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

  void _calculateAtPoint(LineTouchResponse? response) {
    if (response == null) return;
    final spots = response.lineBarSpots;
    if (spots == null || spots.length < 2) return;

    // Filter out spots that are not part of the reference lines (barIndex < 5)
    final refSpots = spots.where((s) => s.barIndex < 5).toList();
    if (refSpots.length < 2) return;

    // Sort by chart Y coordinate ascending
    refSpots.sort((a, b) => a.y.compareTo(b.y));

    // Find the index of the spot with the minimum distance
    int minIndex = 0;
    double minDistance = refSpots[0].distance;
    for (int i = 1; i < refSpots.length; i++) {
      if (refSpots[i].distance < minDistance) {
        minDistance = refSpots[i].distance;
        minIndex = i;
      }
    }

    double dx = refSpots[0].x;
    double dy;

    if (minIndex == 0 && refSpots[1].distance > refSpots[0].distance) {
      final y0 = refSpots[0].y;
      final y1 = refSpots[1].y;
      final d0 = refSpots[0].distance;
      final d1 = refSpots[1].distance;
      
      bool isBelow = false;
      if (refSpots.length > 2) {
        final y2 = refSpots[2].y;
        final d2 = refSpots[2].distance;
        final s1 = (d1 - d0) / (y1 - y0);
        final s2 = (d2 - d1) / (y2 - y1);
        if (s1 > 0 && s2 > 0 && (s1 - s2).abs() < s1 * 0.5) {
          isBelow = true;
        }
      }
      
      if (isBelow) {
        final s = (d1 - d0) / (y1 - y0);
        dy = y0 - (s > 0 ? d0 / s : 0);
      } else {
        final s = (d0 + d1) / (y1 - y0);
        dy = y0 + (s > 0 ? d0 / s : 0);
      }
    } else if (minIndex == refSpots.length - 1) {
      final n = refSpots.length;
      final yN1 = refSpots[n-1].y;
      final yN2 = refSpots[n-2].y;
      final dN1 = refSpots[n-1].distance;
      final dN2 = refSpots[n-2].distance;
      
      bool isAbove = false;
      if (n > 2) {
        final yN3 = refSpots[n-3].y;
        final dN3 = refSpots[n-3].distance;
        final s1 = (dN2 - dN1) / (yN1 - yN2);
        final s2 = (dN3 - dN2) / (yN2 - yN3);
        if (s1 > 0 && s2 > 0 && (s1 - s2).abs() < s1 * 0.5) {
          isAbove = true;
        }
      }
      
      if (isAbove) {
        final s = (dN2 - dN1) / (yN1 - yN2);
        dy = yN1 + (s > 0 ? dN1 / s : 0);
      } else {
        final s = (dN1 + dN2) / (yN1 - yN2);
        dy = yN2 + (s > 0 ? dN2 / s : 0);
      }
    } else {
      final y0 = refSpots[minIndex].y;
      final d0 = refSpots[minIndex].distance;
      
      final yPrev = refSpots[minIndex - 1].y;
      final dPrev = refSpots[minIndex - 1].distance;
      
      final yNext = refSpots[minIndex + 1].y;
      final dNext = refSpots[minIndex + 1].distance;
      
      final sPrev = (d0 + dPrev) / (y0 - yPrev);
      final sNext = (d0 + dNext) / (yNext - y0);
      
      if (dPrev < dNext) {
        dy = yPrev + (sPrev > 0 ? dPrev / sPrev : 0);
      } else {
        dy = y0 + (sNext > 0 ? d0 / sNext : 0);
      }
    }

    final table = WhoGrowthData.instance.tableFor(
      indicator: widget.indicator,
      sex: widget.sex,
      measuredLying: widget.measuredLying,
    );
    if (table == null || table.isEmpty) return;

    final minX = _isAgeBased ? table.first.x / 30.4375 : table.first.x;
    final maxX = _isAgeBased ? table.last.x / 30.4375 : table.last.x;

    if (dx < minX || dx > maxX) return;

    final double actualX = _isAgeBased ? dx * 30.4375 : dx;
    final double actualY = dy;

    String resultText = '';
    try {
      final who = WhoGrowthData.instance;
      if (_isAgeBased) {
        final z = who.zscoreForAge(
          indicator: widget.indicator,
          sex: widget.sex,
          value: actualY,
          ageDays: actualX,
        );
        if (z != null) {
          final ageMonths = dx;
          final status = NutritionClassifier.classify(
            widget.indicator,
            z.zScore,
            ageMonths: ageMonths.round(),
          );
          
          final xLabel = 'Umur: ${ageMonths.toStringAsFixed(1)} bln';
          final yLabel = '${widget.indicator.code}: ${actualY.toStringAsFixed(1)}';
          resultText = '$xLabel, $yLabel\nZ-Score: ${z.zScore.toStringAsFixed(2)} (${status.label})';
        }
      } else {
        final z = who.zscoreWeightForLength(
          sex: widget.sex,
          weightKg: actualY,
          lengthHeightCm: actualX,
          measuredLying: widget.measuredLying,
        );
        if (z != null) {
          final status = NutritionClassifier.classify(
            widget.indicator,
            z.zScore,
            ageMonths: 12,
          );
          final xLabel = 'Tinggi/Panjang: ${actualX.toStringAsFixed(1)} cm';
          final yLabel = 'BB: ${actualY.toStringAsFixed(1)} kg';
          resultText = '$xLabel, $yLabel\nZ-Score: ${z.zScore.toStringAsFixed(2)} (${status.label})';
        }
      }
    } catch (e) {
      resultText = 'Gagal menghitung hasil pada titik ini';
    }

    if (resultText.isNotEmpty) {
      setState(() {
        _tappedSpot = FlSpot(dx, dy);
        _tappedCalculationResult = resultText;
      });
    }
  }

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

  Widget _buildChart(BuildContext context, List<LmsPoint> table, _ChartPatientData? patientData) {
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
      final currentSpot = FlSpot(toDisplayX(widget.pointX), widget.pointValue);
      final exists = spots.any((s) => (s.x - currentSpot.x).abs() < 0.01);
      if (!exists) {
        spots.add(currentSpot);
      }

      // Urutkan titik agar garis ditarik secara kronologis
      spots.sort((a, b) => a.x.compareTo(b.x));

      if (spots.isNotEmpty) {
        lineBars.add(LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2.0,
          color: Colors.red.shade700,
          isStrokeCapRound: true,
          dashArray: [4, 4], // Garis putus-putus (imajiner)
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              final isCurrentPoint = (spot.x - toDisplayX(widget.pointX)).abs() < 0.01;
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

    // Titik kalkulasi interaktif ketika kotak diklik.
    if (_tappedSpot != null) {
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
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                    if (event is FlTapUpEvent) {
                      _calculateAtPoint(response);
                    }
                  },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.blueGrey.shade900.withOpacity(0.95),
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    maxContentWidth: 150,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final barIndex = touchedSpot.barIndex;
                        final yValue = touchedSpot.y;
                        
                        String label = '';
                        TextStyle textStyle;
                        
                        if (barIndex < zLines.length) {
                          final z = zLines[barIndex];
                          label = z == 0 ? 'Median' : 'SD ${z > 0 ? '+$z' : z}';
                          textStyle = TextStyle(
                            color: _zColorLight(z),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          );
                        } else if (_tappedSpot != null && barIndex == lineBars.length - 1) {
                          label = 'Titik Klik';
                          textStyle = const TextStyle(
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          );
                        } else {
                          label = 'Pasien';
                          textStyle = TextStyle(
                            color: Colors.red.shade300,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          );
                        }
                        
                        final unit = _getYUnit(widget.indicator);
                        final valStr = '${yValue.toStringAsFixed(1)} $unit';
                        
                        // Let's find the first spot to prepend the X value
                        if (touchedSpots.indexOf(touchedSpot) == 0) {
                          final xText = _getXText(touchedSpot.x);
                          return LineTooltipItem(
                            '$xText\n$label: $valStr',
                            textStyle,
                          );
                        }
                        
                        return LineTooltipItem(
                          '$label: $valStr',
                          textStyle,
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Garis putus-putus merah = tren pertumbuhan pasien • Klik kotak/grid untuk menghitung Z-score titik tersebut',
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

  Color _zColorLight(double z) {
    if (z == 0) return Colors.greenAccent;
    if (z.abs() == 1) return Colors.lightGreenAccent;
    if (z.abs() == 2) return Colors.orangeAccent;
    return Colors.redAccent;
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
