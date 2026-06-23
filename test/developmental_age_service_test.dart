import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/kpsp/developmental_age_service.dart';
import 'package:tumbang/modules/kpsp/kpsp_data.dart';
import 'package:tumbang/modules/kpsp/kpsp_model.dart';

void main() {
  setUpAll(registerKpspForms);

  /// Bangun baris riwayat: semua item Ya kecuali [failNumbers].
  KpspHistoryRow row(DateTime date, int formAge,
      {Set<int> failNumbers = const {}}) {
    final form = KpspData.form(formAge)!;
    final answers = <String, bool>{
      for (final q in form.questions)
        '${q.number}': !failNumbers.contains(q.number)
    };
    return KpspHistoryRow(
      examDate: date,
      formAgeMonths: formAge,
      answersJson: jsonEncode(answers),
    );
  }

  group('DevelopmentalAgeService.fromHistory', () {
    test('riwayat kosong → null', () {
      final r = DevelopmentalAgeService.fromHistory(
        birthDate: DateTime(2020, 1, 1),
        rows: const [],
      );
      expect(r, isNull);
    });

    test('menggabungkan riwayat → estimasi domain tertinggi', () {
      final birth = DateTime(2020, 1, 1);
      final rows = [
        row(DateTime(2020, 7, 1), 6),
        row(DateTime(2021, 1, 1), 12),
      ];
      final res = DevelopmentalAgeService.fromHistory(
        birthDate: birth,
        rows: rows,
      )!;
      for (final d in res.domains) {
        expect(d.estimatedMonths, 12);
      }
    });

    test('asOf membatasi entri ke kunjungan pada/sebelum tanggal', () {
      final birth = DateTime(2020, 1, 1);
      final rows = [
        row(DateTime(2020, 7, 1), 6), // usia 6 bln
        row(DateTime(2021, 1, 1), 12), // usia 12 bln (kunjungan kemudian)
      ];
      // asOf = tanggal kunjungan pertama → hanya form 6 yang dipakai.
      final res = DevelopmentalAgeService.fromHistory(
        birthDate: birth,
        rows: rows,
        asOf: DateTime(2020, 7, 1),
      )!;
      for (final d in res.domains) {
        expect(d.estimatedMonths, 6,
            reason: 'kunjungan setelah asOf harus diabaikan');
      }
    });

    test('koreksi prematur dipakai untuk pembanding < 2 thn', () {
      // Bayi prematur 32 mgg; pada asOf usia kronologis ~12 bln, koreksi ~10 bln.
      final birth = DateTime(2024, 1, 1);
      final rows = [row(DateTime(2024, 7, 1), 6)];
      final res = DevelopmentalAgeService.fromHistory(
        birthDate: birth,
        gestationalWeeks: 32,
        rows: rows,
        asOf: DateTime(2025, 1, 1),
      )!;
      // Pembanding memakai usia koreksi (< kronologis). Tidak error & ada hasil.
      expect(res.domains, isNotEmpty);
      expect(res.chronologicalMonths, lessThan(12));
    });
  });
}
