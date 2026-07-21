library;

/// Data statis untuk Modul Pemenuhan Nutrisi (Asuhan Nutrisi Pediatrik).
///
/// Sumber:
/// - Tabel AKG: Permenkes RI Nomor 28 Tahun 2019
/// - Feeding Rules: Rekomendasi IDAI
/// - MPASI: Panduan WHO/IDAI
/// - Suplementasi: Rekomendasi IDAI

/// Kebutuhan Energi & Protein harian per kelompok usia (Permenkes RI 28/2019).
class AkgEntry {
  final int ageMinMonths;
  final int ageMaxMonths;
  final String label;
  final int energyKcal;
  final int proteinGram;

  /// RDA per kgBB/hari (untuk kalkulasi target individual).
  final double energyPerKgBB;
  final double proteinPerKgBB;

  const AkgEntry({
    required this.ageMinMonths,
    required this.ageMaxMonths,
    required this.label,
    required this.energyKcal,
    required this.proteinGram,
    required this.energyPerKgBB,
    required this.proteinPerKgBB,
  });
}

/// Tabel AKG Permenkes RI No. 28 Tahun 2019.
/// Kolom energyPerKgBB & proteinPerKgBB dihitung dari:
///   energyKcal / median BB WHO pada usia tengah rentang.
const List<AkgEntry> akgTable = [
  AkgEntry(
    ageMinMonths: 0, ageMaxMonths: 5, label: '0–5 bulan',
    energyKcal: 550, proteinGram: 9,
    energyPerKgBB: 100.0, proteinPerKgBB: 1.5,
  ),
  AkgEntry(
    ageMinMonths: 6, ageMaxMonths: 11, label: '6–11 bulan',
    energyKcal: 800, proteinGram: 15,
    energyPerKgBB: 95.0, proteinPerKgBB: 1.5,
  ),
  AkgEntry(
    ageMinMonths: 12, ageMaxMonths: 36, label: '1–3 tahun',
    energyKcal: 1350, proteinGram: 20,
    energyPerKgBB: 100.0, proteinPerKgBB: 1.5,
  ),
  AkgEntry(
    ageMinMonths: 37, ageMaxMonths: 72, label: '4–6 tahun',
    energyKcal: 1400, proteinGram: 25,
    energyPerKgBB: 80.0, proteinPerKgBB: 1.2,
  ),
  AkgEntry(
    ageMinMonths: 73, ageMaxMonths: 108, label: '7–9 tahun',
    energyKcal: 1650, proteinGram: 40,
    energyPerKgBB: 65.0, proteinPerKgBB: 1.2,
  ),
  AkgEntry(
    ageMinMonths: 109, ageMaxMonths: 144, label: '10–12 tahun (L)',
    energyKcal: 2000, proteinGram: 50,
    energyPerKgBB: 55.0, proteinPerKgBB: 1.0,
  ),
  AkgEntry(
    ageMinMonths: 145, ageMaxMonths: 180, label: '13–15 tahun (L)',
    energyKcal: 2400, proteinGram: 70,
    energyPerKgBB: 50.0, proteinPerKgBB: 1.0,
  ),
  AkgEntry(
    ageMinMonths: 181, ageMaxMonths: 216, label: '16–18 tahun (L)',
    energyKcal: 2650, proteinGram: 75,
    energyPerKgBB: 45.0, proteinPerKgBB: 1.0,
  ),
];

/// Tabel AKG khusus Perempuan untuk usia 10+ (ambang protein & energi berbeda).
const List<AkgEntry> akgTableGirls = [
  AkgEntry(
    ageMinMonths: 109, ageMaxMonths: 144, label: '10–12 tahun (P)',
    energyKcal: 1900, proteinGram: 55,
    energyPerKgBB: 50.0, proteinPerKgBB: 1.0,
  ),
  AkgEntry(
    ageMinMonths: 145, ageMaxMonths: 180, label: '13–15 tahun (P)',
    energyKcal: 2050, proteinGram: 65,
    energyPerKgBB: 45.0, proteinPerKgBB: 1.0,
  ),
  AkgEntry(
    ageMinMonths: 181, ageMaxMonths: 216, label: '16–18 tahun (P)',
    energyKcal: 2100, proteinGram: 65,
    energyPerKgBB: 40.0, proteinPerKgBB: 1.0,
  ),
];

/// Cari entri AKG berdasarkan usia (bulan) dan jenis kelamin.
AkgEntry? findAkg(int ageMonths, String sex) {
  final isBoy = sex.toUpperCase() == 'L' || sex.toUpperCase() == 'M';

  // Untuk usia ≥10 tahun, gunakan tabel spesifik jenis kelamin
  if (ageMonths >= 109) {
    final table = isBoy ? akgTable : akgTableGirls;
    for (final e in table) {
      if (ageMonths >= e.ageMinMonths && ageMonths <= e.ageMaxMonths) {
        return e;
      }
    }
    // Jika di atas rentang tabel, pakai entri terakhir
    return isBoy ? akgTable.last : akgTableGirls.last;
  }

  // Untuk usia <10 tahun, tabel sama untuk L dan P
  for (final e in akgTable) {
    if (ageMonths >= e.ageMinMonths && ageMonths <= e.ageMaxMonths) {
      return e;
    }
  }
  return akgTable.last;
}

// ─────────────────────────────────────────────
// PANDUAN MPASI PER USIA (IDAI / WHO)
// ─────────────────────────────────────────────

class MpasiGuidance {
  final int ageMinMonths;
  final int ageMaxMonths;
  final String label;
  final String texture;
  final String frequency;
  final String portion;
  final String notes;
  /// Contoh menu/resep MPASI (sumber: Buku Resep Makanan Lokal Kemenkes RI 2023).
  final List<String> menuExamples;

  const MpasiGuidance({
    required this.ageMinMonths,
    required this.ageMaxMonths,
    required this.label,
    required this.texture,
    required this.frequency,
    required this.portion,
    required this.notes,
    this.menuExamples = const [],
  });
}

const List<MpasiGuidance> mpasiGuidelines = [
  MpasiGuidance(
    ageMinMonths: 0, ageMaxMonths: 5,
    label: '0–6 Bulan',
    texture: 'ASI Eksklusif',
    frequency: 'On demand (sesuai permintaan bayi)',
    portion: 'Tidak dibatasi',
    notes: 'ASI eksklusif tanpa tambahan makanan/minuman apapun. '
        'Jika ada indikasi medis, susu formula diberikan atas advis dokter.',
    menuExamples: [],
  ),
  MpasiGuidance(
    ageMinMonths: 6, ageMaxMonths: 8,
    label: '6–8 Bulan',
    texture: 'Bubur kental (puree) / makanan dilumatkan halus (mashed)',
    frequency: '2–3× makan utama + 1–2× selingan',
    portion: 'Mulai 2–3 sdm, bertahap hingga ½ mangkuk (125 ml)',
    notes: 'Mulai MPASI kaya zat besi (protein hewani: daging, hati, telur). '
        'Perkenalkan satu jenis makanan baru setiap 3–5 hari. '
        'ASI tetap diberikan sesuai permintaan.',
    menuExamples: [
      'Bubur Singkong Isi Ikan & Ayam dengan Saus Jeruk',
      'Bubur Soto Ayam Santan',
      'Bubur Sup Telur Daging Kacang Merah',
      'Bubur Kanju Rumbi Ayam dan Udang',
      'Puding Kentang Ayam dan Telur',
    ],
  ),
  MpasiGuidance(
    ageMinMonths: 9, ageMaxMonths: 11,
    label: '9–11 Bulan',
    texture: 'Makanan dicincang halus/kasar + finger food',
    frequency: '3–4× makan utama + 1–2× selingan',
    portion: '½ – ¾ mangkuk (125–175 ml)',
    notes: 'Dorong anak makan mandiri dengan finger food. '
        'Variasi protein hewani & nabati, sayur, buah. '
        'ASI tetap diberikan.',
    menuExamples: [
      'Nasi Tim Ikan Tuna Telur Puyuh',
      'Nasi Tim Ayam Lele Cincang',
      'Mie Kukus Telur Puyuh',
      'Nasi Tim Ikan Telur Sayuran',
      'Tim Bubur Manado Daging dan Udang',
    ],
  ),
  MpasiGuidance(
    ageMinMonths: 12, ageMaxMonths: 23,
    label: '12–23 Bulan',
    texture: 'Makanan keluarga (potong kecil/dicincang)',
    frequency: '3–4× makan utama + 1–2× selingan',
    portion: '¾ – 1 mangkuk (175–250 ml)',
    notes: 'Transisi ke makanan keluarga. Perhatikan keamanan '
        '(hindari makanan bulat keras: kacang utuh, anggur utuh). '
        'ASI dapat dilanjutkan sampai 24 bulan.',
    menuExamples: [
      'Nasi Sup Telur Puyuh Bola Tahu Ayam',
      'Nasi Soto Ayam Kuah Kuning',
      'Sup Telur Puyuh Ikan Air Tawar Labu Kuning',
      'Nasi Ikan Kuah Kuning',
      'Nugget Tempe Ayam Sayuran',
    ],
  ),
  MpasiGuidance(
    ageMinMonths: 24, ageMaxMonths: 240,
    label: '≥2 Tahun',
    texture: 'Makanan keluarga penuh',
    frequency: '3× makan utama + 2× selingan',
    portion: 'Sesuai kebutuhan anak',
    notes: 'Pola makan gizi seimbang: karbohidrat, protein hewani & nabati, '
        'lemak sehat, sayur, dan buah. Batasi makanan ultra-proses, '
        'minuman manis, dan garam berlebih.',
    menuExamples: [
      'Nasi Bakar Ayam Santan',
      'Nasi Sup Tabas Udang',
      'Nasi Masak Ayam Kecap Sayur',
      'Bola-bola Nasi Rabuk Ikan',
    ],
  ),
];

/// Cari panduan MPASI berdasarkan usia (bulan).
MpasiGuidance findMpasiGuidance(int ageMonths) {
  for (final g in mpasiGuidelines) {
    if (ageMonths >= g.ageMinMonths && ageMonths <= g.ageMaxMonths) {
      return g;
    }
  }
  return mpasiGuidelines.last;
}

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
