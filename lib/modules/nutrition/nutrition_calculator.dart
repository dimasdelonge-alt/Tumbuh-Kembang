import '../growth/nutrition_classifier.dart';
import '../growth/waterlow_calculator.dart';
import 'nutrition_data.dart';

/// Hasil perhitungan kebutuhan nutrisi harian anak.
class NutritionRequirement {
  /// Berat badan ideal (kg) berdasarkan median BB untuk Height Age (CDC 2000).
  final double idealWeightKg;

  /// Height Age (bulan): usia di mana TB anak = median CDC.
  final double heightAgeMonths;

  /// Kebutuhan Energi Target (kkal/hari).
  final double targetEnergyKcal;

  /// Kebutuhan Protein Target (gram/hari).
  final double targetProteinGram;

  /// Kebutuhan Cairan Harian (ml/hari) — rumus Holliday-Segar.
  final double dailyFluidMl;

  /// Entri AKG Permenkes yang digunakan.
  final AkgEntry akgEntry;

  /// Panduan MPASI sesuai usia.
  final MpasiGuidance mpasiGuidance;

  /// Rekomendasi suplementasi Zat Besi.
  final SupplementGuidance ironSupp;

  /// Rekomendasi suplementasi Vitamin D.
  final SupplementGuidance vitDSupp;

  /// Status gizi anak (dari Waterlow atau WHO).
  final NutritionStatus? nutritionStatus;

  /// Persentase BB aktual / BB ideal (Waterlow).
  final double? waterlowPercentage;

  NutritionRequirement({
    required this.idealWeightKg,
    required this.heightAgeMonths,
    required this.targetEnergyKcal,
    required this.targetProteinGram,
    required this.dailyFluidMl,
    required this.akgEntry,
    required this.mpasiGuidance,
    required this.ironSupp,
    required this.vitDSupp,
    this.nutritionStatus,
    this.waterlowPercentage,
  });

  /// Label ringkasan kebutuhan nutrisi harian.
  String get energyLabel => '${targetEnergyKcal.toStringAsFixed(0)} kkal/hari';
  String get proteinLabel => '${targetProteinGram.toStringAsFixed(1)} g/hari';
  String get fluidLabel => '${dailyFluidMl.toStringAsFixed(0)} ml/hari';
  String get idealWeightLabel => '${idealWeightKg.toStringAsFixed(1)} kg';

  /// Apakah anak perlu intervensi nutrisi khusus (gizi kurang/buruk)?
  bool get needsIntervention =>
      nutritionStatus == NutritionStatus.wasting ||
      nutritionStatus == NutritionStatus.severeWasting;

  /// Saran intervensi berdasarkan status gizi.
  String get interventionAdvice {
    if (nutritionStatus == NutritionStatus.severeWasting) {
      return 'GIZI BURUK — Rujuk segera ke RS/Puskesmas dengan TFC (Therapeutic Feeding Centre). '
          'Berikan F-75 stabilisasi → F-100 rehabilitasi. '
          'Tambahkan kalori target 150–220 kkal/kgBB/hari selama fase rehabilitasi.';
    } else if (nutritionStatus == NutritionStatus.wasting) {
      return 'GIZI KURANG — Tingkatkan asupan kalori menjadi 120–150% dari kebutuhan normal. '
          'Tambahkan lemak sehat (minyak/mentega/santan) ke makanan. '
          'Pastikan protein hewani setiap kali makan. '
          'Evaluasi ulang setiap 2 minggu.';
    } else if (nutritionStatus == NutritionStatus.overweight ||
        nutritionStatus == NutritionStatus.obese) {
      return 'OVERWEIGHT/OBESITAS — Jangan restriksi kalori secara drastis pada anak. '
          'Fokus pada pola makan gizi seimbang dan peningkatan aktivitas fisik. '
          'Batasi makanan ultra-proses dan minuman manis.';
    }
    return 'Status gizi normal — Pertahankan pola makan gizi seimbang.';
  }
}

class NutritionCalculator {
  /// Menghitung kebutuhan nutrisi harian anak berdasarkan pengukuran antropometri.
  /// Menghitung kebutuhan nutrisi harian anak berdasarkan pengukuran antropometri.
  ///
  /// [weightKg]: BB aktual anak (kg)
  /// [heightCm]: TB aktual anak (cm)
  /// [ageMonths]: Usia anak (bulan) — gunakan usia kronologis
  /// [sex]: 'L' / 'M' untuk Laki-laki, 'P' / 'F' untuk Perempuan
  /// [whoNutritionStatus]: Status gizi berdasarkan Z-score WHO BB/TB (standar Kemenkes).
  ///   Jika diberikan, digunakan sebagai STATUS GIZI yang ditampilkan.
  ///   Waterlow hanya digunakan untuk menghitung W_ideal (kebutuhan kalori/protein).
  ///   Jika null, status diambil dari Waterlow (untuk kompatibilitas anak > 5 tahun).
  static NutritionRequirement? calculate({
    required double? weightKg,
    required double? heightCm,
    required int ageMonths,
    required String sex,
    NutritionStatus? whoNutritionStatus,
  }) {
    if (weightKg == null || heightCm == null || weightKg <= 0 || heightCm <= 0) {
      return null;
    }

    final isBoy = sex.toUpperCase() == 'L' || sex.toUpperCase() == 'M';
    final sexCode = isBoy ? 'L' : 'P';

    // 1. Hitung W_ideal dan Height Age menggunakan Waterlow (CDC 2000/WHO 2006)
    //    W_ideal dipakai HANYA untuk kalkulasi kebutuhan energi/protein/cairan.
    final waterlow = WaterlowCalculator.calculate(
      weightKg: weightKg,
      heightCm: heightCm,
      sex: sexCode,
      ageMonths: ageMonths,
    );

    final idealWeight = waterlow.idealWeightKg;
    final heightAge = waterlow.heightAgeMonths;

    // 2. Cari entri AKG berdasarkan Height Age (bukan usia kronologis)
    //    Ini sesuai metode RDA × W_ideal yang disetujui dokter
    final akgEntry = findAkg(heightAge.round(), sex);
    if (akgEntry == null) return null;

    // 3. Hitung Kebutuhan Energi & Protein Target
    //    Target = RDA per kgBB × W_ideal
    final targetEnergy = akgEntry.energyPerKgBB * idealWeight;
    final targetProtein = akgEntry.proteinPerKgBB * idealWeight;

    // 4. Hitung Kebutuhan Cairan Harian (Holliday-Segar)
    final dailyFluid = _hollidaySegar(idealWeight);

    // 5. Panduan MPASI sesuai usia kronologis
    final mpasi = findMpasiGuidance(ageMonths);

    // 6. Suplementasi
    final ironSupp = ironSupplement(ageMonths, weightKg);
    final vitDSupp = vitaminDSupplement(ageMonths);

    // 7. Status Gizi:
    //    - Untuk anak < 5 tahun: gunakan status WHO BB/TB (standar Kemenkes RI 2010)
    //      jika diberikan oleh caller, karena lebih konsisten dengan tampilan antropometri.
    //    - Untuk anak ≥ 5 tahun (Waterlow dipakai di growth_assessment): pakai status Waterlow.
    //    - Jika whoNutritionStatus null (caller tidak punya data WHO): fallback ke Waterlow.
    final finalStatus = whoNutritionStatus ?? waterlow.status;

    return NutritionRequirement(
      idealWeightKg: idealWeight,
      heightAgeMonths: heightAge,
      targetEnergyKcal: targetEnergy,
      targetProteinGram: targetProtein,
      dailyFluidMl: dailyFluid,
      akgEntry: akgEntry,
      mpasiGuidance: mpasi,
      ironSupp: ironSupp,
      vitDSupp: vitDSupp,
      nutritionStatus: finalStatus,
      waterlowPercentage: waterlow.percentage,
    );
  }

  /// Kebutuhan cairan harian (ml/hari) berdasarkan rumus Holliday-Segar.
  ///
  /// - 100 ml/kg untuk 10 kg pertama
  /// - 50 ml/kg untuk 10 kg berikutnya (11–20 kg)
  /// - 20 ml/kg untuk setiap kg di atas 20 kg
  static double _hollidaySegar(double weightKg) {
    if (weightKg <= 0) return 0;

    if (weightKg <= 10) {
      return 100.0 * weightKg;
    } else if (weightKg <= 20) {
      return 1000.0 + 50.0 * (weightKg - 10.0);
    } else {
      return 1500.0 + 20.0 * (weightKg - 20.0);
    }
  }

  /// Versi publik Holliday-Segar untuk dipakai oleh unit test.
  static double hollidaySegar(double weightKg) => _hollidaySegar(weightKg);
}
