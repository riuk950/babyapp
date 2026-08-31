import 'package:flutter/material.dart';

import 'features/sleep/presentation/l10n/app_localizations.dart';
import 'features/sleep/presentation/sleep_controller.dart';
import 'features/sleep/presentation/sleep_page.dart';

void main() {
  runApp(const BabyApp());
}

class BabyApp extends StatelessWidget {
  const BabyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuánto debe dormir tu hijo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      locale: const Locale('es'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: SleepPage(controller: SleepController()),
    );
  }
}
