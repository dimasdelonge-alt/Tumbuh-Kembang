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
    List<FoodExchangeItem>? selectedCarbs,
    List<FoodExchangeItem>? selectedAnimalProteins,
    List<FoodExchangeItem>? selectedPlantProteins,
    List<FoodExchangeItem>? selectedVeggies,
    List<FoodExchangeItem>? selectedFruits,
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

    final carbs = selectedCarbs ?? (selectedCarb != null ? [selectedCarb] : FoodExchangeRepository.carbsList.take(3).toList());
    final animals = selectedAnimalProteins ?? (selectedAnimalProtein != null ? [selectedAnimalProtein] : FoodExchangeRepository.allAnimalProtein.take(3).toList());
    final plants = selectedPlantProteins ?? (selectedPlantProtein != null ? [selectedPlantProtein] : FoodExchangeRepository.plantProteinList.take(2).toList());
    final veggies = selectedVeggies ?? FoodExchangeRepository.veggiesList.take(3).toList();
    final fruits = selectedFruits ?? FoodExchangeRepository.fruitsList.take(3).toList();

    // Helper: small page-number footer
    pw.Widget pageFooter(pw.Context ctx, int pageNum, int totalPages) {
      return pw.Container(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'Halaman $pageNum / $totalPages',
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
        ),
      );
    }

    // Helper: mini header for continuation pages
    pw.Widget miniHeader() {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: pw.BoxDecoration(
          color: PdfColors.teal800,
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              _clean('RENCANA MAKAN SEMINGGU - ${patient.name}'),
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            ),
            pw.Text(
              _clean(_dateFmt.format(now)),
              style: pw.TextStyle(fontSize: 8, color: PdfColors.teal100),
            ),
          ],
        ),
      );
    }

    const pageMargin = pw.EdgeInsets.all(24);
    const totalPages = 3;

    // ========================
    // HALAMAN 1: Header + Info + SENIN, SELASA, RABU
    // ========================
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pageMargin,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
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
                    pw.Expanded(
                      child: pw.Column(
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
                            _clean('Rujukan Utama: WHO Guideline (2023) & Kemenkes RI | Asuhan Nutrisi Pediatrik'),
                            style: pw.TextStyle(fontSize: 8.5, color: PdfColors.teal50),
                          ),
                        ],
                      ),
                    ),
                    pw.Text(
                      _clean(_dateFmt.format(now)),
                      style: pw.TextStyle(fontSize: 9, color: PdfColors.white),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 6),

              // --- IDENTITAS & TARGET GIZI ---
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: nutResult.needsCatchUp ? PdfColors.orange50 : PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(4),
                  border: pw.Border.all(color: nutResult.needsCatchUp ? PdfColors.deepOrange300 : PdfColors.grey300),
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
                          pw.Text(_clean('BB Ideal (BBI): ${nutResult.idealWeightLabel}  |  Usia Tinggi: ${nutResult.heightAgeLabel}'), style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey800)),
                        ],
                      ),
                    ),
                    pw.Container(width: 1, height: 42, color: nutResult.needsCatchUp ? PdfColors.deepOrange200 : PdfColors.grey400),
                    pw.SizedBox(width: 8),
                    pw.Expanded(
                      flex: 5,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          if (nutResult.needsCatchUp) ...[
                            pw.Text(
                              _clean('Patokan Kalori: ${nutResult.targetEnergyKcal.round()} kcal/hari (Catch-Up Growth)'),
                              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.deepOrange900),
                            ),
                            pw.Text(
                              _clean('Patokan Protein: ${nutResult.targetProteinGram.toStringAsFixed(1)} g/hari (Kejar Tumbuh)'),
                              style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.deepOrange800),
                            ),
                            pw.Text(
                              _clean('RDA Standar: ${nutResult.eerKcal.round()} kcal | Cairan: ${nutResult.fluidMl.round()} mL'),
                              style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
                            ),
                          ] else ...[
                            pw.Text(
                              _clean('Target Kalori: ${nutResult.eerKcal.round()} kcal/hari (RDA x BBI)'),
                              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
                            ),
                            pw.Text(
                              _clean('Target Protein: ${nutResult.proteinGrams.toStringAsFixed(1)} g/hari'),
                              style: const pw.TextStyle(fontSize: 8.5),
                            ),
                            pw.Text(
                              _clean('Cairan Pemeliharaan: ${nutResult.fluidMl.round()} mL/hari'),
                              style: const pw.TextStyle(fontSize: 8.5),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 6),

              miniHeader(),
              pw.SizedBox(height: 6),

              pw.Text(
                _clean('MATRIKS JADWAL MENU MAKAN 7 HARI (SENIN - MINGGU)'),
                style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
              ),
              pw.SizedBox(height: 4),

              // SENIN, SELASA, RABU (3 hari)
              ...weeklyPlan.take(3).map((dayPlan) => _buildDayPlanTable(dayPlan)),

              pw.Spacer(),
              pageFooter(context, 1, totalPages),
            ],
          );
        },
      ),
    );

    // ========================
    // HALAMAN 2: KAMIS, JUMAT, SABTU
    // ========================
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pageMargin,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              miniHeader(),
              pw.SizedBox(height: 6),

              pw.Text(
                _clean('MATRIKS JADWAL MENU MAKAN 7 HARI (SENIN - MINGGU) - Lanjutan'),
                style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
              ),
              pw.SizedBox(height: 4),

              // KAMIS, JUMAT, SABTU (3 hari)
              ...weeklyPlan.skip(3).take(3).map((dayPlan) => _buildDayPlanTable(dayPlan)),

              pw.Spacer(),
              pageFooter(context, 2, totalPages),
            ],
          );
        },
      ),
    );

    // ========================
    // HALAMAN 3: MINGGU + TABEL PENUKAR + FEEDING RULES + TTD
    // ========================
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pageMargin,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              miniHeader(),
              pw.SizedBox(height: 6),

              pw.Text(
                _clean('MATRIKS JADWAL MENU MAKAN 7 HARI (SENIN - MINGGU) - Lanjutan'),
                style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
              ),
              pw.SizedBox(height: 4),

              // MINGGU (1 hari)
              _buildDayPlanTable(weeklyPlan.last),

              pw.SizedBox(height: 10),

              // --- TABEL MATRIKS BAHAN MAKANAN PENUKAR SETARA ---
              pw.Text(
                _clean('TABEL MATRIKS BAHAN MAKANAN PENUKAR SETARA (DAPAT SALING DIGANTI)'),
                style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
              ),
              pw.SizedBox(height: 4),

              _buildExchangeMatrixTable(
                carbs: carbs,
                animals: animals,
                plants: plants,
                veggies: veggies,
                fruits: fruits,
              ),

              pw.SizedBox(height: 8),

              // --- ATURAN MAKAN (FEEDING RULES) ---
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  color: nutResult.needsCatchUp ? PdfColors.deepOrange50 : PdfColors.teal50,
                  borderRadius: pw.BorderRadius.circular(3),
                  border: pw.Border.all(color: nutResult.needsCatchUp ? PdfColors.deepOrange200 : PdfColors.teal200, width: 0.5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      _clean(nutResult.needsCatchUp
                          ? 'PRINSIP PEMBERIAN MAKAN CATCH-UP GROWTH & WHO GUIDELINE 2023'
                          : 'PRINSIP ATURAN PEMBERIAN MAKAN (WHO GUIDELINE 2023 & FEEDING RULES)'),
                      style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: nutResult.needsCatchUp ? PdfColors.deepOrange900 : PdfColors.teal900),
                    ),
                    pw.SizedBox(height: 2),
                    if (nutResult.needsCatchUp) ...[
                      pw.Text(_clean('1. Patokan Target Kejar Tumbuh: Berikan ${nutResult.targetEnergyKcal.round()} kcal/hari & Protein ${nutResult.targetProteinGram.toStringAsFixed(1)} g/hari.'), style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold, color: PdfColors.deepOrange900)),
                      pw.Text(_clean('2. Densitas Energi Tinggi: Tambahkan 1-2 sdt minyak sehat/santan/mentega di setiap porsi makan utama.'), style: const pw.TextStyle(fontSize: 7)),
                      pw.Text(_clean('3. Wajib Protein Hewani Harian (WHO 2023): Berikan porsi penuh lauk hewani kaya zat besi di setiap jam makan utama.'), style: const pw.TextStyle(fontSize: 7)),
                      pw.Text(_clean('4. Bebas Gula Tambahan & Minuman Manis: Dilarang memberi minuman manis (SSB), pemanis sintetis, atau garam berlebih.'), style: const pw.TextStyle(fontSize: 7)),
                    ] else ...[
                      pw.Text(_clean('1. Jadwal Terstruktur: Berikan makanan utama & selingan pada jam teratur (jarak 2-3 jam).'), style: const pw.TextStyle(fontSize: 7)),
                      pw.Text(_clean('2. Wajib Protein Hewani & Buah/Sayur Harian (WHO 2023): Sajikan lauk hewani (telur/hati/daging/ikan) dan sayur/buah setiap hari.'), style: const pw.TextStyle(fontSize: 7)),
                      pw.Text(_clean('3. Responsive Feeding (WHO 2023): Peka rasa kenyang/lapar anak, dorong makan mandiri, suasana hangat tanpa paksaan/gadget.'), style: const pw.TextStyle(fontSize: 7)),
                      pw.Text(_clean('4. Bebas Gula Tambahan & Batasi Susu: Tanpa minuman manis (SSB). Susu hewan murni/ASI (WHO tidak sarankan formula lanjutan).'), style: const pw.TextStyle(fontSize: 7)),
                    ],
                    if (customNote != null && customNote.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Text(_clean('Catatan Dokter: $customNote'), style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold, color: PdfColors.red900)),
                    ],
                  ],
                ),
              ),

              pw.SizedBox(height: 8),

              // --- DAFTAR PUSTAKA ---
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey50,
                  borderRadius: pw.BorderRadius.circular(3),
                  border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(_clean('DAFTAR PUSTAKA / REFERENSI'), style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                    pw.SizedBox(height: 3),
                    pw.Text(_clean('1. UKK Nutrisi & Penyakit Metabolik IDAI. Rekomendasi Praktik Pemberian Makan Berbasis Bukti pd Bayi & Batita di Indonesia. Jakarta: IDAI; 2023.'), style: const pw.TextStyle(fontSize: 6)),
                    pw.Text(_clean('2. WHO. Guideline for Complementary Feeding of Infants and Young Children 6-23 Months of Age. Geneva: WHO; 2023.'), style: const pw.TextStyle(fontSize: 6)),
                    pw.Text(_clean('3. Kementerian Kesehatan RI. Buku Resep Makanan Lokal Balita & Ibu Hamil. Jakarta: Kemenkes RI; 2023.'), style: const pw.TextStyle(fontSize: 6)),
                    pw.Text(_clean('4. UKK Nutrisi & Penyakit Metabolik IDAI. Buku Ajar Nutrisi Pediatrik dan Penyakit Metabolik Jilid I. Jakarta: IDAI; 2011.'), style: const pw.TextStyle(fontSize: 6)),
                    pw.Text(_clean('5. Kementerian Kesehatan RI. Tabel Komposisi Pangan Indonesia (TKPI). Jakarta: Kemenkes RI; 2017.'), style: const pw.TextStyle(fontSize: 6)),
                  ],
                ),
              ),

              pw.SizedBox(height: 8),

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
                        pw.Image(pw.MemoryImage(base64Decode(sigBase64)), height: 30, fit: pw.BoxFit.contain)
                      else
                        pw.BarcodeWidget(barcode: pw.Barcode.qrCode(), data: 'MEALWEEK-${patient.id}-${now.millisecondsSinceEpoch}', width: 30, height: 30),
                      pw.SizedBox(height: 2),
                      pw.Text(_clean(docName), style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                      if (docSip.isNotEmpty)
                        pw.Text(_clean(docSip), style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700)),
                    ],
                  ),
                ],
              ),

              pw.Spacer(),
              pageFooter(context, 3, totalPages),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  /// Membuat tabel matriks 4-kolom per hari yang rapi & bergaris
  /// Membuat tabel matriks 4-kolom per hari yang rapi & bergaris (tidak akan terpisah antar halaman)
  static pw.Widget _buildDayPlanTable(SingleDayMealPlan dayPlan) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Table(
        border: pw.TableBorder.all(color: PdfColors.teal700, width: 0.5),
        children: [
          // Row 0: Header Hari & Tema (100% Lebar)
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.teal800),
            children: [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                child: pw.Text(
                  _clean('${dayPlan.dayName.toUpperCase()} — ${dayPlan.theme}'),
                  style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                ),
              ),
            ],
          ),
          // Row 1: Tabel Matriks 4-Kolom Sesi Makan
          pw.TableRow(
            children: [
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.3),
                columnWidths: const {
                  0: pw.FlexColumnWidth(1.1), // Waktu
                  1: pw.FlexColumnWidth(2.1), // Sesi
                  2: pw.FlexColumnWidth(4.8), // Menu & Deskripsi
                  3: pw.FlexColumnWidth(2.0), // Takaran Porsi
                },
                children: dayPlan.sessions.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final s = entry.value;
                  final isEven = idx % 2 == 0;
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(color: isEven ? PdfColors.white : PdfColors.grey50),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(_clean(s.time), style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(_clean(s.sessionName), style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(_clean('${s.menuName}: ${s.description}'), style: const pw.TextStyle(fontSize: 6.5)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(3),
                        child: pw.Text(_clean(s.portionUrt), style: pw.TextStyle(fontSize: 6.5, color: PdfColors.grey900, fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Membuat Tabel Matriks Bahan Makanan Penukar Setara di bawah variasi menu
  static pw.Widget _buildExchangeMatrixTable({
    required List<FoodExchangeItem> carbs,
    required List<FoodExchangeItem> animals,
    required List<FoodExchangeItem> plants,
    required List<FoodExchangeItem> veggies,
    required List<FoodExchangeItem> fruits,
  }) {
    String formatList(List<FoodExchangeItem> items) {
      if (items.isEmpty) return '-';
      return items.map((i) => '${i.name} (${i.displayUrt})').join(' - ');
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.teal700, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(2.3),
        1: pw.FlexColumnWidth(5.7),
        2: pw.FlexColumnWidth(2.0),
      },
      children: [
        // Table Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.teal800),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean('GOLONGAN BAHAN'), style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean('BAHAN TERSEDIA & OPSI PENUKAR SETARA'), style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean('NILAI GIZI SETARA'), style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
            ),
          ],
        ),
        // Row 1: Karbohidrat
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.white),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean('Karbohidrat'), style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean(formatList(carbs)), style: const pw.TextStyle(fontSize: 6.5)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean('1 Satuan =\n175 Kal, 4g Pro, 40g KH'), style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey800)),
            ),
          ],
        ),
        // Row 2: Protein Hewani
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.teal50),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean('Protein Hewani'), style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean(formatList(animals)), style: const pw.TextStyle(fontSize: 6.5)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean('1 Satuan =\n50-75 Kal, 7g Pro'), style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey800)),
            ),
          ],
        ),
        // Row 3: Protein Nabati
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.white),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean('Protein Nabati'), style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean(formatList(plants)), style: const pw.TextStyle(fontSize: 6.5)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean('1 Satuan =\n75 Kal, 5g Pro, 7g KH'), style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey800)),
            ),
          ],
        ),
        // Row 4: Sayuran
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.teal50),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean('Sayuran A & B'), style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean(formatList(veggies)), style: const pw.TextStyle(fontSize: 6.5)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean('1 Satuan (100g) =\n25-50 Kal, 1-3g Pro'), style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey800)),
            ),
          ],
        ),
        // Row 5: Buah-buahan
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.white),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean('Buah-buahan'), style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean(formatList(fruits)), style: const pw.TextStyle(fontSize: 6.5)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(_clean('1 Satuan =\n50 Kal, 12g KH'), style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey800)),
            ),
          ],
        ),
      ],
    );
  }

  /// Tampilkan Preview PDF Interaktif (Preview dulu sebelum simpan/share)
  static void showPdfPreview({
    required BuildContext context,
    required Patient patient,
    required NutritionCalculationResult nutResult,
    required List<SingleDayMealPlan> weeklyPlan,
    List<FoodExchangeItem>? selectedCarbs,
    List<FoodExchangeItem>? selectedAnimalProteins,
    List<FoodExchangeItem>? selectedPlantProteins,
    List<FoodExchangeItem>? selectedVeggies,
    List<FoodExchangeItem>? selectedFruits,
    FoodExchangeItem? selectedCarb,
    FoodExchangeItem? selectedAnimalProtein,
    FoodExchangeItem? selectedPlantProtein,
    String? customNote,
  }) {
    final title = 'Pratinjau PDF Meal Plan (${patient.name})';
    final filename = 'Meal_Plan_Seminggu_${patient.name.replaceAll(' ', '_')}.pdf';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: Colors.teal.shade800,
            foregroundColor: Colors.white,
          ),
          body: PdfPreview(
            build: (format) => buildPdf(
              patient: patient,
              nutResult: nutResult,
              weeklyPlan: weeklyPlan,
              selectedCarbs: selectedCarbs,
              selectedAnimalProteins: selectedAnimalProteins,
              selectedPlantProteins: selectedPlantProteins,
              selectedVeggies: selectedVeggies,
              selectedFruits: selectedFruits,
              selectedCarb: selectedCarb,
              selectedAnimalProtein: selectedAnimalProtein,
              selectedPlantProtein: selectedPlantProtein,
              customNote: customNote,
            ),
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
  }

  /// Bagikan / Print PDF Meal Plan 7 Hari
  static Future<void> shareWeeklyMealPlanPdf({
    required Patient patient,
    required NutritionCalculationResult nutResult,
    required List<SingleDayMealPlan> weeklyPlan,
    List<FoodExchangeItem>? selectedCarbs,
    List<FoodExchangeItem>? selectedAnimalProteins,
    List<FoodExchangeItem>? selectedPlantProteins,
    List<FoodExchangeItem>? selectedVeggies,
    List<FoodExchangeItem>? selectedFruits,
    FoodExchangeItem? selectedCarb,
    FoodExchangeItem? selectedAnimalProtein,
    FoodExchangeItem? selectedPlantProtein,
    String? customNote,
  }) async {
    final pdfBytes = await buildPdf(
      patient: patient,
      nutResult: nutResult,
      weeklyPlan: weeklyPlan,
      selectedCarbs: selectedCarbs,
      selectedAnimalProteins: selectedAnimalProteins,
      selectedPlantProteins: selectedPlantProteins,
      selectedVeggies: selectedVeggies,
      selectedFruits: selectedFruits,
      selectedCarb: selectedCarb,
      selectedAnimalProtein: selectedAnimalProtein,
      selectedPlantProtein: selectedPlantProtein,
      customNote: customNote,
    );
    final filename = 'Meal_Plan_Seminggu_${patient.name.replaceAll(' ', '_')}.pdf';
    await Printing.sharePdf(bytes: pdfBytes, filename: filename);
  }
}
