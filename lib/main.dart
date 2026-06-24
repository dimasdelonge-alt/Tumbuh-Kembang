import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'data/database.dart';
import 'data/repository.dart';
import 'modules/growth/who_growth_data.dart';
import 'modules/kpsp/kpsp_data.dart';
import 'modules/stimulation/stimulation_data.dart';
import 'screens/dashboard_screen.dart';
import 'services/sync_service.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // Muat data referensi.
  registerKpspForms();
  registerStimulationData();
  await WhoGrowthData.instance.ensureLoaded();

  final db = AppDatabase();
  final repo = AppRepository(db);
  final syncService = SyncService(db);
  repo.syncService = syncService;

  // Coba inisialisasi sinkronisasi cloud jika konfigurasi sudah tersimpan
  await syncService.initialize();

  runApp(TumbangApp(repo: repo, syncService: syncService));
}

class TumbangApp extends StatelessWidget {
  final AppRepository repo;
  final SyncService syncService;
  const TumbangApp({super.key, required this.repo, required this.syncService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState(repo)),
        Provider.value(value: repo),
        Provider.value(value: syncService),
      ],
      child: MaterialApp(
        title: 'Skrining Tumbuh Kembang',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('id', 'ID'),
          Locale('en', 'US'),
        ],
        locale: const Locale('id', 'ID'),
        home: const DashboardScreen(),
      ),
    );
  }
}
