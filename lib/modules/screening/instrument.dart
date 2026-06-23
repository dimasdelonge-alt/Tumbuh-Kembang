/// Kerangka generik instrumen skrining berbasis kuesioner Ya/Tidak.
///
/// Dipakai untuk instrumen di luar KPSP (mis. KMME, M-CHAT-R, GPPH) agar
/// logika item + skoring + interpretasi seragam dan tidak diduplikasi per
/// instrumen.

/// Jawaban yang menandakan risiko untuk suatu item.
enum RiskAnswer { ya, tidak }

/// Tipe respon item dalam instrumen.
/// - [binary]: Ya/Tidak; skor = jumlah jawaban berisiko.
/// - [likert4]: skala 0-1-2-3 (mis. GPPH); skor = jumlah nilai.
enum ResponseType { binary, likert4 }

/// Label skala Likert 0-3 (GPPH/Conners).
const List<String> likert4Labels = [
  'Tidak ada (0)',
  'Kadang (1)',
  'Sering (2)',
  'Selalu (3)',
];

/// Satu item pertanyaan.
class ScreeningItem {
  final int number;
  final String text;

  /// Jawaban mana yang dihitung sebagai "berisiko"/poin (khusus [ResponseType.binary]).
  /// Untuk sebagian besar instrumen = ya; sebagian item M-CHAT terbalik = tidak.
  final RiskAnswer riskAnswer;

  const ScreeningItem(this.number, this.text,
      {this.riskAnswer = RiskAnswer.ya});
}

/// Tingkat hasil interpretasi (3 level umum risiko).
enum RiskLevel {
  low('Risiko rendah', 0),
  medium('Risiko sedang', 1),
  high('Risiko tinggi', 2);

  final String label;
  final int severity;
  const RiskLevel(this.label, this.severity);
}

/// Hasil satu ambang skor → level + rekomendasi.
class ScoreBand {
  /// Skor minimum (inklusif) untuk band ini.
  final int minScore;
  final RiskLevel level;
  final String interpretation;
  final String recommendation;

  const ScoreBand({
    required this.minScore,
    required this.level,
    required this.interpretation,
    required this.recommendation,
  });
}

/// Definisi sebuah instrumen skrining.
class ScreeningInstrument {
  /// Kode unik stabil (disimpan di DB), mis. 'kmme', 'mchat_r'.
  final String id;
  final String name;
  final String shortDescription;

  /// Rentang usia berlaku (bulan), untuk validasi/peringatan.
  final int minAgeMonths;
  final int maxAgeMonths;

  final List<ScreeningItem> items;

  /// Daftar band terurut menaik berdasarkan [ScoreBand.minScore].
  final List<ScoreBand> bands;

  /// Catatan hak cipta yang WAJIB ditampilkan (mis. M-CHAT). Null bila bebas.
  final String? copyrightNotice;

  /// Label varian untuk instrumen yang set item-nya bergantung usia (mis. TDD
  /// "0-6 bulan"). Null untuk instrumen biasa. [name] tetap band-agnostik.
  final String? variantLabel;

  /// Tipe respon item. Default biner (Ya/Tidak).
  final ResponseType responseType;

  /// Opsi penilai (mis. SPPAHI: Dokter/Orang tua/Guru). Kosong = tidak relevan.
  /// Bila tidak kosong, UI meminta pemilihan penilai sebelum menyimpan, dan
  /// penilai tersimpan di kolom variantLabel.
  final List<String> raterOptions;

  /// Cut-off skor "risiko tinggi" per penilai (untuk instrumen Likert dengan
  /// ambang bergantung penilai, mis. SPPAHI). Null bila pakai [bands] biasa.
  final Map<String, int>? raterCutoffs;

  const ScreeningInstrument({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.minAgeMonths,
    required this.maxAgeMonths,
    required this.items,
    required this.bands,
    this.copyrightNotice,
    this.variantLabel,
    this.responseType = ResponseType.binary,
    this.raterOptions = const [],
    this.raterCutoffs,
  });

  int get totalItems => items.length;

  bool get hasRaterSelection => raterOptions.isNotEmpty;

  /// Skor maksimum yang mungkin (untuk tampilan "skor/total").
  int get maxScore =>
      responseType == ResponseType.likert4 ? items.length * 3 : items.length;

  /// Judul tampilan: nama + varian bila ada (mis. "TDD ... — 0-6 bulan").
  String get displayTitle =>
      variantLabel == null ? name : '$name — $variantLabel';
}

/// Hasil interpretasi pengisian instrumen.
class ScreeningInterpretation {
  final int score;
  final int total;
  final ScoreBand band;

  /// Nomor item yang dijawab "berisiko".
  final List<int> flaggedItems;

  const ScreeningInterpretation({
    required this.score,
    required this.total,
    required this.band,
    required this.flaggedItems,
  });

  RiskLevel get level => band.level;
}

/// Mesin skoring generik.
class ScreeningScorer {
  /// Hitung skor = jumlah item yang dijawab sesuai [ScreeningItem.riskAnswer].
  ///
  /// [answers] memetakan nomor item → true (Ya) / false (Tidak).
  static ScreeningInterpretation interpret(
      ScreeningInstrument instrument, Map<int, bool> answers) {
    var score = 0;
    final flagged = <int>[];
    for (final item in instrument.items) {
      final ans = answers[item.number];
      if (ans == null) continue;
      final isRisk =
          (item.riskAnswer == RiskAnswer.ya && ans == true) ||
              (item.riskAnswer == RiskAnswer.tidak && ans == false);
      if (isRisk) {
        score++;
        flagged.add(item.number);
      }
    }
    return ScreeningInterpretation(
      score: score,
      total: instrument.totalItems,
      band: bandFor(instrument, score),
      flaggedItems: flagged,
    );
  }

  /// Pilih band tertinggi yang minScore-nya <= skor.
  static ScoreBand bandFor(ScreeningInstrument instrument, int score) {
    var chosen = instrument.bands.first;
    for (final b in instrument.bands) {
      if (score >= b.minScore) chosen = b;
    }
    return chosen;
  }

  /// Skoring instrumen skala Likert 0-3 (mis. GPPH).
  ///
  /// [answers] memetakan nomor item → nilai 0..3. Skor = jumlah seluruh nilai.
  /// Item yang dianggap menonjol (nilai >= 2) dimasukkan ke flaggedItems.
  ///
  /// Bila instrumen punya [ScreeningInstrument.raterCutoffs] dan [rater]
  /// diberikan, band ditentukan oleh cut-off penilai tersebut (>= cut-off =
  /// risiko tinggi) alih-alih [ScreeningInstrument.bands].
  static ScreeningInterpretation interpretLikert(
      ScreeningInstrument instrument, Map<int, int> answers,
      {String? rater}) {
    var score = 0;
    final flagged = <int>[];
    for (final item in instrument.items) {
      final v = answers[item.number];
      if (v == null) continue;
      final clamped = v < 0 ? 0 : (v > 3 ? 3 : v);
      score += clamped;
      if (clamped >= 2) flagged.add(item.number);
    }
    final band = bandForRater(instrument, score, rater);
    return ScreeningInterpretation(
      score: score,
      total: instrument.maxScore,
      band: band,
      flaggedItems: flagged,
    );
  }

  /// Tentukan band; bila ada cut-off per penilai, pakai itu.
  static ScoreBand bandForRater(
      ScreeningInstrument instrument, int score, String? rater) {
    final cutoffs = instrument.raterCutoffs;
    if (cutoffs != null) {
      // Instrumen ber-rater: HANYA pakai cut-off penilai yang dikenali.
      // bands[0] = di bawah cut-off (rendah), bands.last = >= cut-off (tinggi).
      if (rater != null && cutoffs.containsKey(rater)) {
        return score >= cutoffs[rater]! ? instrument.bands.last
            : instrument.bands.first;
      }
      // Penilai tidak diketahui: jangan tandai risiko tinggi otomatis
      // (ambang bergantung penilai, tak bisa ditentukan tanpa penilai).
      return instrument.bands.first;
    }
    return bandFor(instrument, score);
  }
}
