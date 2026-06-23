import '../instrument.dart';

/// M-CHAT-R (Modified Checklist for Autism in Toddlers, Revised) — tahap 1.
///
/// HAK CIPTA: © 2009 Diana Robins, Deborah Fein, & Marianne Barton.
/// Terjemahan Indonesia: Soetjiningsih, Trisna Windiani, Sugitha Adnyana,
/// & Apik Lestari (2014).
///
/// PENTING (lisensi): instrumen ini berhak cipta. Boleh dicantumkan pada rekam
/// medis elektronik untuk pemakaian DI DALAM praktek sendiri. Bila aplikasi
/// akan DIDISTRIBUSIKAN di luar praktek pribadi, WAJIB mengurus lisensi ke
/// Diana Robins (mchatscreen2009@gmail.com). Pertanyaan tidak boleh diubah dan
/// harus digunakan utuh (20 item). Lihat www.mchatscreen.com.
///
/// Algoritma skoring: untuk semua item KECUALI 2, 5, dan 12, jawaban "TIDAK"
/// menandakan risiko ASD; untuk item 2, 5, 12, jawaban "YA" menandakan risiko.
/// - 0-2  : risiko rendah
/// - 3-7  : risiko sedang (lakukan Follow-Up / M-CHAT-R/F tahap 2)
/// - 8-20 : risiko tinggi (rujuk segera untuk evaluasi diagnostik)
///
/// Berlaku untuk anak usia 16-30 bulan.

const String mchatId = 'mchat_r';

const ScreeningInstrument mchatInstrument = ScreeningInstrument(
  id: mchatId,
  name: 'M-CHAT-R (Skrining Autisme)',
  shortDescription:
      'Modified Checklist for Autism in Toddlers, Revised. Untuk anak usia '
      '16-30 bulan. Diisi oleh orang tua.',
  minAgeMonths: 16,
  maxAgeMonths: 30,
  copyrightNotice:
      '© 2009 Diana Robins, Deborah Fein, & Marianne Barton. Terjemahan: '
      'Soetjiningsih dkk. (2014). Digunakan untuk skrining klinis; '
      'distribusi di luar praktek pribadi memerlukan lisensi '
      '(www.mchatscreen.com).',
  items: [
    ScreeningItem(1,
        'Jika anda menunjuk sesuatu di ruangan, apakah anak melihatnya? '
        '(mis. menunjuk hewan/mainan, apakah anak melihat ke arahnya?)',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(2, 'Pernahkah anda berpikir bahwa anak anda tuli?',
        riskAnswer: RiskAnswer.ya),
    ScreeningItem(3,
        'Apakah anak pernah bermain pura-pura? (mis. pura-pura minum dari '
        'gelas kosong, bicara di telepon, menyuapi boneka)',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(4,
        'Apakah anak suka memanjat benda? (mis. furniture, alat bermain, tangga)',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(5,
        'Apakah anak menggerakkan jari tangannya dengan cara tidak biasa di '
        'dekat matanya? (mis. menggoyangkan jari dekat mata)',
        riskAnswer: RiskAnswer.ya),
    ScreeningItem(6,
        'Apakah anak pernah menunjuk dengan satu jari untuk meminta sesuatu '
        'atau minta tolong? (mis. menunjuk makanan/mainan di luar jangkauan)',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(7,
        'Apakah anak pernah menunjuk dengan satu jari untuk menunjukkan sesuatu '
        'yang menarik? (mis. pesawat di langit, truk di jalan)',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(8,
        'Apakah anak tertarik pada anak lain? (memperhatikan, tersenyum, atau '
        'mendekati anak lain)',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(9,
        'Apakah anak pernah memperlihatkan benda dengan membawa/mengangkatnya '
        'kepada anda — bukan minta tolong, hanya untuk berbagi?',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(10,
        'Apakah anak memberikan respon jika namanya dipanggil? (melihat, '
        'bicara/bergumam, atau menghentikan kegiatannya)',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(11,
        'Saat anda tersenyum pada anak, apakah anak tersenyum balik?',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(12,
        'Apakah anak pernah marah saat mendengar suara bising sehari-hari? '
        '(mis. berteriak/menangis saat vacuum cleaner atau musik keras)',
        riskAnswer: RiskAnswer.ya),
    ScreeningItem(13, 'Apakah anak anda bisa berjalan?',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(14,
        'Apakah anak menatap mata anda saat anda bicara padanya, bermain, atau '
        'memakaikan pakaian?',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(15,
        'Apakah anak mencoba meniru apa yang anda lakukan? (mis. melambai, '
        'tepuk tangan, meniru suara lucu)',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(16,
        'Jika anda memutar kepala untuk melihat sesuatu, apakah anak melihat '
        'sekeliling untuk melihat apa yang anda lihat?',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(17,
        'Apakah anak mencoba membuat anda melihat kepadanya? (mis. melihat anda '
        'untuk dipuji, atau berkata "lihat aku")',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(18,
        'Apakah anak mengerti saat anda memintanya melakukan sesuatu tanpa '
        'isyarat? (mis. "letakkan buku di atas kursi", "ambilkan saya selimut")',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(19,
        'Jika sesuatu yang baru terjadi, apakah anak menatap wajah anda untuk '
        'melihat perasaan anda? (mis. saat mendengar bunyi aneh/melihat mainan baru)',
        riskAnswer: RiskAnswer.tidak),
    ScreeningItem(20,
        'Apakah anak menyukai aktivitas yang bergerak? (mis. diayun atau '
        'dihentak-hentakkan pada lutut anda)',
        riskAnswer: RiskAnswer.tidak),
  ],
  bands: [
    ScoreBand(
      minScore: 0,
      level: RiskLevel.low,
      interpretation: 'Risiko rendah ASD (skor 0-2).',
      recommendation:
          'Tidak ada tindakan lanjutan khusus, kecuali surveilans rutin. '
          'Bila anak < 24 bulan, skrining ulang setelah ulang tahun kedua.',
    ),
    ScoreBand(
      minScore: 3,
      level: RiskLevel.medium,
      interpretation: 'Risiko sedang ASD (skor 3-7).',
      recommendation:
          'Lakukan wawancara Follow-Up (M-CHAT-R/F tahap 2). Bila skor '
          'Follow-Up tetap >= 2, rujuk untuk evaluasi diagnostik & intervensi '
          'dini. Bila 0-1, skrining ulang pada kunjungan berikutnya.',
    ),
    ScoreBand(
      minScore: 8,
      level: RiskLevel.high,
      interpretation: 'Risiko tinggi ASD (skor 8-20).',
      recommendation:
          'Follow-Up dapat dilewati; rujuk SEGERA untuk evaluasi diagnostik '
          'dan evaluasi eligibilitas intervensi dini.',
    ),
  ],
);
