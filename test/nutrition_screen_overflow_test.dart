import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbang/data/database.dart';
import 'package:tumbang/data/repository.dart';
import 'package:tumbang/modules/nutrition/nutrition_module_screen.dart';

/// Regresi: layar Nutrisi & Meal Plan tidak boleh overflow (garis kuning)
/// di layar ponsel sempit, dan dropdown gender harus mengikuti pasien.
void main() {
  testWidgets('tidak overflow di 360px dan gender mengikuti pasien perempuan',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = AppRepository(db);
    addTearDown(db.close);

    final girl = Patient(
      id: 'g1',
      name: 'Siti',
      birthDate: DateTime.now().subtract(const Duration(days: 400)),
      sex: 'P',
      createdAt: DateTime.now(),
      isPremature: false,
      hasDownSyndrome: false,
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [Provider<AppRepository>.value(value: repo)],
        child: MaterialApp(home: NutritionModuleScreen(initialPatient: girl)),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.takeException(), isNull,
        reason: 'render awal tab Kalkulator Gizi tidak boleh overflow');

    // Gender tampil "Perempuan" mengikuti pasien (bukan default laki-laki).
    expect(find.text('Perempuan'), findsWidgets);
    expect(find.text('Laki'), findsNothing);

    // Lepas layar lalu flush timer dari pemuatan async (stream DB) agar
    // tidak ada timer tertunda saat test berakhir.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });
}
