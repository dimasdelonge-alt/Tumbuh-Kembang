import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/repository.dart';
import '../services/backup_service.dart';
import '../utils/file_helper.dart';

/// Halaman Pengaturan untuk mengelola data (Fase 1: Backup & Restore).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isProcessing = false;

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
          'Proses ini akan MENGAPUS seluruh data pasien saat ini di perangkat Anda dan menggantinya dengan data dari file cadangan. Tindakan ini tidak dapat dibatalkan.\n\nApakah Anda yakin ingin melanjutkan?',
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
        // Pengguna membatalkan pemilihan file
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Text(
                  'Manajemen Database',
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
                  'Versi Aplikasi 1.0.0 (Fase 1 Migrasi Cloud)',
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
