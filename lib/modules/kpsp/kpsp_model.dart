/// Model & engine skoring KPSP (Kuesioner Pra Skrining Perkembangan).
///
/// Sumber: Buku Panduan KPSP (CSL FK Unhas 2018) berbasis Stimulasi Deteksi
/// Dini Tumbuh Kembang DEPKES, mengikuti SDIDTK. Form tersedia untuk usia
/// 3, 6, 9, 12, 15, 18, 21, 24, 30, 36, 42, 48, 54, 60, 66, 72 bulan.

/// Sektor/domain perkembangan dalam KPSP.
enum KpspDomain {
  gerakKasar('Gerak Kasar'),
  gerakHalus('Gerak Halus'),
  bicaraBahasa('Bicara & Bahasa'),
  sosialisasiKemandirian('Sosialisasi & Kemandirian');

  final String label;
  const KpspDomain(this.label);
}

/// Satu pertanyaan KPSP.
class KpspQuestion {
  final int number;
  final String text;
  final KpspDomain domain;
  final String? imagePath;

  const KpspQuestion(this.number, this.text, this.domain, {this.imagePath});
}

/// Satu formulir KPSP untuk rentang usia tertentu.
class KpspForm {
  /// Usia form dalam bulan (3, 6, 9, ...).
  final int ageMonths;
  final List<KpspQuestion> questions;

  const KpspForm({required this.ageMonths, required this.questions});

  int get total => questions.length;
}

/// Kategori hasil KPSP.
enum KpspResultCategory {
  sesuai('Sesuai', 'S'),
  meragukan('Meragukan', 'M'),
  penyimpangan('Penyimpangan', 'P');

  final String label;
  final String code;
  const KpspResultCategory(this.label, this.code);

  static KpspResultCategory fromCode(String code) =>
      values.firstWhere((e) => e.code == code, orElse: () => sesuai);
}

/// Hasil interpretasi skor KPSP.
class KpspInterpretation {
  final int yesCount;
  final int total;
  final KpspResultCategory category;

  /// Saran tindak lanjut sesuai pedoman.
  final String recommendation;

  /// Daftar nomor pertanyaan yang dijawab "Tidak", dikelompokkan per domain.
  final Map<KpspDomain, List<int>> failedByDomain;

  const KpspInterpretation({
    required this.yesCount,
    required this.total,
    required this.category,
    required this.recommendation,
    required this.failedByDomain,
  });
}

/// Engine skoring KPSP.
///
/// Aturan (jumlah jawaban "Ya"):
/// - 9-10 : Sesuai
/// - 7-8  : Meragukan
/// - <=6  : Penyimpangan
class KpspScorer {
  static KpspResultCategory categorize(int yesCount) {
    if (yesCount >= 9) return KpspResultCategory.sesuai;
    if (yesCount >= 7) return KpspResultCategory.meragukan;
    return KpspResultCategory.penyimpangan;
  }

  static const Map<KpspResultCategory, String> _recommendations = {
    KpspResultCategory.sesuai:
        'Perkembangan anak sesuai dengan tahap usianya. Beri pujian pada ibu. '
        'Lanjutkan stimulasi sesuai usia dan jadwalkan KPSP rutin berikutnya.',
    KpspResultCategory.meragukan:
        'Beri stimulasi lebih sering selama 2 minggu. Cari kemungkinan penyakit '
        'penyerta. Ulangi KPSP 2 minggu lagi memakai daftar pertanyaan yang sama; '
        'bila hasil tetap 7-8 lakukan pemeriksaan lanjutan.',
    KpspResultCategory.penyimpangan:
        'Rujuk ke fasilitas yang lebih lengkap. Lakukan pemeriksaan menyeluruh '
        '(anamnesis, fisik umum & neurologis, penunjang bila ada indikasi).',
  };

  /// Hitung interpretasi dari jawaban.
  ///
  /// [answers] memetakan nomor pertanyaan (1-based) ke true (Ya) / false (Tidak).
  static KpspInterpretation interpret(KpspForm form, Map<int, bool> answers) {
    var yes = 0;
    final failed = <KpspDomain, List<int>>{};
    for (final q in form.questions) {
      final ans = answers[q.number] ?? false;
      if (ans) {
        yes++;
      } else {
        failed.putIfAbsent(q.domain, () => []).add(q.number);
      }
    }
    final category = categorize(yes);
    return KpspInterpretation(
      yesCount: yes,
      total: form.total,
      category: category,
      recommendation: _recommendations[category]!,
      failedByDomain: failed,
    );
  }

  /// Pilih form KPSP yang sesuai untuk usia (bulan) tertentu.
  ///
  /// Mengikuti aturan: gunakan form usia skrining terdekat yang lebih muda
  /// bila usia anak bukan tepat di usia skrining.
  static int nearestFormAge(int ageMonths) {
    final ages = KpspData.availableAges;
    if (ageMonths <= ages.first) return ages.first;
    if (ageMonths >= ages.last) return ages.last;
    var chosen = ages.first;
    for (final a in ages) {
      if (a <= ageMonths) {
        chosen = a;
      } else {
        break;
      }
    }
    return chosen;
  }
}

/// Placeholder kelas data; isi form didefinisikan di kpsp_data.dart.
abstract class KpspData {
  static const List<int> availableAges = [
    3, 6, 9, 12, 15, 18, 21, 24, 30, 36, 42, 48, 54, 60, 66, 72,
  ];

  /// Diisi oleh kpsp_data.dart melalui [register].
  static final Map<int, KpspForm> _forms = {};

  static void register(KpspForm form) => _forms[form.ageMonths] = form;

  static KpspForm? form(int ageMonths) => _forms[ageMonths];

  static bool get isLoaded => _forms.isNotEmpty;
}
