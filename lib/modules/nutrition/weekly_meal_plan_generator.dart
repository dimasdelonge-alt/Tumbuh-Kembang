import 'food_exchange_data.dart';
import 'nutrition_calculator.dart';

/// Item menu satu sesi makan (Pagi, Selingan, Siang, Selingan, Malam, Susu).
class DailyMealSession {
  final String time;
  final String sessionName; // 'Makan Pagi', 'Selingan Pagi', 'Makan Siang', 'Selingan Sore', 'Makan Malam', 'Susu Malam'
  final String menuName;
  final String description;
  final String portionUrt;

  /// Estimasi energi & makro sesi ini dari tabel penukar (0 bila tidak
  /// dihitung, mis. ASI on demand atau mode tanpa target kalori).
  final double kcal;
  final double carbsG;
  final double proteinG;
  final double fatG;

  const DailyMealSession({
    required this.time,
    required this.sessionName,
    required this.menuName,
    required this.description,
    required this.portionUrt,
    this.kcal = 0,
    this.carbsG = 0,
    this.proteinG = 0,
    this.fatG = 0,
  });
}

/// Rencana makan 1 hari (Senin..Minggu).
class SingleDayMealPlan {
  final String dayName; // 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
  final String theme; // mis. 'Hari Protein Ayam & Telur', 'Hari Protein Ikan & Tahu', dll
  final List<DailyMealSession> sessions;

  const SingleDayMealPlan({
    required this.dayName,
    required this.theme,
    required this.sessions,
  });

  double get totalKcal => sessions.fold(0.0, (a, s) => a + s.kcal);
  double get totalCarbsG => sessions.fold(0.0, (a, s) => a + s.carbsG);
  double get totalProteinG => sessions.fold(0.0, (a, s) => a + s.proteinG);
  double get totalFatG => sessions.fold(0.0, (a, s) => a + s.fatG);

  /// Persentase energi KH : Protein : Lemak (4/4/9 kkal per gram).
  ({double carb, double protein, double fat}) get macroEnergyPct {
    final c = totalCarbsG * 4;
    final p = totalProteinG * 4;
    final f = totalFatG * 9;
    final total = c + p + f;
    if (total <= 0) return (carb: 0, protein: 0, fat: 0);
    return (carb: c / total * 100, protein: p / total * 100, fat: f / total * 100);
  }

  String get macroSummary {
    final m = macroEnergyPct;
    return 'KH ${totalCarbsG.round()} g (${m.carb.round()}%) : '
        'Protein ${totalProteinG.round()} g (${m.protein.round()}%) : '
        'Lemak ${totalFatG.round()} g (${m.fat.round()}%)';
  }
}

/// Profil tekstur makanan (mengikuti usia, atau dipilih manual oleh dokter).
class _TextureProfile {
  final String guide;
  final String bowlLabel;
  const _TextureProfile(this.guide, this.bowlLabel);
}

const _profileSaring = _TextureProfile(
  'Tekstur: Lumat Halus / Saring (Puree)',
  '±2-3 sdm bertahap s.d. 1/2 mangkuk (125 mL)',
);
const _profileLembik = _TextureProfile(
  'Tekstur: Lembik / Cincang Halus (Mashed/Chopped)',
  '±1/2 mangkuk (125 mL)',
);
const _profileKeluargaCincang = _TextureProfile(
  'Tekstur: Makanan Keluarga Cincang Kasar / Potong Kecil',
  '±3/4 mangkuk (175 mL)',
);
const _profileKeluarga = _TextureProfile(
  'Tekstur: Makanan Keluarga Utuh',
  '±1 piring makan',
);

/// Komponen bahan hasil perhitungan penukar untuk satu sesi makan utama.
class _Component {
  final FoodExchangeItem item;
  final double grams;
  final double kcal;
  final double carbsG;
  final double proteinG;
  final double fatG;
  const _Component(this.item, this.grams, this.kcal, this.carbsG, this.proteinG, this.fatG);
}

/// Generator Rencana & Jadwal Makan Seminggu (7 Hari).
class WeeklyMealPlanGenerator {
  /// Bahan olahan tinggi garam/gula yang tidak ditawarkan untuk <24 bulan.
  static const _processedNames = {'Sosis', 'Corned Beef', 'Daging Asap', 'Biskuit'};

  /// 1 sdt minyak/santan tambahan (±5 g) ≈ 45 kkal, lemak 5 g (TKPI).
  static const double _oilKcalPerSdt = 45.0;

  /// Profil gizi rata-rata ASI / Formula bayi standar per 100 mL (TKPI / WHO):
  /// 67 kkal, Protein 1.3 g, Lemak 3.8 g, Karbohidrat 7.0 g.
  static const double _infantMilkKcalPerMl = 0.67;
  static const double _infantMilkProPer100Ml = 1.3;
  static const double _infantMilkFatPer100Ml = 3.8;
  static const double _infantMilkCarbPer100Ml = 7.0;

  static ({double kcal, double carbsG, double proteinG, double fatG}) _infantMilkMacros(int ml) {
    if (ml <= 0) return (kcal: 0, carbsG: 0, proteinG: 0, fatG: 0);
    final factor = ml / 100.0;
    return (
      kcal: ml * _infantMilkKcalPerMl,
      carbsG: factor * _infantMilkCarbPer100Ml,
      proteinG: factor * _infantMilkProPer100Ml,
      fatG: factor * _infantMilkFatPer100Ml,
    );
  }

  static ({double kcal, double carbsG, double proteinG, double fatG}) _olderMilkMacros(
    FoodExchangeItem milkItem,
    int ml,
  ) {
    if (ml <= 0 || milkItem.grams <= 0) {
      return (kcal: 0, carbsG: 0, proteinG: 0, fatG: 0);
    }
    final factor = ml / milkItem.grams;
    return (
      kcal: milkItem.calories * factor,
      carbsG: milkItem.carbs * factor,
      proteinG: milkItem.protein * factor,
      fatG: milkItem.fat * factor,
    );
  }

  /// Membikin Rencana Makan 7 Hari (Senin - Minggu) berbasis Usia & Bahan Penukar Pilihan.
  ///
  /// Bila [nutResult] diberikan, takaran dihitung dari target kalori harian
  /// memakai Daftar Bahan Penukar sehingga total menu contoh mendekati
  /// target (bukan takaran tetap per usia). [textureOverride] ('saring' |
  /// 'lembik' | 'keluarga') mengganti profil tekstur bawaan usia.
  static List<SingleDayMealPlan> generate7DayPlan({
    required double ageMonths,
    FoodExchangeItem? preferredCarb,
    FoodExchangeItem? preferredAnimalProtein,
    FoodExchangeItem? preferredPlantProtein,
    List<FoodExchangeItem>? selectedCarbs,
    List<FoodExchangeItem>? selectedAnimalProteins,
    List<FoodExchangeItem>? selectedPlantProteins,
    List<FoodExchangeItem>? selectedVeggies,
    List<FoodExchangeItem>? selectedFruits,
    NutritionCalculationResult? nutResult,
    String? textureOverride,
  }) {
    var carbs = (selectedCarbs != null && selectedCarbs.isNotEmpty)
        ? selectedCarbs
        : (preferredCarb != null ? [preferredCarb] : [FoodExchangeRepository.carbsList.first]);

    var animalProteins = (selectedAnimalProteins != null && selectedAnimalProteins.isNotEmpty)
        ? selectedAnimalProteins
        : (preferredAnimalProtein != null ? [preferredAnimalProtein] : [FoodExchangeRepository.animalProteinMedFat.first]);

    final plantProteins = (selectedPlantProteins != null && selectedPlantProteins.isNotEmpty)
        ? selectedPlantProteins
        : (preferredPlantProtein != null ? [preferredPlantProtein] : [FoodExchangeRepository.plantProteinList.first]);

    final veggies = (selectedVeggies != null && selectedVeggies.isNotEmpty)
        ? selectedVeggies
        : FoodExchangeRepository.veggiesList;

    final fruits = (selectedFruits != null && selectedFruits.isNotEmpty)
        ? selectedFruits
        : FoodExchangeRepository.fruitsList;

    // Keamanan bahan: untuk anak <24 bulan, bahan olahan dikeluarkan dari
    // rotasi menu contoh (WHO 2023: hindari pangan ultra-proses/garam tinggi).
    if (ageMonths < 24.0) {
      final safeCarbs = carbs.where((i) => !_processedNames.contains(i.name)).toList();
      carbs = safeCarbs.isNotEmpty ? safeCarbs : [FoodExchangeRepository.carbsList.first];
      final safeAnimals = animalProteins.where((i) => !_processedNames.contains(i.name)).toList();
      animalProteins = safeAnimals.isNotEmpty ? safeAnimals : [FoodExchangeRepository.animalProteinMedFat.first];
    }

    final isCatchUp = nutResult?.needsCatchUp ?? false;
    final targetKcal = nutResult?.targetEnergyKcal;
    final hasTarget = targetKcal != null && targetKcal > 0;

    if (ageMonths < 6.0) {
      // 0-5 Bulan: ASI Eksklusif / Formula 7 Hari
      final totalMilkMl = hasTarget ? ((targetKcal / _infantMilkKcalPerMl) / 10).round() * 10 : 0;
      final perFeedMl = hasTarget ? ((totalMilkMl / 6) / 5).round() * 5 : 0;
      final lastFeedMl = hasTarget ? (totalMilkMl - perFeedMl * 5).clamp(0, totalMilkMl) : 0;
      DailyMealSession infantSession(String time, String name, String desc, String fallbackUrt, int ml) {
        if (!hasTarget || ml <= 0) {
          return DailyMealSession(time: time, sessionName: name, menuName: 'ASI / Formula', description: desc, portionUrt: fallbackUrt);
        }
        final m = _infantMilkMacros(ml);
        return DailyMealSession(
          time: time,
          sessionName: name,
          menuName: 'ASI / Formula',
          description: desc,
          portionUrt: 'ASI on demand (atau ±$ml mL ASIP/Formula)',
          kcal: m.kcal,
          carbsG: m.carbsG,
          proteinG: m.proteinG,
          fatG: m.fatG,
        );
      }

      return List.generate(7, (index) {
        const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
        return SingleDayMealPlan(
          dayName: days[index],
          theme: hasTarget
              ? 'ASI Eksklusif / Formula Bayi (Target ${targetKcal.round()} kcal)'
              : 'ASI Eksklusif / Formula Bayi',
          sessions: [
            infantSession('06:00', 'Pagi', 'Menyusu langsung / botol steril', 'Sesuai kehendak bayi (on demand)', perFeedMl),
            infantSession('09:00', 'Selingan Pagi', 'Menyusu hingga kenyang', '60-120 mL', perFeedMl),
            infantSession('12:00', 'Siang', 'Menyusu siang hari', '60-120 mL', perFeedMl),
            infantSession('15:00', 'Selingan Sore', 'Menyusu sore', '60-120 mL', perFeedMl),
            infantSession('18:00', 'Malam', 'Menyusu malam', '60-120 mL', perFeedMl),
            infantSession('21:00', 'Sebelum Tidur', 'Menyusu sebelum tidur', 'Sesuai kehendak bayi', lastFeedMl),
          ],
        );
      });
    }

    // Gaya masakan & variasi pengolahan kuliner per hari (Senin s/d Minggu)
    final cookingStyles = [
      ('Sup Kaldu Gurih', 'kuah kaldu bening gurih', 'sup sayur kaldu hangat', 'kuah bening segar'),
      ('Kukus & Tim Wangi', 'tim kukus gurih lembut', 'kukus bumbu aromatik', 'tim lembut harum'),
      ('Masak Gurih Santan Ringan', 'kuah santan encer gurih', 'tumis santan ringan', 'masak kuah santan gurih'),
      ('Semur / Bumbu Gurih Manis', 'semur bumbu gurih manis lunak', 'bumbu semur empuk', 'masak kecap gurih manis'),
      ('Sup Bola Cincang / Sayur', 'bola-bola cincang kuah sayur', 'kuah kaldu bola cincang', 'sup bola sayur hangat'),
      ('Tumis Lembut / Bumbu Gurih', 'tumis mentega/minyak kelapa lunak', 'masak tumis empuk', 'tumis bumbu gurih'),
      ('Bumbu Kuning / Soto Bening Segar', 'kuah soto bening rempah ringan', 'masak bumbu kuning gurih', 'kuah kuning segar'),
    ];

    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

    final profile = _profileFor(ageMonths, textureOverride);

    // Proporsi energi ASI/SF/Susu : Makanan Padat sesuai arahan klinis (IDAI / WHO):
    // - 6-8 bln:  70% ASI/SF : 30% MPASI
    // - 9-11 bln: 50% ASI/SF : 50% MPASI
    // - 12-23 bln: 30% ASI/Susu : 70% MPASI
    // - >=24 bln: Susu 1-2 gelas (200 mL jika target <1400, 400 mL jika >=1400), sisa penuh dari makanan keluarga
    // Target rasio makro harian: KH 40-60%, Protein ~15%, Lemak 35-50%.
    final milkItem = FoodExchangeRepository.milkList.first;
    final double olderMilkKcalPerMl =
        milkItem.grams > 0 ? milkItem.calories / milkItem.grams : 0.625;

    final int plannedMilkMl;
    final ({double kcal, double carbsG, double proteinG, double fatG}) plannedMilk;
    final double targetSolidsKcal;
    final double targetCarbPct;
    final double targetProPct;

    if (!hasTarget) {
      plannedMilkMl = 0;
      plannedMilk = (kcal: 0, carbsG: 0, proteinG: 0, fatG: 0);
      targetSolidsKcal = 0.0;
      targetCarbPct = 0.45;
      targetProPct = 0.15;
    } else if (ageMonths < 9.0) {
      plannedMilkMl = ((targetKcal * 0.70 / _infantMilkKcalPerMl) / 10).round() * 10;
      plannedMilk = _infantMilkMacros(plannedMilkMl);
      targetSolidsKcal = targetKcal * 0.30;
      targetCarbPct = 0.43;
      targetProPct = 0.13; // Sisa energi (~44%) dialokasikan ke lemak
    } else if (ageMonths < 12.0) {
      plannedMilkMl = ((targetKcal * 0.50 / _infantMilkKcalPerMl) / 10).round() * 10;
      plannedMilk = _infantMilkMacros(plannedMilkMl);
      targetSolidsKcal = targetKcal * 0.50;
      targetCarbPct = 0.43;
      targetProPct = 0.15; // Sisa energi (~42%) dialokasikan ke lemak
    } else if (ageMonths < 24.0) {
      plannedMilkMl = ((targetKcal * 0.30 / olderMilkKcalPerMl) / 10).round() * 10;
      plannedMilk = _olderMilkMacros(milkItem, plannedMilkMl);
      targetSolidsKcal = targetKcal * 0.70;
      targetCarbPct = 0.44;
      targetProPct = 0.15; // Sisa energi (~41%) dialokasikan ke lemak
    } else {
      final milkGlasses = targetKcal >= 1400 ? 2 : 1;
      plannedMilkMl = milkGlasses * milkItem.grams.round();
      plannedMilk = _olderMilkMacros(milkItem, plannedMilkMl);
      targetSolidsKcal = (targetKcal - plannedMilk.kcal).clamp(200.0, targetKcal);
      targetCarbPct = 0.45;
      targetProPct = 0.15; // Sisa energi (~40%) dialokasikan ke lemak
    }

    return List.generate(7, (index) {
      final dayName = days[index];
      final style = cookingStyles[index % cookingStyles.length];

      final currentCarb = carbs[index % carbs.length];
      // Rotasi protein hewani antar sesi agar dalam 1 hari bervariasi.
      final animalPagi = animalProteins[index % animalProteins.length];
      final animalSiang = animalProteins[(index + 1) % animalProteins.length];
      final animalMalam = animalProteins[(index + 2) % animalProteins.length];
      final currentPlant = plantProteins[index % plantProteins.length];
      final plantSiang = plantProteins[(index + 1) % plantProteins.length];
      final currentVeg = veggies[index % veggies.length];
      final currentFruit = fruits[index % fruits.length];

      final themeSuffix = isCatchUp && hasTarget ? ' • Kejar Tumbuh (${targetKcal.round()} kcal)' : '';
      final animalTheme = {animalPagi.name, animalSiang.name, animalMalam.name}.join(', ');
      final theme = 'Variasi $animalTheme (${currentCarb.name} & Sayur ${currentVeg.name})$themeSuffix';

      final fatTip = isCatchUp
          ? ' Menu padat energi untuk kejar tumbuh: tambahkan lemak sehat di tiap makan utama.'
          : '';

      // Takaran bawaan (dipakai bila target kalori tidak tersedia).
      final legacy = _legacyPortions(ageMonths, currentCarb, animalPagi, currentVeg, currentFruit);

      // Hitung 2 selingan buah terlebih dahulu (masing-masing ~5% energi padat)
      // agar sisa kebutuhan energi, KH, & protein untuk 3 makan utama dapat
      // dipecahkan tepat mencapai KH 40-60%, Protein ~15%, Lemak 35-50%.
      DailyMealSession buildFruitSnackBase({
        required String time,
        required String sessionName,
        required String menuName,
        required String description,
      }) {
        if (!hasTarget) {
          return DailyMealSession(
            time: time,
            sessionName: sessionName,
            menuName: menuName,
            description: description,
            portionUrt: legacy.snack,
          );
        }
        final fruit = _component(currentFruit, targetSolidsKcal * 0.05, 5);
        return DailyMealSession(
          time: time,
          sessionName: sessionName,
          menuName: menuName,
          description: description,
          portionUrt: _portionText(fruit),
          kcal: fruit.kcal,
          carbsG: fruit.carbsG,
          proteinG: fruit.proteinG,
          fatG: fruit.fatG,
        );
      }

      final selinganPagiBase = buildFruitSnackBase(
        time: '09:30',
        sessionName: 'Selingan Pagi',
        menuName: ageMonths < 9.0 ? 'Puree Buah ${currentFruit.name}' : 'Snack Pagi: Buah ${currentFruit.name}',
        description: 'Buah segar ${currentFruit.name} kaya vitamin & serat alami.',
      );
      final selinganSoreBase = buildFruitSnackBase(
        time: '15:30',
        sessionName: 'Selingan Sore',
        menuName: 'Snack Sore: Buah ${currentFruit.name}',
        description: ageMonths < 24.0
            ? 'Potongan buah ${currentFruit.name} atau ASI / Susu segar.'
            : 'Potongan buah segar ${currentFruit.name} atau Susu UHT / Pasteurisasi plain.',
      );

      final snacksKcal = selinganPagiBase.kcal + selinganSoreBase.kcal;
      final snacksCarbG = selinganPagiBase.carbsG + selinganSoreBase.carbsG;
      final snacksProG = selinganPagiBase.proteinG + selinganSoreBase.proteinG;

      final mainsTotalKcal = hasTarget
          ? (targetSolidsKcal - snacksKcal).clamp(90.0, targetSolidsKcal)
          : 0.0;
      final dailyTargetCarbG = hasTarget ? (targetKcal * targetCarbPct) / 4.0 : 0.0;
      final dailyTargetProG = hasTarget ? (targetKcal * targetProPct) / 4.0 : 0.0;

      var remainingMainsKcal = mainsTotalKcal;
      var remainingMainsCarbG = (dailyTargetCarbG - plannedMilk.carbsG - snacksCarbG).clamp(0.0, dailyTargetCarbG);
      var remainingMainsProG = (dailyTargetProG - plannedMilk.proteinG - snacksProG).clamp(0.0, dailyTargetProG);
      var remainingMainsShare = 1.0;

      DailyMealSession mainSession({
        required String time,
        required String sessionName,
        required String menuName,
        required String description,
        required FoodExchangeItem animal,
        required FoodExchangeItem plant,
        required double shareOfMains,
        bool isLastSolid = false,
      }) {
        if (!hasTarget) {
          return DailyMealSession(
            time: time,
            sessionName: sessionName,
            menuName: menuName,
            description: description,
            portionUrt: legacy.main,
          );
        }

        final double mealKcal;
        final double mealCarbG;
        final double mealProG;
        if (isLastSolid || remainingMainsShare <= shareOfMains + 1e-6) {
          mealKcal = remainingMainsKcal.clamp(30.0, mainsTotalKcal);
          mealCarbG = remainingMainsCarbG.clamp(0.0, dailyTargetCarbG);
          mealProG = remainingMainsProG.clamp(0.0, dailyTargetProG);
          remainingMainsShare = 0.0;
        } else {
          final ratio = shareOfMains / remainingMainsShare;
          mealKcal = (remainingMainsKcal * ratio).clamp(30.0, mainsTotalKcal);
          mealCarbG = (remainingMainsCarbG * ratio).clamp(0.0, dailyTargetCarbG);
          mealProG = (remainingMainsProG * ratio).clamp(0.0, dailyTargetProG);
          remainingMainsShare -= shareOfMains;
        }

        final sayur = _component(currentVeg, mealKcal * 0.05, 10);
        final nabati = _component(plant, mealKcal * 0.07, 5);

        final remCarbG = (mealCarbG - sayur.carbsG - nabati.carbsG).clamp(0.0, mealCarbG);
        final rawCarbKcal = currentCarb.carbs > 0
            ? remCarbG * currentCarb.calories / currentCarb.carbs
            : mealKcal * 0.42;
        final carbKcal = rawCarbKcal.clamp(mealKcal * 0.22, mealKcal * 0.55);
        var carb = _component(currentCarb, carbKcal, 5);

        final remProG = (mealProG - carb.proteinG - nabati.proteinG - sayur.proteinG).clamp(0.0, mealProG);
        final rawAnimalKcal = animal.protein > 0
            ? remProG * animal.calories / animal.protein
            : mealKcal * 0.18;
        final maxAnimalShare = ageMonths < 12.0 ? 0.42 : 0.35;
        final animalKcal = rawAnimalKcal.clamp(mealKcal * 0.10, mealKcal * maxAnimalShare);
        final hewani = _component(animal, animalKcal, 5);

        var foodKcalBeforeOil = carb.kcal + hewani.kcal + nabati.kcal + sayur.kcal;
        final desiredOilKcal = (mealKcal - foodKcalBeforeOil).clamp(0.0, mealKcal * 0.45);
        final double upperOilSdt = ageMonths < 24.0 ? 2.5 : 3.5;
        var oilSdt = ((desiredOilKcal / _oilKcalPerSdt) * 2).round() / 2;
        if (oilSdt < 0.5) oilSdt = 0.5;
        if (oilSdt > upperOilSdt) oilSdt = upperOilSdt;

        // Untuk >=24 bln (susu tetap 1-2 gelas), sesuaikan gramasi karbohidrat
        // pada makan malam bila masih ada selisih >15 kkal terhadap target harian.
        if (isLastSolid && ageMonths >= 24.0 && currentCarb.calories > 0 && currentCarb.grams > 0) {
          final residual = mealKcal - (foodKcalBeforeOil + oilSdt * _oilKcalPerSdt);
          if (residual.abs() > 15.0) {
            final kcalPerGramCarb = currentCarb.calories / currentCarb.grams;
            final deltaGrams = ((residual / kcalPerGramCarb) / 5).round() * 5.0;
            final maxCarbGrams = (carb.grams * 1.8) > 10.0 ? carb.grams * 1.8 : 10.0;
            final adjustedGrams = (carb.grams + deltaGrams).clamp(10.0, maxCarbGrams);
            final r = adjustedGrams / currentCarb.grams;
            carb = _Component(
              currentCarb,
              adjustedGrams,
              currentCarb.calories * r,
              currentCarb.carbs * r,
              currentCarb.protein * r,
              currentCarb.fat * r,
            );
            foodKcalBeforeOil = carb.kcal + hewani.kcal + nabati.kcal + sayur.kcal;
          }
        }

        final oilKcal = oilSdt * _oilKcalPerSdt;
        final oilFat = oilSdt * 5.0;
        final actualSessionKcal = foodKcalBeforeOil + oilKcal;
        final actualCarbG = carb.carbsG + hewani.carbsG + nabati.carbsG + sayur.carbsG;
        final actualProG = carb.proteinG + hewani.proteinG + nabati.proteinG + sayur.proteinG;

        remainingMainsKcal -= actualSessionKcal;
        remainingMainsCarbG = (remainingMainsCarbG - actualCarbG).clamp(0.0, dailyTargetCarbG);
        remainingMainsProG = (remainingMainsProG - actualProG).clamp(0.0, dailyTargetProG);

        final portion = '${profile.bowlLabel}: '
            '${_portionText(carb)}, ${_portionText(hewani)}, ${_portionText(nabati)}, '
            'Sayur ${_portionText(sayur)}, minyak/santan ${oilSdt.toString().replaceAll('.0', '')} sdt';

        return DailyMealSession(
          time: time,
          sessionName: sessionName,
          menuName: menuName,
          description: description,
          portionUrt: portion,
          kcal: actualSessionKcal,
          carbsG: actualCarbG,
          proteinG: actualProG,
          fatG: carb.fatG + hewani.fatG + nabati.fatG + sayur.fatG + oilFat,
        );
      }

      final pagi = mainSession(
        time: '07:00',
        sessionName: 'Makan Pagi',
        menuName: ageMonths < 9.0
            ? 'Bubur Lumat ${currentCarb.name} + ${animalPagi.name}'
            : 'Menu Pagi: ${currentCarb.name} + ${animalPagi.name} + Sayur ${currentVeg.name}',
        description: '${profile.guide}. ${currentCarb.name} dimasak bersama ${animalPagi.name}, ${currentPlant.name}, & Sayur ${currentVeg.name}.$fatTip',
        animal: animalPagi,
        plant: currentPlant,
        shareOfMains: 30.0 / 90.0,
      );

      final siang = mainSession(
        time: '12:00',
        sessionName: 'Makan Siang',
        menuName: 'Menu Siang: ${currentCarb.name} + ${animalSiang.name} (${style.$1}) + ${plantSiang.name}',
        description: '${profile.guide}. ${currentCarb.name} dengan ${animalSiang.name} ${style.$2}, ${plantSiang.name}, & Sayur ${currentVeg.name}.$fatTip',
        animal: animalSiang,
        plant: plantSiang,
        shareOfMains: 35.0 / 90.0,
      );

      final malam = mainSession(
        time: '18:00',
        sessionName: 'Makan Malam',
        menuName: 'Menu Malam: ${currentCarb.name} + ${animalMalam.name} (${style.$4}) + ${currentPlant.name}',
        description: '${profile.guide}. ${currentCarb.name} dengan ${animalMalam.name} empuk, ${currentPlant.name}, & Sayur ${currentVeg.name}.$fatTip',
        animal: animalMalam,
        plant: currentPlant,
        shareOfMains: 25.0 / 90.0,
        isLastSolid: true,
      );

      DailyMealSession selinganPagi = selinganPagiBase;
      DailyMealSession selinganSore = selinganSoreBase;
      final DailyMealSession susuMalam;

      if (!hasTarget) {
        if (ageMonths >= 12.0) {
          susuMalam = DailyMealSession(
            time: '20:30',
            sessionName: 'Sebelum Tidur',
            menuName: 'Susu Malam',
            description: ageMonths < 24.0
                ? 'Susu Sapi Pasteurisasi / UHT plain. Pilihan susu: PKMK, PDK, atau UHT plain sesuai advis dokter (WHO: tanpa formula lanjutan). ASI tetap dapat diteruskan.'
                : 'Susu UHT / Pasteurisasi plain. Pilihan susu: PKMK, PDK, atau UHT sesuai advis dokter.',
            portionUrt: 'Susu 200 mL (1 gelas)',
          );
        } else {
          susuMalam = const DailyMealSession(
            time: '20:30',
            sessionName: 'Sebelum Tidur',
            menuName: 'ASI / Susu Malam',
            description: 'Menyusu ASI on demand sebelum tidur. Bila non-ASI, susu formula/PKMK sesuai advis dokter (±200 mL, tidak dihitung dalam total tabel).',
            portionUrt: 'Sesuai kehendak bayi (on demand)',
          );
        }
      } else if (ageMonths < 12.0) {
        // 6-8 bln (~70% ASI/SF : 30% MPASI) dan 9-11 bln (~50% ASI/SF : 50% MPASI)
        final solidsActual = pagi.kcal + selinganPagiBase.kcal + siang.kcal + selinganSoreBase.kcal + malam.kcal;
        final milkGapKcal = (targetKcal - solidsActual).clamp(0.0, targetKcal);
        final totalMilkMl = ((milkGapKcal / _infantMilkKcalPerMl) / 10).round() * 10;
        final mlPagi = ((totalMilkMl * 0.25) / 10).round() * 10;
        final mlSore = ((totalMilkMl * 0.25) / 10).round() * 10;
        final mlMalam = (totalMilkMl - mlPagi - mlSore).clamp(0, totalMilkMl);

        DailyMealSession attachInfantMilk(DailyMealSession base, int ml) {
          if (ml <= 0) return base;
          final m = _infantMilkMacros(ml);
          return DailyMealSession(
            time: base.time,
            sessionName: base.sessionName,
            menuName: '${base.menuName} + ASI/Susu',
            description: '${base.description} Disertai ASI/Formula ±$ml mL (bila PKMK 1 kkal/mL, sesuaikan volume advis dokter).',
            portionUrt: '${base.portionUrt} + ASI/Susu $ml mL',
            kcal: base.kcal + m.kcal,
            carbsG: base.carbsG + m.carbsG,
            proteinG: base.proteinG + m.proteinG,
            fatG: base.fatG + m.fatG,
          );
        }

        selinganPagi = attachInfantMilk(selinganPagiBase, mlPagi);
        selinganSore = attachInfantMilk(selinganSoreBase, mlSore);

        final milkPctLabel = ageMonths < 9.0 ? '~70%' : '~50%';
        final mMalam = _infantMilkMacros(mlMalam);
        susuMalam = DailyMealSession(
          time: '20:30',
          sessionName: 'Sebelum Tidur',
          menuName: 'ASI / Susu Malam & Dini Hari',
          description: 'ASI on demand (porsi susu $milkPctLabel target harian, ekuivalen total ±$totalMilkMl mL/hari; malam & dini hari ±$mlMalam mL). Bila non-ASI/PKMK, sesuaikan volume & densitas energi advis dokter.',
          portionUrt: mlMalam > 0 ? 'ASI on demand (ekuivalen ±$mlMalam mL)' : 'Sesuai kehendak bayi (on demand)',
          kcal: mMalam.kcal,
          carbsG: mMalam.carbsG,
          proteinG: mMalam.proteinG,
          fatG: mMalam.fatG,
        );
      } else if (ageMonths < 24.0) {
        // 12-23 bln: ~30% ASI/Susu : ~70% MPASI
        final solidsActual = pagi.kcal + selinganPagiBase.kcal + siang.kcal + selinganSoreBase.kcal + malam.kcal;
        final milkGapKcal = (targetKcal - solidsActual).clamp(targetKcal * 0.22, targetKcal * 0.38);
        var totalMilkMl = ((milkGapKcal / olderMilkKcalPerMl) / 10).round() * 10;
        if (totalMilkMl < 200) totalMilkMl = 200;

        DailyMealSession attachOlderMilk(DailyMealSession base, int ml) {
          if (ml <= 0) return base;
          final m = _olderMilkMacros(milkItem, ml);
          return DailyMealSession(
            time: base.time,
            sessionName: base.sessionName,
            menuName: '${base.menuName} + Susu/ASI',
            description: '${base.description} Ditambah Susu Sapi Pasteurisasi / UHT plain ±$ml mL atau ASI.',
            portionUrt: '${base.portionUrt} + Susu/ASI $ml mL',
            kcal: base.kcal + m.kcal,
            carbsG: base.carbsG + m.carbsG,
            proteinG: base.proteinG + m.proteinG,
            fatG: base.fatG + m.fatG,
          );
        }

        final int mlMalam;
        if (totalMilkMl <= 500) {
          final mlSore = ((totalMilkMl * 0.50) / 10).round() * 10;
          mlMalam = (totalMilkMl - mlSore).clamp(0, totalMilkMl);
          selinganSore = attachOlderMilk(selinganSoreBase, mlSore);
        } else {
          final mlPagi = ((totalMilkMl * 0.30) / 10).round() * 10;
          final mlSore = ((totalMilkMl * 0.35) / 10).round() * 10;
          mlMalam = (totalMilkMl - mlPagi - mlSore).clamp(0, totalMilkMl);
          selinganPagi = attachOlderMilk(selinganPagiBase, mlPagi);
          selinganSore = attachOlderMilk(selinganSoreBase, mlSore);
        }

        final mMalam = _olderMilkMacros(milkItem, mlMalam);
        susuMalam = DailyMealSession(
          time: '20:30',
          sessionName: 'Sebelum Tidur',
          menuName: 'Susu Malam',
          description: 'Susu Sapi Pasteurisasi / UHT plain (±$totalMilkMl mL/hari, ~30% energi harian). Pilihan susu: PKMK, PDK, atau UHT plain sesuai advis dokter (WHO: tanpa formula lanjutan). ASI tetap dapat diteruskan.',
          portionUrt: mlMalam == 200 ? 'Susu 200 mL (1 gelas)' : 'Susu $mlMalam mL',
          kcal: mMalam.kcal,
          carbsG: mMalam.carbsG,
          proteinG: mMalam.proteinG,
          fatG: mMalam.fatG,
        );
      } else {
        // >=24 bln: 1 gelas (200 mL) atau 2 gelas (400 mL: sore + malam)
        if (plannedMilkMl >= 400) {
          final mSore = _olderMilkMacros(milkItem, 200);
          selinganSore = DailyMealSession(
            time: selinganSoreBase.time,
            sessionName: selinganSoreBase.sessionName,
            menuName: '${selinganSoreBase.menuName} + Susu Sore',
            description: '${selinganSoreBase.description} Ditambah 1 gelas (200 mL) susu UHT/pasteurisasi plain atau ASI.',
            portionUrt: '${selinganSoreBase.portionUrt} + Susu 200 mL (1 gelas)',
            kcal: selinganSoreBase.kcal + mSore.kcal,
            carbsG: selinganSoreBase.carbsG + mSore.carbsG,
            proteinG: selinganSoreBase.proteinG + mSore.proteinG,
            fatG: selinganSoreBase.fatG + mSore.fatG,
          );
        }
        susuMalam = DailyMealSession(
          time: '20:30',
          sessionName: 'Sebelum Tidur',
          menuName: 'Susu Malam',
          description: 'Susu UHT / Pasteurisasi plain. Pilihan susu: PKMK, PDK, atau UHT sesuai advis dokter.',
          portionUrt: 'Susu 200 mL (1 gelas)',
          kcal: milkItem.calories,
          carbsG: milkItem.carbs,
          proteinG: milkItem.protein,
          fatG: milkItem.fat,
        );
      }

      return SingleDayMealPlan(
        dayName: dayName,
        theme: theme,
        sessions: [
          pagi,
          selinganPagi,
          siang,
          selinganSore,
          malam,
          susuMalam,
        ],
      );
    }).toList();
  }

  static _TextureProfile _profileFor(double ageMonths, String? textureOverride) {
    switch (textureOverride) {
      case 'saring':
        return _profileSaring;
      case 'lembik':
        return _profileLembik;
      case 'keluarga':
        return _profileKeluarga;
    }
    if (ageMonths < 9.0) return _profileSaring;
    if (ageMonths < 12.0) return _profileLembik;
    if (ageMonths < 24.0) return _profileKeluargaCincang;
    return _profileKeluarga;
  }

  /// Hitung komponen dari target energi sesi memakai satuan penukar bahan:
  /// gram dibulatkan ke kelipatan [step] g agar praktis ditakar di rumah,
  /// lalu energi/makro dihitung ulang dari gram final.
  static _Component _component(FoodExchangeItem item, double kcalShare, double step) {
    if (item.calories <= 0 || item.grams <= 0 || kcalShare <= 0) {
      return _Component(item, 0, 0, 0, 0, 0);
    }
    final rawGrams = kcalShare * item.grams / item.calories;
    var grams = (rawGrams / step).round() * step;
    if (grams < step) grams = step;
    final ratio = grams / item.grams;
    return _Component(
      item,
      grams,
      item.calories * ratio,
      item.carbs * ratio,
      item.protein * ratio,
      item.fat * ratio,
    );
  }

  /// Teks takaran yang mudah diterapkan: nama + gram + setara URT penukar.
  static String _portionText(_Component c) {
    final grams = c.grams.round();
    final units = c.item.grams > 0 ? c.grams / c.item.grams : 0.0;
    final String equiv;
    if ((units - 1).abs() < 0.15) {
      equiv = c.item.urt;
    } else {
      var u = units.toStringAsFixed(2);
      if (u.contains('.')) {
        u = u.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
      }
      equiv = '$u satuan penukar (${c.item.urt})';
    }
    return '${c.item.name} $grams g (±$equiv)';
  }

  /// Takaran bawaan per usia (mode tanpa target kalori).
  static ({String main, String snack}) _legacyPortions(
    double ageMonths,
    FoodExchangeItem carb,
    FoodExchangeItem animal,
    FoodExchangeItem veg,
    FoodExchangeItem fruit,
  ) {
    if (ageMonths < 9.0) {
      return (
        main: '2-3 sdm bubur lumat (~25g ${carb.name} + 10-15g ${animal.name} + Sayur ${veg.name} lumat)',
        snack: '2-3 sdt puree buah ${fruit.name}',
      );
    } else if (ageMonths < 12.0) {
      return (
        main: '1/2 mangkuk (125 mL) tim cincang (~50g ${carb.name} + 15-20g ${animal.name} + Sayur ${veg.name} cincang)',
        snack: '1-2 potong finger food buah ${fruit.name}',
      );
    } else if (ageMonths < 24.0) {
      return (
        main: '3/4 mangkuk (175 mL) makanan cincang (~75g ${carb.name} + 30g ${animal.name} + Sayur ${veg.name})',
        snack: '1 potong buah segar ${fruit.name}',
      );
    }
    return (
      main: '1 porsi piring makan (${carb.name} [${carb.displayUrt}] + ${animal.name} [${animal.displayUrt}] + Sayur ${veg.name} [${veg.displayUrt}])',
      snack: '1 porsi buah segar ${fruit.name} [${fruit.displayUrt}]',
    );
  }
}
