import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/data/database.dart';
import 'package:tumbang/services/backup_service.dart';

void main() {
  late AppDatabase db1;
  late AppDatabase db2;

  setUp(() {
    db1 = AppDatabase.forTesting(NativeDatabase.memory());
    db2 = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db1.close();
    await db2.close();
  });

  test('BackupService - Ekspor dan Impor data kosong', () async {
    final backupService1 = BackupService(db1);
    final backupService2 = BackupService(db2);

    final jsonStr = await backupService1.exportBackupJson();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    expect(data['metadata']['app'], 'tumbang');
    expect(data['patients'], isEmpty);

    // Pulihkan ke db2
    await backupService2.importBackupJson(jsonStr);

    final patients = await db2.select(db2.patients).get();
    expect(patients, isEmpty);
  });

  test('BackupService - Ekspor dan Impor dengan data terisi lengkap', () async {
    // 1. Tambahkan data pasien
    final birth = DateTime(2025, 1, 1);
    final patient = Patient(
      id: 'patient-uuid-1',
      name: 'Budi Santoso',
      medicalRecordNo: 'RM-001',
      birthDate: birth,
      sex: 'L',
      parentName: 'Rudi',
      phone: '08123456789',
      address: 'Jl. Merdeka 10',
      gestationalWeeks: 38,
      isPremature: false,
      hasDownSyndrome: false,
      notes: 'Catatan pasien budi',
      createdAt: DateTime.now(),
    );
    await db1.into(db1.patients).insert(patient);

    // 2. Tambahkan data pemeriksaan
    final exam = Examination(
      id: 'exam-uuid-1',
      patientId: 'patient-uuid-1',
      examDate: DateTime(2025, 6, 1),
      examinerNote: 'Pemeriksaan rutin 6 bulan',
      createdAt: DateTime.now(),
    );
    await db1.into(db1.examinations).insert(exam);

    // 3. Tambahkan data antropometri
    final growth = GrowthMeasurement(
      id: 'growth-uuid-1',
      examinationId: 'exam-uuid-1',
      weightKg: 7.2,
      heightCm: 65.0,
      headCircumferenceCm: 42.0,
      measuredLying: false,
    );
    await db1.into(db1.growthMeasurements).insert(growth);

    // 4. Tambahkan data KPSP
    final kpsp = KpspResult(
      id: 'kpsp-uuid-1',
      examinationId: 'exam-uuid-1',
      formAgeMonths: 6,
      yesCount: 9,
      totalQuestions: 10,
      result: 'Sesuai',
      answersJson: '{"1": true, "2": true}',
    );
    await db1.into(db1.kpspResults).insert(kpsp);

    // 5. Ekspor data dari db1
    final backupService1 = BackupService(db1);
    final jsonStr = await backupService1.exportBackupJson();

    // 6. Impor data ke db2
    final backupService2 = BackupService(db2);
    await backupService2.importBackupJson(jsonStr);

    // 7. Verifikasi pemulihan data pada db2
    final patients2 = await db2.select(db2.patients).get();
    expect(patients2.length, 1);
    expect(patients2.first.name, 'Budi Santoso');
    expect(patients2.first.medicalRecordNo, 'RM-001');
    expect(patients2.first.birthDate.year, 2025);

    final exams2 = await db2.select(db2.examinations).get();
    expect(exams2.length, 1);
    expect(exams2.first.examinerNote, 'Pemeriksaan rutin 6 bulan');

    final growths2 = await db2.select(db2.growthMeasurements).get();
    expect(growths2.length, 1);
    expect(growths2.first.weightKg, 7.2);
    expect(growths2.first.heightCm, 65.0);

    final kpsps2 = await db2.select(db2.kpspResults).get();
    expect(kpsps2.length, 1);
    expect(kpsps2.first.yesCount, 9);
  });
}
