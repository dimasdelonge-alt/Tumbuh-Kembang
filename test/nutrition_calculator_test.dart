import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/growth/who_growth_data.dart';
import 'package:tumbang/modules/nutrition/nutrition_calculator.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await WhoGrowthData.instance.ensureLoaded();
  });

  group('PediatricNutritionCalculator Tests (ANP IDAI / Permenkes 28/2019 / AAP)', () {
    test('Height Age and Ideal Weight calculations (WHO 0-5 years)', () {
      // Female 67 cm (approx 6-7 months) -> HA is approx 6.5 months, Ideal Weight is approx 7.5 kg
      final ha67 = PediatricNutritionCalculator.calculateHeightAge(
        heightCm: 67.0,
        sex: 'P',
        ageMonths: 17,
      );
      expect(ha67, closeTo(6.5, 0.5));

      final idealW67 = PediatricNutritionCalculator.calculateIdealWeight(
        heightCm: 67.0,
        sex: 'P',
        ageMonths: 17,
      );
      expect(idealW67, closeTo(7.5, 0.1));

      // Female 75 cm (approx 12.8 months) -> HA is approx 12.8 months, Ideal Weight is approx 9.15 kg
      final ha75 = PediatricNutritionCalculator.calculateHeightAge(
        heightCm: 75.0,
        sex: 'P',
        ageMonths: 17,
      );
      expect(ha75, closeTo(12.8, 0.5));

      final idealW75 = PediatricNutritionCalculator.calculateIdealWeight(
        heightCm: 75.0,
        sex: 'P',
        ageMonths: 17,
      );
      expect(idealW75, closeTo(9.15, 0.1));
    });

    test('RDA Energy and Protein per kg requirements by height age', () {
      // 0-5 months -> 100 kcal/kg, 1.5 g/kg
      expect(PediatricNutritionCalculator.getRdaEnergyPerKg(4.0), equals(100.0));
      expect(PediatricNutritionCalculator.getProteinRdaPerKg(4.0), equals(1.5));

      // 6-11 months -> 95 kcal/kg, 1.5 g/kg
      expect(PediatricNutritionCalculator.getRdaEnergyPerKg(9.0), equals(95.0));
      expect(PediatricNutritionCalculator.getProteinRdaPerKg(9.0), equals(1.5));

      // 1-3 years -> 100 kcal/kg, 1.5 g/kg
      expect(PediatricNutritionCalculator.getRdaEnergyPerKg(24.0), equals(100.0));
      expect(PediatricNutritionCalculator.getProteinRdaPerKg(24.0), equals(1.5));

      // 4-6 years -> 80 kcal/kg, 1.2 g/kg
      expect(PediatricNutritionCalculator.getRdaEnergyPerKg(60.0), equals(80.0));
      expect(PediatricNutritionCalculator.getProteinRdaPerKg(60.0), equals(1.2));
    });

    test('Full Nutrition Calculation uses RDA x BB Ideal (e.g. 75cm / 7.2kg)', () {
      // Female 17 months, 7.2 kg, 75 cm -> BB Ideal WHO is 9.15 kg, HA ~12.8 bln (RDA 100 kcal/kg)
      final res = PediatricNutritionCalculator.calculate(
        weightKg: 7.2,
        heightCm: 75.0,
        ageMonths: 17.0,
        sex: 'P',
      );

      // Kebutuhan energi = 100 kcal/kg x 9.15 kg = 915 kcal/hari (jauh lebih tepat dari BMR 388 kcal/hari)
      expect(res.eerKcal, closeTo(915.0, 5.0));
      expect(res.idealWeightKg, closeTo(9.15, 0.1));
      expect(res.idealWeightLabel, equals('9.1 kg'));
      expect(res.proteinGrams, closeTo(13.7, 0.5));
      expect(res.fluidMl, equals(720.0));
      expect(res.needsCatchUp, isFalse);
    });

    test('Nutrition Calculation with customized BB Ideal (e.g. 7.5 kg for 67cm)', () {
      final res = PediatricNutritionCalculator.calculate(
        weightKg: 7.0,
        heightCm: 67.0,
        ageMonths: 17.0,
        sex: 'P',
        idealWeightKg: 7.5,
      );

      expect(res.idealWeightKg, equals(7.5));
      expect(res.idealWeightLabel, equals('7.5 kg'));
      // HA ~6.5 bln -> RDA 95 kcal/kg -> 95 * 7.5 = 712.5 kcal/hari
      expect(res.eerKcal, closeTo(712.5, 1.0));
      expect(res.proteinGrams, equals(7.5 * 1.5));
      expect(res.fluidMl, equals(700.0));
    });

    test('Malnourished child Catch-Up Growth calculation', () {
      final resMalnourished = PediatricNutritionCalculator.calculate(
        weightKg: 7.0,
        heightCm: 75.0,
        ageMonths: 17.0,
        sex: 'P',
        idealWeightKg: 9.15,
        isMalnourished: true,
      );

      expect(resMalnourished.needsCatchUp, isTrue);
      // Catch-up energy > normal energy
      expect(resMalnourished.catchUpEnergyKcal, greaterThanOrEqualTo(resMalnourished.eerKcal));
      // Protein catch-up tidak boleh di bawah standar: 1,8 x 7 kg = 12,6 g
      // lebih rendah dari RDA x BBI (1,5 x 9,15 = 13,7 g) -> lantai standar.
      expect(resMalnourished.catchUpProteinGrams, closeTo(9.15 * 1.5, 0.1));
      expect(resMalnourished.targetProteinGram,
          greaterThanOrEqualTo(resMalnourished.proteinGrams));
    });

    test('Catch-Up Protein uses 1.8 g/kg when above standard floor', () {
      // BB dekat BBI: 1,8 x 9 kg = 16,2 g > standar 1,5 x 9,15 = 13,7 g.
      final res = PediatricNutritionCalculator.calculate(
        weightKg: 9.0,
        heightCm: 75.0,
        ageMonths: 17.0,
        sex: 'P',
        idealWeightKg: 9.15,
        isMalnourished: true,
      );
      expect(res.catchUpProteinGrams, closeTo(9.0 * 1.8, 0.1));
    });

    test('Holliday-Segar fluid calculation', () {
      // 8 kg -> 8 * 100 = 800 mL
      expect(PediatricNutritionCalculator.calculateHollidaySegarFluid(8.0), equals(800.0));

      // 15 kg -> 1000 + (5 * 50) = 1250 mL
      expect(PediatricNutritionCalculator.calculateHollidaySegarFluid(15.0), equals(1250.0));

      // 25 kg -> 1500 + (5 * 20) = 1600 mL
      expect(PediatricNutritionCalculator.calculateHollidaySegarFluid(25.0), equals(1600.0));
    });

    test('EER WHO equation helper test for Schofield baseline reference', () {
      // 18 months male, 11 kg -> (60.9 * 11) - 54 = 669.9 - 54 = 615.9 kcal
      final eer = PediatricNutritionCalculator.calculateEerWho(
        weightKg: 11.0,
        ageYears: 1.5,
        sex: 'L',
      );
      expect(eer, closeTo(615.9, 0.1));
    });
  });
}
