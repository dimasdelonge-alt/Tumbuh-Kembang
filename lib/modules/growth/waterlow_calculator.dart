import 'cdc_growth_data.dart';
import 'nutrition_classifier.dart';

class WaterlowResult {
  final double idealWeightKg;
  final double percentage;
  final NutritionStatus status;
  final double heightAgeMonths;

  WaterlowResult({
    required this.idealWeightKg,
    required this.percentage,
    required this.status,
    required this.heightAgeMonths,
  });
}

class WaterlowCalculator {
  static WaterlowResult calculate({
    required double weightKg,
    required double heightCm,
    required String sex, // 'L' for Male, 'P' for Female
  }) {
    final statureTable = sex == 'L' ? CdcGrowthData.statureBoys : CdcGrowthData.statureGirls;
    final weightTable = sex == 'L' ? CdcGrowthData.weightBoys : CdcGrowthData.weightGirls;

    // 1. Determine Height Age (HA)
    double ha = 24.0;
    if (heightCm <= statureTable.first.value) {
      ha = statureTable.first.key;
    } else if (heightCm >= statureTable.last.value) {
      ha = statureTable.last.key;
    } else {
      // Find bracketing
      for (int i = 0; i < statureTable.length - 1; i++) {
        final p1 = statureTable[i];
        final p2 = statureTable[i + 1];
        if (heightCm >= p1.value && heightCm <= p2.value) {
          final t = (heightCm - p1.value) / (p2.value - p1.value);
          ha = p1.key + t * (p2.key - p1.key);
          break;
        }
      }
    }

    // 2. Determine Ideal Weight (W_ideal) at HA
    double idealWeight = weightTable.first.value;
    if (ha <= weightTable.first.key) {
      idealWeight = weightTable.first.value;
    } else if (ha >= weightTable.last.key) {
      idealWeight = weightTable.last.value;
    } else {
      // Find bracketing
      for (int i = 0; i < weightTable.length - 1; i++) {
        final p1 = weightTable[i];
        final p2 = weightTable[i + 1];
        if (ha >= p1.key && ha <= p2.key) {
          final t = (ha - p1.key) / (p2.key - p1.key);
          idealWeight = p1.value + t * (p2.value - p1.value);
          break;
        }
      }
    }

    // 3. Percentage
    final percentage = (weightKg / idealWeight) * 100.0;

    // 4. Classify Waterlow status
    // Obesitas: > 120%
    // Overweight: 110% - 120%
    // Normal: 90% - 110%
    // Gizi Kurang: 70% - 90%
    // Gizi Buruk: < 70%
    NutritionStatus status;
    if (percentage > 120.0) {
      status = NutritionStatus.obese;
    } else if (percentage >= 110.0) {
      status = NutritionStatus.overweight;
    } else if (percentage >= 90.0) {
      status = NutritionStatus.normalNutrition;
    } else if (percentage >= 70.0) {
      status = NutritionStatus.wasting;
    } else {
      status = NutritionStatus.severeWasting;
    }

    return WaterlowResult(
      idealWeightKg: idealWeight,
      percentage: percentage,
      status: status,
      heightAgeMonths: ha,
    );
  }
}
