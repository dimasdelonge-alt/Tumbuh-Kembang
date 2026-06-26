import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/growth/growth_assessment.dart';
import 'package:tumbang/modules/growth/waterlow_calculator.dart';
import 'package:tumbang/modules/growth/zscore_calculator.dart';
import 'package:tumbang/modules/growth/nutrition_classifier.dart';

void main() {
  group('WaterlowCalculator', () {
    test('Boy 115cm height calculations', () {
      // Stature table boy median matches 115cm at some height-age.
      final res = WaterlowCalculator.calculate(
        weightKg: 18.0,
        heightCm: 115.0,
        sex: 'L',
      );

      expect(res.heightAgeMonths, greaterThan(0));
      expect(res.idealWeightKg, greaterThan(0));
      expect(res.percentage, greaterThan(0));
      expect(res.status, isNotNull);
    });

    test('Boy 115cm with weight = idealWeight yields 100% and normal status', () {
      final res1 = WaterlowCalculator.calculate(
        weightKg: 18.0,
        heightCm: 115.0,
        sex: 'L',
      );
      
      final resIdeal = WaterlowCalculator.calculate(
        weightKg: res1.idealWeightKg,
        heightCm: 115.0,
        sex: 'L',
      );

      expect(resIdeal.percentage, closeTo(100.0, 1e-9));
      expect(resIdeal.status, NutritionStatus.normalNutrition);
    });

    test('Nutrition status classifications for Waterlow', () {
      // Obese: > 120%
      // Overweight: 110% - 120%
      // Normal: 90% - 110%
      // Wasting (Gizi Kurang): 70% - 90%
      // Severe Wasting (Gizi Buruk): < 70%
      
      final resNormal = WaterlowCalculator.calculate(weightKg: 20.0, heightCm: 115.0, sex: 'L'); // BBI is ~20.7
      expect(resNormal.status, NutritionStatus.normalNutrition);

      final resSevere = WaterlowCalculator.calculate(weightKg: 10.0, heightCm: 115.0, sex: 'L');
      expect(resSevere.status, NutritionStatus.severeWasting);

      final resWasting = WaterlowCalculator.calculate(weightKg: 16.0, heightCm: 115.0, sex: 'L');
      expect(resWasting.status, NutritionStatus.wasting);

      final resOverweight = WaterlowCalculator.calculate(weightKg: 23.5, heightCm: 115.0, sex: 'L');
      expect(resOverweight.status, NutritionStatus.overweight);

      final resObese = WaterlowCalculator.calculate(weightKg: 26.0, heightCm: 115.0, sex: 'L');
      expect(resObese.status, NutritionStatus.obese);
    });
  });

  group('GrowthAssessment integration with Waterlow', () {
    final birthDate = DateTime.now().subtract(const Duration(days: 365 * 6)); // 6 years old
    final examDate = DateTime.now();

    test('Uses Waterlow for BB/TB when age > 5 years old', () {
      final assessment = GrowthAssessment.compute(
        birthDate: birthDate,
        examDate: examDate,
        sex: 'L',
        weightKg: 18.0,
        heightCm: 115.0,
        measuredLying: false,
      );

      expect(assessment.age.chronologicalMonths, greaterThan(60));
      expect(assessment.waterlow, isNotNull);
      
      final bbtb = assessment.byIndicator(GrowthIndicator.weightForLengthHeight);
      expect(bbtb, isNotNull);
      expect(bbtb!.z.zScore, assessment.waterlow!.percentage);
      expect(bbtb.status, assessment.waterlow!.status);
    });

    test('Does not use Waterlow for BB/TB when age <= 5 years old', () {
      final birthDateYoung = DateTime.now().subtract(const Duration(days: 365 * 3)); // 3 years old
      final assessment = GrowthAssessment.compute(
        birthDate: birthDateYoung,
        examDate: examDate,
        sex: 'L',
        weightKg: 14.0,
        heightCm: 95.0,
        measuredLying: false,
      );

      expect(assessment.age.chronologicalMonths, lessThanOrEqualTo(60));
      expect(assessment.waterlow, isNull);
    });
  });
}
