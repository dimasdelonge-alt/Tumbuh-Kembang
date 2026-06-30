import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../modules/growth/zscore_calculator.dart';
import '../modules/kpsp/kpsp_model.dart';
import '../modules/stimulation/stimulation.dart';
import '../modules/stimulation/stimulation_data.dart';
import 'report_builder.dart';

/// Membuat laporan PDF hasil pemeriksaan (Modul 16) dan menampilkan dialog
/// cetak / bagikan / simpan via paket printing.
class PdfReportService {
  static final _dateFmt = DateFormat('d MMMM yyyy', 'id_ID');

  /// Render PDF lalu buka layout/preview cetak bawaan sistem.
  static Future<void> generateAndPrint(ExamReportData data) async {
    final bytes = await _build(data);
    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: 'Laporan_${_safe(data.patient.name)}_'
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
    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: 'Panduan_Stimulasi_${_safe(patient.name)}$domainSuffix.pdf',
    );
  }

  static Future<Uint8List> _buildStimulationPdf(
    Patient patient,
    int ageMonths,
    KpspInterpretation interp,
    KpspDomain? filterDomain,
  ) async {
    final doc = pw.Document();
    
    // Pastikan data stimulasi terdaftar
    registerStimulationData();
    
    var tempBand = StimulationLibrary.bandFor(ageMonths);
    final isNextAge = interp.category == KpspResultCategory.sesuai;
    if (isNextAge && tempBand != null) {
      final bands = StimulationLibrary.bands;
      final idx = bands.indexOf(tempBand);
      if (idx >= 0 && idx < bands.length - 1) {
        tempBand = bands[idx + 1];
      }
    }
    final band = tempBand;

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
                              pw.Text('- ${act.title}',
                                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
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
                  pw.SizedBox(height: 40),
                  pw.Container(width: 120, child: pw.Divider(thickness: 0.8)),
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

  static Future<Uint8List> _build(ExamReportData data) async {
    final doc = pw.Document();

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
          if (data.growthRows.isNotEmpty) ...[
            _sectionTitle('Status Pertumbuhan (WHO)'),
            _growthTable(data),
            pw.SizedBox(height: 12),
          ],
          if (data.growthOutOfRange)
            _note(
                'Catatan: usia anak di luar rentang standar WHO 0-5 tahun; '
                'sebagian indikator berbasis umur tidak ditampilkan. '
                'Status gizi BB/TB memakai referensi CDC 2000 (Waterlow).'),
          if (data.kpsp != null) ...[
            pw.SizedBox(height: 4),
            _sectionTitle('Skrining Perkembangan (KPSP)'),
            _kpspSection(data.kpsp!),
            pw.SizedBox(height: 12),
          ],
          if (data.screenings.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            _sectionTitle('Skrining Lain'),
            ...data.screenings.map(_screeningSection),
            pw.SizedBox(height: 12),
          ],
          if (data.vision != null) ...[
            pw.SizedBox(height: 4),
            _sectionTitle('Tes Daya Lihat (TDL)'),
            _visionSection(data.vision!),
            pw.SizedBox(height: 12),
          ],
          if (data.cars != null) ...[
            pw.SizedBox(height: 4),
            _sectionTitle('CARS (Skrining Autisme)'),
            _carsSection(data.cars!),
            pw.SizedBox(height: 12),
          ],
          _conclusion(data),
          if (data.stimulation.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            _sectionTitle('Program Stimulasi (sesuai usia perkembangan)'),
            ...data.stimulation.map(_stimulationSection),
          ],
          pw.SizedBox(height: 24),
          _signature(data),
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
                pw.Text('- Usia Tinggi (Height Age): ${data.waterlow!.heightAgeMonths.toStringAsFixed(1)} bulan',
                    style: const pw.TextStyle(fontSize: 9)),
                pw.Text('- Berat Badan Ideal (BBI): ${data.waterlow!.idealWeightKg.toStringAsFixed(1)} kg',
                    style: const pw.TextStyle(fontSize: 9)),
                pw.Text('- BB Aktual / BBI: ${data.waterlow!.percentage.toStringAsFixed(1)}%',
                    style: const pw.TextStyle(fontSize: 9)),
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
        if (k.failedByDomain.isNotEmpty) ...[
          pw.SizedBox(height: 4),
          pw.Text('Item belum tercapai:',
              style: pw.TextStyle(
                  fontSize: 9, fontWeight: pw.FontWeight.bold)),
          ...k.failedByDomain.entries.map((e) => pw.Text(
              '- ${e.key.label}: no. ${e.value.join(', ')}',
              style: const pw.TextStyle(fontSize: 9))),
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
            ...s.flaggedItemTexts.map((t) => pw.Text('- $t',
                style: const pw.TextStyle(fontSize: 9))),
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
        pw.Text('Skor total: ${c.totalScore.toStringAsFixed(1)} (rentang 15-60)',
            style: const pw.TextStyle(fontSize: 10)),
        pw.Text('Hasil: ${c.categoryLabel.toUpperCase()}',
            style: pw.TextStyle(
                fontSize: 11, fontWeight: pw.FontWeight.bold)),
        pw.Text('Rekomendasi: ${c.recommendation}',
            style: const pw.TextStyle(fontSize: 9)),
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
                    pw.Text('- ${a.title}',
                        style: const pw.TextStyle(fontSize: 9)),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 8),
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
                  .map((f) => pw.Text('- $f',
                      style: const pw.TextStyle(fontSize: 10)))
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

  static pw.Widget _signature(ExamReportData data) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(_dateFmt.format(data.examDate),
                style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 48),
            pw.Container(width: 160, child: pw.Divider(thickness: 0.8)),
            pw.Text('Dokter Pemeriksa',
                style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
      ],
    );
  }
}
