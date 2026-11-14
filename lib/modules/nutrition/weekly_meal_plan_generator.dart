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

    // Porsi energi makanan padat vs ASI/Susu agar total kalori harian
    // (makanan padat + ASI/Susu terhitung) mendekati target kalori yang dihitung:
    // - 6-8 bln: MPASI ~40% target, sisa ~60% ASI/Formula/PKMK terhitung
    // - 9-11 bln: MPASI ~55% target, sisa ~45% ASI/Formula/PKMK terhitung
    // - 12-23 bln: Susu 2x200 mL (400 mL = 250 kkal, atau 1x200 mL bila target <900), sisa penuh dari makanan padat
    // - >=24 bln: Susu 1-2x200 mL (200 mL bila target <1400, 400 mL bila >=1400), sisa penuh dari makanan padat
    final milkItem = FoodExchangeRepository.milkList.first;
    final int milkGlassesForOlder;
    if (ageMonths < 12.0) {
      milkGlassesForOlder = 0;
    } else if (ageMonths < 24.0) {
      milkGlassesForOlder = (hasTarget && targetKcal < 900) ? 1 : 2;
    } else {
      milkGlassesForOlder = (hasTarget && targetKcal >= 1400) ? 2 : 1;
    }
    final double plannedOlderMilkKcal = milkGlassesForOlder * milkItem.calories;

    final double targetSolidsKcal;
    if (!hasTarget) {
      targetSolidsKcal = 0.0;
    } else if (ageMonths < 9.0) {
      targetSolidsKcal = (targetKcal * 0.40).clamp(150.0, targetKcal * 0.55);
    } else if (ageMonths < 12.0) {
      targetSolidsKcal = (targetKcal * 0.55).clamp(220.0, targetKcal * 0.65);
    } else {
      targetSolidsKcal = (targetKcal - plannedOlderMilkKcal).clamp(200.0, targetKcal);
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

      // Pelacak sisa anggaran energi makanan padat agar error pembulatan
      // per sesi tidak menumpuk menjauhi target.
      var remainingSolidsBudget = targetSolidsKcal;
      var remainingSolidsShare = 1.0;

      double claimSessionBudget(double share, {bool isLastSolid = false}) {
        if (!hasTarget) return 0.0;
        if (isLastSolid || remainingSolidsShare <= share + 1e-6) {
          final b = remainingSolidsBudget.clamp(40.0, targetSolidsKcal);
          remainingSolidsShare = 0.0;
          return b;
        }
        final allocated = (remainingSolidsBudget * (share / remainingSolidsShare)).clamp(20.0, targetSolidsKcal);
        remainingSolidsShare -= share;
        return allocated;
      }

      DailyMealSession mainSession({
        required String time,
        required String sessionName,
        required String menuName,
        required String description,
        required FoodExchangeItem animal,
        required FoodExchangeItem plant,
        required double kcalShareOfSolids,
        required String legacyPortion,
        bool isLastSolid = false,
      }) {
        if (!hasTarget) {
          return DailyMealSession(
            time: time,
            sessionName: sessionName,
            menuName: menuName,
            description: description,
            portionUrt: legacyPortion,
          );
        }
        final sessionKcal = claimSessionBudget(kcalShareOfSolids, isLastSolid: isLastSolid);
        // Komposisi sesi utama dari penukar: karbo 45%, hewani 27%,
        // nabati 10%, sayur 5%, lemak tambahan ~13% (menyesuaikan sisa
        // pembulatan gramasi agar energi sesi mendekati sessionKcal).
        var carb = _component(currentCarb, sessionKcal * 0.45, 5);
        final hewani = _component(animal, sessionKcal * 0.27, 5);
        final nabati = _component(plant, sessionKcal * 0.10, 5);
        final sayur = _component(currentVeg, sessionKcal * 0.05, 10);

        final foodKcalBeforeOil = carb.kcal + hewani.kcal + nabati.kcal + sayur.kcal;
        final desiredOilKcal = (sessionKcal - foodKcalBeforeOil).clamp(0.0, sessionKcal * 0.25);
        final maxOilSdt = ((sessionKcal * 0.22) / _oilKcalPerSdt * 2).ceil() / 2;
        final upperOilSdt = maxOilSdt < 1.0 ? 1.0 : (maxOilSdt > 2.5 ? 2.5 : maxOilSdt);
        var oilSdt = ((desiredOilKcal / _oilKcalPerSdt) * 2).round() / 2;
        if (oilSdt < 0.5) oilSdt = 0.5;
        if (oilSdt > upperOilSdt) oilSdt = upperOilSdt;

        // Pada sesi padat terakhir untuk >=12 bln (susu tetap per gelas),
        // sesuaikan gramasi karbohidrat jika masih ada selisih >12 kkal.
        if (isLastSolid && ageMonths >= 12.0 && currentCarb.calories > 0 && currentCarb.grams > 0) {
          final residual = sessionKcal - (foodKcalBeforeOil + oilSdt * _oilKcalPerSdt);
          if (residual.abs() > 12.0) {
            final kcalPerGramCarb = currentCarb.calories / currentCarb.grams;
            final deltaGrams = ((residual / kcalPerGramCarb) / 5).round() * 5.0;
            final adjustedGrams = (carb.grams + deltaGrams).clamp(10.0, carb.grams * 2.0);
            final r = adjustedGrams / currentCarb.grams;
            carb = _Component(
              currentCarb,
              adjustedGrams,
              currentCarb.calories * r,
              currentCarb.carbs * r,
              currentCarb.protein * r,
              currentCarb.fat * r,
            );
          }
        }

        final oilKcal = oilSdt * _oilKcalPerSdt;
        final oilFat = oilSdt * 5.0;
        final actualSessionKcal = carb.kcal + hewani.kcal + nabati.kcal + sayur.kcal + oilKcal;
        remainingSolidsBudget -= actualSessionKcal;

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
          carbsG: carb.carbsG + hewani.carbsG + nabati.carbsG + sayur.carbsG,
          proteinG: carb.proteinG + hewani.proteinG + nabati.proteinG + sayur.proteinG,
          fatG: carb.fatG + hewani.fatG + nabati.fatG + sayur.fatG + oilFat,
        );
      }

      DailyMealSession snackFruitSession({
        required String time,
        required String sessionName,
        required String menuName,
        required String description,
        required String legacyPortion,
        int extraInfantMilkMl = 0,
        bool includeOneGlassOlderMilk = false,
      }) {
        if (!hasTarget) {
          return DailyMealSession(
            time: time,
            sessionName: sessionName,
            menuName: menuName,
            description: description,
            portionUrt: legacyPortion,
          );
        }
        final snackBudget = claimSessionBudget(0.05);
        final fruit = _component(currentFruit, snackBudget, 5);
        remainingSolidsBudget -= fruit.kcal;

        var totalKcal = fruit.kcal;
        var totalCarbs = fruit.carbsG;
        var totalPro = fruit.proteinG;
        var totalFat = fruit.fatG;
        var portionText = _portionText(fruit);
        var finalMenu = menuName;
        var finalDesc = description;

        if (extraInfantMilkMl > 0) {
          final m = _infantMilkMacros(extraInfantMilkMl);
          totalKcal += m.kcal;
          totalCarbs += m.carbsG;
          totalPro += m.proteinG;
          totalFat += m.fatG;
          portionText = '$portionText + ASI/Susu $extraInfantMilkMl mL';
          finalMenu = '$menuName + ASI/Susu';
        } else if (includeOneGlassOlderMilk) {
          totalKcal += milkItem.calories;
          totalCarbs += milkItem.carbs;
          totalPro += milkItem.protein;
          totalFat += milkItem.fat;
          portionText = '$portionText + Susu 200 mL (1 gelas)';
          finalMenu = '$menuName + Susu Sore';
          finalDesc = '$description Ditambah 1 gelas (200 mL) susu UHT/pasteurisasi plain atau ASI.';
        }

        return DailyMealSession(
          time: time,
          sessionName: sessionName,
          menuName: finalMenu,
          description: finalDesc,
          portionUrt: portionText,
          kcal: totalKcal,
          carbsG: totalCarbs,
          proteinG: totalPro,
          fatG: totalFat,
        );
      }

      // Takaran bawaan (dipakai bila target kalori tidak tersedia).
      final legacy = _legacyPortions(ageMonths, currentCarb, animalPagi, currentVeg, currentFruit);

      // Susun 5 sesi makanan padat terlebih dahulu agar sisa energi untuk
      // ASI/Susu bayi (<12 bln) dapat dihitung tepat menutup target harian.
      final pagi = mainSession(
        time: '07:00',
        sessionName: 'Makan Pagi',
        menuName: ageMonths < 9.0
            ? 'Bubur Lumat ${currentCarb.name} + ${animalPagi.name}'
            : 'Menu Pagi: ${currentCarb.name} + ${animalPagi.name} + Sayur ${currentVeg.name}',
        description: '${profile.guide}. ${currentCarb.name} dimasak bersama ${animalPagi.name}, ${currentPlant.name}, & Sayur ${currentVeg.name}.$fatTip',
        animal: animalPagi,
        plant: currentPlant,
        kcalShareOfSolids: 0.30,
        legacyPortion: legacy.main,
      );

      // Untuk <12 bln dengan target kalori, kita hitung sisa kebutuhan susu
      // setelah seluruh sesi padat terhitung. Karena Selingan Pagi & Sore
      // juga membawa komponen buah, hitung buahnya dulu lewat snackFruitSession
      // lalu tambahkan alokasi susu jika <12 bln!
      final selinganPagiBase = snackFruitSession(
        time: '09:30',
        sessionName: 'Selingan Pagi',
        menuName: ageMonths < 9.0 ? 'Puree Buah ${currentFruit.name}' : 'Snack Pagi: Buah ${currentFruit.name}',
        description: 'Buah segar ${currentFruit.name} kaya vitamin & serat alami.',
        legacyPortion: legacy.snack,
      );

      final siang = mainSession(
        time: '12:00',
        sessionName: 'Makan Siang',
        menuName: 'Menu Siang: ${currentCarb.name} + ${animalSiang.name} (${style.$1}) + ${plantSiang.name}',
        description: '${profile.guide}. ${currentCarb.name} dengan ${animalSiang.name} ${style.$2}, ${plantSiang.name}, & Sayur ${currentVeg.name}.$fatTip',
        animal: animalSiang,
        plant: plantSiang,
        kcalShareOfSolids: 0.35,
        legacyPortion: legacy.main,
      );

      final selinganSoreBase = snackFruitSession(
        time: '15:30',
        sessionName: 'Selingan Sore',
        menuName: 'Snack Sore: Buah ${currentFruit.name}',
        description: ageMonths < 24.0
            ? 'Potongan buah ${currentFruit.name} atau ASI / Susu segar.'
            : 'Potongan buah segar ${currentFruit.name} atau Susu UHT / Pasteurisasi plain.',
        legacyPortion: legacy.snack,
        includeOneGlassOlderMilk: hasTarget && ageMonths >= 12.0 && milkGlassesForOlder >= 2,
      );

      final malam = mainSession(
        time: '18:00',
        sessionName: 'Makan Malam',
        menuName: 'Menu Malam: ${currentCarb.name} + ${animalMalam.name} (${style.$4}) + ${currentPlant.name}',
        description: '${profile.guide}. ${currentCarb.name} dengan ${animalMalam.name} empuk, ${currentPlant.name}, & Sayur ${currentVeg.name}.$fatTip',
        animal: animalMalam,
        plant: currentPlant,
        kcalShareOfSolids: 0.25,
        legacyPortion: legacy.main,
        isLastSolid: true,
      );

      DailyMealSession selinganPagi = selinganPagiBase;
      DailyMealSession selinganSore = selinganSoreBase;
      final DailyMealSession susuMalam;

      if (ageMonths >= 12.0) {
        susuMalam = DailyMealSession(
          time: '20:30',
          sessionName: 'Sebelum Tidur',
          menuName: 'Susu Malam',
          description: ageMonths < 24.0
              ? 'Susu Sapi Pasteurisasi / UHT plain. Pilihan susu: PKMK, PDK, atau UHT plain sesuai advis dokter (WHO: tanpa formula lanjutan). ASI tetap dapat diteruskan.'
              : 'Susu UHT / Pasteurisasi plain. Pilihan susu: PKMK, PDK, atau UHT sesuai advis dokter.',
          portionUrt: 'Susu 200 mL (1 gelas)',
          kcal: hasTarget ? milkItem.calories : 0,
          carbsG: hasTarget ? milkItem.carbs : 0,
          proteinG: hasTarget ? milkItem.protein : 0,
          fatG: hasTarget ? milkItem.fat : 0,
        );
      } else if (hasTarget) {
        // 6-11 bln: hitung porsi ASI/Formula/PKMK untuk menutup selisih target
        // agar total energi harian di menu mendekati target kalori terhitung.
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

        final mMalam = _infantMilkMacros(mlMalam);
        susuMalam = DailyMealSession(
          time: '20:30',
          sessionName: 'Sebelum Tidur',
          menuName: 'ASI / Susu Malam & Dini Hari',
          description: 'ASI on demand (ekuivalen total harian ±$totalMilkMl mL; malam & dini hari ±$mlMalam mL). Bila non-ASI/PKMK, sesuaikan volume & densitas energi advis dokter.',
          portionUrt: mlMalam > 0 ? 'ASI on demand (ekuivalen ±$mlMalam mL)' : 'Sesuai kehendak bayi (on demand)',
          kcal: mMalam.kcal,
          carbsG: mMalam.carbsG,
          proteinG: mMalam.proteinG,
          fatG: mMalam.fatG,
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
