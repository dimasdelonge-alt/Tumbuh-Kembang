import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/repository.dart';
import '../services/backup_service.dart';
import '../services/sync_service.dart';
import '../utils/file_helper.dart';
import '../utils/config_storage.dart';

/// Halaman Pengaturan untuk mengelola data (Backup/Restore & Sinkronisasi Cloud).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isProcessing = false;
  late final SyncService _syncService;

  final _apiKeyController = TextEditingController();
  final _projectIdController = TextEditingController();
  final _appIdController = TextEditingController();
  final _doctorNameController = TextEditingController();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _syncService = Provider.of<SyncService>(context, listen: false);
    _isConnected = _syncService.isInitialized;
    _loadSyncConfig();
  }

  Future<void> _loadSyncConfig() async {
    final config = await _syncService.loadConfig();
    final apiKey = config['apiKey'] ?? '';
    final projectId = config['projectId'] ?? '';
    final appId = config['appId'] ?? '';

    _apiKeyController.text = apiKey.isNotEmpty
        ? apiKey
        : 'AIzaSyBSAyIdaHIQxjYYGKxxmiYyLoAsqKxCBdo';
    _projectIdController.text = projectId.isNotEmpty
        ? projectId
        : 'tumbuh-kembang-klinik';
    _appIdController.text = appId.isNotEmpty
        ? appId
        : '1:728132917509:web:6b57eddad890cb960fbf6c';

    final docName = await ConfigStorage.getString('doctor_name') ?? '';
    _doctorNameController.text = docName;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _projectIdController.dispose();
    _appIdController.dispose();
    _doctorNameController.dispose();
    super.dispose();
  }

  Future<void> _exportBackup(BuildContext context) async {
    setState(() => _isProcessing = true);
    try {
      final repo = Provider.of<AppRepository>(context, listen: false);
      final backupService = BackupService(repo.db);

      final jsonString = await backupService.exportBackupJson();
      final dateStr = DateTime.now().toIso8601String().substring(0, 10).replaceAll('-', '_');
      final filename = 'tumbang_backup_$dateStr.json';

      await FileHelper.saveAndDownloadJson(jsonString, filename);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil diekspor.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengekspor data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _importBackup(BuildContext context) async {
    // Tampilkan dialog konfirmasi overwrite data
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pulihkan Data?'),
        content: const Text(
          'Proses ini akan MENGHAPUS seluruh data pasien saat ini di perangkat Anda dan menggantinya dengan data dari file cadangan. Tindakan ini tidak dapat dibatalkan.\n\nApakah Anda yakin ingin melanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ya, Hapus & Pulihkan'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isProcessing = true);
    try {
      final jsonString = await FileHelper.pickJsonFile();
      if (jsonString == null) {
        setState(() => _isProcessing = false);
        return;
      }

      if (!mounted) return;
      final repo = Provider.of<AppRepository>(context, listen: false);
      final backupService = BackupService(repo.db);

      await backupService.importBackupJson(jsonString);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil dipulihkan dari cadangan.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memulihkan data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _connectCloud() async {
    final apiKey = _apiKeyController.text.trim();
    final projectId = _projectIdController.text.trim();
    final appId = _appIdController.text.trim();

    if (apiKey.isEmpty || projectId.isEmpty || appId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field konfigurasi Firebase harus diisi!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);
    try {
      await _syncService.saveConfig(
        apiKey: apiKey,
        projectId: projectId,
        appId: appId,
      );

      // Putuskan koneksi lama dan inisialisasi ulang
      await _syncService.disconnect();
      final success = await _syncService.initialize();

      if (mounted) {
        if (success) {
          setState(() {
            _isConnected = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Koneksi Cloud Firebase berhasil diaktifkan! Data tersinkronisasi secara real-time.'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          setState(() {
            _isConnected = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal terhubung ke Firebase. Silakan periksa kembali konfigurasi Anda.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan koneksi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _disconnectCloud() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Matikan Sinkronisasi Cloud?'),
        content: const Text(
          'Aplikasi akan berhenti menyinkronkan data secara otomatis ke Cloud. Data lokal Anda di perangkat ini tetap aman.\n\nApakah Anda yakin?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ya, Matikan'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isProcessing = true);
    try {
      await _syncService.clearConfig();
      if (mounted) {
        setState(() {
          _isConnected = false;
          _apiKeyController.clear();
          _projectIdController.clear();
          _appIdController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Koneksi Cloud dinonaktifkan. Aplikasi kembali ke mode offline lokal.'),
            backgroundColor: Colors.blueGrey,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memutuskan koneksi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _saveDoctorName() async {
    final name = _doctorNameController.text.trim();
    await ConfigStorage.setString('doctor_name', name);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama Dokter berhasil disimpan.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Aplikasi'),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // --- SEKSI 1: LINK CLOUD SINKRONISASI ---
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Text(
                  'Sinkronisasi Cloud (Perawat - Dokter)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Status Card
              Card(
                color: _isConnected ? Colors.green.shade50 : Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: _isConnected ? Colors.green.shade300 : Colors.grey.shade400,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        _isConnected ? Icons.cloud_done : Icons.cloud_off,
                        color: _isConnected ? Colors.green : Colors.grey,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isConnected ? 'Sinkronisasi Aktif (Online)' : 'Sinkronisasi Nonaktif (Lokal)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: _isConnected ? Colors.green.shade900 : Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isConnected
                                  ? 'Data tersinkronisasi secara real-time antar perangkat perawat dan dokter.'
                                  : 'Data hanya disimpan secara lokal di browser/perangkat ini.',
                              style: TextStyle(
                                fontSize: 13,
                                color: _isConnected ? Colors.green.shade700 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Form / Konfigurasi Firebase
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Konfigurasi Firebase Klinik',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _apiKeyController,
                        enabled: !_isConnected,
                        decoration: const InputDecoration(
                          labelText: 'Firebase API Key',
                          hintText: 'AIzaSy...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _projectIdController,
                        enabled: !_isConnected,
                        decoration: const InputDecoration(
                          labelText: 'Firebase Project ID',
                          hintText: 'klinik-tumbang-123',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _appIdController,
                        enabled: !_isConnected,
                        decoration: const InputDecoration(
                          labelText: 'Firebase App ID',
                          hintText: '1:12345678:web:abcdef...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isProcessing
                              ? null
                              : (_isConnected ? _disconnectCloud : _connectCloud),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isConnected ? Colors.redAccent : Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _isConnected ? 'Putuskan Sinkronisasi Cloud' : 'Aktifkan Sinkronisasi Cloud',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      if (!_isConnected) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          'Cara Menghubungkan:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '1. Buka Firebase Console (console.firebase.google.com) dan buat proyek baru.\n'
                          '2. Daftarkan aplikasi baru jenis Web App (</>) pada pengaturan proyek.\n'
                          '3. Salin nilai apiKey, projectId, dan appId dari konfigurasi web Firebase.\n'
                          '4. Pastikan Cloud Firestore diaktifkan di konsol Firebase Anda dengan aturan rules: allow read, write: if true; (atau aturan otentikasi yang sesuai).',
                          style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- SEKSI: IDENTITAS PEMERIKSA ---
              const Divider(),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Text(
                  'Identitas Pemeriksa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama Dokter Pemeriksa',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Nama ini akan ditampilkan pada bagian tanda tangan laporan PDF hasil pemeriksaan.',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _doctorNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Dokter',
                          hintText: 'Contoh: dr. Budi Sp.A',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan Nama Dokter', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: _saveDoctorName,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- SEKSI 2: BACKUP MANUAL ---
              const Divider(),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Text(
                  'Manajemen Database Lokal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Card Ekspor
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.download),
                  ),
                  title: const Text(
                    'Cadangkan Data (Ekspor JSON)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Unduh seluruh database pasien dan hasil skrining dalam format file .json untuk disimpan sebagai cadangan fisik.',
                  ),
                  onTap: _isProcessing ? null : () => _exportBackup(context),
                ),
              ),
              const SizedBox(height: 12),

              // Card Impor
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.upload),
                  ),
                  title: const Text(
                    'Pulihkan Data (Impor JSON)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Pilih berkas cadangan .json dari perangkat Anda untuk memulihkan seluruh data klinis.',
                  ),
                  onTap: _isProcessing ? null : () => _importBackup(context),
                ),
              ),
              const SizedBox(height: 24),

              const Divider(),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Versi Aplikasi 1.1.0 (Real-time Cloud Sync)',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
          if (_isProcessing)
            Container(
              color: Colors.black26,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Sedang memproses database...',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
