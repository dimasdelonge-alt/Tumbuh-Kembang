import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbang/data/database.dart';
import 'package:tumbang/modules/growth/who_growth_data.dart';
import 'package:tumbang/modules/nutrition/food_exchange_data.dart';
import 'package:tumbang/modules/nutrition/nutrition_calculator.dart';
import 'package:tumbang/modules/nutrition/weekly_meal_plan_generator.dart';
import 'package:tumbang/reports/weekly_meal_plan_pdf_builder.dart';

/// Mengekstrak seluruh teks terkompresi (zlib) maupun tidak terkompresi dari PDF.
String _extractPdfTextContent(Uint8List bytes) {
  final raw = latin1.decode(bytes);
  final buf = StringBuffer(raw);
  final streamReg = RegExp(r'stream\r?\n([\s\S]*?)endstream');
  for (final match in streamReg.allMatches(raw)) {
    final body = match.group(1);
    if (body == null || body.isEmpty) continue;
    final bodyBytes = latin1.encode(body);
    try {
      buf.write(latin1.decode(zlib.decode(bodyBytes), allowInvalid: true));
    } catch (_) {
      // Coba tanpa trailing newline jika stream berakhir dengan \r\n sebelum endstream
      var end = bodyBytes.length;
      while (end > 0 && (bodyBytes[end - 1] == 10 || bodyBytes[end - 1] == 13)) {
        end--;
      }
      if (end > 0 && end < bodyBytes.length) {
        try {
          buf.write(latin1.decode(zlib.decode(bodyBytes.sublist(0, end)), allowInvalid: true));
        } catch (_) {}
      }
    }
  }
  return buf.toString();
}

/// Regresi: PDF meal plan 7 hari harus berhasil dibangun untuk semua
/// kelompok usia setelah takaran dihitung dari target kalori (tabel
/// bertambah baris total & rasio, teks takaran lebih panjang) tanpa terpotong.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await initializeDateFormatting('id_ID', null);
    await WhoGrowthData.instance.ensureLoaded();
  });

  Patient patient(double ageMo, {String name = 'Anak Uji Nama Panjang Sekali'}) => Patient(
        id: 'pdf-uji',
        name: name,
        birthDate: DateTime.now().subtract(Duration(days: (ageMo * 30.4).round())),
        sex: 'P',
        createdAt: DateTime.now(),
        isPremature: false,
        hasDownSyndrome: false,
      );

  test('buildPdf berhasil untuk semua bracket usia + catch-up + semua bahan', () async {
    for (final age in [3.0, 7.0, 10.0, 13.0, 14.0, 30.0, 48.0]) {
      final nut = PediatricNutritionCalculator.calculate(
        weightKg: age == 13.0 ? 7.9 : 8.05,
        heightCm: age == 13.0 ? 73.0 : 75.0,
        ageMonths: age,
        sex: 'P',
        isMalnourished: age == 10.0 || age == 13.0,
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

  test('PDF Hana (13 bln) mengalir MultiPage (>=4 halaman) dan memuat seluruh 7 hari Senin-Minggu', () async {
    final nut = PediatricNutritionCalculator.calculate(
      weightKg: 7.9,
      heightCm: 73.0,
      ageMonths: 13.0,
      sex: 'P',
      isMalnourished: true,
    );
    final plan = WeeklyMealPlanGenerator.generate7DayPlan(
      ageMonths: 13.0,
      nutResult: nut,
      selectedCarbs: FoodExchangeRepository.carbsList,
      selectedAnimalProteins: FoodExchangeRepository.allAnimalProtein,
      selectedPlantProteins: FoodExchangeRepository.plantProteinList,
      selectedVeggies: FoodExchangeRepository.veggiesList,
      selectedFruits: FoodExchangeRepository.fruitsList,
    );
    final bytes = await WeeklyMealPlanPdfBuilder.buildPdf(
      patient: patient(13.0, name: 'Hana'),
      nutResult: nut,
      weeklyPlan: plan,
      selectedCarbs: FoodExchangeRepository.carbsList,
      selectedAnimalProteins: FoodExchangeRepository.allAnimalProtein,
      selectedPlantProteins: FoodExchangeRepository.plantProteinList,
      selectedVeggies: FoodExchangeRepository.veggiesList,
      selectedFruits: FoodExchangeRepository.fruitsList,
      customNote:
          'Evaluasi ulang berat badan dan asupan makan dalam 2 minggu. Pastikan lauk hewani diberikan setiap makan utama dan hindari minuman manis tambahan.',
    );

    final rawPdf = latin1.decode(bytes);
    final pageCount = RegExp(r'/Type\s*/Page\b(?!s)').allMatches(rawPdf).length;
    expect(pageCount, greaterThanOrEqualTo(4),
        reason: 'MultiPage harus mengalirkan seluruh 7 hari (>3 halaman) agar tidak ter-clip');

    final pdfText = _extractPdfTextContent(bytes);
    for (final day in ['SENIN', 'SELASA', 'RABU', 'KAMIS', 'JUMAT', 'SABTU', 'MINGGU']) {
      expect(pdfText, contains(day), reason: 'Hari $day harus muncul di PDF');
    }
  });
}
