import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Spanish (es) localizations for the milestones feature (constitution §6).
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

  String get appTitle => 'Hitos de desarrollo';
  String get selectPrompt => 'Elige el mes del bebé (1 a 60 meses)';
  String get searchHint => 'Buscar por número o edad (p. ej., 7)';
  String get searchNoResults => 'No hay meses que coincidan con tu búsqueda';
  String get newMilestonesTitle => 'Hitos nuevos';
  String get previousHitLabel => 'Último hito alcanzado';
  String get alarmSignsTitle => 'Señales de alarma';
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
