import '../../core/age_calculator.dart';
import '../../data/database.dart';
import 'nutrition_classifier.dart';
import 'who_growth_data.dart';
import 'zscore_calculator.dart';
import 'waterlow_calculator.dart';

/// Satu hasil indikator pertumbuhan: nilai terukur + Z-score + status.
class GrowthIndicatorResult {
  final GrowthIndicator indicator;

  /// Nilai pengukuran asli (kg / cm / IMT).
  final double value;

  final ZScoreResult z;
  final NutritionStatus status;

  /// Posisi sumbu-x kurva: hari (untuk *-menurut-umur) atau cm (BB/TB).
  final double chartX;

  GrowthIndicatorResult({
    required this.indicator,
    required this.value,
    required this.z,
    required this.status,
    required this.chartX,
  });
}

/// Penilaian pertumbuhan satu pengukuran: SATU sumber kebenaran untuk seluruh
/// pipeline usia → ageDays → Z-score → status gizi.
///
/// Dipakai bersama oleh layar input antropometri, tren longitudinal, dan
/// laporan PDF agar logika klinis tidak menyimpang antar tempat.
class GrowthAssessment {
  final AgeResult age;
  final List<GrowthIndicatorResult> results;

  /// true bila usia kronologis melewati rentang WHO 0-5 tahun (60 bulan).
  final bool outOfRange;

  /// Detail perhitungan Waterlow untuk anak > 5 tahun.
  final WaterlowResult? waterlow;

  GrowthAssessment({
    required this.age,
    required this.results,
    required this.outOfRange,
    this.waterlow,
  });

  GrowthIndicatorResult? byIndicator(GrowthIndicator indicator) {
    for (final r in results) {
      if (r.indicator == indicator) return r;
    }
    return null;
  }

  /// Usia (hari) yang dipakai untuk Z-score: koreksi bila berlaku.
  static double ageDaysFor(AgeResult age) =>
      (age.correctionApplied ? age.correctedDays : age.chronologicalDays)
          .toDouble();

  /// Hitung penilaian dari nilai mentah pengukuran.
  static GrowthAssessment compute({
    required DateTime birthDate,
    required DateTime examDate,
    int? gestationalWeeks,
    required String sex,
    double? weightKg,
    double? heightCm,
    double? headCircumferenceCm,
    required bool measuredLying,
  }) {
    final age = AgeCalculator.calculate(
      birthDate: birthDate,
      examDate: examDate,
      gestationalWeeks: gestationalWeeks,
    );
    final ageDays = ageDaysFor(age);
    final who = WhoGrowthData.instance;
    final results = <GrowthIndicatorResult>[];
    WaterlowResult? waterlowResult;

    void addAge(GrowthIndicator ind, double? value) {
      if (value == null) return;
      final z = who.zscoreForAge(
          indicator: ind, sex: sex, value: value, ageDays: ageDays);
      if (z == null) return;
      results.add(GrowthIndicatorResult(
        indicator: ind,
        value: value,
        z: z,
        status: NutritionClassifier.classify(ind, z.zScore,
            ageMonths: age.chronologicalMonths),
        chartX: ageDays,
      ));
    }

    addAge(GrowthIndicator.weightForAge, weightKg);
    addAge(GrowthIndicator.lengthHeightForAge, heightCm);

    if (weightKg != null && heightCm != null) {
      if (age.chronologicalMonths > 60) {
        // Hitung status gizi BB/TB menggunakan Waterlow CDC 2000
        waterlowResult = WaterlowCalculator.calculate(
          weightKg: weightKg,
          heightCm: heightCm,
          sex: sex,
        );
        results.add(GrowthIndicatorResult(
          indicator: GrowthIndicator.weightForLengthHeight,
          value: weightKg,
          z: ZScoreResult(
            indicator: GrowthIndicator.weightForLengthHeight,
            zScore: waterlowResult.percentage,
            percentile: 50.0,
            median: waterlowResult.idealWeightKg,
          ),
          status: waterlowResult.status,
          chartX: heightCm,
        ));
      } else {
        final z = who.zscoreWeightForLength(
          sex: sex,
          weightKg: weightKg,
          lengthHeightCm: heightCm,
          measuredLying: measuredLying,
        );
        if (z != null) {
          results.add(GrowthIndicatorResult(
            indicator: GrowthIndicator.weightForLengthHeight,
            value: weightKg,
            z: z,
            status: NutritionClassifier.classify(
                GrowthIndicator.weightForLengthHeight, z.zScore,
                ageMonths: age.chronologicalMonths),
            chartX: heightCm,
          ));
        }
      }

      final bmi = weightKg / ((heightCm / 100) * (heightCm / 100));
      addAge(GrowthIndicator.bmiForAge, bmi);
    }

    addAge(GrowthIndicator.headCircumferenceForAge, headCircumferenceCm);

    return GrowthAssessment(
      age: age,
      results: results,
      outOfRange: age.chronologicalMonths > 60,
      waterlow: waterlowResult,
    );
  }

  /// Versi praktis yang menerima baris [GrowthMeasurement] dari DB.
  static GrowthAssessment fromMeasurement({
    required DateTime birthDate,
    required DateTime examDate,
    int? gestationalWeeks,
    required String sex,
    required GrowthMeasurement m,
  }) {
    return compute(
      birthDate: birthDate,
      examDate: examDate,
      gestationalWeeks: gestationalWeeks,
      sex: sex,
      weightKg: m.weightKg,
      heightCm: m.heightCm,
      headCircumferenceCm: m.headCircumferenceCm,
      measuredLying: m.measuredLying,
    );
  }
}
