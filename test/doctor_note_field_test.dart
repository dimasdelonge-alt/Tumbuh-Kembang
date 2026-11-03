import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbang/data/database.dart';
import 'package:tumbang/data/repository.dart';
import 'package:tumbang/modules/nutrition/nutrition_module_screen.dart';

/// Regresi: catatan dokter harus bisa diisi dari UI (sebelumnya controller
/// ada tapi tidak ada field-nya, sehingga "Catatan Dokter" di PDF selalu
/// kosong) dan teksnya bertahan walau field ter-dispose oleh ListView.
void main() {
  testWidgets('field catatan dokter terisi dan teksnya bertahan', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(360, 1100);
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

    // Pindah ke tab Meal Plan dengan swipe (tab terpotong di layar sempit).
    await tester.drag(find.byType(TabBarView), const Offset(-400, 0));
    await tester.pump(const Duration(milliseconds: 600));

    final noteField = find.byKey(const ValueKey('doctor_note_field'));
    final mealScrollable = find
        .ancestor(
          of: find.textContaining('Patokan Meal Plan'),
          matching: find.byType(Scrollable),
        )
        .first;
    final scrollState = tester.state<ScrollableState>(mealScrollable);
    var offset = 0.0;
    while (noteField.evaluate().isEmpty && offset <= scrollState.position.maxScrollExtent) {
      offset += 700;
      scrollState.position
          .jumpTo(offset.clamp(0.0, scrollState.position.maxScrollExtent));
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(noteField, findsOneWidget);

    await tester.enterText(noteField, 'Kontrol ulang 2 minggu lagi.');
    await tester.pump();
    expect(find.text('Kontrol ulang 2 minggu lagi.'), findsOneWidget);

    // Scroll jauh sampai field ter-dispose ListView, lalu kembali: teks
    // tidak hilang karena controller dimiliki State layar.
    scrollState.position.jumpTo(scrollState.position.maxScrollExtent);
    await tester.pump(const Duration(milliseconds: 300));
    var back = scrollState.position.pixels;
    while (noteField.evaluate().isEmpty && back > 0) {
      back -= 700;
      scrollState.position.jumpTo(back.clamp(0.0, double.infinity));
      await tester.pump(const Duration(milliseconds: 200));
    }
    final field = tester.widget<TextField>(noteField);
    expect(field.controller?.text, 'Kontrol ulang 2 minggu lagi.');
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });
}
