import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../modules/autism/cars.dart';

/// Layar penilaian CARS (Childhood Autism Rating Scale).
class CarsScreen extends StatefulWidget {
  final String examinationId;
  const CarsScreen({super.key, required this.examinationId});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  final Map<int, double> _values = {};

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final repo = context.read<AppRepository>();
    final existing = await repo.getCarsForExam(widget.examinationId);
    if (existing != null && mounted) {
      try {
        final m = jsonDecode(existing.answersJson) as Map<String, dynamic>;
        setState(() {
          m.forEach((k, v) {
            final n = int.tryParse(k);
            if (n != null && v is num) _values[n] = v.toDouble();
          });
        });
      } catch (_) {}
    }
  }

  bool get _complete => _values.length == carsAreas.length;

  double get _total =>
      _values.values.fold(0.0, (s, v) => s + v);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CARS (Skrining Autisme)')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: _complete ? _save : null,
            icon: const Icon(Icons.calculate),
            label: Text(_complete
                ? 'Hitung & Simpan (total ${_fmt(_total)})'
                : 'Lengkapi (${_values.length}/${carsAreas.length})'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
        children: [
          const Text(
            'Nilai tiap area 1 (sesuai usia) sampai 4 (abnormal berat); '
            'boleh nilai tengah 0,5. Total 15-60.',
            style: TextStyle(color: Colors.grey),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'CARS berhak cipta (Schopler dkk., WPS). Dipakai untuk skrining '
              'klinis di dalam praktek sendiri.',
              style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey),
            ),
          ),
          const SizedBox(height: 12),
          ...carsAreas.map(_areaCard),
        ],
      ),
    );
  }

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  String _anchorFor(CarsArea a, double v) {
    if (v < 1.75) return a.anchor1;
    if (v < 2.75) return a.anchor2;
    if (v < 3.75) return a.anchor3;
    return a.anchor4;
  }

  Widget _areaCard(CarsArea area) {
    final v = _values[area.number];
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    radius: 14,
                    child: Text('${area.number}',
                        style: const TextStyle(fontSize: 12))),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(area.title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                if (v != null)
                  Text(_fmt(v),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700)),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: CarsScorer.validValues.map((val) {
                final selected = v == val;
                return ChoiceChip(
                  label: Text(_fmt(val)),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _values[area.number] = val),
                );
              }).toList(),
            ),
            if (v != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(_anchorFor(area, v),
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54)),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final interp = CarsScorer.interpret(_values);
    final repo = context.read<AppRepository>();
    await repo.upsertCars(CarsResultsCompanion.insert(
      examinationId: widget.examinationId,
      totalScore: interp.totalScore,
      category: interp.category.severity,
      answersJson:
          jsonEncode(_values.map((k, v) => MapEntry(k.toString(), v))),
    ));
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (_) => _CarsResultDialog(interp: interp),
    );
    if (mounted) Navigator.of(context).pop();
  }
}

class _CarsResultDialog extends StatelessWidget {
  final CarsInterpretation interp;
  const _CarsResultDialog({required this.interp});

  Color get _color {
    switch (interp.category) {
      case CarsCategory.nonAutistic:
        return Colors.green.shade600;
      case CarsCategory.mildModerate:
        return Colors.orange.shade700;
      case CarsCategory.severe:
        return Colors.red.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.assignment_turned_in, color: _color),
          const SizedBox(width: 8),
          const Text('Hasil CARS'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Skor total: ${interp.totalScore.toStringAsFixed(1)} '
                    '(rentang 15-60)'),
                Text(
                  interp.category.label.toUpperCase(),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _color),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text('Rekomendasi:',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(interp.recommendation, style: const TextStyle(fontSize: 13)),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Selesai'),
        ),
      ],
    );
  }
}
