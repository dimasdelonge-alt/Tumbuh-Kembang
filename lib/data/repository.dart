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
          ..orderBy([(p) => OrderingTerm(expression: p.name)]))
        .watch();
  }

  Future<List<Patient>> searchPatients(String query) {
    final q = '%$query%';
    return (db.select(db.patients)
          ..where((p) => p.name.like(q) | p.medicalRecordNo.like(q))
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

  Future<void> deletePatient(String id) async {
    await (db.delete(db.patients)..where((p) => p.id.equals(id))).go();
    if (syncService != null) {
      unawaited(syncService!.deletePatientRemote(id));
    }
  }

  // ---------------- Pemeriksaan ----------------

  Stream<List<Examination>> watchExaminations(String patientId) {
    return (db.select(db.examinations)
          ..where((e) => e.patientId.equals(patientId))
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

  Future<void> deleteExamination(String id) async {
    await (db.delete(db.examinations)..where((e) => e.id.equals(id))).go();
    if (syncService != null) {
      unawaited(syncService!.deleteExaminationRemote(id));
    }
  }

  Future<Examination?> getExamination(String id) {
    return (db.select(db.examinations)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
  }

  // ---------------- Antropometri ----------------

  Future<String> upsertGrowth(GrowthMeasurementsCompanion data) async {
    final id = data.id.present ? data.id.value : _uuid.v4();
    await db
        .into(db.growthMeasurements)
        .insertOnConflictUpdate(data.copyWith(id: Value(id)));
    if (syncService != null) {
      final item = await getGrowthForExam(data.examinationId.value);
      if (item != null) {
        unawaited(syncService!.uploadGrowthMeasurement(item));
      }
    }
    return id;
  }

  Future<GrowthMeasurement?> getGrowthForExam(String examinationId) {
    return (db.select(db.growthMeasurements)
          ..where((g) => g.examinationId.equals(examinationId)))
        .getSingleOrNull();
  }

  // ---------------- KPSP ----------------

  Future<String> insertKpsp(KpspResultsCompanion data) async {
    final id = data.id.present ? data.id.value : _uuid.v4();
    await db.into(db.kpspResults).insert(data.copyWith(id: Value(id)));
    if (syncService != null) {
      final item = await getKpspForExam(data.examinationId.value);
      if (item != null) {
        unawaited(syncService!.uploadKpspResult(item));
      }
    }
    return id;
  }

  Future<KpspResult?> getKpspForExam(String examinationId) {
    return (db.select(db.kpspResults)
          ..where((k) => k.examinationId.equals(examinationId)))
        .getSingleOrNull();
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
}
