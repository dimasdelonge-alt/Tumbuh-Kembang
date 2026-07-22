import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/nutrition/nutrition_calculator.dart';

void main() {
  group('PediatricNutritionCalculator Tests (AAP Handbook 2011)', () {
    test('EER WHO equation for male under 3 years', () {
      // 18 months male, 11 kg -> (60.9 * 11) - 54 = 669.9 - 54 = 615.9 kcal
      final eer = PediatricNutritionCalculator.calculateEerWho(
        weightKg: 11.0,
        ageYears: 1.5,
        sex: 'L',
      );
      expect(eer, closeTo(615.9, 0.1));
    });

    test('EER WHO equation for female 3-10 years', () {
      // 5 years female, 18 kg -> (22.5 * 18) + 499 = 405 + 499 = 904 kcal
      final eer = PediatricNutritionCalculator.calculateEerWho(
        weightKg: 18.0,
        ageYears: 5.0,
        sex: 'P',
      );
      expect(eer, closeTo(904.0, 0.1));
    });

    test('Protein RDA per kg requirements by age group', () {
      expect(PediatricNutritionCalculator.getProteinRdaPerKg(4.0), equals(1.52)); // < 6 months
      expect(PediatricNutritionCalculator.getProteinRdaPerKg(9.0), equals(1.20)); // 7-12 months
      expect(PediatricNutritionCalculator.getProteinRdaPerKg(24.0), equals(1.05)); // 1-3 years
      expect(PediatricNutritionCalculator.getProteinRdaPerKg(72.0), equals(0.95)); // 4-13 years
    });

    test('Holliday-Segar fluid calculation', () {
      // 8 kg -> 8 * 100 = 800 mL
      expect(PediatricNutritionCalculator.calculateHollidaySegarFluid(8.0), equals(800.0));

      // 15 kg -> 1000 + (5 * 50) = 1250 mL
      expect(PediatricNutritionCalculator.calculateHollidaySegarFluid(15.0), equals(1250.0));

      // 25 kg -> 1500 + (5 * 20) = 1600 mL
      expect(PediatricNutritionCalculator.calculateHollidaySegarFluid(25.0), equals(1600.0));
    });

    test('Full Nutrition Calculation for normal vs malnourished child', () {
      final resNormal = PediatricNutritionCalculator.calculate(
        weightKg: 10.0,
        heightCm: 75.0,
        ageMonths: 12.0,
        sex: 'L',
      );
      expect(resNormal.eerKcal, greaterThan(500));
      expect(resNormal.needsCatchUp, isFalse);

      final resMalnourished = PediatricNutritionCalculator.calculate(
        weightKg: 7.5,
        heightCm: 75.0,
        ageMonths: 12.0,
        sex: 'L',
        idealWeightKg: 9.5,
        isMalnourished: true,
      );
      expect(resMalnourished.needsCatchUp, isTrue);
      expect(resMalnourished.catchUpEnergyKcal, greaterThan(resMalnourished.eerKcal));
    });
  });
}
