import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/nutrition/food_exchange_data.dart';
import 'package:tumbang/modules/nutrition/nutrition_calculator.dart';
import 'package:tumbang/modules/nutrition/weekly_meal_plan_generator.dart';

void main() {
  group('Food Exchange & Weekly Meal Plan Tests', () {
    test('Food Exchange Repository dataset contains correct groups', () {
      expect(FoodExchangeRepository.carbsList.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.animalProteinLowFat.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.animalProteinMedFat.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.animalProteinHighFat.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.plantProteinList.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.veggiesList.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.fruitsList.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.milkList.isNotEmpty, isTrue);
      expect(FoodExchangeRepository.veggiesFree.isNotEmpty, isTrue);

      final nasi = FoodExchangeRepository.carbsList.firstWhere((i) => i.name.contains('Nasi'));
      expect(nasi.calories, equals(175));
      expect(nasi.carbs, equals(40));
    });

    test('Weekly Meal Plan Generator creates 7 days (Senin to Minggu)', () {
      final plan = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 14.0,
        preferredCarb: FoodExchangeRepository.carbsList.first,
        preferredAnimalProtein: FoodExchangeRepository.animalProteinMedFat.first,
      );

      expect(plan.length, equals(7));
      expect(plan[0].dayName, equals('Senin'));
      expect(plan[6].dayName, equals('Minggu'));

      // Check daily sessions
      expect(plan[0].sessions.length, equals(6)); // 07:00, 09:30, 12:00, 15:30, 18:00, 20:30
      expect(plan[0].sessions[0].sessionName, equals('Makan Pagi'));
      expect(plan[0].sessions[2].sessionName, equals('Makan Siang'));
    });

    test('Weekly Meal Plan Generator scales portions correctly according to age bracket', () {
      // 7 bulan (6-8 bln): Lumat
      final plan7m = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 7.0,
        preferredCarb: FoodExchangeRepository.carbsList.first,
      );
      final portion7m = plan7m[0].sessions[0].portionUrt;
      expect(portion7m, contains('2-3 sdm bubur lumat'));
      expect(portion7m, contains('25g'));

      // 9 bulan (9-11 bln): Tim Cincang 1/2 mangkuk
      final plan9m = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 9.0,
        preferredCarb: FoodExchangeRepository.carbsList.first,
      );
      final portion9m = plan9m[0].sessions[0].portionUrt;
      expect(portion9m, contains('1/2 mangkuk'));
      expect(portion9m, contains('50g'));

      // 14 bulan (12-23 bln): 3/4 mangkuk makanan cincang
      final plan14m = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 14.0,
        preferredCarb: FoodExchangeRepository.carbsList.first,
      );
      final portion14m = plan14m[0].sessions[0].portionUrt;
      expect(portion14m, contains('3/4 mangkuk'));
      expect(portion14m, contains('75g'));

      // 36 bulan (2-5 thn): 1 porsi piring makan keluarga
      final plan36m = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 36.0,
        preferredCarb: FoodExchangeRepository.carbsList.first,
      );
      final portion36m = plan36m[0].sessions[0].portionUrt;
      expect(portion36m, contains('1 porsi piring makan'));
    });

    test('Weekly Meal Plan ONLY includes checked/selected animal proteins (e.g. Daging Sapi & Hati Sapi)', () {
      final beef = FoodExchangeRepository.animalProteinMedFat.firstWhere((i) => i.name == 'Daging Sapi');
      final beefLiver = FoodExchangeRepository.animalProteinMedFat.firstWhere((i) => i.name == 'Hati Sapi');
      final rice = FoodExchangeRepository.carbsList.firstWhere((i) => i.name.contains('Nasi'));
      final tempeh = FoodExchangeRepository.plantProteinList.firstWhere((i) => i.name == 'Tempe');
      final carrot = FoodExchangeRepository.veggiesList.firstWhere((i) => i.name == 'Wortel');
      final banana = FoodExchangeRepository.fruitsList.firstWhere((i) => i.name.contains('Pisang'));

      final plan = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 10.0, // 9-11 bulan
        selectedCarbs: [rice],
        selectedAnimalProteins: [beef, beefLiver],
        selectedPlantProteins: [tempeh],
        selectedVeggies: [carrot],
        selectedFruits: [banana],
      );

      expect(plan.length, equals(7));

      // Disallowed words that were previously hardcoded and leaked into output
      final unselectedMeats = [
        'Ayam',
        'Telur',
        'Ikan',
        'Puyuh',
        'Bebek',
        'Lele',
        'Kakap',
        'Kembung',
        'Hati ayam',
        'Tahu',
      ];

      for (final day in plan) {
        // Check theme
        for (final meat in unselectedMeats) {
          expect(
            day.theme.toLowerCase().contains(meat.toLowerCase()),
            isFalse,
            reason: 'Day ${day.dayName} theme "${day.theme}" should not contain unselected "$meat"',
          );
        }

        // Check sessions
        for (final session in day.sessions) {
          for (final meat in unselectedMeats) {
            expect(
              session.menuName.toLowerCase().contains(meat.toLowerCase()),
              isFalse,
              reason: 'Day ${day.dayName} session "${session.sessionName}" menuName "${session.menuName}" should not contain unselected "$meat"',
            );
            expect(
              session.description.toLowerCase().contains(meat.toLowerCase()),
              isFalse,
              reason: 'Day ${day.dayName} session "${session.sessionName}" description "${session.description}" should not contain unselected "$meat"',
            );
          }
        }
      }

      // Verify that Daging Sapi and Hati Sapi are present
      final allText = plan.map((d) => '${d.theme} ${d.sessions.map((s) => '${s.menuName} ${s.description}').join(' ')}').join(' ');
      expect(allText, contains('Daging Sapi'));
      expect(allText, contains('Hati Sapi'));
      expect(allText, contains('Tempe'));
      expect(allText, contains('Wortel'));
      expect(allText, contains('Pisang'));
    });

    test('Weekly Meal Plan uses Catch-Up Growth calories as primary benchmark when indicated', () {
      final nutResultCatchUp = PediatricNutritionCalculator.calculate(
        weightKg: 7.0,
        heightCm: 75.0,
        ageMonths: 12.0,
        sex: 'L',
        idealWeightKg: 9.5,
        isMalnourished: true,
      );

      expect(nutResultCatchUp.needsCatchUp, isTrue);
      expect(nutResultCatchUp.catchUpEnergyKcal, isNotNull);
      expect(nutResultCatchUp.targetEnergyKcal, equals(nutResultCatchUp.catchUpEnergyKcal));

      final plan = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 12.0,
        nutResult: nutResultCatchUp,
      );

      expect(plan.length, equals(7));
      expect(plan[0].theme, contains('Kejar Tumbuh'));
      expect(plan[0].theme, contains('${nutResultCatchUp.targetEnergyKcal.round()} kcal'));
      expect(plan[0].sessions[0].description, contains('kejar tumbuh'));
    });

    test('Menu contoh dihitung dari target kalori tanpa kalori gap (regresi Milana: 10 bln, target ±1092)', () {
      // Kasus dokter: 10 bulan, BB 8,05 kg, TB 75 cm, target tertulis 1.092 kkal.
      // Total kalori harian (makanan padat + ASI/susu terhitung) harus mendekati target.
      final nut = PediatricNutritionCalculator.calculate(
        weightKg: 8.05,
        heightCm: 75.0,
        ageMonths: 10.0,
        sex: 'P',
        isMalnourished: true,
      );
      final plan = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 10.0,
        nutResult: nut,
      );
      final target = nut.targetEnergyKcal;
      for (final day in plan) {
        expect(day.totalKcal, closeTo(target, target * 0.05),
            reason: '${day.dayName} total ${day.totalKcal} masih gap dari target $target');
        // 9-11 bln: proporsi 50% ASI/SF : 50% MPASI (makanan utama 45% + 2 selingan buah 5%).
        final mainKcal = day.sessions[0].kcal + day.sessions[2].kcal + day.sessions[4].kcal;
        expect(mainKcal, greaterThan(target * 0.40));
        expect(mainKcal, lessThan(target * 0.55));
        // Rasio makro harus terhitung, konsisten 100%, dan memenuhi KH 40-60%, Pro ~15%, Lemak 35-50%.
        final m = day.macroEnergyPct;
        expect(m.carb + m.protein + m.fat, closeTo(100, 2));
        expect(m.carb, inInclusiveRange(40, 60));
        expect(m.protein, inInclusiveRange(12, 18));
        expect(m.fat, inInclusiveRange(35, 50));
      }
      // Takaran tampil dalam gram + setara satuan penukar/URT.
      expect(plan[0].sessions[0].portionUrt, contains('g (±'));
      expect(plan[0].sessions[0].kcal, greaterThan(0));
      // Theme tidak boleh bocor "Instance of" karena salah interpolasi string.
      expect(plan[0].theme, isNot(contains('Instance of')));
    });

    test('Total menu harian mendekati target kalori untuk semua kelompok usia', () {
      final cases = [
        (age: 3.0, w: 5.8, h: 60.0, mal: false),
        (age: 7.0, w: 7.5, h: 68.0, mal: false),
        (age: 10.0, w: 8.05, h: 75.0, mal: true),
        (age: 14.0, w: 8.5, h: 78.0, mal: true),
        (age: 30.0, w: 12.0, h: 88.0, mal: false),
        (age: 48.0, w: 15.0, h: 100.0, mal: false),
      ];
      for (final c in cases) {
        final nut = PediatricNutritionCalculator.calculate(
          weightKg: c.w,
          heightCm: c.h,
          ageMonths: c.age,
          sex: 'L',
          isMalnourished: c.mal,
        );
        final plan = WeeklyMealPlanGenerator.generate7DayPlan(
          ageMonths: c.age,
          nutResult: nut,
          selectedCarbs: FoodExchangeRepository.carbsList,
          selectedAnimalProteins: FoodExchangeRepository.allAnimalProtein,
          selectedPlantProteins: FoodExchangeRepository.plantProteinList,
          selectedVeggies: FoodExchangeRepository.veggiesList,
          selectedFruits: FoodExchangeRepository.fruitsList,
        );
        final target = nut.targetEnergyKcal;
        for (final day in plan) {
          expect(day.totalKcal, closeTo(target, target * 0.06),
              reason: 'Usia ${c.age} bln (${day.dayName}): total ${day.totalKcal} vs target $target');
        }
      }
    });

    test('Total menu anak >=24 bulan mendekati target kalori penuh', () {
      final nut = PediatricNutritionCalculator.calculate(
        weightKg: 12.0,
        heightCm: 88.0,
        ageMonths: 30.0,
        sex: 'L',
      );
      final plan = WeeklyMealPlanGenerator.generate7DayPlan(ageMonths: 30.0, nutResult: nut);
      final target = nut.targetEnergyKcal;
      for (final day in plan) {
        expect(day.totalKcal, closeTo(target, target * 0.05),
            reason: '${day.dayName}: ${day.totalKcal} vs target $target');
      }
      // Susu malam terhitung sebagai komponen wajib dengan pilihan dokter.
      final milk = plan[0].sessions.last;
      expect(milk.kcal, greaterThan(0));
      expect(milk.description, contains('PKMK'));
      expect(milk.description, contains('UHT'));
    });

    test('Rotasi protein hewani berbeda antar sesi dalam satu hari', () {
      final nut = PediatricNutritionCalculator.calculate(
        weightKg: 9.0, heightCm: 78.0, ageMonths: 14.0, sex: 'L');
      final plan = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 14.0,
        nutResult: nut,
        selectedAnimalProteins: [
          FoodExchangeRepository.animalProteinLowFat.firstWhere((i) => i.name.contains('Ayam')),
          FoodExchangeRepository.animalProteinMedFat.firstWhere((i) => i.name == 'Telur Ayam'),
          FoodExchangeRepository.animalProteinLowFat.firstWhere((i) => i.name.contains('Ikan')),
        ],
      );
      final senin = plan[0];
      final mains = [senin.sessions[0], senin.sessions[2], senin.sessions[4]];
      final names = mains.map((s) => s.menuName).join('|');
      expect(names, contains('Ayam'));
      expect(names, contains('Telur'));
      expect(names, contains('Ikan'));
    });

    test('Bahan olahan (Sosis/Biskuit) tidak masuk menu bayi <24 bulan', () {
      final sosis = FoodExchangeRepository.animalProteinHighFat.firstWhere((i) => i.name == 'Sosis');
      final biskuit = FoodExchangeRepository.carbsList.firstWhere((i) => i.name == 'Biskuit');
      final plan = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 7.0,
        selectedCarbs: [biskuit],
        selectedAnimalProteins: [sosis],
      );
      final allText = plan
          .map((d) => '${d.theme} ${d.sessions.map((s) => '${s.menuName} ${s.description} ${s.portionUrt}').join(' ')}')
          .join(' ');
      expect(allText.contains('Sosis'), isFalse);
      expect(allText.contains('Biskuit'), isFalse);
    });

    test('Pilihan tekstur manual mengganti profil usia', () {
      final nut = PediatricNutritionCalculator.calculate(
        weightKg: 9.0, heightCm: 78.0, ageMonths: 14.0, sex: 'L');
      final plan = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 14.0,
        nutResult: nut,
        textureOverride: 'saring',
      );
      expect(plan[0].sessions[0].description, contains('Saring'));
    });

    test('Kasus Hana (13 bln, BB 7.9 kg, TB 73 cm, P, malnourished): 7 hari, kalori ~1003, proporsi 30:70 & makro 40-60 / 15 / 35-50', () {
      final nut = PediatricNutritionCalculator.calculate(
        weightKg: 7.9,
        heightCm: 73.0,
        ageMonths: 13.0,
        sex: 'P',
        isMalnourished: true,
      );
      final ayamTanpaKulit = FoodExchangeRepository.animalProteinLowFat.firstWhere((i) => i.name.contains('Ayam tanpa Kulit'));
      final ikan = FoodExchangeRepository.animalProteinLowFat.firstWhere((i) => i.name.contains('Ikan Segar'));
      final telur = FoodExchangeRepository.animalProteinMedFat.firstWhere((i) => i.name == 'Telur Ayam');

      final plan = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 13.0,
        nutResult: nut,
        selectedAnimalProteins: [ayamTanpaKulit, ikan, telur],
      );

      expect(plan.length, equals(7));
      expect(
        plan.map((d) => d.dayName).toList(),
        equals(['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu']),
      );

      final target = nut.targetEnergyKcal;
      for (final day in plan) {
        expect(
          day.totalKcal,
          closeTo(target, target * 0.05),
          reason: '${day.dayName}: total ${day.totalKcal} vs target $target',
        );
        final m = day.macroEnergyPct;
        expect(m.carb, inInclusiveRange(40, 60), reason: '${day.dayName} KH ${m.carb}%');
        expect(m.protein, inInclusiveRange(13, 18), reason: '${day.dayName} Pro ${m.protein}%');
        expect(m.fat, inInclusiveRange(35, 50), reason: '${day.dayName} Lemak ${m.fat}%');

        // 12-23 bln: makanan padat ~70% (pagi + siang + malam + porsi buah di snack).
        final mainMealsKcal = day.sessions[0].kcal + day.sessions[2].kcal + day.sessions[4].kcal;
        expect(mainMealsKcal / day.totalKcal, inInclusiveRange(0.55, 0.72),
            reason: '${day.dayName} makan utama $mainMealsKcal dari ${day.totalKcal}');

        expect(day.theme, isNot(contains('Instance of')));
        for (final s in day.sessions) {
          expect(s.menuName, isNot(contains('Instance of')));
          expect(s.description, isNot(contains('Instance of')));
          expect(s.portionUrt, isNot(contains('Instance of')));
        }
      }
    });

    test('Proporsi ASI/SF vs MPASI (70:30, 50:50, 30:70) & rasio makro lintas usia dan jenis lemak lauk', () {
      // 6-8 bln: 70% ASI/SF : 30% MPASI
      final nut7 = PediatricNutritionCalculator.calculate(
        weightKg: 7.5, heightCm: 68.0, ageMonths: 7.0, sex: 'L');
      final plan7 = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 7.0,
        nutResult: nut7,
        selectedAnimalProteins: FoodExchangeRepository.allAnimalProtein,
      );
      for (final day in plan7) {
        final mpasiPct = (day.sessions[0].kcal + day.sessions[2].kcal + day.sessions[4].kcal) / day.totalKcal * 100;
        expect(mpasiPct, inInclusiveRange(20, 38), reason: '7 bln ${day.dayName} makan utama $mpasiPct%');
        final m = day.macroEnergyPct;
        expect(m.carb, inInclusiveRange(38, 60), reason: '7 bln ${day.dayName} KH ${m.carb}%');
        expect(m.fat, inInclusiveRange(35, 52), reason: '7 bln ${day.dayName} Lemak ${m.fat}%');
      }

      // 9-11 bln: 50% ASI/SF : 50% MPASI
      final nut10 = PediatricNutritionCalculator.calculate(
        weightKg: 8.5, heightCm: 73.0, ageMonths: 10.0, sex: 'P');
      final plan10 = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 10.0,
        nutResult: nut10,
        selectedAnimalProteins: FoodExchangeRepository.allAnimalProtein,
      );
      for (final day in plan10) {
        final mainPct = (day.sessions[0].kcal + day.sessions[2].kcal + day.sessions[4].kcal) / day.totalKcal * 100;
        expect(mainPct, inInclusiveRange(38, 55), reason: '10 bln ${day.dayName} makan utama $mainPct%');
        final m = day.macroEnergyPct;
        expect(m.carb, inInclusiveRange(40, 60), reason: '10 bln ${day.dayName} KH ${m.carb}%');
        expect(m.protein, inInclusiveRange(12, 18), reason: '10 bln ${day.dayName} Pro ${m.protein}%');
        expect(m.fat, inInclusiveRange(35, 50), reason: '10 bln ${day.dayName} Lemak ${m.fat}%');
      }

      // 12-23 bln: 30% ASI/Susu : 70% MPASI (uji lauk rendah lemak maupun campuran)
      final nut18 = PediatricNutritionCalculator.calculate(
        weightKg: 10.2, heightCm: 81.0, ageMonths: 18.0, sex: 'L');
      final plan18 = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 18.0,
        nutResult: nut18,
        selectedAnimalProteins: FoodExchangeRepository.allAnimalProtein,
      );
      for (final day in plan18) {
        expect(day.totalKcal, closeTo(nut18.targetEnergyKcal, nut18.targetEnergyKcal * 0.05));
        final m = day.macroEnergyPct;
        expect(m.carb, inInclusiveRange(40, 60), reason: '18 bln ${day.dayName} KH ${m.carb}%');
        expect(m.protein, inInclusiveRange(13, 18), reason: '18 bln ${day.dayName} Pro ${m.protein}%');
        expect(m.fat, inInclusiveRange(35, 50), reason: '18 bln ${day.dayName} Lemak ${m.fat}%');
      }

      // >=24 bln: makanan keluarga + 1-2 gelas susu
      final nut36 = PediatricNutritionCalculator.calculate(
        weightKg: 14.0, heightCm: 95.0, ageMonths: 36.0, sex: 'L');
      final plan36 = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: 36.0,
        nutResult: nut36,
        selectedAnimalProteins: FoodExchangeRepository.allAnimalProtein,
      );
      for (final day in plan36) {
        expect(day.totalKcal, closeTo(nut36.targetEnergyKcal, nut36.targetEnergyKcal * 0.05));
        final m = day.macroEnergyPct;
        expect(m.carb, inInclusiveRange(40, 60), reason: '36 bln ${day.dayName} KH ${m.carb}%');
        expect(m.protein, inInclusiveRange(13, 18), reason: '36 bln ${day.dayName} Pro ${m.protein}%');
        expect(m.fat, inInclusiveRange(35, 50), reason: '36 bln ${day.dayName} Lemak ${m.fat}%');
      }
    });
  });
}
