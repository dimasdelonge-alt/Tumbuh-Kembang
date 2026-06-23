import 'instrument.dart';
import 'data/kmme_data.dart';
import 'data/tdd_data.dart';
import 'data/mchat_data.dart';
import 'data/gpph_data.dart';
import 'data/sppahi_data.dart';

/// Registry seluruh instrumen skrining generik yang tersedia.
///
/// Memetakan kode instrumen (tersimpan di DB) ke definisinya, agar laporan dan
/// tampilan dapat merekonstruksi nama, item, dan band dari hasil tersimpan.
///
/// Catatan: instrumen yang item-nya bergantung usia (mis. TDD) didaftarkan
/// dengan versi representatif; band interpretasinya independen usia sehingga
/// rekonstruksi skor di laporan tetap akurat.
class ScreeningRegistry {
  static final List<ScreeningInstrument> all = [
    kmmeInstrument,
    tddRegistryInstrument(),
    mchatInstrument,
    gpphInstrument,
    sppahiInstrument,
  ];

  static ScreeningInstrument? byId(String id) {
    for (final i in all) {
      if (i.id == id) return i;
    }
    return null;
  }
}
