import 'config_storage.dart';

/// Utilitas untuk mengelola status aktivasi Modul Denver II.
///
/// Modul Denver II dilindungi hak cipta (Frankenburg et al., 1990).
/// Penggunaan klinis hanya diizinkan bagi tenaga medis terlisensi yang
/// telah menyetujui ketentuan penggunaan dan memasukkan kode aktivasi.
class DenverLicense {
  static const _keyActivated = 'denver_ii_activated';
  static const _keyAgreedAt = 'denver_ii_agreed_at';


  // Daftar kode valid (huruf kapital, tanpa spasi).
  // Tambah kode sesuai kebutuhan (misal per institusi).
  static const _validCodes = <String>[
    'DENVER2026TUMBANG',
    'DENVERII-SDIDTK',
    'TUMBANG-DENVER-PRO',
  ];

  /// Memeriksa apakah modul Denver II sudah diaktifkan.
  static Future<bool> isActivated() async {
    final val = await ConfigStorage.getString(_keyActivated);
    return val == '1';
  }

  /// Memvalidasi kode aktivasi yang dimasukkan pengguna.
  static bool validateCode(String code) {
    final normalized = code.trim().toUpperCase();
    return _validCodes.contains(normalized);
  }

  /// Menyimpan status aktivasi dan waktu persetujuan T&C.
  static Future<void> activate() async {
    await ConfigStorage.setString(_keyActivated, '1');
    await ConfigStorage.setString(
      _keyAgreedAt,
      DateTime.now().toIso8601String(),
    );
  }

  /// Mencabut aktivasi (reset).
  static Future<void> deactivate() async {
    await ConfigStorage.remove(_keyActivated);
    await ConfigStorage.remove(_keyAgreedAt);
  }

  /// Mendapatkan tanggal/waktu persetujuan T&C (null bila belum diaktifkan).
  static Future<DateTime?> agreedAt() async {
    final val = await ConfigStorage.getString(_keyAgreedAt);
    if (val == null) return null;
    return DateTime.tryParse(val);
  }
}
