import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getStringImpl(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<void> setStringImpl(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<void> removeImpl(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}
