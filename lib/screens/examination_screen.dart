import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../data/repository.dart';
import '../modules/screening/instrument.dart';
import '../modules/screening/data/kmme_data.dart';
import '../modules/screening/data/tdd_data.dart';
import '../modules/screening/data/mchat_data.dart';
import '../modules/screening/data/gpph_data.dart';
import '../modules/screening/data/sppahi_data.dart';
import '../reports/pdf_report_service.dart';
import '../reports/report_builder.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemeriksaan'),
        actions: [
          IconButton(
            tooltip: 'Cetak / Bagikan PDF',
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _examId == null ? null : _printReport,
          ),
        ],
      ),
      body: ListView(
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => GrowthScreen(
                  patient: widget.patient,
                  examinationId: id,
                  examDate: _examDate,
                ),
              ));
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => KpspScreen(
                  patient: widget.patient,
                  examinationId: id,
                  age: _age,
                ),
              ));
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => StimulationScreen(
                  patient: widget.patient,
                  examinationId: id,
                  age: _age,
                ),
              ));
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => TdlScreen(
                  examinationId: id,
                  ageMonths: _age.chronologicalMonths,
                ),
              ));
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => CarsScreen(examinationId: id),
              ));
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openScreening(ScreeningInstrument instrument) async {
    final id = await _ensureExam();
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ScreeningScreen(
        instrument: instrument,
        examinationId: id,
        ageMonths: _age.chronologicalMonths,
      ),
    ));
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
