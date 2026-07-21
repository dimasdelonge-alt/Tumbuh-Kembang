import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/database.dart';
import '../../data/repository.dart';
import 'fenton_calculator.dart';
import 'fenton_chart_painter.dart';

/// Layar Tampilan Kurva Pertumbuhan Bayi Prematur Fenton 2013 (F2013)
/// dengan dukungan tren longitudinal antar-kunjungan.
class FentonScreen extends StatefulWidget {
  final Patient patient;
  final Examination examination;

  const FentonScreen({
    super.key,
    required this.patient,
    required this.examination,
  });

  @override
  State<FentonScreen> createState() => _FentonScreenState();
}

class _FentonScreenState extends State<FentonScreen> {
  ui.Image? _chartImage;
  bool _isLoadingImage = true;

  double _currentPmaWeeks = 30.0;
  List<FentonPoint> _fentonPoints = [];
  bool _showAgeLine = true;
  bool _loadingData = true;

  @override
  void initState() {
    super.initState();
    _calculateCurrentPMA();
    _loadHistoricalDataAndImage();
  }

  void _calculateCurrentPMA() {
    final gestationalWeeks = widget.patient.gestationalWeeks ?? 32;
    _currentPmaWeeks = FentonCalculator.calculatePMAWeeks(
      gestationalWeeks: gestationalWeeks,
      birthDate: widget.patient.birthDate,
      examDate: widget.examination.examDate,
    );
  }

  Future<void> _loadHistoricalDataAndImage() async {
    setState(() => _loadingData = true);
    final repo = context.read<AppRepository>();
    final gestationalWeeks = widget.patient.gestationalWeeks ?? 32;

    // Load semua riwayat pertumbuhan pasien lintas kunjungan
    final history = await repo.growthHistory(widget.patient.id);
    final List<FentonPoint> pointsList = [];

    for (final item in history) {
      final pma = FentonCalculator.calculatePMAWeeks(
        gestationalWeeks: gestationalWeeks,
        birthDate: widget.patient.birthDate,
        examDate: item.exam.examDate,
      );

      // Hanya masukkan ke Kurva Fenton jika berada dalam rentang 22-50 mgg PMA
      if (pma >= 20.0 && pma <= 52.0) {
        final isCurrent = item.exam.id == widget.examination.id;
        pointsList.add(
          FentonPoint(
            date: item.exam.examDate,
            pmaWeeks: pma,
            weightKg: item.growth.weightKg,
            lengthCm: item.growth.heightCm,
            headCircumferenceCm: item.growth.headCircumferenceCm,
            isCurrentExam: isCurrent,
          ),
        );
      }
    }

    _fentonPoints = pointsList;

    // Load gambar kurva Fenton sesuai jenis kelamin
    final isBoy = widget.patient.sex.toUpperCase() == 'M' ||
        widget.patient.sex.toUpperCase() == 'L';
    final assetPath = isBoy
        ? 'assets/fenton/fenton_boys.jpg'
        : 'assets/fenton/fenton_girls.jpg';

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
      debugPrint('Error loading Fenton chart image: $e');
      if (mounted) {
        setState(() {
          _isLoadingImage = false;
          _loadingData = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBoy = widget.patient.sex.toUpperCase() == 'M' ||
        widget.patient.sex.toUpperCase() == 'L';
    final gestationalWeeks = widget.patient.gestationalWeeks ?? 32;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kurva Fenton 2013 (${isBoy ? "Laki-laki" : "Perempuan"})',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: const Color(0xFF0148A0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showAgeLine ? Icons.line_style : Icons.show_chart),
            tooltip: _showAgeLine ? 'Sembunyikan Garis Usia' : 'Tampilkan Garis Usia',
            onPressed: () => setState(() => _showAgeLine = !_showAgeLine),
          ),
        ],
      ),
      body: _loadingData
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header Info Pasien & PMA
                Container(
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFFE8F0FE),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.child_care,
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
                                  'Usia Lahir Gestasi: $gestationalWeeks minggu | '
                                  'PMA Usia Uji: ${_currentPmaWeeks.toStringAsFixed(1)} mgg',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FilterChip(
                            selected: _showAgeLine,
                            label: Text(
                              _showAgeLine ? 'Garis Vertikal ON' : 'Garis Vertikal OFF',
                              style: const TextStyle(fontSize: 10),
                            ),
                            onSelected: (val) => setState(() => _showAgeLine = val),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        FentonCalculator.formatPMAStatus(_currentPmaWeeks),
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      if (_fentonPoints.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.timeline, size: 16, color: Colors.blue.shade800),
                            const SizedBox(width: 4),
                            Text(
                              'Tercatat ${_fentonPoints.length} titik pengukuran pada Kurva Fenton (otomatik terhubung garis kurva).',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
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
                          'Geser / perbesar (zoom) kurva untuk melihat garis tren perkembangan bayi antar kunjungan.',
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
                              aspectRatio: 1.0 / 1.414, // Proporsi A4 tegak
                              child: CustomPaint(
                                painter: FentonChartPainter(
                                  image: _chartImage,
                                  currentPmaWeeks: _currentPmaWeeks,
                                  points: _fentonPoints,
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
