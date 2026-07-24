import 'dart:async';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'database.dart';
import '../services/sync_service.dart';

/// Repository tunggal untuk akses data aplikasi.
///
/// Membungkus AppDatabase agar UI tidak bergantung langsung pada drift.
class AppRepository {
  final AppDatabase db;
  final _uuid = const Uuid();
  SyncService? syncService;

  AppRepository(this.db);

  // ---------------- Pasien ----------------

  Stream<List<Patient>> watchPatients() {
    return (db.select(db.patients)
          ..where((p) => p.deletedAt.isNull())
          ..orderBy([(p) => OrderingTerm(expression: p.name)]))
        .watch();
  }

  Future<List<Patient>> searchPatients(String query) {
    final q = '%$query%';
    return (db.select(db.patients)
          ..where((p) =>
              p.deletedAt.isNull() &
              (p.name.like(q) | p.medicalRecordNo.like(q)))
          ..orderBy([(p) => OrderingTerm(expression: p.name)]))
        .get();
  }

  Future<Patient?> getPatient(String id) {
    return (db.select(db.patients)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  /// Simpan pasien baru, mengembalikan id.
  Future<String> insertPatient(PatientsCompanion data) async {
    final id = data.id.present ? data.id.value : _uuid.v4();
    await db.into(db.patients).insert(data.copyWith(id: Value(id)));
    if (syncService != null) {
      final item = await getPatient(id);
      if (item != null) {
        unawaited(syncService!.uploadPatient(item));
      }
    }
    return id;
  }

  Future<void> updatePatient(Patient patient) async {
    await db.update(db.patients).replace(patient);
    if (syncService != null) {
      unawaited(syncService!.uploadPatient(patient));
    }
  }

  /// Soft delete: set deletedAt = now. Data tetap ada di database.
  Future<void> deletePatient(String id) async {
    final now = DateTime.now();
    await (db.update(db.patients)..where((p) => p.id.equals(id)))
        .write(PatientsCompanion(deletedAt: Value(now)));
    // Juga soft-delete semua examinations milik pasien ini
    await (db.update(db.examinations)..where((e) => e.patientId.equals(id)))
        .write(ExaminationsCompanion(deletedAt: Value(now)));
    if (syncService != null) {
      final item = await getPatient(id);
      if (item != null) unawaited(syncService!.uploadPatient(item));
    }
  }

  /// Restore pasien dari tempat sampah.
  Future<void> restorePatient(String id) async {
    await (db.update(db.patients)..where((p) => p.id.equals(id)))
        .write(const PatientsCompanion(deletedAt: Value(null)));
    // Restore juga semua examinations milik pasien ini
    await (db.update(db.examinations)..where((e) => e.patientId.equals(id)))
        .write(const ExaminationsCompanion(deletedAt: Value(null)));
    if (syncService != null) {
      final item = await getPatient(id);
      if (item != null) unawaited(syncService!.uploadPatient(item));
    }
  }

  /// Hapus permanen pasien beserta seluruh data terkait (cascade).
  Future<void> permanentlyDeletePatient(String id) async {
    await (db.delete(db.patients)..where((p) => p.id.equals(id))).go();
    if (syncService != null) {
      unawaited(syncService!.deletePatientRemote(id));
    }
  }

  /// Watch pasien yang ada di tempat sampah (soft deleted).
  Stream<List<Patient>> watchDeletedPatients() {
    return (db.select(db.patients)
          ..where((p) => p.deletedAt.isNotNull())
          ..orderBy([(p) => OrderingTerm(
              expression: p.deletedAt, mode: OrderingMode.desc)]))
        .watch();
  }

  /// Hapus permanen semua pasien yang sudah di-soft-delete > 30 hari.
  Future<int> autoCleanTrash() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    final expired = await (db.select(db.patients)
          ..where((p) => p.deletedAt.isNotNull() &
              p.deletedAt.isSmallerThanValue(cutoff)))
        .get();
    for (final p in expired) {
      await permanentlyDeletePatient(p.id);
    }
    return expired.length;
  }

  /// Hapus permanen SEMUA item di tempat sampah.
  Future<void> emptyTrash() async {
    final deleted = await (db.select(db.patients)
          ..where((p) => p.deletedAt.isNotNull()))
        .get();
    for (final p in deleted) {
      await permanentlyDeletePatient(p.id);
    }
  }

  // ---------------- Pemeriksaan ----------------

  Stream<List<Examination>> watchExaminations(String patientId) {
    return (db.select(db.examinations)
          ..where((e) => e.patientId.equals(patientId) & e.deletedAt.isNull())
          ..orderBy([
            (e) => OrderingTerm(
                expression: e.examDate, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future<String> insertExamination(ExaminationsCompanion data) async {
    final id = data.id.present ? data.id.value : _uuid.v4();
    await db.into(db.examinations).insert(data.copyWith(id: Value(id)));
    if (syncService != null) {
      final item = await getExamination(id);
      if (item != null) {
        unawaited(syncService!.uploadExamination(item));
      }
    }
    return id;
  }

  /// Soft delete pemeriksaan.
  Future<void> deleteExamination(String id) async {
    await (db.update(db.examinations)..where((e) => e.id.equals(id)))
        .write(ExaminationsCompanion(deletedAt: Value(DateTime.now())));
    if (syncService != null) {
      final item = await getExamination(id);
      if (item != null) unawaited(syncService!.uploadExamination(item));
    }
  }

  /// Restore pemeriksaan dari tempat sampah.
  Future<void> restoreExamination(String id) async {
    await (db.update(db.examinations)..where((e) => e.id.equals(id)))
        .write(const ExaminationsCompanion(deletedAt: Value(null)));
    if (syncService != null) {
      final item = await getExamination(id);
      if (item != null) unawaited(syncService!.uploadExamination(item));
    }
  }

  /// Hapus permanen pemeriksaan.
  Future<void> permanentlyDeleteExamination(String id) async {
    await (db.delete(db.examinations)..where((e) => e.id.equals(id))).go();
    if (syncService != null) {
      unawaited(syncService!.deleteExaminationRemote(id));
    }
  }

  /// Watch pemeriksaan yang ada di tempat sampah.
  Stream<List<Examination>> watchDeletedExaminations() {
    return (db.select(db.examinations)
          ..where((e) => e.deletedAt.isNotNull())
          ..orderBy([(e) => OrderingTerm(
              expression: e.deletedAt, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<Examination?> getExamination(String id) {
    return (db.select(db.examinations)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
  }

  // ---------------- Antropometri ----------------

  Future<String> upsertGrowth(GrowthMeasurementsCompanion data) async {
    final id = data.id.present ? data.id.value : _uuid.v4();
    final examId = data.examinationId.value;
    await db.transaction(() async {
      await (db.delete(db.growthMeasurements)
            ..where((g) => g.examinationId.equals(examId)))
          .go();
      await db
          .into(db.growthMeasurements)
          .insert(data.copyWith(id: Value(id)));
    });
    await _promoteIfAnonymous(examId);
    if (syncService != null) {
      final item = await getGrowthForExam(examId);
      if (item != null) {
        unawaited(syncService!.uploadGrowthMeasurement(item));
      }
    }
    return id;
  }

  Future<GrowthMeasurement?> getGrowthForExam(String examinationId) async {
    final list = await (db.select(db.growthMeasurements)
          ..where((g) => g.examinationId.equals(examinationId)))
        .get();
    return list.isEmpty ? null : list.first;
  }

  // ---------------- KPSP ----------------

  Future<String> upsertKpsp(KpspResultsCompanion data) async {
    final id = data.id.present ? data.id.value : _uuid.v4();
    final examId = data.examinationId.value;
    await db.transaction(() async {
      await (db.delete(db.kpspResults)
            ..where((k) => k.examinationId.equals(examId)))
          .go();
      await db.into(db.kpspResults).insert(data.copyWith(id: Value(id)));
    });
    await _promoteIfAnonymous(examId);
    if (syncService != null) {
      final item = await getKpspForExam(examId);
      if (item != null) {
        unawaited(syncService!.uploadKpspResult(item));
      }
    }
    return id;
  }

  Future<KpspResult?> getKpspForExam(String examinationId) async {
    final list = await (db.select(db.kpspResults)
          ..where((k) => k.examinationId.equals(examinationId)))
        .get();
    return list.isEmpty ? null : list.first;
  }

  // ---------------- Instrumen skrining generik (KMME, M-CHAT, dll) ----------

  /// Simpan hasil instrumen. Bila sudah ada hasil instrumen yang sama untuk
  /// pemeriksaan ini, ganti (hindari duplikat per exam+instrument).
  Future<String> upsertScreening(ScreeningResultsCompanion data) async {
    final id = data.id.present ? data.id.value : _uuid.v4();
    final examId = data.examinationId.value;
    final instrId = data.instrumentId.value;
    await db.transaction(() async {
      await (db.delete(db.screeningResults)
            ..where((s) =>
                s.examinationId.equals(examId) &
                s.instrumentId.equals(instrId)))
          .go();
      await db
          .into(db.screeningResults)
          .insert(data.copyWith(id: Value(id)));
    });
    await _promoteIfAnonymous(examId);
    if (syncService != null) {
      final item = await getScreening(examId, instrId);
      if (item != null) {
        unawaited(syncService!.uploadScreeningResult(item));
      }
    }
    return id;
  }

  Future<List<ScreeningResult>> getScreeningsForExam(String examinationId) {
    return (db.select(db.screeningResults)
          ..where((s) => s.examinationId.equals(examinationId)))
        .get();
  }

  Future<ScreeningResult?> getScreening(
      String examinationId, String instrumentId) {
    return (db.select(db.screeningResults)
          ..where((s) =>
              s.examinationId.equals(examinationId) &
              s.instrumentId.equals(instrumentId)))
        .getSingleOrNull();
  }

  // ---------------- TDL (Tes Daya Lihat) ----------------

  /// Simpan hasil TDL; ganti hasil sebelumnya untuk pemeriksaan yang sama.
  Future<String> upsertVision(VisionResultsCompanion data) async {
    final id = data.id.present ? data.id.value : _uuid.v4();
    final examId = data.examinationId.value;
    await db.transaction(() async {
      await (db.delete(db.visionResults)
            ..where((v) => v.examinationId.equals(examId)))
          .go();
      await db.into(db.visionResults).insert(data.copyWith(id: Value(id)));
    });
    await _promoteIfAnonymous(examId);
    if (syncService != null) {
      final item = await getVisionForExam(examId);
      if (item != null) {
        unawaited(syncService!.uploadVisionResult(item));
      }
    }
    return id;
  }

  Future<VisionResult?> getVisionForExam(String examinationId) {
    return (db.select(db.visionResults)
          ..where((v) => v.examinationId.equals(examinationId)))
        .getSingleOrNull();
  }

  // ---------------- CARS (autisme) ----------------

  /// Simpan hasil CARS; ganti hasil sebelumnya untuk pemeriksaan yang sama.
  Future<String> upsertCars(CarsResultsCompanion data) async {
    final id = data.id.present ? data.id.value : _uuid.v4();
    final examId = data.examinationId.value;
    await db.transaction(() async {
      await (db.delete(db.carsResults)
            ..where((c) => c.examinationId.equals(examId)))
          .go();
      await db.into(db.carsResults).insert(data.copyWith(id: Value(id)));
    });
    await _promoteIfAnonymous(examId);
    if (syncService != null) {
      final item = await getCarsForExam(examId);
      if (item != null) {
        unawaited(syncService!.uploadCarsResult(item));
      }
    }
    return id;
  }

  Future<CarsResult?> getCarsForExam(String examinationId) {
    return (db.select(db.carsResults)
          ..where((c) => c.examinationId.equals(examinationId)))
        .getSingleOrNull();
  }

  // ---------------- Denver II ----------------

  Future<String> saveDenverResult({
    required String examinationId,
    required String patientId,
    required double ageInMonths,
    required bool usedCorrectedAge,
    required int cautionsCount,
    required int delaysCount,
    required String globalResult,
    required String answersJson,
    String? behaviorNotes,
    String? fearNotes,
    String? environmentResponseNotes,
  }) async {
    final id = _uuid.v4();
    await db.transaction(() async {
      await (db.delete(db.denverResults)
            ..where((d) => d.examinationId.equals(examinationId)))
          .go();
      await db.into(db.denverResults).insert(DenverResultsCompanion(
            id: Value(id),
            examinationId: Value(examinationId),
            ageInMonths: Value(ageInMonths),
            usedCorrectedAge: Value(usedCorrectedAge),
            cautionsCount: Value(cautionsCount),
            delaysCount: Value(delaysCount),
            globalResult: Value(globalResult),
            answersJson: Value(answersJson),
            behaviorNotes: Value(behaviorNotes),
            fearNotes: Value(fearNotes),
            environmentResponseNotes: Value(environmentResponseNotes),
          ));
    });
    await _promoteIfAnonymous(examinationId);
    return id;
  }

  Future<DenverResult?> getDenverResultForExamination(String examinationId) {
    return (db.select(db.denverResults)
          ..where((d) => d.examinationId.equals(examinationId)))
        .getSingleOrNull();
  }

  Future<List<({Examination exam, DenverResult denver})>> denverHistory(
      String patientId) async {
    final query = db.select(db.examinations).join([
      innerJoin(db.denverResults,
          db.denverResults.examinationId.equalsExp(db.examinations.id))
    ])
      ..where(db.examinations.patientId.equals(patientId))
      ..orderBy([OrderingTerm(expression: db.examinations.examDate)]);
    final rows = await query.get();
    return rows
        .map((r) => (
              exam: r.readTable(db.examinations),
              denver: r.readTable(db.denverResults),
            ))
        .toList();
  }

  /// Semua hasil KPSP untuk seorang pasien (untuk grafik longitudinal),
  /// digabung dengan tanggal pemeriksaannya.
  Future<List<({Examination exam, KpspResult kpsp})>> kpspHistory(
      String patientId) async {
    final query = db.select(db.examinations).join([
      innerJoin(db.kpspResults,
          db.kpspResults.examinationId.equalsExp(db.examinations.id))
    ])
      ..where(db.examinations.patientId.equals(patientId))
      ..orderBy([OrderingTerm(expression: db.examinations.examDate)]);
    final rows = await query.get();
    return rows
        .map((r) => (
              exam: r.readTable(db.examinations),
              kpsp: r.readTable(db.kpspResults),
            ))
        .toList();
  }

  /// Semua pengukuran antropometri pasien lintas kunjungan, terurut tanggal,
  /// untuk grafik pertumbuhan longitudinal (Modul 14).
  Future<List<({Examination exam, GrowthMeasurement growth})>> growthHistory(
      String patientId) async {
    final query = db.select(db.examinations).join([
      innerJoin(db.growthMeasurements,
          db.growthMeasurements.examinationId.equalsExp(db.examinations.id))
    ])
      ..where(db.examinations.patientId.equals(patientId))
      ..orderBy([OrderingTerm(expression: db.examinations.examDate)]);
    final rows = await query.get();
    return rows
        .map((r) => (
              exam: r.readTable(db.examinations),
              growth: r.readTable(db.growthMeasurements),
            ))
        .toList();
  }

  /// Mengambil pengukuran growth pada tanggal tertentu untuk pasien tertentu (mis. data lahir).
  Future<GrowthMeasurement?> getGrowthForDate(String patientId, DateTime date) async {
    final exam = await (db.select(db.examinations)
          ..where((e) => e.patientId.equals(patientId) & e.examDate.equals(date)))
        .getSingleOrNull();
    if (exam != null) {
      return getGrowthForExam(exam.id);
    }
    return null;
  }

  /// Mempromosikan pasien anonim (Skrining Cepat) menjadi pasien terdaftar
  /// jika salah satu modul pemeriksaan telah diisi.
  Future<void> _promoteIfAnonymous(String examinationId) async {
    final exam = await getExamination(examinationId);
    if (exam == null) return;
    final patient = await getPatient(exam.patientId);
    if (patient != null && patient.medicalRecordNo == 'ANONIM') {
      final updated = patient.copyWith(
        medicalRecordNo: const Value(null),
        notes: patient.notes == 'Skrining Cepat' ? const Value(null) : Value(patient.notes),
      );
      await updatePatient(updated);
    }
  }
}
