import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/age_calculator.dart';
import '../data/database.dart';
import '../data/repository.dart';

/// Layar Tempat Sampah: menampilkan pasien & pemeriksaan yang di-soft-delete.
/// Pengguna bisa restore atau hapus permanen dari sini.
class TrashScreen extends StatelessWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AppRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tempat Sampah'),
        actions: [
          IconButton(
            tooltip: 'Kosongkan Sampah',
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () => _confirmEmptyTrash(context, repo),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info banner
          Card(
            color: Colors.orange.shade50,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.orange.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Data di tempat sampah akan dihapus otomatis setelah 30 hari.',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // --- Pasien yang dihapus ---
          Text('Pasien Terhapus',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          StreamBuilder<List<Patient>>(
            stream: repo.watchDeletedPatients(),
            builder: (context, snap) {
              final patients = snap.data ?? [];
              if (patients.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text('Tidak ada pasien di tempat sampah.',
                        style: TextStyle(color: Colors.grey)),
                  ),
                );
              }
              return Column(
                children: patients.map((p) => _DeletedPatientCard(patient: p)).toList(),
              );
            },
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // --- Pemeriksaan yang dihapus ---
          Text('Pemeriksaan Terhapus',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          StreamBuilder<List<Examination>>(
            stream: repo.watchDeletedExaminations(),
            builder: (context, snap) {
              final exams = snap.data ?? [];
              if (exams.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text('Tidak ada pemeriksaan di tempat sampah.',
                        style: TextStyle(color: Colors.grey)),
                  ),
                );
              }
              return Column(
                children: exams.map((e) => _DeletedExamCard(exam: e, repo: repo)).toList(),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _confirmEmptyTrash(BuildContext context, AppRepository repo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kosongkan Tempat Sampah?'),
        content: const Text(
          'SEMUA data di tempat sampah akan dihapus secara PERMANEN.\n\n'
          'Tindakan ini TIDAK BISA dibatalkan.\n\nLanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Kosongkan'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await repo.emptyTrash();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tempat sampah dikosongkan.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

class _DeletedPatientCard extends StatelessWidget {
  final Patient patient;
  const _DeletedPatientCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AppRepository>();
    final isMale = patient.sex == 'L';
    final deletedDate = patient.deletedAt != null
        ? AgeCalculator.formatDate(patient.deletedAt!)
        : '-';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Icon(
            isMale ? Icons.boy : Icons.girl,
            color: Colors.grey,
          ),
        ),
        title: Text(patient.name,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.lineThrough)),
        subtitle: Text('Dihapus: $deletedDate'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Kembalikan',
              icon: const Icon(Icons.restore, color: Colors.green),
              onPressed: () async {
                await repo.restorePatient(patient.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Pasien "${patient.name}" dikembalikan.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
            IconButton(
              tooltip: 'Hapus Permanen',
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () => _confirmPermanentDelete(context, repo),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmPermanentDelete(
      BuildContext context, AppRepository repo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Permanen?'),
        content: Text(
          'Data pasien "${patient.name}" beserta SELURUH riwayat pemeriksaan '
          'akan dihapus secara PERMANEN.\n\nTindakan ini TIDAK BISA dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus Permanen'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await repo.permanentlyDeletePatient(patient.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pasien "${patient.name}" dihapus permanen.'),
        ),
      );
    }
  }
}

class _DeletedExamCard extends StatelessWidget {
  final Examination exam;
  final AppRepository repo;
  const _DeletedExamCard({required this.exam, required this.repo});

  @override
  Widget build(BuildContext context) {
    final deletedDate = exam.deletedAt != null
        ? AgeCalculator.formatDate(exam.deletedAt!)
        : '-';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: const Icon(Icons.event_note, color: Colors.grey),
        ),
        title: Text(
          'Pemeriksaan ${AgeCalculator.formatDate(exam.examDate)}',
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.lineThrough),
        ),
        subtitle: Text(
          '${exam.examinerNote ?? 'Pemeriksaan'} • Dihapus: $deletedDate',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Kembalikan',
              icon: const Icon(Icons.restore, color: Colors.green),
              onPressed: () async {
                await repo.restoreExamination(exam.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pemeriksaan dikembalikan.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
            IconButton(
              tooltip: 'Hapus Permanen',
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () => _confirmPermanentDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmPermanentDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Permanen?'),
        content: Text(
          'Pemeriksaan tanggal ${AgeCalculator.formatDate(exam.examDate)} '
          'akan dihapus secara PERMANEN.\n\nTindakan ini TIDAK BISA dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus Permanen'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await repo.permanentlyDeleteExamination(exam.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pemeriksaan dihapus permanen.'),
        ),
      );
    }
  }
}
