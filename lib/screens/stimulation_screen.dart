import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../data/repository.dart';
import '../modules/kpsp/kpsp_model.dart';
import '../modules/stimulation/stimulation.dart';

/// Skrin khusus untuk melihat saran stimulasi perkembangan (SDIDTK Kemenkes).
class StimulationScreen extends StatefulWidget {
  final Patient patient;
  final String examinationId;
  final AgeResult age;

  const StimulationScreen({
    super.key,
    required this.patient,
    required this.examinationId,
    required this.age,
  });

  @override
  State<StimulationScreen> createState() => _StimulationScreenState();
}

class _StimulationScreenState extends State<StimulationScreen> {
  late Future<({KpspResult? kpsp, List<StimulationSuggestion> suggestions})> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<({KpspResult? kpsp, List<StimulationSuggestion> suggestions})> _loadData() async {
    final repo = context.read<AppRepository>();
    final k = await repo.getKpspForExam(widget.examinationId);
    final suggestions = <StimulationSuggestion>[];

    if (k != null) {
      final form = KpspData.form(k.formAgeMonths);
      final Map<int, bool> answers = {};
      if (form != null) {
        try {
          final m = jsonDecode(k.answersJson) as Map<String, dynamic>;
          m.forEach((key, val) {
            final n = int.tryParse(key);
            if (n != null && val is bool) answers[n] = val;
          });
        } catch (_) {}
      }

      if (form != null && answers.isNotEmpty) {
        suggestions.addAll(StimulationMatcher.forKpspResult(
          form: form,
          answers: answers,
        ));
      }
    }

    if (suggestions.isEmpty) {
      // Fallback/Default: gunakan kelompok usia anak saat ini
      final refAge = widget.age.correctionApplied
          ? widget.age.correctedMonths
          : widget.age.chronologicalMonths;
      final domainAges = <KpspDomain, int?>{
        for (final d in KpspDomain.values) d: refAge,
      };
      suggestions.addAll(StimulationMatcher.forDomains(domainAges));
    }

    return (kpsp: k, suggestions: suggestions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Stimulasi'),
      ),
      body: FutureBuilder<({KpspResult? kpsp, List<StimulationSuggestion> suggestions})>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Gagal memuat data: ${snap.error}'));
          }

          final data = snap.data!;
          final hasKpsp = data.kpsp != null;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header Info
              Card(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.25),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Metode Penentuan Stimulasi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (hasKpsp)
                        const Text(
                          'Saran stimulasi dihitung berdasarkan hasil KPSP kunjungan ini:\n'
                          '• Bidang yang belum tercapai (terdapat jawaban "Tidak") diberikan stimulasi sesuai usia saat ini.\n'
                          '• Bidang yang sudah tercapai (seluruh jawaban "Ya") diberikan stimulasi kelompok usia di atasnya.',
                          style: TextStyle(fontSize: 12.5),
                        )
                      else
                        const Text(
                          'Hasil KPSP belum diisi untuk pemeriksaan ini. Menampilkan saran stimulasi default sesuai usia saat ini. '
                          'Hasil saran stimulasi akan otomatis disesuaikan per domain jika Anda telah mengisi modul KPSP.',
                          style: TextStyle(fontSize: 12.5),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Suggestions list
              ...data.suggestions.map((s) {
                final isNextAge = hasKpsp && s.developmentalAgeMonths > data.kpsp!.formAgeMonths;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isNextAge
                          ? Colors.teal.shade200
                          : Colors.amber.shade200,
                      width: 1,
                    ),
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    leading: CircleAvatar(
                      backgroundColor: isNextAge
                          ? Colors.teal.shade50
                          : Colors.amber.shade50,
                      child: Icon(
                        isNextAge ? Icons.trending_up : Icons.assignment_turned_in,
                        color: isNextAge ? Colors.teal.shade700 : Colors.amber.shade800,
                      ),
                    ),
                    title: Text(
                      s.domain.label,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Text(
                      'Saran: stimulasi kelompok ${s.band.label} '
                      '(${isNextAge ? "usia atasnya/sudah tercapai" : "usia saat ini/belum tercapai"})',
                      style: TextStyle(
                        fontSize: 12,
                        color: isNextAge ? Colors.teal.shade700 : Colors.amber.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: s.activities.map((act) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 2),
                                        child: Icon(Icons.play_arrow, size: 14, color: Colors.blueGrey),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          act.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13.5,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      act.howTo,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.grey.shade700,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
