import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/growth/nutrition_classifier.dart';
import 'package:tumbang/modules/growth/zscore_calculator.dart';

void main() {
  group('ZScoreCalculator.rawZ', () {
    // WHO BB/U laki-laki, umur 0 bulan: L=0.3487, M=3.3464, S=0.14602.
    // Pada nilai = M (median) Z harus 0.
    const lms = LmsPoint(0, 0.3487, 3.3464, 0.14602);

    test('nilai = median menghasilkan Z = 0', () {
      expect(ZScoreCalculator.rawZ(3.3464, lms).abs(), lessThan(1e-9));
    });

    test('valueAtZ adalah invers dari rawZ', () {
      for (final z in [-3.0, -2.0, -1.0, 1.0, 2.0, 3.0]) {
        final v = ZScoreCalculator.valueAtZ(lms, z);
        final back = ZScoreCalculator.rawZ(v, lms);
        expect(back, closeTo(z, 1e-6), reason: 'z=$z');
      }
    });

    test('SD2neg WHO (0 bln laki) ~ 2.5 kg', () {
      // Tabel WHO mencantumkan SD2neg = 2.5 kg untuk usia 0 bulan.
      final v = ZScoreCalculator.valueAtZ(lms, -2);
      expect(v, closeTo(2.5, 0.05));
    });
  });

  group('interpolate', () {
    final table = [
      const LmsPoint(0, 1, 10, 0.1),
      const LmsPoint(10, 1, 20, 0.1),
    ];
    test('interpolasi linear di tengah', () {
      final p = ZScoreCalculator.interpolate(table, 5)!;
      expect(p.m, closeTo(15, 1e-9));
    });
    test('clamp di luar rentang', () {
      expect(ZScoreCalculator.interpolate(table, -5)!.m, 10);
      expect(ZScoreCalculator.interpolate(table, 99)!.m, 20);
    });
  });

  group('compute enforceBounds', () {
    final table = [
      const LmsPoint(0, 1, 10, 0.1),
      const LmsPoint(10, 1, 20, 0.1),
    ];
    test('x di luar rentang menghasilkan null saat enforceBounds', () {
      final r = ZScoreCalculator.compute(
        indicator: GrowthIndicator.weightForAge,
        table: table,
        value: 15,
        x: 50, // > 10
      );
      expect(r, isNull);
    });
    test('x dalam rentang tetap menghasilkan nilai', () {
      final r = ZScoreCalculator.compute(
        indicator: GrowthIndicator.weightForAge,
        table: table,
        value: 15,
        x: 5,
      );
      expect(r, isNotNull);
    });
    test('enforceBounds=false tetap clamp (perilaku lama)', () {
      final r = ZScoreCalculator.compute(
        indicator: GrowthIndicator.weightForAge,
        table: table,
        value: 20,
        x: 50,
        enforceBounds: false,
      );
      expect(r, isNotNull);
    });
  });

  group('NutritionClassifier', () {
    test('BB/U klasifikasi sesuai ambang', () {
      expect(NutritionClassifier.classify(GrowthIndicator.weightForAge, -3.5),
          NutritionStatus.severeUnderweight);
      expect(NutritionClassifier.classify(GrowthIndicator.weightForAge, -2.5),
          NutritionStatus.underweight);
      expect(NutritionClassifier.classify(GrowthIndicator.weightForAge, 0),
          NutritionStatus.normalWeight);
    });

    test('TB/U stunting', () {
      expect(
          NutritionClassifier.classify(
              GrowthIndicator.lengthHeightForAge, -2.5),
          NutritionStatus.stunting);
      expect(
          NutritionClassifier.classify(
              GrowthIndicator.lengthHeightForAge, -3.5),
          NutritionStatus.severeStunting);
    });

    test('IMT/U obesitas & wasting', () {
      expect(NutritionClassifier.classify(GrowthIndicator.bmiForAge, 3.5),
          NutritionStatus.obese);
      expect(NutritionClassifier.classify(GrowthIndicator.bmiForAge, 2.5),
          NutritionStatus.overweight);
      expect(NutritionClassifier.classify(GrowthIndicator.bmiForAge, -3.5),
          NutritionStatus.severeWasting);
    });

    test('IMT/U age-aware: ambang WHO 2007 (>5 thn) berbeda dari 0-5 thn', () {
      // Z = +1.5: 0-5 thn = "berisiko gizi lebih"; >5 thn = "overweight".
      expect(
          NutritionClassifier.classify(GrowthIndicator.bmiForAge, 1.5,
              ageMonths: 36),
          NutritionStatus.possibleRiskOverweight);
      expect(
          NutritionClassifier.classify(GrowthIndicator.bmiForAge, 1.5,
              ageMonths: 84),
          NutritionStatus.overweight);

      // Z = +2.5: 0-5 thn = overweight; >5 thn = obesitas.
      expect(
          NutritionClassifier.classify(GrowthIndicator.bmiForAge, 2.5,
              ageMonths: 36),
          NutritionStatus.overweight);
      expect(
          NutritionClassifier.classify(GrowthIndicator.bmiForAge, 2.5,
              ageMonths: 84),
          NutritionStatus.obese);
    });
  });
}
