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

    if (ageMonths < 6.0) {
      // 0-5 Bulan: ASI Eksklusif / Formula 7 Hari
      return List.generate(7, (index) {
        final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
        return SingleDayMealPlan(
          dayName: days[index],
          theme: 'ASI Eksklusif / Formula Bayi',
          sessions: const [
            DailyMealSession(time: '06:00', sessionName: 'Pagi', menuName: 'ASI / Formula', description: 'Menyusu langsung / botol steril', portionUrt: 'Sesuai kehendak bayi (on demand)'),
            DailyMealSession(time: '09:00', sessionName: 'Selingan Pagi', menuName: 'ASI / Formula', description: 'Menyusu hingga kenyang', portionUrt: '60-120 mL'),
            DailyMealSession(time: '12:00', sessionName: 'Siang', menuName: 'ASI / Formula', description: 'Menyusu siang hari', portionUrt: '60-120 mL'),
            DailyMealSession(time: '15:00', sessionName: 'Selingan Sore', menuName: 'ASI / Formula', description: 'Menyusu sore', portionUrt: '60-120 mL'),
            DailyMealSession(time: '18:00', sessionName: 'Malam', menuName: 'ASI / Formula', description: 'Menyusu malam', portionUrt: '60-120 mL'),
            DailyMealSession(time: '21:00', sessionName: 'Sebelum Tidur', menuName: 'ASI / Formula', description: 'Menyusu sebelum tidur', portionUrt: 'Sesuai kehendak bayi'),
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
    final isCatchUp = nutResult?.needsCatchUp ?? false;
    final targetKcal = nutResult?.targetEnergyKcal;
    final hasTarget = targetKcal != null && targetKcal > 0;

    // Porsi energi dari makanan padat (MPASI/makanan keluarga) terhadap
    // target harian; sisanya dipenuhi ASI/susu on demand yang tidak
    // dihitung dalam tabel (acuan proporsi energi MPASI WHO 2023).
    final double foodShare;
    if (ageMonths < 9.0) {
      foodShare = 0.32;
    } else if (ageMonths < 12.0) {
      foodShare = 0.45;
    } else if (ageMonths < 24.0) {
      foodShare = 0.62;
    } else {
      foodShare = 0.85;
    }
    final solidsKcal = hasTarget ? targetKcal * foodShare : 0.0;
    // Susu malam terhitung untuk >=12 bulan: 1 satuan penukar susu (200 mL).
    final milkItem = FoodExchangeRepository.milkList.first;
    final countedMilk = ageMonths >= 12.0;

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
      final theme = 'Variasi $animalTheme ($currentCarb.name & Sayur ${currentVeg.name})$themeSuffix';

      final fatTip = isCatchUp
          ? ' Menu padat energi untuk kejar tumbuh: tambahkan lemak sehat di tiap makan utama.'
          : '';

      DailyMealSession mainSession({
        required String time,
        required String sessionName,
        required String menuName,
        required String description,
        required FoodExchangeItem animal,
        required FoodExchangeItem plant,
        required double kcalShareOfSolids,
        required String legacyPortion,
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
        final sessionKcal = solidsKcal * kcalShareOfSolids;
        // Komposisi sesi utama dari penukar: karbo 45%, hewani 27%,
        // nabati 10%, sayur 5%, lemak tambahan 13% dari energi sesi.
        final carb = _component(currentCarb, sessionKcal * 0.45, 5);
        final hewani = _component(animal, sessionKcal * 0.27, 5);
        final nabati = _component(plant, sessionKcal * 0.10, 5);
        final sayur = _component(currentVeg, sessionKcal * 0.05, 10);
        var oilSdt = ((sessionKcal * 0.13) / _oilKcalPerSdt * 2).round() / 2;
        if (oilSdt < 0.5) oilSdt = 0.5; // minimal 1/2 sdt lemak tambahan per makan utama
        final oilKcal = oilSdt * _oilKcalPerSdt;
        final oilFat = oilSdt * 5.0;

        final portion = '${profile.bowlLabel}: '
            '${_portionText(carb)}, ${_portionText(hewani)}, ${_portionText(nabati)}, '
            'Sayur ${_portionText(sayur)}, minyak/santan ${oilSdt.toString().replaceAll('.0', '')} sdt';

        return DailyMealSession(
          time: time,
          sessionName: sessionName,
          menuName: menuName,
          description: description,
          portionUrt: portion,
          kcal: carb.kcal + hewani.kcal + nabati.kcal + sayur.kcal + oilKcal,
          carbsG: carb.carbsG + hewani.carbsG + nabati.carbsG + sayur.carbsG,
          proteinG: carb.proteinG + hewani.proteinG + nabati.proteinG + sayur.proteinG,
          fatG: carb.fatG + hewani.fatG + nabati.fatG + sayur.fatG + oilFat,
        );
      }

      DailyMealSession snackSession({
        required String time,
        required String sessionName,
        required String menuName,
        required String description,
        required String legacyPortion,
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
        final fruit = _component(currentFruit, solidsKcal * 0.05, 10);
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

      // Takaran bawaan (dipakai bila target kalori tidak tersedia).
      final legacy = _legacyPortions(ageMonths, currentCarb, animalPagi, currentVeg, currentFruit);

      final sessions = <DailyMealSession>[
        mainSession(
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
        ),
        snackSession(
          time: '09:30',
          sessionName: 'Selingan Pagi',
          menuName: ageMonths < 9.0 ? 'Puree Buah ${currentFruit.name}' : 'Snack Pagi: Buah ${currentFruit.name}',
          description: 'Buah segar ${currentFruit.name} kaya vitamin & serat alami.',
          legacyPortion: legacy.snack,
        ),
        mainSession(
          time: '12:00',
          sessionName: 'Makan Siang',
          menuName: 'Menu Siang: ${currentCarb.name} + ${animalSiang.name} (${style.$1}) + ${plantSiang.name}',
          description: '${profile.guide}. ${currentCarb.name} dengan ${animalSiang.name} ${style.$2}, ${plantSiang.name}, & Sayur ${currentVeg.name}.$fatTip',
          animal: animalSiang,
          plant: plantSiang,
          kcalShareOfSolids: 0.35,
          legacyPortion: legacy.main,
        ),
        snackSession(
          time: '15:30',
          sessionName: 'Selingan Sore',
          menuName: 'Snack Sore: Buah ${currentFruit.name}',
          description: ageMonths < 24.0
              ? 'Potongan buah ${currentFruit.name} atau ASI / Susu segar.'
              : 'Potongan buah segar ${currentFruit.name} atau Susu UHT / Pasteurisasi plain.',
          legacyPortion: legacy.snack,
        ),
        mainSession(
          time: '18:00',
          sessionName: 'Makan Malam',
          menuName: 'Menu Malam: ${currentCarb.name} + ${animalMalam.name} (${style.$4}) + ${currentPlant.name}',
          description: '${profile.guide}. ${currentCarb.name} dengan ${animalMalam.name} empuk, ${currentPlant.name}, & Sayur ${currentVeg.name}.$fatTip',
          animal: animalMalam,
          plant: currentPlant,
          kcalShareOfSolids: 0.25,
          legacyPortion: legacy.main,
        ),
        if (countedMilk)
          DailyMealSession(
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
          )
        else
          DailyMealSession(
            time: '20:30',
            sessionName: 'Sebelum Tidur',
            menuName: 'ASI / Susu Malam',
            description: 'Menyusu ASI on demand sebelum tidur. Bila non-ASI, susu formula/PKMK sesuai advis dokter (±200 mL, tidak dihitung dalam total tabel).',
            portionUrt: 'Sesuai kehendak bayi (on demand)',
          ),
      ];

      return SingleDayMealPlan(
        dayName: dayName,
        theme: theme,
        sessions: sessions,
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
