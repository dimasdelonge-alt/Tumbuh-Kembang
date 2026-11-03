import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbang/data/database.dart';
import 'package:tumbang/data/repository.dart';
import 'package:tumbang/modules/nutrition/nutrition_module_screen.dart';

/// Regresi: pilihan bahan makanan dimuat & disimpan lewat ConfigStorage
/// (bukan SharedPreferences langsung) sehingga juga aman di web.
void main() {
  testWidgets('pilihan bahan dimuat dan disimpan lewat ConfigStorage',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nutrition_selected_carbs': ['Kentang'],
    });
    tester.view.physicalSize = const Size(420, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = AppRepository(db);
    addTearDown(db.close);

    Future<void> pumpScreen() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [Provider<AppRepository>.value(value: repo)],
          child: const MaterialApp(home: NutritionModuleScreen()),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });
      await tester.pump(const Duration(milliseconds: 300));
      // Pindah ke tab Meal Plan (tempat chip bahan berada).
      await tester.drag(find.byType(TabBarView), const Offset(-400, 0));
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('Centang Bahan Makanan yang Tersedia di Rumah:'),
          findsOneWidget);
    }

    FilterChip chipFor(String name) {
      return tester.widget<FilterChip>(
        find
            .ancestor(
              of: find.textContaining(name),
              matching: find.byType(FilterChip),
            )
            .first,
      );
    }

    await pumpScreen();

    // Nilai tersimpan (hanya Kentang) menimpa default.
    expect(chipFor('Kentang').selected, isTrue);
    expect(chipFor('Nasi Beras Giling').selected, isFalse);

    // Mencentang bahan lain harus tersimpan lewat ConfigStorage.
    final nasiChip = find
        .ancestor(
          of: find.textContaining('Nasi Beras Giling'),
          matching: find.byType(FilterChip),
        )
        .first;
    await tester.ensureVisible(nasiChip);
    await tester.pumpAndSettle();
    await tester.tap(nasiChip);
    await tester.pump();
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });

    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getStringList('nutrition_selected_carbs'),
      containsAll(<String>['Kentang', 'Nasi Beras Giling']),
    );
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });
}
