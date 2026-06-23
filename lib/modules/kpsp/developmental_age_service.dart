import 'dart:convert';

import '../../core/age_calculator.dart';
import 'developmental_age.dart';
import 'kpsp_model.dart';

/// Satu baris riwayat KPSP mentah (decoupled dari tipe DB).
class KpspHistoryRow {
  final DateTime examDate;
  final int formAgeMonths;
  final String answersJson;
  const KpspHistoryRow({
    required this.examDate,
    required this.formAgeMonths,
    required this.answersJson,
  });
}

/// Layanan bersama: menghitung estimasi usia perkembangan dari riwayat KPSP.
///
/// SATU sumber kebenaran untuk pipeline: filter tanggal → parse jawaban →
/// pilih usia pembanding (koreksi vs kronologis) → DevelopmentalAgeEngine.
/// Dipakai oleh layar tren dan laporan PDF agar tidak menyimpang.
class DevelopmentalAgeService {
  /// Hitung dari [rows] (riwayat KPSP pasien).
  ///
  /// [asOf] membatasi entri ke kunjungan pada/sebelum tanggal itu (untuk
  /// laporan per-pemeriksaan agar tidak memakai kunjungan setelahnya). Bila
  /// null, semua riwayat dipakai (mis. tampilan tren terkini).
  static DevelopmentalAgeResult? fromHistory({
    required DateTime birthDate,
    int? gestationalWeeks,
    required List<KpspHistoryRow> rows,
    DateTime? asOf,
  }) {
    final entries = <KpspHistoryEntry>[];
    for (final r in rows) {
      if (asOf != null && r.examDate.isAfter(asOf)) continue;
      final answers = <int, bool>{};
      try {
        final m = jsonDecode(r.answersJson) as Map<String, dynamic>;
        m.forEach((key, val) {
          final n = int.tryParse(key);
          if (n != null && val is bool) answers[n] = val;
        });
      } catch (_) {}
      if (answers.isNotEmpty) {
        entries.add(KpspHistoryEntry(
          formAgeMonths: r.formAgeMonths,
          answers: answers,
        ));
      }
    }
    if (entries.isEmpty) return null;

    // Usia pembanding pada [asOf] (atau sekarang): koreksi bila prematur < 2 thn.
    final refDate = asOf ?? DateTime.now();
    final refAge = AgeCalculator.calculate(
      birthDate: birthDate,
      examDate: refDate,
      gestationalWeeks: gestationalWeeks,
    );
    final comparatorMonths = refAge.correctionApplied
        ? refAge.correctedMonths
        : refAge.chronologicalMonths;

    return DevelopmentalAgeEngine.analyze(
      history: entries,
      resolveForm: KpspData.form,
      chronologicalMonths: comparatorMonths,
    );
  }
}
