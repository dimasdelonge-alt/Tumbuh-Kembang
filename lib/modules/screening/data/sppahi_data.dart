import '../instrument.dart';

/// SPPAHI — Skala Penilaian Perilaku Anak Hiperaktif Indonesia.
///
/// 35 pernyataan, dinilai untuk perilaku 6 bulan terakhir dengan skala 0-3:
///   0 = sama sekali tidak/sangat jarang, 1 = kadang-kadang,
///   2 = seringkali, 3 = selalu demikian.
/// Skor = jumlah seluruh nilai (0-105).
///
/// Cut-off (kemungkinan GPPH) BERGANTUNG penilai:
///   - Guru   : >= 29
///   - Orangtua: >= 30
///   - Dokter umum: >= 22
///
/// Sumber: SPPAHI (Skala Penilaian Perilaku Anak Hiperaktif Indonesia).
/// Bebas dipakai untuk skrining GPPH.
const ScreeningInstrument sppahiInstrument = ScreeningInstrument(
  id: 'sppahi',
  name: 'SPPAHI (Perilaku Hiperaktif)',
  shortDescription:
      'Skala Penilaian Perilaku Anak Hiperaktif Indonesia. Nilai tiap perilaku '
      '6 bulan terakhir: 0 tidak/sangat jarang, 1 kadang, 2 sering, 3 selalu.',
  minAgeMonths: 48,
  maxAgeMonths: 216,
  responseType: ResponseType.likert4,
  raterOptions: ['Dokter', 'Orang tua', 'Guru'],
  raterCutoffs: {'Dokter': 22, 'Orang tua': 30, 'Guru': 29},
  items: [
    ScreeningItem(1,
        'Sering sulit mempertahankan perhatian pada waktu melaksanakan tugas atau kegiatan bermain-main.'),
    ScreeningItem(2,
        'Sering berlari-lari atau memanjat secara berlebihan pada situasi yang tidak sesuai.'),
    ScreeningItem(3, 'Gagal menyelesaikan sesuatu yang telah dimulai.'),
    ScreeningItem(4,
        'Sering gagal memberi perhatian pada hal kecil atau ceroboh dalam menyelesaikan tugas sekolah/pekerjaan.'),
    ScreeningItem(5,
        'Sering seolah-olah tidak memperhatikan orang pada waktu diajak berbicara.'),
    ScreeningItem(6,
        'Sering lambat menyelesaikan tugas di sekolah (mencatat, menyalin, mengerjakan soal).'),
    ScreeningItem(7, 'Kemampuan sosialisasi buruk.'),
    ScreeningItem(8, 'Sering lupa tentang sesuatu yang telah disetujui.'),
    ScreeningItem(9,
        'Menghindari/enggan/kesulitan melaksanakan tugas yang membutuhkan ketekunan berkesinambungan.'),
    ScreeningItem(10, 'Membutuhkan bimbingan penuh untuk menyelesaikan tugas.'),
    ScreeningItem(11,
        'Mengalami kesulitan bermain atau melakukan kegiatan dengan tenang di waktu senggang.'),
    ScreeningItem(12, 'Mudah terangsang dan impulsif (bertindak tanpa berpikir).'),
    ScreeningItem(13,
        'Sering melontarkan jawaban terburu-buru terhadap pertanyaan yang belum selesai diungkapkan.'),
    ScreeningItem(14,
        'Meninggalkan tempat duduk di kelas/situasi lain di mana diharapkan tetap duduk diam.'),
    ScreeningItem(15,
        'Mengalami kesulitan antri atau menunggu giliran dalam bermain/situasi kelompok.'),
    ScreeningItem(16, 'Sering perhatiannya mudah terpecah atau terbagi.'),
    ScreeningItem(17, 'Mudah tersinggung dan terganggu oleh orang lain.'),
    ScreeningItem(18,
        'Tidak mampu menyelesaikan pekerjaan dengan baik tanpa bantuan orang lain.'),
    ScreeningItem(19, 'Tidak dapat menyelesaikan tugas sesuai dengan waktunya.'),
    ScreeningItem(20, 'Tidak dapat mengikuti perintah secara berurutan.'),
    ScreeningItem(21,
        'Perhatiannya mudah beralih ketika diberi petunjuk untuk mengerjakan sesuatu.'),
    ScreeningItem(22,
        'Perhatiannya sering mudah dialihkan oleh rangsangan dari luar.'),
    ScreeningItem(23, 'Sering ceroboh atau tidak teliti dalam mengerjakan tugas.'),
    ScreeningItem(24, 'Tidak pernah bisa diam, tidak mengenal lelah.'),
    ScreeningItem(25,
        'Sering menghilangkan benda yang diperlukan untuk tugas/kegiatan (pensil, buku, alat bermain).'),
    ScreeningItem(26,
        'Sering seperti tidak mendengarkan pada waktu diajak berbicara secara langsung.'),
    ScreeningItem(27, 'Sering gagal menyelesaikan tugas.'),
    ScreeningItem(28,
        'Selalu dalam keadaan "siap gerak" atau aktivitasnya seperti digerakkan oleh mesin.'),
    ScreeningItem(29, 'Sulit dikendalikan saat berada di mall atau sedang berbelanja.'),
    ScreeningItem(30,
        'Sering menyela/memaksakan diri terhadap orang lain (memotong percakapan, mengganggu permainan).'),
    ScreeningItem(31, 'Sering usil, mengganggu anak lain di dalam kelas.'),
    ScreeningItem(32, 'Terlalu aktif atau aktivitas berlebihan.'),
    ScreeningItem(33,
        'Tidak mampu mengikuti petunjuk dan gagal menyelesaikan tugas sekolah (bukan karena menentang/tidak paham).'),
    ScreeningItem(34,
        'Tidak bisa duduk diam (kaki dan tangannya tidak bisa diam atau selalu digerakkan).'),
    ScreeningItem(35, 'Sering bengong pada waktu melaksanakan tugas.'),
  ],
  bands: [
    ScoreBand(
      minScore: 0,
      level: RiskLevel.low,
      interpretation: 'Skor di bawah cut-off penilai: kemungkinan GPPH kecil.',
      recommendation:
          'Tidak ada indikasi GPPH yang menonjol saat ini. Lanjutkan pemantauan '
          'dan ulangi bila ada kekhawatiran perilaku.',
    ),
    ScoreBand(
      minScore: 1,
      level: RiskLevel.high,
      interpretation:
          'Skor mencapai/melebihi cut-off penilai: kemungkinan GPPH.',
      recommendation:
          'Rujuk untuk evaluasi lebih lanjut (pemeriksaan klinis & diagnostik '
          'GPPH/ADHD oleh spesialis).',
    ),
  ],
);
