import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../modules/growth/growth_assessment.dart';
import '../modules/growth/nutrition_classifier.dart';
import '../modules/growth/who_growth_data.dart';
import '../modules/growth/zscore_calculator.dart';

class _ChartPatientData {
  final Patient patient;
  final List<({Examination exam, GrowthMeasurement growth})> history;
  _ChartPatientData({required this.patient, required this.history});
}

/// Menampilkan kurva pertumbuhan WHO untuk satu indikator, lengkap dengan
/// garis Z-score referensi (-3, -2, 0, +1/+2/+3) dan garis tren pertumbuhan pasien.
class GrowthChartScreen extends StatelessWidget {
  final GrowthIndicator indicator;
  final String sex;
  final bool measuredLying;

  /// Sumbu-x titik pasien: hari (umur) atau cm (BB/TB).
  final double pointX;

  /// Nilai pengukuran pasien (kg / cm / IMT).
  final double pointValue;

  /// ID pasien untuk memuat riwayat pertumbuhan longitudinal.
  final String? patientId;

  const GrowthChartScreen({
    super.key,
    required this.indicator,
    required this.sex,
    required this.measuredLying,
    required this.pointX,
    required this.pointValue,
    this.patientId,
  });

  bool get _isAgeBased =>
      indicator != GrowthIndicator.weightForLengthHeight;

  Future<_ChartPatientData?> _loadData(BuildContext context) async {
    if (patientId == null) return null;
    final repo = Provider.of<AppRepository>(context, listen: false);
    final patient = await repo.getPatient(patientId!);
    if (patient == null) return null;
    final history = await repo.growthHistory(patientId!);
    return _ChartPatientData(patient: patient, history: history);
  }

  @override
  Widget build(BuildContext context) {
    final table = WhoGrowthData.instance.tableFor(
      indicator: indicator,
      sex: sex,
      measuredLying: measuredLying,
    );

    if (table == null || table.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Kurva ${indicator.code}')),
        body: const Center(child: Text('Data kurva tidak tersedia')),
      );
    }

    if (patientId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Kurva ${indicator.code}')),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8, 24, 24, 16),
          child: _buildChart(context, table, null),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Kurva ${indicator.code}')),
      body: FutureBuilder<_ChartPatientData?>(
        future: _loadData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 24, 24, 16),
            child: _buildChart(context, table, data),
          );
        },
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<LmsPoint> table, _ChartPatientData? patientData) {
    final zLines = NutritionClassifier.referenceLines(indicator);

    // Konversi sumbu-x ke satuan tampilan: bulan (umur) atau cm.
    double toDisplayX(double x) => _isAgeBased ? x / 30.4375 : x;

    final lineBars = <LineChartBarData>[];
    for (final z in zLines) {
      final spots = <FlSpot>[];
      for (final p in table) {
        final v = ZScoreCalculator.valueAtZ(p, z);
        spots.add(FlSpot(toDisplayX(p.x), v));
      }
      final isMedian = z == 0;
      lineBars.add(LineChartBarData(
        spots: spots,
        isCurved: true,
        barWidth: isMedian ? 2.2 : 1.2,
        color: _zColor(z),
        dotData: const FlDotData(show: false),
      ));
    }

    // Garis imajiner riwayat pasien & titik-titik pengukurannya.
    if (patientData != null) {
      final spots = <FlSpot>[];
      for (final r in patientData.history) {
        final assessment = GrowthAssessment.fromMeasurement(
          birthDate: patientData.patient.birthDate,
          examDate: r.exam.examDate,
          gestationalWeeks: patientData.patient.gestationalWeeks,
          sex: patientData.patient.sex,
          m: r.growth,
        );
        final res = assessment.byIndicator(indicator);
        if (res != null) {
          spots.add(FlSpot(toDisplayX(res.chartX), res.value));
        }
      }

      // Tambahkan titik saat ini jika belum terdaftar
      final currentSpot = FlSpot(toDisplayX(pointX), pointValue);
      final exists = spots.any((s) => (s.x - currentSpot.x).abs() < 0.01);
      if (!exists) {
        spots.add(currentSpot);
      }

      // Urutkan titik agar garis ditarik secara kronologis
      spots.sort((a, b) => a.x.compareTo(b.x));

      if (spots.isNotEmpty) {
        lineBars.add(LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2.0,
          color: Colors.red.shade700,
          isStrokeCapRound: true,
          dashArray: [4, 4], // Garis putus-putus (imajiner)
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              final isCurrentPoint = (spot.x - toDisplayX(pointX)).abs() < 0.01;
              return FlDotCirclePainter(
                radius: isCurrentPoint ? 5 : 3.5,
                color: isCurrentPoint ? Colors.red : Colors.red.shade700,
                strokeWidth: isCurrentPoint ? 2 : 1,
                strokeColor: Colors.white,
              );
            },
          ),
        ));
      }
    } else {
      // Titik pasien tunggal.
      final px = toDisplayX(pointX);
      lineBars.add(LineChartBarData(
        spots: [FlSpot(px, pointValue)],
        barWidth: 0,
        color: Colors.black,
        dotData: FlDotData(
          show: true,
          getDotPainter: (s, _, __, ___) => FlDotCirclePainter(
            radius: 5,
            color: Colors.red,
            strokeWidth: 2,
            strokeColor: Colors.white,
          ),
        ),
      ));
    }

    final xAxisLabel = _isAgeBased ? 'Umur (bulan)' : 'Panjang/Tinggi (cm)';

    return Column(
      children: [
        _legend(),
        const SizedBox(height: 12),
        Expanded(
          child: LineChart(
            LineChartData(
              lineBarsData: lineBars,
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  axisNameWidget: Text(xAxisLabel),
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (v, meta) => Text(
                      v.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(indicator.code),
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (v, meta) => Text(
                      v.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: true),
              lineTouchData: const LineTouchData(enabled: false),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Garis putus-putus merah = tren pertumbuhan pasien',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _legend() {
    final zLines = NutritionClassifier.referenceLines(indicator);
    return Wrap(
      spacing: 12,
      children: zLines
          .map((z) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 16, height: 3, color: _zColor(z)),
                  const SizedBox(width: 4),
                  Text(z == 0 ? 'Median' : 'SD ${z > 0 ? '+$z' : z}',
                      style: const TextStyle(fontSize: 11)),
                ],
              ))
          .toList(),
    );
  }

  Color _zColor(double z) {
    if (z == 0) return Colors.green.shade700;
    if (z.abs() == 1) return Colors.lightGreen;
    if (z.abs() == 2) return Colors.orange;
    return Colors.red;
  }
}
