import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' as d;
import 'package:tumbang/data/database.dart';
import 'package:tumbang/data/repository.dart';

void main() {
  late AppDatabase db;
  late AppRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = AppRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Promotion - Pasien skrining cepat otomatis menjadi pasien terdaftar setelah pemeriksaan diisi', () async {
    // 1. Masukkan pasien anonim (Skrining Cepat)
    final patientId = await repo.insertPatient(PatientsCompanion.insert(
      name: 'Pasien Cepat',
      medicalRecordNo: const d.Value('ANONIM'),
      birthDate: DateTime(2025, 1, 1),
      sex: 'L',
      notes: const d.Value('Skrining Cepat'),
    ));

    var patient = await repo.getPatient(patientId);
    expect(patient!.medicalRecordNo, 'ANONIM');
    expect(patient.notes, 'Skrining Cepat');

    // 2. Buat pemeriksaan
    final examId = await repo.insertExamination(ExaminationsCompanion.insert(
      patientId: patientId,
      examDate: DateTime(2025, 6, 1),
    ));

    // 3. Upsert antropometri (modul growth)
    await repo.upsertGrowth(GrowthMeasurementsCompanion.insert(
      examinationId: examId,
      weightKg: const d.Value(8.5),
      heightCm: const d.Value(70.0),
    ));

    // 4. Verifikasi data pasien otomatis diperbarui (RM menjadi null / terdaftar)
    patient = await repo.getPatient(patientId);
    expect(patient!.medicalRecordNo, isNull);
    expect(patient.notes, isNull); // Catatan skrining cepat dibersihkan karena sudah terdaftar
  });
}
