/// Calculator engine untuk Fenton 2013 Preterm Growth Chart.
///
/// Digunakan untuk menilai pertumbuhan bayi prematur berdasarkan Postmenstrual Age (PMA)
/// dalam rentang 22.0 hingga 50.0 minggu gestasi.
class FentonCalculator {
  /// Memeriksa apakah bayi memenuhi kriteria penilaian Fenton (Prematur atau PMA <= 50 mgg).
  static bool isEligibleForFenton({
    required int gestationalWeeks,
    required double ageMonths,
  }) {
    // Usia pasca-menstrual dalam minggu (Postmenstrual Age / PMA)
    // PMA = gestationalWeeks + (ageMonths * 4.3482)
    final pmaWeeks = gestationalWeeks + (ageMonths * 4.3482);
    return gestationalWeeks < 37 || pmaWeeks <= 50.0;
  }

  /// Menghitung Postmenstrual Age (PMA) dalam minggu.
  ///
  /// [gestationalWeeks]: Usia kehamilan saat lahir (misal 28, 32 minggu).
  /// [birthDate]: Tanggal lahir bayi.
  /// [examDate]: Tanggal pemeriksaan.
  static double calculatePMAWeeks({
    required int gestationalWeeks,
    required DateTime birthDate,
    required DateTime examDate,
  }) {
    final diffDays = examDate.difference(birthDate).inDays;
    final ageWeeks = diffDays / 7.0;
    return gestationalWeeks + ageWeeks;
  }

  /// Menghitung Usia Koreksi dalam bulan (jika PMA > 40 minggu).
  static double calculateCorrectedAgeMonths({
    required double pmaWeeks,
  }) {
    if (pmaWeeks <= 40.0) {
      return 0.0;
    }
    final correctedWeeks = pmaWeeks - 40.0;
    return correctedWeeks / 4.3482;
  }

  /// Format keterangan status PMA.
  static String formatPMAStatus(double pmaWeeks) {
    if (pmaWeeks < 22.0) {
      return 'Di bawah rentang Fenton (< 22 minggu gestasi)';
    } else if (pmaWeeks > 50.0) {
      return 'Di atas rentang Fenton (> 50 minggu gestasi - gunakan Kurva WHO)';
    } else if (pmaWeeks < 40.0) {
      return '${pmaWeeks.toStringAsFixed(1)} minggu PMA (Prematur < 40 mgg)';
    } else {
      final correctedMonths = (pmaWeeks - 40.0) / 4.3482;
      return '${pmaWeeks.toStringAsFixed(1)} minggu PMA (setara usia koreksi ${correctedMonths.toStringAsFixed(1)} bln)';
    }
  }
}
