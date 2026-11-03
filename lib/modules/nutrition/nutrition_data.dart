library;

/// Data statis untuk Modul Pemenuhan Nutrisi (Asuhan Nutrisi Pediatrik).
///
/// Sumber:
/// - MPASI & Pangan 6–23 Bulan: WHO Guideline for Complementary Feeding of Infants and Young Children 6–23 Months of Age (2023)
/// - Resep MPASI & Pangan Lokal: Buku Resep Makanan Lokal Balita & Ibu Hamil Kemenkes RI (2023)
/// - Tabel AKG: Permenkes RI Nomor 28 Tahun 2019
/// - Feeding Rules & ANP: Rekomendasi IDAI (Ikatan Dokter Anak Indonesia)
/// - Suplementasi Mikronutrien: Rekomendasi IDAI & WHO 2023


// ─────────────────────────────────────────────
// 7 PRINSIP MPASI WHO GUIDELINE (2023)
// "WHO Guideline for Complementary Feeding of Infants and Young Children 6–23 Months of Age"
// ─────────────────────────────────────────────

class WhoGuidelinePrinciple {
  final int number;
  final String title;
  final String recommendation;
  final String strengthAndCertainty;
  final List<String> details;

  const WhoGuidelinePrinciple({
    required this.number,
    required this.title,
    required this.recommendation,
    required this.strengthAndCertainty,
    required this.details,
  });
}

const List<WhoGuidelinePrinciple> whoComplementaryFeedingPrinciples = [
  WhoGuidelinePrinciple(
    number: 1,
    title: 'Kelanjutan Pemberian ASI (Continued Breastfeeding)',
    recommendation: 'Pemberian ASI sebaiknya terus dilanjutkan hingga anak berusia 2 tahun atau lebih.',
    strengthAndCertainty: 'Strong recommendation, very low certainty evidence',
    details: [
      'Menyumbang proporsi energi substansial: 77% pada 6-8 bulan, 63% pada 9-11 bulan, dan 44% pada 12-23 bulan.',
      'Memenuhi ~70% kebutuhan Vit A, ~40% Kalsium, & ~37% Riboflavin pada tahun kedua, serta asam lemak esensial (DHA/ALA) untuk otak.',
      'Melindungi anak dari infeksi saluran napas dan gastrointestinal.',
      'Mendukung hak ibu dengan ruang laktasi, jadwal kerja fleksibel, dan perlindungan dari pemasaran agresif susu pengganti ASI.',
    ],
  ),
  WhoGuidelinePrinciple(
    number: 2,
    title: 'Ketentuan Susu Non-ASI (Milks for Non-Breastfed Children)',
    recommendation: 'Usia 6–11 bulan: susu formula bayi atau susu hewani full-fat. Usia 12–23 bulan: susu hewani pasteurisasi murni; Formula lanjutan (follow-up formula) TIDAK direkomendasikan.',
    strengthAndCertainty: 'Conditional recommendation, low certainty evidence',
    details: [
      'Jenis susu hewan: Susu sapi pasteurisasi murni full-cream, susu fermentasi tawar, atau yogurt alami.',
      'Usia 12–23 bulan: WHO secara eksplisit TIDAK merekomendasikan formula lanjutan (susu formula 1-3 tahun komersial).',
      'Dilarang memberikan susu kental manis, susu berperisa (cokelat/stroberi), atau susu dengan tambahan gula.',
      'Batasi volume susu (maksimal 400-500 mL/hari) agar anak tidak kenyang cairan dan tetap bernafsu makan makanan padat.',
    ],
  ),
  WhoGuidelinePrinciple(
    number: 3,
    title: 'Usia Pengenalan MPASI (Age of Introduction)',
    recommendation: 'Bayi harus mulai diperkenalkan makanan pendamping ASI (MPASI) tepat pada usia 6 bulan (180 hari) sambil terus disusui.',
    strengthAndCertainty: 'Strong recommendation, low certainty evidence',
    details: [
      'Pada usia 6 bulan, kebutuhan energi dan zat gizi (terutama zat besi & seng) melampaui yang disediakan oleh ASI saja.',
      'Pengenalan dini (< 6 bulan) tidak mencegah anemia dan meningkatkan risiko infeksi atau penyapihan dini.',
      'Kebutuhan zat besi bayi aterm sangat tinggi; utamakan protein hewani kaya zat besi heme sejak hari pertama MPASI.',
    ],
  ),
  WhoGuidelinePrinciple(
    number: 4,
    title: 'Keragaman Makanan & Kualitas Pangan (Dietary Diversity)',
    recommendation: 'Anak 6–23 bulan harus mengonsumsi makanan beraneka ragam: Pangan Hewani (ASF) setiap hari, Buah & Sayuran setiap hari, serta Kacang/Biji-bijian secara berkala.',
    strengthAndCertainty: 'Strong recommendation (ASF & Buah/Sayur), Conditional (Kacang/Biji)',
    details: [
      'Pangan Hewani (ASF: daging merah, ayam, telur, ikan, hati): WAJIB dikonsumsi SETIAP HARI sebagai sumber zat besi, seng, protein berkualitas, dan Vit B12.',
      'Buah & Sayuran: WAJIB dikonsumsi SETIAP HARI, khususnya yang kaya vitamin A dan vitamin C.',
      'Minimalkan Makanan Pokok Bertepung (starchy staples): Nasi, serealia, atau umbi-umbian jangan mendominasi isi piring karena densitas nutrisi rendah dan mengandung fitat.',
      'Kacang-kacangan & biji-bijian: Diberikan teratur dalam tekstur aman tanpa risiko tersedak (puree/lumat).',
    ],
  ),
  WhoGuidelinePrinciple(
    number: 5,
    title: 'Pembatasan Makanan & Minuman Tidak Sehat (Unhealthy Foods)',
    recommendation: 'Makanan tinggi gula, garam, dan lemak trans TIDAK BOLEH dikonsumsi. Minuman manis (SSB) dan pemanis buatan DILARANG. Jus buah 100% sangat dibatasi.',
    strengthAndCertainty: 'Strong recommendation (Gula/Garam/Trans/SSB), Conditional (Jus Buah)',
    details: [
      'Tanpa tambahan gula meja, pemanis sintetis, atau garam berlebih pada masakan MPASI.',
      'Larang keras minuman berpemanis (Sugar-Sweetened Beverages/SSBs): teh manis, soda, kental manis, sari buah kemasan.',
      'Mencegah karies gigi dini, obesitas anak, preferensi rasa manis berlebih, dan risiko penyakit tidak menular (hipertensi/diabetes).',
      'Jus buah 100% sebaiknya diganti dengan buah potong utuh untuk menjaga serat alami.',
    ],
  ),
  WhoGuidelinePrinciple(
    number: 6,
    title: 'Suplementasi Mikronutrien & Fortifikasi Selektif (Nutrient Supplements)',
    recommendation: 'Jika kebutuhan gizi tidak terpenuhi dari makanan lokal unfortified, anak 6–23 bulan dapat menerima suplemen mikronutrien (MNP/Fe/Vit D) atau pangan terfortifikasi.',
    strengthAndCertainty: 'Context-specific recommendation, moderate-to-high certainty evidence',
    details: [
      'Tabur gizi (Multiple Micronutrient Powders/MNP) dan suplemen tetes Zat Besi rutin IDAI (2 mg/kgBB/hari) untuk pencegahan stunting & anemia.',
      'Suplementasi Vitamin D (400-600 IU/hari) sesuai indikasi IDAI.',
      'Suplemen mikronutrien bersifat pelengkap dan tidak pernah menggantikan piring makanan segar yang beragam.',
    ],
  ),
  WhoGuidelinePrinciple(
    number: 7,
    title: 'Pemberian Makan Responsif (Responsive Feeding)',
    recommendation: 'Anak 6–23 bulan harus diberi makan secara responsif: mendukung kemandirian makan otonom dan peka terhadap sinyal lapar serta kenyang fisiologis anak.',
    strengthAndCertainty: 'Strong recommendation, low certainty evidence',
    details: [
      'Mendukung regulasi nafsu makan mandiri (self-regulation) serta perkembangan kognitif, emosional, dan sosial anak.',
      'Pengasuh hadir mendampingi secara sabar, hangat, tersenyum, dan mempertahankan kontak mata.',
      'Dilarang memaksa makan (no force-feeding), tidak mengancam, dan tidak menggunakan gadget/TV sebagai distraksi.',
      'Dorong anak memegang makanan sendiri (finger food) atau menggunakan sendok kecil sesuai tahap perkembangannya.',
    ],
  ),
];

// ─────────────────────────────────────────────
// BASIC FEEDING RULES IDAI
// ─────────────────────────────────────────────

class FeedingRule {
  final int number;
  final String category; // 'Jadwal', 'Lingkungan', 'Prosedur'
  final String title;
  final String description;

  const FeedingRule({
    required this.number,
    required this.category,
    required this.title,
    required this.description,
  });
}

const List<FeedingRule> feedingRules = [
  // JADWAL
  FeedingRule(
    number: 1,
    category: 'Jadwal',
    title: 'Jadwal makan teratur',
    description: 'Buat jadwal rutin: 3 kali makan utama dan 1–2 kali '
        'selingan/snack per hari. Jeda antar waktu makan 2–3 jam.',
  ),
  FeedingRule(
    number: 2,
    category: 'Jadwal',
    title: 'Durasi makan maksimal 30 menit',
    description: 'Batasi setiap sesi makan maksimal 30 menit. '
        'Jika anak belum selesai, akhiri sesi makan dengan netral.',
  ),
  FeedingRule(
    number: 3,
    category: 'Jadwal',
    title: 'Hanya ASI/susu & air putih di antara waktu makan',
    description: 'Di luar jadwal makan, hanya berikan ASI, susu, atau air '
        'putih. Hindari jus, minuman manis, atau camilan di luar jadwal.',
  ),
  // LINGKUNGAN
  FeedingRule(
    number: 4,
    category: 'Lingkungan',
    title: 'Lingkungan makan menyenangkan',
    description: 'Ciptakan suasana makan yang positif dan menyenangkan. '
        'Tidak memaksa, tidak membentak, tidak menghukum.',
  ),
  FeedingRule(
    number: 5,
    category: 'Lingkungan',
    title: 'Tanpa distraksi (TV/gadget/bermain)',
    description: 'Matikan TV, jauhkan gadget, dan tidak makan sambil bermain '
        'atau jalan-jalan. Anak duduk di kursi makan.',
  ),
  FeedingRule(
    number: 6,
    category: 'Lingkungan',
    title: 'Contoh perilaku makan yang baik',
    description: 'Orang tua makan bersama anak dan menunjukkan '
        'contoh perilaku makan yang baik (role model).',
  ),
  // PROSEDUR
  FeedingRule(
    number: 7,
    category: 'Prosedur',
    title: 'Porsi kecil, variasi makanan bergizi',
    description: 'Berikan porsi kecil dengan variasi makanan bergizi lengkap '
        '(karbo, protein hewani & nabati, lemak, sayur, buah).',
  ),
  FeedingRule(
    number: 8,
    category: 'Prosedur',
    title: 'Responsive feeding (peka sinyal lapar/kenyang)',
    description: 'Perhatikan tanda lapar dan kenyang anak. Tawarkan makanan '
        'secara responsif tanpa memaksa. Hargai keputusan anak.',
  ),
  FeedingRule(
    number: 9,
    category: 'Prosedur',
    title: 'Dorong makan mandiri sesuai usia',
    description: 'Biarkan anak mencoba makan sendiri (finger food, sendok). '
        'Jangan membersihkan mulut anak sebelum sesi makan selesai.',
  ),
  FeedingRule(
    number: 10,
    category: 'Prosedur',
    title: 'Tawarkan kembali tanpa memaksa',
    description: 'Jika anak menolak makan, tawarkan kembali secara netral. '
        'Jika tetap menolak setelah 10–15 menit, akhiri sesi makan. '
        'Jangan memberikan makanan pengganti di luar jadwal.',
  ),
];

// ─────────────────────────────────────────────
// PANDUAN SUPLEMENTASI IDAI
// ─────────────────────────────────────────────

class SupplementGuidance {
  final String name;
  final String dose;
  final String indication;
  final String duration;
  final String notes;

  const SupplementGuidance({
    required this.name,
    required this.dose,
    required this.indication,
    required this.duration,
    required this.notes,
  });
}

/// Rekomendasi suplementasi Zat Besi berdasarkan usia.
SupplementGuidance ironSupplement(int ageMonths, double weightKg) {
  final dosePerDay = (2.0 * weightKg).toStringAsFixed(1);

  if (ageMonths < 4) {
    return SupplementGuidance(
      name: 'Zat Besi (Fe)',
      dose: 'Belum diperlukan (cadangan besi dari lahir masih cukup)',
      indication: 'Bayi aterm dengan berat lahir normal',
      duration: '-',
      notes: 'Bayi prematur/BBLR mungkin memerlukan suplementasi lebih awal — '
          'konsultasi dokter.',
    );
  } else if (ageMonths <= 24) {
    return SupplementGuidance(
      name: 'Zat Besi (Fe)',
      dose: '2 mg/kgBB/hari ($dosePerDay mg/hari)',
      indication: 'Pencegahan anemia defisiensi besi (terutama bayi ASI eksklusif)',
      duration: 'Usia 4 bulan – 2 tahun',
      notes: 'Berikan dalam bentuk tetes/sirup besi. '
          'Konsumsi bersama Vitamin C untuk meningkatkan absorpsi. '
          'Hindari bersamaan dengan susu/teh.',
    );
  } else {
    return SupplementGuidance(
      name: 'Zat Besi (Fe)',
      dose: '2 mg/kgBB/hari ($dosePerDay mg/hari) jika ada indikasi',
      indication: 'Jika ada tanda anemia atau risiko tinggi (pola makan kurang protein hewani)',
      duration: 'Sesuai advis dokter',
      notes: 'Skrining anemia direkomendasikan pada usia 12 bulan. '
          'Pastikan asupan makanan kaya zat besi (daging merah, hati, telur).',
    );
  }
}

/// Rekomendasi suplementasi Vitamin D berdasarkan usia.
SupplementGuidance vitaminDSupplement(int ageMonths) {
  if (ageMonths <= 12) {
    return const SupplementGuidance(
      name: 'Vitamin D',
      dose: '400 IU/hari',
      indication: 'Semua bayi (terutama yang ASI eksklusif dan kurang paparan matahari)',
      duration: 'Sejak lahir hingga usia 1 tahun',
      notes: 'Vitamin D penting untuk mineralisasi tulang, fungsi imun, '
          'dan pencegahan riketsia. Berikan dalam bentuk tetes.',
    );
  } else {
    return const SupplementGuidance(
      name: 'Vitamin D',
      dose: '600 IU/hari',
      indication: 'Anak >1 tahun (terutama kurang paparan sinar matahari)',
      duration: 'Berkelanjutan',
      notes: 'Sumber Vitamin D: paparan matahari pagi (15–30 menit), '
          'ikan berlemak (salmon, makarel), kuning telur, susu fortifikasi.',
    );
  }
}
