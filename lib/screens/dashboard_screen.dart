import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../core/age_calculator.dart';
import '../data/database.dart';
import '../data/repository.dart';
import 'patient_form_screen.dart';
import 'patient_detail_screen.dart';
import 'fast_screening_form_screen.dart';
import 'settings_screen.dart';

/// Layar utama: daftar pasien + pencarian + tombol tambah.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update FAB and screen state
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final patients = _query.isEmpty
        ? state.patients
        : state.patients
            .where((p) =>
                p.name.toLowerCase().contains(_query.toLowerCase()) ||
                (p.medicalRecordNo ?? '')
                    .toLowerCase()
                    .contains(_query.toLowerCase()))
            .toList();

    final registeredPatients = patients.where((p) => p.medicalRecordNo != 'ANONIM').toList();
    final anonymousPatients = patients.where((p) => p.medicalRecordNo == 'ANONIM').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skrining Tumbuh Kembang'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Pengaturan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Pasien Terdaftar'),
            Tab(icon: Icon(Icons.flash_on), text: 'Skrining Cepat'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_tabController.index == 0) {
            _openForm(context);
          } else {
            _openFastScreeningForm(context);
          }
        },
        icon: Icon(_tabController.index == 0 ? Icons.person_add : Icons.add_circle),
        label: Text(_tabController.index == 0 ? 'Pasien Baru' : 'Skrining Baru'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari nama atau no. rekam medis',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Pasien Terdaftar
                if (state.loading)
                  const Center(child: CircularProgressIndicator())
                else if (registeredPatients.isEmpty)
                  _EmptyState(hasQuery: _query.isNotEmpty, type: 'terdaftar')
                else
                  ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 96),
                    itemCount: registeredPatients.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => _PatientCard(patient: registeredPatients[i]),
                  ),

                // Tab 2: Skrining Cepat (Anonim)
                if (state.loading)
                  const Center(child: CircularProgressIndicator())
                else if (anonymousPatients.isEmpty)
                  _EmptyState(hasQuery: _query.isNotEmpty, type: 'cepat')
                else
                  ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 96),
                    itemCount: anonymousPatients.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => _PatientCard(patient: anonymousPatients[i]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PatientFormScreen()),
    );
  }

  void _openFastScreeningForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FastScreeningFormScreen()),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final Patient patient;
  const _PatientCard({required this.patient});

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Pasien?'),
        content: Text(
          'Data pasien "${patient.name}" beserta SELURUH riwayat '
          'pemeriksaan (pertumbuhan, KPSP, skrining, dll) akan '
          'dihapus permanen.\n\nTindakan ini tidak bisa dibatalkan.\n\nLanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final repo = context.read<AppRepository>();
    await repo.deletePatient(patient.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pasien "${patient.name}" dihapus.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final age = AgeCalculator.calculate(
      birthDate: patient.birthDate,
      examDate: DateTime.now(),
      gestationalWeeks: patient.gestationalWeeks,
    );
    final isMale = patient.sex == 'L';
    final isAnon = patient.medicalRecordNo == 'ANONIM';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isMale
              ? Colors.blue.shade100
              : Colors.pink.shade100,
          child: Icon(
            isMale ? Icons.boy : Icons.girl,
            color: isMale ? Colors.blue.shade700 : Colors.pink.shade700,
          ),
        ),
        title: Text(patient.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${age.chronologicalLabel}'
          '${!isAnon && patient.medicalRecordNo != null ? ' • RM ${patient.medicalRecordNo}' : ''}'
          '${patient.isPremature ? ' • prematur' : ''}'
          '${isAnon ? ' • skrining cepat' : ''}',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PatientDetailScreen(patientId: patient.id),
          ),
        ),
        onLongPress: () => _confirmDelete(context),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasQuery;
  final String type;
  const _EmptyState({required this.hasQuery, required this.type});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(hasQuery ? Icons.search_off : Icons.child_care,
              size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            hasQuery
                ? 'Pasien tidak ditemukan'
                : type == 'terdaftar'
                    ? 'Belum ada pasien terdaftar.\nTekan "Pasien Baru" untuk menambah.'
                    : 'Belum ada riwayat skrining cepat.\nTekan "Skrining Baru" untuk memulai.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
