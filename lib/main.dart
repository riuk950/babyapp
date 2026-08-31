import 'package:flutter/material.dart';

import 'features/breastmilk/presentation/breastmilk_controller.dart';
import 'features/breastmilk/presentation/breastmilk_page.dart';
import 'features/breastmilk/presentation/l10n/app_localizations.dart';

void main() {
  runApp(const BabyApp());
}

class BabyApp extends StatelessWidget {
  const BabyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cómo almacenar leche materna',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      locale: const Locale('es'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: BreastMilkPage(controller: BreastMilkController()),
    );
  }
}
