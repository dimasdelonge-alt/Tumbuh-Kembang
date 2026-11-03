import 'package:drift/drift.dart' as d;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/data/database.dart';
import 'package:tumbang/data/repository.dart';

/// Regresi bug "GPPH dobel di PDF": satu pemeriksaan tidak boleh memiliki
/// dua hasil instrumen yang sama (kunci logis sama, ID berbeda), dari jalur
/// mana pun duplikat itu masuk (input ulang, sinkronisasi, backup).
void main() {
  late AppDatabase db;
  late AppRepository repo;
  late String examId;

  ScreeningResultsCompanion gpph({required int score, String? id}) {
    return ScreeningResultsCompanion(
      id: id != null ? d.Value(id) : const d.Value.absent(),
      examinationId: d.Value(examId),
      instrumentId: const d.Value('gpph'),
      score: d.Value(score),
      totalItems: const d.Value(10),
      riskLevel: d.Value(score >= 13 ? 2 : 0),
      answersJson: const d.Value('{"1":1}'),
      variantLabel: const d.Value(null),
    );
  }

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = AppRepository(db);
    final patientId = await repo.insertPatient(PatientsCompanion.insert(
      name: 'Anak Uji',
      birthDate: DateTime(2021, 1, 1),
      sex: 'L',
    ));
    examId = await repo.insertExamination(ExaminationsCompanion.insert(
      patientId: patientId,
      examDate: DateTime(2026, 1, 10, 9, 30),
    ));
  });

  tearDown(() async {
    await db.close();
  });

  test('simpan GPPH dua kali dalam satu pemeriksaan: tetap satu, skor terakhir, ID sama', () async {
    final id1 = await repo.upsertScreening(gpph(score: 5));
    final id2 = await repo.upsertScreening(gpph(score: 20));

    expect(id2, equals(id1), reason: 'ID baris harus dipakai ulang agar dokumen sync tidak beranak');
    final rows = await repo.getScreeningsForExam(examId);
    expect(rows.length, equals(1));
    expect(rows.single.score, equals(20));
  });

  test('duplikat warisan sync (ID berbeda, isi sama persis) tidak tampil ganda', () async {
    await repo.upsertScreening(gpph(score: 9));
    // Simulasi dokumen duplikat dari perangkat lain yang masuk lewat sync.
    await db.into(db.screeningResults).insert(gpph(score: 9, id: 'dokumen-dari-perangkat-lain'));

    final raw = await (db.select(db.screeningResults)
          ..where((s) => s.examinationId.equals(examId)))
        .get();
    expect(raw.length, equals(2), reason: 'premis: duplikat fisik memang ada di DB');

    // Lapisan baca harus men-dedup sehingga PDF/UI hanya menampilkan satu.
    final rows = await repo.getScreeningsForExam(examId);
    expect(rows.where((r) => r.instrumentId == 'gpph').length, equals(1));

    // getScreening tidak boleh melempar StateError akibat duplikat.
    final single = await repo.getScreening(examId, 'gpph');
    expect(single, isNotNull);
    expect(single!.score, equals(9));
  });

  test('cleanupDuplicateResults menghapus duplikat fisik, mempertahankan varian berbeda', () async {
    await repo.upsertScreening(gpph(score: 9));
    await db.into(db.screeningResults).insert(gpph(score: 9, id: 'duplikat-1'));
    await db.into(db.screeningResults).insert(gpph(score: 9, id: 'duplikat-2'));
    // Varian berbeda (mis. M-CHAT Follow-Up / SPPAHI penilai lain) bukan duplikat.
    await db.into(db.screeningResults).insert(ScreeningResultsCompanion(
          id: const d.Value('varian-lain'),
          examinationId: d.Value(examId),
          instrumentId: const d.Value('gpph'),
          score: const d.Value(3),
          totalItems: const d.Value(10),
          riskLevel: const d.Value(0),
          answersJson: const d.Value('{}'),
          variantLabel: const d.Value('Penilai Lain'),
        ));

    final removed = await repo.cleanupDuplicateResults();
    expect(removed, equals(2));

    final raw = await db.select(db.screeningResults).get();
    expect(raw.length, equals(2)); // 1 gpph utama + 1 varian lain
    final rows = await repo.getScreeningsForExam(examId);
    expect(rows.length, equals(2));
  });

  test('SPPAHI beda penilai tidak saling menimpa (keyByVariant)', () async {
    ScreeningResultsCompanion sppahi(String rater, int score) {
      return ScreeningResultsCompanion.insert(
        examinationId: examId,
        instrumentId: 'sppahi',
        score: score,
        totalItems: 35,
        riskLevel: 0,
        answersJson: '{}',
        variantLabel: d.Value(rater),
      );
    }

    await repo.upsertScreening(sppahi('Dokter', 10), keyByVariant: true);
    await repo.upsertScreening(sppahi('Orang Tua', 12), keyByVariant: true);
    await repo.upsertScreening(sppahi('Dokter', 15), keyByVariant: true);

    final rows = await repo.getScreeningsForExam(examId);
    final raters = rows.map((r) => r.variantLabel).toSet();
    expect(raters, equals({'Dokter', 'Orang Tua'}));
    expect(rows.firstWhere((r) => r.variantLabel == 'Dokter').score, equals(15));
  });

  test('findExaminationOnDate menemukan pemeriksaan di tanggal sama (jam berbeda)', () async {
    final found = await repo.findExaminationOnDate(
        (await repo.getExamination(examId))!.patientId,
        DateTime(2026, 1, 10, 18, 45));
    expect(found?.id, equals(examId));

    final notFound = await repo.findExaminationOnDate(
        (await repo.getExamination(examId))!.patientId,
        DateTime(2026, 1, 11));
    expect(notFound, isNull);
  });
}
