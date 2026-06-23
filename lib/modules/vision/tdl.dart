/// Tes Daya Lihat (TDL) — SDIDTK Kemenkes.
///
/// Tes fisik tetap memakai poster "E" asli (4 baris, baris 1 terbesar s/d
/// baris 4 terkecil) dari jarak 3 meter. Aplikasi hanya MENCATAT hasil:
/// baris terkecil yang masih dapat dibaca tiap mata.
///
/// Interpretasi (pedoman): anak prasekolah umumnya dapat melihat sampai
/// baris ketiga. Bila suatu mata tidak mencapai baris 3 (hanya baris 1 atau 2),
/// mata itu kemungkinan mengalami gangguan daya lihat.
///
/// Untuk anak usia prasekolah 36-72 bulan, dites tiap 6 bulan.

/// Jumlah baris pada poster "E" standar yang dipakai.
const int tdlTotalLines = 4;

/// Baris minimal yang harus tercapai agar dianggap normal.
const int tdlNormalThresholdLine = 3;

enum TdlEyeStatus {
  normal('Normal'),
  suspectedImpairment('Kemungkinan gangguan');

  final String label;
  const TdlEyeStatus(this.label);
}

class TdlResult {
  /// Baris terkecil yang terbaca mata kanan/kiri (1..[tdlTotalLines]).
  /// null bila tidak dapat membaca baris mana pun.
  final int? rightEyeLine;
  final int? leftEyeLine;

  const TdlResult({required this.rightEyeLine, required this.leftEyeLine});

  static TdlEyeStatus eyeStatus(int? line) {
    if (line == null) return TdlEyeStatus.suspectedImpairment;
    return line >= tdlNormalThresholdLine
        ? TdlEyeStatus.normal
        : TdlEyeStatus.suspectedImpairment;
  }

  TdlEyeStatus get rightStatus => eyeStatus(rightEyeLine);
  TdlEyeStatus get leftStatus => eyeStatus(leftEyeLine);

  /// Ada kemungkinan gangguan bila salah satu mata tidak mencapai ambang.
  bool get hasImpairment =>
      rightStatus == TdlEyeStatus.suspectedImpairment ||
      leftStatus == TdlEyeStatus.suspectedImpairment;

  /// Daftar mata yang terindikasi gangguan ('kanan'/'kiri').
  List<String> get affectedEyes {
    final eyes = <String>[];
    if (rightStatus == TdlEyeStatus.suspectedImpairment) eyes.add('kanan');
    if (leftStatus == TdlEyeStatus.suspectedImpairment) eyes.add('kiri');
    return eyes;
  }

  String get interpretation {
    if (!hasImpairment) {
      return 'Daya lihat kedua mata dalam batas normal '
          '(mencapai baris $tdlNormalThresholdLine).';
    }
    return 'Kemungkinan gangguan daya lihat pada mata ${affectedEyes.join(' & ')}.';
  }

  String get recommendation {
    if (!hasImpairment) {
      return 'Lanjutkan pemantauan rutin. Ulangi TDL tiap 6 bulan pada usia '
          'prasekolah (36-72 bulan).';
    }
    return 'Minta anak datang untuk pemeriksaan ulang. Bila pada pemeriksaan '
        'berikutnya tetap tidak dapat melihat baris yang sama, rujuk ke Rumah '
        'Sakit (tuliskan mata yang terganggu: ${affectedEyes.join(' & ')}).';
  }
}
