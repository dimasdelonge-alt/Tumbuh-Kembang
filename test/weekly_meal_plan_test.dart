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
  });
}
