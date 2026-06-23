import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../data/repository.dart';
import 'examination_screen.dart';

/// Form skrining cepat (tanpa registrasi pasien formal).
class FastScreeningFormScreen extends StatefulWidget {
  const FastScreeningFormScreen({super.key});

  @override
  State<FastScreeningFormScreen> createState() => _FastScreeningFormScreenState();
}

class _FastScreeningFormScreenState extends State<FastScreeningFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _gestation;
  late final TextEditingController _birthWeight;
  late final TextEditingController _birthHeight;
  late final TextEditingController _birthHeadCircumference;

  DateTime? _birthDate;
  DateTime _examDate = DateTime.now();
  String _sex = 'L';
  bool _premature = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _gestation = TextEditingController();
    _birthWeight = TextEditingController();
    _birthHeight = TextEditingController();
    _birthHeadCircumference = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _gestation.dispose();
    _birthWeight.dispose();
    _birthHeight.dispose();
    _birthHeadCircumference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skrining Cepat (Anonim)')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.15),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.flash_on, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Sesi skrining cepat ini tidak memerlukan pendaftaran rekam medis. '
                        'Hasil pemeriksaan dapat diunduh sebagai laporan PDF.',
                        style: TextStyle(fontSize: 12.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nama / Inisial (opsional)',
                prefixIcon: Icon(Icons.badge),
                hintText: 'Mis. Anak X, Bayi A',
              ),
            ),
            const SizedBox(height: 12),
            _DatePickerField(
              label: 'Tanggal lahir *',
              value: _birthDate,
              onPick: (d) => setState(() => _birthDate = d),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Jenis kelamin: '),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Laki-laki'),
                  selected: _sex == 'L',
                  onSelected: (_) => setState(() => _sex = 'L'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Perempuan'),
                  selected: _sex == 'P',
                  onSelected: (_) => setState(() => _sex = 'P'),
                ),
              ],
            ),
            const Divider(height: 32),
            Text('Riwayat kelahiran',
                style: Theme.of(context).textTheme.titleSmall),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Lahir prematur'),
              subtitle: const Text('Usia kehamilan < 37 minggu'),
              value: _premature,
              onChanged: (v) => setState(() => _premature = v),
            ),
            if (_premature)
              TextFormField(
                controller: _gestation,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Usia kehamilan saat lahir (minggu)',
                  prefixIcon: Icon(Icons.pregnant_woman),
                  helperText: 'Dipakai untuk menghitung usia koreksi',
                ),
                validator: (v) {
                  if (!_premature) return null;
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 20 || n > 42) {
                    return 'Masukkan 20-42 minggu';
                  }
                  return null;
                },
              ),
            const Divider(height: 32),
            Text('Antropometri Lahir (Opsional)',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _birthWeight,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'BB Lahir (kg)',
                      prefixIcon: Icon(Icons.monitor_weight),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _birthHeight,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'TB Lahir (cm)',
                      prefixIcon: Icon(Icons.height),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _birthHeadCircumference,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'LK Lahir (cm) — opsional',
                prefixIcon: Icon(Icons.circle_outlined),
              ),
            ),
            const Divider(height: 32),
            _DatePickerField(
              label: 'Tanggal pemeriksaan *',
              value: _examDate,
              onPick: (d) => setState(() => _examDate = d),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _startScreening,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Mulai Pemeriksaan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startScreening() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal lahir wajib diisi')),
      );
      return;
    }

    final repo = context.read<AppRepository>();
    final gest = _premature ? int.tryParse(_gestation.text) : null;
    final birthW = double.tryParse(_birthWeight.text.replaceAll(',', '.'));
    final birthH = double.tryParse(_birthHeight.text.replaceAll(',', '.'));
    final birthHC = double.tryParse(_birthHeadCircumference.text.replaceAll(',', '.'));

    final nameText = _name.text.trim().isEmpty ? 'Pasien Anonim' : _name.text.trim();

    // 1. Simpan pasien dengan no. RM ANONIM dan catatan Skrining Cepat
    final patientId = await repo.insertPatient(PatientsCompanion.insert(
      name: nameText,
      medicalRecordNo: const d.Value('ANONIM'),
      birthDate: _birthDate!,
      sex: _sex,
      isPremature: d.Value(_premature),
      gestationalWeeks: d.Value(gest),
      notes: const d.Value('Skrining Cepat'),
    ));

    final patient = await repo.getPatient(patientId);
    if (patient == null) return;

    // 2. Simpan data lahir jika terisi
    if (birthW != null || birthH != null || birthHC != null) {
      final birthExamId = await repo.insertExamination(
        ExaminationsCompanion.insert(
          patientId: patientId,
          examDate: _birthDate!,
          examinerNote: const d.Value('Data Lahir'),
        ),
      );
      await repo.upsertGrowth(
        GrowthMeasurementsCompanion.insert(
          examinationId: birthExamId,
          weightKg: d.Value(birthW),
          heightCm: d.Value(birthH),
          headCircumferenceCm: d.Value(birthHC),
          measuredLying: const d.Value(true),
        ),
      );
    }

    // 3. Buat pemeriksaan saat ini
    final currentExamId = await repo.insertExamination(
      ExaminationsCompanion.insert(
        patientId: patientId,
        examDate: _examDate,
        examinerNote: const d.Value('Skrining Cepat'),
      ),
    );

    final currentExam = await repo.getExamination(currentExamId);

    if (mounted) {
      // Langsung arahkan ke ExaminationScreen dan replace form screen ini
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ExaminationScreen(
            patient: patient,
            existing: currentExam,
          ),
        ),
      );
    }
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onPick;
  const _DatePickerField({required this.label, required this.value, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(now.year - 19),
          lastDate: now,
          locale: const Locale('id', 'ID'),
        );
        if (picked != null) onPick(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_month),
        ),
        child: Text(
          value == null ? 'Pilih tanggal' : AgeCalculator.formatDate(value!),
          style: TextStyle(
            color: value == null
                ? Theme.of(context).hintColor
                : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}
