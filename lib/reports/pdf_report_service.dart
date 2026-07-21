import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../modules/growth/zscore_calculator.dart';
import '../modules/kpsp/kpsp_model.dart';
import '../modules/redleaf/redleaf_data.dart';
import '../modules/redleaf/redleaf_model.dart';
import '../modules/stimulation/stimulation.dart';
import '../modules/stimulation/stimulation_data.dart';
import 'report_builder.dart';
import '../utils/config_storage.dart';

/// Membuat laporan PDF hasil pemeriksaan (Modul 16) dan menampilkan dialog
/// bagikan / simpan / cetak via paket printing (share sheet sistem).
class PdfReportService {
  static final _dateFmt = DateFormat('d MMMM yyyy', 'id_ID');

  /// Bagikan PDF lewat share sheet (WhatsApp, Bluetooth, Files, Print, dll).
  static Future<void> _presentPdf(Uint8List bytes, String name) async {
    final filename = name.endsWith('.pdf') ? name : '$name.pdf';
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }

  /// Bullet point digambar (bukan glyph font) agar tidak jadi kotak/X saat print.
  static pw.Widget _bulletItem(
    String text, {
    double fontSize = 9,
    PdfColor? color,
    PdfColor? bulletColor,
    pw.FontWeight? fontWeight,
  }) {
    final textColor = color ?? PdfColors.grey800;
    final dotColor = bulletColor ?? PdfColors.teal700;
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 1, bottom: 1),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 4,
            height: 4,
            margin: const pw.EdgeInsets.only(top: 3.5, right: 6),
            decoration: pw.BoxDecoration(
              color: dotColor,
              shape: pw.BoxShape.circle,
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              text,
              style: pw.TextStyle(
                fontSize: fontSize,
                color: textColor,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Render PDF Komprehensif (Gabungan Semua Modul & Hasil).
  static Future<void> generateAndPrint(ExamReportData data) async {
    final bytes = await _build(data);
    await _presentPdf(
      bytes,
      'Laporan_Gabungan_${_safe(data.patient.name)}_'
      '${DateFormat('yyyyMMdd').format(data.examDate)}.pdf',
    );
  }

  /// Cetak Laporan Antropometri & Status Gizi Saja.
  static Future<void> generateAndPrintGrowthOnly(ExamReportData data) async {
    final bytes = await _build(
      data,
      includeKpsp: false,
      includeScreenings: false,
      includeVision: false,
      includeCars: false,
      includeStimulation: false,
    );
    await _presentPdf(
      bytes,
      'Laporan_Antropometri_${_safe(data.patient.name)}_'
      '${DateFormat('yyyyMMdd').format(data.examDate)}.pdf',
    );
  }

  /// Cetak Laporan KPSP Saja.
  static Future<void> generateAndPrintKpspOnly(ExamReportData data) async {
    final bytes = await _build(
      data,
      includeGrowth: false,
      includeScreenings: false,
      includeVision: false,
      includeCars: false,
      includeStimulation: false,
    );
    await _presentPdf(
      bytes,
      'Laporan_KPSP_${_safe(data.patient.name)}_'
      '${DateFormat('yyyyMMdd').format(data.examDate)}.pdf',
    );
  }

  /// Cetak Laporan Denver II Saja.
  static Future<void> generateAndPrintDenverOnly(ExamReportData data) async {
    final bytes = await _build(
      data,
      includeGrowth: false,
      includeKpsp: false,
      includeScreenings: false,
      includeVision: false,
      includeCars: false,
      includeStimulation: false,
    );
    await _presentPdf(
      bytes,
      'Laporan_DenverII_${_safe(data.patient.name)}_'
      '${DateFormat('yyyyMMdd').format(data.examDate)}.pdf',
    );
  }

  /// Cetak Laporan Fenton 2013 Saja.
  static Future<void> generateAndPrintFentonOnly(ExamReportData data) async {
    final bytes = await _build(
      data,
      includeGrowth: false,
      includeKpsp: false,
      includeScreenings: false,
      includeVision: false,
      includeCars: false,
      includeStimulation: false,
    );
    await _presentPdf(
      bytes,
      'Laporan_Fenton2013_${_safe(data.patient.name)}_'
      '${DateFormat('yyyyMMdd').format(data.examDate)}.pdf',
    );
  }

  /// Cetak Laporan CDC 2000 & TPG Saja.
  static Future<void> generateAndPrintCdcOnly(ExamReportData data) async {
    final bytes = await _build(
      data,
      includeGrowth: false,
      includeKpsp: false,
      includeScreenings: false,
      includeVision: false,
      includeCars: false,
      includeStimulation: false,
    );
    await _presentPdf(
      bytes,
      'Laporan_CDC2000_TPG_${_safe(data.patient.name)}_'
      '${DateFormat('yyyyMMdd').format(data.examDate)}.pdf',
    );
  }

  /// Cetak Laporan Skrining & Redleaf Checklist Saja.
  static Future<void> generateAndPrintScreeningsOnly(ExamReportData data) async {
    final bytes = await _build(
      data,
      includeGrowth: false,
      includeKpsp: false,
      includeVision: false,
      includeCars: false,
      includeStimulation: false,
    );
    await _presentPdf(
      bytes,
      'Laporan_Skrining_${_safe(data.patient.name)}_'
      '${DateFormat('yyyyMMdd').format(data.examDate)}.pdf',
    );
  }

  /// Cetak panduan stimulasi khusus untuk orang tua berdasarkan domain KPSP yang kurang.
  static Future<void> generateAndPrintStimulation({
    required Patient patient,
    required int ageMonths,
    required KpspInterpretation interp,
    KpspDomain? filterDomain,
  }) async {
    final bytes = await _buildStimulationPdf(patient, ageMonths, interp, filterDomain);
    final domainSuffix = filterDomain != null ? '_${filterDomain.label}' : '_Semua_Stimulasi';
    await _presentPdf(
      bytes,
      'Panduan_Stimulasi_${_safe(patient.name)}$domainSuffix.pdf',
    );
  }

  /// Cetak panduan stimulasi Redleaf khusus untuk orang tua.
  static Future<void> generateAndPrintRedleafStimulation({
    required Patient patient,
    required RedleafAgeGroup ageGroup,
    required Map<String, bool> checkedItems,
    DateTime? examDate,
    int? childAgeMonths,
  }) async {
    final bytes = await _buildRedleafStimulationPdf(
      patient,
      ageGroup,
      checkedItems,
      examDate ?? DateTime.now(),
      childAgeMonths,
    );
    await _presentPdf(
      bytes,
      'Panduan_Stimulasi_Redleaf_${_safe(patient.name)}_${ageGroup.name}.pdf',
    );
  }

  static Future<Uint8List> _buildRedleafStimulationPdf(
    Patient patient,
    RedleafAgeGroup ageGroup,
    Map<String, bool> checkedItems,
    DateTime examDate,
    int? childAgeMonths,
  ) async {
    final doc = pw.Document();
    final doctorName = await ConfigStorage.getString('doctor_name') ?? '';
    final sigWidget = await _buildSimpleSignatureWidget(doctorName, examDate, patientName: patient.name, mrNo: patient.medicalRecordNo);

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(),
        ),
        build: (context) => [
          // Header Klinik Premium
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('PANDUAN STIMULASI TUMBUH KEMBANG (REDLEAF)',
                      style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.teal800)),
                  pw.Text('Berdasarkan Developmental Milestones (Karen Petty, PhD)',
                      style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700)),
                ],
              ),
              pw.Text(_dateFmt.format(examDate),
                  style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800)),
            ],
          ),
          pw.Divider(thickness: 1, color: PdfColors.teal700),
          pw.SizedBox(height: 8),

          // Identitas Pasien
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Nama Anak: ${patient.name}',
                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.Text('Kelompok Usia: ${ageGroup.name}',
                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
          pw.SizedBox(height: 14),

          // Render Domain & Tips Stimulasi
          ...ageGroup.domains.map((domain) {
            final filteredItems =
                filterRedleafItemsForAge(domain.items, childAgeMonths);

            if (filteredItems.isEmpty) return pw.SizedBox();
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 12),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.teal50,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.teal200, width: 0.8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Domain: ${domain.name}',
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.teal900,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  ...filteredItems.map((item) {
                    final key = '${ageGroup.id}_${domain.id}_${item.number}';
                    final isChecked = checkedItems[key] ?? false;

                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 8),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Text(
                                '${item.number}. ${item.title}',
                                style: pw.TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: pw.FontWeight.bold,
                                  color: isChecked ? PdfColors.teal800 : PdfColors.black,
                                ),
                              ),
                              pw.SizedBox(width: 6),
                              pw.Container(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: pw.BoxDecoration(
                                  color: isChecked ? PdfColors.green100 : PdfColors.orange100,
                                  borderRadius: pw.BorderRadius.circular(3),
                                ),
                                child: pw.Text(
                                  isChecked ? 'Tercapai' : 'Perlu Stimulasi',
                                  style: pw.TextStyle(
                                    fontSize: 7.5,
                                    fontWeight: pw.FontWeight.bold,
                                    color: isChecked ? PdfColors.green900 : PdfColors.orange900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            item.target,
                            style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey800),
                          ),
                          if (item.parentTips.isNotEmpty) ...[
                            pw.SizedBox(height: 3),
                            pw.Text(
                              'Yang dapat dilakukan orang tua / pengasuh:',
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.grey900),
                            ),
                            ...item.parentTips.map(
                              (tip) => pw.Padding(
                                padding: const pw.EdgeInsets.only(left: 8),
                                child: _bulletItem(
                                  tip,
                                  fontSize: 8,
                                  color: PdfColors.grey800,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }),

          pw.SizedBox(height: 20),
          // Signature
          sigWidget,
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(
            'Halaman ${context.pageNumber} dari ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ),
      ),
    );

    return doc.save();
  }

  static Future<Uint8List> _buildStimulationPdf(
    Patient patient,
    int ageMonths,
    KpspInterpretation interp,
    KpspDomain? filterDomain,
  ) async {
    final doc = pw.Document();
    final doctorName = await ConfigStorage.getString('doctor_name') ?? '';
    
    // Pastikan data stimulasi terdaftar
    registerStimulationData();
    
    final isNextAge = interp.category == KpspResultCategory.sesuai;
    // Jika KPSP sesuai (lulus target bulan X), berikan stimulasi untuk usia selanjutnya (band yang memuat X).
    // Jika KPSP kurang (gagal target bulan X), berikan stimulasi untuk mengejar target X (band yang memuat X - 1).
    final targetMonthForBand = isNextAge ? ageMonths : (ageMonths - 1);
    final band = StimulationLibrary.bandFor(targetMonthForBand);

    final domainsToPrint = filterDomain != null 
        ? [filterDomain] 
        : (isNextAge 
            ? KpspDomain.values.toList()
            : (interp.failedByDomain.isNotEmpty 
                ? interp.failedByDomain.keys.toList() 
                : KpspDomain.values.toList()));

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(),
        ),
        build: (context) => [
          // Header Klinik Premium
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('PANDUAN STIMULASI TUMBUH KEMBANG',
                      style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.teal800)),
                  pw.Text('Berdasarkan Buku Pedoman SDIDTK Kemenkes RI',
                      style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                ],
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: pw.BoxDecoration(
                  color: PdfColors.teal50,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text('Tumbuh Kembang',
                    style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.teal800)),
              ),
            ],
          ),
          pw.Divider(thickness: 1, color: PdfColors.teal800),
          pw.SizedBox(height: 12),

          // Identitas Pasien
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300, width: 0.8),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Nama Anak: ${patient.name}',
                              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                          pw.Text('Tanggal Lahir: ${_dateFmt.format(patient.birthDate)}',
                              style: const pw.TextStyle(fontSize: 9)),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Usia Skrining: $ageMonths bulan',
                              style: const pw.TextStyle(fontSize: 9)),
                          pw.Text('Tanggal Evaluasi: ${_dateFmt.format(DateTime.now())}',
                              style: const pw.TextStyle(fontSize: 9)),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 6),
                pw.Divider(thickness: 0.5, color: PdfColors.grey300),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Hasil KPSP: ${interp.yesCount} dari ${interp.total} "Ya" (${interp.category.label.toUpperCase()})',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: interp.category == KpspResultCategory.sesuai 
                        ? PdfColors.green800 
                        : (interp.category == KpspResultCategory.meragukan ? PdfColors.orange800 : PdfColors.red800),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // Judul bagian stimulasi
          pw.Text(
            filterDomain != null 
                ? 'Fokus Stimulasi Sektor: ${filterDomain.label} (Kelompok Usia ${band?.label ?? "$ageMonths bln"})'
                : 'Program Stimulasi yang Dianjurkan (Kelompok Usia ${band?.label ?? "$ageMonths bln"}${isNextAge ? " - Usia Di Atasnya" : ""})',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
          ),
          pw.SizedBox(height: 8),

          // List stimulasi per domain
          if (band != null) ...[
            ...domainsToPrint.map((dom) {
              final acts = band.forDomain(dom);
              if (acts.isEmpty) return pw.SizedBox();
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey50,
                  border: pw.Border(left: pw.BorderSide(color: PdfColors.teal700, width: 3)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Sektor Perkembangan: ${dom.label}',
                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
                    ),
                    pw.SizedBox(height: 6),
                    ...acts.map((act) => pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 4),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _bulletItem(
                                act.title,
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(left: 10, top: 2),
                                child: pw.Text(
                                  act.howTo,
                                  style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey800),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            }),
          ] else ...[
            pw.Text('Data stimulasi untuk kelompok usia ini tidak ditemukan.',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.red800)),
          ],

          pw.SizedBox(height: 12),
          // Ringkasan rekomendasi dokter/pedoman
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.teal50,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Rekomendasi Tindak Lanjut:',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                pw.SizedBox(height: 2),
                pw.Text(
                  interp.recommendation,
                  style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey900),
                ),
              ],
            ),
          ),
          
          pw.SizedBox(height: 32),
          // Tanda tangan dokter
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text('Dokter Pemeriksa,', style: const pw.TextStyle(fontSize: 9)),
                  pw.SizedBox(height: 35),
                  if (doctorName.isNotEmpty) ...[
                    pw.Text(doctorName, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 2),
                  ],
                  pw.Container(width: 140, child: pw.Divider(thickness: 0.8)),
                  pw.Text('Tanda Tangan & Stempel', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                ],
              ),
            ],
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(
            'Halaman ${context.pageNumber} dari ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ),
      ),
    );

    return doc.save();
  }

  static String _safe(String s) =>
      s.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_');

  /// Sanitasi teks Unicode agar kompatibel 100% dengan font Type1 (Helvetica) di PDF.
  static String _clean(String text) {
    if (text.isEmpty) return text;
    return text
        .replaceAll('–', '-')
        .replaceAll('—', '-')
        .replaceAll('•', '-')
        .replaceAll('≥', '>=')
        .replaceAll('≤', '<=')
        .replaceAll('±', '+/-')
        .replaceAll('×', 'x')
        .replaceAll('°', ' deg');
  }

  static Future<Uint8List> _build(
    ExamReportData data, {
    bool includeGrowth = true,
    bool includeKpsp = true,
    bool includeScreenings = true,
    bool includeVision = true,
    bool includeCars = true,
    bool includeStimulation = true,
  }) async {
    final doc = pw.Document();
    final doctorName = await ConfigStorage.getString('doctor_name') ?? '';
    final sigWidget = await _buildSignatureWidget(data, doctorName);

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(),
        ),
        build: (context) => [
          _header(data),
          pw.SizedBox(height: 12),
          _identity(data),
          pw.SizedBox(height: 16),
          if (includeGrowth && data.growthRows.isNotEmpty) ...[
            _sectionTitle('Status Pertumbuhan (WHO)'),
            _growthTable(data),
            pw.SizedBox(height: 12),
          ],
          if (includeGrowth && data.growthOutOfRange)
            _note(
                'Catatan: usia anak di luar rentang standar WHO 0-5 tahun; '
                'sebagian indikator berbasis umur tidak ditampilkan. '
                'Status gizi BB/TB memakai referensi CDC 2000 (Waterlow).'),
          if (includeKpsp && data.kpsp != null) ...[
            pw.SizedBox(height: 4),
            _sectionTitle('Skrining Perkembangan (KPSP)'),
            _kpspSection(data.kpsp!),
            pw.SizedBox(height: 12),
          ],
          if (includeScreenings && data.screenings.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            _sectionTitle('Skrining Perkembangan & Milestones'),
            ...data.screenings.map(_screeningSection),
            pw.SizedBox(height: 12),
          ],
          if (includeVision && data.vision != null) ...[
            pw.SizedBox(height: 4),
            _sectionTitle('Tes Daya Lihat (TDL)'),
            _visionSection(data.vision!),
            pw.SizedBox(height: 12),
          ],
          if (includeCars && data.cars != null) ...[
            pw.SizedBox(height: 4),
            _sectionTitle('CARS (Skrining Autisme)'),
            _carsSection(data.cars!),
            pw.SizedBox(height: 12),
          ],
          if (data.denver != null) ...[
            pw.SizedBox(height: 4),
            _sectionTitle('Skrining Perkembangan (Denver II)'),
            _denverSection(data.denver!),
            pw.SizedBox(height: 12),
          ],
          if (data.fenton != null) ...[
            pw.SizedBox(height: 4),
            _sectionTitle('Pertumbuhan Bayi Prematur (Kurva Fenton 2013)'),
            _fentonSection(data.fenton!),
            pw.SizedBox(height: 12),
          ],
          if (data.cdc != null) ...[
            pw.SizedBox(height: 4),
            _sectionTitle('Kurva Pertumbuhan CDC 2000 & Tinggi Potensi Genetik (TPG)'),
            _cdcSection(data.cdc!),
            pw.SizedBox(height: 12),
          ],
          if (data.nutrition != null) ...[
            pw.SizedBox(height: 4),
            _sectionTitle('Asuhan Nutrisi Pediatrik'),
            _nutritionSection(data.nutrition!),
            pw.SizedBox(height: 12),
          ],
          if (includeStimulation && data.stimulation.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            _sectionTitle('Program Stimulasi (sesuai usia perkembangan)'),
            ...data.stimulation.map(_stimulationSection),
          ],
          pw.SizedBox(height: 12),
          pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _conclusion(data),
                pw.SizedBox(height: 16),
                sigWidget,
              ],
            ),
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(
            'Halaman ${context.pageNumber} dari ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey),
          ),
        ),
      ),
    );

    return doc.save();
  }

  static pw.Widget _header(ExamReportData data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('LAPORAN SKRINING TUMBUH KEMBANG ANAK',
            style: pw.TextStyle(
                fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.Divider(thickness: 1.2),
        pw.Text('Tanggal pemeriksaan: ${_dateFmt.format(data.examDate)}',
            style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  static pw.Widget _identity(ExamReportData data) {
    final p = data.patient;
    final age = data.age;
    final left = <List<String>>[
      ['Nama', p.name],
      ['Jenis kelamin', p.sex == 'L' ? 'Laki-laki' : 'Perempuan'],
      ['Tanggal lahir', AgeCalculator.formatDate(p.birthDate)],
    ];
    final right = <List<String>>[
      ['No. RM', p.medicalRecordNo ?? '-'],
      ['Usia kronologis', age.chronologicalLabel],
      if (age.correctionApplied)
        ['Usia koreksi', age.correctedLabel]
      else
        ['Orang tua', p.parentName ?? '-'],
    ];

    pw.Widget col(List<List<String>> rows) => pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: rows
                .map((r) => pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 1),
                      child: pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                                text: '${r[0]}: ',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.TextSpan(
                                text: r[1],
                                style: const pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        );

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(children: [col(left), col(right)]),
    );
  }

  static pw.Widget _sectionTitle(String title) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Text(title,
            style: pw.TextStyle(
                fontSize: 12, fontWeight: pw.FontWeight.bold)),
      );

  static pw.Widget _growthTable(ExamReportData data) {
    final hasWaterlow = data.growthRows.any((r) => r.indicator == GrowthIndicator.weightForLengthHeight && data.age.chronologicalMonths > 60);
    final headers = ['Indikator', 'Nilai', hasWaterlow ? 'Z / %' : 'Z-score', '-2SD', 'Median', '+2SD', 'Status'];
    double? heightCm;
    for (final row in data.growthRows) {
      if (row.indicator == GrowthIndicator.lengthHeightForAge) {
        heightCm = row.value;
        break;
      }
    }
    final rows = data.growthRows.map((r) {
      final isWaterlow = r.indicator == GrowthIndicator.weightForLengthHeight && data.age.chronologicalMonths > 60;
      final scoreStr = isWaterlow
          ? '${r.zScore.toStringAsFixed(1)}%'
          : ((r.zScore * 100).round() / 100).toStringAsFixed(2);

      final isBmi = r.indicator == GrowthIndicator.bmiForAge;
      final medianStr = (isBmi && heightCm != null)
          ? '${r.median.toStringAsFixed(1)} (BBI: ${(r.median * (heightCm / 100) * (heightCm / 100)).toStringAsFixed(1)} kg)'
          : r.median.toStringAsFixed(1);

      return [
        isWaterlow ? '${r.indicator.code} (Waterlow)' : r.indicator.code,
        _valueLabel(r.indicator, r.value),
        scoreStr,
        isWaterlow ? '-' : r.sd2neg.toStringAsFixed(1),
        isWaterlow ? r.median.toStringAsFixed(1) : medianStr,
        isWaterlow ? '-' : r.sd2pos.toStringAsFixed(1),
        r.status.label,
      ];
    }).toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.TableHelper.fromTextArray(
          headers: headers,
          data: rows,
          headerStyle:
              pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 8),
          headerDecoration:
              const pw.BoxDecoration(color: PdfColors.teal50),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            6: pw.Alignment.centerLeft,
          },
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
        ),
        if (data.waterlow != null) ...[
          pw.SizedBox(height: 6),
          pw.Container(
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
              borderRadius: pw.BorderRadius.circular(4),
              color: PdfColors.grey50,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Analisis Waterlow (CDC 2000):',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 2),
                _bulletItem(
                  'Usia Tinggi (Height Age): ${data.waterlow!.heightAgeMonths.toStringAsFixed(1)} bulan',
                  fontSize: 9,
                  color: PdfColors.black,
                ),
                _bulletItem(
                  'Berat Badan Ideal (BBI): ${data.waterlow!.idealWeightKg.toStringAsFixed(1)} kg',
                  fontSize: 9,
                  color: PdfColors.black,
                ),
                _bulletItem(
                  'BB Aktual / BBI: ${data.waterlow!.percentage.toStringAsFixed(1)}%',
                  fontSize: 9,
                  color: PdfColors.black,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  static String _valueLabel(GrowthIndicator ind, double v) {
    switch (ind) {
      case GrowthIndicator.weightForAge:
      case GrowthIndicator.weightForLengthHeight:
        return '${v.toStringAsFixed(1)} kg';
      case GrowthIndicator.lengthHeightForAge:
      case GrowthIndicator.headCircumferenceForAge:
        return '${v.toStringAsFixed(1)} cm';
      case GrowthIndicator.bmiForAge:
        return v.toStringAsFixed(1);
    }
  }

  static pw.Widget _kpspSection(ReportKpsp k) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Form usia ${k.formAgeMonths} bulan | '
            'Skor: ${k.yesCount}/${k.total} "Ya"',
            style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 2),
        pw.Text('Hasil: ${k.category.label.toUpperCase()}',
            style: pw.TextStyle(
                fontSize: 11, fontWeight: pw.FontWeight.bold)),
        if (k.developmentalAges != null) ...[
          pw.SizedBox(height: 4),
          pw.Text('Usia Perkembangan Per Domain (Asesmen GDD):',
              style: pw.TextStyle(
                  fontSize: 9, fontWeight: pw.FontWeight.bold)),
          ...k.developmentalAges!.entries.map(
            (e) => _bulletItem(
              '${e.key.label}: ${e.value == 0 ? "< 3" : e.value} bulan',
              fontSize: 9,
              color: PdfColors.black,
            ),
          ),
        ] else if (k.failedByDomain.isNotEmpty) ...[
          pw.SizedBox(height: 4),
          pw.Text('Item belum tercapai:',
              style: pw.TextStyle(
                  fontSize: 9, fontWeight: pw.FontWeight.bold)),
          ...k.failedByDomain.entries.map(
            (e) => _bulletItem(
              '${e.key.label}: no. ${e.value.join(', ')}',
              fontSize: 9,
              color: PdfColors.black,
            ),
          ),
        ],
        pw.SizedBox(height: 4),
        pw.Text('Rekomendasi: ${k.recommendation}',
            style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }

  static pw.Widget _screeningSection(ReportScreening s) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('${s.name} - skor ${s.score}/${s.total}',
              style: const pw.TextStyle(fontSize: 10)),
          pw.Text('Hasil: ${s.levelLabel.toUpperCase()}',
              style: pw.TextStyle(
                  fontSize: 11, fontWeight: pw.FontWeight.bold)),
          pw.Text(s.interpretation, style: const pw.TextStyle(fontSize: 9)),
          if (s.flaggedItemTexts.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text('Perilaku menonjol:',
                style: pw.TextStyle(
                    fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ...s.flaggedItemTexts.map(
              (t) => _bulletItem(t, fontSize: 9, color: PdfColors.black),
            ),
          ],
          pw.Text('Rekomendasi: ${s.recommendation}',
              style: const pw.TextStyle(fontSize: 9)),
        ],
      ),
    );
  }

  static pw.Widget _visionSection(ReportVision v) {
    String eye(int? line, String status) => line == null
        ? '$status (tidak terbaca)'
        : '$status (baris $line)';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Mata kanan: ${eye(v.rightEyeLine, v.rightStatus)}',
            style: const pw.TextStyle(fontSize: 10)),
        pw.Text('Mata kiri: ${eye(v.leftEyeLine, v.leftStatus)}',
            style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 2),
        pw.Text('Hasil: ${v.interpretation}',
            style: pw.TextStyle(
                fontSize: 10, fontWeight: pw.FontWeight.bold)),
        pw.Text('Rekomendasi: ${v.recommendation}',
            style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }

  static pw.Widget _carsSection(ReportCars c) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Skor total: ${c.totalScore.toStringAsFixed(1)} / 60,0',
            style: const pw.TextStyle(fontSize: 10)),
        pw.Text('Kategori: ${c.categoryLabel.toUpperCase()}',
            style:
                pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
        pw.Text('Rekomendasi: ${c.recommendation}',
            style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }

  static pw.Widget _denverSection(ReportDenver d) {
    final isAlert = d.globalResultLabel.contains('SUSPEK') || d.globalResultLabel.contains('UNTESTABLE');
    final color = isAlert ? PdfColors.red800 : PdfColors.green800;
    final bg = isAlert ? PdfColors.red50 : PdfColors.green50;

    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: bg,
        borderRadius: pw.BorderRadius.circular(4),
        border: pw.Border.all(color: color, width: 0.8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Denver II: ${d.globalResultLabel}',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: color,
                ),
              ),
              pw.Text(
                'Usia Uji: ${d.ageInMonths.toStringAsFixed(1)} Bulan${d.usedCorrectedAge ? " (Koreksi)" : ""}',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Rincian: ${d.cautionsCount} Caution (Peringatan) | ${d.delaysCount} Delay (Keterlambatan)',
            style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey900),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'Rekomendasi: ${d.recommendation}',
            style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey800),
          ),
        ],
      ),
    );
  }

  static pw.Widget _fentonSection(ReportFenton f) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.blue200, width: 0.8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Usia Gestasi saat Lahir: ${f.gestationalWeeksAtBirth} minggu',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
              ),
              pw.Text(
                'PMA Usia Uji: ${f.pmaWeeks.toStringAsFixed(1)} minggu',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Status: ${f.pmaStatusLabel}',
            style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey900),
          ),
          pw.SizedBox(height: 4),
          pw.Row(
            children: [
              if (f.weightKg != null)
                pw.Text('BB: ${f.weightKg!.toStringAsFixed(2)} kg   ', style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
              if (f.lengthCm != null)
                pw.Text('PB: ${f.lengthCm!.toStringAsFixed(1)} cm   ', style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
              if (f.headCircumferenceCm != null)
                pw.Text('LK: ${f.headCircumferenceCm!.toStringAsFixed(1)} cm', style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
            ],
          ),
          if (f.chartImageBytes != null) ...[
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Image(
                pw.MemoryImage(f.chartImageBytes!),
                height: 310,
                fit: pw.BoxFit.contain,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _cdcSection(ReportCdc c) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.teal50,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.teal200, width: 0.8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Usia Uji: ${c.ageYears.toStringAsFixed(1)} Tahun',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
              ),
              if (c.tpg != null)
                pw.Text(
                  'TPG: ${c.tpg!.label}',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900),
                ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Evaluasi: ${c.evaluation}',
            style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey900),
          ),
          if (c.chartImageBytes != null) ...[
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Image(
                pw.MemoryImage(c.chartImageBytes!),
                height: 330,
                fit: pw.BoxFit.contain,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _nutritionSection(ReportNutrition n) {
    final borderColor = n.needsIntervention ? PdfColors.red200 : PdfColors.orange200;
    final bgColor = n.needsIntervention ? PdfColors.red50 : PdfColors.orange50;
    final titleColor = n.needsIntervention ? PdfColors.red900 : PdfColors.orange900;

    // Group feeding rules by category
    final categories = ['Jadwal', 'Lingkungan', 'Prosedur'];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // ── Bagian 1: Kebutuhan Nutrisi Harian ──
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            color: bgColor,
            borderRadius: pw.BorderRadius.circular(6),
            border: pw.Border.all(color: borderColor, width: 0.8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Kebutuhan Nutrisi Harian (RDA Permenkes RI 28/2019 x BB Ideal)',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: titleColor,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(3),
                },
                children: [
                  _nutritionRow('Energi Target', '${n.targetEnergyKcal.toStringAsFixed(0)} kkal/hari'),
                  _nutritionRow('Protein Target', '${n.targetProteinGram.toStringAsFixed(1)} g/hari'),
                  _nutritionRow('Cairan Harian', '${n.dailyFluidMl.toStringAsFixed(0)} ml/hari (Holliday-Segar)'),
                  _nutritionRow('BB Ideal (W_ideal)', '${n.idealWeightKg.toStringAsFixed(1)} kg'),
                  _nutritionRow('Kelompok AKG', n.akgGroupLabel),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Container(
                padding: const pw.EdgeInsets.all(4),
                decoration: pw.BoxDecoration(
                  color: n.needsIntervention ? PdfColors.red100 : PdfColors.green50,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(
                  _clean(n.interventionAdvice),
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: n.needsIntervention ? pw.FontWeight.bold : pw.FontWeight.normal,
                    color: n.needsIntervention ? PdfColors.red900 : PdfColors.green900,
                  ),
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),

        // ── Bagian 2: Panduan Pemberian Makan & Resep Menu ──
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            color: PdfColors.green50,
            borderRadius: pw.BorderRadius.circular(6),
            border: pw.Border.all(color: PdfColors.green200, width: 0.8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                _clean('Panduan Pemberian Makan: ${n.mpasiLabel}'),
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.green900),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(3),
                },
                children: [
                  _nutritionRow('Tekstur', n.mpasiTexture),
                  _nutritionRow('Frekuensi', n.mpasiFrequency),
                  _nutritionRow('Porsi', n.mpasiPortion),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Text(_clean(n.mpasiNotes), style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700)),
              if (n.mpasiMenuExamples.isNotEmpty) ...[
                pw.SizedBox(height: 6),
                pw.Text(
                  'Contoh Menu MPASI (Kemenkes RI 2023):',
                  style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.green800),
                ),
                pw.SizedBox(height: 2),
                ...n.mpasiMenuExamples.map((menu) => pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 8, top: 1),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('- ', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.green700)),
                      pw.Expanded(
                        child: pw.Text(_clean(menu), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey900)),
                      ),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),
        pw.SizedBox(height: 8),

        // ── Bagian 3: Suplementasi ──
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            color: PdfColors.purple50,
            borderRadius: pw.BorderRadius.circular(6),
            border: pw.Border.all(color: PdfColors.purple200, width: 0.8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Suplementasi (Rekomendasi IDAI)',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.purple900),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(3),
                },
                children: [
                  _nutritionRow('Zat Besi (Fe)', n.ironDose),
                  _nutritionRow('Vitamin D', n.vitDDose),
                ],
              ),
              if (n.ironNotes.isNotEmpty) ...[
                pw.SizedBox(height: 3),
                pw.Text(_clean('Catatan Fe: ${n.ironNotes}'), style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700)),
              ],
              if (n.vitDNotes.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                pw.Text(_clean('Catatan Vit D: ${n.vitDNotes}'), style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700)),
              ],
            ],
          ),
        ),
        pw.SizedBox(height: 8),

        // ── Bagian 4: Basic Feeding Rules IDAI ──
        if (n.feedingRules.isNotEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: PdfColors.blue200, width: 0.8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Basic Feeding Rules (IDAI)',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
                ),
                pw.SizedBox(height: 4),
                ...categories.map((cat) {
                  final rules = n.feedingRules.where((r) => r.category == cat).toList();
                  if (rules.isEmpty) return pw.SizedBox();
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 4),
                      pw.Text(
                        cat.toUpperCase(),
                        style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
                      ),
                      ...rules.map((r) => pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 6, top: 2),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('${r.number}. ', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.blue700)),
                                pw.Expanded(
                                  child: pw.Text(_clean(r.title), style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey900)),
                                ),
                              ],
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: 12),
                              child: pw.Text(_clean(r.description), style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700)),
                            ),
                          ],
                        ),
                      )),
                    ],
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }

  static pw.TableRow _nutritionRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 1),
          child: pw.Text(_clean(label), style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 1),
          child: pw.Text(_clean(value), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey900)),
        ),
      ],
    );
  }

  static pw.Widget _stimulationSection(ReportStimulationItem s) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${s.domainLabel} - setara ${s.developmentalAgeMonths} bln '
            '(stimulasi ${s.bandLabel})',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          ...s.activities.map((a) => pw.Padding(
                padding: const pw.EdgeInsets.only(top: 2, left: 4),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _bulletItem(a.title, fontSize: 9, color: PdfColors.black),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10),
                      child: pw.Text(a.howTo,
                          style: const pw.TextStyle(
                              fontSize: 8, color: PdfColors.grey700)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  static pw.Widget _conclusion(ExamReportData data) {
    final flags = <String>[];
    for (final r in data.growthRows) {
      if (r.status.isAlert) flags.add(r.status.label);
    }
    if (data.kpsp != null &&
        data.kpsp!.category != KpspResultCategory.sesuai) {
      flags.add('KPSP ${data.kpsp!.category.label}');
    }
    if (data.denver != null && (data.denver!.delaysCount > 0 || data.denver!.cautionsCount >= 2)) {
      flags.add('Denver II: ${data.denver!.globalResultLabel}');
    }
    for (final s in data.screenings) {
      if (s.severity > 0) flags.add('${s.name}: ${s.levelLabel}');
    }
    if (data.vision != null && data.vision!.hasImpairment) {
      flags.add('TDL: kemungkinan gangguan daya lihat');
    }
    if (data.cars != null && data.cars!.severity > 0) {
      flags.add('CARS: ${data.cars!.categoryLabel}');
    }

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: flags.isEmpty ? PdfColors.green50 : PdfColors.orange50,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Kesimpulan',
              style: pw.TextStyle(
                  fontSize: 11, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          if (flags.isEmpty)
            pw.Text(
                'Tidak ditemukan tanda bahaya (red flag) pada pemeriksaan ini.',
                style: const pw.TextStyle(fontSize: 10))
          else
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: flags
                  .map((f) => _bulletItem(f, fontSize: 10, color: PdfColors.black))
                  .toList(),
            ),
        ],
      ),
    );
  }

  static pw.Widget _note(String text) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Text(text,
            style: pw.TextStyle(
                fontSize: 9,
                fontStyle: pw.FontStyle.italic,
                color: PdfColors.grey700)),
      );

  static Future<pw.Widget> _buildSignatureWidget(ExamReportData data, String doctorName) {
    return _buildSimpleSignatureWidget(
      doctorName,
      data.examDate,
      patientName: data.patient.name,
      mrNo: data.patient.medicalRecordNo,
    );
  }

  static Future<pw.Widget> _buildSimpleSignatureWidget(
    String doctorName,
    DateTime examDate, {
    String? patientName,
    String? mrNo,
  }) async {
    final docSip = await ConfigStorage.getString('doctor_sip') ?? '';
    final sigType = await ConfigStorage.getString('doctor_signature_type') ?? 'qr_generated';
    final sigBase64 = await ConfigStorage.getString('doctor_signature_base64');

    final nameText = doctorName.isNotEmpty ? doctorName : 'Dokter Pemeriksa';
    final sipText = docSip.isNotEmpty ? docSip : '';

    final qrText = 'VERIFIKASI DOKUMEN SKRINING TUMBUH KEMBANG\n'
        '${patientName != null ? "Pasien: $patientName (RM: ${mrNo ?? "-"})\n" : ""}'
        'Tanggal Periksa: ${_dateFmt.format(examDate)}\n'
        'Disahkan Digital Oleh: $nameText\n'
        '${sipText.isNotEmpty ? "$sipText\n" : ""}'
        'Status: Dokumen Sah & Terverifikasi Digital';

    pw.Widget signatureGraphic;
    if (sigType == 'custom_image' && sigBase64 != null && sigBase64.isNotEmpty) {
      try {
        final bytes = base64Decode(sigBase64);
        signatureGraphic = pw.Image(
          pw.MemoryImage(bytes),
          width: 90,
          height: 48,
          fit: pw.BoxFit.contain,
        );
      } catch (_) {
        signatureGraphic = pw.BarcodeWidget(
          barcode: pw.Barcode.qrCode(),
          data: qrText,
          width: 48,
          height: 48,
        );
      }
    } else {
      signatureGraphic = pw.BarcodeWidget(
        barcode: pw.Barcode.qrCode(),
        data: qrText,
        width: 48,
        height: 48,
      );
    }

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(_dateFmt.format(examDate),
                style: const pw.TextStyle(fontSize: 8.5)),
            pw.SizedBox(height: 4),
            pw.Text('Dokter Pemeriksa,',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            signatureGraphic,
            pw.SizedBox(height: 4),
            pw.Text(nameText,
                style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold)),
            if (sipText.isNotEmpty) ...[
              pw.SizedBox(height: 1),
              pw.Text(sipText,
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800)),
            ],
          ],
        ),
      ],
    );
  }
}
