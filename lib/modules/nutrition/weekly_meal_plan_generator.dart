import 'food_exchange_data.dart';

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

    // 6+ Bulan: 7 Variasi Menu Terstruktur (Senin s/d Minggu)
    final dailyThemes = [
      ('Senin', 'Variasi Daging Ayam & Telur', 'Ayam tanpa kulit & Telur rebus', 'Tahu kukus halus', 'Puree Alpukat / Biskuit MPASI'),
      ('Selasa', 'Variasi Ikan Kembung & Tempe', 'Daging Ikan Kembung kukus halus', 'Tempe lumat tumis', 'Puree Pisang Ambon / Buah Potong'),
      ('Rabu', 'Variasi Daging Sapi & Hati Ayam', 'Daging sapi giling & Hati ayam', 'Tahu bacem lunak', 'Puding Susu / Buah Naga'),
      ('Kamis', 'Variasi Ikan Lele / Kakap & Telur Puyuh', 'Ikan Kakap & 2 btr Telur puyuh', 'Tempe kukus santan', 'Puree Papaya / Roti Panggang Lunak'),
      ('Jumat', 'Variasi Daging Ayam & Hati Sapi', 'Daging Ayam & Hati sapi cincang', 'Tahu sutra kukus', 'Puree Mangga / Pisang'),
      ('Sabtu', 'Variasi Telur Ayam & Daging Sapi', 'Bola daging sapi & Telur dadar', 'Tempe goreng tepung lunak', 'Biskuit MPASI / Susu UHT'),
      ('Minggu', 'Variasi Spesial Ikan & Ayam Santan', 'Ikan segar & Daging ayam gurih', 'Tahu tempe kuah santan', 'Puree Alpukat Susu'),
    ];

    return List.generate(7, (index) {
      final t = dailyThemes[index];
      final dayName = t.$1;

      final currentCarb = carbs[index % carbs.length];
      final currentAnimal = animalProteins[index % animalProteins.length];
      final currentPlant = plantProteins[index % plantProteins.length];

      final carbName = currentCarb.name;
      final carbUrt = currentCarb.urt;

      final theme = '${t.$2} (${currentCarb.name})';
      final mainDish = 'Menu Utama: $carbName + ${currentAnimal.name}';
      final animalDetail = '${t.$3} / ${currentAnimal.name}';
      final plantDetail = '${t.$4} / ${currentPlant.name}';
      final snackDetail = t.$5;

      String portionMain;
      String portionSnack;

      if (ageMonths < 9.0) { // 6-8 bulan (Lumat)
        portionMain = '2-3 sdm bubur lumat ($carbName $carbUrt)';
        portionSnack = '2 sdt puree / lumatan buah';
      } else if (ageMonths < 12.0) { // 9-11 bulan (Cincang/Lembik)
        portionMain = '1/2 mangkuk tim cincang ($carbName $carbUrt)';
        portionSnack = '1-2 potong finger food lunak';
      } else { // 12+ bulan (Makanan Keluarga)
        portionMain = '1 porsi makanan ($carbName $carbUrt) + 1 ptg lauk (${currentAnimal.name})';
        portionSnack = '1 potong snack sehat / buah segar';
      }

      return SingleDayMealPlan(
        dayName: dayName,
        theme: theme,
        sessions: [
          DailyMealSession(
            time: '07:00',
            sessionName: 'Makan Pagi',
            menuName: mainDish,
            description: 'Bahan utama: $carbName + $animalDetail + $plantDetail + Sayur bayam/wortel. Opsi penukar: ${currentAnimal.name} (${currentAnimal.urt}).',
            portionUrt: portionMain,
          ),
          DailyMealSession(
            time: '09:30',
            sessionName: 'Selingan Pagi',
            menuName: 'Snack Pagi Sehat',
            description: snackDetail,
            portionUrt: portionSnack,
          ),
          DailyMealSession(
            time: '12:00',
            sessionName: 'Makan Siang',
            menuName: mainDish,
            description: 'Bahan utama: $carbName + $animalDetail + ${currentPlant.name}. Kuah bening/santan gurih.',
            portionUrt: portionMain,
          ),
          DailyMealSession(
            time: '15:30',
            sessionName: 'Selingan Sore',
            menuName: 'Snack Sore / ASI',
            description: '$snackDetail atau ASI / Susu segar.',
            portionUrt: portionSnack,
          ),
          DailyMealSession(
            time: '18:00',
            sessionName: 'Makan Malam',
            menuName: mainDish,
            description: 'Bahan utama: $carbName + $animalDetail + ${currentPlant.name}.',
            portionUrt: portionMain,
          ),
          DailyMealSession(
            time: '20:30',
            sessionName: 'Sebelum Tidur',
            menuName: 'ASI / Susu Malam',
            description: 'ASI atau Susu UHT / Formula lunak (max 200 mL).',
            portionUrt: '1 gelas (150-200 mL)',
          ),
        ],
      );
    }).toList();
  }
}
