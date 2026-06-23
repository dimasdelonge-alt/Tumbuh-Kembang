import '../instrument.dart';

/// GPPH — Deteksi Dini Gangguan Pemusatan Perhatian & Hiperaktivitas.
/// Abbreviated Conners Rating Scale versi pedoman Kemenkes SDIDTK.
///
/// 10 pertanyaan, masing-masing dinilai skala 0-3:
///   0 = tidak ditemukan, 1 = kadang-kadang, 2 = sering, 3 = selalu.
/// Skor = jumlah seluruh nilai (0-30).
/// Ambang: nilai total >= 13 menandakan kemungkinan GPPH/ADHD (perlu rujukan).
///
/// Sumber: Buku Pedoman Deteksi Dini GPPH, SDIDTK Kemenkes. Versi Abbreviated
/// Conners pada pedoman ini bebas dipakai untuk skrining GPPH (konfirmasi
/// klinis dokter). Untuk anak usia sekolah (umumnya >= 36 bulan).
const ScreeningInstrument gpphInstrument = ScreeningInstrument(
  id: 'gpph',
  name: 'GPPH (Abbreviated Conners)',
  shortDescription:
      'Deteksi dini gangguan pemusatan perhatian & hiperaktivitas. '
      'Nilai tiap perilaku: 0 tidak ada, 1 kadang, 2 sering, 3 selalu.',
  minAgeMonths: 36,
  maxAgeMonths: 216,
  responseType: ResponseType.likert4,
  items: [
    ScreeningItem(1, 'Tidak kenal lelah, atau aktivitas yang berlebihan.'),
    ScreeningItem(2, 'Mudah menjadi gembira, impulsif.'),
    ScreeningItem(3, 'Mengganggu anak-anak lain.'),
    ScreeningItem(4,
        'Gagal menyelesaikan kegiatan yang telah dimulai, rentang perhatian pendek.'),
    ScreeningItem(5,
        'Menggerak-gerakkan anggota badan atau kepala secara terus-menerus.'),
    ScreeningItem(6, 'Kurang perhatian, mudah teralihkan.'),
    ScreeningItem(7,
        'Permintaannya harus segera dipenuhi, mudah menjadi frustrasi.'),
    ScreeningItem(8, 'Sering dan mudah menangis.'),
    ScreeningItem(9, 'Suasana hatinya mudah berubah dengan cepat dan drastis.'),
    ScreeningItem(10,
        'Ledakan kekesalan, tingkah laku eksplosif dan tak terduga.'),
  ],
  bands: [
    ScoreBand(
      minScore: 0,
      level: RiskLevel.low,
      interpretation: 'Nilai total < 13: kemungkinan GPPH kecil.',
      recommendation:
          'Tidak ada tanda GPPH yang menonjol saat ini. Lanjutkan pemantauan '
          'dan ulangi bila ada kekhawatiran perilaku.',
    ),
    ScoreBand(
      minScore: 13,
      level: RiskLevel.high,
      interpretation:
          'Nilai total >= 13: kemungkinan terdapat GPPH/ADHD.',
      recommendation:
          'Rujuk untuk evaluasi lebih lanjut (pemeriksaan klinis & diagnostik '
          'GPPH/ADHD oleh spesialis).',
    ),
  ],
);
