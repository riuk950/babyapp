import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Spanish (es) localizations for the app (constitution §6).
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

  String get appTitle => 'Cómo vestir al bebé';
  String get manualTempLabel => 'Temperatura (°C)';
  String get manualTempHint => 'Introduce la temperatura';
  String get ageBandLabel => 'Edad del bebé';
  String get ageBandNone => 'Elige la edad';
  String get ageBandNewborn => '0–3 meses';
  String get ageBandInfant => '3–12 meses';
  String get ageBandToddler => '1–3 años';
  String get ageBandChild => '4–5 años';

  /// RF-1: empty / not numeric / too many decimals.
  String get errorTemperatureRequired => 'Introduce una temperatura';

  /// RF-1: out of -30..50.
  String get errorOutOfRange => 'La temperatura debe estar entre −30 y 50 °C';

  /// RF-4: geo unavailable, recommending with manual.
  String get noticeGeoUnavailable =>
      'No se ha podido obtener el clima automático. Se usa tu temperatura manual.';

  /// RF-4: manual invalid, recommending with geo.
  String get noticeManualIgnored =>
      'Tu temperatura manual no es válida. Se usa el clima de tu zona.';

  String get loadingWeather => 'Obteniendo el clima…';
  String get recommendationTitle => 'Recomendación';

  /// RF-8.
  String get extremeCold => 'Temperatura muy baja: abriga bien al bebé.';
  String get extremeHeat => 'Temperatura muy alta: mantén al bebé fresco.';
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
