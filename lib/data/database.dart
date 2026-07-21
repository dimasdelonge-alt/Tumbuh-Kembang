import 'package:drift/drift.dart';
// Drift v7 schema update for CDC & TPG
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

const _uuid = Uuid();

/// Tabel data pasien (Modul 1 PRD).
class Patients extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())(); // UUID
  TextColumn get name => text()();
  TextColumn get medicalRecordNo => text().nullable()();
  DateTimeColumn get birthDate => dateTime()();
  TextColumn get sex => text()(); // 'L' atau 'P'
  TextColumn get parentName => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();

  /// Usia gestasi saat lahir (minggu). Null bila aterm/tidak diketahui.
  IntColumn get gestationalWeeks => integer().nullable()();
  BoolColumn get isPremature =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get hasDownSyndrome =>
      boolean().withDefault(const Constant(false))();

  RealColumn get fatherHeightCm => real().nullable()();
  RealColumn get motherHeightCm => real().nullable()();

  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabel pemeriksaan/kunjungan (Modul 14 - riwayat longitudinal).
///
/// Setiap baris adalah satu kunjungan dengan tanggal tertentu. Hasil tiap
/// modul (antropometri, KPSP, dll) disimpan terkait examination ini.
class Examinations extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get patientId =>
      text().references(Patients, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get examDate => dateTime()();
  TextColumn get examinerNote => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Hasil pengukuran antropometri (Modul 3).
class GrowthMeasurements extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get examinationId =>
      text().references(Examinations, #id, onDelete: KeyAction.cascade)();

  RealColumn get weightKg => real().nullable()();
  RealColumn get heightCm => real().nullable()();
  RealColumn get headCircumferenceCm => real().nullable()();

  /// true bila tinggi diukur berbaring (length), false bila berdiri (height).
  BoolColumn get measuredLying =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Hasil skrining KPSP (Modul 4).
class KpspResults extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get examinationId =>
      text().references(Examinations, #id, onDelete: KeyAction.cascade)();

  /// Form usia yang dipakai (bulan): 3,6,9,...,72.
  IntColumn get formAgeMonths => integer()();

  /// Jumlah jawaban "Ya".
  IntColumn get yesCount => integer()();
  IntColumn get totalQuestions => integer()();

  /// Hasil: 'sesuai' | 'meragukan' | 'penyimpangan'.
  TextColumn get result => text()();

  /// JSON map jawaban per nomor pertanyaan (untuk audit & analisis domain).
  TextColumn get answersJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Hasil instrumen skrining generik (KMME, M-CHAT-R, GPPH, dll).
///
/// Satu tabel untuk semua instrumen berbasis kuesioner di luar KPSP, dibedakan
/// oleh [instrumentId].
class ScreeningResults extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get examinationId =>
      text().references(Examinations, #id, onDelete: KeyAction.cascade)();

  /// Kode instrumen, mis. 'kmme', 'mchat_r'.
  TextColumn get instrumentId => text()();

  /// Skor mentah (jumlah item berisiko).
  IntColumn get score => integer()();
  IntColumn get totalItems => integer()();

  /// Tingkat risiko: 0 = rendah, 1 = sedang, 2 = tinggi.
  IntColumn get riskLevel => integer()();

  /// JSON map jawaban per nomor item.
  TextColumn get answersJson => text()();

  /// Label varian instrumen (mis. band usia TDD "0-6 bulan"). Null bila tidak
  /// relevan. Disimpan agar laporan dapat menampilkan band yang benar.
  TextColumn get variantLabel => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Hasil Tes Daya Lihat (TDL) — pencatatan baris-E poster per mata.
class VisionResults extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get examinationId =>
      text().references(Examinations, #id, onDelete: KeyAction.cascade)();

  /// Baris terkecil yang terbaca (1..4). Null bila tidak terbaca sama sekali.
  IntColumn get rightEyeLine => integer().nullable()();
  IntColumn get leftEyeLine => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Hasil CARS (Childhood Autism Rating Scale) — 15 item, skala 1-4 (step 0,5).
class CarsResults extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get examinationId =>
      text().references(Examinations, #id, onDelete: KeyAction.cascade)();

  /// Skor total (15.0 - 60.0; bisa pecahan kelipatan 0,5).
  RealColumn get totalScore => real()();

  /// Kategori: 0 = non-autistik, 1 = ringan-sedang, 2 = berat.
  IntColumn get category => integer()();

  /// JSON map nilai per item (1..15 → double 1..4).
  TextColumn get answersJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Hasil Skrining Denver II.
class DenverResults extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get examinationId =>
      text().references(Examinations, #id, onDelete: KeyAction.cascade)();

  RealColumn get ageInMonths => real()();
  BoolColumn get usedCorrectedAge =>
      boolean().withDefault(const Constant(false))();
  IntColumn get cautionsCount => integer()();
  IntColumn get delaysCount => integer()();

  /// Hasil global: 'normal' | 'suspect' | 'untestable'.
  TextColumn get globalResult => text()();

  /// JSON map jawaban per itemId ('P', 'F', 'R', 'NO').
  TextColumn get answersJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Patients,
    Examinations,
    GrowthMeasurements,
    KpspResults,
    ScreeningResults,
    VisionResults,
    CarsResults,
    DenverResults,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v1 -> v2: tambah tabel instrumen skrining generik.
          if (from < 2) {
            await m.createTable(screeningResults);
          }
          // v2 -> v3: tambah kolom variantLabel pada ScreeningResults.
          if (from < 3) {
            await m.addColumn(
                screeningResults, screeningResults.variantLabel);
          }
          // v3 -> v4: tambah tabel hasil TDL.
          if (from < 4) {
            await m.createTable(visionResults);
          }
          // v4 -> v5: tambah tabel hasil CARS.
          if (from < 5) {
            await m.createTable(carsResults);
          }
          // v5 -> v6: tambah tabel hasil Denver II.
          if (from < 6) {
            await m.createTable(denverResults);
          }
          // v6 -> v7: tambah kolom fatherHeightCm & motherHeightCm pada Patients.
          if (from < 7) {
            await m.addColumn(patients, patients.fatherHeightCm);
            await m.addColumn(patients, patients.motherHeightCm);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'tumbang_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
