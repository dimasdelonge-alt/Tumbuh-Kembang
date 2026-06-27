import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:firebase_core/firebase_core.dart';
import '../data/database.dart';
import '../utils/config_storage.dart';

/// Service untuk sinkronisasi database lokal SQLite dengan Firebase Firestore
/// secara real-time. Memungkinkan alur kerja Perawat-Dokter.
class SyncService {
  final AppDatabase db;
  FirebaseApp? _firebaseApp;
  FirebaseFirestore? _firestore;
  bool _initialized = false;
  
  // Menyimpan subscription active agar bisa di-cancel saat disconnect
  final List<StreamSubscription> _subscriptions = [];

  SyncService(this.db);

  bool get isInitialized => _initialized;

  /// Membaca konfigurasi Firebase dari storage lokal (localStorage di web, SharedPreferences di mobile)
  Future<Map<String, String>> loadConfig() async {
    return {
      'apiKey': await ConfigStorage.getString('fb_api_key') ?? '',
      'projectId': await ConfigStorage.getString('fb_project_id') ?? '',
      'appId': await ConfigStorage.getString('fb_app_id') ?? '',
    };
  }

  /// Menyimpan konfigurasi Firebase ke storage lokal
  Future<void> saveConfig({
    required String apiKey,
    required String projectId,
    required String appId,
  }) async {
    await ConfigStorage.setString('fb_api_key', apiKey);
    await ConfigStorage.setString('fb_project_id', projectId);
    await ConfigStorage.setString('fb_app_id', appId);
  }

  /// Menghapus konfigurasi dan memutuskan koneksi
  Future<void> clearConfig() async {
    await ConfigStorage.remove('fb_api_key');
    await ConfigStorage.remove('fb_project_id');
    await ConfigStorage.remove('fb_app_id');
    await disconnect();
  }

  /// Memutuskan semua listener Firestore
  Future<void> disconnect() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();
    _firestore = null;
    _firebaseApp = null;
    _initialized = false;
  }

  /// Menginisialisasi Firebase secara dinamis berdasarkan konfigurasi yang disimpan
  Future<bool> initialize() async {
    if (_initialized) return true;
    
    try {
      final config = await loadConfig();
      final apiKey = config['apiKey']!;
      final projectId = config['projectId']!;
      final appId = config['appId']!;

      if (apiKey.isEmpty || projectId.isEmpty || appId.isEmpty) {
        return false;
      }

      final apps = Firebase.apps;
      if (apps.isNotEmpty) {
        // Cari app yang sudah diinisialisasi
        _firebaseApp = apps.first;
      } else {
        _firebaseApp = await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: apiKey,
            appId: appId,
            messagingSenderId: '1234567890', // Dummy sender ID
            projectId: projectId,
          ),
        );
      }

      _firestore = FirebaseFirestore.instanceFor(app: _firebaseApp!);
      _initialized = true;
      
      // Mulai dengarkan update dari server
      _startListening();
      
      // Unggah data lokal yang belum ada di server (opsional, sebagai background task)
      unawaited(pushAllLocalData());
      
      return true;
    } catch (e) {
      print('Firebase initialization failed: $e');
      _initialized = false;
      return false;
    }
  }
  
  /// Mulai sinkronisasi Inbound (Firestore -> SQLite Lokal)
  void _startListening() {
    if (!_initialized || _firestore == null) return;
    
    void _listenCollection<T>(
      String collectionName,
      T Function(Map<String, dynamic> json) fromJson,
      Insertable<T> Function(T item) toCompanion,
      TableInfo<Table, T> table,
    ) {
      final sub = _firestore!.collection(collectionName).snapshots().listen((snapshot) async {
        for (final doc in snapshot.docChanges) {
          final data = doc.doc.data();
          if (data == null) continue;

          if (doc.type == DocumentChangeType.added || doc.type == DocumentChangeType.modified) {
            try {
              final item = fromJson(data);
              if (table == db.patients) {
                final p = item as Patient;
                final localPatient = await (db.select(db.patients)..where((x) => x.id.equals(p.id))).getSingleOrNull();
                if (localPatient != null && localPatient.medicalRecordNo != 'ANONIM' && p.medicalRecordNo == 'ANONIM') {
                  continue;
                }
              }
              await db.into(table).insertOnConflictUpdate(toCompanion(item));
            } catch (e) {
              print('Error syncing document to local SQLite ($collectionName): $e');
            }
          } else if (doc.type == DocumentChangeType.removed) {
            try {
              final id = doc.doc.id;
              await (db.delete(table)..where((t) => (t as dynamic).id.equals(id))).go();
            } catch (e) {
              print('Error removing document from local SQLite ($collectionName): $e');
            }
          }
        }
      }, onError: (e) {
        print('Firestore listener error on $collectionName: $e');
      });
      
      _subscriptions.add(sub);
    }
    
    // Subscribe ke 7 tabel data medis
    _listenCollection<Patient>(
      'patients',
      (json) => Patient.fromJson(json),
      (item) => item,
      db.patients,
    );
    
    _listenCollection<Examination>(
      'examinations',
      (json) => Examination.fromJson(json),
      (item) => item,
      db.examinations,
    );
    
    _listenCollection<GrowthMeasurement>(
      'growthMeasurements',
      (json) => GrowthMeasurement.fromJson(json),
      (item) => item,
      db.growthMeasurements,
    );
    
    _listenCollection<KpspResult>(
      'kpspResults',
      (json) => KpspResult.fromJson(json),
      (item) => item,
      db.kpspResults,
    );
    
    _listenCollection<ScreeningResult>(
      'screeningResults',
      (json) => ScreeningResult.fromJson(json),
      (item) => item,
      db.screeningResults,
    );
    
    _listenCollection<VisionResult>(
      'visionResults',
      (json) => VisionResult.fromJson(json),
      (item) => item,
      db.visionResults,
    );
    
    _listenCollection<CarsResult>(
      'carsResults',
      (json) => CarsResult.fromJson(json),
      (item) => item,
      db.carsResults,
    );
  }

  // --- Upload Helpers (Local -> Firestore) ---

  Future<void> uploadPatient(Patient item) async {
    if (!_initialized || _firestore == null) return;
    try {
      if (item.medicalRecordNo == 'ANONIM') {
        final doc = await _firestore!.collection('patients').doc(item.id).get();
        if (doc.exists) {
          final remoteData = doc.data();
          if (remoteData != null) {
            final remoteMrn = remoteData['medicalRecordNo'];
            if (remoteMrn != 'ANONIM') {
              print('Skipping upload for patient ${item.id}: remote is already promoted ($remoteMrn)');
              return;
            }
          }
        }
      }
      await _firestore!.collection('patients').doc(item.id).set(item.toJson());
    } catch (e) {
      print('Failed to upload patient to Firestore: $e');
    }
  }

  Future<void> deletePatientRemote(String id) async {
    if (!_initialized || _firestore == null) return;
    try {
      await _firestore!.collection('patients').doc(id).delete();
    } catch (e) {
      print('Failed to delete patient from Firestore: $e');
    }
  }

  Future<void> uploadExamination(Examination item) async {
    if (!_initialized || _firestore == null) return;
    try {
      await _firestore!.collection('examinations').doc(item.id).set(item.toJson());
    } catch (e) {
      print('Failed to upload examination to Firestore: $e');
    }
  }

  Future<void> deleteExaminationRemote(String id) async {
    if (!_initialized || _firestore == null) return;
    try {
      await _firestore!.collection('examinations').doc(id).delete();
    } catch (e) {
      print('Failed to delete examination from Firestore: $e');
    }
  }

  Future<void> uploadGrowthMeasurement(GrowthMeasurement item) async {
    if (!_initialized || _firestore == null) return;
    try {
      await _firestore!.collection('growthMeasurements').doc(item.id).set(item.toJson());
    } catch (e) {
      print('Failed to upload growth measurement to Firestore: $e');
    }
  }

  Future<void> uploadKpspResult(KpspResult item) async {
    if (!_initialized || _firestore == null) return;
    try {
      await _firestore!.collection('kpspResults').doc(item.id).set(item.toJson());
    } catch (e) {
      print('Failed to upload KPSP to Firestore: $e');
    }
  }

  Future<void> uploadScreeningResult(ScreeningResult item) async {
    if (!_initialized || _firestore == null) return;
    try {
      await _firestore!.collection('screeningResults').doc(item.id).set(item.toJson());
    } catch (e) {
      print('Failed to upload screening to Firestore: $e');
    }
  }

  Future<void> uploadVisionResult(VisionResult item) async {
    if (!_initialized || _firestore == null) return;
    try {
      await _firestore!.collection('visionResults').doc(item.id).set(item.toJson());
    } catch (e) {
      print('Failed to upload vision to Firestore: $e');
    }
  }

  Future<void> uploadCarsResult(CarsResult item) async {
    if (!_initialized || _firestore == null) return;
    try {
      await _firestore!.collection('carsResults').doc(item.id).set(item.toJson());
    } catch (e) {
      print('Failed to upload CARS to Firestore: $e');
    }
  }

  /// Unggah seluruh data SQLite lokal ke Firestore
  Future<void> pushAllLocalData() async {
    if (!_initialized || _firestore == null) return;
    try {
      final patients = await db.select(db.patients).get();
      for (final item in patients) {
        await uploadPatient(item);
      }
      
      final examinations = await db.select(db.examinations).get();
      for (final item in examinations) {
        await uploadExamination(item);
      }
      
      final growth = await db.select(db.growthMeasurements).get();
      for (final item in growth) {
        await uploadGrowthMeasurement(item);
      }
      
      final kpsp = await db.select(db.kpspResults).get();
      for (final item in kpsp) {
        await uploadKpspResult(item);
      }
      
      final screening = await db.select(db.screeningResults).get();
      for (final item in screening) {
        await uploadScreeningResult(item);
      }
      
      final vision = await db.select(db.visionResults).get();
      for (final item in vision) {
        await uploadVisionResult(item);
      }
      
      final cars = await db.select(db.carsResults).get();
      for (final item in cars) {
        await uploadCarsResult(item);
      }
    } catch (e) {
      print('Error pushing local data: $e');
    }
  }
}
