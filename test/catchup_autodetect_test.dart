import 'package:drift/drift.dart' as d;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbang/data/database.dart';
import 'package:tumbang/data/repository.dart';
import 'package:tumbang/modules/growth/growth_assessment.dart';
import 'package:tumbang/modules/growth/who_growth_data.dart';
import 'package:tumbang/modules/nutrition/nutrition_module_screen.dart';

/// Regresi: indikasi catch-up growth harus terdeteksi otomatis dari status
/// gizi WHO pemeriksaan terakhir (bukan hanya checkbox manual di Meal Plan),
/// dengan definisi yang sama seperti layar Pertumbuhan & laporan PDF.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await WhoGrowthData.instance.ensureLoaded();
  });

  group('GrowthAssessment.indicatesMalnutrition', () {
    GrowthAssessment assess({
      required DateTime birth,
      required DateTime exam,
      required double w,
      required double h,
    }) {
      return GrowthAssessment.compute(
        birthDate: birth,
        examDate: exam,
        sex: 'P',
        weightKg: w,
        heightCm: h,
        measuredLying: false,
      );
    }

    test('anak gizi baik: tidak terindikasi', () {
      final a = assess(birth: DateTime(2024, 6, 1), exam: DateTime(2025, 6, 1), w: 9.4, h: 75);
      expect(a.indicatesMalnutrition, isFalse);
    });

    test('wasting (BB/TB rendah, TB normal): terindikasi', () {
      final a = assess(birth: DateTime(2024, 6, 1), exam: DateTime(2025, 6, 1), w: 7.0, h: 75);
      expect(a.indicatesMalnutrition, isTrue);
    });

    test('stunting saja (BB/TB normal): terindikasi', () {
      final a = assess(birth: DateTime(2023, 6, 1), exam: DateTime(2025, 6, 1), w: 10.5, h: 78);
      expect(a.indicatesMalnutrition, isTrue);
    });
  });

  testWidgets('Meal Plan: checkbox catch-up aktif otomatis untuk pasien wasting', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(360, 1100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = AppRepository(db);
    addTearDown(db.close);

    final patientId = await repo.insertPatient(PatientsCompanion.insert(
      name: 'Siti Wasting',
      birthDate: DateTime.now().subtract(const Duration(days: 400)),
      sex: 'P',
    ));
    final examId = await repo.insertExamination(ExaminationsCompanion.insert(
      patientId: patientId,
      examDate: DateTime.now(),
    ));
    await repo.upsertGrowth(GrowthMeasurementsCompanion.insert(
      examinationId: examId,
      weightKg: const d.Value(7.0),
      heightCm: const d.Value(75.0),
    ));
    final patient = await repo.getPatient(patientId);

    await tester.pumpWidget(
      MultiProvider(
        providers: [Provider<AppRepository>.value(value: repo)],
        child: MaterialApp(home: NutritionModuleScreen(initialPatient: patient)),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    // Biarkan future database (isolate sqlite nyata) selesai di luar zona
    // fake-async agar _loadPatientData sempat memanggil setState.
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pump(const Duration(milliseconds: 500));

    final tile = tester.widget<CheckboxListTile>(find.byType(CheckboxListTile));
    expect(tile.value, isTrue,
        reason: 'pasien wasting harus otomatis catch-up tanpa centang manual');
    expect(find.textContaining('Terdeteksi otomatis'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });
}
