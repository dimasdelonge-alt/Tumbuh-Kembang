import 'package:flutter/material.dart';

/// Tema aplikasi dengan warna utama hijau-teal (nuansa kesehatan anak).
class AppTheme {
  static const seed = Color(0xFF00897B);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: seed);
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        isDense: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// Warna status: hijau (normal), kuning (waspada), merah (alert).
  static Color statusColor(BuildContext context, {required int level}) {
    switch (level) {
      case 0:
        return Colors.green.shade600;
      case 1:
        return Colors.orange.shade700;
      default:
        return Colors.red.shade600;
    }
  }
}
