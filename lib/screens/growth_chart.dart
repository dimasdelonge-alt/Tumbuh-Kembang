import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../modules/growth/growth_assessment.dart';
import '../modules/growth/nutrition_classifier.dart';
import '../modules/growth/who_growth_data.dart';
import '../modules/growth/zscore_calculator.dart';

class _ChartPatientData {
  final Patient patient;
  final List<({Examination exam, GrowthMeasurement growth})> history;
  _ChartPatientData({required this.patient, required this.history});
}

/// Menampilkan kurva pertumbuhan WHO untuk satu indikator, lengkap dengan
/// garis Z-score referensi (-3, -2, 0, +1/+2/+3) dan garis tren pertumbuhan pasien.
class GrowthChartScreen extends StatefulWidget {
  final GrowthIndicator indicator;
  final String sex;
  final bool measuredLying;

  /// Sumbu-x titik pasien: hari (umur) atau cm (BB/TB).
  final double pointX;

  /// Nilai pengukuran pasien (kg / cm / IMT).
  final double pointValue;

  /// ID pasien untuk memuat riwayat pertumbuhan longitudinal.
  final String? patientId;

  const GrowthChartScreen({
    super.key,
    required this.indicator,
    required this.sex,
    required this.measuredLying,
    required this.pointX,
    required this.pointValue,
    this.patientId,
  });

  @override
  State<GrowthChartScreen> createState() => _GrowthChartScreenState();
}

class _GrowthChartScreenState extends State<GrowthChartScreen> {
  final _transformationController = TransformationController();
  _ChartPatientData? _patientData;
  bool _loading = true;
  FlSpot? _tappedSpot;
  String? _tappedCalculationResult;

  bool get _isAgeBased =>
      widget.indicator != GrowthIndicator.weightForLengthHeight;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onZoomChanged);
    _loadData();
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onZoomChanged);
    _transformationController.dispose();
    super.dispose();
  }

  void _onZoomChanged() {
    setState(() {}); // Redraw to update floating zoom-reset button visibility
  }

  void _resetZoom() {
    setState(() {
      _transformationController.value = Matrix4.identity();
    });
  }

  Future<void> _loadData() async {
    if (widget.patientId == null) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
      return;
    }
    try {
      final repo = Provider.of<AppRepository>(context, listen: false);
      final patient = await repo.getPatient(widget.patientId!);
      if (patient != null) {
        final history = await repo.growthHistory(widget.patientId!);
        if (mounted) {
          setState(() {
            _patientData = _ChartPatientData(patient: patient, history: history);
            _loading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // --- Konversi pixel → data koordinat ---

  /// Hitung data range dari semua line bars.
  ({double minX, double maxX, double minY, double maxY}) _computeDataRange(
      List<LineChartBarData> bars) {
    double minX = double.infinity, maxX = -double.infinity;
    double minY = double.infinity, maxY = -double.infinity;
    for (final bar in bars) {
      for (final s in bar.spots) {
        if (s.x < minX) minX = s.x;
        if (s.x > maxX) maxX = s.x;
        if (s.y < minY) minY = s.y;
        if (s.y > maxY) maxY = s.y;
      }
    }
    return (minX: minX, maxX: maxX, minY: minY, maxY: maxY);
  }

  /// Konversi posisi tap (pixel lokal dalam widget LineChart) ke koordinat data.
  FlSpot? _pixelToData({
    required Offset tapLocal,
    required Size chartSize,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
  }) {
    // Estimasi layout fl_chart:
    // leftTitles  = reservedSize(36) + axisNameSize(~16) = ~52
    // bottomTitles = reservedSize(28) + axisNameSize(~16) = ~44
    const double leftPad = 52;
    const double bottomPad = 44;

    final drawLeft = leftPad;
    final drawRight = chartSize.width;
    final drawTop = 0.0;
    final drawBottom = chartSize.height - bottomPad;

    final dx = tapLocal.dx;
    final dy = tapLocal.dy;

    if (dx < drawLeft || dx > drawRight ||
        dy < drawTop || dy > drawBottom) {
      return null;
    }

    final dataX = minX +
        (dx - drawLeft) / (drawRight - drawLeft) * (maxX - minX);
    final dataY = maxY -
        (dy - drawTop) / (drawBottom - drawTop) * (maxY - minY);

    return FlSpot(dataX, dataY);
  }

  /// Dipanggil saat pengguna mengetuk area kurva secara bebas.
  void _onChartTapped(FlSpot spot) {
    final unit = _getYUnit(widget.indicator);
    final xText = _getXText(spot.x);
    final yVal = spot.y.toStringAsFixed(1);

    // Hitung Z-score di titik tersebut
    String zInfo = '';
    try {
      final who = WhoGrowthData.instance;
      if (_isAgeBased) {
        final ageDays = spot.x * 30.4375;
        final z = who.zscoreForAge(
          indicator: widget.indicator,
          sex: widget.sex,
          value: spot.y,
          ageDays: ageDays,
        );
        if (z != null) {
          final status = NutritionClassifier.classify(
            widget.indicator,
            z.zScore,
            ageMonths: spot.x.round(),
          );
          zInfo =
              '\nZ-Score: ${z.zScore.toStringAsFixed(2)} (${status.label})';
        }
      } else {
        final z = who.zscoreWeightForLength(
          sex: widget.sex,
          weightKg: spot.y,
          lengthHeightCm: spot.x,
          measuredLying: widget.measuredLying,
        );
        if (z != null) {
          final status = NutritionClassifier.classify(
            widget.indicator,
            z.zScore,
            ageMonths: 12,
          );
          zInfo =
              '\nZ-Score: ${z.zScore.toStringAsFixed(2)} (${status.label})';
        }
      }
    } catch (_) {}

    setState(() {
      _tappedSpot = spot;
      _tappedCalculationResult = '$xText, $yVal $unit$zInfo';
    });
  }

  // --- Build UI ---

  @override
  Widget build(BuildContext context) {
    final table = WhoGrowthData.instance.tableFor(
      indicator: widget.indicator,
      sex: widget.sex,
      measuredLying: widget.measuredLying,
    );

    if (table == null || table.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Kurva ${widget.indicator.code}')),
        body: const Center(child: Text('Data kurva tidak tersedia')),
      );
    }

    if (widget.patientId != null && _loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Kurva ${widget.indicator.code}')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final isZoomed = _transformationController.value != Matrix4.identity();

    return Scaffold(
      appBar: AppBar(title: Text('Kurva ${widget.indicator.code}')),
      floatingActionButton: isZoomed
          ? FloatingActionButton.small(
              onPressed: _resetZoom,
              tooltip: 'Reset Zoom',
              child: const Icon(Icons.zoom_out),
            )
          : null,
      bottomNavigationBar: _tappedCalculationResult != null
          ? Container(
              padding: const EdgeInsets.all(12),
              color: Colors.teal.shade50,
              child: SafeArea(
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.teal),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _tappedCalculationResult!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _tappedSpot = null;
                          _tappedCalculationResult = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 24, 24, 16),
        child: _buildChart(context, table, _patientData),
      ),
    );
  }

  Widget _buildChart(
      BuildContext context, List<LmsPoint> table, _ChartPatientData? patientData) {
    final zLines = NutritionClassifier.referenceLines(widget.indicator);

    // Konversi sumbu-x ke satuan tampilan: bulan (umur) atau cm.
    double toDisplayX(double x) => _isAgeBased ? x / 30.4375 : x;

    final lineBars = <LineChartBarData>[];
    for (final z in zLines) {
      final spots = <FlSpot>[];
      for (final p in table) {
        final v = ZScoreCalculator.valueAtZ(p, z);
        spots.add(FlSpot(toDisplayX(p.x), v));
      }
      final isMedian = z == 0;
      lineBars.add(LineChartBarData(
        spots: spots,
        isCurved: true,
        barWidth: isMedian ? 2.2 : 1.2,
        color: _zColor(z),
        dotData: const FlDotData(show: false),
      ));
    }

    // Garis imajiner riwayat pasien & titik-titik pengukurannya.
    if (patientData != null) {
      final spots = <FlSpot>[];
      for (final r in patientData.history) {
        final assessment = GrowthAssessment.fromMeasurement(
          birthDate: patientData.patient.birthDate,
          examDate: r.exam.examDate,
          gestationalWeeks: patientData.patient.gestationalWeeks,
          sex: patientData.patient.sex,
          m: r.growth,
        );
        final res = assessment.byIndicator(widget.indicator);
        if (res != null) {
          spots.add(FlSpot(toDisplayX(res.chartX), res.value));
        }
      }

      // Tambahkan titik saat ini jika belum terdaftar
      final currentSpot =
          FlSpot(toDisplayX(widget.pointX), widget.pointValue);
      final exists = spots.any((s) => (s.x - currentSpot.x).abs() < 0.01);
      if (!exists) spots.add(currentSpot);

      // Urutkan titik agar garis ditarik secara kronologis
      spots.sort((a, b) => a.x.compareTo(b.x));

      if (spots.isNotEmpty) {
        lineBars.add(LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2.0,
          color: Colors.red.shade700,
          isStrokeCapRound: true,
          dashArray: [4, 4],
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              final isCurrentPoint =
                  (spot.x - toDisplayX(widget.pointX)).abs() < 0.01;
              return FlDotCirclePainter(
                radius: isCurrentPoint ? 5 : 3.5,
                color: isCurrentPoint ? Colors.red : Colors.red.shade700,
                strokeWidth: isCurrentPoint ? 2 : 1,
                strokeColor: Colors.white,
              );
            },
          ),
        ));
      }
    } else {
      // Titik pasien tunggal.
      final px = toDisplayX(widget.pointX);
      lineBars.add(LineChartBarData(
        spots: [FlSpot(px, widget.pointValue)],
        barWidth: 0,
        color: Colors.black,
        dotData: FlDotData(
          show: true,
          getDotPainter: (s, _, __, ___) => FlDotCirclePainter(
            radius: 5,
            color: Colors.red,
            strokeWidth: 2,
            strokeColor: Colors.white,
          ),
        ),
      ));
    }

    // Data range untuk konversi pixel (dihitung dari kurva-kurva standar)
    final range = _computeDataRange(lineBars);

    // Titik teal di lokasi yang diklik & garis crosshair terputus (hanya sampai ke sumbu)
    if (_tappedSpot != null) {
      // 1. Garis putus-putus horizontal dari sumbu Y (range.minX) ke titik ketuk
      lineBars.add(LineChartBarData(
        spots: [FlSpot(range.minX, _tappedSpot!.y), _tappedSpot!],
        isCurved: false,
        barWidth: 1.2,
        color: Colors.teal.shade600.withOpacity(0.8),
        dashArray: [4, 4],
        dotData: const FlDotData(show: false),
      ));

      // 2. Garis putus-putus vertikal dari sumbu X (range.minY) ke titik ketuk
      lineBars.add(LineChartBarData(
        spots: [FlSpot(_tappedSpot!.x, range.minY), _tappedSpot!],
        isCurved: false,
        barWidth: 1.2,
        color: Colors.teal.shade600.withOpacity(0.8),
        dashArray: [4, 4],
        dotData: const FlDotData(show: false),
      ));

      // 3. Titik teal di lokasi yang diklik
      lineBars.add(LineChartBarData(
        spots: [_tappedSpot!],
        barWidth: 0,
        color: Colors.transparent,
        dotData: FlDotData(
          show: true,
          getDotPainter: (s, _, __, ___) => FlDotCirclePainter(
            radius: 6,
            color: Colors.teal,
            strokeWidth: 2,
            strokeColor: Colors.white,
          ),
        ),
      ));
    }

    final xAxisLabel = _isAgeBased ? 'Umur (bulan)' : 'Panjang/Tinggi (cm)';

    return Column(
      children: [
        _legend(),
        const SizedBox(height: 12),
        Expanded(
          child: InteractiveViewer(
            transformationController: _transformationController,
            panEnabled: true,
            scaleEnabled: true,
            minScale: 1.0,
            maxScale: 5.0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapUp: (details) {
                    final spot = _pixelToData(
                      tapLocal: details.localPosition,
                      chartSize: Size(
                          constraints.maxWidth, constraints.maxHeight),
                      minX: range.minX,
                      maxX: range.maxX,
                      minY: range.minY,
                      maxY: range.maxY,
                    );
                    if (spot != null) _onChartTapped(spot);
                  },
                  child: LineChart(
                    LineChartData(
                      lineBarsData: lineBars,
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          axisNameWidget: Text(xAxisLabel),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (v, meta) => Text(
                              v.toStringAsFixed(0),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                        leftTitles: AxisTitles(
                          axisNameWidget: Text(widget.indicator.code),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                            getTitlesWidget: (v, meta) => Text(
                              v.toStringAsFixed(0),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: true),
                      borderData: FlBorderData(show: true),
                      lineTouchData: const LineTouchData(enabled: false),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Garis putus-putus merah = tren pertumbuhan pasien • Klik area kurva untuk menghitung Z-score',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _legend() {
    final zLines = NutritionClassifier.referenceLines(widget.indicator);
    return Wrap(
      spacing: 12,
      children: zLines
          .map((z) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 16, height: 3, color: _zColor(z)),
                  const SizedBox(width: 4),
                  Text(z == 0 ? 'Median' : 'SD ${z > 0 ? '+$z' : z}',
                      style: const TextStyle(fontSize: 11)),
                ],
              ))
          .toList(),
    );
  }

  Color _zColor(double z) {
    if (z == 0) return Colors.green.shade700;
    if (z.abs() == 1) return Colors.lightGreen;
    if (z.abs() == 2) return Colors.orange;
    return Colors.red;
  }

  String _getXText(double x) {
    if (widget.indicator == GrowthIndicator.weightForLengthHeight) {
      return 'Tinggi/Panjang: ${x.toStringAsFixed(1)} cm';
    } else {
      return 'Umur: ${x.toStringAsFixed(1)} bln';
    }
  }

  String _getYUnit(GrowthIndicator indicator) {
    switch (indicator) {
      case GrowthIndicator.weightForAge:
      case GrowthIndicator.weightForLengthHeight:
        return 'kg';
      case GrowthIndicator.lengthHeightForAge:
      case GrowthIndicator.headCircumferenceForAge:
        return 'cm';
      case GrowthIndicator.bmiForAge:
        return 'kg/m²';
    }
  }
}
