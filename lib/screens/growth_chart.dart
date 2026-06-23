import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../modules/growth/nutrition_classifier.dart';
import '../modules/growth/who_growth_data.dart';
import '../modules/growth/zscore_calculator.dart';

/// Menampilkan kurva pertumbuhan WHO untuk satu indikator, lengkap dengan
/// garis Z-score referensi (-3, -2, 0, +1/+2/+3) dan penanda titik pasien.
class GrowthChartScreen extends StatelessWidget {
  final GrowthIndicator indicator;
  final String sex;
  final bool measuredLying;

  /// Sumbu-x titik pasien: hari (umur) atau cm (BB/TB).
  final double pointX;

  /// Nilai pengukuran pasien (kg / cm / IMT).
  final double pointValue;

  const GrowthChartScreen({
    super.key,
    required this.indicator,
    required this.sex,
    required this.measuredLying,
    required this.pointX,
    required this.pointValue,
  });

  bool get _isAgeBased =>
      indicator != GrowthIndicator.weightForLengthHeight;

  @override
  Widget build(BuildContext context) {
    final table = WhoGrowthData.instance.tableFor(
      indicator: indicator,
      sex: sex,
      measuredLying: measuredLying,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Kurva ${indicator.code}')),
      body: table == null || table.isEmpty
          ? const Center(child: Text('Data kurva tidak tersedia'))
          : Padding(
              padding: const EdgeInsets.fromLTRB(8, 24, 24, 16),
              child: _buildChart(context, table),
            ),
    );
  }

  Widget _buildChart(BuildContext context, List<LmsPoint> table) {
    final zLines = NutritionClassifier.referenceLines(indicator);

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

    // Titik pasien.
    final px = toDisplayX(pointX);
    lineBars.add(LineChartBarData(
      spots: [FlSpot(px, pointValue)],
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

    final xAxisLabel = _isAgeBased ? 'Umur (bulan)' : 'Panjang/Tinggi (cm)';

    return Column(
      children: [
        _legend(),
        const SizedBox(height: 12),
        Expanded(
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
                  axisNameWidget: Text(indicator.code),
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
        ),
        const SizedBox(height: 8),
        Text(
          'Titik merah = pengukuran pasien',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _legend() {
    final zLines = NutritionClassifier.referenceLines(indicator);
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
}
