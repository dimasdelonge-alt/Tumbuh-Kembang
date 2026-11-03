import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbang/data/database.dart';
import 'package:tumbang/modules/growth/who_growth_data.dart';
import 'package:tumbang/modules/nutrition/food_exchange_data.dart';
import 'package:tumbang/modules/nutrition/nutrition_calculator.dart';
import 'package:tumbang/modules/nutrition/weekly_meal_plan_generator.dart';
import 'package:tumbang/reports/weekly_meal_plan_pdf_builder.dart';

/// Regresi: PDF meal plan 7 hari harus berhasil dibangun untuk semua
/// kelompok usia setelah takaran dihitung dari target kalori (tabel
/// bertambah baris total & rasio, teks takaran lebih panjang).
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await initializeDateFormatting('id_ID', null);
    await WhoGrowthData.instance.ensureLoaded();
  });

  Patient patient(double ageMo) => Patient(
        id: 'pdf-uji',
        name: 'Anak Uji Nama Panjang Sekali',
        birthDate: DateTime.now().subtract(Duration(days: (ageMo * 30.4).round())),
        sex: 'P',
        createdAt: DateTime.now(),
        isPremature: false,
        hasDownSyndrome: false,
      );

  test('buildPdf berhasil untuk semua bracket usia + catch-up + semua bahan', () async {
    for (final age in [3.0, 7.0, 10.0, 14.0, 30.0, 48.0]) {
      final nut = PediatricNutritionCalculator.calculate(
        weightKg: 8.05,
        heightCm: 75.0,
        ageMonths: age,
        sex: 'P',
        isMalnourished: age == 10.0,
      );
      final plan = WeeklyMealPlanGenerator.generate7DayPlan(
        ageMonths: age,
        nutResult: nut,
        selectedCarbs: FoodExchangeRepository.carbsList,
        selectedAnimalProteins: FoodExchangeRepository.allAnimalProtein,
        selectedPlantProteins: FoodExchangeRepository.plantProteinList,
        selectedVeggies: FoodExchangeRepository.veggiesList,
        selectedFruits: FoodExchangeRepository.fruitsList,
      );
      final bytes = await WeeklyMealPlanPdfBuilder.buildPdf(
        patient: patient(age),
        nutResult: nut,
        weeklyPlan: plan,
        selectedCarbs: FoodExchangeRepository.carbsList,
        selectedAnimalProteins: FoodExchangeRepository.allAnimalProtein,
        selectedPlantProteins: FoodExchangeRepository.plantProteinList,
        selectedVeggies: FoodExchangeRepository.veggiesList,
        selectedFruits: FoodExchangeRepository.fruitsList,
      );
      expect(bytes.length, greaterThan(5000), reason: 'PDF usia $age harus terisi');
    }
  });
}
