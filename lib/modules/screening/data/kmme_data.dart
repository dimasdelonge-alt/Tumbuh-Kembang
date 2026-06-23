import '../instrument.dart';

/// Kuesioner Masalah Mental Emosional (KMME) — Kemenkes SDIDTK.
///
/// Untuk anak usia 36-72 bulan (3-6 tahun). 12 pertanyaan, jawaban "Ya"
/// menandakan masalah. Aturan tindak lanjut:
/// - 1 jawaban "Ya": konseling pola asuh + evaluasi ulang 3 bulan.
/// - >= 2 jawaban "Ya": rujuk ke fasilitas kesehatan jiwa/tumbuh kembang.
///
/// Sumber: Form KMME, Pedoman SDIDTK Kemenkes. Bebas digunakan.
const ScreeningInstrument kmmeInstrument = ScreeningInstrument(
  id: 'kmme',
  name: 'KMME (Masalah Mental Emosional)',
  shortDescription:
      'Kuesioner Masalah Mental Emosional anak usia 3-6 tahun (SDIDTK).',
  minAgeMonths: 36,
  maxAgeMonths: 72,
  items: [
    ScreeningItem(1,
        'Apakah anak seringkali terlihat marah tanpa sebab yang jelas? '
        '(banyak menangis, mudah tersinggung, atau bereaksi berlebihan '
        'terhadap hal yang sudah biasa dihadapinya)'),
    ScreeningItem(2,
        'Apakah anak tampak menghindar dari teman atau anggota keluarganya? '
        '(ingin menyendiri, merasa sedih sepanjang waktu, kehilangan minat '
        'terhadap hal yang biasa dinikmati)'),
    ScreeningItem(3,
        'Apakah anak berperilaku merusak dan menentang lingkungan sekitarnya? '
        '(melanggar peraturan, mencuri, melakukan perbuatan berbahaya, '
        'menyiksa binatang/anak lain, dan tidak peduli nasihat)'),
    ScreeningItem(4,
        'Apakah anak memperlihatkan ketakutan atau kecemasan berlebihan yang '
        'tidak dapat dijelaskan asalnya dan tidak sebanding dengan anak '
        'seusianya?'),
    ScreeningItem(5,
        'Apakah anak mengalami konsentrasi yang buruk atau mudah teralih '
        'perhatiannya, sehingga menurunkan aktivitas sehari-hari atau prestasi '
        'belajarnya?'),
    ScreeningItem(6,
        'Apakah anak menunjukkan perilaku kebingungan sehingga sulit '
        'berkomunikasi dan membuat keputusan?'),
    ScreeningItem(7,
        'Apakah anak menunjukkan perubahan pola tidur? '
        '(sulit tidur, terjaga sepanjang hari, sering terbangun malam karena '
        'mimpi buruk, mengigau)'),
    ScreeningItem(8,
        'Apakah anak mengalami perubahan pola makan? '
        '(kehilangan nafsu makan, makan berlebihan, atau tidak mau makan)'),
    ScreeningItem(9,
        'Apakah anak seringkali mengeluh sakit kepala, sakit perut, atau '
        'keluhan fisik lainnya?'),
    ScreeningItem(10,
        'Apakah anak seringkali mengeluh putus asa atau berkeinginan '
        'mengakhiri hidupnya?'),
    ScreeningItem(11,
        'Apakah anak menunjukkan kemunduran perilaku atau kemampuan yang sudah '
        'dimilikinya? (mengompol kembali, mengisap jempol, tidak mau berpisah '
        'dengan orang tua/pengasuh)'),
    ScreeningItem(12,
        'Apakah anak melakukan perbuatan yang berulang-ulang tanpa alasan yang '
        'jelas?'),
  ],
  bands: [
    ScoreBand(
      minScore: 0,
      level: RiskLevel.low,
      interpretation: 'Tidak ditemukan masalah mental emosional.',
      recommendation:
          'Lanjutkan pola asuh yang mendukung perkembangan anak. '
          'Skrining ulang sesuai jadwal rutin.',
    ),
    ScoreBand(
      minScore: 1,
      level: RiskLevel.medium,
      interpretation: 'Ditemukan 1 masalah mental emosional.',
      recommendation:
          'Lakukan konseling pada orang tua memakai Pedoman Pola Asuh. '
          'Evaluasi ulang setelah 3 bulan; bila tidak ada perubahan, rujuk ke '
          'RS dengan fasilitas kesehatan jiwa/tumbuh kembang anak.',
    ),
    ScoreBand(
      minScore: 2,
      level: RiskLevel.high,
      interpretation: 'Ditemukan 2 atau lebih masalah mental emosional.',
      recommendation:
          'Rujuk ke RS dengan fasilitas kesehatan jiwa/tumbuh kembang anak. '
          'Sertakan informasi jumlah dan jenis masalah yang ditemukan.',
    ),
  ],
);
