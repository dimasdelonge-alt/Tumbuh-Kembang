import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/nutrition/nutrition_data.dart';
import 'package:tumbang/modules/nutrition/meal_plan_data.dart';
import 'package:tumbang/modules/nutrition/weekly_meal_plan_generator.dart';

void main() {
  group('WHO Guideline for Complementary Feeding 2023 (6-23 Months) Tests', () {
    test('whoComplementaryFeedingPrinciples contains all 7 official WHO 2023 recommendations', () {
      expect(whoComplementaryFeedingPrinciples.length, equals(7));

      // Rec 1: Continued Breastfeeding
      final rec1 = whoComplementaryFeedingPrinciples[0];
      expect(rec1.number, equals(1));
      expect(rec1.title.toLowerCase(), contains('continued breastfeeding'));
      expect(rec1.recommendation.toLowerCase(), contains('2 tahun atau lebih'));
      expect(rec1.strengthAndCertainty.toLowerCase(), contains('strong recommendation'));

      // Rec 2: Milks for Non-Breastfed Children
      final rec2 = whoComplementaryFeedingPrinciples[1];
      expect(rec2.number, equals(2));
      expect(rec2.recommendation.toLowerCase(), contains('formula lanjutan (follow-up formula) tidak direkomendasikan'));
      expect(rec2.details.any((d) => d.toLowerCase().contains('susu sapi pasteurisasi')), isTrue);
      expect(rec2.details.any((d) => d.toLowerCase().contains('400-500 ml/hari')), isTrue);

      // Rec 3: Age of Introduction
      final rec3 = whoComplementaryFeedingPrinciples[2];
      expect(rec3.number, equals(3));
      expect(rec3.recommendation, contains('6 bulan (180 hari)'));

      // Rec 4: Dietary Diversity
      final rec4 = whoComplementaryFeedingPrinciples[3];
      expect(rec4.number, equals(4));
      expect(rec4.recommendation, contains('Pangan Hewani (ASF) setiap hari'));
      expect(rec4.recommendation, contains('Buah & Sayuran setiap hari'));
      expect(rec4.details.any((d) => d.toLowerCase().contains('starchy staples')), isTrue);

      // Rec 5: Unhealthy Foods & Beverages
      final rec5 = whoComplementaryFeedingPrinciples[4];
      expect(rec5.number, equals(5));
      expect(rec5.recommendation, contains('TIDAK BOLEH dikonsumsi'));
      expect(rec5.recommendation, contains('Minuman manis (SSB)'));
      expect(rec5.recommendation, contains('pemanis buatan DILARANG'));
      expect(rec5.recommendation, contains('Jus buah 100% sangat dibatasi'));

      // Rec 6: Nutrient Supplements
      final rec6 = whoComplementaryFeedingPrinciples[5];
      expect(rec6.number, equals(6));
      expect(rec6.recommendation, contains('suplemen mikronutrien (MNP/Fe/Vit D)'));

      // Rec 7: Responsive Feeding
      final rec7 = whoComplementaryFeedingPrinciples[6];
      expect(rec7.number, equals(7));
      expect(rec7.title.toLowerCase(), contains('responsive feeding'));
      expect(rec7.details.any((d) => d.toLowerCase().contains('no force-feeding')), isTrue);
    });

    test('mpasiGuidelines integrates WHO 2023 recommendations into age brackets', () {
      // 6-8 months
      final g6 = findMpasiGuidance(7);
      expect(g6.notes, contains('WHO Guideline (2023)'));
      expect(g6.notes, contains('Pangan hewani'));
      expect(g6.notes, contains('SETIAP HARI'));
      expect(g6.notes, contains('Responsive Feeding'));
      expect(g6.notes, contains('Dilarang: gula tambahan, garam tinggi, lemak trans, & minuman manis (SSB)'));

      // 9-11 months
      final g9 = findMpasiGuidance(10);
      expect(g9.notes, contains('WHO Guideline (2023)'));
      expect(g9.notes, contains('finger food'));
      expect(g9.notes, contains('Responsive Feeding'));

      // 12-23 months
      final g12 = findMpasiGuidance(14);
      expect(g12.notes, contains('WHO Guideline (2023)'));
      expect(g12.notes, contains('Teruskan ASI sampai 2 tahun atau lebih'));
      expect(g12.notes, contains('TIDAK merekomendasikan susu formula lanjutan'));
    });

    test('MealPlanRepository integrates WHO 2023 rules and feeding schedule', () {
      // Schedule recommendations for 6-8 months
      final sched6 = MealPlanRepository.getScheduleForAge(7.0);
      expect(sched6.first.recommendation, contains('WHO 2023: wajib pangan hewani setiap hari'));

      // Schedule recommendations for 12-23 months
      final sched12 = MealPlanRepository.getScheduleForAge(15.0);
      expect(sched12.last.recommendation, contains('WHO 2023 tidak merekomendasikan formula lanjutan'));

      // Portion guide notes
      final portion6 = MealPlanRepository.getPortionGuide(7.0);
      expect(portion6.animalProtein, contains('WAJIB setiap hari - WHO 2023'));

      // Feeding rules list
      expect(MealPlanRepository.feedingRules.length, equals(7));
      expect(MealPlanRepository.feedingRules.any((r) => r.contains('Wajib Protein Hewani Harian (WHO 2023)')), isTrue);
      expect(MealPlanRepository.feedingRules.any((r) => r.contains('Bebas Gula Tambahan & Batasi Minuman Manis (WHO 2023)')), isTrue);
      expect(MealPlanRepository.feedingRules.any((r) => r.contains('Ketentuan Susu Non-ASI (WHO 2023)')), isTrue);
    });

    test('WeeklyMealPlanGenerator sessions reflect WHO 2023 milk guidance for toddlers', () {
      final plan = WeeklyMealPlanGenerator.generate7DayPlan(ageMonths: 18.0);
      final lastSession = plan[0].sessions.last;
      expect(lastSession.description, contains('WHO: tanpa formula lanjutan'));
      expect(lastSession.description, contains('Susu Sapi Pasteurisasi / UHT plain'));
    });
  });
}
