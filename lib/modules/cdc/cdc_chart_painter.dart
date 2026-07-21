import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'cdc_calculator.dart';

/// Data point pengukuran tinggi anak pada usia tertentu (dalam tahun).
class CdcPoint {
  final DateTime date;
  final double ageYears;
  final double heightCm;
  final bool isCurrentExam;

  CdcPoint({
    required this.date,
    required this.ageYears,
    required this.heightCm,
    this.isCurrentExam = false,
  });
}

/// Painter untuk memplot titik tinggi anak serta mengarsir jalur/garis tren Tinggi Potensi Genetik (TPG)
/// di atas Kurva Pertumbuhan CDC 2000 (Usia 2-20 Tahun).
class CdcChartPainter extends CustomPainter {
  final ui.Image? image;
  final double currentAgeYears;
  final List<CdcPoint> points;
  final TpgResult? tpg;
  final RealtimeTpgResult? realtimeTpg;
  final bool showAgeLine;
  final String sex;

  CdcChartPainter({
    required this.image,
    required this.currentAgeYears,
    required this.points,
    this.tpg,
    this.realtimeTpg,
    this.showAgeLine = true,
    required this.sex,
  });

  // Koordinat relatif sumbu X (Usia 2 - 20 Tahun)
  static const double _xAge2 = 0.170;
  static const double _xAge20 = 0.820;

  // Koordinat relatif sumbu Y Stature (80 cm - 190 cm)
  // Disesuaikan presisi agar pangkal usia 2.0 thn berada pas di atas garis 80cm (83-92cm)
  static const double _yStature80cm = 0.695;
  static const double _yStature190cm = 0.138;

  double _ageToX(double ageYears, double w) {
    final xNorm = _xAge2 + (ageYears - 2.0) / 18.0 * (_xAge20 - _xAge2);
    return xNorm * w;
  }

  double _heightToY(double heightCm, double h) {
    final yNorm = _yStature80cm -
        ((heightCm - 80.0) / 110.0) * (_yStature80cm - _yStature190cm);
    return yNorm * h;
  }

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

    // 1. Gambar latar belakang kurva CDC 2000
    final Paint imgPaint = Paint()..filterQuality = FilterQuality.high;
    canvas.drawImageRect(image!, srcRect, dstRect, imgPaint);

    final double w = size.width;
    final double h = size.height;

    // 2. Gambar Kurva Trajektori TPG (min/max/target) dari usia 2-20
    if (tpg != null) {
      _drawTpgTrajectory(canvas, w, h);
    }

    // 3. Garis Usia Vertikal (Age Line) Merah untuk kunjungan saat ini
    if (showAgeLine && currentAgeYears >= 2.0 && currentAgeYears <= 20.0) {
      final double xPos = _ageToX(currentAgeYears, w);

      final Paint ageLinePaint = Paint()
        ..color = Colors.red.withValues(alpha: 0.85)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(xPos, 0.05 * h),
        Offset(xPos, 0.82 * h),
        ageLinePaint,
      );

      _drawTag(
        canvas,
        Offset(xPos, 0.03 * h),
        'Usia ${currentAgeYears.toStringAsFixed(1)} Thn',
        Colors.red.shade800,
      );

      // Rentang Ideal TPG di Usia Saat Ini (pada garis vertikal merah)
      if (realtimeTpg != null) {
        final double yMinPos = _heightToY(realtimeTpg!.minExpectedCm, h);
        final double yMaxPos = _heightToY(realtimeTpg!.maxExpectedCm, h);
        final double yTgtPos = _heightToY(realtimeTpg!.targetExpectedCm, h);

        // Rentang garis hijau tebal di garis usia saat ini
        final Paint rangePaint = Paint()
          ..color = Colors.green.shade700
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(
            Offset(xPos, yMinPos), Offset(xPos, yMaxPos), rangePaint);

        // Titik Target TPG
        final Paint tgtDotPaint = Paint()
          ..color = Colors.green.shade900
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(xPos, yTgtPos), 5.0, tgtDotPaint);

        _drawTag(
          canvas,
          Offset(xPos + 60, yTgtPos),
          'Ideal: ${realtimeTpg!.minExpectedCm.toStringAsFixed(1)}–${realtimeTpg!.maxExpectedCm.toStringAsFixed(1)} cm',
          realtimeTpg!.isBelow ? Colors.red.shade800 : Colors.green.shade800,
        );
      }
    }

    // 4. Hubungkan Titik Pengukuran Tinggi Badan Pasien (Polyline)
    final sortedPoints = List<CdcPoint>.from(points)
      ..sort((a, b) => a.ageYears.compareTo(b.ageYears));

    final validOffsets = <Offset>[];
    for (final p in sortedPoints) {
      if (p.ageYears >= 2.0 && p.ageYears <= 20.0 && p.heightCm > 0) {
        validOffsets.add(Offset(_ageToX(p.ageYears, w), _heightToY(p.heightCm, h)));
      }
    }

    if (validOffsets.length >= 2) {
      final Path path = Path();
      path.moveTo(validOffsets.first.dx, validOffsets.first.dy);
      for (int i = 1; i < validOffsets.length; i++) {
        path.lineTo(validOffsets[i].dx, validOffsets[i].dy);
      }

      final Paint linePaint = Paint()
        ..color = Colors.blue.shade900
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(path, linePaint);
    }

    // 5. Gambar Titik Pengukuran (Dots)
    for (final p in sortedPoints) {
      if (p.ageYears >= 2.0 && p.ageYears <= 20.0 && p.heightCm > 0) {
        final Offset pt = Offset(_ageToX(p.ageYears, w), _heightToY(p.heightCm, h));

        _drawPoint(
          canvas: canvas,
          position: pt,
          color: Colors.blue.shade900,
          label: '${p.heightCm.toStringAsFixed(1)} cm',
          isCurrent: p.isCurrentExam,
        );
      }
    }
  }

  /// Menggambar kurva trajektori TPG (min, target, max) dari usia 2 hingga 20 tahun.
  /// Area antara min dan max diarsir hijau transparan.
  void _drawTpgTrajectory(Canvas canvas, double w, double h) {
    final isBoy = sex.toUpperCase() == 'L' || sex.toUpperCase() == 'M';

    // Sample usia setiap 0.5 tahun dari 2 sampai 20
    const double step = 0.5;
    final List<Offset> minPath = [];
    final List<Offset> maxPath = [];
    final List<Offset> targetPath = [];

    for (double age = 2.0; age <= 20.0; age += step) {
      final expected = CdcCalculator.expectedHeightAtAge(age, tpg!, isBoy);

      final x = _ageToX(age, w);
      minPath.add(Offset(x, _heightToY(expected.min, h)));
      maxPath.add(Offset(x, _heightToY(expected.max, h)));
      targetPath.add(Offset(x, _heightToY(expected.target, h)));
    }

    // Area arsir antara min dan max (hijau transparan)
    if (minPath.length >= 2) {
      final Path fillPath = Path();
      fillPath.moveTo(minPath.first.dx, minPath.first.dy);
      for (final pt in minPath) {
        fillPath.lineTo(pt.dx, pt.dy);
      }
      // Balik dari max (reversed) untuk menutup area
      for (final pt in maxPath.reversed) {
        fillPath.lineTo(pt.dx, pt.dy);
      }
      fillPath.close();

      final Paint fillPaint = Paint()
        ..color = Colors.green.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill;
      canvas.drawPath(fillPath, fillPaint);
    }

    // Garis min (dashed-style: garis tipis)
    _drawCurveLine(canvas, minPath, Colors.green.shade600, 1.2, dashed: true);

    // Garis max (dashed-style: garis tipis)
    _drawCurveLine(canvas, maxPath, Colors.green.shade600, 1.2, dashed: true);

    // Garis target (garis solid tebal)
    _drawCurveLine(canvas, targetPath, Colors.green.shade800, 2.0,
        dashed: false);

    // Label di ujung kanan (usia 20)
    if (targetPath.isNotEmpty) {
      final lastTarget = targetPath.last;
      final lastMin = minPath.last;
      final lastMax = maxPath.last;

      _drawTag(
        canvas,
        Offset(lastTarget.dx - 10, lastTarget.dy - 12),
        'TPG ${tpg!.targetCm.toStringAsFixed(0)}',
        Colors.green.shade800,
      );
      _drawSmallLabel(
        canvas,
        Offset(lastMin.dx + 5, lastMin.dy - 4),
        tpg!.minCm.toStringAsFixed(0),
        Colors.green.shade700,
      );
      _drawSmallLabel(
        canvas,
        Offset(lastMax.dx + 5, lastMax.dy - 4),
        tpg!.maxCm.toStringAsFixed(0),
        Colors.green.shade700,
      );
    }
  }

  void _drawCurveLine(
    Canvas canvas,
    List<Offset> points,
    Color color,
    double strokeWidth, {
    bool dashed = false,
  }) {
    if (points.length < 2) return;

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (!dashed) {
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);
    } else {
      // Garis putus-putus sederhana
      for (int i = 0; i < points.length - 1; i++) {
        if (i % 2 == 0) {
          canvas.drawLine(points[i], points[i + 1], paint);
        }
      }
    }
  }

  void _drawSmallLabel(
      Canvas canvas, Offset position, String text, Color color) {
    final TextSpan span = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: 8,
        fontWeight: FontWeight.bold,
      ),
    );
    final TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, position);
  }

  void _drawPoint({
    required Canvas canvas,
    required Offset position,
    required Color color,
    required String label,
    required bool isCurrent,
  }) {
    final double radius = isCurrent ? 6.0 : 4.5;

    final Paint haloPaint = Paint()
      ..color = color.withValues(alpha: isCurrent ? 0.35 : 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, radius + 4, haloPaint);

    final Paint dotPaint = Paint()
      ..color = isCurrent ? color : color.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, radius, dotPaint);

    final Paint strokePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(position, radius, strokePaint);

    final TextSpan span = TextSpan(
      text: label,
      style: TextStyle(
        color: Colors.white,
        fontSize: isCurrent ? 10 : 8.5,
        fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
        shadows: [
          Shadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 3),
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
    final RRect rrect =
        RRect.fromRectAndRadius(bgRect, const Radius.circular(4));

    canvas.drawRRect(rrect, bgPaint);
    tp.paint(canvas, Offset(position.dx + 13, position.dy - 8));
  }

  void _drawTag(Canvas canvas, Offset center, String text, Color color) {
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
      width: tp.width + 12,
      height: tp.height + 6,
    );
    final RRect rrect =
        RRect.fromRectAndRadius(bgRect, const Radius.circular(5));

    final Paint bgPaint = Paint()..color = color;
    canvas.drawRRect(rrect, bgPaint);
    tp.paint(
        canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CdcChartPainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.currentAgeYears != currentAgeYears ||
        oldDelegate.points != points ||
        oldDelegate.tpg != tpg ||
        oldDelegate.realtimeTpg != realtimeTpg ||
        oldDelegate.showAgeLine != showAgeLine ||
        oldDelegate.sex != sex;
  }
}
