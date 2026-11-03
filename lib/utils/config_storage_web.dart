import 'dart:convert';
import 'dart:html' as html;

Future<String?> getStringImpl(String key) async {
  return html.window.localStorage[key];
}

Future<void> setStringImpl(String key, String value) async {
  html.window.localStorage[key] = value;
}

/// Daftar disimpan sebagai JSON di localStorage agar tidak bergantung pada
/// plugin shared_preferences (yang dulu tidak konsisten di web).
Future<List<String>?> getStringListImpl(String key) async {
  final raw = html.window.localStorage[key];
  if (raw == null) return null;
  try {
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded.map((e) => e.toString()).toList();
    }
  } catch (_) {
    // Data lama/rusak diabaikan; pemanggil memakai nilai default.
  }
  return null;
}

Future<void> setStringListImpl(String key, List<String> value) async {
  html.window.localStorage[key] = jsonEncode(value);
}

Future<void> removeImpl(String key) async {
  html.window.localStorage.remove(key);
}
