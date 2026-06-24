import 'dart:html' as html;

Future<String?> getStringImpl(String key) async {
  return html.window.localStorage[key];
}

Future<void> setStringImpl(String key, String value) async {
  html.window.localStorage[key] = value;
}

Future<void> removeImpl(String key) async {
  html.window.localStorage.remove(key);
}
