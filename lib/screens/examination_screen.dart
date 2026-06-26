import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../data/repository.dart';
import '../modules/kpsp/kpsp_model.dart';
import '../modules/screening/instrument.dart';
import '../modules/screening/data/kmme_data.dart';
import '../modules/screening/data/tdd_data.dart';
import '../modules/screening/data/mchat_data.dart';
import '../modules/screening/data/gpph_data.dart';
import '../modules/screening/data/sppahi_data.dart';
import '../reports/pdf_report_service.dart';
import '../reports/report_builder.dart';
import '../modules/growth/zscore_calculator.dart';
import 'growth_screen.dart';
import 'kpsp_screen.dart';
import 'screening_screen.dart';
import 'tdl_screen.dart';
import 'cars_screen.dart';
import 'stimulation_screen.dart';

/// Hub satu pemeriksaan/kunjungan: pilih tanggal lalu kerjakan modul
/// (antropometri & KPSP). Membuat baris Examination bila belum ada.
class ExaminationScreen extends StatefulWidget {
  final Patient patient;
  final Examination? existing;
  const ExaminationScreen({super.key, required this.patient, this.existing});

  @override
  State<ExaminationScreen> createState() => _ExaminationScreenState();
}

class _ExaminationScreenState extends State<ExaminationScreen> {
  late DateTime _examDate;
  String? _examId;

  @override
  void initState() {
    super.initState();
    _examDate = widget.existing?.examDate ?? DateTime.now();
    _examId = widget.existing?.id;
  }

  AgeResult get _age => AgeCalculator.calculate(
        birthDate: widget.patient.birthDate,
        examDate: _examDate,
        gestationalWeeks: widget.patient.gestationalWeeks,
      );

  /// Pastikan baris Examination ada sebelum membuka modul.
  Future<String> _ensureExam() async {
    if (_examId != null) return _examId!;
    final repo = context.read<AppRepository>();
    final id = await repo.insertExamination(
      ExaminationsCompanion.insert(
        patientId: widget.patient.id,
        examDate: _examDate,
      ),
    );
    setState(() => _examId = id);
    return id;
  }

  @override
  Widget build(BuildContext context) {
    final age = _age;
    final hasExam = _examId != null;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pemeriksaan'),
          actions: [
            IconButton(
              tooltip: 'Cetak / Bagikan PDF',
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _examId == null ? null : _printReport,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.edit_note), text: 'Modul Pemeriksaan'),
              Tab(icon: Icon(Icons.assignment_turned_in), text: 'Hasil Pemeriksaan'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- TAB 1: MODUL PEMERIKSAAN (INPUT) ---
            _buildModulesTab(age),
            // --- TAB 2: HASIL PEMERIKSAAN (READ-ONLY) ---
            hasExam
                ? _ExamResultsTab(
                    patient: widget.patient,
                    examId: _examId!,
                    examDate: _examDate,
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'Belum ada pemeriksaan. Isi modul di tab pertama.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildModulesTab(AgeResult age) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.patient.name,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.event, size: 18),
                    const SizedBox(width: 8),
                    Text('Tanggal: ${AgeCalculator.formatDate(_examDate)}'),
                    const Spacer(),
                    if (_examId == null)
                      TextButton(
                        onPressed: _pickDate,
                        child: const Text('Ubah'),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Usia kronologis: ${age.chronologicalLabel}'),
                if (age.correctionApplied)
                  Text('Usia koreksi: ${age.correctedLabel}',
                      style: TextStyle(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Modul Pemeriksaan',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _ModuleTile(
          icon: Icons.monitor_weight,
          color: Colors.indigo,
          title: 'Pertumbuhan (Antropometri WHO)',
          subtitle: 'BB, TB, Lingkar Kepala → Z-score & status gizi',
          onTap: () async {
            final id = await _ensureExam();
            if (!mounted) return;
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => GrowthScreen(
                patient: widget.patient,
                examinationId: id,
                examDate: _examDate,
              ),
            ));
            setState(() {}); // Refresh hasil tab
          },
        ),
        const SizedBox(height: 8),
        _ModuleTile(
          icon: Icons.checklist,
          color: Colors.deepPurple,
          title: 'KPSP (Skrining Perkembangan)',
          subtitle: 'Kuesioner Pra Skrining Perkembangan sesuai usia',
          onTap: () async {
            final id = await _ensureExam();
            if (!mounted) return;
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => KpspScreen(
                patient: widget.patient,
                examinationId: id,
                age: _age,
              ),
            ));
            setState(() {});
          },
        ),
        const SizedBox(height: 8),
        _ModuleTile(
          icon: Icons.lightbulb,
          color: Colors.amber.shade800,
          title: 'Stimulasi (Saran Aktivitas)',
          subtitle: 'Aktivitas stimulasi SDIDTK sesuai hasil KPSP',
          onTap: () async {
            final id = await _ensureExam();
            if (!mounted) return;
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => StimulationScreen(
                patient: widget.patient,
                examinationId: id,
                age: _age,
              ),
            ));
            setState(() {});
          },
        ),
        const SizedBox(height: 8),
        _ModuleTile(
          icon: Icons.sentiment_satisfied_alt,
          color: Colors.teal,
          title: 'KMME (Mental Emosional)',
          subtitle: 'Masalah mental emosional anak usia 3-6 tahun',
          onTap: () => _openScreening(kmmeInstrument),
        ),
        const SizedBox(height: 8),
        _ModuleTile(
          icon: Icons.hearing,
          color: Colors.brown,
          title: 'TDD (Tes Daya Dengar)',
          subtitle: 'Skrining pendengaran sesuai kelompok usia',
          onTap: () =>
              _openScreening(tddInstrumentForAge(_age.chronologicalMonths)),
        ),
        const SizedBox(height: 8),
        _ModuleTile(
          icon: Icons.extension,
          color: Colors.redAccent,
          title: 'M-CHAT-R (Skrining Autisme)',
          subtitle: 'Deteksi dini risiko ASD, anak usia 16-30 bulan',
          onTap: () => _openScreening(mchatInstrument),
        ),
        const SizedBox(height: 8),
        _ModuleTile(
          icon: Icons.bolt,
          color: Colors.orange,
          title: 'GPPH (Hiperaktivitas / ADHD)',
          subtitle: 'Abbreviated Conners, skala 0-3, untuk usia sekolah',
          onTap: () => _openScreening(gpphInstrument),
        ),
        const SizedBox(height: 8),
        _ModuleTile(
          icon: Icons.run_circle,
          color: Colors.deepOrange,
          title: 'SPPAHI (Perilaku Hiperaktif)',
          subtitle: '35 item, skala 0-3, cut-off sesuai penilai',
          onTap: () => _openScreening(sppahiInstrument),
        ),
        const SizedBox(height: 8),
        _ModuleTile(
          icon: Icons.visibility,
          color: Colors.cyan,
          title: 'TDL (Tes Daya Lihat)',
          subtitle: 'Catat hasil poster "E" per mata (prasekolah 3-6 thn)',
          onTap: () async {
            final id = await _ensureExam();
            if (!mounted) return;
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => TdlScreen(
                examinationId: id,
                ageMonths: _age.chronologicalMonths,
              ),
            ));
            setState(() {});
          },
        ),
        const SizedBox(height: 8),
        _ModuleTile(
          icon: Icons.psychology_alt,
          color: Colors.pink,
          title: 'CARS (Skrining Autisme)',
          subtitle: '15 area, skala 1-4; berhak cipta (pakai klinik sendiri)',
          onTap: () async {
            final id = await _ensureExam();
            if (!mounted) return;
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => CarsScreen(examinationId: id),
            ));
            setState(() {});
          },
        ),
      ],
    );
  }

  Future<void> _openScreening(ScreeningInstrument instrument) async {
    final id = await _ensureExam();
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ScreeningScreen(
        instrument: instrument,
        examinationId: id,
        ageMonths: _age.chronologicalMonths,
      ),
    ));
    setState(() {});
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _examDate,
      firstDate: widget.patient.birthDate,
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) setState(() => _examDate = picked);
  }

  Future<void> _printReport() async {
    final repo = context.read<AppRepository>();
    final examId = _examId!;
    try {
      // Muat baris Examination dari DB agar tanggal/data konsisten.
      final exam = widget.existing ?? await repo.getExamination(examId);
      if (exam == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data pemeriksaan tidak ditemukan.')),
        );
        return;
      }
      final data = await ReportBuilder(repo)
          .build(patient: widget.patient, exam: exam);
      if (data.growthRows.isEmpty &&
          data.kpsp == null &&
          data.screenings.isEmpty &&
          data.vision == null &&
          data.cars == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Belum ada hasil untuk dilaporkan. Isi antropometri atau KPSP dulu.')),
        );
        return;
      }
      await PdfReportService.generateAndPrint(data);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat laporan: $e')),
      );
    }
  }
}

// ============================================================================
// TAB 2: HASIL PEMERIKSAAN (READ-ONLY SUMMARY)
// ============================================================================

class _ExamResultsTab extends StatefulWidget {
  final Patient patient;
  final String examId;
  final DateTime examDate;
  const _ExamResultsTab({
    required this.patient,
    required this.examId,
    required this.examDate,
  });

  @override
  State<_ExamResultsTab> createState() => _ExamResultsTabState();
}

class _ExamResultsTabState extends State<_ExamResultsTab> {
  ExamReportData? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _ExamResultsTab old) {
    super.didUpdateWidget(old);
    // Reload saat kembali dari modul input
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final repo = context.read<AppRepository>();
    final exam = await repo.getExamination(widget.examId);
    if (exam == null || !mounted) {
      setState(() => _loading = false);
      return;
    }
    final data = await ReportBuilder(repo)
        .build(patient: widget.patient, exam: exam);
    if (mounted) setState(() { _data = data; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final data = _data;
    if (data == null) {
      return const Center(child: Text('Data tidak ditemukan.'));
    }

    final hasAny = data.growthRows.isNotEmpty ||
        data.kpsp != null ||
        data.screenings.isNotEmpty ||
        data.vision != null ||
        data.cars != null;

    if (!hasAny) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'Belum ada hasil pemeriksaan.\nIsi modul di tab pertama, lalu kembali ke sini.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Info pasien ringkas ---
          Card(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.15),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.patient.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Tanggal: ${AgeCalculator.formatDate(widget.examDate)}'),
                        Text('Usia: ${data.age.chronologicalLabel}'
                            '${data.age.correctionApplied ? ' (koreksi: ${data.age.correctedLabel})' : ''}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- PERTUMBUHAN ---
          if (data.growthRows.isNotEmpty) ...[
            _sectionHeader(Icons.monitor_weight, Colors.indigo, 'Pertumbuhan (Antropometri)'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Table(
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                            ),
                            children: [
                              const _TableHeader('Indikator  '),
                              const _TableHeader('Nilai  '),
                              _TableHeader(
                                data.growthRows.any((r) => r.indicator == GrowthIndicator.weightForLengthHeight && data.age.chronologicalMonths > 60)
                                    ? 'Z / %  '
                                    : 'Z-score  ',
                              ),
                              const _TableHeader('-2SD  '),
                              const _TableHeader('Median  '),
                              const _TableHeader('+2SD  '),
                              const _TableHeader('Status'),
                            ],
                          ),
                          ...data.growthRows.map((r) {
                            final isWaterlow = r.indicator == GrowthIndicator.weightForLengthHeight && data.age.chronologicalMonths > 60;
                            final color = r.status.isAlert
                                ? (isWaterlow
                                    ? (r.zScore < 70 || r.zScore > 120 ? Colors.red : Colors.orange)
                                    : (r.zScore.abs() > 3 ? Colors.red : Colors.orange))
                                : Colors.green;
                            final scoreText = isWaterlow
                                ? '${r.zScore.toStringAsFixed(1)}%'
                                : r.zScore.toStringAsFixed(2);
                            final unit = _unitForIndicator(r.indicator);
                            return TableRow(
                              children: [
                                _TableCell(r.indicator.label),
                                _TableCell('${r.value.toStringAsFixed(1)} $unit'),
                                _TableCell(scoreText,
                                    color: color, bold: true),
                                _TableCell(isWaterlow ? '-' : '${r.sd2neg.toStringAsFixed(1)}'),
                                _TableCell(isWaterlow ? '${r.median.toStringAsFixed(1)}' : '${r.median.toStringAsFixed(1)}'),
                                _TableCell(isWaterlow ? '-' : '${r.sd2pos.toStringAsFixed(1)}'),
                                _TableCell(r.status.label, color: color),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    if (data.waterlow != null) ...[
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Analisis Waterlow (CDC 2000):',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _kvRow('Usia Tinggi (Height Age)', '${data.waterlow!.heightAgeMonths.toStringAsFixed(1)} bulan'),
                      _kvRow('Berat Badan Ideal (BBI)', '${data.waterlow!.idealWeightKg.toStringAsFixed(1)} kg'),
                      _kvRow('BB Aktual / BBI', '${data.waterlow!.percentage.toStringAsFixed(1)}%'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // --- KPSP ---
          if (data.kpsp != null) ...[
            _sectionHeader(Icons.checklist, Colors.deepPurple, 'KPSP (Skrining Perkembangan)'),
            _resultCard(
              color: _kpspColor(data.kpsp!.category),
              children: [
                _kvRow('Form usia', '${data.kpsp!.formAgeMonths} bulan'),
                _kvRow('Skor', '${data.kpsp!.yesCount} / ${data.kpsp!.total} Ya'),
                _kvRow('Hasil', data.kpsp!.category.label,
                    valueColor: _kpspColor(data.kpsp!.category), bold: true),
                const Divider(),
                Text(data.kpsp!.recommendation,
                    style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // --- INSTRUMEN SKRINING ---
          if (data.screenings.isNotEmpty) ...[
            _sectionHeader(Icons.fact_check, Colors.teal, 'Instrumen Skrining'),
            ...data.screenings.map((s) {
              final color = s.severity == 0
                  ? Colors.green
                  : s.severity == 1
                      ? Colors.orange
                      : Colors.red;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _resultCard(
                  color: color,
                  children: [
                    Text(s.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 8),
                    _kvRow('Skor', '${s.score} / ${s.total}'),
                    _kvRow('Hasil', s.levelLabel, valueColor: color, bold: true),
                    if (s.interpretation.isNotEmpty) ...[
                      const Divider(),
                      Text(s.interpretation,
                          style: const TextStyle(fontSize: 13)),
                    ],
                    if (s.recommendation.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(s.recommendation,
                          style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                    ],
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
          ],

          // --- TDL ---
          if (data.vision != null) ...[
            _sectionHeader(Icons.visibility, Colors.cyan, 'TDL (Tes Daya Lihat)'),
            _resultCard(
              color: data.vision!.hasImpairment ? Colors.orange : Colors.green,
              children: [
                _kvRow('Mata kanan', '${data.vision!.rightStatus} (baris ${data.vision!.rightEyeLine ?? "-"})'),
                _kvRow('Mata kiri', '${data.vision!.leftStatus} (baris ${data.vision!.leftEyeLine ?? "-"})'),
                const Divider(),
                Text(data.vision!.interpretation,
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // --- CARS ---
          if (data.cars != null) ...[
            _sectionHeader(Icons.psychology_alt, Colors.pink, 'CARS (Skrining Autisme)'),
            _resultCard(
              color: data.cars!.severity == 0
                  ? Colors.green
                  : data.cars!.severity == 1
                      ? Colors.orange
                      : Colors.red,
              children: [
                _kvRow('Total skor', data.cars!.totalScore.toStringAsFixed(1)),
                _kvRow('Kategori', data.cars!.categoryLabel,
                    valueColor: data.cars!.severity == 0
                        ? Colors.green
                        : data.cars!.severity == 1
                            ? Colors.orange
                            : Colors.red,
                    bold: true),
                const Divider(),
                Text(data.cars!.recommendation,
                    style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
              ],
            ),
            const SizedBox(height: 16),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // --- Helper widgets ---

  Widget _sectionHeader(IconData icon, Color color, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: color)),
        ],
      ),
    );
  }

  Widget _resultCard({required Color color, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _kvRow(String key, String value,
      {Color? valueColor, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$key: ', style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
          Expanded(
            child: Text(value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  color: valueColor,
                )),
          ),
        ],
      ),
    );
  }

  Color _kpspColor(KpspResultCategory cat) {
    switch (cat) {
      case KpspResultCategory.sesuai:
        return Colors.green;
      case KpspResultCategory.meragukan:
        return Colors.orange;
      case KpspResultCategory.penyimpangan:
        return Colors.red;
    }
  }

  String _unitForIndicator(GrowthIndicator ind) {
    switch (ind) {
      case GrowthIndicator.weightForAge:
      case GrowthIndicator.weightForLengthHeight:
        return 'kg';
      case GrowthIndicator.lengthHeightForAge:
      case GrowthIndicator.headCircumferenceForAge:
        return 'cm';
      case GrowthIndicator.bmiForAge:
        return '';
    }
  }
}

// ============================================================================
// SHARED WIDGETS
// ============================================================================

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      );
}

class _TableCell extends StatelessWidget {
  final String text;
  final Color? color;
  final bool bold;
  const _TableCell(this.text, {this.color, this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(text,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            )),
      );
}

class _ModuleTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _ModuleTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
