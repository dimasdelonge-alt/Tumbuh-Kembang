import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/autism/cars.dart';

void main() {
  group('CarsScorer.categorize', () {
    test('< 30 = non-autistik', () {
      expect(CarsScorer.categorize(15), CarsCategory.nonAutistic);
      expect(CarsScorer.categorize(29.5), CarsCategory.nonAutistic);
    });
    test('30 - 36,5 = ringan-sedang', () {
      expect(CarsScorer.categorize(30), CarsCategory.mildModerate);
      expect(CarsScorer.categorize(36.5), CarsCategory.mildModerate);
    });
    test('>= 37 = berat', () {
      expect(CarsScorer.categorize(37), CarsCategory.severe);
      expect(CarsScorer.categorize(60), CarsCategory.severe);
    });
  });

  group('CarsScorer.interpret', () {
    test('15 area semua nilai 1 = total 15 non-autistik', () {
      final values = {for (var a in carsAreas) a.number: 1.0};
      final r = CarsScorer.interpret(values);
      expect(r.totalScore, 15);
      expect(r.category, CarsCategory.nonAutistic);
    });

    test('semua nilai 2 = total 30 ringan-sedang', () {
      final values = {for (var a in carsAreas) a.number: 2.0};
      final r = CarsScorer.interpret(values);
      expect(r.totalScore, 30);
      expect(r.category, CarsCategory.mildModerate);
    });

    test('nilai pecahan dijumlahkan benar', () {
      final values = {for (var a in carsAreas) a.number: 2.5};
      final r = CarsScorer.interpret(values);
      expect(r.totalScore, 37.5); // 15 * 2.5
      expect(r.category, CarsCategory.severe);
    });

    test('semua nilai 4 = total 60 berat', () {
      final values = {for (var a in carsAreas) a.number: 4.0};
      final r = CarsScorer.interpret(values);
      expect(r.totalScore, 60);
      expect(r.category, CarsCategory.severe);
    });
  });

  group('CARS data', () {
    test('terdiri dari 15 area bernomor 1-15 unik', () {
      expect(carsAreas.length, 15);
      final nums = carsAreas.map((a) => a.number).toSet();
      expect(nums.length, 15);
      expect(nums, containsAll(List.generate(15, (i) => i + 1)));
    });

    test('nilai valid 1-4 langkah 0,5 (7 pilihan)', () {
      expect(CarsScorer.validValues, [1, 1.5, 2, 2.5, 3, 3.5, 4]);
    });
  });
}
