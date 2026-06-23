import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../data/repository.dart';

/// Form tambah / edit data pasien (Modul 1).
class PatientFormScreen extends StatefulWidget {
  /// Bila null = tambah baru, bila ada = edit.
  final Patient? patient;
  const PatientFormScreen({super.key, this.patient});

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _mrn;
  late final TextEditingController _parent;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _gestation;
  late final TextEditingController _notes;
  late final TextEditingController _birthWeight;
  late final TextEditingController _birthHeight;
  late final TextEditingController _birthHeadCircumference;

  DateTime? _birthDate;
  String _sex = 'L';
  bool _premature = false;
  bool _downSyndrome = false;

  bool get _isEdit => widget.patient != null;

  @override
  void initState() {
    super.initState();
    final p = widget.patient;
    _name = TextEditingController(text: p?.name ?? '');
    _mrn = TextEditingController(text: p?.medicalRecordNo ?? '');
    _parent = TextEditingController(text: p?.parentName ?? '');
    _phone = TextEditingController(text: p?.phone ?? '');
    _address = TextEditingController(text: p?.address ?? '');
    _gestation =
        TextEditingController(text: p?.gestationalWeeks?.toString() ?? '');
    _notes = TextEditingController(text: p?.notes ?? '');
    _birthWeight = TextEditingController();
    _birthHeight = TextEditingController();
    _birthHeadCircumference = TextEditingController();
    _birthDate = p?.birthDate;
    _sex = p?.sex ?? 'L';
    _premature = p?.isPremature ?? false;
    _downSyndrome = p?.hasDownSyndrome ?? false;

    if (_isEdit) {
      _loadBirthData();
    }
  }

  Future<void> _loadBirthData() async {
    final repo = context.read<AppRepository>();
    final m = await repo.getGrowthForDate(widget.patient!.id, widget.patient!.birthDate);
    if (m != null) {
      setState(() {
        if (m.weightKg != null) _birthWeight.text = m.weightKg.toString();
        if (m.heightCm != null) _birthHeight.text = m.heightCm.toString();
        if (m.headCircumferenceCm != null) {
          _birthHeadCircumference.text = m.headCircumferenceCm.toString();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _mrn,
      _parent,
      _phone,
      _address,
      _gestation,
      _notes,
      _birthWeight,
      _birthHeight,
      _birthHeadCircumference,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Pasien' : 'Pasien Baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  labelText: 'Nama lengkap *', prefixIcon: Icon(Icons.badge)),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _mrn,
              decoration: const InputDecoration(
                  labelText: 'No. rekam medis',
                  prefixIcon: Icon(Icons.tag)),
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
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sindrom Down'),
              value: _downSyndrome,
              onChanged: (v) => setState(() => _downSyndrome = v),
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
            TextFormField(
              controller: _parent,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  labelText: 'Nama orang tua',
                  prefixIcon: Icon(Icons.family_restroom)),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  labelText: 'No. telepon', prefixIcon: Icon(Icons.phone)),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              maxLines: 2,
              decoration: const InputDecoration(
                  labelText: 'Alamat', prefixIcon: Icon(Icons.home)),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notes,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Catatan / diagnosis kerja',
                  prefixIcon: Icon(Icons.notes)),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Text(_isEdit ? 'Simpan Perubahan' : 'Simpan Pasien'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
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

    String? nz(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();

    if (_isEdit) {
      final updated = widget.patient!.copyWith(
        name: _name.text.trim(),
        medicalRecordNo: d.Value(nz(_mrn)),
        birthDate: _birthDate!,
        sex: _sex,
        parentName: d.Value(nz(_parent)),
        phone: d.Value(nz(_phone)),
        address: d.Value(nz(_address)),
        gestationalWeeks: d.Value(gest),
        isPremature: _premature,
        hasDownSyndrome: _downSyndrome,
        notes: d.Value(nz(_notes)),
      );
      await repo.updatePatient(updated);

      final patientId = widget.patient!.id;
      final oldBirthDate = widget.patient!.birthDate;
      final newBirthDate = _birthDate!;

      // Jika tanggal lahir berubah, sesuaikan tanggal pemeriksaan lahir sebelumnya (jika ada)
      if (oldBirthDate != newBirthDate) {
        final oldBirthExam = await (repo.db.select(repo.db.examinations)
              ..where((e) => e.patientId.equals(patientId) & e.examDate.equals(oldBirthDate)))
            .getSingleOrNull();
        if (oldBirthExam != null) {
          await repo.db.update(repo.db.examinations).replace(
            oldBirthExam.copyWith(examDate: newBirthDate),
          );
        }
      }

      // Upsert data lahir jika ada minimal satu nilai terisi
      if (birthW != null || birthH != null || birthHC != null) {
        final birthExam = await (repo.db.select(repo.db.examinations)
              ..where((e) => e.patientId.equals(patientId) & e.examDate.equals(newBirthDate)))
            .getSingleOrNull();
        String birthExamId;
        if (birthExam == null) {
          birthExamId = await repo.insertExamination(
            ExaminationsCompanion.insert(
              patientId: patientId,
              examDate: newBirthDate,
              examinerNote: const d.Value('Data Lahir'),
            ),
          );
        } else {
          birthExamId = birthExam.id;
        }

        final existingGrowth = await repo.getGrowthForExam(birthExamId);
        await repo.upsertGrowth(
          GrowthMeasurementsCompanion(
            id: existingGrowth != null ? d.Value(existingGrowth.id) : const d.Value.absent(),
            examinationId: d.Value(birthExamId),
            weightKg: d.Value(birthW),
            heightCm: d.Value(birthH),
            headCircumferenceCm: d.Value(birthHC),
            measuredLying: const d.Value(true),
          ),
        );
      }
    } else {
      final patientId = await repo.insertPatient(PatientsCompanion.insert(
        name: _name.text.trim(),
        medicalRecordNo: d.Value(nz(_mrn)),
        birthDate: _birthDate!,
        sex: _sex,
        parentName: d.Value(nz(_parent)),
        phone: d.Value(nz(_phone)),
        address: d.Value(nz(_address)),
        gestationalWeeks: d.Value(gest),
        isPremature: d.Value(_premature),
        hasDownSyndrome: d.Value(_downSyndrome),
        notes: d.Value(nz(_notes)),
      ));

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
    }
    if (mounted) Navigator.of(context).pop();
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onPick;
  const _DatePickerField(
      {required this.label, required this.value, required this.onPick});

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
          prefixIcon: const Icon(Icons.cake),
        ),
        child: Text(
          value == null ? 'Pilih tanggal' : AgeCalculator.formatDate(value!),
          style: TextStyle(
              color: value == null
                  ? Theme.of(context).hintColor
                  : Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
    );
  }
}
