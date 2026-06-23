import '../kpsp/kpsp_model.dart' show KpspDomain, KpspForm;

/// Satu aktivitas stimulasi.
class StimulationActivity {
  /// Domain yang distimulasi (memakai domain KPSP agar mudah dicocokkan).
  final KpspDomain domain;

  /// Judul singkat aktivitas (mis. "Melatih anak mengangkat kepala").
  final String title;

  /// Cara melakukan, dalam bahasa sederhana.
  final String howTo;

  const StimulationActivity({
    required this.domain,
    required this.title,
    required this.howTo,
  });
}

/// Kelompok stimulasi untuk satu rentang usia perkembangan.
class StimulationBand {
  /// Batas bawah usia (bulan, inklusif).
  final int minMonths;

  /// Batas atas usia (bulan, inklusif).
  final int maxMonths;

  /// Label tampilan (mis. "0-2 bulan").
  final String label;

  final List<StimulationActivity> activities;

  const StimulationBand({
    required this.minMonths,
    required this.maxMonths,
    required this.label,
    required this.activities,
  });

  bool contains(int ageMonths) =>
      ageMonths >= minMonths && ageMonths <= maxMonths;

  List<StimulationActivity> forDomain(KpspDomain domain) =>
      activities.where((a) => a.domain == domain).toList();
}

/// Pustaka stimulasi (diisi dari data SDIDTK).
abstract class StimulationLibrary {
  /// Daftar band terurut menaik; diisi oleh stimulation_data.dart.
  static List<StimulationBand> bands = const [];

  static bool get isLoaded => bands.isNotEmpty;

  /// Pilih band yang memuat [ageMonths]; bila di luar rentang, ambil band
  /// terdekat (terkecil bila di bawah, terbesar bila di atas).
  static StimulationBand? bandFor(int ageMonths) {
    if (bands.isEmpty) return null;
    for (final b in bands) {
      if (b.contains(ageMonths)) return b;
    }
    if (ageMonths < bands.first.minMonths) return bands.first;
    return bands.last;
  }
}

/// Saran stimulasi untuk satu domain berdasarkan usia perkembangannya.
class StimulationSuggestion {
  final KpspDomain domain;

  /// Usia perkembangan (bulan) yang dipakai untuk mencocokkan band.
  final int developmentalAgeMonths;

  final StimulationBand band;
  final List<StimulationActivity> activities;

  const StimulationSuggestion({
    required this.domain,
    required this.developmentalAgeMonths,
    required this.band,
    required this.activities,
  });
}

/// Mesin pencocokan stimulasi (Modul 6 & 9 PRD).
///
/// Prinsip: stimulasi dipilih berdasarkan USIA PERKEMBANGAN domain yang
/// tertinggal, BUKAN usia kronologis. Mis. anak 4 tahun dengan bahasa setara
/// 24 bulan menerima stimulasi bahasa band 24-35 bulan.
class StimulationMatcher {
  /// Cari saran stimulasi untuk satu domain pada usia perkembangan tertentu.
  static StimulationSuggestion? forDomain(
    KpspDomain domain,
    int developmentalAgeMonths,
  ) {
    final band = StimulationLibrary.bandFor(developmentalAgeMonths);
    if (band == null) return null;
    final acts = band.forDomain(domain);
    if (acts.isEmpty) return null;
    return StimulationSuggestion(
      domain: domain,
      developmentalAgeMonths: developmentalAgeMonths,
      band: band,
      activities: acts,
    );
  }

  /// Cari saran untuk beberapa domain sekaligus.
  ///
  /// [domainAges] memetakan domain → usia perkembangan (bulan). Domain dengan
  /// usia null dilewati.
  static List<StimulationSuggestion> forDomains(
      Map<KpspDomain, int?> domainAges) {
    final out = <StimulationSuggestion>[];
    domainAges.forEach((domain, age) {
      if (age == null) return;
      final s = forDomain(domain, age);
      if (s != null) out.add(s);
    });
    return out;
  }

  /// Cari saran berdasarkan hasil satu formulir KPSP tertentu.
  ///
  /// Mengikuti logika dokter:
  /// - Bila ada jawaban "Tidak" pada suatu domain → stimulasi untuk domain tersebut
  ///   diambil sesuai usia form KPSP saat ini (belum tercapai).
  /// - Bila semua jawaban "Ya" pada suatu domain → stimulasi untuk domain tersebut
  ///   diambil untuk usia tingkat di atasnya (sudah tercapai).
  static List<StimulationSuggestion> forKpspResult({
    required KpspForm form,
    required Map<int, bool> answers,
  }) {
    final out = <StimulationSuggestion>[];
    final currentAge = form.ageMonths;

    // Cari band saat ini.
    final currentBand = StimulationLibrary.bandFor(currentAge);
    if (currentBand == null) return out;

    // Cari band berikutnya.
    final bands = StimulationLibrary.bands;
    final idx = bands.indexOf(currentBand);
    final nextBand = (idx >= 0 && idx < bands.length - 1)
        ? bands[idx + 1]
        : currentBand;

    // Evaluasi tiap domain.
    for (final domain in KpspDomain.values) {
      final qList = form.questions.where((q) => q.domain == domain).toList();
      if (qList.isEmpty) {
        // Jika tidak ada pertanyaan untuk domain ini di form, gunakan band saat ini.
        final acts = currentBand.forDomain(domain);
        if (acts.isNotEmpty) {
          out.add(StimulationSuggestion(
            domain: domain,
            developmentalAgeMonths: currentAge,
            band: currentBand,
            activities: acts,
          ));
        }
        continue;
      }

      // Cek apakah ada yang "Tidak" (false).
      final hasNo = qList.any((q) => answers[q.number] == false);
      if (hasNo) {
        // Belum tercapai -> band saat ini
        final acts = currentBand.forDomain(domain);
        if (acts.isNotEmpty) {
          out.add(StimulationSuggestion(
            domain: domain,
            developmentalAgeMonths: currentAge,
            band: currentBand,
            activities: acts,
          ));
        }
      } else {
        // Sudah tercapai -> band berikutnya
        final acts = nextBand.forDomain(domain);
        if (acts.isNotEmpty) {
          out.add(StimulationSuggestion(
            domain: domain,
            developmentalAgeMonths: nextBand.minMonths,
            band: nextBand,
            activities: acts,
          ));
        }
      }
    }
    return out;
  }
}
