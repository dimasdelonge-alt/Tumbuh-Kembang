import 'package:drift/drift.dart' as d;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbang/data/database.dart';
import 'package:tumbang/data/repository.dart';
import 'package:tumbang/modules/nutrition/nutrition_module_screen.dart';

/// Regresi: saat dokter berganti pasien, BB/TB/catatan pasien sebelumnya
/// tidak boleh terbawa. Pasien tanpa data pemeriksaan harus mengembalikan
/// field ke nilai awal + menampilkan peringatan, dan hasil query pasien lama
/// yang datang terlambat harus diabaikan.
void main() {
  testWidgets('ganti pasien tidak membawa BB/TB pasien sebelumnya',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(360, 1100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = AppRepository(db);
    addTearDown(db.close);

    final wastingId = await repo.insertPatient(PatientsCompanion.insert(
      name: 'Siti Wasting',
      birthDate: DateTime.now().subtract(const Duration(days: 400)),
      sex: 'P',
    ));
    final examId = await repo.insertExamination(ExaminationsCompanion.insert(
      patientId: wastingId,
      examDate: DateTime.now(),
    ));
    await repo.upsertGrowth(GrowthMeasurementsCompanion.insert(
      examinationId: examId,
      weightKg: const d.Value(7.0),
      heightCm: const d.Value(80.0),
    ));

    final tanpaExamId = await repo.insertPatient(PatientsCompanion.insert(
      name: 'Budi',
      birthDate: DateTime.now().subtract(const Duration(days: 300)),
      sex: 'L',
    ));

    final wasting = await repo.getPatient(wastingId);
    final tanpaExam = (await repo.getPatient(tanpaExamId))!;

    await tester.pumpWidget(
      MultiProvider(
        providers: [Provider<AppRepository>.value(value: repo)],
        child: MaterialApp(home: NutritionModuleScreen(initialPatient: wasting)),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pump(const Duration(milliseconds: 300));

    // Data pasien pertama sudah terisi.
    expect(
      tester.widget<TextField>(find.byKey(const ValueKey('weight_field'))).controller?.text,
      '7.0',
    );

    // Ganti ke pasien tanpa data pemeriksaan.
    await tester.tap(find.byType(DropdownButton<String?>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('${tanpaExam.name} (${tanpaExam.sex})').last);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pump(const Duration(milliseconds: 300));

    final weight = tester
        .widget<TextField>(find.byKey(const ValueKey('weight_field')))
        .controller
        ?.text;
    final height = tester
        .widget<TextField>(find.byKey(const ValueKey('height_field')))
        .controller
        ?.text;
    expect(weight, '10.0', reason: 'BB pasien lama tidak boleh terbawa');
    expect(height, '75.0', reason: 'TB pasien lama tidak boleh terbawa');
    expect(find.textContaining('Belum ada data BB/TB'), findsOneWidget);

    // Checkbox catch-up kembali nonaktif untuk pasien baru.
    final tile = tester.widget<CheckboxListTile>(find.byType(CheckboxListTile));
    expect(tile.value, isFalse);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });
}
