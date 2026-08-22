import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/nutrition/food_exchange_data.dart';
import 'package:tumbang/modules/nutrition/weekly_meal_plan_generator.dart';

void main() {
  group('Food Exchange & Weekly Meal Plan Tests', () {
    test('Food Exchange Repository dataset contains correct groups', () {
      expect(FoodExchangeRepository.carbsList.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.animalProteinLowFat.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.animalProteinMedFat.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.animalProteinHighFat.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.plantProteinList.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.veggiesList.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.fruitsList.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.milkList.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.veggiesFree.isNotEmpty, isTrue);

      final nasi = FoodExchangeRepository.carbsList.firstWhere((i) => i.name.contains('Nasi'));
      expect(nasi.calories, equals(175));
      expect(nasi.carbs, equals(40));
    });

    test('Weekly Meal Plan Generator creates 7 days (Senin to Minggu)', () {
      final plan = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 14.0,
        preferredCarb: FoodExchangeRepository.carbsList.first,
        preferredAnimalProtein: FoodExchangeRepository.animalProteinMedFat.first,
      );

      expect(plan.length, equals(7));
      expect(plan[0].dayName, equals('Senin'));
      expect(plan[6].dayName, equals('Minggu'));

      // Check daily sessions
      expect(plan[0].sessions.length, equals(6)); // 07:00, 09:30, 12:00, 15:30, 18:00, 20:30
      expect(plan[0].sessions[0].sessionName, equals('Makan Pagi'));
      expect(plan[0].sessions[2].sessionName, equals('Makan Siang'));
    });

    test('Weekly Meal Plan Generator scales portions correctly according to age bracket', () {
      // 7 bulan (6-8 bln): Lumat
      final plan7m = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 7.0,
        preferredCarb: FoodExchangeRepository.carbsList.first,
      );
      final portion7m = plan7m[0].sessions[0].portionUrt;
      expect(portion7m, contains('2-3 sdm bubur lumat'));
      expect(portion7m, contains('25g'));

      // 9 bulan (9-11 bln): Tim Cincang 1/2 mangkuk
      final plan9m = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 9.0,
        preferredCarb: FoodExchangeRepository.carbsList.first,
      );
      final portion9m = plan9m[0].sessions[0].portionUrt;
      expect(portion9m, contains('1/2 mangkuk'));
      expect(portion9m, contains('50g'));

      // 14 bulan (12-23 bln): 3/4 mangkuk makanan cincang
      final plan14m = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 14.0,
        preferredCarb: FoodExchangeRepository.carbsList.first,
      );
      final portion14m = plan14m[0].sessions[0].portionUrt;
      expect(portion14m, contains('3/4 mangkuk'));
      expect(portion14m, contains('75g'));

      // 36 bulan (2-5 thn): 1 porsi piring makan keluarga
      final plan36m = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 36.0,
        preferredCarb: FoodExchangeRepository.carbsList.first,
      );
      final portion36m = plan36m[0].sessions[0].portionUrt;
      expect(portion36m, contains('1 porsi piring makan'));
    });

    test('Weekly Meal Plan ONLY includes checked/selected animal proteins (e.g. Daging Sapi & Hati Sapi)', () {
      final beef = FoodExchangeRepository.animalProteinMedFat.firstWhere((i) => i.name == 'Daging Sapi');
      final beefLiver = FoodExchangeRepository.animalProteinMedFat.firstWhere((i) => i.name == 'Hati Sapi');
      final rice = FoodExchangeRepository.carbsList.firstWhere((i) => i.name.contains('Nasi'));
      final tempeh = FoodExchangeRepository.plantProteinList.firstWhere((i) => i.name == 'Tempe');
      final carrot = FoodExchangeRepository.veggiesList.firstWhere((i) => i.name == 'Wortel');
      final banana = FoodExchangeRepository.fruitsList.firstWhere((i) => i.name.contains('Pisang'));

      final plan = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 10.0, // 9-11 bulan
        selectedCarbs: [rice],
        selectedAnimalProteins: [beef, beefLiver],
        selectedPlantProteins: [tempeh],
        selectedVeggies: [carrot],
        selectedFruits: [banana],
      );

      expect(plan.length, equals(7));

      // Disallowed words that were previously hardcoded and leaked into output
      final unselectedMeats = [
        'Ayam',
        'Telur',
        'Ikan',
        'Puyuh',
        'Bebek',
        'Lele',
        'Kakap',
        'Kembung',
        'Hati ayam',
        'Tahu',
      ];

      for (final day in plan) {
        // Check theme
        for (final meat in unselectedMeats) {
          expect(
            day.theme.toLowerCase().contains(meat.toLowerCase()),
            isFalse,
            reason: 'Day ${day.dayName} theme "${day.theme}" should not contain unselected "$meat"',
          );
        }

        // Check sessions
        for (final session in day.sessions) {
          for (final meat in unselectedMeats) {
            expect(
              session.menuName.toLowerCase().contains(meat.toLowerCase()),
              isFalse,
              reason: 'Day ${day.dayName} session "${session.sessionName}" menuName "${session.menuName}" should not contain unselected "$meat"',
            );
            expect(
              session.description.toLowerCase().contains(meat.toLowerCase()),
              isFalse,
              reason: 'Day ${day.dayName} session "${session.sessionName}" description "${session.description}" should not contain unselected "$meat"',
            );
          }
        }
      }

      // Verify that Daging Sapi and Hati Sapi are present
      final allText = plan.map((d) => '${d.theme} ${d.sessions.map((s) => '${s.menuName} ${s.description}').join(' ')}').join(' ');
      expect(allText, contains('Daging Sapi'));
      expect(allText, contains('Hati Sapi'));
      expect(allText, contains('Tempe'));
      expect(allText, contains('Wortel'));
      expect(allText, contains('Pisang'));
    });
  });
}
