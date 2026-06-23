import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/kpsp/developmental_age.dart';
import 'package:tumbang/modules/kpsp/kpsp_data.dart';
import 'package:tumbang/modules/kpsp/kpsp_model.dart';

void main() {
  setUpAll(registerKpspForms);

  KpspForm? resolve(int age) => KpspData.form(age);

  /// Bangun entri dengan semua item dijawab Ya kecuali yang di [failNumbers].
  KpspHistoryEntry entry(int formAge, {Set<int> failNumbers = const {}}) {
    final form = KpspData.form(formAge)!;
    final answers = <int, bool>{
      for (final q in form.questions) q.number: !failNumbers.contains(q.number)
    };
    return KpspHistoryEntry(formAgeMonths: formAge, answers: answers);
  }

  group('DevelopmentalAgeEngine', () {
    test('lulus penuh semua domain pada form 12 → estimasi >= 12', () {
      final res = DevelopmentalAgeEngine.analyze(
        history: [entry(12)],
        resolveForm: resolve,
        chronologicalMonths: 12,
      );
      for (final d in res.domains) {
        expect(d.estimatedMonths, 12,
            reason: '${d.domain} harus 12');
      }
    });

    test('mengambil form tertinggi yang lulus lintas kunjungan', () {
      // Lulus penuh di 9 dan 12 → estimasi minimal 12.
      final res = DevelopmentalAgeEngine.analyze(
        history: [entry(9), entry(12)],
        resolveForm: resolve,
        chronologicalMonths: 15,
      );
      for (final d in res.domains) {
        expect(d.estimatedMonths, 12);
      }
    });

    test('domain yang gagal tidak dapat estimasi dari form itu', () {
      // Pada form 12, gagalkan semua item domain bicara/bahasa.
      final form = KpspData.form(12)!;
      final bahasaNums = form.questions
          .where((q) => q.domain == KpspDomain.bicaraBahasa)
          .map((q) => q.number)
          .toSet();
      expect(bahasaNums, isNotEmpty);

      final res = DevelopmentalAgeEngine.analyze(
        history: [entry(12, failNumbers: bahasaNums)],
        resolveForm: resolve,
        chronologicalMonths: 12,
      );
      final bahasa = res.domains
          .firstWhere((d) => d.domain == KpspDomain.bicaraBahasa);
      expect(bahasa.estimatedMonths, isNull);
      expect(bahasa.highestFormAssessed, 12);
    });

    test('lowestDomain & maxLag mendeteksi keterlambatan dominan', () {
      // Lulus penuh di form 6, lalu di form 24 hanya bahasa yang gagal.
      final form24 = KpspData.form(24)!;
      final bahasa24 = form24.questions
          .where((q) => q.domain == KpspDomain.bicaraBahasa)
          .map((q) => q.number)
          .toSet();

      final res = DevelopmentalAgeEngine.analyze(
        history: [entry(6), entry(24, failNumbers: bahasa24)],
        resolveForm: resolve,
        chronologicalMonths: 24,
      );
      // Domain non-bahasa harus mencapai 24; bahasa tertinggal di 6.
      final low = res.lowestDomain;
      expect(low, isNotNull);
      expect(low!.domain, KpspDomain.bicaraBahasa);
      expect(low.estimatedMonths, 6);
      expect(res.maxLagMonths, 24 - 6);
    });

    test('tanpa riwayat → tidak ada domain', () {
      final res = DevelopmentalAgeEngine.analyze(
        history: const [],
        resolveForm: resolve,
        chronologicalMonths: 10,
      );
      expect(res.domains, isEmpty);
      expect(res.lowestDomain, isNull);
      expect(res.maxLagMonths, isNull);
    });
  });
}
