import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'zscore_calculator.dart';

/// Memuat tabel LMS WHO dari aset JSON dan menyediakan perhitungan lengkap.
///
/// Aset berada di `assets/who/<indikator>_<L|P>.json`, masing-masing berisi
/// `{ "by": "month|length|height", "points": [[x,L,M,S], ...] }`.
class WhoGrowthData {
  WhoGrowthData._();
  static final WhoGrowthData instance = WhoGrowthData._();

  static const double _daysPerMonth = 30.4375;

  /// cache: key "indikator_jeniskelamin" -> tabel LMS (x dalam hari/cm).
  final Map<String, List<LmsPoint>> _cache = {};
  bool _loaded = false;

  static const Map<GrowthIndicator, String> _ageFilePrefix = {
    GrowthIndicator.weightForAge: 'wfa',
    GrowthIndicator.lengthHeightForAge: 'lhfa',
    GrowthIndicator.bmiForAge: 'bmifa',
    GrowthIndicator.headCircumferenceForAge: 'hcfa',
  };

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    for (final entry in _ageFilePrefix.entries) {
      for (final sex in ['L', 'P']) {
        await _load('${entry.value}_$sex', isAge: true);
      }
    }
    // BB/PB (berbaring, 0-2 thn) dan BB/TB (berdiri, 2-5 thn): x dalam cm.
    for (final sex in ['L', 'P']) {
      await _load('wfl_$sex', isAge: false);
      await _load('wfh_$sex', isAge: false);
    }
    _loaded = true;
  }

  Future<void> _load(String key, {required bool isAge}) async {
    final raw = await rootBundle.loadString('assets/who/$key.json');
    final map = json.decode(raw) as Map<String, dynamic>;
    final pts = (map['points'] as List).map((e) {
      final l = (e as List);
      var x = (l[0] as num).toDouble();
      if (isAge) x *= _daysPerMonth; // bulan -> hari
      return LmsPoint(
        x,
        (l[1] as num).toDouble(),
        (l[2] as num).toDouble(),
        (l[3] as num).toDouble(),
      );
    }).toList();
    _cache[key] = pts;
  }

  /// Ambil tabel LMS untuk indikator umur. [sex] = 'L' / 'P'.
  List<LmsPoint>? _ageTable(GrowthIndicator indicator, String sex) {
    final prefix = _ageFilePrefix[indicator];
    if (prefix == null) return null;
    return _cache['${prefix}_$sex'];
  }

  /// Tabel BB menurut panjang/tinggi sesuai cara ukur.
  List<LmsPoint>? _wflTable(String sex, {required bool lying}) {
    return _cache['${lying ? 'wfl' : 'wfh'}_$sex'];
  }

  /// Hitung Z-score indikator berbasis umur.
  ///
  /// [ageDays] usia (kronologis atau koreksi) dalam hari.
  ZScoreResult? zscoreForAge({
    required GrowthIndicator indicator,
    required String sex,
    required double value,
    required double ageDays,
  }) {
    final table = _ageTable(indicator, sex);
    if (table == null) return null;
    return ZScoreCalculator.compute(
      indicator: indicator,
      table: table,
      value: value,
      x: ageDays,
    );
  }

  /// Hitung Z-score BB/PB atau BB/TB.
  ZScoreResult? zscoreWeightForLength({
    required String sex,
    required double weightKg,
    required double lengthHeightCm,
    required bool measuredLying,
  }) {
    final table = _wflTable(sex, lying: measuredLying);
    if (table == null) return null;
    return ZScoreCalculator.compute(
      indicator: GrowthIndicator.weightForLengthHeight,
      table: table,
      value: weightKg,
      x: lengthHeightCm,
    );
  }

  /// Tabel mentah untuk keperluan menggambar kurva (x asli: hari/cm).
  List<LmsPoint>? tableFor({
    required GrowthIndicator indicator,
    required String sex,
    bool measuredLying = false,
  }) {
    if (indicator == GrowthIndicator.weightForLengthHeight) {
      return _wflTable(sex, lying: measuredLying);
    }
    return _ageTable(indicator, sex);
  }
}
