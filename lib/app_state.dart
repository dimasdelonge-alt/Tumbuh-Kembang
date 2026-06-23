import 'package:flutter/foundation.dart';

import '../data/database.dart';
import '../data/repository.dart';

/// State global aplikasi: menyediakan repository dan daftar pasien yang
/// dipantau secara reaktif.
class AppState extends ChangeNotifier {
  final AppRepository repo;

  AppState(this.repo) {
    _sub = repo.watchPatients().listen((rows) {
      _patients = rows;
      _loading = false;
      notifyListeners();
    });
  }

  List<Patient> _patients = const [];
  bool _loading = true;

  List<Patient> get patients => _patients;
  bool get loading => _loading;

  late final dynamic _sub;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
