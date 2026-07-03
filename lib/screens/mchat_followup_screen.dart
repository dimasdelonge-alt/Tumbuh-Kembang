import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../modules/screening/data/mchat_data.dart';
import '../modules/screening/data/mchat_followup_data.dart';
import '../modules/screening/instrument.dart';

class MchatFollowUpScreen extends StatefulWidget {
  final String examinationId;

  const MchatFollowUpScreen({
    super.key,
    required this.examinationId,
  });

  @override
  State<MchatFollowUpScreen> createState() => _MchatFollowUpScreenState();
}

class _MchatFollowUpScreenState extends State<MchatFollowUpScreen> {
  bool _isLoading = true;
  String? _error;

  // Answers from Stage 1: itemNumber -> risk (true/false)
  Map<int, bool> _stage1Answers = {};
  // Only items that failed in Stage 1
  List<int> _flaggedItems = [];
  
  // Follow-up answers: itemNumber -> 'pass' / 'fail' (Lulus / Gagal)
  final Map<int, String> _followUpAnswers = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final repo = context.read<AppRepository>();
      final existing = await repo.getScreening(widget.examinationId, mchatId);
      
      if (existing == null) {
        setState(() {
          _error = 'Skrining M-CHAT-R tahap 1 belum diisi.';
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> decoded = jsonDecode(existing.answersJson) as Map<String, dynamic>;
      
      // Determine stage 1 answers
      final Map<int, bool> stage1 = {};
      final stage1Raw = decoded.containsKey('answers') ? decoded['answers'] : decoded;
      
      if (stage1Raw is Map) {
        stage1Raw.forEach((k, v) {
          final n = int.tryParse(k.toString());
          if (n != null && v is bool) {
            stage1[n] = v;
          }
        });
      }

      // Find flagged items (failed items in Stage 1)
      final List<int> flagged = [];
      for (final item in mchatInstrument.items) {
        final ans = stage1[item.number];
        if (ans != null) {
          final isRisk = (item.riskAnswer == RiskAnswer.ya && ans == true) ||
                         (item.riskAnswer == RiskAnswer.tidak && ans == false);
          if (isRisk) {
            flagged.add(item.number);
          }
        }
      }

      // Preload follow-up answers if they exist
      final Map<int, String> followUp = {};
      if (decoded.containsKey('followUp')) {
        final followUpRaw = decoded['followUp'] as Map<String, dynamic>? ?? {};
        followUpRaw.forEach((k, v) {
          final n = int.tryParse(k);
          if (n != null && (v == 'pass' || v == 'fail')) {
            followUp[n] = v;
          }
        });
      }

      setState(() {
        _stage1Answers = stage1;
        _flaggedItems = flagged;
        
        // Initialize followUpAnswers
        for (final itemNo in flagged) {
          _followUpAnswers[itemNo] = followUp[itemNo] ?? 'fail'; // Default to fail (failed in Stage 1)
        }
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat data: $e';
        _isLoading = false;
      });
    }
  }

  bool get _canSave {
    return _flaggedItems.isNotEmpty && _followUpAnswers.length == _flaggedItems.length;
  }

  int get _failedCount {
    return _followUpAnswers.values.where((v) => v == 'fail').length;
  }

  Future<void> _save() async {
    if (!_canSave) return;

    final repo = context.read<AppRepository>();
    final int followUpScore = _failedCount;
    // Follow-up interpretation: >=2 failed is RiskLevel.high, 0-1 is RiskLevel.low
    final isHigh = followUpScore >= 2;
    final finalRiskLevel = isHigh ? RiskLevel.high : RiskLevel.low;

    // Convert stage 1 answers
    final stage1Map = _stage1Answers.map((k, v) => MapEntry(k.toString(), v));
    // Convert follow-up answers
    final followUpMap = _followUpAnswers.map((k, v) => MapEntry(k.toString(), v));

    final enrichedAnswers = {
      'answers': stage1Map,
      'initialScore': _flaggedItems.length,
      'followUp': followUpMap,
      'followUpScore': followUpScore,
    };

    await repo.upsertScreening(ScreeningResultsCompanion.insert(
      examinationId: widget.examinationId,
      instrumentId: mchatId,
      score: followUpScore,
      totalItems: mchatInstrument.totalItems,
      riskLevel: finalRiskLevel.severity,
      answersJson: jsonEncode(enrichedAnswers),
      variantLabel: const Value('Follow-Up'),
    ));

    if (!mounted) return;

    // Show custom results dialog
    await showDialog(
      context: context,
      builder: (_) => _ResultDialog(
        followUpScore: followUpScore,
        isHigh: isHigh,
      ),
    );

    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M-CHAT-R/F Wawancara Tahap 2'),
      ),
      bottomNavigationBar: _isLoading || _error != null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: FilledButton.icon(
                  onPressed: _canSave ? _save : null,
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text('Simpan Hasil Wawancara (Skor Akhir: $_failedCount Gagal)'),
                ),
              ),
            ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadData();
                },
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_flaggedItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: Colors.green.shade600),
              const SizedBox(height: 16),
              const Text(
                'Tidak Perlu Wawancara Tahap 2',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Hasil M-CHAT-R Tahap 1 menunjukkan risiko rendah (0-2 item berisiko). Wawancara Tahap 2 hanya diperlukan untuk anak dengan skor 3-7.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Card(
          color: Colors.amber.shade50,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.amber.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber.shade800),
                    const SizedBox(width: 8),
                    const Text(
                      'PANDUAN PENTING',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Skrining awal menunjukkan anak berisiko pada ${_flaggedItems.length} item. Tanyakan pertanyaan lanjutan di bawah untuk mengonfirmasi apakah anak benar-benar GAGAL (Fail) atau LULUS (Pass) pada tiap item tersebut.',
                  style: TextStyle(fontSize: 13, color: Colors.amber.shade900),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ..._flaggedItems.map(_buildItemCard),
      ],
    );
  }

  Widget _buildItemCard(int number) {
    final item = mchatInstrument.items.firstWhere((i) => i.number == number);
    final answer = _followUpAnswers[number];
    final guide = mchatFollowUpGuides[number] ?? 'Panduan untuk item ini tidak tersedia.';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: answer == 'fail' ? Colors.red.shade200 : Colors.green.shade200,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: answer == 'fail' ? Colors.red.shade100 : Colors.green.shade100,
                  foregroundColor: answer == 'fail' ? Colors.red.shade900 : Colors.green.shade900,
                  child: Text('$number', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.text,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jawaban awal: ${_stage1Answers[number] == true ? "YA" : "TIDAK"} (Risiko)',
                        style: const TextStyle(fontSize: 12.5, color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    avatar: Icon(
                      Icons.check_circle,
                      color: answer == 'pass' ? Colors.white : Colors.green,
                      size: 18,
                    ),
                    label: const Center(child: Text('LULUS (Pass)')),
                    selected: answer == 'pass',
                    selectedColor: Colors.green.shade600,
                    labelStyle: TextStyle(
                      color: answer == 'pass' ? Colors.white : Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _followUpAnswers[number] = 'pass');
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChoiceChip(
                    avatar: Icon(
                      Icons.cancel,
                      color: answer == 'fail' ? Colors.white : Colors.red,
                      size: 18,
                    ),
                    label: const Center(child: Text('GAGAL (Fail)')),
                    selected: answer == 'fail',
                    selectedColor: Colors.red.shade600,
                    labelStyle: TextStyle(
                      color: answer == 'fail' ? Colors.white : Colors.red.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _followUpAnswers[number] = 'fail');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.help_outline, size: 20),
              title: const Text(
                'Panduan Wawancara & Flowchart',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade50,
                  child: SelectableText(
                    guide,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Courier',
                      color: Colors.grey.shade800,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  final int followUpScore;
  final bool isHigh;

  const _ResultDialog({
    required this.followUpScore,
    required this.isHigh,
  });

  @override
  Widget build(BuildContext context) {
    final color = isHigh ? Colors.red.shade700 : Colors.green.shade700;
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.assignment_turned_in, color: color),
          const SizedBox(width: 8),
          const Text('Hasil Wawancara Tahap 2'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skor Akhir (Gagal): $followUpScore',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  isHigh ? 'SKRINING POSITIF / RISIKO TINGGI' : 'SKRINING NEGATIF / RISIKO RENDAH',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isHigh
                ? 'Hasil menunjukkan risiko tinggi ASD (skor akhir >= 2).'
                : 'Hasil menunjukkan risiko rendah ASD (skor akhir 0-1).',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text('Rekomendasi:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            isHigh
                ? 'Rujuk segera untuk evaluasi diagnostik dan evaluasi eligibilitas intervensi dini.'
                : 'Tidak ada tindakan lanjutan khusus, lakukan surveilans perkembangan rutin pada kunjungan berikutnya.',
            style: const TextStyle(fontSize: 13),
          ),
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
