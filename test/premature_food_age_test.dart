import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbang/data/database.dart';
import 'package:tumbang/data/repository.dart';
import 'package:tumbang/modules/nutrition/nutrition_module_screen.dart';

/// Regresi audit no. 8: sesuai arahan dokter, panduan makanan (tekstur,
/// porsi, resep, menu) untuk bayi prematur mengikuti usia koreksi selama
/// koreksi berlaku (<24 bulan), bukan usia kronologis.
void main() {
  testWidgets('pasien prematur: usia slider nutrisi = usia koreksi',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(360, 1100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = AppRepository(db);
    addTearDown(db.close);

    final now = DateTime.now();
    // Kronologis 10 bulan, lahir 32 minggu (koreksi 8 minggu) -> koreksi 8 bln.
    final patient = Patient(
      id: 'prematur-uji',
      name: 'Bayi Prematur',
      birthDate: DateTime(now.year, now.month - 10, now.day),
      sex: 'L',
      gestationalWeeks: 32,
      isPremature: true,
      hasDownSyndrome: false,
      createdAt: now,
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [Provider<AppRepository>.value(value: repo)],
        child: MaterialApp(
          home: NutritionModuleScreen(initialPatient: patient),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pump(const Duration(milliseconds: 300));

    // Slider memakai usia koreksi (8), bukan kronologis (10).
    expect(find.text('Usia koreksi: 8 bln'), findsOneWidget);
    expect(find.text('Usia: 10 bln'), findsNothing);
    // Penjelasan basis usia tampil agar tidak membingungkan.
    expect(
      find.textContaining('Kronologis 10 bln'),
      findsOneWidget,
    );
    expect(
      find.textContaining('mengikuti usia koreksi'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('pasien aterm: usia slider nutrisi = usia kronologis',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(360, 1100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = AppRepository(db);
    addTearDown(db.close);

    final now = DateTime.now();
    final patient = Patient(
      id: 'aterm-uji',
      name: 'Bayi Aterm',
      birthDate: DateTime(now.year, now.month - 10, now.day),
      sex: 'P',
      gestationalWeeks: 39,
      isPremature: false,
      hasDownSyndrome: false,
      createdAt: now,
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [Provider<AppRepository>.value(value: repo)],
        child: MaterialApp(
          home: NutritionModuleScreen(initialPatient: patient),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Usia: 10 bln'), findsOneWidget);
    expect(find.textContaining('mengikuti usia koreksi'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });
}
