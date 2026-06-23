import 'dart:convert';
import '../data/database.dart';

/// Service untuk melakukan backup (ekspor) dan restore (impor) data aplikasi
/// dalam format JSON. Sesuai Fase 1 rencana migrasi.
class BackupService {
  final AppDatabase db;

  BackupService(this.db);

  /// Mengekspor seluruh isi database menjadi sebuah JSON string yang terformat rapi.
  Future<String> exportBackupJson() async {
    final patientsList = await db.select(db.patients).get();
    final examinationsList = await db.select(db.examinations).get();
    final growthList = await db.select(db.growthMeasurements).get();
    final kpspList = await db.select(db.kpspResults).get();
    final screeningList = await db.select(db.screeningResults).get();
    final visionList = await db.select(db.visionResults).get();
    final carsList = await db.select(db.carsResults).get();

    final backupMap = {
      'metadata': {
        'version': 1,
        'app': 'tumbang',
        'exportedAt': DateTime.now().toIso8601String(),
      },
      'patients': patientsList.map((e) => e.toJson()).toList(),
      'examinations': examinationsList.map((e) => e.toJson()).toList(),
      'growthMeasurements': growthList.map((e) => e.toJson()).toList(),
      'kpspResults': kpspList.map((e) => e.toJson()).toList(),
      'screeningResults': screeningList.map((e) => e.toJson()).toList(),
      'visionResults': visionList.map((e) => e.toJson()).toList(),
      'carsResults': carsList.map((e) => e.toJson()).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(backupMap);
  }

  /// Memulihkan database dari JSON string.
  /// Bila [overwrite] bernilai true, seluruh data lama akan dihapus terlebih dahulu.
  Future<void> importBackupJson(String jsonString, {bool overwrite = true}) async {
    final Map<String, dynamic> data = jsonDecode(jsonString) as Map<String, dynamic>;

    // Validasi metadata
    final metadata = data['metadata'] as Map<String, dynamic>?;
    if (metadata == null || metadata['app'] != 'tumbang') {
      throw const FormatException('Format file cadangan (backup) tidak valid.');
    }

    await db.transaction(() async {
      if (overwrite) {
        // Hapus data lama dengan urutan yang aman (terkait Foreign Keys)
        await db.delete(db.carsResults).go();
        await db.delete(db.visionResults).go();
        await db.delete(db.screeningResults).go();
        await db.delete(db.kpspResults).go();
        await db.delete(db.growthMeasurements).go();
        await db.delete(db.examinations).go();
        await db.delete(db.patients).go();
      }

      // Impor data baru dengan urutan relasi yang benar (Parent -> Child)
      if (data['patients'] != null) {
        final list = (data['patients'] as List)
            .map((e) => Patient.fromJson(e as Map<String, dynamic>))
            .toList();
        for (final item in list) {
          await db.into(db.patients).insertOnConflictUpdate(item);
        }
      }

      if (data['examinations'] != null) {
        final list = (data['examinations'] as List)
            .map((e) => Examination.fromJson(e as Map<String, dynamic>))
            .toList();
        for (final item in list) {
          await db.into(db.examinations).insertOnConflictUpdate(item);
        }
      }

      if (data['growthMeasurements'] != null) {
        final list = (data['growthMeasurements'] as List)
            .map((e) => GrowthMeasurement.fromJson(e as Map<String, dynamic>))
            .toList();
        for (final item in list) {
          await db.into(db.growthMeasurements).insertOnConflictUpdate(item);
        }
      }

      if (data['kpspResults'] != null) {
        final list = (data['kpspResults'] as List)
            .map((e) => KpspResult.fromJson(e as Map<String, dynamic>))
            .toList();
        for (final item in list) {
          await db.into(db.kpspResults).insertOnConflictUpdate(item);
        }
      }

      if (data['screeningResults'] != null) {
        final list = (data['screeningResults'] as List)
            .map((e) => ScreeningResult.fromJson(e as Map<String, dynamic>))
            .toList();
        for (final item in list) {
          await db.into(db.screeningResults).insertOnConflictUpdate(item);
        }
      }

      if (data['visionResults'] != null) {
        final list = (data['visionResults'] as List)
            .map((e) => VisionResult.fromJson(e as Map<String, dynamic>))
            .toList();
        for (final item in list) {
          await db.into(db.visionResults).insertOnConflictUpdate(item);
        }
      }

      if (data['carsResults'] != null) {
        final list = (data['carsResults'] as List)
            .map((e) => CarsResult.fromJson(e as Map<String, dynamic>))
            .toList();
        for (final item in list) {
          await db.into(db.carsResults).insertOnConflictUpdate(item);
        }
      }
    });
  }
}
