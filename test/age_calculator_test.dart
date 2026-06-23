import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/core/age_calculator.dart';

void main() {
  group('AgeCalculator', () {
    test('usia kronologis tahun-bulan-hari', () {
      final r = AgeCalculator.calculate(
        birthDate: DateTime(2023, 1, 15),
        examDate: DateTime(2025, 4, 20),
      );
      expect(r.years, 2);
      expect(r.months, 3);
      expect(r.days, 5);
    });

    test('tanpa prematur tidak ada koreksi', () {
      final r = AgeCalculator.calculate(
        birthDate: DateTime(2024, 1, 1),
        examDate: DateTime(2024, 7, 1),
      );
      expect(r.correctionApplied, false);
      expect(r.correctedDays, r.chronologicalDays);
    });

    test('prematur 32 minggu dikoreksi 8 minggu (56 hari)', () {
      final birth = DateTime(2024, 1, 1);
      final exam = DateTime(2024, 7, 1); // ~182 hari
      final r = AgeCalculator.calculate(
        birthDate: birth,
        examDate: exam,
        gestationalWeeks: 32,
      );
      expect(r.correctionApplied, true);
      // 40-32 = 8 minggu = 56 hari prematuritas
      expect(r.chronologicalDays - r.correctedDays, 56);
    });

    test('koreksi berhenti setelah 24 bulan', () {
      final r = AgeCalculator.calculate(
        birthDate: DateTime(2022, 1, 1),
        examDate: DateTime(2024, 6, 1), // > 24 bulan
        gestationalWeeks: 30,
      );
      expect(r.correctionApplied, false);
      expect(r.correctedDays, r.chronologicalDays);
    });

    test('aterm (>=37 minggu) tidak dikoreksi', () {
      final r = AgeCalculator.calculate(
        birthDate: DateTime(2024, 1, 1),
        examDate: DateTime(2024, 7, 1),
        gestationalWeeks: 38,
      );
      expect(r.correctionApplied, false);
    });
  });
}
