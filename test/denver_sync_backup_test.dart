import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/data/database.dart';
import 'package:tumbang/data/repository.dart';
import 'package:tumbang/services/backup_service.dart';
import 'package:tumbang/services/sync_service.dart';

/// Regresi: hasil Denver II harus ikut backup/restore (dan tersimpan via
/// repository dengan ID stabil agar dapat tersinkronisasi seperti modul lain).
void main() {
  late AppDatabase db1;
  late AppDatabase db2;

  DenverResult denver(String id, String examId) => DenverResult(
        id: id,
        examinationId: examId,
        ageInMonths: 18.5,
        usedCorrectedAge: false,
        cautionsCount: 1,
        delaysCount: 0,
        globalResult: 'normal',
        answersJson: '{"1":"P"}',
        behaviorNotes: 'Kooperatif',
      );

  setUp(() async {
    db1 = AppDatabase.forTesting(NativeDatabase.memory());
    db2 = AppDatabase.forTesting(NativeDatabase.memory());
    await db1.into(db1.patients).insert(Patient(
          id: 'p1',
          name: 'Anak Denver',
          birthDate: DateTime(2024, 1, 1),
          sex: 'P',
          createdAt: DateTime.now(),
          isPremature: false,
          hasDownSyndrome: false,
        ));
    await db1.into(db1.examinations).insert(Examination(
          id: 'e1',
          patientId: 'p1',
          examDate: DateTime(2025, 7, 1),
          createdAt: DateTime.now(),
        ));
  });

  tearDown(() async {
    await db1.close();
    await db2.close();
  });

  test('Backup round-trip membawa hasil Denver II', () async {
    await db1.into(db1.denverResults).insert(denver('d1', 'e1'));

    final jsonStr = await BackupService(db1).exportBackupJson();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    expect((data['denverResults'] as List).length, 1);

    await BackupService(db2).importBackupJson(jsonStr);
    final restored = await db2.select(db2.denverResults).get();
    expect(restored.length, 1);
    expect(restored.first.id, 'd1');
    expect(restored.first.globalResult, 'normal');
    expect(restored.first.behaviorNotes, 'Kooperatif');
  });

  test('Impor overwrite menghapus Denver lama yang tidak ada di backup', () async {
    // db2 punya Denver yatim dari data sebelumnya.
    await db2.into(db2.patients).insert(Patient(
          id: 'p1',
          name: 'Anak Denver',
          birthDate: DateTime(2024, 1, 1),
          sex: 'P',
          createdAt: DateTime.now(),
          isPremature: false,
          hasDownSyndrome: false,
        ));
    await db2.into(db2.examinations).insert(Examination(
          id: 'e1',
          patientId: 'p1',
          examDate: DateTime(2025, 7, 1),
          createdAt: DateTime.now(),
        ));
    await db2.into(db2.denverResults).insert(denver('yatim', 'e1'));

    // Backup sumber tidak berisi Denver.
    final jsonStr = await BackupService(db1).exportBackupJson();
    await BackupService(db2).importBackupJson(jsonStr);

    final remaining = await db2.select(db2.denverResults).get();
    expect(remaining, isEmpty);
  });

  test('saveDenverResult dua kali: satu baris, ID stabil, aman dengan sync terpasang', () async {
    final repo = AppRepository(db1);
    repo.syncService = SyncService(db1); // belum terinisialisasi: upload no-op aman

    final id1 = await repo.saveDenverResult(
      examinationId: 'e1',
      patientId: 'p1',
      ageInMonths: 18.5,
      usedCorrectedAge: false,
      cautionsCount: 1,
      delaysCount: 0,
      globalResult: 'normal',
      answersJson: '{"1":"P"}',
    );
    final id2 = await repo.saveDenverResult(
      examinationId: 'e1',
      patientId: 'p1',
      ageInMonths: 18.5,
      usedCorrectedAge: false,
      cautionsCount: 2,
      delaysCount: 1,
      globalResult: 'suspect',
      answersJson: '{"1":"F"}',
    );

    expect(id2, equals(id1));
    final saved = await repo.getDenverResultForExamination('e1');
    expect(saved, isNotNull);
    expect(saved!.globalResult, 'suspect');
    final all = await db1.select(db1.denverResults).get();
    expect(all.length, 1);
  });
}
