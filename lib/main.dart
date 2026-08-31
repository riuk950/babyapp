import 'package:flutter/material.dart';

import 'features/routine/presentation/l10n/app_localizations.dart'
    as routine_l10n;
import 'features/routine/presentation/routine_controller.dart';
import 'features/routine/presentation/routine_page.dart';

void main() {
  runApp(const BabyApp());
}

class BabyApp extends StatelessWidget {
  const BabyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabyApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      locale: const Locale('es'),
      supportedLocales: routine_l10n.AppLocalizations.supportedLocales,
      localizationsDelegates:
          routine_l10n.AppLocalizations.localizationsDelegates,
      home: RoutinePage(controller: RoutineController()),
    );
  }
}
