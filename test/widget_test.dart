import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/kpsp/kpsp_data.dart';
import 'package:tumbang/modules/kpsp/kpsp_model.dart';

void main() {
  setUpAll(registerKpspForms);

  group('KpspScorer.categorize', () {
    test('9-10 sesuai', () {
      expect(KpspScorer.categorize(10), KpspResultCategory.sesuai);
      expect(KpspScorer.categorize(9), KpspResultCategory.sesuai);
    });
    test('7-8 meragukan', () {
      expect(KpspScorer.categorize(8), KpspResultCategory.meragukan);
      expect(KpspScorer.categorize(7), KpspResultCategory.meragukan);
    });
    test('<=6 penyimpangan', () {
      expect(KpspScorer.categorize(6), KpspResultCategory.penyimpangan);
      expect(KpspScorer.categorize(0), KpspResultCategory.penyimpangan);
    });
  });

  group('KpspData', () {
    test('16 form usia termuat', () {
      for (final a in KpspData.availableAges) {
        final f = KpspData.form(a);
        expect(f, isNotNull, reason: 'form $a bulan harus ada');
        expect(f!.questions.length, 10,
            reason: 'form $a bulan harus 10 pertanyaan');
        // nomor pertanyaan 1..10 unik
        final nums = f.questions.map((q) => q.number).toSet();
        expect(nums.length, 10);
      }
    });

    test('nearestFormAge memilih form lebih muda terdekat', () {
      expect(KpspScorer.nearestFormAge(3), 3);
      expect(KpspScorer.nearestFormAge(5), 3); // 5 -> 3
      expect(KpspScorer.nearestFormAge(28), 24); // 28 -> 24
      expect(KpspScorer.nearestFormAge(72), 72);
      expect(KpspScorer.nearestFormAge(100), 72); // clamp atas
      expect(KpspScorer.nearestFormAge(1), 3); // clamp bawah
    });
  });

  group('KpspScorer.interpret', () {
    test('semua Ya = sesuai, tanpa kegagalan domain', () {
      final form = KpspData.form(12)!;
      final answers = {for (var q in form.questions) q.number: true};
      final r = KpspScorer.interpret(form, answers);
      expect(r.yesCount, 10);
      expect(r.category, KpspResultCategory.sesuai);
      expect(r.failedByDomain, isEmpty);
    });

    test('jawaban tidak dikelompokkan per domain', () {
      final form = KpspData.form(12)!;
      final answers = {for (var q in form.questions) q.number: true};
      // jadikan 3 pertama gagal
      answers[1] = false;
      answers[2] = false;
      answers[3] = false;
      final r = KpspScorer.interpret(form, answers);
      expect(r.yesCount, 7);
      expect(r.category, KpspResultCategory.meragukan);
      final totalFailed =
          r.failedByDomain.values.fold<int>(0, (s, l) => s + l.length);
      expect(totalFailed, 3);
    });
  });
}
