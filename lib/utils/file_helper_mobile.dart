import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:printing/printing.dart';

Future<void> saveAndDownloadJsonImpl(String jsonString, String filename) async {
  final bytes = utf8.encode(jsonString);
  // Menggunakan sharing panel agar pengguna bisa mengirim ke WhatsApp, email,
  // atau memilih "Save to Files" di perangkat mobile.
  await Printing.sharePdf(bytes: bytes, filename: filename);
}

Future<String?> pickJsonFileImpl() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
  );
  if (result == null || result.files.single.path == null) {
    return null;
  }
  final file = File(result.files.single.path!);
  return file.readAsString();
}
