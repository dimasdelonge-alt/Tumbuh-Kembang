import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../modules/vision/tdl.dart';

/// Layar pencatatan Tes Daya Lihat (TDL).
///
/// Tes fisik tetap memakai poster "E" asli. Aplikasi hanya mencatat baris
/// terkecil yang terbaca tiap mata, lalu memberi interpretasi otomatis.
class TdlScreen extends StatefulWidget {
  final String examinationId;

  /// Usia anak (bulan) untuk peringatan rentang (TDL prasekolah 36-72 bulan).
  final int? ageMonths;

  const TdlScreen({
    super.key,
    required this.examinationId,
    this.ageMonths,
  });

  @override
  State<TdlScreen> createState() => _TdlScreenState();
}

/// Sentinel pilihan per mata: belum dipilih, tidak terbaca, atau baris 1..4.
const int _kUnset = -1;
const int _kNotReadable = 0;

class _TdlScreenState extends State<TdlScreen> {
  // _kUnset = belum dipilih, _kNotReadable = tidak terbaca, 1..4 = baris.
  int _right = _kUnset;
  int _left = _kUnset;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final repo = context.read<AppRepository>();
    final v = await repo.getVisionForExam(widget.examinationId);
    if (v != null && mounted) {
      setState(() {
        _right = v.rightEyeLine ?? _kNotReadable;
        _left = v.leftEyeLine ?? _kNotReadable;
      });
    }
  }

  bool get _ageWarning {
    final a = widget.ageMonths;
    if (a == null) return false;
    return a < 36 || a > 72;
  }

  /// Konversi sentinel ke nilai baris untuk model (null = tidak terbaca).
  int? _lineValue(int sel) => sel == _kNotReadable ? null : sel;

  TdlResult get _result => TdlResult(
        rightEyeLine: _lineValue(_right),
        leftEyeLine: _lineValue(_left),
      );

  /// Lengkap bila KEDUA mata sudah dinilai (baris atau tidak terbaca).
  bool get _complete => _right != _kUnset && _left != _kUnset;

  @override
  Widget build(BuildContext context) {
    final res = _result;
    return Scaffold(
      appBar: AppBar(title: const Text('TDL (Tes Daya Lihat)')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: _complete ? _save : null,
            icon: const Icon(Icons.save),
            label: const Text('Simpan Hasil'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          const Text(
            'Tes memakai poster "E" asli ($tdlTotalLines baris) dari jarak '
            '3 meter. Catat baris terkecil yang masih terbaca tiap mata. '
            'Normal bila mencapai baris $tdlNormalThresholdLine.',
            style: TextStyle(color: Colors.grey),
          ),
          if (_ageWarning)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade700),
              ),
              child: Text(
                'Catatan: TDL baku untuk anak prasekolah 36-72 bulan.',
                style: TextStyle(fontSize: 12.5, color: Colors.amber.shade900),
              ),
            ),
          const SizedBox(height: 16),
          _eyeSelector('Mata kanan', _right, (v) => setState(() => _right = v)),
          const SizedBox(height: 16),
          _eyeSelector('Mata kiri', _left, (v) => setState(() => _left = v)),
          const SizedBox(height: 20),
          if (_complete) _resultCard(res),
        ],
      ),
    );
  }

  Widget _eyeSelector(String label, int value, ValueChanged<int> onPick) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Baris terkecil yang terbaca:',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (var line = 1; line <= tdlTotalLines; line++)
                  ChoiceChip(
                    label: Text('Baris $line'),
                    selected: value == line,
                    onSelected: (_) => onPick(line),
                  ),
                ChoiceChip(
                  label: const Text('Tidak terbaca'),
                  selected: value == _kNotReadable,
                  onSelected: (_) => onPick(_kNotReadable),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultCard(TdlResult res) {
    final color =
        res.hasImpairment ? Colors.orange.shade700 : Colors.green.shade600;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.visibility, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    res.hasImpairment
                        ? 'Kemungkinan gangguan daya lihat'
                        : 'Daya lihat normal',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Mata kanan: ${res.rightStatus.label}'
                '${res.rightEyeLine != null ? ' (baris ${res.rightEyeLine})' : ' (tidak terbaca)'}'),
            Text('Mata kiri: ${res.leftStatus.label}'
                '${res.leftEyeLine != null ? ' (baris ${res.leftEyeLine})' : ' (tidak terbaca)'}'),
            const SizedBox(height: 8),
            Text(res.recommendation, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final repo = context.read<AppRepository>();
    await repo.upsertVision(VisionResultsCompanion.insert(
      examinationId: widget.examinationId,
      rightEyeLine: Value(_lineValue(_right)),
      leftEyeLine: Value(_lineValue(_left)),
    ));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hasil TDL tersimpan')),
    );
    Navigator.of(context).pop();
  }
}
