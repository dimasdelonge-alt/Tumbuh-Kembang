import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../data/repository.dart';
import '../modules/growth/growth_assessment.dart';
import '../modules/growth/nutrition_classifier.dart';
import '../modules/growth/zscore_calculator.dart';
import '../modules/cdc/cdc_calculator.dart';
import '../modules/cdc/cdc_screen.dart';
import '../modules/nutrition/nutrition_calculator.dart';
import '../modules/nutrition/nutrition_module_screen.dart';
import 'growth_chart.dart';

/// Layar input antropometri + hasil Z-score (Modul 3).
class GrowthScreen extends StatefulWidget {
  final Patient patient;
  final String examinationId;
  final DateTime examDate;
  const GrowthScreen({
    super.key,
    required this.patient,
    required this.examinationId,
    required this.examDate,
  });

  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _head = TextEditingController();
  final _fatherHeight = TextEditingController();
  final _motherHeight = TextEditingController();
  bool _lying = true;

  List<GrowthIndicatorResult> _results = const [];
  bool _computed = false;
  TpgResult? _tpg;
  RealtimeTpgResult? _realtimeTpg;

  AgeResult get _age => AgeCalculator.calculate(
        birthDate: widget.patient.birthDate,
        examDate: widget.examDate,
        gestationalWeeks: widget.patient.gestationalWeeks,
      );

  @override
  void initState() {
    super.initState();
    // Default cara ukur: berbaring bila usia < 24 bulan.
    _lying = _age.chronologicalMonths < 24;
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final repo = context.read<AppRepository>();
    final g = await repo.getGrowthForExam(widget.examinationId);
    if (g != null && mounted) {
      _weight.text = g.weightKg?.toString() ?? '';
      _height.text = g.heightCm?.toString() ?? '';
      _head.text = g.headCircumferenceCm?.toString() ?? '';
      _lying = g.measuredLying;
      _compute();
    }
    _initTPG();
  }

  void _initTPG() {
    if (widget.patient.fatherHeightCm != null && widget.patient.fatherHeightCm! > 0) {
      _fatherHeight.text = widget.patient.fatherHeightCm!.toStringAsFixed(1);
    }
    if (widget.patient.motherHeightCm != null && widget.patient.motherHeightCm! > 0) {
      _motherHeight.text = widget.patient.motherHeightCm!.toStringAsFixed(1);
    }
    _recalculateTPG();
  }

  void _recalculateTPG() {
    final fH = double.tryParse(_fatherHeight.text);
    final mH = double.tryParse(_motherHeight.text);
    final currentH = double.tryParse(_height.text);

    final tpg = CdcCalculator.calculateTPG(
      fatherHeightCm: fH,
      motherHeightCm: mH,
      sex: widget.patient.sex,
    );

    final realtime = CdcCalculator.calculateRealtimeTPG(
      currentHeightCm: currentH,
      ageMonths: _age.chronologicalMonths,
      tpg: tpg,
    );

    setState(() {
      _tpg = tpg;
      _realtimeTpg = realtime;
    });
  }

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    _head.dispose();
    _fatherHeight.dispose();
    _motherHeight.dispose();
    super.dispose();
  }

  void _compute() {
    final w = double.tryParse(_weight.text.replaceAll(',', '.'));
    final h = double.tryParse(_height.text.replaceAll(',', '.'));
    final hc = double.tryParse(_head.text.replaceAll(',', '.'));

    final assessment = GrowthAssessment.compute(
      birthDate: widget.patient.birthDate,
      examDate: widget.examDate,
      gestationalWeeks: widget.patient.gestationalWeeks,
      sex: widget.patient.sex,
      weightKg: w,
      heightCm: h,
      headCircumferenceCm: hc,
      measuredLying: _lying,
    );

    setState(() {
      _results = assessment.results;
      _computed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final age = _age;
    return Scaffold(
      appBar: AppBar(title: const Text('Pertumbuhan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Text(
            'Usia: ${age.chronologicalLabel}'
            '${age.correctionApplied ? ' (koreksi: ${age.correctedLabel})' : ''}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weight,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      labelText: 'Berat (kg)',
                      prefixIcon: Icon(Icons.monitor_weight)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _height,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      labelText: 'Tinggi (cm)',
                      prefixIcon: Icon(Icons.height)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _head,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
                labelText: 'Lingkar kepala (cm) — opsional',
                prefixIcon: Icon(Icons.circle_outlined)),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Tinggi diukur berbaring (telentang)'),
            subtitle: const Text('Aktif untuk bayi < 2 tahun'),
            value: _lying,
            onChanged: (v) => setState(() => _lying = v),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _compute,
            icon: const Icon(Icons.calculate),
            label: const Text('Hitung Z-score'),
          ),
          const SizedBox(height: 20),
          if (_age.chronologicalMonths > 60)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade900),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Usia anak di atas 5 tahun. Indikator BB/U dan LK/U '
                      '(standar WHO 0–5 tahun) tidak ditampilkan. '
                      'TB/U & IMT/U memakai referensi WHO 5–19 tahun. '
                      'BB/TB memakai rumus Waterlow (CDC 2000).',
                      style: TextStyle(
                          fontSize: 12.5, color: Colors.blue.shade900),
                    ),
                  ),
                ],
              ),
            ),
          if (_computed && _results.isEmpty)
            const Text('Masukkan minimal satu pengukuran.',
                style: TextStyle(color: Colors.grey)),
          ..._results.map((r) => _ResultCard(
                result: r,
                patient: widget.patient,
                measuredLying: _lying,
                ageMonths: _age.chronologicalMonths,
                heightCm: double.tryParse(_height.text.replaceAll(',', '.')),
              )),
          _buildTpgSection(),
          _buildNutritionSection(),
          if (_results.isNotEmpty) ...[
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Pengukuran & TPG'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _save() async {
    final repo = context.read<AppRepository>();
    double? p(TextEditingController c) =>
        double.tryParse(c.text.replaceAll(',', '.'));
    await repo.upsertGrowth(GrowthMeasurementsCompanion.insert(
      examinationId: widget.examinationId,
      weightKg: d.Value(p(_weight)),
      heightCm: d.Value(p(_height)),
      headCircumferenceCm: d.Value(p(_head)),
      measuredLying: d.Value(_lying),
    ));

    final fH = p(_fatherHeight);
    final mH = p(_motherHeight);
    if (fH != widget.patient.fatherHeightCm || mH != widget.patient.motherHeightCm) {
      final updatedPatient = widget.patient.copyWith(
        fatherHeightCm: d.Value(fH),
        motherHeightCm: d.Value(mH),
      );
      await repo.updatePatient(updatedPatient);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengukuran & Data TPG tersimpan')),
    );
  }

  Widget _buildTpgSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.family_restroom, color: Colors.teal.shade800),
                const SizedBox(width: 8),
                Text(
                  'Sub-Modul: Tinggi Potensi Genetik (TPG)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.teal.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Hitung tinggi potensi genetik dewasa & evaluasi real-time tinggi badan anak saat ini.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _fatherHeight,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'TB Ayah (cm)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    onChanged: (_) => _recalculateTPG(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _motherHeight,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'TB Ibu (cm)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    onChanged: (_) => _recalculateTPG(),
                  ),
                ),
              ],
            ),
            if (_tpg != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _realtimeTpg?.isBelow ?? false ? Colors.red.shade50 : Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _realtimeTpg?.isBelow ?? false ? Colors.red.shade300 : Colors.teal.shade300,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TPG Dewasa (18\u201320 Thn): ${_tpg!.label}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.teal.shade900,
                      ),
                    ),
                    if (_realtimeTpg != null) ...[
                      const SizedBox(height: 4),
                      // Untuk anak < 2 tahun, hanya tampilkan pesan informatif
                      // (tanpa rangeLabel yang salah karena CDC belum berlaku)
                      if (_age.chronologicalMonths >= 24) ...[
                        Text(
                          'Rentang Ideal Usia Ini (${(_age.chronologicalMonths / 12.0).toStringAsFixed(1)} Thn): ${_realtimeTpg!.rangeLabel}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        _realtimeTpg!.statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _realtimeTpg!.isBelow
                              ? Colors.red.shade900
                              : (_realtimeTpg!.isAbove ? Colors.orange.shade900 : Colors.blue.shade900),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Tombol CDC chart hanya untuk usia >= 2 tahun
              if (_age.chronologicalMonths >= 24) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.show_chart, size: 16),
                    label: const Text('Lihat Kurva CDC 2000 & Trajektori TPG'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CdcScreen(
                            patient: widget.patient,
                            examination: Examination(
                              id: widget.examinationId,
                              patientId: widget.patient.id,
                              examDate: widget.examDate,
                              createdAt: DateTime.now(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionSection() {
    final w = double.tryParse(_weight.text.replaceAll(',', '.'));
    final h = double.tryParse(_height.text.replaceAll(',', '.'));

    if (w == null || h == null || w <= 0 || h <= 0 || !_computed) {
      return const SizedBox.shrink();
    }

    // Ekstrak status gizi WHO BB/TB dari hasil GrowthAssessment.
    // Ini adalah standar Kemenkes RI 2010 yang konsisten dengan tampilan antropometri.
    // Untuk anak > 5 tahun, weightForLengthHeight di-_results menggunakan Waterlow
    // (growth_assessment.dart), sehingga tetap konsisten di semua usia.
    final whoStatus = _results
        .where((r) => r.indicator == GrowthIndicator.weightForLengthHeight)
        .map((r) => r.status)
        .whereType<NutritionStatus>()
        .firstOrNull;

    final nutrition = NutritionCalculator.calculate(
      weightKg: w,
      heightCm: h,
      ageMonths: _age.chronologicalMonths,
      sex: widget.patient.sex,
      whoNutritionStatus: whoStatus,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant, color: Colors.orange.shade800),
                const SizedBox(width: 8),
                Text(
                  'Sub-Modul: Pemenuhan Nutrisi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.orange.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Kebutuhan nutrisi harian berdasarkan RDA × BB Ideal.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: nutrition.needsIntervention
                    ? Colors.red.shade50
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: nutrition.needsIntervention
                      ? Colors.red.shade300
                      : Colors.orange.shade300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _nutritionKvRow(
                    Icons.local_fire_department,
                    'Energi Target',
                    nutrition.energyLabel,
                    Colors.red.shade700,
                  ),
                  _nutritionKvRow(
                    Icons.egg,
                    'Protein Target',
                    nutrition.proteinLabel,
                    Colors.brown.shade700,
                  ),
                  _nutritionKvRow(
                    Icons.water_drop,
                    'Cairan Harian',
                    nutrition.fluidLabel,
                    Colors.blue.shade700,
                  ),
                  _nutritionKvRow(
                    Icons.monitor_weight,
                    'BB Ideal',
                    nutrition.idealWeightLabel,
                    Colors.teal.shade700,
                  ),
                ],
              ),
            ),
            if (nutrition.needsIntervention) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.red.shade800, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        nutrition.interventionAdvice,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.restaurant_menu, size: 16),
                label: const Text('Lihat Detail Asuhan Nutrisi'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => NutritionModuleScreen(
                        initialPatient: widget.patient,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nutritionKvRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 11)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final GrowthIndicatorResult result;
  final Patient patient;
  final bool measuredLying;
  final int ageMonths;
  final double? heightCm;

  const _ResultCard({
    required this.result,
    required this.patient,
    required this.measuredLying,
    required this.ageMonths,
    this.heightCm,
  });

  @override
  Widget build(BuildContext context) {
    final isWaterlow = result.indicator == GrowthIndicator.weightForLengthHeight && ageMonths > 60;
    final z = result.z;
    final color = result.status.isAlert
        ? (isWaterlow
            ? (z.zScore < 70 || z.zScore > 120 ? Colors.red.shade600 : Colors.orange.shade700)
            : (z.zScore.abs() > 3 ? Colors.red.shade600 : Colors.orange.shade700))
        : Colors.green.shade600;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(z.indicator.code,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: color)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                      isWaterlow
                          ? '${z.indicator.label} (Waterlow)'
                          : z.indicator.label,
                      style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                    isWaterlow
                        ? 'BBI = ${z.median.toStringAsFixed(1)} kg\nPersentase = ${z.zScore.toStringAsFixed(1)}%'
                        : 'Z = ${z.zRounded}',
                    style: TextStyle(
                        fontSize: isWaterlow ? 15 : 18,
                        fontWeight: FontWeight.bold,
                        color: color)),
                if (!isWaterlow) ...[
                  const SizedBox(width: 12),
                  Text('P${z.percentile.round()}',
                      style: const TextStyle(color: Colors.grey)),
                ],
                const Spacer(),
                Flexible(
                  child: Text(
                    result.status.label,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: color),
                  ),
                ),
              ],
            ),
            // --- Nilai referensi -2SD, Median, +2SD ---
            if (!isWaterlow) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _refValue('-2SD', z.sd2neg, result.indicator),
                    _refValue('Median', z.median, result.indicator, heightCm: heightCm),
                    _refValue('+2SD', z.sd2pos, result.indicator),
                  ],
                ),
              ),
            ],
            if (!isWaterlow) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(Icons.show_chart, size: 18),
                label: const Text('Lihat kurva'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GrowthChartScreen(
                      indicator: z.indicator,
                      sex: patient.sex,
                      measuredLying: measuredLying,
                      pointX: result.chartX,
                      pointValue: result.value,
                      patientId: patient.id,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _refValue(String label, double value, GrowthIndicator indicator, {double? heightCm}) {
    final unit = _unitFor(indicator);
    final isBmiMedian = indicator == GrowthIndicator.bmiForAge && label == 'Median' && heightCm != null;
    final bbiStr = isBmiMedian ? '\n(BBI: ${(value * (heightCm / 100) * (heightCm / 100)).toStringAsFixed(1)} kg)' : '';
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: '${value.toStringAsFixed(1)}${unit.isEmpty ? "" : " $unit"}',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
              if (isBmiMedian)
                TextSpan(
                  text: bbiStr,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo.shade700),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _unitFor(GrowthIndicator ind) {
    switch (ind) {
      case GrowthIndicator.weightForAge:
      case GrowthIndicator.weightForLengthHeight:
        return 'kg';
      case GrowthIndicator.lengthHeightForAge:
      case GrowthIndicator.headCircumferenceForAge:
        return 'cm';
      case GrowthIndicator.bmiForAge:
        return '';
    }
  }
}
