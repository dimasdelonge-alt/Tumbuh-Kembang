import 'zscore_calculator.dart';

/// Kategori status hasil interpretasi Z-score.
enum NutritionStatus {
  severeUnderweight('Berat badan sangat kurang', true),
  underweight('Berat badan kurang', true),
  normalWeight('Berat badan normal', false),
  riskOverweight('Risiko berat badan lebih', true),

  severeStunting('Sangat pendek (severe stunting)', true),
  stunting('Pendek (stunting)', true),
  normalHeight('Tinggi badan normal', false),
  tall('Tinggi', false),

  severeWasting('Gizi buruk (severe wasting)', true),
  wasting('Gizi kurang (wasting)', true),
  normalNutrition('Gizi baik (normal)', false),
  possibleRiskOverweight('Berisiko gizi lebih', true),
  overweight('Gizi lebih (overweight)', true),
  obese('Obesitas', true),

  microcephaly('Mikrosefali', true),
  normalHead('Lingkar kepala normal', false),
  macrocephaly('Makrosefali', true),

  undetermined('Tidak dapat ditentukan', false);

  final String label;

  /// true bila status ini perlu perhatian/red flag.
  final bool isAlert;

  const NutritionStatus(this.label, this.isAlert);
}

/// Klasifikasi status gizi dari Z-score sesuai ambang WHO / Permenkes No. 2
/// Tahun 2020 tentang Standar Antropometri Anak.
class NutritionClassifier {
  static NutritionStatus classify(GrowthIndicator indicator, double z,
      {int? ageMonths}) {
    switch (indicator) {
      case GrowthIndicator.weightForAge:
        // BB/U: -3, -2, +1 (ambang risiko lebih)
        if (z < -3) return NutritionStatus.severeUnderweight;
        if (z < -2) return NutritionStatus.underweight;
        if (z > 1) return NutritionStatus.riskOverweight;
        return NutritionStatus.normalWeight;

      case GrowthIndicator.lengthHeightForAge:
        // TB/U: -3, -2, +3
        if (z < -3) return NutritionStatus.severeStunting;
        if (z < -2) return NutritionStatus.stunting;
        if (z > 3) return NutritionStatus.tall;
        return NutritionStatus.normalHeight;

      case GrowthIndicator.weightForLengthHeight:
      case GrowthIndicator.bmiForAge:
        // IMT/U usia > 5 tahun memakai ambang WHO 2007 (5-19 thn):
        // thinness <-2, severe thinness <-3, overweight >+1, obesitas >+2.
        if (indicator == GrowthIndicator.bmiForAge &&
            ageMonths != null &&
            ageMonths > 60) {
          if (z < -3) return NutritionStatus.severeWasting;
          if (z < -2) return NutritionStatus.wasting;
          if (z > 2) return NutritionStatus.obese;
          if (z > 1) return NutritionStatus.overweight;
          return NutritionStatus.normalNutrition;
        }
        // BB/TB & IMT/U 0-5 thn (WHO 2006): -3, -2, +1, +2, +3
        if (z < -3) return NutritionStatus.severeWasting;
        if (z < -2) return NutritionStatus.wasting;
        if (z > 3) return NutritionStatus.obese;
        if (z > 2) return NutritionStatus.overweight;
        if (z > 1) return NutritionStatus.possibleRiskOverweight;
        return NutritionStatus.normalNutrition;

      case GrowthIndicator.headCircumferenceForAge:
        // LK/U: -2, +2
        if (z < -2) return NutritionStatus.microcephaly;
        if (z > 2) return NutritionStatus.macrocephaly;
        return NutritionStatus.normalHead;
    }
  }

  /// Ambang batas garis kurva yang relevan untuk ditampilkan per indikator.
  static List<double> referenceLines(GrowthIndicator indicator) {
    switch (indicator) {
      case GrowthIndicator.weightForAge:
        return const [-3, -2, 0, 1];
      case GrowthIndicator.lengthHeightForAge:
        return const [-3, -2, 0, 2, 3];
      case GrowthIndicator.weightForLengthHeight:
      case GrowthIndicator.bmiForAge:
        return const [-3, -2, 0, 1, 2, 3];
      case GrowthIndicator.headCircumferenceForAge:
        return const [-3, -2, 0, 2, 3];
    }
  }
}
