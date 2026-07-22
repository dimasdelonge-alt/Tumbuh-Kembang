import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../modules/nutrition/nutrition_calculator.dart';
import '../modules/nutrition/food_exchange_data.dart';
import '../modules/nutrition/weekly_meal_plan_generator.dart';
import '../utils/config_storage.dart';

/// Pembuat & pencetak Laporan PDF Meal Plan Seminggu (7 Hari) untuk Orang Tua.
class WeeklyMealPlanPdfBuilder {
  static final _dateFmt = DateFormat('d MMMM yyyy', 'id_ID');

  static String _clean(String text) {
    return text
        .replaceAll('–', '-')
        .replaceAll('—', '-')
        .replaceAll('•', '-')
        .replaceAll('≥', '>=')
        .replaceAll('≤', '<=')
        .replaceAll('±', '+/-')
        .replaceAll('×', 'x')
        .replaceAll('’', "'")
        .replaceAll('“', '"')
        .replaceAll('”', '"');
  }

  /// Membuat dokumen PDF 7 Hari Rencana Makan Anak
  static Future<Uint8List> buildPdf({
    required Patient patient,
    required NutritionCalculationResult nutResult,
    required List<SingleDayMealPlan> weeklyPlan,
    FoodExchangeItem? selectedCarb,
    FoodExchangeItem? selectedAnimalProtein,
    FoodExchangeItem? selectedPlantProtein,
    String? customNote,
  }) async {
    final doc = pw.Document();
    final now = DateTime.now();

    final docName = await ConfigStorage.getString('doctor_name') ?? 'dr. Spesialis Anak';
    final docSip = await ConfigStorage.getString('doctor_sip') ?? '';
    final sigType = await ConfigStorage.getString('doctor_signature_type') ?? 'qr_generated';
    final sigBase64 = await ConfigStorage.getString('doctor_signature_base64');

    final age = AgeCalculator.calculate(
      birthDate: patient.birthDate,
      examDate: now,
      gestationalWeeks: patient.gestationalWeeks,
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return [
            // --- HEADER KLINIK ---
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.teal800,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        _clean('RENCANA & JADWAL MAKAN SEMINGGU (7 HARI: SENIN - MINGGU)'),
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        _clean('Asuhan Nutrisi Pediatrik & Daftar Bahan Makanan Penukar Ahli Gizi'),
                        style: pw.TextStyle(fontSize: 8.5, color: PdfColors.teal50),
                      ),
                    ],
                  ),
                  pw.Text(
                    _clean(_dateFmt.format(now)),
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.white),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 8),

            // --- IDENTITAS & TARGET GIZI ---
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(4),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 5,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(_clean('Nama Anak: ${patient.name}'), style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold)),
                        pw.Text(_clean('Usia: ${age.chronologicalLabel} (${patient.sex == 'L' ? 'Laki-laki' : 'Perempuan'})'), style: const pw.TextStyle(fontSize: 8.5)),
                        pw.Text(_clean('Berat: ${nutResult.weightKg} kg  |  Tinggi: ${nutResult.heightCm} cm'), style: const pw.TextStyle(fontSize: 8.5)),
                      ],
                    ),
                  ),
                  pw.Container(width: 1, height: 35, color: PdfColors.grey400),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    flex: 5,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(_clean('Target Kalori: ${nutResult.eerKcal.round()} kcal/hari'), style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                        pw.Text(_clean('Target Protein: ${nutResult.proteinGrams.toStringAsFixed(1)} g/hari'), style: const pw.TextStyle(fontSize: 8.5)),
                        pw.Text(_clean('Cairan Pemeliharaan: ${nutResult.fluidMl.round()} mL/hari'), style: const pw.TextStyle(fontSize: 8.5)),
                        if (nutResult.needsCatchUp)
                          pw.Text(_clean('Catch-up Growth: ${nutResult.catchUpEnergyKcal?.round()} kcal/hari'), style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.deepOrange900)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 8),

            // --- PANDUAN BAHAN MAKANAN PENUKAR PILIHAN ---
            if (selectedCarb != null || selectedAnimalProtein != null || selectedPlantProtein != null) ...[
              pw.Text(
                _clean('BAHAN MAKANAN PENUKAR PILIHAN KELUARGA'),
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
              ),
              pw.SizedBox(height: 2),
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  color: PdfColors.teal50,
                  borderRadius: pw.BorderRadius.circular(4),
                  border: pw.Border.all(color: PdfColors.teal200),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    if (selectedCarb != null)
                      pw.Text(_clean('Karbohidrat: ${selectedCarb.name} (${selectedCarb.urt})'), style: const pw.TextStyle(fontSize: 7.5)),
                    if (selectedAnimalProtein != null)
                      pw.Text(_clean('Protein Hewani: ${selectedAnimalProtein.name} (${selectedAnimalProtein.urt})'), style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold)),
                    if (selectedPlantProtein != null)
                      pw.Text(_clean('Protein Nabati: ${selectedPlantProtein.name} (${selectedPlantProtein.urt})'), style: const pw.TextStyle(fontSize: 7.5)),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),
            ],

            // --- TABEL JADWAL MEAL PLAN 7 HARI (SENIN S/D MINGGU) ---
            pw.Text(
              _clean('VARIASE MENU MAKAN 7 HARI (SENIN - MINGGU)'),
              style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
            ),
            pw.SizedBox(height: 4),

            ...weeklyPlan.map((dayPlan) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      color: PdfColors.teal100,
                      child: pw.Text(
                        _clean('${dayPlan.dayName.toUpperCase()} - ${dayPlan.theme}'),
                        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Column(
                        children: dayPlan.sessions.map((s) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: 32,
                                  child: pw.Text(_clean(s.time), style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.SizedBox(
                                  width: 75,
                                  child: pw.Text(_clean(s.sessionName), style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                                ),
                                pw.Expanded(
                                  child: pw.Text(_clean('${s.menuName}: ${s.description}'), style: const pw.TextStyle(fontSize: 7)),
                                ),
                                pw.SizedBox(
                                  width: 90,
                                  child: pw.Text(_clean('Porsi: ${s.portionUrt}'), style: const pw.TextStyle(fontSize: 6.5, color: PdfColors.grey800)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }),

            pw.SizedBox(height: 6),

            // --- ATURAN MAKAN & TTD ---
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 6,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(_clean('PRINSIP ATURAN PEMBERIAN MAKAN (FEEDING RULES)'), style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                      pw.SizedBox(height: 2),
                      pw.Text(_clean('1. Jadwal Terstruktur: Berikan makanan utama & selingan pada jam teratur (jarak 2-3 jam).'), style: const pw.TextStyle(fontSize: 7)),
                      pw.Text(_clean('2. Utamakan Protein Hewani (telur/hati/daging/ikan) di setiap jam makan utama.'), style: const pw.TextStyle(fontSize: 7)),
                      pw.Text(_clean('3. Lingkungan Menyenangkan: Makan bersama di meja makan tanpa TV/HP, max 30 menit.'), style: const pw.TextStyle(fontSize: 7)),
                      if (customNote != null && customNote.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        pw.Text(_clean('Catatan Dokter: $customNote'), style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold, color: PdfColors.red900)),
                      ],
                    ],
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  flex: 4,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(_clean('Dokter Spesialis Anak'), style: const pw.TextStyle(fontSize: 8)),
                      pw.SizedBox(height: 2),
                      if (sigType == 'custom_image' && sigBase64 != null && sigBase64.isNotEmpty)
                        pw.Image(pw.MemoryImage(base64Decode(sigBase64)), height: 30, fit: pw.BoxFit.contain)
                      else
                        pw.BarcodeWidget(barcode: pw.Barcode.qrCode(), data: 'MEALWEEK-${patient.id}-${now.millisecondsSinceEpoch}', width: 30, height: 30),
                      pw.SizedBox(height: 2),
                      pw.Text(_clean(docName), style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                      if (docSip.isNotEmpty)
                        pw.Text(_clean(docSip), style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700)),
                    ],
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );

    return doc.save();
  }

  /// Bagikan / Print PDF Meal Plan 7 Hari
  static Future<void> shareWeeklyMealPlanPdf({
    required Patient patient,
    required NutritionCalculationResult nutResult,
    required List<SingleDayMealPlan> weeklyPlan,
    FoodExchangeItem? selectedCarb,
    FoodExchangeItem? selectedAnimalProtein,
    FoodExchangeItem? selectedPlantProtein,
    String? customNote,
  }) async {
    final pdfBytes = await buildPdf(
      patient: patient,
      nutResult: nutResult,
      weeklyPlan: weeklyPlan,
      selectedCarb: selectedCarb,
      selectedAnimalProtein: selectedAnimalProtein,
      selectedPlantProtein: selectedPlantProtein,
      customNote: customNote,
    );
    final filename = 'Meal_Plan_Seminggu_${patient.name.replaceAll(' ', '_')}.pdf';
    await Printing.sharePdf(bytes: pdfBytes, filename: filename);
  }
}
