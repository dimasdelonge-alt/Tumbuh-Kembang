import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/growth/nutrition_classifier.dart';
import 'package:tumbang/modules/nutrition/nutrition_calculator.dart';
import 'package:tumbang/modules/nutrition/nutrition_data.dart';

void main() {
  group('NutritionCalculator Tests', () {
    test('Holliday-Segar fluid calculation', () {
      expect(NutritionCalculator.hollidaySegar(5.0), equals(500.0));
      expect(NutritionCalculator.hollidaySegar(10.0), equals(1000.0));
      expect(NutritionCalculator.hollidaySegar(15.0), equals(1250.0));
      expect(NutritionCalculator.hollidaySegar(25.0), equals(1600.0));
    });

    test('AKG table lookup per age and sex', () {
      final akgBaby = findAkg(4, 'L');
      expect(akgBaby?.label, equals('0–5 bulan'));
      expect(akgBaby?.energyKcal, equals(550));

      final akgToddler = findAkg(24, 'P');
      expect(akgToddler?.label, equals('1–3 tahun'));
      expect(akgToddler?.energyKcal, equals(1350));

      final akgBoy12 = findAkg(130, 'L');
      expect(akgBoy12?.label, contains('10–12 tahun (L)'));

      final akgGirl12 = findAkg(130, 'P');
      expect(akgGirl12?.label, contains('10–12 tahun (P)'));
    });

    test('MPASI guidance per age', () {
      final m6 = findMpasiGuidance(4);
      expect(m6.texture, contains('ASI Eksklusif'));

      final m8 = findMpasiGuidance(7);
      expect(m8.texture, contains('Bubur kental'));

      final m10 = findMpasiGuidance(10);
      expect(m10.texture, contains('dicincang'));

      final m18 = findMpasiGuidance(18);
      expect(m18.texture, contains('Makanan keluarga'));
    });

    test('Full Nutrition calculation for 2-year-old boy', () {
      final result = NutritionCalculator.calculate(
        weightKg: 12.0,
        heightCm: 86.0,
        ageMonths: 24,
        sex: 'L',
      );

      expect(result, isNotNull);
      expect(result!.idealWeightKg, greaterThan(11.0));
      expect(result.idealWeightKg, lessThan(13.0));
      expect(result.targetEnergyKcal, greaterThan(1000));
      expect(result.targetProteinGram, greaterThan(15));
      expect(result.dailyFluidMl, closeTo(1133.5, 5.0));
      expect(result.mpasiGuidance.label, equals('≥2 Tahun'));
      expect(result.ironSupp.name, contains('Zat Besi'));
      expect(result.vitDSupp.dose, equals('600 IU/hari'));
    });

    test('Nutrition calculation for malnourished child triggers intervention', () {
      final result = NutritionCalculator.calculate(
        weightKg: 7.0, // sangat kurus untuk TB 86 cm
        heightCm: 86.0,
        ageMonths: 24,
        sex: 'L',
      );

      expect(result, isNotNull);
      expect(result!.needsIntervention, isTrue);
      expect(result.nutritionStatus, equals(NutritionStatus.severeWasting));
      expect(result.interventionAdvice, contains('GIZI BURUK'));
    });
  });
}
