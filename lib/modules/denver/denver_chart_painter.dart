import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'denver_model.dart';

/// Painter khusus untuk menggambar canvas Denver II:
/// - Background image `kosong.png` (denver_chart_blank.png)
/// - Garis Usia Vertikal Merah (Age Line)
/// - Penanda status pengujian per item jika diuji
class DenverChartPainter extends CustomPainter {
  final ui.Image? image;
  final double ageInMonths;
  final bool usedCorrectedAge;
  final Map<String, DenverItemEvaluation> answers;
  final List<double> previousAgeLines;

  DenverChartPainter({
    required this.image,
    required this.ageInMonths,
    required this.usedCorrectedAge,
    required this.answers,
    this.previousAgeLines = const [],
  });

  /// Mengonversi Usia (Bulan 0 - 72) ke rasio X (0.0 - 1.0) di dalam kotak grafik
  static double calculateAgeRatioX(double ageInMonths) {
    if (ageInMonths <= 0) return 0.0;
    if (ageInMonths >= 72) return 1.0;

    // Titik-titik acuan (Bulan, RasioX di dalam kotak diagram)
    final List<MapEntry<double, double>> stops = const [
      MapEntry(0.0, 0.000),
      MapEntry(2.0, 0.054),
      MapEntry(4.0, 0.108),
      MapEntry(6.0, 0.162),
      MapEntry(9.0, 0.243),
      MapEntry(12.0, 0.324),
      MapEntry(15.0, 0.405),
      MapEntry(18.0, 0.486),
      MapEntry(24.0, 0.650),
      MapEntry(36.0, 0.738),
      MapEntry(48.0, 0.825),
      MapEntry(60.0, 0.912),
      MapEntry(72.0, 1.000),
    ];

    for (int i = 0; i < stops.length - 1; i++) {
      final p1 = stops[i];
      final p2 = stops[i + 1];
      if (ageInMonths >= p1.key && ageInMonths <= p2.key) {
        final t = (ageInMonths - p1.key) / (p2.key - p1.key);
        return p1.value + t * (p2.value - p1.value);
      }
    }
    return 1.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Gambar background image jika sudah ter-load
    if (image != null) {
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.width, size.height),
        image: image!,
        fit: BoxFit.fill,
      );
    } else {
      final bgPaint = Paint()..color = Colors.white;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
    }

    // Margin kotak diagram pada denver_chart_blank.png
    final double boxLeft = size.width * 0.082;
    final double boxRight = size.width * 0.965;
    final double boxWidth = boxRight - boxLeft;

    final double boxTop = size.height * 0.070;
    final double boxBottom = size.height * 0.950;

    // 1.5 Gambar Garis-Garis Usia Tes Sebelumnya (Beda Warna: Biru / Teal)
    final prevLineColors = [
      Colors.blue.shade700,
      Colors.teal.shade700,
      Colors.indigo.shade700,
      Colors.purple.shade700,
    ];

    for (int i = 0; i < previousAgeLines.length; i++) {
      final prevAge = previousAgeLines[i];
      final double prevRatioX = calculateAgeRatioX(prevAge);
      final double prevLineX = boxLeft + (prevRatioX * boxWidth);
      final color = prevLineColors[i % prevLineColors.length];

      final prevPaint = Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      // Draw dashed line
      double startY = boxTop;
      while (startY < boxBottom) {
        canvas.drawLine(
          Offset(prevLineX, startY),
          Offset(prevLineX, (startY + 6).clamp(boxTop, boxBottom)),
          prevPaint,
        );
        startY += 10;
      }

      // Label untuk garis sebelumnya
      final prevTextSpan = TextSpan(
        text: ' ${prevAge.toStringAsFixed(1)}b ',
        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
      );
      final prevTextPainter = TextPainter(text: prevTextSpan, textDirection: TextDirection.ltr);
      prevTextPainter.layout();
      final double pWidth = prevTextPainter.width + 6;
      final double pHeight = prevTextPainter.height + 2;
      double pLeft = prevLineX - (pWidth / 2);
      if (pLeft < boxLeft) pLeft = boxLeft;

      final pRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(pLeft, boxTop - pHeight - 2, pWidth, pHeight),
        const Radius.circular(3),
      );
      canvas.drawRRect(pRect, Paint()..color = color);
      prevTextPainter.paint(canvas, Offset(pLeft + 3, boxTop - pHeight));
    }

    // 2. Hitung posisi X Garis Usia Saat Ini
    final double ageRatioX = calculateAgeRatioX(ageInMonths);
    final double ageLineX = boxLeft + (ageRatioX * boxWidth);

    // 3. Gambar Garis Usia Vertikal (Merah Tegas)
    final ageLinePaint = Paint()
      ..color = Colors.red.shade700
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final ageLineShadowPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.3)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(ageLineX, boxTop),
      Offset(ageLineX, boxBottom),
      ageLineShadowPaint,
    );

    canvas.drawLine(
      Offset(ageLineX, boxTop),
      Offset(ageLineX, boxBottom),
      ageLinePaint,
    );

    // 4. Gambar Label Tag Usia di Atas Garis Usia
    final textSpan = TextSpan(
      text: ' ${ageInMonths.toStringAsFixed(1)} bln${usedCorrectedAge ? " (Koreksi)" : ""} ',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final double tagWidth = textPainter.width + 10;
    final double tagHeight = textPainter.height + 4;
    double tagLeft = ageLineX - (tagWidth / 2);
    if (tagLeft < boxLeft) tagLeft = boxLeft;
    if (tagLeft + tagWidth > boxRight) tagLeft = boxRight - tagWidth;

    final tagRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tagLeft, boxTop - tagHeight - 2, tagWidth, tagHeight),
      const Radius.circular(4),
    );

    final tagBgPaint = Paint()..color = Colors.red.shade700;
    canvas.drawRRect(tagRect, tagBgPaint);
    textPainter.paint(
      canvas,
      Offset(tagLeft + 5, boxTop - tagHeight),
    );
  }

  @override
  bool shouldRepaint(covariant DenverChartPainter oldDelegate) {
    return oldDelegate.ageInMonths != ageInMonths ||
        oldDelegate.usedCorrectedAge != usedCorrectedAge ||
        oldDelegate.answers != answers ||
        oldDelegate.image != image ||
        oldDelegate.previousAgeLines != previousAgeLines;
  }
}
