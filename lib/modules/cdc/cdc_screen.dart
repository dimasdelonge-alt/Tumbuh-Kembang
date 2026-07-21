import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:drift/drift.dart' show Value;
import '../../core/age_calculator.dart';
import '../../data/database.dart';
import '../../data/repository.dart';
import 'cdc_calculator.dart';
import 'cdc_chart_painter.dart';

/// Layar Modul Kurva Pertumbuhan CDC 2000 & Tinggi Potensi Genetik (TPG).
class CdcScreen extends StatefulWidget {
  final Patient patient;
  final Examination examination;

  const CdcScreen({
    super.key,
    required this.patient,
    required this.examination,
  });

  @override
  State<CdcScreen> createState() => _CdcScreenState();
}

class _CdcScreenState extends State<CdcScreen> {
  ui.Image? _chartImage;
  bool _isLoadingImage = true;

  double _ageYears = 3.0;
  TpgResult? _tpg;
  RealtimeTpgResult? _realtimeTpg;
  List<CdcPoint> _cdcPoints = [];
  bool _showAgeLine = true;
  bool _loadingData = true;

  final _fatherHeightController = TextEditingController();
  final _motherHeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _calculateAgeYears();
    _initParentHeights();
    _loadHistoricalDataAndImage();
  }

  void _calculateAgeYears() {
    final ageRes = AgeCalculator.calculate(
      birthDate: widget.patient.birthDate,
      examDate: widget.examination.examDate,
    );
    _ageYears = ageRes.chronologicalMonths / 12.0;
  }

  Future<void> _initParentHeights() async {
    // Muat data pasien terbaru dari database (bukan dari widget.patient yang bisa stale)
    final repo = context.read<AppRepository>();
    final freshPatient = await repo.getPatient(widget.patient.id);
    final patient = freshPatient ?? widget.patient;

    final fHeight = patient.fatherHeightCm;
    final mHeight = patient.motherHeightCm;

    if (fHeight != null && fHeight > 0) {
      _fatherHeightController.text = fHeight.toStringAsFixed(0);
    }
    if (mHeight != null && mHeight > 0) {
      _motherHeightController.text = mHeight.toStringAsFixed(0);
    }

    _recalculateTPG();
  }

  void _recalculateTPG() {
    final fH = double.tryParse(_fatherHeightController.text);
    final mH = double.tryParse(_motherHeightController.text);

    final tpg = CdcCalculator.calculateTPG(
      fatherHeightCm: fH,
      motherHeightCm: mH,
      sex: widget.patient.sex,
    );

    double? currentHeight;
    for (final p in _cdcPoints) {
      if (p.isCurrentExam) {
        currentHeight = p.heightCm;
        break;
      }
    }

    final ageRes = AgeCalculator.calculate(
      birthDate: widget.patient.birthDate,
      examDate: widget.examination.examDate,
    );

    final realtimeTpg = CdcCalculator.calculateRealtimeTPG(
      currentHeightCm: currentHeight,
      ageMonths: ageRes.chronologicalMonths,
      tpg: tpg,
    );

    setState(() {
      _tpg = tpg;
      _realtimeTpg = realtimeTpg;
    });
  }

  Future<void> _saveParentHeights() async {
    final fH = double.tryParse(_fatherHeightController.text);
    final mH = double.tryParse(_motherHeightController.text);

    final repo = context.read<AppRepository>();
    final updated = widget.patient.copyWith(
      fatherHeightCm: Value(fH),
      motherHeightCm: Value(mH),
    );

    await repo.updatePatient(updated);
    _recalculateTPG();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tinggi Badan Orang Tua & TPG berhasil diperbarui!'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Future<void> _loadHistoricalDataAndImage() async {
    setState(() => _loadingData = true);
    final repo = context.read<AppRepository>();

    final history = await repo.growthHistory(widget.patient.id);
    final List<CdcPoint> pointsList = [];

    for (final item in history) {
      final ageRes = AgeCalculator.calculate(
        birthDate: widget.patient.birthDate,
        examDate: item.exam.examDate,
      );
      final ageY = ageRes.chronologicalMonths / 12.0;

      if (item.growth.heightCm != null && item.growth.heightCm! > 0) {
        pointsList.add(
          CdcPoint(
            date: item.exam.examDate,
            ageYears: ageY,
            heightCm: item.growth.heightCm!,
            isCurrentExam: item.exam.id == widget.examination.id,
          ),
        );
      }
    }

    _cdcPoints = pointsList;
    _recalculateTPG();

    final isBoy = widget.patient.sex.toUpperCase() == 'M' ||
        widget.patient.sex.toUpperCase() == 'L';
    final assetPath =
        isBoy ? 'assets/cdc/cdc_boys.jpg' : 'assets/cdc/cdc_girls.jpg';

    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo fi = await codec.getNextFrame();
      if (mounted) {
        setState(() {
          _chartImage = fi.image;
          _isLoadingImage = false;
          _loadingData = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading CDC chart image: $e');
      if (mounted) {
        setState(() {
          _isLoadingImage = false;
          _loadingData = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _fatherHeightController.dispose();
    _motherHeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBoy = widget.patient.sex.toUpperCase() == 'M' ||
        widget.patient.sex.toUpperCase() == 'L';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kurva CDC 2000 & TPG (${isBoy ? "Laki-laki" : "Perempuan"})',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: const Color(0xFF0148A0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showAgeLine ? Icons.line_style : Icons.show_chart),
            tooltip:
                _showAgeLine ? 'Sembunyikan Garis Usia' : 'Tampilkan Garis Usia',
            onPressed: () => setState(() => _showAgeLine = !_showAgeLine),
          ),
        ],
      ),
      body: _loadingData
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header Input TB Orang Tua & Hasil TPG
                Container(
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFFE8F0FE),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.family_restroom,
                              color: Color(0xFF0148A0), size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.patient.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'Usia Uji: ${_ageYears.toStringAsFixed(1)} Tahun '
                                  '(${widget.patient.sex == "L" ? "Laki-laki" : "Perempuan"})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Input TB Ayah & TB Ibu
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _fatherHeightController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'TB Ayah (cm)',
                                hintText: 'Contoh: 170',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                              ),
                              onChanged: (_) => _recalculateTPG(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _motherHeightController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'TB Ibu (cm)',
                                hintText: 'Contoh: 158',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                              ),
                              onChanged: (_) => _recalculateTPG(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            onPressed: _saveParentHeights,
                            icon: const Icon(Icons.save, size: 20),
                            tooltip: 'Simpan Data Orang Tua',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Status TPG Card
                      if (_tpg != null) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.verified,
                                      color: Colors.green.shade800, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'TPG Dewasa: ${_tpg!.label}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.green.shade900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (_realtimeTpg != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Ideal Usia ${_ageYears.toStringAsFixed(1)} Thn: ${_realtimeTpg!.rangeLabel}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _realtimeTpg!.statusLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _realtimeTpg!.isBelow
                                        ? Colors.red.shade900
                                        : (_realtimeTpg!.isAbove
                                            ? Colors.orange.shade900
                                            : Colors.green.shade900),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ] else
                        Text(
                          'Isi TB Ayah & Ibu di atas untuk mengarsir area Tinggi Potensi Genetik di kurva CDC.',
                          style: TextStyle(
                              fontSize: 11, color: Colors.orange.shade900),
                        ),
                    ],
                  ),
                ),

                // Hint Pan / Zoom
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color: Colors.amber.shade50,
                  child: const Row(
                    children: [
                      Icon(Icons.touch_app, size: 16, color: Colors.amber),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Geser / zoom diagram. Area hijau di kanan menunjukkan rentang Tinggi Potensi Genetik (TPG).',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),

                // Diagram Chart Interaktif
                Expanded(
                  child: _isLoadingImage
                      ? const Center(child: CircularProgressIndicator())
                      : InteractiveViewer(
                          maxScale: 4.0,
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 1.0 / 1.294,
                              child: CustomPaint(
                                painter: CdcChartPainter(
                                  image: _chartImage,
                                  currentAgeYears: _ageYears,
                                  points: _cdcPoints,
                                  tpg: _tpg,
                                  realtimeTpg: _realtimeTpg,
                                  showAgeLine: _showAgeLine,
                                  sex: widget.patient.sex,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
