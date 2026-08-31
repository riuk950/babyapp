import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Spanish (es) localizations for the sleep feature (constitution §6).
///
/// Strings are centralized here and mirror the base ARB file at
/// `lib/l10n/app_es.arb`. Uses Flutter's standard `Localizations` machinery
/// without adding a third-party dependency.
class AppLocalizations {
  const AppLocalizations();

  static const AppLocalizations es = AppLocalizations();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? es;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    delegate,
  ];

  static const List<Locale> supportedLocales = [Locale('es')];

  String get appTitle => 'Cuánto debe dormir tu hijo';
  String get selectPrompt => 'Elige la franja de edad del bebé';
  String get ageBandNone => 'Ninguna seleccionada';
  String get totalHoursTitle => 'Horas totales por día';
  String get napsTitle => 'Siestas';
  String get bedtimeTitle => 'Horario orientativo';
  String get insufficientSignsTitle => 'Señales de sueño insuficiente';
  String get alarmSignsTitle => 'Cuándo consultar al pediatra';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'es';

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations.es;

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
