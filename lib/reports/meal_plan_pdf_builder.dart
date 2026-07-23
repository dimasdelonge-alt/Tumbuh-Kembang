import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../modules/nutrition/nutrition_calculator.dart';
import '../modules/nutrition/meal_plan_data.dart';
import '../utils/config_storage.dart';

/// Pembuat & pencetak Laporan PDF Meal Plan untuk Orang Tua (Modul Nutrisi).
class MealPlanPdfBuilder {
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

  /// Membuat dokumen PDF 1 Halaman A4 Rencana Makan Anak
  static Future<Uint8List> buildPdf({
    required Patient patient,
    required NutritionCalculationResult nutResult,
    required List<MealScheduleItem> schedule,
    required PortionGuide portionGuide,
    required List<MpasiRecipe> recipes,
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
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // --- HEADER KLINIK / APPMED ---
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.teal700,
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          _clean('PANDUAN & RENCANA JADWAL MAKAN ANAK (MEAL PLAN)'),
                          style: pw.TextStyle(
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          _clean('Asuhan Nutrisi Pediatrik & Rekomendasi Konseling Gizi'),
                          style: pw.TextStyle(fontSize: 9, color: PdfColors.teal50),
                        ),
                      ],
                    ),
                    pw.Text(
                      _clean(_dateFmt.format(now)),
                      style: pw.TextStyle(fontSize: 10, color: PdfColors.white),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // --- IDENTITAS ANNAK & TARGET GIZI ---
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
                          pw.Text(
                            _clean('Nama Anak: ${patient.name}'),
                            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            _clean('Usia: ${age.chronologicalLabel} (${patient.sex == 'L' ? 'Laki-laki' : 'Perempuan'})'),
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                          pw.Text(
                            _clean('Berat: ${nutResult.weightKg} kg  |  Tinggi: ${nutResult.heightCm} cm'),
                            style: const pw.TextStyle(fontSize: 9),
                          ),
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
                          pw.Text(
                            _clean('Target Kalori: ${nutResult.eerKcal.round()} kcal/hari'),
                            style: pw.TextStyle(
                                fontSize: 9.5,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.teal900),
                          ),
                          pw.Text(
                            _clean('Target Protein: ${nutResult.proteinGrams.toStringAsFixed(1)} g/hari'),
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                          pw.Text(
                            _clean('Kebutuhan Cairan: ${nutResult.fluidMl.round()} mL/hari'),
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                          if (nutResult.needsCatchUp)
                            pw.Text(
                              _clean('Catch-up Growth: ${nutResult.catchUpEnergyKcal?.round()} kcal/hari'),
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.deepOrange900),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // --- TABEL JADWAL MAKAN HARIAN TERSTRUKTUR ---
              pw.Text(
                _clean('1. JADWAL MAKAN TERSTRUKTUR HARIAN'),
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                columnWidths: {
                  0: const pw.FixedColumnWidth(45),
                  1: const pw.FixedColumnWidth(110),
                  2: const pw.FlexColumnWidth(),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.teal50),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(_clean('Waktu'), style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(_clean('Sesi Makan'), style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(_clean('Panduan Porsi & Opsi Menu'), style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...schedule.map(
                    (item) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(_clean(item.time), style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(_clean(item.title), style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(_clean(item.recommendation), style: const pw.TextStyle(fontSize: 8)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              // --- PANDUAN PORSI & BAHAN MAKANAN ---
              pw.Text(
                _clean('2. PANDUAN PORSI & KOMPOSISI BAHAN (${portionGuide.ageGroupLabel})'),
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800),
              ),
              pw.SizedBox(height: 4),
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(_clean('- Tekstur Makanan: ${portionGuide.textureLabel}'), style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 2),
                    pw.Text(_clean('- Karbohidrat (Nasi/Beras/Kentang): ${portionGuide.carbs}'), style: const pw.TextStyle(fontSize: 8)),
                    pw.Text(_clean('- Protein Hewani (Telur/Daging/Hati/Ikan): ${portionGuide.animalProtein}'), style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                    pw.Text(_clean('- Protein Nabati (Tahu/Tempe): ${portionGuide.plantProtein}'), style: const pw.TextStyle(fontSize: 8)),
                    pw.Text(_clean('- Sayur & Buah: ${portionGuide.veggiesFruit}'), style: const pw.TextStyle(fontSize: 8)),
                    pw.Text(_clean('- Lemak Tambahan (Minyak/Santan/Butter): ${portionGuide.fatAdded}'), style: const pw.TextStyle(fontSize: 8)),
                    pw.Text(_clean('- Susu / Cairan: ${portionGuide.milkFluid}'), style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // --- ATURAN MAKAN (FEEDING RULES) ---
              pw.Container(
                padding: const pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                  color: PdfColors.teal50,
                  borderRadius: pw.BorderRadius.circular(3),
                  border: pw.Border.all(color: PdfColors.teal200, width: 0.5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      _clean('3. PRINSIP ATURAN PEMBERIAN MAKAN (FEEDING RULES)'),
                      style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
                    ),
                    pw.SizedBox(height: 2),
                    ...MealPlanRepository.feedingRules.take(4).map(
                      (rule) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 1),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 3,
                              height: 3,
                              margin: const pw.EdgeInsets.only(top: 2.5, right: 4),
                              decoration: const pw.BoxDecoration(color: PdfColors.teal700, shape: pw.BoxShape.circle),
                            ),
                            pw.Expanded(
                              child: pw.Text(_clean(rule), style: const pw.TextStyle(fontSize: 6.5)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (customNote != null && customNote.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Text(_clean('Catatan Dokter: $customNote'), style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold, color: PdfColors.red900)),
                    ],
                  ],
                ),
              ),

              pw.SizedBox(height: 5),

              // --- DAFTAR PUSTAKA ---
              pw.Container(
                padding: const pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey50,
                  borderRadius: pw.BorderRadius.circular(3),
                  border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(_clean('DAFTAR PUSTAKA / REFERENSI'), style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                    pw.SizedBox(height: 2),
                    pw.Text(_clean('1. UKK Nutrisi & Penyakit Metabolik IDAI. Rekomendasi Praktik Pemberian Makan Berbasis Bukti pd Bayi & Batita di Indonesia. Jakarta: IDAI; 2023.'), style: const pw.TextStyle(fontSize: 6)),
                    pw.Text(_clean('2. WHO. Complementary Feeding: Family Foods for Breastfed Children. Geneva: WHO; 2000.'), style: const pw.TextStyle(fontSize: 6)),
                    pw.Text(_clean('3. Kementerian Kesehatan RI. Tabel Komposisi Pangan Indonesia (TKPI). Jakarta: Kemenkes RI; 2017.'), style: const pw.TextStyle(fontSize: 6)),
                    pw.Text(_clean('4. UKK Nutrisi & Penyakit Metabolik IDAI. Buku Ajar Nutrisi Pediatrik dan Penyakit Metabolik Jilid I. Jakarta: IDAI; 2011.'), style: const pw.TextStyle(fontSize: 6)),
                  ],
                ),
              ),

              pw.SizedBox(height: 5),

              // --- TTD DOKTER ---
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(_clean('Dokter Spesialis Anak'), style: const pw.TextStyle(fontSize: 8)),
                      pw.SizedBox(height: 2),
                      if (sigType == 'custom_image' && sigBase64 != null && sigBase64.isNotEmpty)
                        pw.Image(
                          pw.MemoryImage(base64Decode(sigBase64)),
                          height: 28,
                          fit: pw.BoxFit.contain,
                        )
                      else
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: 'MEALPLAN-${patient.id}-${now.millisecondsSinceEpoch}',
                          width: 28,
                          height: 28,
                        ),
                      pw.SizedBox(height: 2),
                      pw.Text(_clean(docName), style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                      if (docSip.isNotEmpty)
                        pw.Text(_clean(docSip), style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  /// Bagikan / Print PDF Meal Plan via HP/Desktop (dengan preview jika context tersedia)
  static Future<void> shareMealPlanPdf({
    required Patient patient,
    required NutritionCalculationResult nutResult,
    required List<MealScheduleItem> schedule,
    required PortionGuide portionGuide,
    required List<MpasiRecipe> recipes,
    String? customNote,
    BuildContext? context,
  }) async {
    final pdfBytes = await buildPdf(
      patient: patient,
      nutResult: nutResult,
      schedule: schedule,
      portionGuide: portionGuide,
      recipes: recipes,
      customNote: customNote,
    );
    final filename = 'Meal_Plan_${patient.name.replaceAll(' ', '_')}.pdf';
    if (context != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text('Pratinjau PDF Meal Plan (${patient.name})'),
              backgroundColor: Colors.teal.shade800,
              foregroundColor: Colors.white,
            ),
            body: PdfPreview(
              build: (format) async => pdfBytes,
              allowPrinting: true,
              allowSharing: true,
              canChangeOrientation: false,
              canChangePageFormat: false,
              pdfFileName: filename,
              previewPageMargin: const EdgeInsets.all(12),
            ),
          ),
        ),
      );
    } else {
      await Printing.sharePdf(bytes: pdfBytes, filename: filename);
    }
  }
}
