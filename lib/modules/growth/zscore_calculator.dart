import 'dart:math' as math;

/// Indikator pertumbuhan yang didukung.
enum GrowthIndicator {
  weightForAge('BB/U', 'Berat Badan menurut Umur'),
  lengthHeightForAge('TB/U', 'Tinggi Badan menurut Umur'),
  weightForLengthHeight('BB/TB', 'Berat Badan menurut Tinggi Badan'),
  bmiForAge('IMT/U', 'Indeks Massa Tubuh menurut Umur'),
  headCircumferenceForAge('LK/U', 'Lingkar Kepala menurut Umur');

  final String code;
  final String label;
  const GrowthIndicator(this.code, this.label);
}

/// Satu titik koefisien LMS pada usia/panjang tertentu.
class LmsPoint {
  /// Variabel x: umur (hari) untuk *-for-age, atau panjang/tinggi (cm) untuk BB/TB.
  final double x;
  final double l;
  final double m;
  final double s;

  const LmsPoint(this.x, this.l, this.m, this.s);
}

/// Hasil perhitungan Z-score.
class ZScoreResult {
  final GrowthIndicator indicator;
  final double zScore;
  final double percentile;

  /// Median (M) pada titik acuan, berguna untuk grafik.
  final double median;

  /// Nilai pengukuran pada -2 SD (batas bawah normal).
  final double sd2neg;

  /// Nilai pengukuran pada +2 SD (batas atas normal).
  final double sd2pos;

  const ZScoreResult({
    required this.indicator,
    required this.zScore,
    required this.percentile,
    required this.median,
    this.sd2neg = 0,
    this.sd2pos = 0,
  });

  double get zRounded => (zScore * 100).round() / 100;
}

/// Engine perhitungan Z-score dengan metode LMS (WHO Child Growth Standards).
///
/// Rumus dasar:
///   Z = ((X/M)^L - 1) / (L * S),  untuk L != 0
///   Z = ln(X/M) / S,              untuk L == 0
///
/// WHO menerapkan koreksi untuk |Z| > 3 agar nilai ekstrem tidak terdistorsi
/// oleh bentuk distribusi (lihat WHO Anthro, "restricted application of the
/// LMS method"). Koreksi ini hanya berlaku untuk indikator berbasis berat.
class ZScoreCalculator {
  /// Interpolasi linear koefisien LMS pada nilai [x] dari tabel [table].
  ///
  /// [table] harus terurut menaik berdasarkan x. Bila x di luar rentang,
  /// dipakai titik ujung terdekat (clamping).
  static LmsPoint? interpolate(List<LmsPoint> table, double x) {
    if (table.isEmpty) return null;
    if (x <= table.first.x) return table.first;
    if (x >= table.last.x) return table.last;

    var lo = 0;
    var hi = table.length - 1;
    while (lo + 1 < hi) {
      final mid = (lo + hi) ~/ 2;
      if (table[mid].x <= x) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    final a = table[lo];
    final b = table[hi];
    final t = (x - a.x) / (b.x - a.x);
    return LmsPoint(
      x,
      a.l + (b.l - a.l) * t,
      a.m + (b.m - a.m) * t,
      a.s + (b.s - a.s) * t,
    );
  }

  /// Hitung Z-score mentah dari koefisien LMS.
  static double rawZ(double value, LmsPoint lms) {
    if (lms.l.abs() < 1e-7) {
      return math.log(value / lms.m) / lms.s;
    }
    return (math.pow(value / lms.m, lms.l) - 1) / (lms.l * lms.s);
  }

  /// Nilai pengukuran pada Z tertentu (invers), untuk menggambar garis kurva.
  static double valueAtZ(LmsPoint lms, double z) {
    if (lms.l.abs() < 1e-7) {
      return lms.m * math.exp(lms.s * z);
    }
    return lms.m * math.pow(1 + lms.l * lms.s * z, 1 / lms.l).toDouble();
  }

  /// Koreksi WHO untuk |Z| > 3 (hanya indikator berbasis berat).
  static double _applyWhoCorrection(double z, double value, LmsPoint lms) {
    if (z > 3) {
      final sd3pos = valueAtZ(lms, 3);
      final sd23pos = sd3pos - valueAtZ(lms, 2);
      if (sd23pos == 0) return z;
      return 3 + (value - sd3pos) / sd23pos;
    } else if (z < -3) {
      final sd3neg = valueAtZ(lms, -3);
      final sd23neg = valueAtZ(lms, -2) - sd3neg;
      if (sd23neg == 0) return z;
      return -3 + (value - sd3neg) / sd23neg;
    }
    return z;
  }

  static bool _isWeightBased(GrowthIndicator i) =>
      i == GrowthIndicator.weightForAge ||
      i == GrowthIndicator.weightForLengthHeight ||
      i == GrowthIndicator.bmiForAge;

  /// Aproksimasi CDF normal standar untuk konversi Z ke persentil.
  static double _normalCdf(double z) {
    // Zelen & Severo (Abramowitz & Stegun 26.2.17), error < 7.5e-8.
    final t = 1 / (1 + 0.2316419 * z.abs());
    final d = 0.3989422804014327 * math.exp(-z * z / 2);
    var p = d *
        t *
        (0.319381530 +
            t *
                (-0.356563782 +
                    t * (1.781477937 + t * (-1.821255978 + t * 1.330274429))));
    if (z > 0) p = 1 - p;
    return p;
  }

  /// Hitung Z-score lengkap untuk [value] pada [x] (umur-hari atau panjang-cm).
  ///
  /// Bila [enforceBounds] true (default), [x] yang berada di luar rentang
  /// tabel referensi akan menghasilkan null alih-alih di-clamp ke ujung tabel.
  /// Ini mencegah Z-score yang tampak valid padahal di luar cakupan standar
  /// (mis. usia > 5 tahun pada tabel WHO 0-5 tahun, atau tinggi di luar
  /// rentang tabel BB/TB).
  static ZScoreResult? compute({
    required GrowthIndicator indicator,
    required List<LmsPoint> table,
    required double value,
    required double x,
    bool enforceBounds = true,
  }) {
    if (table.isEmpty || value <= 0) return null;
    if (enforceBounds) {
      // Toleransi kecil untuk pembulatan (mis. 60.0 vs 60.0001 bulan).
      const eps = 1e-6;
      if (x < table.first.x - eps || x > table.last.x + eps) return null;
    }
    final lms = interpolate(table, x);
    if (lms == null) return null;
    var z = rawZ(value, lms);
    if (_isWeightBased(indicator) && z.abs() > 3) {
      z = _applyWhoCorrection(z, value, lms);
    }
    return ZScoreResult(
      indicator: indicator,
      zScore: z,
      percentile: _normalCdf(z) * 100,
      median: lms.m,
      sd2neg: valueAtZ(lms, -2),
      sd2pos: valueAtZ(lms, 2),
    );
  }
}
