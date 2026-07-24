/// 4 Sektor Perkembangan Denver II
enum DenverSector {
  personalSocial,
  fineMotorAdaptive,
  language,
  grossMotor,
}

extension DenverSectorExtension on DenverSector {
  String get label => displayName;

  String get displayName {
    switch (this) {
      case DenverSector.personalSocial:
        return 'Personal Sosial';
      case DenverSector.fineMotorAdaptive:
        return 'Adaptif - Motorik Halus';
      case DenverSector.language:
        return 'Bahasa';
      case DenverSector.grossMotor:
        return 'Motorik Kasar';
    }
  }

  String get key {
    switch (this) {
      case DenverSector.personalSocial:
        return 'personal_social';
      case DenverSector.fineMotorAdaptive:
        return 'fine_motor';
      case DenverSector.language:
        return 'language';
      case DenverSector.grossMotor:
        return 'gross_motor';
    }
  }

  static DenverSector fromKey(String key) {
    switch (key) {
      case 'personal_social':
        return DenverSector.personalSocial;
      case 'fine_motor':
        return DenverSector.fineMotorAdaptive;
      case 'language':
        return DenverSector.language;
      case 'gross_motor':
        return DenverSector.grossMotor;
      default:
        return DenverSector.personalSocial;
    }
  }
}

/// Tipe Jawaban/Evaluasi per item saat diuji oleh pemeriksa
enum DenverItemEvaluation {
  pass, // Lulus (P)
  fail, // Gagal (F)
  refusal, // Menolak (R)
  noOpportunity, // Tak Ada Kesempatan (NO)
}

extension DenverItemEvaluationExtension on DenverItemEvaluation {
  String get code {
    switch (this) {
      case DenverItemEvaluation.pass:
        return 'P';
      case DenverItemEvaluation.fail:
        return 'F';
      case DenverItemEvaluation.refusal:
        return 'R';
      case DenverItemEvaluation.noOpportunity:
        return 'NO';
    }
  }

  String get label {
    switch (this) {
      case DenverItemEvaluation.pass:
        return 'Lulus (Pass)';
      case DenverItemEvaluation.fail:
        return 'Gagal (Fail)';
      case DenverItemEvaluation.refusal:
        return 'Menolak (Refusal)';
      case DenverItemEvaluation.noOpportunity:
        return 'Tak Ada Kesempatan (NO)';
    }
  }
}

/// Status Klinis Per Item setelah dibandingkan dengan Garis Usia
enum DenverItemStatus {
  advanced, // Lulus item yang sepenuhnya di kanan garis usia
  normal,   // Normal
  caution,  // Peringatan (Gagal/Menolak pada rentang 75%-90%)
  delayed,  // Keterlambatan (Gagal/Menolak yang sudah melewati 90%)
}

extension DenverItemStatusExtension on DenverItemStatus {
  String get label {
    switch (this) {
      case DenverItemStatus.advanced:
        return 'Advanced (Maju)';
      case DenverItemStatus.normal:
        return 'Normal';
      case DenverItemStatus.caution:
        return 'Caution (Peringatan)';
      case DenverItemStatus.delayed:
        return 'Delay (Keterlambatan)';
    }
  }
}

/// Kesimpulan Akhir Skrining Denver II
enum DenverGlobalResult {
  normal,    // Normal (Tak ada delay & maks 1 caution)
  suspect,   // Suspek (>=2 caution DAN/ATAU >=1 delay)
  untestable,// Untestable (Refusal pada item delay / 2+ caution)
}

extension DenverGlobalResultExtension on DenverGlobalResult {
  String get label {
    switch (this) {
      case DenverGlobalResult.normal:
        return 'NORMAL';
      case DenverGlobalResult.suspect:
        return 'SUSPEK (Rujuk / Skrining Ulang)';
      case DenverGlobalResult.untestable:
        return 'UNTESTABLE (Tidak Dapat Diuji)';
    }
  }
}

/// Definisi 1 Item Tugas Perkembangan Denver II
class DenverItem {
  final String id;
  final DenverSector sector;
  final String title;
  final String? instructions;
  final double p25; // Usia (bulan) 25% anak lulus
  final double p50; // Usia (bulan) 50% anak lulus
  final double p75; // Usia (bulan) 75% anak lulus
  final double p90; // Usia (bulan) 90% anak lulus
  final bool reportableByParent; // Bisa lapor ortu ('R' icon)
  final int indexInSector; // Urutan baris dalam sektor (0..N)

  const DenverItem({
    required this.id,
    required this.sector,
    required this.title,
    this.instructions,
    required this.p25,
    required this.p50,
    required this.p75,
    required this.p90,
    this.reportableByParent = false,
    required this.indexInSector,
  });
}
