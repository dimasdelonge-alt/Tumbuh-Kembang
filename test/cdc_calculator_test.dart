import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/cdc/cdc_calculator.dart';

void main() {
  group('CdcCalculator TPG & Real-Time Evaluation Tests', () {
    test('calculateTPG calculates correct TPG for Boy', () {
      // Boy: ((motherHeight + 13) + fatherHeight) / 2
      // Mother 160, Father 170 -> ((160+13)+170)/2 = 171.5
      final tpg = CdcCalculator.calculateTPG(
        fatherHeightCm: 170.0,
        motherHeightCm: 160.0,
        sex: 'L',
      );

      expect(tpg, isNotNull);
      expect(tpg!.targetCm, closeTo(171.5, 0.01));
      expect(tpg.minCm, closeTo(163.0, 0.01));
      expect(tpg.maxCm, closeTo(180.0, 0.01));
    });

    test('calculateTPG calculates correct TPG for Girl', () {
      // Girl: ((fatherHeight - 13) + motherHeight) / 2
      // Father 170, Mother 160 -> ((170-13)+160)/2 = 158.5
      final tpg = CdcCalculator.calculateTPG(
        fatherHeightCm: 170.0,
        motherHeightCm: 160.0,
        sex: 'P',
      );

      expect(tpg, isNotNull);
      expect(tpg!.targetCm, closeTo(158.5, 0.01));
      expect(tpg.minCm, closeTo(150.0, 0.01));
      expect(tpg.maxCm, closeTo(167.0, 0.01));
    });

    test('calculateRealtimeTPG evaluates height at 5 years old (60 months)', () {
      final tpg = CdcCalculator.calculateTPG(
        fatherHeightCm: 170.0,
        motherHeightCm: 160.0,
        sex: 'L',
      );

      // Height below minimum expected range
      final belowEval = CdcCalculator.calculateRealtimeTPG(
        currentHeightCm: 95.0, // Extremely low height for 5yo
        ageMonths: 60,
        tpg: tpg,
      );

      expect(belowEval, isNotNull);
      expect(belowEval!.isBelow, isTrue);
      expect(belowEval.statusLabel, contains('DI BAWAH POTENSI GENETIK'));

      // Height within normal range
      final normalEval = CdcCalculator.calculateRealtimeTPG(
        currentHeightCm: 110.0, // Normal height for 5yo
        ageMonths: 60,
        tpg: tpg,
      );

      expect(normalEval, isNotNull);
      expect(normalEval!.isBelow, isFalse);
      expect(normalEval.isAbove, isFalse);
      expect(normalEval.statusLabel, contains('SESUAI POTENSI GENETIK'));
    });
  });
}
