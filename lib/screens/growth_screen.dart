import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../data/repository.dart';
import '../modules/growth/growth_assessment.dart';
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
  bool _lying = true;

  List<GrowthIndicatorResult> _results = const [];
  bool _computed = false;

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
  }

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    _head.dispose();
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
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade700),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.amber.shade900),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Usia anak di atas 5 tahun. Indikator BB/U, BB/TB, dan '
                      'LK/U (standar WHO 0–5 tahun) tidak ditampilkan. '
                      'TB/U & IMT/U memakai referensi WHO 5–19 tahun.',
                      style: TextStyle(
                          fontSize: 12.5, color: Colors.amber.shade900),
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
              )),
          if (_results.isNotEmpty) ...[
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Pengukuran'),
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
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengukuran tersimpan')),
    );
    Navigator.of(context).pop();
  }
}

class _ResultCard extends StatelessWidget {
  final GrowthIndicatorResult result;
  final Patient patient;
  final bool measuredLying;
  const _ResultCard({
    required this.result,
    required this.patient,
    required this.measuredLying,
  });

  @override
  Widget build(BuildContext context) {
    final z = result.z;
    final color = result.status.isAlert
        ? (z.zScore.abs() > 3 ? Colors.red.shade600 : Colors.orange.shade700)
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
                  child: Text(z.indicator.label,
                      style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Z = ${z.zRounded}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color)),
                const SizedBox(width: 12),
                Text('P${z.percentile.round()}',
                    style: const TextStyle(color: Colors.grey)),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
