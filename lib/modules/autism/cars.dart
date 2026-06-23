/// CARS — Childhood Autism Rating Scale (versi Indonesia).
///
/// HAK CIPTA: CARS adalah instrumen berhak cipta (Schopler dkk., Western
/// Psychological Services). Dipakai di sini untuk skrining klinis di dalam
/// praktek sendiri. Distribusi di luar praktek pribadi memerlukan lisensi.
///
/// 15 area perilaku (I-XV), tiap area dinilai 1-4 dengan kemungkinan nilai
/// tengah berkelipatan 0,5 (1; 1,5; 2; 2,5; 3; 3,5; 4):
///   1 = sesuai usia (normal), 2 = abnormal ringan, 3 = abnormal sedang,
///   4 = abnormal berat. Skor total = jumlah ke-15 area (15,0 - 60,0).
///
/// Interpretasi (lembar skoring CARS):
///   < 30      : non-autistik
///   30 - 36,5 : autistik ringan-sedang
///   >= 37     : autistik berat

const String carsId = 'cars';

/// Satu area penilaian CARS dengan anchor singkat tiap level utama.
class CarsArea {
  final int number;
  final String title;

  /// Deskripsi singkat anchor untuk level 1,2,3,4.
  final String anchor1;
  final String anchor2;
  final String anchor3;
  final String anchor4;

  const CarsArea(
    this.number,
    this.title, {
    required this.anchor1,
    required this.anchor2,
    required this.anchor3,
    required this.anchor4,
  });
}

enum CarsCategory {
  nonAutistic('Non-autistik', 0),
  mildModerate('Autistik ringan-sedang', 1),
  severe('Autistik berat', 2);

  final String label;
  final int severity;
  const CarsCategory(this.label, this.severity);
}

class CarsInterpretation {
  final double totalScore;
  final CarsCategory category;
  const CarsInterpretation({required this.totalScore, required this.category});

  String get recommendation {
    switch (category) {
      case CarsCategory.nonAutistic:
        return 'Skor di bawah ambang autisme. Bila tetap ada kekhawatiran '
            'perkembangan/perilaku, lakukan pemantauan dan skrining lain '
            'sesuai indikasi.';
      case CarsCategory.mildModerate:
        return 'Indikasi autisme ringan-sedang. Rujuk untuk evaluasi '
            'diagnostik komprehensif dan intervensi dini.';
      case CarsCategory.severe:
        return 'Indikasi autisme berat. Rujuk segera untuk evaluasi '
            'diagnostik dan penanganan multidisiplin.';
    }
  }
}

class CarsScorer {
  /// Nilai pilihan yang valid: 1 sampai 4 dengan langkah 0,5.
  static const List<double> validValues = [
    1, 1.5, 2, 2.5, 3, 3.5, 4,
  ];

  static const double minScore = 15;
  static const double maxScore = 60;

  static CarsCategory categorize(double total) {
    if (total < 30) return CarsCategory.nonAutistic;
    if (total < 37) return CarsCategory.mildModerate; // 30 - 36,5
    return CarsCategory.severe; // >= 37
  }

  /// [values] memetakan nomor area (1..15) → nilai (1..4 step 0,5).
  static CarsInterpretation interpret(Map<int, double> values) {
    var total = 0.0;
    for (final v in values.values) {
      total += v;
    }
    return CarsInterpretation(
      totalScore: total,
      category: categorize(total),
    );
  }
}

/// 15 area CARS dengan anchor ringkas (diringkas dari deskripsi lengkap CARS
/// versi Indonesia; deskripsi penuh tetap dirujuk pemeriksa dari manual).
const List<CarsArea> carsAreas = [
  CarsArea(1, 'Hubungan dengan orang lain',
      anchor1: 'Sesuai usia; tidak ada kesulitan relasi.',
      anchor2: 'Abnormal ringan: kadang menghindari tatap mata, malu berlebih.',
      anchor3: 'Abnormal sedang: menyendiri, perlu usaha kuat menarik perhatian.',
      anchor4: 'Abnormal berat: konsisten menyendiri, hampir tak merespons.'),
  CarsArea(2, 'Imitasi (meniru)',
      anchor1: 'Meniru suara, kata, dan gerak sesuai keterampilannya.',
      anchor2: 'Abnormal ringan: meniru hal sederhana, kadang perlu didorong.',
      anchor3: 'Abnormal sedang: meniru sewaktu-waktu, butuh bantuan kuat.',
      anchor4: 'Abnormal berat: jarang/tak pernah meniru meski dibantu.'),
  CarsArea(3, 'Respon emosi',
      anchor1: 'Respon emosi sesuai situasi dan usia.',
      anchor2: 'Abnormal ringan: kadang reaksi emosi agak tidak sesuai.',
      anchor3: 'Abnormal sedang: reaksi jelas tidak sesuai; terhambat/berlebihan.',
      anchor4: 'Abnormal berat: respon jarang sesuai; sulit diubah.'),
  CarsArea(4, 'Penggunaan tubuh',
      anchor1: 'Gerak santai, lincah, terkoordinasi sesuai usia.',
      anchor2: 'Abnormal ringan: sedikit kaku/repetitif/koordinasi buruk.',
      anchor3: 'Abnormal sedang: gerakan aneh nyata (jinjit, mengayun, dll).',
      anchor4: 'Abnormal berat: gerakan aneh intens dan menetap.'),
  CarsArea(5, 'Penggunaan objek',
      anchor1: 'Minat dan penggunaan mainan/objek sesuai.',
      anchor2: 'Abnormal ringan: minat/cara bermain agak tidak lazim.',
      anchor3: 'Abnormal sedang: fokus pada bagian objek, cara bermain aneh.',
      anchor4: 'Abnormal berat: keasyikan aneh intens, sulit dialihkan.'),
  CarsArea(6, 'Adaptasi terhadap perubahan',
      anchor1: 'Menerima perubahan rutin tanpa stres berlebih.',
      anchor2: 'Abnormal ringan: melanjutkan aktivitas/material yang sama.',
      anchor3: 'Abnormal sedang: aktif menolak perubahan, sulit dialihkan.',
      anchor4: 'Abnormal berat: reaksi hebat/tantrum terhadap perubahan.'),
  CarsArea(7, 'Respon visual',
      anchor1: 'Perilaku visual normal sesuai usia.',
      anchor2: 'Abnormal ringan: kadang perlu diingatkan untuk melihat objek.',
      anchor3: 'Abnormal sedang: tatapan kosong/menghindar, tertarik cahaya.',
      anchor4: 'Abnormal berat: konsisten menghindari tatapan, sangat aneh.'),
  CarsArea(8, 'Respon pendengaran',
      anchor1: 'Perilaku mendengar normal sesuai usia.',
      anchor2: 'Abnormal ringan: respon suara kurang/berlebih sebagian.',
      anchor3: 'Abnormal sedang: respon suara bervariasi, kadang abai/terkejut.',
      anchor4: 'Abnormal berat: reaksi sangat berlebihan/tidak bereaksi.'),
  CarsArea(9, 'Respon rasa, bau, raba',
      anchor1: 'Eksplorasi & respon sentuh/bau/rasa sesuai usia.',
      anchor2: 'Abnormal ringan: memasukkan benda ke mulut, reaksi nyeri tak lazim.',
      anchor3: 'Abnormal sedang: cukup asyik menyentuh/mencium/merasakan.',
      anchor4: 'Abnormal berat: keasyikan berlebih; respon nyeri sangat aneh.'),
  CarsArea(10, 'Ketakutan dan kecemasan',
      anchor1: 'Rasa takut/cemas sesuai situasi dan usia.',
      anchor2: 'Abnormal ringan: takut/cemas sedikit lebih/kurang dari normal.',
      anchor3: 'Abnormal sedang: takut/cemas jelas lebih/kurang dari sewajarnya.',
      anchor4: 'Abnormal berat: takut menetap pada hal tak berbahaya / tak waspada bahaya.'),
  CarsArea(11, 'Komunikasi verbal',
      anchor1: 'Komunikasi verbal normal sesuai usia.',
      anchor2: 'Abnormal ringan: bicara terlambat; sebagian ekolalia.',
      anchor3: 'Abnormal sedang: bicara campur jargon/ekolalia/kata terbalik.',
      anchor4: 'Abnormal berat: tak memakai kata bermakna; suara aneh.'),
  CarsArea(12, 'Komunikasi non-verbal',
      anchor1: 'Komunikasi non-verbal normal sesuai usia.',
      anchor2: 'Abnormal ringan: menunjuk samar untuk yang diinginkan.',
      anchor3: 'Abnormal sedang: sulit ekspresikan kebutuhan non-verbal.',
      anchor4: 'Abnormal berat: gerak isyarat aneh, tak paham isyarat orang.'),
  CarsArea(13, 'Tingkat aktivitas',
      anchor1: 'Aktivitas normal sesuai usia dan keadaan.',
      anchor2: 'Abnormal ringan: agak gelisah atau agak lambat.',
      anchor3: 'Abnormal sedang: sangat aktif sulit dikendalikan / sangat letargi.',
      anchor4: 'Abnormal berat: aktivitas/inaktivitas ekstrem.'),
  CarsArea(14, 'Respon intelektual',
      anchor1: 'Kecerdasan normal dan konsisten di berbagai area.',
      anchor2: 'Abnormal ringan: agak terlambat di segala bidang.',
      anchor3: 'Abnormal sedang: umumnya terlambat, mendekati normal di 1 area.',
      anchor4: 'Abnormal berat: sangat tak merata; menonjol di 1-2 area saja.'),
  CarsArea(15, 'Kesan umum',
      anchor1: 'Bukan autistik: tidak ada karakteristik autisme.',
      anchor2: 'Autisme ringan: sedikit gejala.',
      anchor3: 'Autisme sedang: beberapa gejala.',
      anchor4: 'Autisme berat: banyak gejala/derajat ekstrem.'),
];
