import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/fenton/fenton_calculator.dart';

void main() {
  group('FentonCalculator Tests', () {
    test('calculatePMAWeeks calculates Postmenstrual Age correctly', () {
      final birthDate = DateTime(2026, 1, 1);
      final examDate = DateTime(2026, 1, 29); // 28 days = 4 weeks

      final pma = FentonCalculator.calculatePMAWeeks(
        gestationalWeeks: 30,
        birthDate: birthDate,
        examDate: examDate,
      );

      expect(pma, closeTo(34.0, 0.01));
    });

    test('isEligibleForFenton returns true for gestationalWeeks < 37', () {
      final eligible = FentonCalculator.isEligibleForFenton(
        gestationalWeeks: 32,
        ageMonths: 1.0,
      );
      expect(eligible, isTrue);
    });

    test('calculateCorrectedAgeMonths returns 0 for PMA <= 40 weeks', () {
      final corrected = FentonCalculator.calculateCorrectedAgeMonths(pmaWeeks: 36.0);
      expect(corrected, equals(0.0));
    });

    test('calculateCorrectedAgeMonths calculates corrected age for PMA > 40 weeks', () {
      final corrected = FentonCalculator.calculateCorrectedAgeMonths(pmaWeeks: 44.05);
      expect(corrected, closeTo(0.93, 0.1));
    });

    test('formatPMAStatus returns correct string descriptions', () {
      expect(FentonCalculator.formatPMAStatus(20.0), contains('< 22 minggu'));
      expect(FentonCalculator.formatPMAStatus(52.0), contains('> 50 minggu'));
      expect(FentonCalculator.formatPMAStatus(34.0), contains('Prematur < 40 mgg'));
      expect(FentonCalculator.formatPMAStatus(44.0), contains('usia koreksi'));
    });
  });
}
