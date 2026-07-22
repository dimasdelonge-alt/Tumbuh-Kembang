import 'dart:math';

/// Alias untuk kompatibilitas backward
typedef NutritionCalculator = PediatricNutritionCalculator;
typedef NutritionRequirement = NutritionCalculationResult;

class AkgEntry {
  final String label;
  const AkgEntry(this.label);
}

class MpasiGuidance {
  final String label;
  final String texture;
  final String frequency;
  final String portion;
  final String notes;
  final List<String> menuExamples;

  const MpasiGuidance({
    required this.label,
    required this.texture,
    required this.frequency,
    required this.portion,
    required this.notes,
    required this.menuExamples,
  });
}

class SupplementInfo {
  final String dose;
  final String notes;
  const SupplementInfo({required this.dose, required this.notes});
}

/// Kelas hasil kalkulasi gizi klinis pediatrik.
class NutritionCalculationResult {
  final double weightKg;
  final double heightCm;
  final double ageMonths;
  final String sex;
  final double? idealWeightKg;

  /// Basal Metabolic Rate (BMR) / EER WHO Equation (kcal/hari)
  final double eerKcal;

  /// Kebutuhan Protein Harian RDA (g/hari)
  final double proteinGrams;
  final double proteinRdaPerKg;

  /// Kebutuhan Cairan Rumus Holliday-Segar (mL/hari)
  final double fluidMl;

  /// Target Kalori & Protein Catch-Up Growth (bila diindikasikan gagal tumbuh / stunting / wasting)
  final double? catchUpEnergyKcal;
  final double? catchUpProteinGrams;
  final bool needsCatchUp;

  const NutritionCalculationResult({
    required this.weightKg,
    required this.heightCm,
    required this.ageMonths,
    required this.sex,
    this.idealWeightKg,
    required this.eerKcal,
    required this.proteinGrams,
    required this.proteinRdaPerKg,
    required this.fluidMl,
    this.catchUpEnergyKcal,
    this.catchUpProteinGrams,
    required this.needsCatchUp,
  });

  // --- Getters untuk kompatibilitas UI & ReportBuilder ---
  bool get needsIntervention => needsCatchUp;
  String get energyLabel => '${eerKcal.round()} kcal/hari';
  String get proteinLabel => '${proteinGrams.toStringAsFixed(1)} g/hari';
  String get fluidLabel => '${fluidMl.round()} mL/hari';
  String get idealWeightLabel => '${(idealWeightKg ?? weightKg).toStringAsFixed(1)} kg';
  String get interventionAdvice =>
      'Indikasi Gagal Tumbuh / Stunting: Target Catch-Up Growth ${catchUpEnergyKcal?.round() ?? eerKcal.round()} kcal/hari.';

  double get heightAgeMonths => ageMonths;
  double get targetEnergyKcal => catchUpEnergyKcal ?? eerKcal;
  double get targetProteinGram => catchUpProteinGrams ?? proteinGrams;
  double get dailyFluidMl => fluidMl;

  AkgEntry get akgEntry {
    if (ageMonths < 6) return const AkgEntry('0-5 Bulan');
    if (ageMonths < 12) return const AkgEntry('6-11 Bulan');
    if (ageMonths < 36) return const AkgEntry('1-3 Tahun');
    if (ageMonths < 72) return const AkgEntry('4-6 Tahun');
    return const AkgEntry('Anak Usia Sekolah');
  }

  MpasiGuidance get mpasiGuidance {
    if (ageMonths < 6) {
      return const MpasiGuidance(
        label: 'ASI Eksklusif',
        texture: 'Cair (ASI / Formula)',
        frequency: '8-12 kali per hari (on demand)',
        portion: 'Sesuai kehendak bayi',
        notes: 'ASI Eksklusif 0-6 Bulan tanpa makanan/minuman tambahan lain.',
        menuExamples: ['ASI Eksklusif', 'Formula Bayi (bila ada indikasi medis)'],
      );
    } else if (ageMonths < 9) {
      return const MpasiGuidance(
        label: 'MPASI Usia 6-8 Bulan',
        texture: 'Lumat / Saring (Smooth Puree)',
        frequency: '2-3 kali makan utama + 1-2 kali selingan',
        portion: '2-3 sendok makan bertahap hingga 1/2 mangkuk (125 mL)',
        notes: 'Utamakan protein hewani (telur, hati ayam, daging) & tambahkan minyak/santan.',
        menuExamples: ['Bubur Lumat Singkong Daging Sapi', 'Bubur Hati Ayam & Telur Lemak Manis'],
      );
    } else if (ageMonths < 12) {
      return const MpasiGuidance(
        label: 'MPASI Usia 9-11 Bulan',
        texture: 'Cincang Halus / Lembik / Finger Food',
        frequency: '3-4 kali makan utama + 1-2 kali selingan',
        portion: '1/2 hingga 3/4 mangkuk (125 - 175 mL)',
        notes: 'Tingkatkan tekstur cincang lunak. Berikan finger food lunak untuk stimulasi motorik.',
        menuExamples: ['Nasi Tim Ayam Ikan Kembung', 'Nasi Tim Bola Daging Telur Puyuh'],
      );
    } else {
      return const MpasiGuidance(
        label: 'Makanan Keluarga (12+ Bulan)',
        texture: 'Makanan Keluarga Lunak',
        frequency: '3-4 kali makan utama + 2 kali selingan',
        portion: '3/4 hingga 1 mangkuk penuh (200 - 250 mL)',
        notes: 'Makanan keluarga bergizi seimbang kaya protein hewani.',
        menuExamples: ['Sup Bola Daging Ayam & Hati Sapi', 'Nasi Lengkap Lauk Hewani & Sayur'],
      );
    }
  }

  SupplementInfo get ironSupp {
    if (ageMonths >= 4 && ageMonths <= 24) {
      return const SupplementInfo(
        dose: '1-2 mg/kgBB/hari',
        notes: 'Suplementasi zat besi profilaksis rutin untuk pencegahan anemia defisiensi besi.',
      );
    }
    return const SupplementInfo(
      dose: 'Bila ada indikasi anemia',
      notes: 'Sesuai petunjuk dokter.',
    );
  }

  SupplementInfo get vitDSupp => const SupplementInfo(
        dose: '400 IU/hari',
        notes: 'Rekomendasi rutin harian untuk semua bayi dan anak.',
      );
}

/// Kalkulator Gizi Klinik Pediatrik berbasis algoritma
/// AAP / Pediatric Nutrition Handbook: An Algorithmic Approach (2011).
class PediatricNutritionCalculator {
  /// Menghitung EER / BMR berbasis Persamaan WHO per kelompok usia & jenis kelamin.
  static double calculateEerWho({
    required double weightKg,
    required double ageYears,
    required String sex,
  }) {
    final isMale = sex.toUpperCase() == 'L';

    if (ageYears < 3.0) {
      return isMale
          ? (60.9 * weightKg) - 54.0
          : (61.0 * weightKg) - 51.0;
    } else if (ageYears < 10.0) {
      return isMale
          ? (22.7 * weightKg) + 495.0
          : (22.5 * weightKg) + 499.0;
    } else {
      return isMale
          ? (17.5 * weightKg) + 651.0
          : (12.2 * weightKg) + 746.0;
    }
  }

  /// Menghitung Protein RDA per kg berat badan.
  static double getProteinRdaPerKg(double ageMonths) {
    if (ageMonths < 6.0) {
      return 1.52;
    } else if (ageMonths < 12.0) {
      return 1.20;
    } else if (ageMonths < 48.0) { // 1-3 thn (12-47 bln)
      return 1.05;
    } else if (ageMonths < 168.0) { // 4-13 thn
      return 0.95;
    } else { // 14-18 thn
      return 0.85;
    }
  }

  /// Menghitung Kebutuhan Cairan Pemeliharaan (Holliday-Segar).
  static double calculateHollidaySegarFluid(double weightKg) {
    if (weightKg <= 10.0) {
      return weightKg * 100.0;
    } else if (weightKg <= 20.0) {
      return 1000.0 + ((weightKg - 10.0) * 50.0);
    } else if (weightKg <= 40.0) {
      return 1500.0 + ((weightKg - 20.0) * 20.0);
    } else {
      return 1500.0 + ((weightKg - 20.0) * 20.0);
    }
  }

  /// Menghitung Kalori Catch-Up Growth untuk Anak Gagal Tumbuh / Stunting / Wasting.
  static double calculateCatchUpEnergy({
    required double idealWeightKg,
    required double actualWeightKg,
    required double ageYears,
    required String sex,
  }) {
    if (actualWeightKg <= 0) return 0;
    final idealEer = calculateEerWho(weightKg: idealWeightKg, ageYears: ageYears, sex: sex);
    final catchUpVal = (idealEer * idealWeightKg) / actualWeightKg;
    return max(idealEer * 1.2, catchUpVal);
  }

  /// Kalkulasi lengkap nutrisi klinis.
  static NutritionCalculationResult calculate({
    required double weightKg,
    required double heightCm,
    required num ageMonths,
    required String sex,
    double? idealWeightKg,
    bool isMalnourished = false,
    dynamic whoNutritionStatus,
  }) {
    final months = ageMonths.toDouble();
    final ageYears = months / 12.0;
    final eer = calculateEerWho(weightKg: weightKg, ageYears: ageYears, sex: sex);
    final proteinRda = getProteinRdaPerKg(months);
    final proteinTotal = weightKg * proteinRda;
    final fluid = calculateHollidaySegarFluid(weightKg);

    double? catchUpKcal;
    double? catchUpProtein;

    if (isMalnourished && idealWeightKg != null && idealWeightKg > weightKg) {
      catchUpKcal = calculateCatchUpEnergy(
        idealWeightKg: idealWeightKg,
        actualWeightKg: weightKg,
        ageYears: ageYears,
        sex: sex,
      );
      catchUpProtein = weightKg * 1.8;
    }

    return NutritionCalculationResult(
      weightKg: weightKg,
      heightCm: heightCm,
      ageMonths: months,
      sex: sex,
      idealWeightKg: idealWeightKg,
      eerKcal: eer,
      proteinGrams: proteinTotal,
      proteinRdaPerKg: proteinRda,
      fluidMl: fluid,
      catchUpEnergyKcal: catchUpKcal,
      catchUpProteinGrams: catchUpProtein,
      needsCatchUp: isMalnourished && catchUpKcal != null,
    );
  }
}
