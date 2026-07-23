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

  // ---- Regression state ----
  bool _inRegression = false;
  int _regFormAge = 0;
  Map<int, bool> _regAnswers = {};
  Set<KpspDomain> _pendingDomains = {};
  final Map<KpspDomain, int> _devAges = {};
  final List<Map<String, dynamic>> _regEntries = [];
  KpspInterpretation? _initialInterp;

  int get _screeningMonths => widget.age.correctionApplied
      ? widget.age.correctedMonths
      : widget.age.chronologicalMonths;

  @override
  void initState() {
    super.initState();
    _formAge = KpspScorer.nearestFormAge(_screeningMonths);
  }

  KpspForm? get _form => KpspData.form(_formAge);

  // Questions visible to the user right now.
  List<KpspQuestion> get _visibleQs {
    if (!_inRegression) return _form?.questions ?? [];
    final f = KpspData.form(_regFormAge);
    if (f == null) return [];
    return f.questions.where((q) => _pendingDomains.contains(q.domain)).toList();
  }

  Map<int, bool> get _activeAnswers => _inRegression ? _regAnswers : _answers;

  // ======================= BUILD =======================

  @override
  Widget build(BuildContext context) {
    final qs = _visibleQs;
    final hasForm = _inRegression
        ? KpspData.form(_regFormAge) != null
        : _form != null;

    return Scaffold(
      appBar: AppBar(title: Text(_inRegression ? 'Regresi KPSP' : 'KPSP')),
      body: !hasForm
          ? const Center(child: Text('Form KPSP tidak tersedia'))
          : Column(
              children: [
                _buildHeader(context),
                if (_inRegression && _devAges.isNotEmpty) _buildResolvedBar(),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
                    itemCount: qs.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => _questionCard(qs[i]),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: !hasForm
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _inRegression ? _regButton(qs) : _normalButton(),
              ),
            ),
    );
  }

  // ======================= HEADER =======================

  Widget _buildHeader(BuildContext context) {
    if (_inRegression) {
      return Container(
        width: double.infinity,
        color: Colors.orange.shade50,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.replay, size: 18, color: Colors.orange.shade800),
              const SizedBox(width: 6),
              Text('Regresi — Form KPSP usia $_regFormAge bulan',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900)),
            ]),
            const SizedBox(height: 4),
            Text(
              'Domain diuji: ${_pendingDomains.map((d) => d.label).join(', ')}',
              style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
            ),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Form KPSP usia $_formAge bulan',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            TextButton.icon(
              icon: const Icon(Icons.tune, size: 18),
              label: const Text('Ganti'),
              onPressed: _pickForm,
            ),
          ]),
          Text(
            'Usia skrining: $_screeningMonths bulan'
            '${widget.age.correctionApplied ? ' (koreksi)' : ''}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildResolvedBar() {
    return Container(
      width: double.infinity,
      color: Colors.green.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 12,
        children: _devAges.entries.map((e) {
          return Chip(
            avatar: const Icon(Icons.check_circle, size: 16, color: Colors.green),
            label: Text('${e.key.label}: ${e.value} bln',
                style: const TextStyle(fontSize: 12)),
            backgroundColor: Colors.green.shade50,
          );
        }).toList(),
      ),
    );
  }

  // ======================= QUESTION CARD =======================

  Widget _questionCard(KpspQuestion q) {
    final ans = _activeAnswers[q.number];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(
                  radius: 14,
                  child:
                      Text('${q.number}', style: const TextStyle(fontSize: 12))),
              const SizedBox(width: 10),
              Expanded(child: Text(q.text)),
            ]),
            if (q.imagePath != null) ...[
              const SizedBox(height: 12),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    q.imagePath!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(q.domain.label,
                  style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.primary)),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                  child: _answerBtn('Ya', true, ans, Colors.green.shade600, q.number)),
              const SizedBox(width: 8),
              Expanded(
                  child: _answerBtn('Tidak', false, ans, Colors.red.shade600, q.number)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _answerBtn(String label, bool value, bool? current, Color color, int num) {
    final sel = current == value;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: sel ? color : null,
        foregroundColor: sel ? Colors.white : color,
        side: BorderSide(color: color),
      ),
      onPressed: () {
        setState(() {
          if (_inRegression) {
            _regAnswers[num] = value;
          } else {
            _answers[num] = value;
          }
        });
      },
      child: Text(label),
    );
  }

  // ======================= BOTTOM BUTTONS =======================

  Widget _normalButton() {
    final form = _form!;
    return FilledButton.icon(
      onPressed: _answers.length == form.total ? _save : null,
      icon: const Icon(Icons.calculate),
      label: Text('Hitung & Simpan (${_answers.length}/${form.total})'),
    );
  }

  Widget _regButton(List<KpspQuestion> qs) {
    final allDone = qs.every((q) => _regAnswers.containsKey(q.number));
    return FilledButton.icon(
      onPressed: allDone ? _processRegressionStep : null,
      icon: const Icon(Icons.arrow_forward),
      label: Text('Lanjut Regresi (${_regAnswers.length}/${qs.length})'),
    );
  }

  // ======================= PICK FORM =======================

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

  // ======================= SAVE (initial) =======================

  Future<void> _save() async {
    final form = _form!;
    final interp = KpspScorer.interpret(form, _answers);
    final repo = context.read<AppRepository>();

    // Save the primary KPSP result.
    await repo.upsertKpsp(KpspResultsCompanion.insert(
      examinationId: widget.examinationId,
      formAgeMonths: _formAge,
      yesCount: interp.yesCount,
      totalQuestions: interp.total,
      result: interp.category.code,
      answersJson:
          jsonEncode(_answers.map((k, v) => MapEntry(k.toString(), v))),
    ));
    if (!mounted) return;

    // Determine which domains have at least one "Tidak".
    final failing = <KpspDomain>{};
    final passing = <KpspDomain>{};
    final byDomain = <KpspDomain, List<KpspQuestion>>{};
    for (final q in form.questions) {
      byDomain.putIfAbsent(q.domain, () => []).add(q);
    }
    for (final e in byDomain.entries) {
      final allYes = e.value.every((q) => _answers[q.number] == true);
      if (allYes) {
        passing.add(e.key);
      } else {
        failing.add(e.key);
      }
    }

    if (failing.isEmpty) {
      // All domains passed — show normal result.
      await _showNormalResult(interp);
      return;
    }

    // Offer regression.
    final doRegress = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Asesmen Usia Perkembangan'),
        content: Text(
          'Ada ${failing.length} domain yang belum tercapai penuh:\n'
          '${failing.map((d) => '• ${d.label}').join('\n')}\n\n'
          'Lanjutkan regresi ke usia lebih muda untuk menentukan '
          'usia perkembangan per domain?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak, Cukup'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Lanjutkan'),
          ),
        ],
      ),
    );

    if (doRegress != true) {
      if (mounted) await _showNormalResult(interp);
      return;
    }

    // Record passing domains at this age.
    for (final d in passing) {
      _devAges[d] = _formAge;
    }

    _initialInterp = interp;
    _startRegression(failing);
  }

  Future<void> _showNormalResult(KpspInterpretation interp) async {
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

  // ======================= REGRESSION FLOW =======================

  void _startRegression(Set<KpspDomain> failing) {
    final ages = KpspData.availableAges;
    final idx = ages.indexOf(_formAge);
    if (idx <= 0) {
      _finishRegression();
      return;
    }
    setState(() {
      _inRegression = true;
      _pendingDomains = failing;
      _regFormAge = ages[idx - 1];
      _regAnswers = {};
    });
  }

  void _processRegressionStep() {
    final form = KpspData.form(_regFormAge);
    if (form == null) {
      _advanceOrFinish();
      return;
    }

    // Save this regression entry.
    _regEntries.add({
      'formAge': _regFormAge,
      'answers':
          _regAnswers.map((k, v) => MapEntry(k.toString(), v)),
    });

    // Check each pending domain.
    final resolved = <KpspDomain>{};
    final byDomain = <KpspDomain, List<KpspQuestion>>{};
    for (final q in form.questions) {
      if (_pendingDomains.contains(q.domain)) {
        byDomain.putIfAbsent(q.domain, () => []).add(q);
      }
    }
    for (final e in byDomain.entries) {
      final allYes = e.value.every((q) => _regAnswers[q.number] == true);
      if (allYes) {
        _devAges[e.key] = _regFormAge;
        resolved.add(e.key);
      }
    }
    _pendingDomains.removeAll(resolved);

    _advanceOrFinish();
  }

  void _advanceOrFinish() {
    if (_pendingDomains.isEmpty) {
      _finishRegression();
      return;
    }
    final ages = KpspData.availableAges;
    final idx = ages.indexOf(_regFormAge);
    if (idx <= 0) {
      // Reached the lowest form age; mark unresolved as < 3.
      for (final d in _pendingDomains) {
        _devAges[d] = 0; // 0 = below 3 months
      }
      _finishRegression();
      return;
    }
    setState(() {
      _regFormAge = ages[idx - 1];
      _regAnswers = {};
    });
  }

  Future<void> _finishRegression() async {
    // Update the saved KPSP record with regression data.
    final repo = context.read<AppRepository>();
    final enrichedJson = jsonEncode({
      'answers': _answers.map((k, v) => MapEntry(k.toString(), v)),
      'regression': _regEntries,
      'developmentalAges': _devAges.map(
          (k, v) => MapEntry(k.name, v)),
    });
    await repo.upsertKpsp(KpspResultsCompanion.insert(
      examinationId: widget.examinationId,
      formAgeMonths: _formAge,
      yesCount: _initialInterp!.yesCount,
      totalQuestions: _initialInterp!.total,
      result: _initialInterp!.category.code,
      answersJson: enrichedJson,
    ));

    if (!mounted) return;

    setState(() => _inRegression = false);

    // Determine target stimulation age for each domain based on overall KPSP result.
    final ages = KpspData.availableAges;
    final stimTargets = <KpspDomain, int>{};
    final overallResult = _initialInterp!.category;

    for (final e in _devAges.entries) {
      if (overallResult == KpspResultCategory.meragukan) {
        // Doubtful: stimulate at current chronological age level
        stimTargets[e.key] = _formAge;
      } else if (overallResult == KpspResultCategory.penyimpangan) {
        // Delayed: stimulate at developmental age level
        stimTargets[e.key] = e.value == 0 ? ages.first : e.value;
      } else {
        // Appropriate: stimulate at next age level
        if (e.value == 0) {
          stimTargets[e.key] = ages.first;
        } else {
          final idx = ages.indexOf(e.value);
          stimTargets[e.key] =
              (idx >= 0 && idx < ages.length - 1) ? ages[idx + 1] : e.value;
        }
      }
    }

    await showDialog(
      context: context,
      builder: (_) => _DevAgeSummaryDialog(
        patient: widget.patient,
        chronologicalMonths: _screeningMonths,
        devAges: Map.from(_devAges),
        stimTargets: stimTargets,
        interp: _initialInterp!,
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }
}

// ======================= NORMAL RESULT DIALOG =======================

class _ResultDialog extends StatelessWidget {
  final Patient patient;
  final int screeningMonths;
  final KpspInterpretation interp;
  const _ResultDialog({
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
      context: context,
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
                      icon: const Icon(Icons.picture_as_pdf,
                          size: 20, color: Colors.teal),
                      tooltip: 'Cetak Stimulasi ${e.key.label}',
                      onPressed: () => _printStimulationPdf(context, e.key),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 8),
              if (interp.category != KpspResultCategory.sesuai)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf, size: 16),
                    label: const Text('Cetak Semua Stimulasi Kurang'),
                    onPressed: () => _printStimulationPdf(context),
                  ),
                ),
            ],
            if (interp.category == KpspResultCategory.sesuai) ...[
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

// ======================= DEVELOPMENTAL AGE SUMMARY =======================

class _DevAgeSummaryDialog extends StatelessWidget {
  final Patient patient;
  final int chronologicalMonths;
  final Map<KpspDomain, int> devAges;
  final Map<KpspDomain, int> stimTargets;
  final KpspInterpretation interp;

  const _DevAgeSummaryDialog({
    required this.patient,
    required this.chronologicalMonths,
    required this.devAges,
    required this.stimTargets,
    required this.interp,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = devAges.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return AlertDialog(
      title: Row(children: [
        Icon(Icons.psychology, color: Colors.teal.shade700),
        const SizedBox(width: 8),
        const Expanded(
          child: Text('Asesmen Usia Perkembangan',
              style: TextStyle(fontSize: 17)),
        ),
      ]),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Usia kronologis: $chronologicalMonths bulan',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.teal.shade900),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Usia Perkembangan Per Domain:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 8),
            ...sorted.map((e) {
              final domain = e.key;
              final devAge = e.value;
              final stimAge = stimTargets[domain] ?? devAge;
              final lag = chronologicalMonths - devAge;
              final isDelayed = devAge < chronologicalMonths && devAge > 0;
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDelayed
                      ? Colors.orange.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDelayed
                        ? Colors.orange.shade200
                        : Colors.green.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(domain.label,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                      devAge == 0
                          ? 'Usia perkembangan: < 3 bulan'
                          : 'Usia perkembangan: $devAge bulan'
                              '${isDelayed ? ' (tertinggal $lag bln)' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDelayed
                            ? Colors.orange.shade900
                            : Colors.green.shade900,
                      ),
                    ),
                    Text(
                      'Stimulasi: sesuai usia $stimAge bulan',
                      style: TextStyle(
                          fontSize: 12, color: Colors.teal.shade700),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.picture_as_pdf, size: 16),
                label: const Text('Cetak PDF Stimulasi Per Domain'),
                onPressed: () => _printDomainStimulation(context),
              ),
            ),
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

  void _printDomainStimulation(BuildContext context) {
    // Use the lowest developmental age for overall stimulation PDF.
    final lowestDevAge = devAges.values
        .fold<int>(999, (a, b) => a < b ? a : b);
    final targetAge = lowestDevAge == 999
        ? chronologicalMonths
        : (lowestDevAge == 0 ? 3 : lowestDevAge);

    PdfReportService.generateAndPrintStimulation(
      patient: patient,
      ageMonths: targetAge,
      interp: interp,
      context: context,
    );
  }
}
