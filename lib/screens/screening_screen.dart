import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../modules/screening/instrument.dart';

/// Layar pengisian instrumen skrining generik (KMME, M-CHAT-R, GPPH, dll).
class ScreeningScreen extends StatefulWidget {
  final ScreeningInstrument instrument;
  final String examinationId;

  /// Usia anak (bulan) untuk validasi rentang; null jika tidak ingin validasi.
  final int? ageMonths;

  const ScreeningScreen({
    super.key,
    required this.instrument,
    required this.examinationId,
    this.ageMonths,
  });

  @override
  State<ScreeningScreen> createState() => _ScreeningScreenState();
}

class _ScreeningScreenState extends State<ScreeningScreen> {
  // Jawaban biner (Ya/Tidak) untuk instrumen ResponseType.binary.
  final Map<int, bool> _answers = {};
  // Jawaban skala 0-3 untuk instrumen ResponseType.likert4.
  final Map<int, int> _likert = {};
  // Penilai terpilih (untuk instrumen dengan cut-off bergantung penilai).
  String? _rater;

  bool get _isLikert =>
      widget.instrument.responseType == ResponseType.likert4;

  bool get _needsRater => widget.instrument.hasRaterSelection;

  int get _answeredCount =>
      _isLikert ? _likert.length : _answers.length;

  bool get _canSave =>
      _answeredCount == widget.instrument.totalItems &&
      (!_needsRater || _rater != null);

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final repo = context.read<AppRepository>();
    final existing =
        await repo.getScreening(widget.examinationId, widget.instrument.id);
    if (existing != null && mounted) {
      try {
        final m = jsonDecode(existing.answersJson) as Map<String, dynamic>;
        setState(() {
          // variantLabel menyimpan penilai untuk instrumen ber-rater.
          if (_needsRater &&
              widget.instrument.raterOptions.contains(existing.variantLabel)) {
            _rater = existing.variantLabel;
          }
          m.forEach((k, v) {
            final n = int.tryParse(k);
            if (n == null) return;
            if (_isLikert && v is int) {
              _likert[n] = v;
            } else if (_isLikert && v is num) {
              _likert[n] = v.toInt();
            } else if (!_isLikert && v is bool) {
              _answers[n] = v;
            }
          });
        });
      } catch (_) {}
    }
  }

  bool get _ageWarning {
    final a = widget.ageMonths;
    if (a == null) return false;
    return a < widget.instrument.minAgeMonths ||
        a > widget.instrument.maxAgeMonths;
  }

  @override
  Widget build(BuildContext context) {
    final inst = widget.instrument;
    return Scaffold(
      appBar: AppBar(title: Text(inst.displayTitle)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: _canSave ? _save : null,
            icon: const Icon(Icons.calculate),
            label: Text(
                'Hitung & Simpan ($_answeredCount/${inst.totalItems})'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
        children: [
          Text(inst.shortDescription,
              style: const TextStyle(color: Colors.grey)),
          if (_needsRater)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Penilai (menentukan ambang skor):',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: inst.raterOptions.map((r) {
                      final cut = inst.raterCutoffs?[r];
                      return ChoiceChip(
                        label: Text(
                            cut != null ? '$r (≥$cut)' : r),
                        selected: _rater == r,
                        onSelected: (_) => setState(() => _rater = r),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          if (_ageWarning)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade700),
              ),
              child: Text(
                'Catatan: usia anak di luar rentang baku instrumen ini '
                '(${inst.minAgeMonths}-${inst.maxAgeMonths} bulan). '
                'Interpretasi dapat kurang akurat.',
                style: TextStyle(fontSize: 12.5, color: Colors.amber.shade900),
              ),
            ),
          if (inst.copyrightNotice != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(inst.copyrightNotice!,
                  style: const TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey)),
            ),
          const SizedBox(height: 12),
          ...inst.items.map(_itemCard),
        ],
      ),
    );
  }

  Widget _itemCard(ScreeningItem item) {
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
                  child: Text('${item.number}',
                      style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(item.text)),
              ],
            ),
            const SizedBox(height: 8),
            if (_isLikert) _likertRow(item.number) else _binaryRow(item.number),
          ],
        ),
      ),
    );
  }

  Widget _binaryRow(int number) {
    final ans = _answers[number];
    return Row(
      children: [
        Expanded(
          child: _answerButton(
              'Ya', true, ans, Colors.blueGrey.shade600, number),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _answerButton(
              'Tidak', false, ans, Colors.blueGrey.shade600, number),
        ),
      ],
    );
  }

  Widget _likertRow(int number) {
    final current = _likert[number];
    return Row(
      children: List.generate(4, (v) {
        final selected = current == v;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: v < 3 ? 6 : 0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                backgroundColor:
                    selected ? Colors.indigo.shade600 : null,
                foregroundColor:
                    selected ? Colors.white : Colors.indigo.shade700,
                side: BorderSide(color: Colors.indigo.shade300),
              ),
              onPressed: () => setState(() => _likert[number] = v),
              child: Text('$v', style: const TextStyle(fontSize: 16)),
            ),
          ),
        );
      }),
    );
  }

  Widget _answerButton(
      String label, bool value, bool? current, Color color, int number) {
    final selected = current == value;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? color : null,
        foregroundColor: selected ? Colors.white : color,
        side: BorderSide(color: color),
      ),
      onPressed: () => setState(() => _answers[number] = value),
      child: Text(label),
    );
  }

  Future<void> _save() async {
    final inst = widget.instrument;
    final interp = _isLikert
        ? ScreeningScorer.interpretLikert(inst, _likert, rater: _rater)
        : ScreeningScorer.interpret(inst, _answers);
    final answersMap = _isLikert
        ? _likert.map((k, v) => MapEntry(k.toString(), v))
        : _answers.map((k, v) => MapEntry(k.toString(), v));
    final repo = context.read<AppRepository>();
    // Untuk instrumen ber-rater, simpan penilai di variantLabel; selain itu
    // simpan varian instrumen (mis. band usia TDD).
    final variant = _needsRater ? _rater : inst.variantLabel;
    await repo.upsertScreening(ScreeningResultsCompanion.insert(
      examinationId: widget.examinationId,
      instrumentId: inst.id,
      score: interp.score,
      totalItems: interp.total,
      riskLevel: interp.level.severity,
      answersJson: jsonEncode(answersMap),
      variantLabel: Value(variant),
    ));
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (_) => _ResultDialog(instrument: inst, interp: interp),
    );
    if (mounted) Navigator.of(context).pop();
  }
}

class _ResultDialog extends StatelessWidget {
  final ScreeningInstrument instrument;
  final ScreeningInterpretation interp;
  const _ResultDialog({required this.instrument, required this.interp});

  Color get _color {
    switch (interp.level) {
      case RiskLevel.low:
        return Colors.green.shade600;
      case RiskLevel.medium:
        return Colors.orange.shade700;
      case RiskLevel.high:
        return Colors.red.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final band = interp.band;
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.assignment_turned_in, color: _color),
          const SizedBox(width: 8),
          Expanded(child: Text('Hasil ${instrument.displayTitle}')),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
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
                  Text('Skor: ${interp.score} dari ${interp.total}'),
                  Text(
                    interp.level.label.toUpperCase(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _color),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(band.interpretation,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('Rekomendasi:',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(band.recommendation, style: const TextStyle(fontSize: 13)),
            if (interp.flaggedItems.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Item terjawab berisiko: no. ${interp.flaggedItems.join(', ')}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ],
        ),
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
