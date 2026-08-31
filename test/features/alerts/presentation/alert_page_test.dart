import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/features/alerts/presentation/l10n/app_localizations.dart';
import 'package:babyapp/features/alerts/presentation/alert_controller.dart';
import 'package:babyapp/features/alerts/presentation/alert_page.dart';

const _disclaimer =
    'Esta información es orientativa y no sustituye el consejo de un '
    'profesional de salud.';

void main() {
  Future<void> pumpApp(WidgetTester tester, AlertController controller) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: AlertPage(controller: controller),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Opens the selector and picks the option whose visible label matches
  // [option] (e.g. "1–3 años · [12,36)"), mirroring the sleep selector.
  Future<void> pickBand(WidgetTester tester, String option) async {
    await tester.tap(find.text('Ninguna seleccionada'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  testWidgets('band list shows label and month range for every band (RF-1, '
      'CL-3)', (tester) async {
    final controller = AlertController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await tester.tap(find.text('Ninguna seleccionada'));
    await tester.pumpAndSettle();

    expect(find.text('0–3 meses · [0,3)'), findsOneWidget);
    expect(find.text('3–12 meses · [3,12)'), findsOneWidget);
    expect(find.text('1–3 años · [12,36)'), findsOneWidget);
    expect(find.text('4–5 años · [36,60]'), findsOneWidget);
  });

  testWidgets('choosing a band shows alert signals per area at once (RF-2)',
      (tester) async {
    final controller = AlertController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickBand(tester, '1–3 años · [12,36)');

    // Areas with signals are shown; empty areas are omitted (CL-10).
    expect(find.text('Motricidad fina'), findsOneWidget);
    expect(find.text('Lenguaje'), findsOneWidget);
    expect(find.text('Social/afectivo'), findsOneWidget);
    expect(find.text('Cognitivo'), findsOneWidget);
    // Gross motor is omitted for this band (no signals) (CL-10).
    expect(find.text('Motricidad gruesa'), findsNothing);

    expect(find.textContaining('No usa la pinza'), findsOneWidget);
    expect(find.textContaining('No dice palabras sueltas'), findsOneWidget);
  });

  testWidgets('urgency level is distinguished by text and semantics, not only '
      'color (RF-3, RNF-5)', (tester) async {
    final controller = AlertController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickBand(tester, '0–3 meses · [0,3)');

    // The action guide for the urgency signal is shown as text.
    expect(find.textContaining('Acude a urgencias de inmediato.'),
        findsWidgets);
    // The scheduled signal action exposes its level in its semantics label.
    expect(
      find.bySemanticsLabel(RegExp('Consulta programada:.*No levanta la '
          'cabeza')),
      findsOneWidget,
    );
  });

  testWidgets('consultation-pronto hint appears for 24-48h signals (RF-3)',
      (tester) async {
    final controller = AlertController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickBand(tester, '0–3 meses · [0,3)');
    expect(find.textContaining('Consulta pronto'), findsOneWidget);
  });

  testWidgets('medical disclaimer visible with and without a band (RF-3, CL-1)',
      (tester) async {
    final controller = AlertController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(find.text(_disclaimer), findsOneWidget);

    await pickBand(tester, '0–3 meses · [0,3)');
    expect(find.text(_disclaimer), findsOneWidget);
  });

  testWidgets('long content scrolls without cutting info (CL-4, RNF-2)',
      (tester) async {
    final controller = AlertController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickBand(tester, '4–5 años · [36,60]');

    // Content is taller than the viewport, so it must be vertically scrollable.
    final scrollable = find.byType(SingleChildScrollView);
    expect(scrollable, findsWidgets);
    final elem = tester.widget<SingleChildScrollView>(scrollable.first);
    expect(elem.scrollDirection, Axis.vertical);

    // A signal near the top of one area is reachable.
    await tester.ensureVisible(find.textContaining('No se mantiene sobre un pie'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No se mantiene sobre un pie'), findsOneWidget);
  });

  testWidgets('layout renders at 320dp without overflow (RNF-2, CL-5, CL-7)',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final controller = AlertController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(tester.takeException(), isNull);

    await pickBand(tester, '0–3 meses · [0,3)');
    expect(find.text('Motricidad gruesa'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('labels are centralized in Spanish via l10n (§6)', (tester) async {
    final controller = AlertController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(find.text('Señales de alerta'), findsOneWidget);
    expect(find.text('Elige la franja de edad del bebé'), findsWidgets);
  });
}
