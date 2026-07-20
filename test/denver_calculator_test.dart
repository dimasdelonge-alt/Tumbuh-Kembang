import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/denver/denver_calculator.dart';
import 'package:tumbang/modules/denver/denver_data.dart';
import 'package:tumbang/modules/denver/denver_model.dart';

void main() {
  group('DenverCalculator Tests', () {
    test('calculateTestAge - Chronological vs Corrected', () {
      final birthDate = DateTime(2026, 1, 1);
      final testDate = DateTime(2026, 7, 1); // ~6 bulan

      // Aterm: tidak dikoreksi
      final atermRes = DenverCalculator.calculateTestAge(
        birthDate: birthDate,
        testDate: testDate,
        isPremature: false,
      );
      expect(atermRes['usedCorrectedAge'], isFalse);
      expect((atermRes['ageInMonths'] as double).round(), equals(6));

      // Prematur 32 minggu: dikoreksi ~2 bulan (8 minggu)
      final premRes = DenverCalculator.calculateTestAge(
        birthDate: birthDate,
        testDate: testDate,
        isPremature: true,
        gestationalWeeks: 32,
      );
      expect(premRes['usedCorrectedAge'], isTrue);
      expect((premRes['ageInMonths'] as double).round(), equals(4));
    });

    test('evaluateItemStatus - Advanced, Normal, Caution, Delayed', () {
      // Dummy Item: p25=12, p50=15, p75=18, p90=24
      const item = DenverItem(
        id: 'test_1',
        sector: DenverSector.personalSocial,
        title: 'Test Item',
        p25: 12.0,
        p50: 15.0,
        p75: 18.0,
        p90: 24.0,
        indexInSector: 0,
      );

      // 1. Pass pada usia 10 bln (< p25) -> Advanced
      final statusAdv = DenverCalculator.evaluateItemStatus(
        item: item,
        ageInMonths: 10.0,
        evaluation: DenverItemEvaluation.pass,
      );
      expect(statusAdv, equals(DenverItemStatus.advanced));

      // 2. Pass pada usia 20 bln -> Normal
      final statusNormPass = DenverCalculator.evaluateItemStatus(
        item: item,
        ageInMonths: 20.0,
        evaluation: DenverItemEvaluation.pass,
      );
      expect(statusNormPass, equals(DenverItemStatus.normal));

      // 3. Fail pada usia 20 bln (antara p75=18 dan p90=24) -> Caution
      final statusCaution = DenverCalculator.evaluateItemStatus(
        item: item,
        ageInMonths: 20.0,
        evaluation: DenverItemEvaluation.fail,
      );
      expect(statusCaution, equals(DenverItemStatus.caution));

      // 4. Fail pada usia 26 bln (> p90=24) -> Delayed
      final statusDelayed = DenverCalculator.evaluateItemStatus(
        item: item,
        ageInMonths: 26.0,
        evaluation: DenverItemEvaluation.fail,
      );
      expect(statusDelayed, equals(DenverItemStatus.delayed));
    });

    test('analyze - Normal, Suspect, & Untestable', () {
      final answersNormal = <String, DenverItemEvaluation>{
        'ps_1': DenverItemEvaluation.pass,
        'ps_2': DenverItemEvaluation.pass,
        'fm_1': DenverItemEvaluation.pass,
        'lang_1': DenverItemEvaluation.pass,
        'gm_1': DenverItemEvaluation.pass,
      };

      final resNormal = DenverCalculator.analyze(
        ageInMonths: 2.0,
        usedCorrectedAge: false,
        answers: answersNormal,
      );
      expect(resNormal.globalResult, equals(DenverGlobalResult.normal));
      expect(resNormal.cautionsCount, equals(0));
      expect(resNormal.delaysCount, equals(0));

      // Suspect: 1 Delay (Fail pada item yang p90 nya sudah jauh terlewat)
      final answersSuspect = <String, DenverItemEvaluation>{
        'ps_1': DenverItemEvaluation.fail, // ps_1 p90=1.5 bln, dites usia 12 bln -> Delayed!
      };

      final resSuspect = DenverCalculator.analyze(
        ageInMonths: 12.0,
        usedCorrectedAge: false,
        answers: answersSuspect,
      );
      expect(resSuspect.globalResult, equals(DenverGlobalResult.suspect));
      expect(resSuspect.delaysCount, equals(1));

      // Untestable: Refusal pada item delayed
      final answersUntestable = <String, DenverItemEvaluation>{
        'ps_1': DenverItemEvaluation.refusal, // Refusal pada item delayed -> Untestable
      };

      final resUntestable = DenverCalculator.analyze(
        ageInMonths: 12.0,
        usedCorrectedAge: false,
        answers: answersUntestable,
      );
      expect(resUntestable.globalResult, equals(DenverGlobalResult.untestable));
    });

    test('DenverData contains 120 items', () {
      expect(DenverData.allItems.length, equals(120));
    });
  });
}
