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
  _TddBand(0, 3, '0-3 bulan', [
    'Apakah bayi dapat mengatakan "Aaaaa", "Ooooo"?',
    'Apakah bayi menatap wajah dan tampak mendengarkan Anda, lalu berbicara saat Anda diam? Apakah Anda dapat seolah-olah berbicara dengan bayi Anda?',
    'Apakah bayi kaget bila mendengar suara (mengejapkan mata, napas lebih cepat)?',
    'Apakah bayi kelihatan menoleh bila Anda berbicara di sebelahnya?',
    'Apakah bayi Anda dapat tersenyum?',
    'Apakah bayi Anda kenal dengan Anda, seperti tersenyum lebih cepat pada Anda dibandingkan orang lain?',
  ]),
  _TddBand(3, 6, '3-6 bulan', [
    'Apakah bayi Anda dapat tertawa keras?',
    'Apakah bayi dapat bermain menggelembungkan mulut seperti meniup balon?',
    'Apakah bayi memberi respons tertentu, seperti menjadi lebih riang bila Anda datang?',
    'Pemeriksa duduk menghadap bayi yang dipangku orang tuanya, bunyikan bel disamping tanpa terlihat bayi, apakah bayi itu menoleh ke samping?',
    'Pemeriksa menatap mata bayi sekitar 45 cm, lalu gunakan mainan untuk menarik pandangan bayi ke kiri, kanan, atas, dan bawah. Apakah bayi dapat mengikutinya?',
    'Apakah bayi berkedip bila pemeriksa melakukan gerakan menusuk mata, lalu berhenti sekitar 3 cm tanpa menyentuh mata?',
  ]),
  _TddBand(6, 12, '6-12 bulan', [
    'Apakah bayi dapat membuat suara berulang seperti \'mamamama\', \'babababa\'?',
    'Apakah bayi dapat memanggil mama atau papa, walaupun tidak untuk memanggil orang tuanya?',
    'Pemeriksa duduk mengahadap bayi yang dipangku orang tuanya, bunyikan bel di samping bawah tanpa terlihat bayi, apakah bayi langsung menoleh ke samping bawah?',
    'Apakah bayi mengikuti perintah tanpa dibantu gerakan badan, seperti "Stop, berikan mainanmu"?',
    'Apakah bayi mengikuti perintah dengan dibantu gerakan badan, seperti "Stop, berikan mainanmu"?',
    'Apakah bayi secara spontan memulai permainan dengan gerakan tubuh, seperti \'Pok Ame-Ame\' atau \'Cilukba\'?',
  ]),
  _TddBand(12, 18, '12-18 bulan', [
    'Apakah anak dapat memanggil \'mama\' atau \'papa\', hanya untuk memanggil orang tuanya?',
    'Apakah anak memulai menggunakan kata-kata lain, selain kata \'mama\', \'papa\', anggota keluarga lain, dan hewan peliharaan?',
    'Pemeriksa duduk menghadap bayi yang dipangku orang tuanya, bunyikan bel di samping bawah tanpa terlihat bayi, apakah bayi langsung menoleh ke samping bawah?',
    'Apakah anak mengikuti perintah tanpa dibantu gerakan badan, seperti "Stop, berikan mainanmu"?',
    'Apakah anak secara spontan memulai permainan dengan gerakan tubuh, seperti \'Pok Ame-Ame\' atau \'Cilukba\'?',
    'Apakah anak Anda menunjuk dengan jari telunjuk bila ingin sesuatu, bukan dengan cara memegang dengan semua jari?',
  ]),
  _TddBand(18, 24, '18-24 bulan', [
    'Apakah anak dapat mengucapkan 2 atau lebih kata yang menunjukkan keinginan, seperti "Susu", "Minum", "Lagi"?',
    'Apakah anak secara spontan mengatakan 2 kombinasi kata, seperti "Mau bobo", "Lihat Papa"?',
    'Apakah anak dapat menunjukkan paling sedikit 1 anggota badan, misal "Mana hidungmu?", "Mana matamu?" tanpa diberi contoh?',
    'Apakah anak dapat mengerjakan 2 macam perintah dalam satu kalimat, seperti "Ambil sepatumu dan taruh disini" tanpa diberi contoh?',
    'Apakah anak secara spontan memulai permainan dengan gerakan tubuh, seperti \'Pok Ame-Ame\' atau \'Cilukba\'?',
    'Apakah anak Anda menunjuk dengan jari telunjuk bila ingin sesuatu, bukan dengan cara memegang dengan semua jari?',
  ]),
  _TddBand(24, 30, '24-30 bulan', [
    'Apakah anak mulai menggunakan kata-kata lain, selain kata \'mama\', \'papa\', anggota keluarga lain, dan hewan peliharaan?',
    'Apakah anak mulai mengungkapkan kata yang berarti \'milik\' misal "Susu kamu", "Bonekaku"?',
    'Apakah anak dapat mengerjakan 2 macam perintah dalam satu kalimat, seperti "Ambil sepatu dan taruh disini" tanpa diberi contoh?',
    'Apakah anak dapat menunjuk minimal 2 nama benda di depannya (cangkir, bola, sendok)?',
    'Apakah anak secara spontan memulai permainan dengan gerakan tubuh, seperti \'Pok Ame-Ame\' atau \'Cilukba\'?',
    'Apakah anak Anda menunjuk dengan jari telunjuk bila ingin sesuatu, bukan dengan cara memegang dengan semua jari?',
  ]),
  _TddBand(30, 36, '30-36 bulan', [
    'Apakah anak dapat menyebutkan nama benda dan kegunaannya, seperi cangkir untuk minum, bola untuk dilempar, pensil warna untuk menggambar, sendok untuk makan?',
    'Apakah lebih dari tiga perempat orang mengerti apa yang dibicarakan anak Anda?',
    'Apakah anak dapat menunjukkan minimal 2 nama benda di depannya sesuai fungsinya (misal untuk minum: cangkir, untuk dilempar: bola, untuk makan: sendok, untuk menggambar: pensil warna)?',
    'Apakah anak dapat mengerjakan perintah yang disertai kata depan? (misal: "Sekarang kubus itu di bawah meja, tolong taruh di atas meja")?',
    'Apakah anak secara spontan memulai permainan dengan gerakan tubuh? Seperti \'Pok Ame-Ame\' atau \'Cilukba\'?',
    'Apakah anak Anda menunjuk dengan jari telunjuk bila ingin sesuatu, bukan dengan cara memegang dengan semua jari?',
  ]),
  _TddBand(36, 72, 'lebih dari 3 tahun', [
    'Apakah anak dapat menyebutkan nama benda dan kegunaannya, seperti cangkir untuk minum, bola untuk dilempar, pensil warna untuk menggambar, sendok untuk makan?',
    'Apakah lebih dari tiga perempat orang mengerti apa yang dibicarakan anak Anda?',
    'Apakah anak Anda dapat menunjukkan minimal 2 nama benda di depannya sesuai fungsi (misal untuk minum: cangkir, untuk dilempar: bola, untuk makan: sendok, untuk menggambar: pensil warna)?',
    'Apakah anak secara spontan memulai permainan dengan gerakan tubuh, seperti \'Pok Ame-Ame\' atau \'Cilukba\'?',
    'Apakah anak Anda menunjuk dengan jari telunjuk bila ingin sesuatu, bukan dengan cara memegang dengan semua jari?',
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
