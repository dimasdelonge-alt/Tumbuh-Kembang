import 'dart:convert';
import 'dart:html' as html;

Future<void> saveAndDownloadJsonImpl(String jsonString, String filename) async {
  final bytes = utf8.encode(jsonString);
  final blob = html.Blob([bytes], 'application/json');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute("download", filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}

Future<String?> pickJsonFileImpl() async {
  final uploadInput = html.InputElement(type: 'file')..accept = '.json';
  uploadInput.click();

  await uploadInput.onChange.first;
  if (uploadInput.files?.isEmpty ?? true) return null;

  final file = uploadInput.files!.first;
  final reader = html.FileReader();
  reader.readAsText(file);

  await reader.onLoadEnd.first;
  return reader.result as String?;
}
