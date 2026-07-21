/// Hasil Tinggi Potensi Genetik (TPG) Dewasa (Usia 18-20 Tahun)
class TpgResult {
  final double targetCm;
  final double minCm;
  final double maxCm;
  final String sex;

  TpgResult({
    required this.targetCm,
    required this.minCm,
    required this.maxCm,
    required this.sex,
  });

  String get label =>
      '${targetCm.toStringAsFixed(1)} cm (rentang ${minCm.toStringAsFixed(1)} – ${maxCm.toStringAsFixed(1)} cm)';
}

/// Hasil Evaluasi Potensi Genetik Real-Time Sesuai Usia Anak Saat Ini
class RealtimeTpgResult {
  final double minExpectedCm;
  final double targetExpectedCm;
  final double maxExpectedCm;
  final String statusLabel;
  final bool isBelow;
  final bool isAbove;

  RealtimeTpgResult({
    required this.minExpectedCm,
    required this.targetExpectedCm,
    required this.maxExpectedCm,
    required this.statusLabel,
    required this.isBelow,
    required this.isAbove,
  });

  String get rangeLabel =>
      '${minExpectedCm.toStringAsFixed(1)} cm s/d ${maxExpectedCm.toStringAsFixed(1)} cm (Target: ${targetExpectedCm.toStringAsFixed(1)} cm)';
}

class CdcCalculator {
  /// Menghitung Tinggi Potensi Genetik (TPG) Dewasa berdasarkan TB Orang Tua.
  ///
  /// [fatherHeightCm]: TB Ayah (cm)
  /// [motherHeightCm]: TB Ibu (cm)
  /// [sex]: 'L' / 'M' untuk Laki-laki, 'P' / 'F' untuk Perempuan.
  static TpgResult? calculateTPG({
    required double? fatherHeightCm,
    required double? motherHeightCm,
    required String sex,
  }) {
    if (fatherHeightCm == null ||
        motherHeightCm == null ||
        fatherHeightCm <= 0 ||
        motherHeightCm <= 0) {
      return null;
    }

    final isBoy = sex.toUpperCase() == 'L' || sex.toUpperCase() == 'M';
    double target;

    if (isBoy) {
      // Rumus Anak Laki-Laki: ((TB Ibu + 13) + TB Ayah) / 2
      target = ((motherHeightCm + 13.0) + fatherHeightCm) / 2.0;
    } else {
      // Rumus Anak Perempuan: ((TB Ayah - 13) + TB Ibu) / 2
      target = ((fatherHeightCm - 13.0) + motherHeightCm) / 2.0;
    }

    // Rentang deviasi standar potensi genetik (+/- 8.5 cm)
    final min = target - 8.5;
    final max = target + 8.5;

    return TpgResult(
      targetCm: target,
      minCm: min,
      maxCm: max,
      sex: isBoy ? 'L' : 'P',
    );
  }

  /// Menghitung Rentang Tinggi Ideal Real-Time Anak Pada Usia Saat Ini
  /// dan Menilai Apakah Tinggi Anak Saat Ini Berada di Bawah/Sesuai Potensi Genetik.
  ///
  /// Catatan: Evaluasi ini menggunakan kurva CDC 2000 yang hanya valid untuk usia 2–20 tahun.
  /// Untuk anak < 2 tahun, evaluasi real-time tidak dilakukan karena data CDC belum tersedia.
  static RealtimeTpgResult? calculateRealtimeTPG({
    required double? currentHeightCm,
    required int ageMonths,
    required TpgResult? tpg,
  }) {
    if (tpg == null) return null;

    // CDC 2000 stature-for-age hanya tersedia untuk usia 2–20 tahun.
    // Evaluasi real-time tidak valid untuk anak di bawah 2 tahun.
    if (ageMonths < 24) {
      return RealtimeTpgResult(
        minExpectedCm: 0,
        targetExpectedCm: 0,
        maxExpectedCm: 0,
        statusLabel: 'Evaluasi TPG real-time belum tersedia untuk usia di bawah 2 tahun '
            '(kurva CDC 2000 dimulai dari usia 2 tahun). '
            'TPG Dewasa tetap valid sebagai prediksi tinggi akhir.',
        isBelow: false,
        isAbove: false,
      );
    }

    final isBoy = tpg.sex == 'L';
    final ageYears = (ageMonths / 12.0).clamp(2.0, 20.0);

    final expected = expectedHeightAtAge(ageYears, tpg, isBoy);

    // Evaluasi Posisi Tinggi Anak Saat Ini
    String status;
    bool isBelow = false;
    bool isAbove = false;

    if (currentHeightCm == null || currentHeightCm <= 0) {
      status = 'Isi tinggi badan anak untuk melihat evaluasi real-time.';
    } else if (currentHeightCm < expected.min) {
      isBelow = true;
      status =
          'DI BAWAH POTENSI GENETIK (Tinggi anak ${currentHeightCm.toStringAsFixed(1)} cm < min ideal ${expected.min.toStringAsFixed(1)} cm. Risiko Stunting/Kerdil).';
    } else if (currentHeightCm > expected.max) {
      isAbove = true;
      status =
          'DI ATAS POTENSI GENETIK (Tinggi anak ${currentHeightCm.toStringAsFixed(1)} cm > max ideal ${expected.max.toStringAsFixed(1)} cm).';
    } else {
      status =
          'SESUAI POTENSI GENETIK (Tinggi anak ${currentHeightCm.toStringAsFixed(1)} cm berada dalam rentang ideal ${expected.min.toStringAsFixed(1)} – ${expected.max.toStringAsFixed(1)} cm).';
    }

    return RealtimeTpgResult(
      minExpectedCm: expected.min,
      targetExpectedCm: expected.target,
      maxExpectedCm: expected.max,
      statusLabel: status,
      isBelow: isBelow,
      isAbove: isAbove,
    );
  }

  /// Menghitung tinggi ideal (min, target, max) berdasarkan TPG pada usia tertentu.
  /// Digunakan oleh chart painter untuk menggambar kurva trajektori TPG penuh.
  static ({double min, double target, double max}) expectedHeightAtAge(
    double ageYears,
    TpgResult tpg,
    bool isBoy,
  ) {
    // Median height CDC 2000 per umur (2 sampai 20 thn)
    final double adultMedian = isBoy ? 176.5 : 163.2;
    final double currentMedian = medianHeightForAge(ageYears, isBoy);

    // Skala rasio pertumbuhan usia saat ini terhadap usia dewasa (20 thn)
    final ratio = (currentMedian / adultMedian).clamp(0.4, 1.0);

    final targetExp = currentMedian + (tpg.targetCm - adultMedian) * ratio;
    final minExp = currentMedian + (tpg.minCm - adultMedian) * ratio;
    final maxExp = currentMedian + (tpg.maxCm - adultMedian) * ratio;

    return (min: minExp, target: targetExp, max: maxExp);
  }

  /// Kurva median tinggi badan CDC 2000 (cm) berdasarkan usia (tahun).
  /// Menggunakan interpolasi linier antar titik referensi untuk hasil lebih akurat.
  static double medianHeightForAge(double ageYears, bool isBoy) {
    final data = isBoy ? _boyMedian : _girlMedian;

    // Cari interval yang tepat untuk interpolasi
    if (ageYears <= data.first.$1) return data.first.$2;
    if (ageYears >= data.last.$1) return data.last.$2;

    for (int i = 0; i < data.length - 1; i++) {
      final (age1, h1) = data[i];
      final (age2, h2) = data[i + 1];

      if (ageYears >= age1 && ageYears <= age2) {
        // Interpolasi linier
        final t = (ageYears - age1) / (age2 - age1);
        return h1 + (h2 - h1) * t;
      }
    }

    return data.last.$2;
  }

  // Data referensi median CDC 2000 (usia tahun, tinggi cm)
  static const List<(double, double)> _boyMedian = [
    (2.0, 86.8),
    (3.0, 95.2),
    (4.0, 102.3),
    (5.0, 109.2),
    (6.0, 115.5),
    (7.0, 121.5),
    (8.0, 127.6),
    (9.0, 133.0),
    (10.0, 138.4),
    (11.0, 143.5),
    (12.0, 149.1),
    (13.0, 156.0),
    (14.0, 163.2),
    (15.0, 169.0),
    (16.0, 173.1),
    (17.0, 175.2),
    (18.0, 176.1),
    (19.0, 176.4),
    (20.0, 176.5),
  ];

  static const List<(double, double)> _girlMedian = [
    (2.0, 85.5),
    (3.0, 94.0),
    (4.0, 101.5),
    (5.0, 108.4),
    (6.0, 114.6),
    (7.0, 120.6),
    (8.0, 126.6),
    (9.0, 132.6),
    (10.0, 138.6),
    (11.0, 144.5),
    (12.0, 150.9),
    (13.0, 156.4),
    (14.0, 160.0),
    (15.0, 161.7),
    (16.0, 162.5),
    (17.0, 162.8),
    (18.0, 163.0),
    (19.0, 163.1),
    (20.0, 163.2),
  ];
}
