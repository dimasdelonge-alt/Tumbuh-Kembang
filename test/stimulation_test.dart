import 'package:flutter_test/flutter_test.dart';
import 'package:tumbang/modules/kpsp/kpsp_model.dart';
import 'package:tumbang/modules/kpsp/kpsp_data.dart';
import 'package:tumbang/modules/stimulation/stimulation.dart';
import 'package:tumbang/modules/stimulation/stimulation_data.dart';

void main() {
  setUpAll(() {
    registerStimulationData();
    registerKpspForms();
  });

  group('StimulationLibrary', () {
    test('10 band termuat & terurut menaik', () {
      expect(StimulationLibrary.isLoaded, true);
      expect(StimulationLibrary.bands.length, 10);
      for (var i = 1; i < StimulationLibrary.bands.length; i++) {
        expect(StimulationLibrary.bands[i].minMonths,
            greaterThan(StimulationLibrary.bands[i - 1].minMonths));
      }
    });

    test('setiap band memuat keempat domain KPSP', () {
      for (final b in StimulationLibrary.bands) {
        for (final d in KpspDomain.values) {
          expect(b.forDomain(d), isNotEmpty,
              reason: 'band ${b.label} harus punya aktivitas ${d.label}');
        }
      }
    });

    test('bandFor memilih rentang yang tepat', () {
      expect(StimulationLibrary.bandFor(0)!.label, '0-2 bulan');
      expect(StimulationLibrary.bandFor(7)!.label, '6-8 bulan');
      expect(StimulationLibrary.bandFor(24)!.label, '24-35 bulan');
      expect(StimulationLibrary.bandFor(72)!.label, '60-72 bulan');
    });

    test('bandFor clamp di luar rentang', () {
      expect(StimulationLibrary.bandFor(999)!.label, '60-72 bulan');
    });
  });

  group('StimulationMatcher', () {
    test('forDomain mengembalikan aktivitas sesuai usia perkembangan', () {
      // Bahasa setara 18 bln -> band 12-17 bln (12<=18? tidak, 18 di band 18-23)
      final s = StimulationMatcher.forDomain(KpspDomain.bicaraBahasa, 18);
      expect(s, isNotNull);
      expect(s!.band.label, '18-23 bulan');
      expect(s.activities, isNotEmpty);
      expect(s.activities.every((a) => a.domain == KpspDomain.bicaraBahasa),
          true);
    });

    test('memakai usia perkembangan, bukan kronologis', () {
      // Anak 48 bln dengan bahasa setara 24 bln -> stimulasi band 24-35.
      final s = StimulationMatcher.forDomain(KpspDomain.bicaraBahasa, 24);
      expect(s!.band.label, '24-35 bulan');
      expect(s.developmentalAgeMonths, 24);
    });

    test('forDomains melewati domain dengan usia null', () {
      final res = StimulationMatcher.forDomains({
        KpspDomain.bicaraBahasa: 12,
        KpspDomain.gerakKasar: null,
      });
      expect(res.length, 1);
      expect(res.first.domain, KpspDomain.bicaraBahasa);
    });

    test('forKpspResult mengembalikan stimulasi sesuai jawaban KPSP per domain', () {
      final form = KpspData.form(3)!;
      final answers = {
        1: false, // GK
        2: true,  // SK
        3: true,  // BB
        4: true,  // GH
        5: true,  // GH
        6: true,  // SK
        7: true,  // GK
        8: true,  // GK
        9: true,  // GK
        10: true, // BB
      };

      final res = StimulationMatcher.forKpspResult(form: form, answers: answers);

      // Domain Gerak Kasar (GK) ada yang "Tidak" -> band saat ini (3-5 bulan)
      final gkSug = res.firstWhere((s) => s.domain == KpspDomain.gerakKasar);
      expect(gkSug.developmentalAgeMonths, 3);
      expect(gkSug.band.label, '3-5 bulan');

      // Domain Gerak Halus (GH) semuanya "Ya" -> band tingkat atasnya (6-8 bulan)
      final ghSug = res.firstWhere((s) => s.domain == KpspDomain.gerakHalus);
      expect(ghSug.band.label, '6-8 bulan');
    });
  });
}
