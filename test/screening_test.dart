import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/screening/instrument.dart';
import 'package:tumbang/modules/screening/data/kmme_data.dart';
import 'package:tumbang/modules/screening/data/mchat_data.dart';
import 'package:tumbang/modules/screening/data/gpph_data.dart';
import 'package:tumbang/modules/screening/data/sppahi_data.dart';
import 'package:tumbang/modules/screening/registry.dart';

void main() {
  group('ScreeningScorer (generik)', () {
    test('KMME: skor 0 = risiko rendah', () {
      final answers = {for (var i in kmmeInstrument.items) i.number: false};
      final r = ScreeningScorer.interpret(kmmeInstrument, answers);
      expect(r.score, 0);
      expect(r.level, RiskLevel.low);
      expect(r.flaggedItems, isEmpty);
    });

    test('KMME: 1 jawaban Ya = risiko sedang', () {
      final answers = {for (var i in kmmeInstrument.items) i.number: false};
      answers[1] = true;
      final r = ScreeningScorer.interpret(kmmeInstrument, answers);
      expect(r.score, 1);
      expect(r.level, RiskLevel.medium);
      expect(r.flaggedItems, [1]);
    });

    test('KMME: 2+ jawaban Ya = risiko tinggi', () {
      final answers = {for (var i in kmmeInstrument.items) i.number: false};
      answers[1] = true;
      answers[5] = true;
      answers[9] = true;
      final r = ScreeningScorer.interpret(kmmeInstrument, answers);
      expect(r.score, 3);
      expect(r.level, RiskLevel.high);
    });

    test('item terbalik (riskAnswer=tidak) dihitung saat jawaban Tidak', () {
      const inst = ScreeningInstrument(
        id: 'test',
        name: 'Test',
        shortDescription: '',
        minAgeMonths: 0,
        maxAgeMonths: 999,
        items: [
          ScreeningItem(1, 'normal (ya=risiko)'),
          ScreeningItem(2, 'terbalik (tidak=risiko)',
              riskAnswer: RiskAnswer.tidak),
        ],
        bands: [
          ScoreBand(
              minScore: 0,
              level: RiskLevel.low,
              interpretation: '',
              recommendation: ''),
          ScoreBand(
              minScore: 1,
              level: RiskLevel.high,
              interpretation: '',
              recommendation: ''),
        ],
      );
      // item1=Tidak (bukan risiko), item2=Tidak (risiko) -> skor 1
      var r = ScreeningScorer.interpret(inst, {1: false, 2: false});
      expect(r.score, 1);
      expect(r.flaggedItems, [2]);

      // item1=Ya (risiko), item2=Ya (bukan risiko) -> skor 1
      r = ScreeningScorer.interpret(inst, {1: true, 2: true});
      expect(r.score, 1);
      expect(r.flaggedItems, [1]);
    });

    test('bandFor memilih band tertinggi yang sesuai', () {
      expect(ScreeningScorer.bandFor(kmmeInstrument, 0).level, RiskLevel.low);
      expect(
          ScreeningScorer.bandFor(kmmeInstrument, 1).level, RiskLevel.medium);
      expect(
          ScreeningScorer.bandFor(kmmeInstrument, 12).level, RiskLevel.high);
    });
  });

  group('ScreeningRegistry', () {
    test('KMME terdaftar dan bisa dicari by id', () {
      expect(ScreeningRegistry.byId('kmme'), isNotNull);
      expect(ScreeningRegistry.byId('kmme')!.totalItems, 12);
      expect(ScreeningRegistry.byId('tidak_ada'), isNull);
    });

    test('TDD & M-CHAT terdaftar', () {
      expect(ScreeningRegistry.byId('tdd'), isNotNull);
      expect(ScreeningRegistry.byId('mchat_r'), isNotNull);
    });
  });

  group('M-CHAT-R', () {
    test('20 item; item 2,5,12 berisiko saat "Ya", sisanya saat "Tidak"', () {
      expect(mchatInstrument.totalItems, 20);
      for (final item in mchatInstrument.items) {
        if ([2, 5, 12].contains(item.number)) {
          expect(item.riskAnswer, RiskAnswer.ya,
              reason: 'item ${item.number} harus terbalik');
        } else {
          expect(item.riskAnswer, RiskAnswer.tidak,
              reason: 'item ${item.number} harus normal');
        }
      }
    });

    test('semua jawaban "tidak berisiko" = skor 0 risiko rendah', () {
      // Untuk item normal jawab Ya; untuk item terbalik (2,5,12) jawab Tidak.
      final answers = <int, bool>{};
      for (final item in mchatInstrument.items) {
        answers[item.number] = item.riskAnswer == RiskAnswer.tidak;
      }
      final r = ScreeningScorer.interpret(mchatInstrument, answers);
      expect(r.score, 0);
      expect(r.level, RiskLevel.low);
    });

    test('semua jawaban berisiko = skor 20 risiko tinggi', () {
      final answers = <int, bool>{};
      for (final item in mchatInstrument.items) {
        // jawab sesuai riskAnswer agar semua dihitung
        answers[item.number] = item.riskAnswer == RiskAnswer.ya;
      }
      final r = ScreeningScorer.interpret(mchatInstrument, answers);
      expect(r.score, 20);
      expect(r.level, RiskLevel.high);
    });

    test('ambang band: 2->rendah, 3->sedang, 8->tinggi', () {
      expect(
          ScreeningScorer.bandFor(mchatInstrument, 2).level, RiskLevel.low);
      expect(ScreeningScorer.bandFor(mchatInstrument, 3).level,
          RiskLevel.medium);
      expect(
          ScreeningScorer.bandFor(mchatInstrument, 8).level, RiskLevel.high);
    });
  });

  group('GPPH (Likert 0-3)', () {
    test('instrumen bertipe likert4, 10 item, maxScore 30', () {
      expect(gpphInstrument.responseType, ResponseType.likert4);
      expect(gpphInstrument.totalItems, 10);
      expect(gpphInstrument.maxScore, 30);
    });

    test('semua 0 = skor 0 risiko rendah', () {
      final answers = {for (var i in gpphInstrument.items) i.number: 0};
      final r = ScreeningScorer.interpretLikert(gpphInstrument, answers);
      expect(r.score, 0);
      expect(r.level, RiskLevel.low);
    });

    test('skor 12 (< 13) tetap risiko rendah', () {
      // 4 item bernilai 3 = 12.
      final answers = {for (var i in gpphInstrument.items) i.number: 0};
      answers[1] = 3;
      answers[2] = 3;
      answers[3] = 3;
      answers[4] = 3;
      final r = ScreeningScorer.interpretLikert(gpphInstrument, answers);
      expect(r.score, 12);
      expect(r.level, RiskLevel.low);
    });

    test('skor 13 (ambang) = risiko tinggi', () {
      final answers = {for (var i in gpphInstrument.items) i.number: 0};
      answers[1] = 3;
      answers[2] = 3;
      answers[3] = 3;
      answers[4] = 3;
      answers[5] = 1; // total 13
      final r = ScreeningScorer.interpretLikert(gpphInstrument, answers);
      expect(r.score, 13);
      expect(r.level, RiskLevel.high);
    });

    test('nilai >=2 masuk flaggedItems; nilai di-clamp 0..3', () {
      final answers = {for (var i in gpphInstrument.items) i.number: 0};
      answers[1] = 2;
      answers[2] = 1;
      answers[3] = 5; // di-clamp jadi 3
      final r = ScreeningScorer.interpretLikert(gpphInstrument, answers);
      expect(r.score, 2 + 1 + 3);
      expect(r.flaggedItems, containsAll([1, 3]));
      expect(r.flaggedItems, isNot(contains(2)));
    });

    test('semua 3 = skor 30 risiko tinggi', () {
      final answers = {for (var i in gpphInstrument.items) i.number: 3};
      final r = ScreeningScorer.interpretLikert(gpphInstrument, answers);
      expect(r.score, 30);
      expect(r.level, RiskLevel.high);
    });
  });

  group('SPPAHI (cut-off bergantung penilai)', () {
    test('35 item, likert4, maxScore 105', () {
      expect(sppahiInstrument.totalItems, 35);
      expect(sppahiInstrument.responseType, ResponseType.likert4);
      expect(sppahiInstrument.maxScore, 105);
      expect(sppahiInstrument.hasRaterSelection, true);
    });

    test('skor 25: tinggi utk dokter (>=22), rendah utk ortu (>=30)', () {
      // 25 item bernilai 1 = skor 25.
      final answers = {for (var i in sppahiInstrument.items) i.number: 0};
      for (var n = 1; n <= 25; n++) {
        answers[n] = 1;
      }
      final dokter = ScreeningScorer.interpretLikert(sppahiInstrument, answers,
          rater: 'Dokter');
      final ortu = ScreeningScorer.interpretLikert(sppahiInstrument, answers,
          rater: 'Orang tua');
      expect(dokter.score, 25);
      expect(dokter.level, RiskLevel.high, reason: '25 >= 22 (dokter)');
      expect(ortu.level, RiskLevel.low, reason: '25 < 30 (orang tua)');
    });

    test('skor 30: tinggi utk guru (>=29) dan ortu (>=30)', () {
      final answers = {for (var i in sppahiInstrument.items) i.number: 0};
      for (var n = 1; n <= 30; n++) {
        answers[n] = 1;
      }
      final guru = ScreeningScorer.interpretLikert(sppahiInstrument, answers,
          rater: 'Guru');
      final ortu = ScreeningScorer.interpretLikert(sppahiInstrument, answers,
          rater: 'Orang tua');
      expect(guru.level, RiskLevel.high);
      expect(ortu.level, RiskLevel.high);
    });

    test('tanpa rater → tidak ditandai tinggi (penilai tak diketahui)', () {
      final answers = {for (var i in sppahiInstrument.items) i.number: 0};
      answers[1] = 1; // skor 1
      final r = ScreeningScorer.interpretLikert(sppahiInstrument, answers);
      // Instrumen ber-rater tanpa penilai dikenali tidak otomatis "tinggi".
      expect(r.level, RiskLevel.low);
    });
  });
}
