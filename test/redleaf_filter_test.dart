import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/redleaf/redleaf_data.dart';
import 'package:tumbang/modules/redleaf/redleaf_model.dart';

/// Expected counts per domain for ages 0–12 months (window filter).
/// Source: Redleaf Chapter 4 sub-age bands in redleaf_data.dart.
const expectedCountsByAge = <int, Map<String, int>>{
  0: {
    'fisik_motorik': 7,
    'sosial_emosional': 4,
    'komunikasi_bahasa': 0,
    'kognitif': 2,
    'pendekatan_belajar': 1,
  },
  1: {
    'fisik_motorik': 7,
    'sosial_emosional': 9,
    'komunikasi_bahasa': 1,
    'kognitif': 2,
    'pendekatan_belajar': 1,
  },
  2: {
    'fisik_motorik': 12,
    'sosial_emosional': 5,
    'komunikasi_bahasa': 2,
    'kognitif': 6,
    'pendekatan_belajar': 1,
  },
  3: {
    'fisik_motorik': 12,
    'sosial_emosional': 10,
    'komunikasi_bahasa': 1,
    'kognitif': 4,
    'pendekatan_belajar': 1,
  },
  4: {
    'fisik_motorik': 15,
    'sosial_emosional': 5,
    'komunikasi_bahasa': 3,
    'kognitif': 5,
    'pendekatan_belajar': 1,
  },
  5: {
    'fisik_motorik': 8,
    'sosial_emosional': 5,
    'komunikasi_bahasa': 2,
    'kognitif': 1,
    'pendekatan_belajar': 1,
  },
  6: {
    'fisik_motorik': 16,
    'sosial_emosional': 8,
    'komunikasi_bahasa': 7,
    'kognitif': 4,
    'pendekatan_belajar': 4,
  },
  7: {
    'fisik_motorik': 8,
    'sosial_emosional': 3,
    'komunikasi_bahasa': 5,
    'kognitif': 3,
    'pendekatan_belajar': 3,
  },
  8: {
    'fisik_motorik': 8,
    'sosial_emosional': 3,
    'komunikasi_bahasa': 5,
    'kognitif': 3,
    'pendekatan_belajar': 3,
  },
  9: {
    'fisik_motorik': 11,
    'sosial_emosional': 8,
    'komunikasi_bahasa': 9,
    'kognitif': 9,
    'pendekatan_belajar': 3,
  },
  10: {
    'fisik_motorik': 3,
    'sosial_emosional': 5,
    'komunikasi_bahasa': 4,
    'kognitif': 6,
    'pendekatan_belajar': 3,
  },
  11: {
    'fisik_motorik': 3,
    'sosial_emosional': 5,
    'komunikasi_bahasa': 4,
    'kognitif': 6,
    'pendekatan_belajar': 3,
  },
  12: {
    'fisik_motorik': 3,
    'sosial_emosional': 5,
    'komunikasi_bahasa': 4,
    'kognitif': 6,
    'pendekatan_belajar': 3,
  },
};

bool _isRooting(RedleafItem item) {
  final t = item.title.toLowerCase();
  return t.contains('rooting') || t.contains('mencari puting');
}

void main() {
  final group0to12 = redleafAgeGroups.firstWhere((g) => g.id == '0_12m');
  final allItems =
      group0to12.domains.expand((d) => d.items).toList(growable: false);

  test('0-12 bulan punya 93 milestone ber-sub-usia', () {
    expect(allItems.length, 93);
    expect(
      allItems.every((i) => i.minMonth != null && i.maxMonth != null),
      isTrue,
    );
  });

  test('matrix usia 0-12: jumlah item per domain sesuai sub-usia buku', () {
    for (final age in expectedCountsByAge.keys) {
      final expected = expectedCountsByAge[age]!;
      var total = 0;
      for (final domain in group0to12.domains) {
        final filtered = filterRedleafItemsForAge(domain.items, age);
        final want = expected[domain.id]!;
        expect(
          filtered.length,
          want,
          reason: 'usia $age bln domain ${domain.id}',
        );
        total += filtered.length;
      }
      final expectedTotal = expected.values.fold<int>(0, (a, b) => a + b);
      expect(total, expectedTotal, reason: 'usia $age bln total');
      expect(total, lessThan(93), reason: 'usia $age tidak boleh 93 item');
    }
  });

  test('rooting hanya di usia 0-4 (0-2 birth + 3-4 fading)', () {
    for (var age = 0; age <= 12; age++) {
      final filtered = filterRedleafItemsForAge(allItems, age);
      final hasRooting = filtered.any(_isRooting);
      if (age <= 4) {
        expect(hasRooting, isTrue, reason: 'usia $age harus ada rooting');
      } else {
        expect(hasRooting, isFalse, reason: 'usia $age tidak boleh rooting');
      }
    }
  });

  test('usia 9: fisik hanya 6-9 dan 9-12, tanpa 0-2', () {
    final fisik = group0to12.domains.firstWhere((d) => d.id == 'fisik_motorik');
    final filtered = filterRedleafItemsForAge(fisik.items, 9);
    expect(filtered.length, 11);
    expect(filtered.every((i) => i.minMonth! >= 6), isTrue);
    expect(filtered.any(_isRooting), isFalse);
  });

  test('setiap item 0-12 muncul di minimal 1 usia', () {
    for (final item in allItems) {
      final ages = <int>[
        for (var a = 0; a <= 12; a++)
          if (isRedleafItemRelevantForAge(item, a)) a,
      ];
      expect(ages, isNotEmpty, reason: item.title);
      expect(ages.first, item.minMonth);
      expect(ages.last, item.maxMonth! > 12 ? 12 : item.maxMonth);
    }
  });

  test('tanpa usia: item ber-sub-usia disembunyikan', () {
    expect(filterRedleafItemsForAge(allItems, null), isEmpty);
  });

  test('kelompok 1 tahun: tanpa sub-usia, semua item tampil', () {
    final g1 = redleafAgeGroups.firstWhere((g) => g.id == '1_year');
    final items = g1.domains.first.items;
    expect(filterRedleafItemsForAge(items, 18).length, items.length);
  });

  test('getRedleafAgeGroupForAge: 0-12 tetap di group 0_12m', () {
    for (var age = 0; age <= 12; age++) {
      expect(
        getRedleafAgeGroupForAge(age).id,
        '0_12m',
        reason: 'usia $age harus 0_12m agar filter sub-usia jalan',
      );
    }
    expect(getRedleafAgeGroupForAge(13).id, '1_year');
    expect(getRedleafAgeGroupForAge(24).id, '1_year');
    expect(getRedleafAgeGroupForAge(25).id, '2_years');
  });
}
