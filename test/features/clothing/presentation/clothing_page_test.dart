import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/contracts/weather_repository.dart';
import 'package:babyapp/core/domain/entities/geo.dart';
import 'package:babyapp/core/domain/models.dart';
import 'package:babyapp/features/clothing/presentation/clothing_page.dart';
import 'package:babyapp/features/clothing/presentation/l10n/app_localizations.dart';

class _FakeWeatherRepository implements WeatherRepository {
  GeoTemperatureResult? result;

  @override
  Future<GeoTemperatureResult> fetchCurrentTemperature() {
    return Future.value(result);
  }
}

void main() {
  Future<void> pumpApp(WidgetTester tester, WeatherRepository repo) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(body: ClothingPage(repository: repo)),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder recommendation(String text) => find.text(text);

  testWidgets('shows recommendation from manual + geo (RF-7)', (tester) async {
    final repo = _FakeWeatherRepository()
      ..result = const GeoTemperatureSuccess(TemperatureReading(200));
    await pumpApp(tester, repo);

    await tester.enterText(find.byType(TextField), '20');
    await tester.pump();

    await tester.tap(find.text('Elige la edad'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1–3 años').last);
    await tester.pumpAndSettle();

    expect(
      recommendation('Body manga corta de algodón + pantalón; chaleco fino opcional'),
      findsOneWidget,
    );
  });

  testWidgets('extreme notice appears without replacing the recommendation (RF-8)',
      (tester) async {
    final repo = _FakeWeatherRepository()
      ..result = const GeoTemperatureSuccess(TemperatureReading(340));
    await pumpApp(tester, repo);

    await tester.enterText(find.byType(TextField), '35');
    await tester.pump();
    await tester.tap(find.text('Elige la edad'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('4–5 años').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('muy alta'), findsOneWidget);
    expect(
      recommendation('Solo body/babador de algodón transpirable'),
      findsOneWidget,
    );
  });

  testWidgets('RF-1 error texts are shown in Spanish via l10n', (tester) async {
    final repo = _FakeWeatherRepository()
      ..result = const GeoTemperatureSuccess(TemperatureReading(200));
    await pumpApp(tester, repo);

    await tester.enterText(find.byType(TextField), 'abc');
    await tester.pump();
    expect(find.text('Introduce una temperatura'), findsWidgets);

    await tester.enterText(find.byType(TextField), '60');
    await tester.pump();
    expect(find.text('La temperatura debe estar entre −30 y 50 °C'), findsOneWidget);
  });

  testWidgets('layout renders at 320dp width without overflow (RNF-2)',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repo = _FakeWeatherRepository()
      ..result = const GeoTemperatureSuccess(TemperatureReading(200));
    await pumpApp(tester, repo);

    await tester.enterText(find.byType(TextField), '20');
    await tester.pump();
    await tester.tap(find.text('Elige la edad'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('0–3 meses').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('1 capa'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
