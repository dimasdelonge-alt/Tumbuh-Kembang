import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Data point pengukuran untuk Kurva Fenton pada tanggal/kunjungan tertentu.
class FentonPoint {
  final DateTime date;
  final double pmaWeeks;
  final double? weightKg;
  final double? lengthCm;
  final double? headCircumferenceCm;
  final bool isCurrentExam;

  FentonPoint({
    required this.date,
    required this.pmaWeeks,
    this.weightKg,
    this.lengthCm,
    this.headCircumferenceCm,
    this.isCurrentExam = false,
  });
}

/// Painter untuk memplot titik BB, PB, dan LK serta Garis Usia Pasca-Menstrual (PMA)
/// dan menghubungkannya menjadi Kurva Pertumbuhan Lintas Kunjungan (Longitudinal).
class FentonChartPainter extends CustomPainter {
  final ui.Image? image;
  final double currentPmaWeeks; // Postmenstrual Age kunjungan ini (22.0 .. 50.0 mgg)
  final List<FentonPoint> points; // Semua titik pengukuran historis
  final bool showAgeLine; // Apakah garis vertikal merah ditampilkan
  final String sex; // 'M' atau 'F'

  FentonChartPainter({
    required this.image,
    required this.currentPmaWeeks,
    required this.points,
    this.showAgeLine = true,
    required this.sex,
  });

  // Koordinat relatif terhadap gambar Fenton 2013
  static const double _xLeftWeek22 = 0.088;
  static const double _xRightWeek50 = 0.905;

  // Y-axis Length (15 cm - 60 cm)
  static const double _yLength15cm = 0.448;
  static const double _yLength60cm = 0.052;

  // Y-axis Head Circumference (15 cm - 42 cm)
  static const double _yHead15cm = 0.448;
  static const double _yHead42cm = 0.210;

  // Y-axis Weight (0.0 kg - 6.5 kg)
  static const double _yWeight0kg = 0.895;
  static const double _yWeight65kg = 0.468;

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null) return;

    final Rect dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Rect srcRect = Rect.fromLTWH(
      0,
      0,
      image!.width.toDouble(),
      image!.height.toDouble(),
    );

    // 1. Gambar latar belakang kurva Fenton
    final Paint imgPaint = Paint()..filterQuality = FilterQuality.high;
    canvas.drawImageRect(image!, srcRect, dstRect, imgPaint);

    final double w = size.width;
    final double h = size.height;

    // Sort points berdasarkan PMA terurut menaik
    final sortedPoints = List<FentonPoint>.from(points)
      ..sort((a, b) => a.pmaWeeks.compareTo(b.pmaWeeks));

    // 2. Gambar Garis Usia Vertikal (Age Line) Merah - jika aktif
    if (showAgeLine) {
      final double clampedPMA = currentPmaWeeks.clamp(22.0, 50.0);
      final double pmaNormX = _xLeftWeek22 +
          (clampedPMA - 22.0) / (50.0 - 22.0) * (_xRightWeek50 - _xLeftWeek22);
      final double xPos = pmaNormX * w;

      final Paint ageLinePaint = Paint()
        ..color = Colors.red.withValues(alpha: 0.85)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(xPos, 0.04 * h),
        Offset(xPos, 0.90 * h),
        ageLinePaint,
      );

      _drawAgeTag(
        canvas,
        Offset(xPos, 0.02 * h),
        '${clampedPMA.toStringAsFixed(1)} mgg PMA',
      );
    }

    // 3. Gambar Garis Hubung (Polyline Kurva Pertumbuhan Pasien)
    // --- Garis Berat Badan (BB) ---
    _drawMetricLines(
      canvas: canvas,
      size: size,
      points: sortedPoints,
      color: Colors.blue.shade800,
      getValue: (p) => p.weightKg,
      getYNorm: (val) {
        final clamped = val.clamp(0.0, 6.5);
        return _yWeight0kg - (clamped / 6.5) * (_yWeight0kg - _yWeight65kg);
      },
    );

    // --- Garis Panjang Badan (PB) ---
    _drawMetricLines(
      canvas: canvas,
      size: size,
      points: sortedPoints,
      color: Colors.green.shade800,
      getValue: (p) => p.lengthCm,
      getYNorm: (val) {
        final clamped = val.clamp(15.0, 60.0);
        return _yLength15cm -
            ((clamped - 15.0) / (60.0 - 15.0)) * (_yLength15cm - _yLength60cm);
      },
    );

    // --- Garis Lingkar Kepala (LK) ---
    _drawMetricLines(
      canvas: canvas,
      size: size,
      points: sortedPoints,
      color: Colors.deepPurple,
      getValue: (p) => p.headCircumferenceCm,
      getYNorm: (val) {
        final clamped = val.clamp(15.0, 42.0);
        return _yHead15cm -
            ((clamped - 15.0) / (42.0 - 15.0)) * (_yHead15cm - _yHead42cm);
      },
    );

    // 4. Gambar Titik-titik Pengukuran (Dots + Labels)
    for (final p in sortedPoints) {
      final double pmaNormX = _xLeftWeek22 +
          (p.pmaWeeks.clamp(22.0, 50.0) - 22.0) /
              (50.0 - 22.0) *
              (_xRightWeek50 - _xLeftWeek22);
      final double xPos = pmaNormX * w;

      // BB Point
      if (p.weightKg != null && p.weightKg! > 0) {
        final double normY = _yWeight0kg -
            (p.weightKg!.clamp(0.0, 6.5) / 6.5) * (_yWeight0kg - _yWeight65kg);
        _drawPoint(
          canvas: canvas,
          position: Offset(xPos, normY * h),
          color: Colors.blue.shade800,
          label: '${p.weightKg!.toStringAsFixed(2)} kg',
          isCurrent: p.isCurrentExam,
        );
      }

      // PB Point
      if (p.lengthCm != null && p.lengthCm! > 0) {
        final double normY = _yLength15cm -
            ((p.lengthCm!.clamp(15.0, 60.0) - 15.0) / (60.0 - 15.0)) *
                (_yLength15cm - _yLength60cm);
        _drawPoint(
          canvas: canvas,
          position: Offset(xPos, normY * h),
          color: Colors.green.shade800,
          label: '${p.lengthCm!.toStringAsFixed(1)} cm',
          isCurrent: p.isCurrentExam,
        );
      }

      // LK Point
      if (p.headCircumferenceCm != null && p.headCircumferenceCm! > 0) {
        final double normY = _yHead15cm -
            ((p.headCircumferenceCm!.clamp(15.0, 42.0) - 15.0) / (42.0 - 15.0)) *
                (_yHead15cm - _yHead42cm);
        _drawPoint(
          canvas: canvas,
          position: Offset(xPos, normY * h),
          color: Colors.deepPurple,
          label: '${p.headCircumferenceCm!.toStringAsFixed(1)} cm',
          isCurrent: p.isCurrentExam,
        );
      }
    }
  }

  void _drawMetricLines({
    required Canvas canvas,
    required Size size,
    required List<FentonPoint> points,
    required Color color,
    required double? Function(FentonPoint) getValue,
    required double Function(double) getYNorm,
  }) {
    final validOffsets = <Offset>[];

    for (final p in points) {
      final val = getValue(p);
      if (val != null && val > 0) {
        final double pmaNormX = _xLeftWeek22 +
            (p.pmaWeeks.clamp(22.0, 50.0) - 22.0) /
                (50.0 - 22.0) *
                (_xRightWeek50 - _xLeftWeek22);
        final double xPos = pmaNormX * size.width;
        final double yPos = getYNorm(val) * size.height;
        validOffsets.add(Offset(xPos, yPos));
      }
    }

    if (validOffsets.length >= 2) {
      final Path path = Path();
      path.moveTo(validOffsets.first.dx, validOffsets.first.dy);
      for (int i = 1; i < validOffsets.length; i++) {
        path.lineTo(validOffsets[i].dx, validOffsets[i].dy);
      }

      final Paint linePaint = Paint()
        ..color = color
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(path, linePaint);
    }
  }

  void _drawPoint({
    required Canvas canvas,
    required Offset position,
    required Color color,
    required String label,
    required bool isCurrent,
  }) {
    final double radius = isCurrent ? 6.0 : 4.5;

    // Halo luar titik
    final Paint haloPaint = Paint()
      ..color = color.withValues(alpha: isCurrent ? 0.35 : 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, radius + 4, haloPaint);

    // Titik tengah padat
    final Paint dotPaint = Paint()
      ..color = isCurrent ? color : color.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, radius, dotPaint);

    // Ring luar putih
    final Paint strokePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(position, radius, strokePaint);

    // Label teks di samping titik
    final TextSpan span = TextSpan(
      text: label,
      style: TextStyle(
        color: Colors.white,
        fontSize: isCurrent ? 10 : 8.5,
        fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.8),
            blurRadius: 3,
          ),
        ],
      ),
    );

    final TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    )..layout();

    final Rect bgRect = Rect.fromLTWH(
      position.dx + 8,
      position.dy - 10,
      tp.width + 10,
      tp.height + 4,
    );

    final Paint bgPaint = Paint()
      ..color = color.withValues(alpha: isCurrent ? 0.9 : 0.75)
      ..style = PaintingStyle.fill;
    final RRect rrect = RRect.fromRectAndRadius(bgRect, const Radius.circular(4));

    canvas.drawRRect(rrect, bgPaint);
    tp.paint(canvas, Offset(position.dx + 13, position.dy - 8));
  }

  void _drawAgeTag(Canvas canvas, Offset center, String text) {
    final TextSpan span = TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );
    final TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    )..layout();

    final Rect bgRect = Rect.fromCenter(
      center: center,
      width: tp.width + 14,
      height: tp.height + 6,
    );
    final RRect rrect = RRect.fromRectAndRadius(bgRect, const Radius.circular(6));

    final Paint bgPaint = Paint()..color = Colors.red.shade800;
    canvas.drawRRect(rrect, bgPaint);
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant FentonChartPainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.currentPmaWeeks != currentPmaWeeks ||
        oldDelegate.points != points ||
        oldDelegate.showAgeLine != showAgeLine ||
        oldDelegate.sex != sex;
  }
}
