import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/repository.dart';
import '../data/database.dart';
import '../services/backup_service.dart';
import '../services/sync_service.dart';
import '../utils/file_helper.dart';
import '../utils/config_storage.dart';
import '../utils/denver_license.dart';
import 'trash_screen.dart';

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
  final _doctorSipController = TextEditingController();
  String _doctorSigType = 'qr_generated';
  String? _customSigBase64;
  bool _isConnected = false;

  int _tapCount = 0;
  DateTime? _lastTapTime;
  bool _showFirebaseConfig = false;

  // --- Denver II License ---
  bool _denverActivated = false;
  final _activationCodeController = TextEditingController();

  void _handleSecretTap() {
    final now = DateTime.now();
    if (_lastTapTime == null || now.difference(_lastTapTime!).inSeconds > 2) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }
    _lastTapTime = now;

    if (_tapCount >= 5) {
      _tapCount = 0;
      setState(() {
        _showFirebaseConfig = !_showFirebaseConfig;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _showFirebaseConfig
                ? 'Pengaturan Konfigurasi Firebase berhasil dibuka!'
                : 'Pengaturan Konfigurasi Firebase disembunyikan.',
          ),
          backgroundColor: _showFirebaseConfig ? Colors.teal : Colors.blueGrey,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _syncService = Provider.of<SyncService>(context, listen: false);
    _isConnected = _syncService.isInitialized;
    _loadSyncConfig();
    _checkDenverLicense();
  }

  Future<void> _checkDenverLicense() async {
    final activated = await DenverLicense.isActivated();
    if (mounted) setState(() => _denverActivated = activated);
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
    final docSip = await ConfigStorage.getString('doctor_sip') ?? '';
    final sigType = await ConfigStorage.getString('doctor_signature_type') ?? 'qr_generated';
    final sigBase64 = await ConfigStorage.getString('doctor_signature_base64');

    if (mounted) {
      setState(() {
        _doctorNameController.text = docName;
        _doctorSipController.text = docSip;
        _doctorSigType = sigType;
        _customSigBase64 = sigBase64;
      });
    }
  }

  Future<void> _saveDoctorConfig() async {
    await ConfigStorage.setString('doctor_name', _doctorNameController.text.trim());
    await ConfigStorage.setString('doctor_sip', _doctorSipController.text.trim());
    await ConfigStorage.setString('doctor_signature_type', _doctorSigType);
    if (_customSigBase64 != null) {
      await ConfigStorage.setString('doctor_signature_base64', _customSigBase64!);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Identitas Dokter & Tanda Tangan Digital berhasil disimpan!'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Future<void> _pickCustomSignatureImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final bytes = result.files.single.bytes;
        if (bytes != null) {
          final base64Str = base64Encode(bytes);
          setState(() {
            _customSigBase64 = base64Str;
            _doctorSigType = 'custom_image';
          });
          await _saveDoctorConfig();
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah gambar: $e')),
      );
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _projectIdController.dispose();
    _appIdController.dispose();
    _doctorNameController.dispose();
    _doctorSipController.dispose();
    _activationCodeController.dispose();
    super.dispose();
  }

  // ─── Denver II Activation ──────────────────────────────────────────────────

  Future<void> _showDenverActivationDialog() async {
    _activationCodeController.clear();
    String? errorText;
    bool step2 = false; // false = kode, true = T&C

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setInner) {
          if (!step2) {
            // Step 1: masukkan kode aktivasi
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.lock_open, color: Color(0xFF0148A0)),
                  SizedBox(width: 8),
                  Expanded(child: Text('Aktifkan Modul Denver II', style: TextStyle(fontSize: 16))),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Masukkan kode aktivasi yang diperoleh dari penyedia aplikasi.',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _activationCodeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Kode Aktivasi',
                      border: const OutlineInputBorder(),
                      errorText: errorText,
                      prefixIcon: const Icon(Icons.vpn_key),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    final valid = DenverLicense.validateCode(
                        _activationCodeController.text);
                    if (!valid) {
                      setInner(() => errorText = 'Kode tidak valid. Periksa kembali.');
                    } else {
                      setInner(() { errorText = null; step2 = true; });
                    }
                  },
                  child: const Text('Lanjut'),
                ),
              ],
            );
          } else {
            // Step 2: Syarat & Ketentuan
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.gavel, color: Colors.deepOrange),
                  SizedBox(width: 8),
                  Expanded(child: Text('Syarat & Ketentuan', style: TextStyle(fontSize: 16))),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Denver Developmental Screening Test II (Denver II) adalah instrumen yang dilindungi hak cipta oleh Frankenburg et al. (1990), diterbitkan oleh Denver Developmental Materials, Inc.',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Dengan mengaktifkan modul ini, Anda menyatakan bahwa:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    SizedBox(height: 6),
                    Text('• Anda adalah tenaga kesehatan berlisensi (dokter, perawat, atau terapis).'),
                    SizedBox(height: 4),
                    Text('• Penggunaan terbatas untuk keperluan klinis dan pendidikan kedokteran.'),
                    SizedBox(height: 4),
                    Text('• Anda tidak akan mendistribusikan atau mereproduksi instrumen ini kepada pihak yang tidak berhak.'),
                    SizedBox(height: 4),
                    Text('• Penggunaan komersial atau publikasi tanpa izin tertulis dari pemilik hak cipta adalah pelanggaran hukum.'),
                    SizedBox(height: 10),
                    Text(
                      'Pelanggaran terhadap ketentuan di atas sepenuhnya menjadi tanggung jawab pengguna.',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Tolak'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    await DenverLicense.activate();
                    if (!mounted) return;
                    setState(() => _denverActivated = true);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Modul Denver II berhasil diaktifkan!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Saya Setuju & Aktifkan'),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> _showDenverDeactivateDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nonaktifkan Denver II'),
        content: const Text(
            'Modul Denver II akan disembunyikan. Data yang sudah tersimpan tidak akan terhapus. Lanjutkan?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Nonaktifkan'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await DenverLicense.deactivate();
      if (mounted) setState(() => _denverActivated = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Modul Denver II telah dinonaktifkan.')),
        );
      }
    }
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
              GestureDetector(
                onTap: _handleSecretTap,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sinkronisasi Cloud (Perawat - Dokter)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      if (_showFirebaseConfig)
                        const Icon(Icons.lock_open, size: 18, color: Colors.teal),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Status Card
              GestureDetector(
                onTap: _handleSecretTap,
                child: Card(
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
              ),
              const SizedBox(height: 12),

              // Form / Konfigurasi Firebase (Tampil hanya jika _showFirebaseConfig = true)
              if (_showFirebaseConfig) ...[
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
              ],

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
              // ─── Identitas Dokter & Tanda Tangan Digital ──────────────────────
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.teal.shade50,
                            child: Icon(Icons.badge, color: Colors.teal.shade800),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Identitas Dokter & Tanda Tangan Digital',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const Text(
                                  'Pengesahan resmi hasil skrining pada laporan PDF',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _doctorNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap Dokter & Gelar',
                          hintText: 'Contoh: dr. Budi Santoso, Sp.A',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _doctorSipController,
                        decoration: const InputDecoration(
                          labelText: 'Nomor SIP / STR',
                          hintText: 'Contoh: SIP 503/1234/DISKES/2026',
                          prefixIcon: Icon(Icons.card_membership),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Format Pengesahan / Tanda Tangan di PDF:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'qr_generated',
                            label: Text('Auto QR Code Digital'),
                            icon: Icon(Icons.qr_code_2),
                          ),
                          ButtonSegment(
                            value: 'custom_image',
                            label: Text('Upload Foto TTD'),
                            icon: Icon(Icons.upload_file),
                          ),
                        ],
                        selected: {_doctorSigType},
                        onSelectionChanged: (set) {
                          if (set.isNotEmpty) {
                            setState(() => _doctorSigType = set.first);
                            _saveDoctorConfig();
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Preview Box Tanda Tangan Digital
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            if (_doctorSigType == 'qr_generated') ...[
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(Icons.qr_code_2, size: 48, color: Colors.teal.shade800),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Auto-Generated QR Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    SizedBox(height: 2),
                                    Text('QR Code verifikasi resmi dibuat otomatis per cetakan laporan PDF.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ] else ...[
                              if (_customSigBase64 != null && _customSigBase64!.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.memory(
                                    base64Decode(_customSigBase64!),
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              else
                                const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _pickCustomSignatureImage,
                                  icon: const Icon(Icons.upload),
                                  label: Text(_customSigBase64 != null ? 'Ganti Foto TTD' : 'Unggah Foto TTD (PNG/JPG)'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _saveDoctorConfig,
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan Identitas Dokter'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

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
              const SizedBox(height: 12),

              // Card Tempat Sampah
              StreamBuilder<List<Patient>>(
                stream: context.read<AppRepository>().watchDeletedPatients(),
                builder: (context, patSnap) {
                  return StreamBuilder<List<Examination>>(
                    stream: context.read<AppRepository>().watchDeletedExaminations(),
                    builder: (context, examSnap) {
                      final patCount = patSnap.data?.length ?? 0;
                      final examCount = examSnap.data?.length ?? 0;
                      final totalTrash = patCount + examCount;

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          leading: Badge(
                            isLabelVisible: totalTrash > 0,
                            label: Text('$totalTrash'),
                            backgroundColor: Colors.red,
                            child: const CircleAvatar(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              child: Icon(Icons.delete_outline),
                            ),
                          ),
                          title: const Text(
                            'Tempat Sampah',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            totalTrash == 0
                                ? 'Kosong'
                                : '$patCount pasien, $examCount pemeriksaan',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TrashScreen()),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              const Divider(),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Versi Aplikasi 11.0.0 (Denver II Module)',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),

              // ─── Menu Tersembunyi: Aktifkan Modul Tambahan ───────────────────
              GestureDetector(
                onTap: _denverActivated
                    ? _showDenverDeactivateDialog
                    : _showDenverActivationDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _denverActivated
                          ? Colors.green.shade200
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: _denverActivated
                        ? Colors.green.shade50
                        : Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _denverActivated ? Icons.verified : Icons.extension_outlined,
                        size: 16,
                        color: _denverActivated ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _denverActivated
                                  ? 'Modul Denver II: Aktif'
                                  : 'Aktifkan Modul Tambahan',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: _denverActivated
                                    ? Colors.green.shade700
                                    : Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              _denverActivated
                                  ? 'Ketuk untuk menonaktifkan'
                                  : 'Diperlukan kode aktivasi',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
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
