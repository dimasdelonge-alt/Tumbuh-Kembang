import 'config_storage_stub.dart'
    if (dart.library.io) 'config_storage_mobile.dart'
    if (dart.library.html) 'config_storage_web.dart';

/// Abstraksi penyimpanan key-value untuk konfigurasi Firebase.
/// Di web: localStorage. Di mobile: SharedPreferences.
abstract class ConfigStorage {
  static Future<String?> getString(String key) => getStringImpl(key);
  static Future<void> setString(String key, String value) =>
      setStringImpl(key, value);
  static Future<void> remove(String key) => removeImpl(key);
}
