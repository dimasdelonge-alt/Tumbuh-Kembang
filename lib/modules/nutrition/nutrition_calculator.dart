import 'dart:math';

import '../growth/cdc_growth_data.dart';
import '../growth/waterlow_calculator.dart';
import '../growth/who_growth_data.dart';

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

/// Kelas hasil kalkulasi gizi klinis pediatrik (Asuhan Nutrisi Pediatrik IDAI / AAP / Permenkes).
class NutritionCalculationResult {
  final double weightKg;
  final double heightCm;
  final double ageMonths;
  final String sex;
  final double? idealWeightKg;
  final double heightAgeMonths;

  /// Kebutuhan Energi Harian (RDA Kalori at Height Age x BB Ideal) (kcal/hari)
  final double eerKcal;

  /// RDA Energi per kgBB Ideal (kcal/kg/hari)
  final double energyRdaPerKg;

  /// Kebutuhan Protein Harian (RDA Protein at Height Age x BB Ideal) (g/hari)
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
    required this.heightAgeMonths,
    required this.eerKcal,
    required this.energyRdaPerKg,
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
  String get heightAgeLabel => '${heightAgeMonths.toStringAsFixed(1)} bulan';
  String get interventionAdvice =>
      'Indikasi Gagal Tumbuh / Stunting: Target Catch-Up Growth ${catchUpEnergyKcal?.round() ?? eerKcal.round()} kcal/hari.';

  double get targetEnergyKcal => catchUpEnergyKcal ?? eerKcal;
  double get targetProteinGram => catchUpProteinGrams ?? proteinGrams;
  double get dailyFluidMl => fluidMl;

  AkgEntry get akgEntry {
    final refAge = heightAgeMonths > 0 ? heightAgeMonths : ageMonths;
    if (refAge < 6) return const AkgEntry('0-5 Bulan');
    if (refAge < 12) return const AkgEntry('6-11 Bulan');
    if (refAge < 36) return const AkgEntry('1-3 Tahun');
    if (refAge < 72) return const AkgEntry('4-6 Tahun');
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
/// Asuhan Nutrisi Pediatrik (ANP) IDAI & AAP Pediatric Nutrition Handbook:
/// Target Kalori / Energi = RDA Kalori (Usia Tinggi / Height Age) x BB Ideal (BBI).
/// Target Protein = RDA Protein (Usia Tinggi / Height Age) x BB Ideal (BBI).
class PediatricNutritionCalculator {
  /// Menghitung Usia Tinggi (Height Age) dalam bulan berdasarkan standar WHO / CDC.
  static double calculateHeightAge({
    required double heightCm,
    required String sex,
    num? ageMonths,
  }) {
    if (heightCm <= 0) return (ageMonths?.toDouble() ?? 12.0);

    // 1. Coba dari tabel WHO length/height for age jika tersedia
    final who = WhoGrowthData.instance;
    final whoHa = who.heightAgeMonths(sex: sex, lengthHeightCm: heightCm);
    if (whoHa != null && whoHa > 0) {
      return whoHa;
    }

    // 2. Gunakan CDC 2000 untuk tinggi anak yang lebih besar (>5 thn) atau fallback
    final isMale = sex.toUpperCase() == 'L';
    final statureTable = isMale ? CdcGrowthData.statureBoys : CdcGrowthData.statureGirls;
    if (heightCm < statureTable.first.value) {
      // Fallback interpolasi 0-24 bulan (lahir ~49.5cm s/d 24 bln ~85.7cm)
      final birthHeight = isMale ? 49.9 : 49.1;
      if (heightCm <= birthHeight) return 0.0;
      final t = (heightCm - birthHeight) / (statureTable.first.value - birthHeight);
      return (t * 24.0).clamp(0.0, 24.0);
    } else if (heightCm >= statureTable.last.value) {
      return statureTable.last.key;
    } else {
      for (int i = 0; i < statureTable.length - 1; i++) {
        final p1 = statureTable[i];
        final p2 = statureTable[i + 1];
        if (heightCm >= p1.value && heightCm <= p2.value) {
          if ((p2.value - p1.value).abs() < 1e-6) return p1.key;
          final t = (heightCm - p1.value) / (p2.value - p1.value);
          return p1.key + t * (p2.key - p1.key);
        }
      }
    }

    return (ageMonths?.toDouble() ?? 12.0);
  }

  /// Menghitung Berat Badan Ideal (BB Ideal / BBI / Median BB/TB) dalam kg.
  static double calculateIdealWeight({
    required double heightCm,
    required String sex,
    num? ageMonths,
  }) {
    if (heightCm <= 0) return 10.0;
    final age = ageMonths?.toDouble();

    // 1. Coba dari tabel WHO BB/TB (0-60 bulan / panjang 45-120cm)
    if (age == null || age <= 60.0 || heightCm <= 120.0) {
      final who = WhoGrowthData.instance;
      final whoIdeal = who.medianWeightForLength(
        sex: sex,
        lengthHeightCm: heightCm,
        measuredLying: heightCm < 85.0,
      );
      if (whoIdeal != null && whoIdeal > 0) {
        return whoIdeal;
      }
    }

    // 2. Fallback untuk tinggi < 85 cm bila aset WHO belum dimuat
    if (heightCm < 85.7) {
      final isMale = sex.toUpperCase() == 'L';
      final birthWeight = isMale ? 3.3 : 3.2;
      final weight24m = isMale ? 12.2 : 11.5;
      final birthHeight = isMale ? 49.9 : 49.1;
      final height24m = isMale ? 86.4 : 85.7;
      if (heightCm <= birthHeight) return birthWeight;
      final t = (heightCm - birthHeight) / (height24m - birthHeight);
      return (birthWeight + t * (weight24m - birthWeight)).clamp(birthWeight, weight24m);
    }

    // 3. Gunakan metode Waterlow CDC 2000
    final waterlow = WaterlowCalculator.calculate(
      weightKg: 10.0,
      heightCm: heightCm,
      sex: sex,
      ageMonths: age?.round(),
    );
    return waterlow.idealWeightKg;
  }

  /// Menghitung RDA Kalori per kg BB Ideal berdasarkan Usia Tinggi (Permenkes 28/2019 & AAP).
  static double getRdaEnergyPerKg(double heightAgeMonths, [String sex = 'L']) {
    final isBoy = sex.toUpperCase() == 'L';
    if (heightAgeMonths < 6.0) {
      return 100.0;
    } else if (heightAgeMonths < 12.0) {
      return 95.0;
    } else if (heightAgeMonths < 48.0) { // 1-3 tahun (12-47 bulan)
      return 100.0;
    } else if (heightAgeMonths < 84.0) { // 4-6 tahun (48-83 bulan)
      return 80.0;
    } else if (heightAgeMonths < 120.0) { // 7-9 tahun (84-119 bulan)
      return 65.0;
    } else if (heightAgeMonths < 156.0) { // 10-12 tahun
      return isBoy ? 55.0 : 50.0;
    } else if (heightAgeMonths < 192.0) { // 13-15 tahun
      return isBoy ? 50.0 : 45.0;
    } else { // 16-18 tahun
      return isBoy ? 45.0 : 40.0;
    }
  }

  /// Menghitung Protein RDA per kg BB Ideal berdasarkan Usia Tinggi (AKG 2019 / AAP).
  static double getProteinRdaPerKg(double heightAgeMonths) {
    if (heightAgeMonths < 6.0) {
      return 1.5;
    } else if (heightAgeMonths < 12.0) {
      return 1.5;
    } else if (heightAgeMonths < 48.0) { // 1-3 tahun
      return 1.5;
    } else if (heightAgeMonths < 120.0) { // 4-9 tahun
      return 1.2;
    } else { // 10-18 tahun
      return 1.0;
    }
  }

  /// Menghitung BMR / Basal Metabolic Rate berbasis Persamaan Schofield / WHO 1985 (hanya basal/istirahat).
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

  /// Menghitung Kebutuhan Cairan Pemeliharaan (Holliday-Segar).
  static double calculateHollidaySegarFluid(double weightKg) {
    if (weightKg <= 10.0) {
      return weightKg * 100.0;
    } else if (weightKg <= 20.0) {
      return 1000.0 + ((weightKg - 10.0) * 50.0);
    } else {
      return 1500.0 + ((weightKg - 20.0) * 20.0);
    }
  }

  /// Menghitung Kalori Catch-Up Growth untuk Anak Gagal Tumbuh / Stunting / Wasting
  /// Rumus ANP IDAI: (RDA Kalori at HA x BB Ideal) / BB Aktual.
  static double calculateCatchUpEnergy({
    required double idealWeightKg,
    required double actualWeightKg,
    required double energyRdaPerKg,
  }) {
    if (actualWeightKg <= 0) return 0;
    final normalTarget = energyRdaPerKg * idealWeightKg;
    final catchUpVal = (normalTarget * idealWeightKg) / actualWeightKg;
    return max(normalTarget * 1.2, catchUpVal);
  }

  /// Kalkulasi lengkap nutrisi klinis berbasis standar Asuhan Nutrisi Pediatrik IDAI / AAP.
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
    final ha = calculateHeightAge(heightCm: heightCm, sex: sex, ageMonths: months);
    final idealW = (idealWeightKg != null && idealWeightKg > 0)
        ? idealWeightKg
        : calculateIdealWeight(heightCm: heightCm, sex: sex, ageMonths: months);

    final energyRda = getRdaEnergyPerKg(ha, sex);
    final proteinRda = getProteinRdaPerKg(ha);

    // Kebutuhan Energi & Protein Standar ANP: RDA at Height Age x BB Ideal
    final totalEnergy = energyRda * idealW;
    final totalProtein = proteinRda * idealW;
    final fluid = calculateHollidaySegarFluid(weightKg > 0 ? weightKg : idealW);

    double? catchUpKcal;
    double? catchUpProtein;

    final hasMalnutritionIndication = isMalnourished ||
        (idealW > weightKg &&
            whoNutritionStatus != null &&
            (whoNutritionStatus.toString().contains('wasting') ||
                whoNutritionStatus.toString().contains('severeWasting') ||
                whoNutritionStatus.toString().contains('underweight') ||
                whoNutritionStatus.toString().contains('severeUnderweight')));

    if (hasMalnutritionIndication && idealW > weightKg && weightKg > 0) {
      catchUpKcal = calculateCatchUpEnergy(
        idealWeightKg: idealW,
        actualWeightKg: weightKg,
        energyRdaPerKg: energyRda,
      );
      // Protein kejar tumbuh tidak boleh lebih rendah dari kebutuhan
      // pemeliharaan (RDA x BBI): pada anak sangat kurus, rumus
      // 1,8 g/kgBB aktual bisa jatuh di bawah standar (mis. BB 7 kg,
      // BBI 9,5 kg -> 12,6 g < 14,25 g), jadi standar menjadi lantai.
      catchUpProtein = max(totalProtein, weightKg * 1.8);
    }

    return NutritionCalculationResult(
      weightKg: weightKg,
      heightCm: heightCm,
      ageMonths: months,
      sex: sex,
      idealWeightKg: idealW,
      heightAgeMonths: ha,
      eerKcal: totalEnergy,
      energyRdaPerKg: energyRda,
      proteinGrams: totalProtein,
      proteinRdaPerKg: proteinRda,
      fluidMl: fluid,
      catchUpEnergyKcal: catchUpKcal,
      catchUpProteinGrams: catchUpProtein,
      needsCatchUp: hasMalnutritionIndication && catchUpKcal != null,
    );
  }
}
