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
  });
}
