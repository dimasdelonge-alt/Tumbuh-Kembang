import 'dart:convert';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../data/repository.dart';
import '../modules/autism/cars.dart';
import '../modules/growth/growth_assessment.dart';
import '../modules/growth/nutrition_classifier.dart';
import '../modules/growth/zscore_calculator.dart';
import '../modules/growth/waterlow_calculator.dart';
import '../modules/kpsp/kpsp_model.dart';
import '../modules/screening/instrument.dart';
import '../modules/screening/registry.dart';
import '../modules/stimulation/stimulation.dart';
import '../modules/vision/tdl.dart';

/// Satu baris hasil antropometri untuk laporan.
class ReportGrowthRow {
  final GrowthIndicator indicator;
  final double value;
  final double zScore;
  final double percentile;
  final NutritionStatus status;
  ReportGrowthRow({
    required this.indicator,
    required this.value,
    required this.zScore,
    required this.percentile,
    required this.status,
  });
}

/// Ringkasan hasil KPSP untuk laporan.
class ReportKpsp {
  final int formAgeMonths;
  final int yesCount;
  final int total;
  final KpspResultCategory category;
  final String recommendation;
  final Map<KpspDomain, List<int>> failedByDomain;
  ReportKpsp({
    required this.formAgeMonths,
    required this.yesCount,
    required this.total,
    required this.category,
    required this.recommendation,
    required this.failedByDomain,
  });
}

/// Ringkasan hasil instrumen skrining generik (KMME, M-CHAT, dll) untuk laporan.
class ReportScreening {
  final String name;
  final int score;
  final int total;
  final String levelLabel;
  final int severity;
  final String interpretation;
  final String recommendation;

  /// Teks item yang menonjol (mis. GPPH nilai >= 2). Kosong bila tidak relevan.
  final List<String> flaggedItemTexts;

  ReportScreening({
    required this.name,
    required this.score,
    required this.total,
    required this.levelLabel,
    required this.severity,
    required this.interpretation,
    required this.recommendation,
    this.flaggedItemTexts = const [],
  });
}

/// Ringkasan hasil TDL (tes daya lihat) untuk laporan.
class ReportVision {
  final int? rightEyeLine;
  final int? leftEyeLine;
  final String rightStatus;
  final String leftStatus;
  final bool hasImpairment;
  final String interpretation;
  final String recommendation;
  ReportVision({
    required this.rightEyeLine,
    required this.leftEyeLine,
    required this.rightStatus,
    required this.leftStatus,
    required this.hasImpairment,
    required this.interpretation,
    required this.recommendation,
  });
}

/// Satu saran stimulasi (bidang + usia perkembangan + aktivitas) untuk laporan.
class ReportStimulationItem {
  final String domainLabel;
  final int developmentalAgeMonths;
  final String bandLabel;

  /// Pasangan judul aktivitas + cara melakukan.
  final List<({String title, String howTo})> activities;

  ReportStimulationItem({
    required this.domainLabel,
    required this.developmentalAgeMonths,
    required this.bandLabel,
    required this.activities,
  });
}

/// Ringkasan hasil CARS untuk laporan.
class ReportCars {
  final double totalScore;
  final String categoryLabel;
  final int severity;
  final String recommendation;
  ReportCars({
    required this.totalScore,
    required this.categoryLabel,
    required this.severity,
    required this.recommendation,
  });
}

/// Seluruh data yang dibutuhkan untuk merender satu laporan pemeriksaan.
class ExamReportData {
  final Patient patient;
  final DateTime examDate;
  final AgeResult age;
  final List<ReportGrowthRow> growthRows;
  final ReportKpsp? kpsp;
  final List<ReportScreening> screenings;
  final ReportVision? vision;
  final ReportCars? cars;
  final WaterlowResult? waterlow;

  /// Program stimulasi sesuai usia perkembangan (kosong bila belum ada KPSP).
  final List<ReportStimulationItem> stimulation;

  /// true bila usia di luar rentang WHO 0-5 tahun (indikator umur disembunyikan).
  final bool growthOutOfRange;

  ExamReportData({
    required this.patient,
    required this.examDate,
    required this.age,
    required this.growthRows,
    required this.kpsp,
    required this.screenings,
    required this.vision,
    required this.cars,
    required this.stimulation,
    required this.growthOutOfRange,
    required this.waterlow,
  });
}

/// Menyusun [ExamReportData] dari database untuk satu pemeriksaan.
class ReportBuilder {
  final AppRepository repo;
  ReportBuilder(this.repo);

  Future<ExamReportData> build({
    required Patient patient,
    required Examination exam,
  }) async {
    final rows = <ReportGrowthRow>[];

    final g = await repo.getGrowthForExam(exam.id);
    final assessment = GrowthAssessment.compute(
      birthDate: patient.birthDate,
      examDate: exam.examDate,
      gestationalWeeks: patient.gestationalWeeks,
      sex: patient.sex,
      weightKg: g?.weightKg,
      heightCm: g?.heightCm,
      headCircumferenceCm: g?.headCircumferenceCm,
      measuredLying: g?.measuredLying ?? false,
    );
    final age = assessment.age;
    for (final r in assessment.results) {
      rows.add(ReportGrowthRow(
        indicator: r.indicator,
        value: r.value,
        zScore: r.z.zScore,
        percentile: r.z.percentile,
        status: r.status,
      ));
    }

    ReportKpsp? kpsp;
    final k = await repo.getKpspForExam(exam.id);
    if (k != null) {
      final form = KpspData.form(k.formAgeMonths);
      final category = KpspResultCategory.fromCode(k.result);
      // Rekonstruksi kegagalan per domain dari jawaban tersimpan + form.
      final failed = <KpspDomain, List<int>>{};
      if (form != null) {
        Map<String, dynamic> ans;
        try {
          ans = jsonDecode(k.answersJson) as Map<String, dynamic>;
        } catch (_) {
          ans = const {};
        }
        for (final q in form.questions) {
          final v = ans['${q.number}'];
          if (v == false) {
            failed.putIfAbsent(q.domain, () => []).add(q.number);
          }
        }
      }
      kpsp = ReportKpsp(
        formAgeMonths: k.formAgeMonths,
        yesCount: k.yesCount,
        total: k.totalQuestions,
        category: category,
        recommendation: _kpspRecommendation(category),
        failedByDomain: failed,
      );
    }

    // Instrumen skrining generik (KMME, M-CHAT, dll).
    final screenings = <ReportScreening>[];
    final screeningRows = await repo.getScreeningsForExam(exam.id);
    for (final s in screeningRows) {
      final inst = ScreeningRegistry.byId(s.instrumentId);
      if (inst == null) continue;
      // Untuk instrumen ber-rater (mis. SPPAHI), variantLabel menyimpan penilai
      // dan menentukan cut-off; selain itu band biasa.
      final rater = inst.hasRaterSelection ? s.variantLabel : null;
      final band = ScreeningScorer.bandForRater(inst, s.score, rater);
      // Nama dasar band-agnostik + varian tersimpan (band usia TDD / penilai).
      final name = s.variantLabel == null || s.variantLabel!.isEmpty
          ? inst.name
          : '${inst.name} — ${s.variantLabel}';

      // Untuk instrumen Likert (mis. GPPH), rekonstruksi item menonjol (>=2).
      final flaggedTexts = <String>[];
      if (inst.responseType == ResponseType.likert4) {
        Map<String, dynamic> ans;
        try {
          ans = jsonDecode(s.answersJson) as Map<String, dynamic>;
        } catch (_) {
          ans = const {};
        }
        for (final item in inst.items) {
          final raw = ans['${item.number}'];
          final val = raw is num ? raw.toInt() : null;
          if (val != null && val >= 2) {
            flaggedTexts.add('${item.text} (nilai $val)');
          }
        }
      }

      screenings.add(ReportScreening(
        name: name,
        score: s.score,
        total: s.totalItems,
        levelLabel: band.level.label,
        severity: band.level.severity,
        interpretation: band.interpretation,
        recommendation: band.recommendation,
        flaggedItemTexts: flaggedTexts,
      ));
    }

    // TDL (tes daya lihat).
    ReportVision? vision;
    final v = await repo.getVisionForExam(exam.id);
    if (v != null) {
      final tdl = TdlResult(
        rightEyeLine: v.rightEyeLine,
        leftEyeLine: v.leftEyeLine,
      );
      vision = ReportVision(
        rightEyeLine: v.rightEyeLine,
        leftEyeLine: v.leftEyeLine,
        rightStatus: tdl.rightStatus.label,
        leftStatus: tdl.leftStatus.label,
        hasImpairment: tdl.hasImpairment,
        interpretation: tdl.interpretation,
        recommendation: tdl.recommendation,
      );
    }

    // CARS (autisme).
    ReportCars? cars;
    final c = await repo.getCarsForExam(exam.id);
    if (c != null) {
      final cat = CarsScorer.categorize(c.totalScore);
      cars = ReportCars(
        totalScore: c.totalScore,
        categoryLabel: cat.label,
        severity: cat.severity,
        recommendation:
            CarsInterpretation(totalScore: c.totalScore, category: cat)
                .recommendation,
      );
    }

    // Program stimulasi berbasis hasil KPSP pemeriksaan ini.
    // Jika tidak ada KPSP, default ke kelompok usia saat pemeriksaan.
    final stimulation = <ReportStimulationItem>[];
    if (k != null) {
      final form = KpspData.form(k.formAgeMonths);
      final Map<int, bool> answers = {};
      if (form != null) {
        try {
          final m = jsonDecode(k.answersJson) as Map<String, dynamic>;
          m.forEach((key, val) {
            final n = int.tryParse(key);
            if (n != null && val is bool) answers[n] = val;
          });
        } catch (_) {}
      }

      if (form != null && answers.isNotEmpty) {
        final suggestions = StimulationMatcher.forKpspResult(
          form: form,
          answers: answers,
        );
        for (final s in suggestions) {
          stimulation.add(ReportStimulationItem(
            domainLabel: s.domain.label,
            developmentalAgeMonths: s.developmentalAgeMonths,
            bandLabel: s.band.label,
            activities: s.activities
                .map((a) => (title: a.title, howTo: a.howTo))
                .toList(),
          ));
        }
      }
    }

    if (stimulation.isEmpty) {
      final ageMonths = age.correctionApplied ? age.correctedMonths : age.chronologicalMonths;
      final domainAges = <KpspDomain, int?>{
        for (final d in KpspDomain.values) d: ageMonths,
      };
      for (final s in StimulationMatcher.forDomains(domainAges)) {
        stimulation.add(ReportStimulationItem(
          domainLabel: s.domain.label,
          developmentalAgeMonths: s.developmentalAgeMonths,
          bandLabel: s.band.label,
          activities: s.activities
              .map((a) => (title: a.title, howTo: a.howTo))
              .toList(),
        ));
      }
    }

    return ExamReportData(
      patient: patient,
      examDate: exam.examDate,
      age: age,
      growthRows: rows,
      kpsp: kpsp,
      screenings: screenings,
      vision: vision,
      cars: cars,
      stimulation: stimulation,
      growthOutOfRange: age.chronologicalMonths > 60,
      waterlow: assessment.waterlow,
    );
  }

  static String _kpspRecommendation(KpspResultCategory c) {
    switch (c) {
      case KpspResultCategory.sesuai:
        return 'Perkembangan sesuai usia. Lanjutkan stimulasi & KPSP rutin.';
      case KpspResultCategory.meragukan:
        return 'Stimulasi lebih intensif 2 minggu, lalu ulangi KPSP. '
            'Cari kemungkinan penyakit penyerta.';
      case KpspResultCategory.penyimpangan:
        return 'Rujuk untuk pemeriksaan lengkap (fisik, neurologis, penunjang).';
    }
  }
}
