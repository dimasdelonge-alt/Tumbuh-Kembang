import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../data/repository.dart';
import '../modules/growth/growth_assessment.dart';
import '../modules/growth/zscore_calculator.dart';
import '../modules/kpsp/developmental_age.dart';
import '../modules/kpsp/developmental_age_service.dart';
import '../modules/kpsp/kpsp_model.dart';
import '../modules/stimulation/stimulation.dart';

/// Satu titik tren Z-score pada suatu kunjungan.
class _GrowthTrendPoint {
  final double ageMonths;
  final double? zWeightForAge;
  final double? zHeightForAge;
  _GrowthTrendPoint({
    required this.ageMonths,
    this.zWeightForAge,
    this.zHeightForAge,
  });
}

/// Satu titik tren KPSP.
class _KpspTrendPoint {
  final DateTime date;
  final double ageMonths;
  final int yesCount;
  final KpspResultCategory category;
  _KpspTrendPoint({
    required this.date,
    required this.ageMonths,
    required this.yesCount,
    required this.category,
  });
}

/// Layar monitoring longitudinal (Modul 14): tren pertumbuhan & perkembangan
/// pasien lintas kunjungan.
class LongitudinalScreen extends StatefulWidget {
  final Patient patient;
  const LongitudinalScreen({super.key, required this.patient});

  @override
  State<LongitudinalScreen> createState() => _LongitudinalScreenState();
}

class _LongitudinalScreenState extends State<LongitudinalScreen> {
  late Future<_LongitudinalData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_LongitudinalData> _load() async {
    final repo = context.read<AppRepository>();

    final growthRows = await repo.growthHistory(widget.patient.id);
    final kpspRows = await repo.kpspHistory(widget.patient.id);

    final growth = <_GrowthTrendPoint>[];
    for (final r in growthRows) {
      final assessment = GrowthAssessment.fromMeasurement(
        birthDate: widget.patient.birthDate,
        examDate: r.exam.examDate,
        gestationalWeeks: widget.patient.gestationalWeeks,
        sex: widget.patient.sex,
        m: r.growth,
      );
      final ageMonths = GrowthAssessment.ageDaysFor(assessment.age) / 30.4375;
      growth.add(_GrowthTrendPoint(
        ageMonths: ageMonths,
        zWeightForAge:
            assessment.byIndicator(GrowthIndicator.weightForAge)?.z.zScore,
        zHeightForAge: assessment
            .byIndicator(GrowthIndicator.lengthHeightForAge)
            ?.z
            .zScore,
      ));
    }

    final kpsp = <_KpspTrendPoint>[];
    for (final r in kpspRows) {
      final age = AgeCalculator.calculate(
        birthDate: widget.patient.birthDate,
        examDate: r.exam.examDate,
        gestationalWeeks: widget.patient.gestationalWeeks,
      );
      kpsp.add(_KpspTrendPoint(
        date: r.exam.examDate,
        ageMonths: age.chronologicalMonths.toDouble(),
        yesCount: r.kpsp.yesCount,
        category: KpspResultCategory.fromCode(r.kpsp.result),
      ));
    }

    // Estimasi usia perkembangan dari seluruh riwayat KPSP (tampilan terkini).
    final devAge = DevelopmentalAgeService.fromHistory(
      birthDate: widget.patient.birthDate,
      gestationalWeeks: widget.patient.gestationalWeeks,
      rows: kpspRows
          .map((r) => KpspHistoryRow(
                examDate: r.exam.examDate,
                formAgeMonths: r.kpsp.formAgeMonths,
                answersJson: r.kpsp.answersJson,
              ))
          .toList(),
    );

    return _LongitudinalData(growth: growth, kpsp: kpsp, devAge: devAge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tren — ${widget.patient.name}')),
      body: FutureBuilder<_LongitudinalData>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snap.data!;
          if (data.growth.isEmpty && data.kpsp.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada data untuk ditampilkan.\n'
                  'Lakukan beberapa pemeriksaan terlebih dulu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (data.growth.isNotEmpty) ...[
                Text('Tren Z-score Pertumbuhan',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                const Text(
                  'Garis 0 = median WHO. Zona aman umumnya -2 sd +2.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                SizedBox(height: 260, child: _GrowthTrendChart(points: data.growth)),
                const SizedBox(height: 24),
              ],
              if (data.kpsp.isNotEmpty) ...[
                Text('Tren Skor KPSP',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                SizedBox(height: 240, child: _KpspTrendChart(points: data.kpsp)),
                const SizedBox(height: 12),
                _KpspTrendTable(points: data.kpsp),
                const SizedBox(height: 24),
              ],
              if (data.devAge != null &&
                  data.devAge!.domains.isNotEmpty) ...[
                Text('Estimasi Usia Perkembangan',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _DevAgeSection(result: data.devAge!),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _LongitudinalData {
  final List<_GrowthTrendPoint> growth;
  final List<_KpspTrendPoint> kpsp;
  final DevelopmentalAgeResult? devAge;
  _LongitudinalData({
    required this.growth,
    required this.kpsp,
    required this.devAge,
  });
}

class _GrowthTrendChart extends StatelessWidget {
  final List<_GrowthTrendPoint> points;
  const _GrowthTrendChart({required this.points});

  @override
  Widget build(BuildContext context) {
    final wfa = <FlSpot>[];
    final hfa = <FlSpot>[];
    for (final p in points) {
      if (p.zWeightForAge != null) {
        wfa.add(FlSpot(p.ageMonths, p.zWeightForAge!));
      }
      if (p.zHeightForAge != null) {
        hfa.add(FlSpot(p.ageMonths, p.zHeightForAge!));
      }
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendDot(Colors.indigo, 'BB/U'),
            const SizedBox(width: 16),
            _legendDot(Colors.teal, 'TB/U'),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: LineChart(
            LineChartData(
              minY: -4,
              maxY: 4,
              extraLinesData: ExtraLinesData(horizontalLines: [
                HorizontalLine(y: 0, color: Colors.green, strokeWidth: 1.5),
                HorizontalLine(
                    y: -2,
                    color: Colors.orange,
                    strokeWidth: 1,
                    dashArray: [6, 4]),
                HorizontalLine(
                    y: 2,
                    color: Colors.orange,
                    strokeWidth: 1,
                    dashArray: [6, 4]),
              ]),
              lineBarsData: [
                if (wfa.isNotEmpty)
                  LineChartBarData(
                    spots: wfa,
                    color: Colors.indigo,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: true),
                  ),
                if (hfa.isNotEmpty)
                  LineChartBarData(
                    spots: hfa,
                    color: Colors.teal,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: true),
                  ),
              ],
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Text('Umur (bulan)'),
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 26,
                    getTitlesWidget: (v, _) => Text(v.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 10)),
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: const Text('Z'),
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 2,
                    reservedSize: 28,
                    getTitlesWidget: (v, _) => Text(v.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 10)),
                  ),
                ),
              ),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _legendDot(Color c, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: c),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _KpspTrendChart extends StatelessWidget {
  final List<_KpspTrendPoint> points;
  const _KpspTrendChart({required this.points});

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    for (final p in points) {
      spots.add(FlSpot(p.ageMonths, p.yesCount.toDouble()));
    }
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 10,
        extraLinesData: ExtraLinesData(horizontalLines: [
          HorizontalLine(
              y: 9, color: Colors.green, strokeWidth: 1, dashArray: [6, 4]),
          HorizontalLine(
              y: 7, color: Colors.orange, strokeWidth: 1, dashArray: [6, 4]),
        ]),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: Colors.deepPurple,
            barWidth: 2.5,
            dotData: const FlDotData(show: true),
          ),
        ],
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            axisNameWidget: const Text('Umur (bulan)'),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26,
              getTitlesWidget: (v, _) => Text(v.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 10)),
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: const Text('Skor "Ya"'),
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 28,
              getTitlesWidget: (v, _) => Text(v.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 10)),
            ),
          ),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }
}

class _KpspTrendTable extends StatelessWidget {
  final List<_KpspTrendPoint> points;
  const _KpspTrendTable({required this.points});

  Color _color(KpspResultCategory c) {
    switch (c) {
      case KpspResultCategory.sesuai:
        return Colors.green.shade600;
      case KpspResultCategory.meragukan:
        return Colors.orange.shade700;
      case KpspResultCategory.penyimpangan:
        return Colors.red.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: points.reversed
          .map((p) => Card(
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: _color(p.category).withValues(alpha: 0.15),
                    child: Text('${p.yesCount}',
                        style: TextStyle(
                            color: _color(p.category),
                            fontWeight: FontWeight.bold)),
                  ),
                  title: Text(AgeCalculator.formatDate(p.date)),
                  subtitle: Text('Usia ${p.ageMonths.toStringAsFixed(0)} bulan'),
                  trailing: Text(p.category.label,
                      style: TextStyle(
                          color: _color(p.category),
                          fontWeight: FontWeight.w600)),
                ),
              ))
          .toList(),
    );
  }
}

class _DevAgeSection extends StatelessWidget {
  final DevelopmentalAgeResult result;
  const _DevAgeSection({required this.result});

  String _label(KpspDomain d) => d.label;

  /// Saran stimulasi berbasis USIA PERKEMBANGAN tiap domain (bukan kronologis).
  Widget _buildStimulation(BuildContext context) {
    final domainAges = <KpspDomain, int?>{
      for (final d in result.domains) d.domain: d.estimatedMonths,
    };
    final suggestions = StimulationMatcher.forDomains(domainAges);
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text('Saran Stimulasi',
            style: Theme.of(context).textTheme.titleSmall),
        const Text(
          'Disesuaikan dengan usia perkembangan tiap bidang, bukan usia '
          'kronologis (SDIDTK Kemenkes, revisi 2022).',
          style: TextStyle(fontSize: 11.5, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        ...suggestions.map((s) => Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline,
                            size: 18, color: Colors.amber.shade800),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${_label(s.domain)} '
                            '(setara ${s.developmentalAgeMonths} bln '
                            '→ stimulasi ${s.band.label})',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ...s.activities.map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ${a.title}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.5)),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(a.howTo,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black54)),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final lag = result.maxLagMonths;
    final low = result.lowestDomain;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usia kronologis saat ini: ${result.chronologicalMonths} bulan',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 8),
        ...result.domains.map((d) => Card(
              child: ListTile(
                dense: true,
                leading: Icon(
                  d.estimatedMonths == null
                      ? Icons.help_outline
                      : Icons.timeline,
                  color: d.estimatedMonths == null
                      ? Colors.grey
                      : Colors.teal.shade700,
                ),
                title: Text(_label(d.domain)),
                subtitle: Text(d.estimatedMonths == null
                    ? 'Belum lulus penuh (dinilai s/d form ${d.highestFormAssessed} bln)'
                    : 'Setara \u2265 ${d.estimatedMonths} bulan'),
                trailing: d.estimatedMonths == null
                    ? null
                    : Text('${d.estimatedMonths} bln',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade700)),
              ),
            )),
        if (low?.estimatedMonths != null && lag != null && lag >= 6)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade300),
            ),
            child: Text(
              'Keterlambatan dominan pada domain ${_label(low!.domain)} '
              '(estimasi ${low.estimatedMonths} bln, tertinggal \u2248 $lag bln '
              'dari usia kronologis).',
              style: TextStyle(fontSize: 12.5, color: Colors.orange.shade900),
            ),
          ),
        _buildStimulation(context),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Catatan metode: estimasi ini adalah batas BAWAH berbasis KPSP — '
            'usia form tertinggi di mana seluruh item suatu domain dijawab '
            '"Ya". Ini estimasi skrining, BUKAN penilaian usia perkembangan '
            'formal (mis. Denver II/Bayley). Akurasi meningkat seiring makin '
            'banyak rentang usia KPSP yang diujikan.',
            style: TextStyle(fontSize: 11.5, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
