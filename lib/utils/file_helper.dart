import 'file_helper_stub.dart'
    if (dart.library.io) 'file_helper_mobile.dart'
    if (dart.library.html) 'file_helper_web.dart';

/// Helper cross-platform untuk mengunduh/menyimpan berkas JSON (Ekspor)
/// dan memilih/mengunggah berkas JSON (Impor).
abstract class FileHelper {
  /// Menyimpan string JSON ke dalam berkas fisik/unduhan.
  static Future<void> saveAndDownloadJson(String jsonString, String filename) {
    return saveAndDownloadJsonImpl(jsonString, filename);
  }

  /// Memilih berkas JSON dari penyimpanan perangkat dan mengembalikan isinya sebagai String.
  static Future<String?> pickJsonFile() {
    return pickJsonFileImpl();
  }
}
