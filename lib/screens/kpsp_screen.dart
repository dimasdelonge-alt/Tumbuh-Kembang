import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../data/repository.dart';
import '../modules/kpsp/kpsp_model.dart';
import '../reports/pdf_report_service.dart';

/// Layar pemeriksaan KPSP (Modul 4).
class KpspScreen extends StatefulWidget {
  final Patient patient;
  final String examinationId;
  final AgeResult age;
  const KpspScreen({
    super.key,
    required this.patient,
    required this.examinationId,
    required this.age,
  });

  @override
  State<KpspScreen> createState() => _KpspScreenState();
}

class _KpspScreenState extends State<KpspScreen> {
  late int _formAge;
  final Map<int, bool> _answers = {};

  /// Usia (bulan) untuk memilih form: pakai usia koreksi bila berlaku.
  int get _screeningMonths => widget.age.correctionApplied
      ? widget.age.correctedMonths
      : widget.age.chronologicalMonths;

  @override
  void initState() {
    super.initState();
    _formAge = KpspScorer.nearestFormAge(_screeningMonths);
  }

  KpspForm? get _form => KpspData.form(_formAge);

  @override
  Widget build(BuildContext context) {
    final form = _form;
    return Scaffold(
      appBar: AppBar(title: const Text('KPSP')),
      body: form == null
          ? const Center(child: Text('Form KPSP tidak tersedia'))
          : Column(
              children: [
                _header(context),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
                    itemCount: form.questions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) =>
                        _questionCard(form.questions[i]),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: form == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: FilledButton.icon(
                  onPressed: _answers.length == form.total ? _save : null,
                  icon: const Icon(Icons.calculate),
                  label: Text(
                      'Hitung & Simpan (${_answers.length}/${form.total})'),
                ),
              ),
            ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Form KPSP usia $_formAge bulan',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Ganti'),
                onPressed: _pickForm,
              ),
            ],
          ),
          Text(
            'Usia skrining: $_screeningMonths bulan'
            '${widget.age.correctionApplied ? ' (koreksi)' : ''}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _questionCard(KpspQuestion q) {
    final ans = _answers[q.number];
    return Card(
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
                  child: Text('${q.number}',
                      style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(q.text)),
              ],
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(q.domain.label,
                  style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.primary)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _answerButton('Ya', true, ans,
                      Colors.green.shade600, q.number),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _answerButton('Tidak', false, ans,
                      Colors.red.shade600, q.number),
                ),
              ],
            ),
          ],
        ),
      ),
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

  Future<void> _pickForm() async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      builder: (_) => ListView(
        children: KpspData.availableAges
            .map((a) => ListTile(
                  title: Text('Usia $a bulan'),
                  trailing: a == _formAge ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.pop(context, a),
                ))
            .toList(),
      ),
    );
    if (picked != null && picked != _formAge) {
      setState(() {
        _formAge = picked;
        _answers.clear();
      });
    }
  }

  Future<void> _save() async {
    final form = _form!;
    final interp = KpspScorer.interpret(form, _answers);
    final repo = context.read<AppRepository>();
    await repo.upsertKpsp(KpspResultsCompanion.insert(
      examinationId: widget.examinationId,
      formAgeMonths: _formAge,
      yesCount: interp.yesCount,
      totalQuestions: interp.total,
      result: interp.category.code,
      answersJson: jsonEncode(
          _answers.map((k, v) => MapEntry(k.toString(), v))),
    ));
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (_) => _ResultDialog(
        patient: widget.patient,
        screeningMonths: _screeningMonths,
        interp: interp,
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }
}

class _ResultDialog extends StatelessWidget {
  final Patient patient;
  final int screeningMonths;
  final KpspInterpretation interp;
  const _ResultDialog({
    super.key,
    required this.patient,
    required this.screeningMonths,
    required this.interp,
  });

  Color get _color {
    switch (interp.category) {
      case KpspResultCategory.sesuai:
        return Colors.green.shade600;
      case KpspResultCategory.meragukan:
        return Colors.orange.shade700;
      case KpspResultCategory.penyimpangan:
        return Colors.red.shade600;
    }
  }

  void _printStimulationPdf(BuildContext context, [KpspDomain? domain]) {
    PdfReportService.generateAndPrintStimulation(
      patient: patient,
      ageMonths: screeningMonths,
      interp: interp,
      filterDomain: domain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.assignment_turned_in, color: _color),
          const SizedBox(width: 8),
          const Text('Hasil KPSP'),
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
                  Text('Skor: ${interp.yesCount} dari ${interp.total} "Ya"'),
                  Text(
                    interp.category.label.toUpperCase(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _color),
                  ),
                ],
              ),
            ),
            if (interp.failedByDomain.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Item belum tercapai per domain:',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              ...interp.failedByDomain.entries.map((e) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        '• ${e.key.label}: no. ${e.value.join(', ')}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf, size: 20, color: Colors.teal),
                      tooltip: 'Cetak Stimulasi ${e.key.label}',
                      onPressed: () => _printStimulationPdf(context, e.key),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf, size: 16),
                  label: const Text('Cetak Semua Stimulasi Kurang'),
                  onPressed: () => _printStimulationPdf(context),
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf, size: 16),
                  label: const Text('Cetak Panduan Stimulasi Usia Di Atasnya'),
                  onPressed: () => _printStimulationPdf(context),
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Text('Rekomendasi:',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(interp.recommendation, style: const TextStyle(fontSize: 13)),
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
