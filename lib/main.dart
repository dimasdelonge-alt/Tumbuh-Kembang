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

  runApp(TumbangApp(repo: repo));
}

class TumbangApp extends StatelessWidget {
  final AppRepository repo;
  const TumbangApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(repo),
      child: Provider.value(
        value: repo,
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
      ),
    );
  }
}
