import 'package:intl/intl.dart';

/// Hasil perhitungan usia anak.
///
/// Mencakup usia kronologis dan usia koreksi (untuk bayi prematur).
class AgeResult {
  /// Total hari usia kronologis (sejak tanggal lahir).
  final int chronologicalDays;

  /// Total bulan usia kronologis (dibulatkan ke bawah).
  final int chronologicalMonths;

  /// Komponen tahun usia kronologis.
  final int years;

  /// Komponen bulan usia kronologis (0-11).
  final int months;

  /// Komponen hari usia kronologis.
  final int days;

  /// Total hari usia koreksi. Sama dengan [chronologicalDays] bila tidak ada
  /// koreksi prematur atau usia sudah melewati batas koreksi (24 bulan).
  final int correctedDays;

  /// Total bulan usia koreksi (dibulatkan ke bawah).
  final int correctedMonths;

  /// Apakah koreksi prematur sedang diterapkan.
  final bool correctionApplied;

  /// Usia gestasi saat lahir dalam minggu (null bila aterm/tidak diketahui).
  final int? gestationalWeeks;

  const AgeResult({
    required this.chronologicalDays,
    required this.chronologicalMonths,
    required this.years,
    required this.months,
    required this.days,
    required this.correctedDays,
    required this.correctedMonths,
    required this.correctionApplied,
    required this.gestationalWeeks,
  });

  /// Usia kronologis dalam tahun desimal (mis. 2.5 tahun).
  double get chronologicalYears => chronologicalDays / 365.25;

  /// Usia koreksi dalam tahun desimal.
  double get correctedYears => correctedDays / 365.25;

  /// Format ringkas usia kronologis, mis. "2 tahun 3 bulan 5 hari".
  String get chronologicalLabel => _formatYMD(years, months, days);

  /// Format ringkas usia koreksi dalam tahun-bulan.
  String get correctedLabel {
    final y = correctedMonths ~/ 12;
    final m = correctedMonths % 12;
    if (y == 0) return '$m bulan';
    if (m == 0) return '$y tahun';
    return '$y tahun $m bulan';
  }

  static String _formatYMD(int y, int m, int d) {
    final parts = <String>[];
    if (y > 0) parts.add('$y tahun');
    if (m > 0) parts.add('$m bulan');
    if (d > 0 || parts.isEmpty) parts.add('$d hari');
    return parts.join(' ');
  }
}

/// Engine perhitungan usia anak (Modul 2 PRD).
///
/// Mengikuti aturan SDIDTK / praktik klinis:
/// - Usia kronologis dihitung dari tanggal lahir ke tanggal pemeriksaan.
/// - Usia koreksi untuk bayi prematur = usia kronologis - (40 minggu - usia gestasi).
/// - Koreksi prematur hanya berlaku sampai usia kronologis 24 bulan.
/// - Bayi dianggap prematur bila usia gestasi < 37 minggu.
class AgeCalculator {
  /// Usia gestasi aterm sebagai acuan koreksi (minggu).
  static const int termWeeks = 40;

  /// Batas atas usia (bulan) di mana koreksi prematur masih diterapkan.
  static const int correctionCutoffMonths = 24;

  /// Ambang usia gestasi (minggu) di bawahnya bayi dianggap prematur.
  static const int pretermThresholdWeeks = 37;

  /// Hitung usia berdasarkan [birthDate] dan [examDate].
  ///
  /// [gestationalWeeks] adalah usia kehamilan saat lahir (minggu). Bila null
  /// atau >= [pretermThresholdWeeks], koreksi tidak diterapkan.
  static AgeResult calculate({
    required DateTime birthDate,
    required DateTime examDate,
    int? gestationalWeeks,
  }) {
    final birth = DateTime(birthDate.year, birthDate.month, birthDate.day);
    final exam = DateTime(examDate.year, examDate.month, examDate.day);

    final chronoDays = exam.difference(birth).inDays;

    // Komponen tahun/bulan/hari (kalender).
    var years = exam.year - birth.year;
    var months = exam.month - birth.month;
    var days = exam.day - birth.day;
    if (days < 0) {
      months -= 1;
      final prevMonth = DateTime(exam.year, exam.month, 0); // hari terakhir bln sebelumnya
      days += prevMonth.day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    final chronoMonths = years * 12 + months;

    // Koreksi prematur.
    final isPreterm =
        gestationalWeeks != null && gestationalWeeks < pretermThresholdWeeks;
    final withinCutoff = chronoMonths < correctionCutoffMonths;
    final applyCorrection = isPreterm && withinCutoff;

    var correctedDays = chronoDays;
    if (applyCorrection) {
      final prematureDays = (termWeeks - gestationalWeeks) * 7;
      correctedDays = chronoDays - prematureDays;
      if (correctedDays < 0) correctedDays = 0;
    }
    final correctedMonths = (correctedDays / 30.4375).floor();

    return AgeResult(
      chronologicalDays: chronoDays,
      chronologicalMonths: chronoMonths,
      years: years,
      months: months,
      days: days,
      correctedDays: correctedDays,
      correctedMonths: correctedMonths,
      correctionApplied: applyCorrection,
      gestationalWeeks: gestationalWeeks,
    );
  }

  static final DateFormat _df = DateFormat('d MMM yyyy', 'id_ID');

  /// Format tanggal Indonesia (mis. "5 Jan 2024").
  static String formatDate(DateTime date) => _df.format(date);
}
