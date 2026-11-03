import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbang/utils/config_storage.dart';

/// Regresi: pilihan bahan makanan dulu memakai SharedPreferences langsung,
/// yang tidak konsisten di web. Sekarang lewat ConfigStorage (localStorage di
/// web, SharedPreferences di mobile) termasuk dukungan daftar string.
void main() {
  test('ConfigStorage menyimpan & membaca daftar string', () async {
    SharedPreferences.setMockInitialValues({});
    await ConfigStorage.setStringList('daftar_uji', ['Kentang', 'Tempe']);
    expect(await ConfigStorage.getStringList('daftar_uji'), ['Kentang', 'Tempe']);

    await ConfigStorage.setStringList('daftar_uji', ['Nasi']);
    expect(await ConfigStorage.getStringList('daftar_uji'), ['Nasi']);

    await ConfigStorage.remove('daftar_uji');
    expect(await ConfigStorage.getStringList('daftar_uji'), isNull);
  });
}
