import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbang/data/database.dart';
import 'package:tumbang/data/repository.dart';
import 'package:tumbang/modules/nutrition/nutrition_module_screen.dart';

/// Regresi: dulu tab Panduan Porsi hanya menampilkan rentang umum per usia,
/// sehingga takarannya bisa berbeda dengan Meal Plan. Sekarang porsi hasil
/// hitung target kalori tampil sebagai acuan utama di tab yang sama.
void main() {
  testWidgets('tab Panduan Porsi memakai takaran hasil hitung Meal Plan',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(360, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = AppRepository(db);
    addTearDown(db.close);

    await tester.pumpWidget(
      MultiProvider(
        providers: [Provider<AppRepository>.value(value: repo)],
        child: const MaterialApp(home: NutritionModuleScreen()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    // Geser ke tab Panduan Porsi (indeks 2).
    await tester.drag(find.byType(TabBarView), const Offset(-400, 0));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.drag(find.byType(TabBarView), const Offset(-400, 0));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Porsi Hasil Hitung Target Kalori (Acuan Utama)'),
        findsOneWidget);
    // Sesi makan dari Meal Plan ikut tampil lengkap dengan takarannya.
    expect(find.textContaining('Makan Pagi (07:00)'), findsOneWidget);
    expect(find.textContaining('g (±'), findsWidgets);
    // Penjelasan precedence agar dokter tidak bingung dua angka.
    expect(find.textContaining('ikuti takaran hasil hitung ini'), findsOneWidget);

    // Referensi umum berada di bawah kartu acuan utama.
    final portionScrollable = find
        .ancestor(
          of: find.text('Porsi Hasil Hitung Target Kalori (Acuan Utama)'),
          matching: find.byType(Scrollable),
        )
        .first;
    final scrollState = tester.state<ScrollableState>(portionScrollable);
    var offset = 0.0;
    while (find.text('Panduan Porsi Umum per Usia (Referensi)').evaluate().isEmpty &&
        offset <= scrollState.position.maxScrollExtent) {
      offset += 500;
      scrollState.position
          .jumpTo(offset.clamp(0.0, scrollState.position.maxScrollExtent));
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Panduan Porsi Umum per Usia (Referensi)'),
        findsOneWidget);
    expect(find.textContaining('bukan target individual'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });
}
