/// Item jadwal makan harian.
class MealScheduleItem {
  final String time;
  final String title;
  final String category; // 'Utama' | 'Selingan' | 'ASI/Susu'
  final String recommendation;

  const MealScheduleItem({
    required this.time,
    required this.title,
    required this.category,
    required this.recommendation,
  });
}

/// Panduan porsi makan per kelompok usia (Satter 1987/2000 & AAP 2011).
class PortionGuide {
  final String ageGroupLabel;
  final String textureLabel;
  final String carbs;
  final String animalProtein;
  final String plantProtein;
  final String veggiesFruit;
  final String fatAdded;
  final String milkFluid;

  const PortionGuide({
    required this.ageGroupLabel,
    required this.textureLabel,
    required this.carbs,
    required this.animalProtein,
    required this.plantProtein,
    required this.veggiesFruit,
    required this.fatAdded,
    required this.milkFluid,
  });
}

/// Resep MPASI Kemenkes RI (2023).
class MpasiRecipe {
  final String name;
  final String ageGroup;
  final String texture;
  final String portion;
  final List<String> ingredients;
  final String instructions;

  const MpasiRecipe({
    required this.name,
    required this.ageGroup,
    required this.texture,
    required this.portion,
    required this.ingredients,
    required this.instructions,
  });
}

/// Data Rujukan Meal Plan, Jadwal, Porsi, & Resep MPASI.
class MealPlanRepository {
  /// Mendapatkan Jadwal Makan Terstruktur Harian sesuai Usia.
  static List<MealScheduleItem> getScheduleForAge(double ageMonths) {
    if (ageMonths < 6.0) {
      return const [
        MealScheduleItem(
          time: '06:00',
          title: 'ASI / Formula',
          category: 'ASI/Susu',
          recommendation: 'Berikan ASI eksklusif sesering yang diinginkan bayi (on demand, 8-12x/hari).',
        ),
        MealScheduleItem(
          time: '09:00',
          title: 'ASI / Formula',
          category: 'ASI/Susu',
          recommendation: 'Sesuai isyarat lapar bayi.',
        ),
        MealScheduleItem(
          time: '12:00',
          title: 'ASI / Formula',
          category: 'ASI/Susu',
          recommendation: 'Berikan ASI/Formula hingga kenyang.',
        ),
        MealScheduleItem(
          time: '15:00',
          title: 'ASI / Formula',
          category: 'ASI/Susu',
          recommendation: 'Pemberian siang hari.',
        ),
        MealScheduleItem(
          time: '18:00',
          title: 'ASI / Formula',
          category: 'ASI/Susu',
          recommendation: 'Pemberian sore/malam.',
        ),
        MealScheduleItem(
          time: '21:00',
          title: 'ASI / Formula (Malam)',
          category: 'ASI/Susu',
          recommendation: 'Sebelum tidur malam.',
        ),
      ];
    } else if (ageMonths < 9.0) { // 6-8 bulan
      return const [
        MealScheduleItem(
          time: '07:00',
          title: 'Makan Pagi (MPASI Lumat)',
          category: 'Utama',
          recommendation: '2-3 sendok makan bubur lumat kaya protein hewani (telur/hati/daging/ikan). WHO 2023: wajib pangan hewani setiap hari.',
        ),
        MealScheduleItem(
          time: '09:30',
          title: 'Selingan Pagi / ASI',
          category: 'Selingan',
          recommendation: 'Puree buah lunak segar (pisang/alpukat/pepaya) kaya vitamin atau ASI.',
        ),
        MealScheduleItem(
          time: '12:00',
          title: 'Makan Siang (MPASI Lumat)',
          category: 'Utama',
          recommendation: '2-3 sendok makan bubur lumat + protein hewani + sayur lumat + 1 sdt minyak/santan sehat.',
        ),
        MealScheduleItem(
          time: '15:30',
          title: 'Selingan Sore / ASI',
          category: 'Selingan',
          recommendation: 'ASI atau lumatan buah segar/kudapan MPASI sehat bebas gula.',
        ),
        MealScheduleItem(
          time: '18:00',
          title: 'Makan Malam (MPASI Lumat)',
          category: 'Utama',
          recommendation: '1-2 sdm bubur lumat atau ASI. Terapkan responsive feeding (peka rasa kenyang, tanpa paksaan).',
        ),
        MealScheduleItem(
          time: '20:30',
          title: 'ASI / Susu Sebelum Tidur',
          category: 'ASI/Susu',
          recommendation: 'ASI on demand atau susu formula/susu hewani murni full-fat tanpa pemanis (WHO 2023).',
        ),
      ];
    } else if (ageMonths < 12.0) { // 9-11 bulan
      return const [
        MealScheduleItem(
          time: '07:00',
          title: 'Makan Pagi (MPASI Cincang/Lembik)',
          category: 'Utama',
          recommendation: '1/2 mangkuk (125 mL) bubur tim / nasi tim cincang halus + lauk hewani + sayur.',
        ),
        MealScheduleItem(
          time: '09:30',
          title: 'Selingan Pagi (Finger Food)',
          category: 'Selingan',
          recommendation: 'Finger food potongan buah lunak / potongan telur rebus untuk stimulasi makan mandiri (WHO 2023).',
        ),
        MealScheduleItem(
          time: '12:00',
          title: 'Makan Siang (MPASI Lembik)',
          category: 'Utama',
          recommendation: '1/2 mangkuk nasi tim lengkap dengan 1 butir telur / daging cincang / ikan segar.',
        ),
        MealScheduleItem(
          time: '15:30',
          title: 'Selingan Sore / ASI',
          category: 'Selingan',
          recommendation: 'Buah segar (pepaya/pisang/mangga) atau ASI.',
        ),
        MealScheduleItem(
          time: '18:00',
          title: 'Makan Malam (MPASI Lembik)',
          category: 'Utama',
          recommendation: '1/2 mangkuk nasi tim kaya protein hewani + kuah sayur.',
        ),
        MealScheduleItem(
          time: '20:30',
          title: 'ASI / Susu Sebelum Tidur',
          category: 'ASI/Susu',
          recommendation: 'ASI atau susu formula/susu sapi murni full-fat tanpa perisa sebelum tidur.',
        ),
      ];
    } else if (ageMonths < 24.0) { // 12-23 bulan (1-2 thn)
      return const [
        MealScheduleItem(
          time: '07:00',
          title: 'Makan Pagi (Makanan Keluarga Cincang)',
          category: 'Utama',
          recommendation: 'Nasi tim/lunak 3/4 mangkuk + lauk hewani (ayam/telur/ikan/daging) + sayur keluarga.',
        ),
        MealScheduleItem(
          time: '09:30',
          title: 'Selingan Pagi',
          category: 'Selingan',
          recommendation: 'Buah segar potong atau snack sehat bebas gula tambahan (WHO 2023).',
        ),
        MealScheduleItem(
          time: '12:00',
          title: 'Makan Siang (Makanan Keluarga Cincang)',
          category: 'Utama',
          recommendation: 'Nasi lunak 3/4 mangkuk + lauk hewani harian + kuah sayur kaya vitamin.',
        ),
        MealScheduleItem(
          time: '15:30',
          title: 'Selingan Sore',
          category: 'Selingan',
          recommendation: 'Snack sehat (pisang, bola tahu telur, ubi kukus). Hindari biskuit berpemanis/minuman manis.',
        ),
        MealScheduleItem(
          time: '18:00',
          title: 'Makan Malam (Makanan Keluarga Cincang)',
          category: 'Utama',
          recommendation: 'Nasi lunak + protein hewani + sayur.',
        ),
        MealScheduleItem(
          time: '20:30',
          title: 'Susu Pasteurisasi / ASI Malam',
          category: 'ASI/Susu',
          recommendation: 'Susu sapi pasteurisasi murni / ASI (maks 400 mL/hari). WHO 2023 tidak merekomendasikan formula lanjutan.',
        ),
      ];
    } else { // 24+ bulan (2-5 thn+) - ASI disapih
      return const [
        MealScheduleItem(
          time: '07:00',
          title: 'Makan Pagi (Makanan Keluarga)',
          category: 'Utama',
          recommendation: 'Nasi biasa + lauk protein hewani (ayam/telur/ikan) + sayur.',
        ),
        MealScheduleItem(
          time: '09:30',
          title: 'Selingan Pagi',
          category: 'Selingan',
          recommendation: 'Buah segar, puding susu, atau biskuit sehat.',
        ),
        MealScheduleItem(
          time: '12:00',
          title: 'Makan Siang (Makanan Keluarga)',
          category: 'Utama',
          recommendation: 'Nasi lengkap 1 porsi piring makan + lauk hewani + sayur.',
        ),
        MealScheduleItem(
          time: '15:30',
          title: 'Selingan Sore',
          category: 'Selingan',
          recommendation: 'Snack sehat (pisang bakar, bola tahu daging, puding buah).',
        ),
        MealScheduleItem(
          time: '18:00',
          title: 'Makan Malam (Makanan Keluarga)',
          category: 'Utama',
          recommendation: 'Nasi lengkap + protein hewani + sayur.',
        ),
        MealScheduleItem(
          time: '20:30',
          title: 'Susu UHT / Pasturisasi Sebelum Tidur',
          category: 'Susu',
          recommendation: '1 gelas susu segar / UHT (max 400 mL/hari).',
        ),
      ];
    }
  }

  /// Panduan Porsi Satter per Kelompok Usia (Diselaraskan dengan WHO Guideline 2023).
  static PortionGuide getPortionGuide(double ageMonths) {
    if (ageMonths < 6.0) {
      return const PortionGuide(
        ageGroupLabel: '0 - 5 Bulan',
        textureLabel: 'Cair (ASI Eksklusif / Formula)',
        carbs: 'ASI / Formula',
        animalProtein: 'ASI / Formula',
        plantProtein: 'Belum dianjurkan',
        veggiesFruit: 'Belum dianjurkan',
        fatAdded: 'Alami dalam ASI',
        milkFluid: 'ASI on demand / Formula 600-900 mL/hari',
      );
    } else if (ageMonths < 9.0) {
      return const PortionGuide(
        ageGroupLabel: '6 - 8 Bulan',
        textureLabel: 'Lumat / Saring (Smooth Puree)',
        carbs: '2-3 sdm bubur beras/kentang per makan',
        animalProtein: '1/2 - 1 sdm daging/hati/ikan cincang atau 1/2 telur (WAJIB setiap hari - WHO 2023)',
        plantProtein: '1 sdt tahu/tempe lumat',
        veggiesFruit: '1 sdt - 1 sdm sayur/buah lumat harian (WHO 2023)',
        fatAdded: '1/2 - 1 sdt minyak/santan/mentega per porsi',
        milkFluid: 'ASI diteruskan + air putih secukupnya (non-ASI: formula/susu sapi murni)',
      );
    } else if (ageMonths < 12.0) {
      return const PortionGuide(
        ageGroupLabel: '9 - 11 Bulan',
        textureLabel: 'Cincang Halus / Nasi Tim (Mashed & Finger Foods)',
        carbs: '1/2 mangkuk (125 mL) nasi tim / kentang',
        animalProtein: '1 sdm daging ayam/sapi/ikan atau 1/2-1 butir telur (WAJIB setiap hari - WHO 2023)',
        plantProtein: '1 sdm tempe/tahu cincang',
        veggiesFruit: '1-2 sdm sayur cincang lunak & finger food buah harian',
        fatAdded: '1 sdt minyak/santan per porsi',
        milkFluid: 'ASI + air putih (non-ASI: formula/susu sapi murni full-fat)',
      );
    } else if (ageMonths < 36.0) { // 1-3 thn
      return const PortionGuide(
        ageGroupLabel: '1 - 3 Tahun (Toddler)',
        textureLabel: 'Makanan Keluarga (Family Foods)',
        carbs: '2-4 sdm nasi / 1/2 potong roti / 2 sdm pasta',
        animalProtein: '1-2 sdm daging cincang / 1 butir telur / 1/2 potong ikan (harian)',
        plantProtein: '1-2 sdm potong tahu/tempe',
        veggiesFruit: '1-2 sdm sayur matang / 1/4 potong buah (harian)',
        fatAdded: '1 sdt minyak/butter/santan pada masakan',
        milkFluid: 'Susu sapi pasteurisasi 400-500 mL/hari (max 2 gelas) / ASI (WHO: tanpa formula lanjutan) + Air Putih',
      );
    } else { // 3+ thn
      return const PortionGuide(
        ageGroupLabel: '3 - 5 Tahun+',
        textureLabel: 'Makanan Keluarga Seimbang',
        carbs: '1/2 - 1 centong nasi per makan',
        animalProtein: '1 potong sedang ayam/daging/ikan / 1 butir telur',
        plantProtein: '1-2 potong tempe/tahu',
        veggiesFruit: '3-4 sdm sayur + 1 potong buah segar',
        fatAdded: 'Sesuai olahan masakan keluarga',
        milkFluid: 'Susu 1-2 gelas/hari + Air Putih 1-1.5 Liter',
      );
    }
  }

  /// Aturan Pemberian Makan Terintegrasi (WHO Guideline 2023 & Ellyn Satter Feeding Rules).
  static const List<String> feedingRules = [
    'Jadwal Terstruktur: Berikan makanan utama & selingan pada jam teratur (jarak 2-3 jam). Jangan membiasakan anak ngemil/minum susu terus-menerus di luar jadwal (grazing).',
    'Divisi Tanggung Jawab & Responsive Feeding: Orang tua menentukan APA yang disajikan, KAPAN, dan DI MANA. Anak menentukan BERAPA BANYAK yang ingin dimakan tanpa paksaan (WHO 2023).',
    'Lingkungan Menyenangkan: Makan bersama di meja makan tanpa distraksi (matikan TV, HP, dan mainan). Durasi makan maksimal 30 menit.',
    'Wajib Protein Hewani Harian (WHO 2023): Sajikan protein hewani bernilai hayati tinggi (telur, hati, ayam, daging, ikan) di setiap hari makan utama untuk mencegah stunting dan anemia.',
    'Sayur & Buah Harian (WHO 2023): Berikan sayuran dan buah segar setiap hari, terutama yang kaya Vitamin A dan C.',
    'Bebas Gula Tambahan & Batasi Minuman Manis (WHO 2023): Dilarang memberikan gula tambahan, garam tinggi, minuman manis (SSB), dan pemanis buatan. Jus buah 100% sangat dibatasi.',
    'Ketentuan Susu Non-ASI (WHO 2023): Dianjurkan susu sapi pasteurisasi murni full-cream atau ASI. WHO tidak merekomendasikan susu formula lanjutan/pertumbuhan 1-3 tahun. Batasi susu maksimal 400-500 mL/hari.',
  ];

  /// Resep MPASI Kemenkes RI 2023.
  static List<MpasiRecipe> getRecipesForAge(double ageMonths) {
    if (ageMonths < 9.0) {
      return const [
        MpasiRecipe(
          name: 'Bubur Singkong Daging Sapi (Kemenkes 2023)',
          ageGroup: '6 - 8 Bulan',
          texture: 'Lumat (Puree)',
          portion: '2-3 sdm (2x sehari)',
          ingredients: [
            '50g Singkong (rebus lunak)',
            '30g Daging Sapi cincang halus',
            '10g Hati Ayam',
            '1 sdt Minyak kelapa / santan encer',
            'Bayam potong secukupnya',
          ],
          instructions: 'Rebus daging sapi dan hati ayam hingga empuk. Masukkan singkong rebus dan bayam. Saring halus dengan saringan kawat hingga bertekstur lumat lembut. Tambahkan 1 sdt minyak kelapa.',
        ),
        MpasiRecipe(
          name: 'Bubur Hati Ayam & Telur Lemak Manis',
          ageGroup: '6 - 8 Bulan',
          texture: 'Lumat (Puree)',
          portion: '2-3 sdm',
          ingredients: [
            '2 sdm Beras putih',
            '30g Hati Ayam (cincang)',
            '1/2 butir Telur kuning',
            '1 sdt Santan kental',
          ],
          instructions: 'Masak beras menjadi bubur. Masukkan hati ayam dan santan kental. Saat hampir matang, masukkan kuning telur sambil diaduk rata. Saring halus sebelum disajikan.',
        ),
      ];
    } else if (ageMonths < 12.0) {
      return const [
        MpasiRecipe(
          name: 'Nasi Tim Ayam Ikan Kembung (Kemenkes 2023)',
          ageGroup: '9 - 11 Bulan',
          texture: 'Cincang Halus / Lembik',
          portion: '1/2 mangkuk (125 mL)',
          ingredients: [
            '50g Nasi tim',
            '30g Daging Ikan Kembung tanpa duri',
            '20g Daging Ayam cincang',
            '1 sdt Minyak wijen / kelapa',
            'Wortel cincang halus',
          ],
          instructions: 'Tumis daging ayam dan ikan kembung dengan minyak wijen hingga harum. Masukkan wortel dan beras tim. Tim hingga beras dan ikan empuk meledak bertekstur cincang lembut.',
        ),
        MpasiRecipe(
          name: 'Nasi Tim Bola Daging Telur Puyuh',
          ageGroup: '9 - 11 Bulan',
          texture: 'Cincang / Lembik',
          portion: '1/2 mangkuk (125 mL)',
          ingredients: [
            '50g Nasi tim',
            '30g Daging sapi giling (buat bola kecil)',
            '2 butir Telur puyuh rebus',
            'Brokoli cincang',
            '1 sdt Mentega',
          ],
          instructions: 'Rebus bola daging sapi dan telur puyuh. Campurkan dengan nasi tim dan kuah kaldu sapi gurih. Sajikan hangat.',
        ),
      ];
    } else {
      return const [
        MpasiRecipe(
          name: 'Sup Bola Daging Ayam & Hati Sapi (Kemenkes 2023)',
          ageGroup: '12 - 23 Bulan+',
          texture: 'Makanan Keluarga Lunak',
          portion: '1 porsi mangkuk kecil',
          ingredients: [
            '50g Daging Ayam & Hati Sapi giling',
            '1/2 Kentang potong dadu',
            'Wortel & Buncis iris',
            '1 butir Telur kocok',
            'Minyak untuk menumis & kaldu gurih',
          ],
          instructions: 'Bentuk bola daging ayam dan hati. Masak dalam kuah sup bening bersama kentang, wortel, buncis, dan telur kocok. Sajikan bersama nasi hangat keluarga.',
        ),
      ];
    }
  }
}
