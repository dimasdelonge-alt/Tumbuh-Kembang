import 'food_exchange_data.dart';
import 'nutrition_calculator.dart';

/// Item menu satu sesi makan (Pagi, Selingan, Siang, Selingan, Malam, Susu).
class DailyMealSession {
  final String time;
  final String sessionName; // 'Makan Pagi', 'Selingan Pagi', 'Makan Siang', 'Selingan Sore', 'Makan Malam', 'Susu Malam'
  final String menuName;
  final String description;
  final String portionUrt;

  const DailyMealSession({
    required this.time,
    required this.sessionName,
    required this.menuName,
    required this.description,
    required this.portionUrt,
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
}

/// Generator Rencana & Jadwal Makan Seminggu (7 Hari).
class WeeklyMealPlanGenerator {
  /// Membikin Rencana Makan 7 Hari (Senin - Minggu) berbasis Usia & Bahan Penukar Pilihan.
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
  }) {
    final carbs = (selectedCarbs != null && selectedCarbs.isNotEmpty)
        ? selectedCarbs
        : (preferredCarb != null ? [preferredCarb] : [FoodExchangeRepository.carbsList.first]);

    final animalProteins = (selectedAnimalProteins != null && selectedAnimalProteins.isNotEmpty)
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
      (
        'Sup Kaldu Gurih',
        'kuah kaldu bening gurih',
        'sup sayur kaldu hangat',
        'kuah bening segar',
      ),
      (
        'Kukus & Tim Wangi',
        'tim kukus gurih lembut',
        'kukus bumbu aromatik',
        'tim lembut harum',
      ),
      (
        'Masak Gurih Santan Ringan',
        'kuah santan encer gurih',
        'tumis santan ringan',
        'masak kuah santan gurih',
      ),
      (
        'Semur / Bumbu Gurih Manis',
        'semur bumbu gurih manis lunak',
        'bumbu semur empuk',
        'masak kecap gurih manis',
      ),
      (
        'Sup Bola Cincang / Sayur',
        'bola-bola cincang kuah sayur',
        'kuah kaldu bola cincang',
        'sup bola sayur hangat',
      ),
      (
        'Tumis Lembut / Bumbu Gurih',
        'tumis mentega/minyak kelapa lunak',
        'masak tumis empuk',
        'tumis bumbu gurih',
      ),
      (
        'Bumbu Kuning / Soto Bening Segar',
        'kuah soto bening rempah ringan',
        'masak bumbu kuning gurih',
        'kuah kuning segar',
      ),
    ];

    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

    return List.generate(7, (index) {
      final dayName = days[index];
      final style = cookingStyles[index % cookingStyles.length];

      final currentCarb = carbs[index % carbs.length];
      final currentAnimal = animalProteins[index % animalProteins.length];
      final currentPlant = plantProteins[index % plantProteins.length];
      final currentVeg = veggies[index % veggies.length];
      final currentFruit = fruits[index % fruits.length];

      final carbName = currentCarb.name;
      final animalName = currentAnimal.name;
      final plantName = currentPlant.name;
      final vegName = currentVeg.name;
      final fruitName = currentFruit.name;

      final isCatchUp = nutResult?.needsCatchUp ?? false;
      final targetKcal = nutResult?.targetEnergyKcal.round();
      final themeSuffix = isCatchUp && targetKcal != null ? ' • Kejar Tumbuh ($targetKcal kcal)' : '';

      final theme = 'Variasi $animalName & $plantName ($carbName & Sayur $vegName)$themeSuffix';

      String portionMain;
      String portionSnack;
      String textureGuide;
      List<DailyMealSession> sessions;

      if (ageMonths < 9.0) {
        // 6-8 bulan (Lumat / Puree)
        textureGuide = 'Tekstur: Lumat Halus / Saring (Puree)';
        portionMain = '2-3 sdm bubur lumat (~25g $carbName + 10-15g $animalName + Sayur $vegName lumat)';
        portionSnack = '2-3 sdt puree buah $fruitName';
        final fatTip = isCatchUp
            ? 'Tambahkan 1-2 sdt minyak kelapa/santan/lemak tambahan (densitas energi kejar tumbuh).'
            : 'Tambahkan 1/2 sdt minyak kelapa/santan.';

        sessions = [
          DailyMealSession(
            time: '07:00',
            sessionName: 'Makan Pagi',
            menuName: 'Bubur Lumat $carbName + $animalName',
            description: '$textureGuide. Bubur saring $carbName dimasak bersama $animalName lumat, $plantName halus, & Sayur $vegName. $fatTip',
            portionUrt: portionMain,
          ),
          DailyMealSession(
            time: '09:30',
            sessionName: 'Selingan Pagi',
            menuName: 'Puree Buah $fruitName',
            description: 'Puree lumatan buah segar $fruitName kaya vitamin & serat.',
            portionUrt: portionSnack,
          ),
          DailyMealSession(
            time: '12:00',
            sessionName: 'Makan Siang',
            menuName: 'Puree Tim $carbName + $animalName (${style.$1})',
            description: '$textureGuide. Tim saring $carbName dengan $animalName lumat ${style.$2}, $plantName, & Sayur $vegName.',
            portionUrt: portionMain,
          ),
          DailyMealSession(
            time: '15:30',
            sessionName: 'Selingan Sore',
            menuName: 'Selingan Sore / ASI',
            description: 'Puree buah $fruitName atau ASI / Susu segar.',
            portionUrt: portionSnack,
          ),
          DailyMealSession(
            time: '18:00',
            sessionName: 'Makan Malam',
            menuName: 'Bubur Halus $carbName + $animalName',
            description: '$textureGuide. Bubur lembut $carbName dengan olahan $animalName lumat gurih & $plantName kukus halus.',
            portionUrt: portionMain,
          ),
          const DailyMealSession(
            time: '20:30',
            sessionName: 'Sebelum Tidur',
            menuName: 'ASI / Susu Malam',
            description: 'Menyusu ASI atau susu formula on demand sebelum tidur malam.',
            portionUrt: 'Sesuai kehendak bayi (on demand)',
          ),
        ];
      } else if (ageMonths < 12.0) {
        // 9-11 bulan (Cincang / Lembik)
        textureGuide = 'Tekstur: Lembik / Cincang Halus (Mashed/Chopped)';
        portionMain = '1/2 mangkuk (125 mL) tim cincang (~50g $carbName + 15-20g $animalName + Sayur $vegName cincang)';
        portionSnack = '1-2 potong finger food buah $fruitName';
        final extraFatTip = isCatchUp ? ' Tambahkan minyak/santan sehat untuk kejar tumbuh.' : '';

        sessions = [
          DailyMealSession(
            time: '07:00',
            sessionName: 'Makan Pagi',
            menuName: 'Nasi Tim Cincang $animalName + Sayur $vegName',
            description: '$textureGuide. Nasi tim $carbName dengan $animalName cincang halus, $plantName, & irisan Sayur $vegName.$extraFatTip',
            portionUrt: portionMain,
          ),
          DailyMealSession(
            time: '09:30',
            sessionName: 'Selingan Pagi',
            menuName: 'Finger Food Buah $fruitName',
            description: 'Potongan buah $fruitName lunak seukuran jari untuk stimulasi motorik & oromotor.',
            portionUrt: portionSnack,
          ),
          DailyMealSession(
            time: '12:00',
            sessionName: 'Makan Siang',
            menuName: 'Tim Gurih $carbName + $animalName (${style.$1})',
            description: '$textureGuide. Nasi tim $carbName dengan $animalName cincang ${style.$2}, $plantName, & Sayur $vegName cincang.',
            portionUrt: portionMain,
          ),
          DailyMealSession(
            time: '15:30',
            sessionName: 'Selingan Sore',
            menuName: 'Selingan Sore / ASI',
            description: 'Potongan buah segar $fruitName lunak atau ASI / Susu.',
            portionUrt: portionSnack,
          ),
          DailyMealSession(
            time: '18:00',
            sessionName: 'Makan Malam',
            menuName: 'Nasi Tim Bola/Cincang $animalName',
            description: '$textureGuide. Nasi tim $carbName dengan cincangan $animalName lembut, $plantName kukus lunak, & Sayur $vegName.',
            portionUrt: portionMain,
          ),
          const DailyMealSession(
            time: '20:30',
            sessionName: 'Sebelum Tidur',
            menuName: 'ASI / Susu Malam',
            description: 'ASI atau Susu Formula hangat menjelang tidur malam.',
            portionUrt: '1 botol/gelas (120-180 mL)',
          ),
        ];
      } else if (ageMonths < 24.0) {
        // 12-23 bulan (1-2 Tahun: Makanan Keluarga Cincang)
        textureGuide = 'Tekstur: Makanan Keluarga Cincang Kasar / Potong Kecil';
        portionMain = '3/4 mangkuk (175 mL) makanan cincang (~75g $carbName + 30g $animalName + Sayur $vegName)';
        portionSnack = '1 potong buah segar $fruitName';
        final catchUp12Tip = isCatchUp ? ' Porsi padat energi & kaya protein hewani untuk kejar tumbuh.' : '';

        sessions = [
          DailyMealSession(
            time: '07:00',
            sessionName: 'Makan Pagi',
            menuName: 'Menu Pagi: $carbName + $animalName + Sayur $vegName',
            description: '$textureGuide. $carbName hangat dengan lauk $animalName potong kecil gurih, $plantName kukus/tumis, & sup Sayur $vegName.$catchUp12Tip',
            portionUrt: portionMain,
          ),
          DailyMealSession(
            time: '09:30',
            sessionName: 'Selingan Pagi',
            menuName: 'Snack Pagi: Buah $fruitName',
            description: 'Potongan buah segar $fruitName kaya vitamin & serat alami.',
            portionUrt: portionSnack,
          ),
          DailyMealSession(
            time: '12:00',
            sessionName: 'Makan Siang',
            menuName: 'Menu Siang: $carbName + $animalName (${style.$1}) + $plantName',
            description: '$textureGuide. $carbName dengan olahan $animalName ${style.$2}, lauk nabati $plantName, & Sayur $vegName.',
            portionUrt: portionMain,
          ),
          DailyMealSession(
            time: '15:30',
            sessionName: 'Selingan Sore',
            menuName: 'Snack Sore: Buah / Susu',
            description: 'Potongan buah $fruitName atau Susu UHT / Susu Pertumbuhan.',
            portionUrt: portionSnack,
          ),
          DailyMealSession(
            time: '18:00',
            sessionName: 'Makan Malam',
            menuName: 'Menu Malam: $carbName + $animalName (${style.$4}) + $plantName',
            description: '$textureGuide. $carbName dengan $animalName empuk potong kecil, $plantName gurih, & Sayur $vegName.',
            portionUrt: portionMain,
          ),
          const DailyMealSession(
            time: '20:30',
            sessionName: 'Sebelum Tidur',
            menuName: 'ASI / Susu Malam',
            description: 'ASI atau Susu UHT / Pertumbuhan (max 200 mL).',
            portionUrt: '1 gelas (150-200 mL)',
          ),
        ];
      } else {
        // 24+ bulan (2-5 Tahun: Makanan Keluarga Utuh)
        textureGuide = 'Tekstur: Makanan Keluarga Utuh';
        portionMain = '1 porsi piring makan ($carbName [${currentCarb.displayUrt}] + $animalName [${currentAnimal.displayUrt}] + Sayur $vegName [${currentVeg.displayUrt}])';
        portionSnack = '1 porsi buah segar $fruitName [${currentFruit.displayUrt}]';
        final catchUp24Tip = isCatchUp ? ' Menu porsi padat gizi untuk kejar tumbuh.' : '';

        sessions = [
          DailyMealSession(
            time: '07:00',
            sessionName: 'Makan Pagi',
            menuName: 'Menu Pagi: $carbName + Lauk $animalName + Sayur $vegName',
            description: '$textureGuide. Seporsi sarapan $carbName bersama lauk $animalName, $plantName, & Sayur $vegName.$catchUp24Tip',
            portionUrt: portionMain,
          ),
          DailyMealSession(
            time: '09:30',
            sessionName: 'Selingan Pagi',
            menuName: 'Snack Pagi: Buah $fruitName',
            description: '1 porsi buah segar $fruitName.',
            portionUrt: portionSnack,
          ),
          DailyMealSession(
            time: '12:00',
            sessionName: 'Makan Siang',
            menuName: 'Menu Siang: $carbName + $animalName (${style.$1}) + $plantName',
            description: '$textureGuide. Makan siang lengkap $carbName dengan $animalName ${style.$2}, lauk $plantName, & olahan Sayur $vegName.',
            portionUrt: portionMain,
          ),
          DailyMealSession(
            time: '15:30',
            sessionName: 'Selingan Sore',
            menuName: 'Snack Sore Sehat',
            description: 'Potongan buah segar $fruitName atau Susu UHT / Pasturisasi.',
            portionUrt: portionSnack,
          ),
          DailyMealSession(
            time: '18:00',
            sessionName: 'Makan Malam',
            menuName: 'Menu Malam: $carbName + $animalName (${style.$4}) + $plantName',
            description: '$textureGuide. Makan malam lengkap $carbName dengan lauk hewani $animalName, pendamping $plantName, & Sayur $vegName.',
            portionUrt: portionMain,
          ),
          const DailyMealSession(
            time: '20:30',
            sessionName: 'Sebelum Tidur',
            menuName: 'Susu UHT / Pasturisasi',
            description: 'Susu UHT / Pasturisasi / Susu Segar (max 200 mL).',
            portionUrt: '1 gelas (150-200 mL)',
          ),
        ];
      }

      return SingleDayMealPlan(
        dayName: dayName,
        theme: theme,
        sessions: sessions,
      );
    }).toList();
  }
}
