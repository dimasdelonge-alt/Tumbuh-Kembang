import '../../core/age_calculator.dart';
import 'denver_data.dart';
import 'denver_model.dart';

/// Hasil analisis item per item untuk skrining Denver II
class DenverItemAnalysis {
  final DenverItem item;
  final DenverItemEvaluation evaluation;
  final DenverItemStatus status;

  const DenverItemAnalysis({
    required this.item,
    required this.evaluation,
    required this.status,
  });

  bool get isCaution => status == DenverItemStatus.caution;
  bool get isDelayed => status == DenverItemStatus.delayed;
  bool get isAdvanced => status == DenverItemStatus.advanced;
  bool get isNormal => status == DenverItemStatus.normal;
}

/// Hasil Rangkuman Analisis Global Denver II
class DenverAssessmentResult {
  final double ageInMonths;
  final bool usedCorrectedAge;
  final Map<String, DenverItemEvaluation> answers;
  final List<DenverItemAnalysis> itemAnalyses;
  final int cautionsCount;
  final int delaysCount;
  final DenverGlobalResult globalResult;
  final Map<DenverSector, int> cautionsPerSector;
  final Map<DenverSector, int> delaysPerSector;
  final Map<DenverSector, double> developmentalAgePerSectorInMonths;

  const DenverAssessmentResult({
    required this.ageInMonths,
    required this.usedCorrectedAge,
    required this.answers,
    required this.itemAnalyses,
    required this.cautionsCount,
    required this.delaysCount,
    required this.globalResult,
    required this.cautionsPerSector,
    required this.delaysPerSector,
    required this.developmentalAgePerSectorInMonths,
  });
}

/// Engine Kalkulator Klinis Denver II
class DenverCalculator {
  /// Menghitung usia uji dalam bulan (memakai Usia Koreksi bila prematur < 24 bln)
  static Map<String, dynamic> calculateTestAge({
    required DateTime birthDate,
    required DateTime testDate,
    bool isPremature = false,
    int? gestationalWeeks,
  }) {
    final ageData = AgeCalculator.calculate(
      birthDate: birthDate,
      examDate: testDate,
      gestationalWeeks: gestationalWeeks,
    );

    final bool useCorrected = ageData.correctionApplied;
    final double ageInMonths = useCorrected
        ? ageData.correctedDays / 30.4375
        : ageData.chronologicalDays / 30.4375;

    return {
      'ageInMonths': ageInMonths,
      'usedCorrectedAge': useCorrected,
      'ageData': ageData,
    };
  }

  /// Menilai status per item tunggal berdasarkan jawaban dan garis usia
  static DenverItemStatus evaluateItemStatus({
    required DenverItem item,
    required double ageInMonths,
    required DenverItemEvaluation evaluation,
  }) {
    switch (evaluation) {
      case DenverItemEvaluation.pass:
        // Jika garis usia belum mencapai p25 (anak lulus item yang lebih tua dari usianya)
        if (ageInMonths < item.p25) {
          return DenverItemStatus.advanced;
        }
        return DenverItemStatus.normal;

      case DenverItemEvaluation.fail:
      case DenverItemEvaluation.refusal:
        // Jika garis usia sudah melewati p90 (seharusnya 90% anak seusianya sudah bisa)
        if (ageInMonths > item.p90) {
          return DenverItemStatus.delayed;
        }
        // Jika garis usia memotong rentang p75 s.d p90
        if (ageInMonths >= item.p75 && ageInMonths <= item.p90) {
          return DenverItemStatus.caution;
        }
        return DenverItemStatus.normal;

      case DenverItemEvaluation.noOpportunity:
        return DenverItemStatus.normal;
    }
  }

  /// Memfilter item-item yang relevan diuji untuk usia anak saat ini
  static List<DenverItem> getItemsToTestForAge(double ageInMonths) {
    return DenverData.allItems.where((item) {
      // Item dipotong oleh garis usia OR item persis di sebelah kiri garis usia (p90 <= age)
      // OR item persis di sebelah kanan (p25 >= age) dalam rentang buffer wajar (6 bulan)
      final bool ageLineIntersects = ageInMonths >= item.p25 && ageInMonths <= item.p90;
      final bool nearLeft = item.p90 <= ageInMonths && (ageInMonths - item.p90) <= 6.0;
      final bool nearRight = item.p25 >= ageInMonths && (item.p25 - ageInMonths) <= 6.0;
      return ageLineIntersects || nearLeft || nearRight;
    }).toList();
  }

  /// Melakukan analisis komprehensif atas seluruh jawaban yang diinputkan
  static DenverAssessmentResult analyze({
    required double ageInMonths,
    required bool usedCorrectedAge,
    required Map<String, DenverItemEvaluation> answers,
  }) {
    final List<DenverItemAnalysis> analyses = [];

    final Map<DenverSector, int> cautionsPerSector = {
      DenverSector.personalSocial: 0,
      DenverSector.fineMotorAdaptive: 0,
      DenverSector.language: 0,
      DenverSector.grossMotor: 0,
    };

    final Map<DenverSector, int> delaysPerSector = {
      DenverSector.personalSocial: 0,
      DenverSector.fineMotorAdaptive: 0,
      DenverSector.language: 0,
      DenverSector.grossMotor: 0,
    };

    final Map<DenverSector, double> highestPassedAgePerSector = {
      DenverSector.personalSocial: 0.0,
      DenverSector.fineMotorAdaptive: 0.0,
      DenverSector.language: 0.0,
      DenverSector.grossMotor: 0.0,
    };

    bool refusalOnDelayOrMultipleCaution = false;

    answers.forEach((itemId, eval) {
      final item = DenverData.getItemById(itemId);
      if (item == null) return;

      final status = evaluateItemStatus(
        item: item,
        ageInMonths: ageInMonths,
        evaluation: eval,
      );

      final analysis = DenverItemAnalysis(
        item: item,
        evaluation: eval,
        status: status,
      );
      analyses.add(analysis);

      if (status == DenverItemStatus.caution) {
        cautionsPerSector[item.sector] = (cautionsPerSector[item.sector] ?? 0) + 1;
      } else if (status == DenverItemStatus.delayed) {
        delaysPerSector[item.sector] = (delaysPerSector[item.sector] ?? 0) + 1;
      }

      if (eval == DenverItemEvaluation.pass) {
        if (item.p50 > (highestPassedAgePerSector[item.sector] ?? 0.0)) {
          highestPassedAgePerSector[item.sector] = item.p50;
        }
      }

      if (eval == DenverItemEvaluation.refusal) {
        if (status == DenverItemStatus.delayed || status == DenverItemStatus.caution) {
          refusalOnDelayOrMultipleCaution = true;
        }
      }
    });

    final int totalCautions = cautionsPerSector.values.reduce((a, b) => a + b);
    final int totalDelays = delaysPerSector.values.reduce((a, b) => a + b);

    DenverGlobalResult globalResult;
    if (refusalOnDelayOrMultipleCaution) {
      globalResult = DenverGlobalResult.untestable;
    } else if (totalDelays >= 1 || totalCautions >= 2) {
      globalResult = DenverGlobalResult.suspect;
    } else {
      globalResult = DenverGlobalResult.normal;
    }

    return DenverAssessmentResult(
      ageInMonths: ageInMonths,
      usedCorrectedAge: usedCorrectedAge,
      answers: answers,
      itemAnalyses: analyses,
      cautionsCount: totalCautions,
      delaysCount: totalDelays,
      globalResult: globalResult,
      cautionsPerSector: cautionsPerSector,
      delaysPerSector: delaysPerSector,
      developmentalAgePerSectorInMonths: highestPassedAgePerSector,
    );
  }
}
