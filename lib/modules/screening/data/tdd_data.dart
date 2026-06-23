import '../instrument.dart';

/// Tes Daya Dengar (TDD) — Kemenkes SDIDTK.
///
/// Pertanyaan dikelompokkan per rentang usia. Untuk SEMUA pertanyaan, jawaban
/// "Tidak" menandakan kemungkinan gangguan pendengaran. Interpretasi bersifat
/// biner: bila ada minimal satu jawaban "Tidak", anak dirujuk.
///
/// Karena item bergantung usia, gunakan [tddInstrumentForAge] untuk memilih
/// set pertanyaan yang sesuai. Kode instrumen tetap 'tdd' agar konsisten di DB.
/// Sumber: Instrumen TDD, Pedoman SDIDTK Kemenkes. Bebas digunakan.

const String tddId = 'tdd';

/// Band interpretasi TDD (independen usia): 0 "Tidak" = normal, >=1 = rujuk.
const List<ScoreBand> _tddBands = [
  ScoreBand(
    minScore: 0,
    level: RiskLevel.low,
    interpretation: 'Daya dengar dalam batas normal sesuai usia.',
    recommendation:
        'Lanjutkan pemantauan rutin. Ulangi TDD sesuai jadwal '
        '(tiap 3 bulan < 12 bulan; tiap 6 bulan >= 12 bulan).',
  ),
  ScoreBand(
    minScore: 1,
    level: RiskLevel.high,
    interpretation:
        'Terdapat jawaban "Tidak" — kemungkinan gangguan pendengaran.',
    recommendation:
        'Rujuk ke fasilitas kesehatan yang lebih lengkap untuk pemeriksaan '
        'pendengaran lebih lanjut.',
  ),
];

class _TddBand {
  final int minMonths;
  final int maxMonths;
  final String label;
  final List<String> questions;
  const _TddBand(this.minMonths, this.maxMonths, this.label, this.questions);
}

const List<_TddBand> _bands = [
  _TddBand(0, 6, '0-6 bulan', [
    'Pada waktu bayi tidur lalu anda berbicara/membuat kegaduhan, apakah bayi bergerak atau terbangun?',
    'Saat bayi telentang dan anda bertepuk tangan keras dari posisi tak terlihat, apakah bayi terkejut/mengedipkan mata/menegangkan tubuh?',
    'Bila ada suara nyaring (batuk, salak anjing, piring jatuh), apakah bayi terkejut atau terlompat?',
  ]),
  _TddBand(6, 9, '6-9 bulan', [
    'Pada waktu bayi tidur lalu anda berbicara/membuat kegaduhan, apakah bayi bergerak atau terbangun?',
    'Saat bayi telentang dan anda bertepuk tangan keras dari posisi tak terlihat, apakah bayi terkejut/mengedipkan mata/menegangkan tubuh?',
    'Bila ada suara nyaring, apakah bayi terkejut atau terlompat?',
    'Dari sisi yang tak terlihat bayi, sebut namanya atau bunyikan sesuatu — apakah bayi memalingkan kepala mencari sumber suara?',
  ]),
  _TddBand(9, 12, '9-12 bulan', [
    'Pada waktu bayi tidur lalu anda berbicara/membuat kegaduhan, apakah bayi bergerak atau terbangun?',
    'Saat bayi telentang dan anda bertepuk tangan keras dari posisi tak terlihat, apakah bayi terkejut/mengedipkan mata/menegangkan tubuh?',
    'Bila ada suara nyaring, apakah bayi terkejut atau terlompat?',
    'Dari samping/belakang bayi tanpa terlihat, sebut namanya atau bunyikan sesuatu — apakah bayi langsung memalingkan kepala ke arah suara?',
  ]),
  _TddBand(12, 24, '12-24 bulan', [
    'Pada waktu anak tidur lalu anda berbicara/membuat kegaduhan, apakah anak bergerak atau terbangun?',
    'Saat anak telentang dan anda bertepuk tangan keras dari posisi tak terlihat, apakah anak terkejut/mengedipkan mata/menegangkan tubuh?',
    'Bila ada suara nyaring, apakah anak terkejut atau terlompat?',
    'Tanpa terlihat anak, buat suara menarik perhatian — apakah anak langsung mengetahui posisi sumber suara yang berpindah-pindah?',
    'Ucapkan kata-kata yang mudah dan sederhana — dapatkah anak menirukan anda?',
  ]),
  _TddBand(24, 36, '2-3 tahun', [
    'Tutup mulut anda dengan buku/kertas, tanpa terlihat gerak bibir, minta anak "Pegang matamu", "Pegang kakimu" — apakah anak melakukannya dengan benar?',
    'Tutup mulut anda, minta anak menunjukkan gambar (kucing/anjing/mobil/rumah dll) di majalah — dapatkah anak menunjukkan gambar yang dimaksud dengan benar?',
    'Tutup mulut anda, perintahkan sesuatu ("Berikan boneka itu", "Taruh kubus di atas meja") — apakah anak mengerjakan perintah dengan benar?',
  ]),
  _TddBand(36, 72, 'lebih dari 3 tahun', [
    'Perlihatkan benda di sekeliling (sendok, cangkir, bola, bunga) dan minta anak menyebutkan namanya — apakah anak dapat menyebut dengan benar?',
    'Dari jarak 3 meter, tutup mulut anda dengan buku/kertas, ucapkan 4 angka berlainan — dapatkah anak mengulangi atau menirukan dengan jari tangannya?',
  ]),
];

/// Pilih band TDD sesuai [ageMonths]; mengembalikan band terdekat bila di luar.
_TddBand _bandForAge(int ageMonths) {
  for (final b in _bands) {
    if (ageMonths >= b.minMonths && ageMonths < b.maxMonths) return b;
  }
  return ageMonths < _bands.first.minMonths ? _bands.first : _bands.last;
}

/// Bangun instrumen TDD untuk usia tertentu (item sesuai kelompok usia).
ScreeningInstrument tddInstrumentForAge(int ageMonths) {
  final band = _bandForAge(ageMonths);
  return ScreeningInstrument(
    id: tddId,
    name: 'TDD (Tes Daya Dengar)',
    variantLabel: band.label,
    shortDescription:
        'Tes Daya Dengar SDIDTK. Jawaban "Tidak" menandakan kemungkinan '
        'gangguan pendengaran.',
    minAgeMonths: band.minMonths,
    maxAgeMonths: band.maxMonths,
    items: [
      for (var i = 0; i < band.questions.length; i++)
        ScreeningItem(i + 1, band.questions[i], riskAnswer: RiskAnswer.tidak),
    ],
    bands: _tddBands,
  );
}

/// Label band TDD untuk usia tertentu (untuk rekonstruksi laporan).
String tddVariantLabelForAge(int ageMonths) => _bandForAge(ageMonths).label;

/// Instrumen TDD representatif untuk registry/laporan (band independen usia).
ScreeningInstrument tddRegistryInstrument() => tddInstrumentForAge(36);
