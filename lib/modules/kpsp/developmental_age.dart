import 'kpsp_model.dart';

/// Estimasi usia perkembangan satu domain.
class DomainDevelopmentalAge {
  final KpspDomain domain;

  /// Usia perkembangan estimasi (bulan), atau null bila belum ada bukti
  /// (tidak ada satu pun form di mana domain ini lulus penuh).
  final int? estimatedMonths;

  /// Usia form tertinggi yang PERNAH dinilai untuk domain ini (lulus/tidak).
  /// Berguna untuk konteks: bila domain belum pernah lulus penuh padahal
  /// sudah dinilai pada usia tinggi, itu sinyal keterlambatan.
  final int highestFormAssessed;

  const DomainDevelopmentalAge({
    required this.domain,
    required this.estimatedMonths,
    required this.highestFormAssessed,
  });
}

/// Hasil analisis usia perkembangan lintas domain.
class DevelopmentalAgeResult {
  final List<DomainDevelopmentalAge> domains;

  /// Usia kronologis (bulan) saat analisis, untuk pembanding.
  final int chronologicalMonths;

  const DevelopmentalAgeResult({
    required this.domains,
    required this.chronologicalMonths,
  });

  /// Domain dengan estimasi terendah (kandidat keterlambatan dominan).
  DomainDevelopmentalAge? get lowestDomain {
    DomainDevelopmentalAge? lowest;
    for (final d in domains) {
      if (d.estimatedMonths == null) continue;
      if (lowest == null ||
          d.estimatedMonths! < lowest.estimatedMonths!) {
        lowest = d;
      }
    }
    return lowest;
  }

  /// Selisih (bulan) usia kronologis dengan estimasi domain terendah.
  /// Positif berarti perkembangan tertinggal dari usia.
  int? get maxLagMonths {
    final low = lowestDomain;
    if (low?.estimatedMonths == null) return null;
    return chronologicalMonths - low!.estimatedMonths!;
  }
}

/// Satu entri riwayat KPSP untuk analisis.
class KpspHistoryEntry {
  final int formAgeMonths;

  /// Jawaban per nomor pertanyaan: true = Ya (tercapai), false = Tidak.
  final Map<int, bool> answers;

  const KpspHistoryEntry({
    required this.formAgeMonths,
    required this.answers,
  });
}

/// Mesin estimasi usia perkembangan berbasis KPSP.
///
/// METODE (transparan, konservatif — batas bawah):
/// Setiap formulir KPSP dikalibrasi untuk usia tertentu. Bila SEMUA item suatu
/// domain pada form usia A dijawab "Ya", kemampuan domain itu dianggap minimal
/// setara A bulan. Estimasi usia perkembangan suatu domain = usia form
/// TERTINGGI (lintas semua kunjungan) di mana domain tersebut lulus penuh.
///
/// Ini adalah estimasi skrining batas-bawah, BUKAN diagnosis usia perkembangan
/// formal (seperti Denver II / Bayley). Akurasi meningkat seiring makin banyak
/// rentang usia KPSP yang pernah diujikan.
///
/// Catatan: hanya domain dengan >= 1 item pada sebuah form yang dievaluasi
/// untuk form tersebut (komposisi domain tiap form KPSP berbeda).
class DevelopmentalAgeEngine {
  /// Hitung estimasi dari [history] (boleh lintas kunjungan, urutan bebas).
  ///
  /// [resolveForm] memetakan usia-form ke definisi [KpspForm] (untuk tahu
  /// domain tiap item). Entri yang form-nya tidak dikenal diabaikan.
  static DevelopmentalAgeResult analyze({
    required List<KpspHistoryEntry> history,
    required KpspForm? Function(int formAgeMonths) resolveForm,
    required int chronologicalMonths,
  }) {
    // Per domain: usia tertinggi lulus penuh, dan usia form tertinggi dinilai.
    final passed = <KpspDomain, int>{};
    final assessed = <KpspDomain, int>{};

    for (final entry in history) {
      final form = resolveForm(entry.formAgeMonths);
      if (form == null) continue;

      // Kelompokkan item form ini per domain.
      final byDomain = <KpspDomain, List<KpspQuestion>>{};
      for (final q in form.questions) {
        byDomain.putIfAbsent(q.domain, () => []).add(q);
      }

      byDomain.forEach((domain, questions) {
        // Catat domain ini dinilai pada usia form ini.
        final prevAssessed = assessed[domain];
        if (prevAssessed == null || entry.formAgeMonths > prevAssessed) {
          assessed[domain] = entry.formAgeMonths;
        }

        // Lulus penuh = semua item domain dijawab Ya.
        final allYes = questions.every((q) => entry.answers[q.number] == true);
        if (allYes) {
          final prev = passed[domain];
          if (prev == null || entry.formAgeMonths > prev) {
            passed[domain] = entry.formAgeMonths;
          }
        }
      });
    }

    final domains = <DomainDevelopmentalAge>[];
    for (final domain in KpspDomain.values) {
      if (!assessed.containsKey(domain)) continue;
      domains.add(DomainDevelopmentalAge(
        domain: domain,
        estimatedMonths: passed[domain],
        highestFormAssessed: assessed[domain]!,
      ));
    }

    return DevelopmentalAgeResult(
      domains: domains,
      chronologicalMonths: chronologicalMonths,
    );
  }
}
