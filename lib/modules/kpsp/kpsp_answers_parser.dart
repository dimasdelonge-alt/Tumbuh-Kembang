/// Helper untuk mengekstrak jawaban utama dari answersJson KPSP.
///
/// Format lama (tanpa regresi): `{"1": true, "2": false, ...}`
/// Format baru (dengan regresi): `{"answers": {"1": true, ...}, "regression": [...], "developmentalAges": {...}}`
///
/// Fungsi ini selalu mengembalikan Map jawaban utama (key = nomor soal string).
import 'dart:convert';

/// Parse answersJson dan kembalikan hanya jawaban utama.
Map<String, dynamic> parseKpspPrimaryAnswers(String answersJson) {
  try {
    final decoded = jsonDecode(answersJson) as Map<String, dynamic>;
    // Format baru: has 'answers' key
    if (decoded.containsKey('answers') && decoded['answers'] is Map) {
      return decoded['answers'] as Map<String, dynamic>;
    }
    // Format lama: langsung berisi nomor soal
    return decoded;
  } catch (_) {
    return const {};
  }
}

/// Parse developmental ages dari answersJson (format baru saja).
/// Kembalikan null jika data regresi tidak ada.
Map<String, dynamic>? parseKpspDevelopmentalAges(String answersJson) {
  try {
    final decoded = jsonDecode(answersJson) as Map<String, dynamic>;
    if (decoded.containsKey('developmentalAges') &&
        decoded['developmentalAges'] is Map) {
      return decoded['developmentalAges'] as Map<String, dynamic>;
    }
  } catch (_) {}
  return null;
}
