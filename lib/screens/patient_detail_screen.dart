import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../data/repository.dart';
import 'patient_form_screen.dart';
import 'examination_screen.dart';
import 'longitudinal_screen.dart';

/// Detail pasien: identitas, usia, dan riwayat pemeriksaan (Modul 14).
class PatientDetailScreen extends StatelessWidget {
  final String patientId;
  const PatientDetailScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AppRepository>();
    return FutureBuilder<Patient?>(
      future: repo.getPatient(patientId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final patient = snap.data;
        if (patient == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Pasien tidak ditemukan')),
          );
        }
        return _DetailView(patient: patient);
      },
    );
  }
}

class _DetailView extends StatefulWidget {
  final Patient patient;
  const _DetailView({required this.patient});

  @override
  State<_DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<_DetailView> {
  Future<void> _confirmDeleteExam(Examination exam) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Pemeriksaan?'),
        content: Text(
          'Pemeriksaan tanggal ${AgeCalculator.formatDate(exam.examDate)}'
          '${exam.examinerNote != null ? " (${exam.examinerNote})" : ""}'
          ' beserta seluruh data hasil (pertumbuhan, KPSP, skrining, dll) '
          'akan dihapus permanen.\n\nLanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final repo = context.read<AppRepository>();
    await repo.deleteExamination(exam.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pemeriksaan ${AgeCalculator.formatDate(exam.examDate)} dihapus.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AppRepository>();
    final patient = widget.patient;
    final age = AgeCalculator.calculate(
      birthDate: patient.birthDate,
      examDate: DateTime.now(),
      gestationalWeeks: patient.gestationalWeeks,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
        actions: [
          IconButton(
            tooltip: 'Tren / Longitudinal',
            icon: const Icon(Icons.trending_up),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LongitudinalScreen(patient: patient),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PatientFormScreen(patient: patient),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ExaminationScreen(patient: patient),
          ),
        ),
        icon: const Icon(Icons.add_chart),
        label: const Text('Pemeriksaan Baru'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
        children: [
          _IdentityCard(patient: patient, age: age),
          const SizedBox(height: 16),
          Text('Riwayat Pemeriksaan',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          StreamBuilder<List<Examination>>(
            stream: repo.watchExaminations(patient.id),
            builder: (context, snap) {
              final exams = snap.data ?? const [];
              if (exams.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('Belum ada pemeriksaan.',
                        style: TextStyle(color: Colors.grey)),
                  ),
                );
              }
              return Column(
                children: exams
                    .map((e) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.event_note),
                            title:
                                Text(AgeCalculator.formatDate(e.examDate)),
                            subtitle: Text(e.examinerNote ?? 'Pemeriksaan'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ExaminationScreen(
                                  patient: patient,
                                  existing: e,
                                ),
                              ),
                            ),
                            onLongPress: () => _confirmDeleteExam(e),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _IdentityCard extends StatelessWidget {
  final Patient patient;
  final AgeResult age;
  const _IdentityCard({required this.patient, required this.age});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Jenis kelamin',
                patient.sex == 'L' ? 'Laki-laki' : 'Perempuan'),
            _row('Tanggal lahir',
                AgeCalculator.formatDate(patient.birthDate)),
            _row('Usia kronologis', age.chronologicalLabel),
            if (age.correctionApplied)
              _row('Usia koreksi', age.correctedLabel,
                  highlight: true),
            if (patient.isPremature)
              _row('Riwayat',
                  'Prematur (${patient.gestationalWeeks ?? '-'} minggu)'),
            if (patient.hasDownSyndrome) _row('Riwayat', 'Sindrom Down'),
            if (patient.medicalRecordNo != null)
              _row('No. RM', patient.medicalRecordNo!),
            if (patient.parentName != null)
              _row('Orang tua', patient.parentName!),
            if (patient.phone != null) _row('Telepon', patient.phone!),
            if (patient.notes != null && patient.notes!.isNotEmpty)
              _row('Catatan', patient.notes!),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
                color: highlight ? Colors.teal.shade700 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
