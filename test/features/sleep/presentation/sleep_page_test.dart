import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/features/sleep/presentation/l10n/app_localizations.dart';
import 'package:babyapp/features/sleep/presentation/sleep_controller.dart';
import 'package:babyapp/features/sleep/presentation/sleep_page.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester, SleepController controller) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: SleepPage(controller: controller),
      ),
    );
    await tester.pumpAndSettle();
  }

  SleepController makeController() => SleepController();

  // Opens the selector and picks the option whose visible label matches
  // [option] (e.g. "1–3 años · [12,36)").
  Future<void> pickBand(WidgetTester tester, String option) async {
    await tester.tap(find.text('Ninguna seleccionada'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  testWidgets('band list shows label and month range for every band (RF-1, CL-3)',
      (tester) async {
    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await tester.tap(find.text('Ninguna seleccionada'));
    await tester.pumpAndSettle();

    expect(find.text('0–3 meses · [0,3)'), findsOneWidget);
    expect(find.text('3–12 meses · [3,12)'), findsOneWidget);
    expect(find.text('1–3 años · [12,36)'), findsOneWidget);
    expect(find.text('4–5 años · [36,60]'), findsOneWidget);
  });

  testWidgets('choosing a band shows hours, naps, schedule and signs (RF-2)',
      (tester) async {
    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickBand(tester, '1–3 años · [12,36)');

    expect(find.text('Horas totales por día'), findsOneWidget);
    expect(find.text('11–14 h'), findsOneWidget);
    expect(find.text('Siestas'), findsOneWidget);
    expect(find.text('1 siesta de tarde, 1–2 h'), findsOneWidget);
    expect(find.text('Horario orientativo'), findsOneWidget);
    expect(find.textContaining('19:30–21:00'), findsOneWidget);
    expect(find.text('Señales de sueño insuficiente'), findsOneWidget);
    expect(find.textContaining('Rabietas'), findsOneWidget);
  });

  testWidgets('medical disclaimer visible without selection and after (RF-3)',
      (tester) async {
    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(
      find.text(
        'Esta información es orientativa y no sustituye el consejo de un '
        'profesional de salud.',
      ),
      findsOneWidget,
    );

    await pickBand(tester, '0–3 meses · [0,3)');
    expect(
      find.text(
        'Esta información es orientativa y no sustituye el consejo de un '
        'profesional de salud.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('alarm block is highlighted without replacing info content (RF-3)',
      (tester) async {
    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickBand(tester, '0–3 meses · [0,3)');

    expect(find.text('Cuándo consultar al pediatra'), findsOneWidget);
    // A clinical alarm sign with its everyday clarification is shown.
    expect(
      find.textContaining('pausas respiratorias'),
      findsOneWidget,
    );
    expect(find.textContaining('paradas breves'), findsOneWidget);
    // Informational content is still present alongside the alarm block.
    expect(find.text('Horas totales por día'), findsOneWidget);
    expect(find.text('14–17 h'), findsOneWidget);
  });

  testWidgets('long content scrolls without cutting info (CL-4, RNF-2)',
      (tester) async {
    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickBand(tester, '0–3 meses · [0,3)');

    // Content is taller than the viewport, so it must be scrollable.
    final scrollable = find.byType(SingleChildScrollView);
    expect(scrollable, findsOneWidget);
    final scrollableWidget = tester.widget<SingleChildScrollView>(scrollable);
    expect(scrollableWidget.scrollDirection, Axis.vertical);

    // The disclaimer sits at the bottom; scrolling the content to it proves
    // nothing is cut off (CL-4).
    final disclaimer = find.text(
      'Esta información es orientativa y no sustituye el consejo de un '
      'profesional de salud.',
    );
    expect(disclaimer, findsOneWidget);

    await tester.ensureVisible(disclaimer);
    await tester.pumpAndSettle();

    // Alarms that were below the fold are reachable after scrolling.
    final alarmTitle = find.text('Cuándo consultar al pediatra');
    await tester.ensureVisible(alarmTitle);
    await tester.pumpAndSettle();
    expect(alarmTitle, findsOneWidget);
  });

  testWidgets('layout renders at 320dp width without overflow (RNF-2, CL-5, CL-7)',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    // Temporarily surfaced to identify the overflowing widget (RNF-2).
    await pickBand(tester, '4–5 años · [36,60]');
    expect(find.text('Señales de sueño insuficiente'), findsOneWidget);
    expect(find.text('Cuándo consultar al pediatra'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('labels are centralized in Spanish via l10n (§6)', (tester) async {
    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(find.text('Cuánto debe dormir tu hijo'), findsOneWidget);
    expect(find.text('Elige la franja de edad del bebé'), findsWidgets);
    await pickBand(tester, '3–12 meses · [3,12)');
    expect(find.text('Siestas'), findsOneWidget);
    expect(find.text('Horas totales por día'), findsOneWidget);
  });
}
