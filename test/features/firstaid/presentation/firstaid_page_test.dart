import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/features/firstaid/presentation/firstaid_controller.dart';
import 'package:babyapp/features/firstaid/presentation/firstaid_page.dart';
import 'package:babyapp/features/firstaid/presentation/l10n/app_localizations.dart';

const _disclaimer =
    'Esta información es orientativa y no sustituye el consejo de un '
    'profesional de salud.';

void main() {
  Future<void> pumpApp(WidgetTester tester, FirstAidController controller) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: FirstAidPage(controller: controller),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pickEmergency(WidgetTester tester, String option) async {
    await tester.tap(find.text('Elige una emergencia'));
    await tester.pumpAndSettle();

    // The dropdown menu's scrollable is the last Scrollable in the overlay.
    await tester.scrollUntilVisible(find.text(option), 80,
        scrollable: find.byType(Scrollable).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  Future<void> pickBand(WidgetTester tester, String option) async {
    await tester.tap(find.text('Ninguna seleccionada'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text(option), 80,
        scrollable: find.byType(Scrollable).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  testWidgets('emergency list shows the 12 situations in Spanish (RF-1, CL-2)',
      (tester) async {
    final controller = FirstAidController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await tester.tap(find.text('Elige una emergencia'));
    await tester.pumpAndSettle();

    for (final label in [
      'Atragantamiento', 'Quemaduras', 'Caídas', 'Picaduras y mordeduras',
      'Convulsiones', 'Fiebre alta', 'Heridas sangrantes', 'Intoxicación',
      'Golpe en la cabeza', 'Alergias graves', 'Ahogamiento',
      'Objetos en ojos, orejas o nariz',
    ]) {
      await tester.scrollUntilVisible(find.text(label), 80,
          scrollable: find.byType(Scrollable).last);
      expect(find.text(label), findsWidgets);
    }
  });

  testWidgets('band list shows label and range for every band (RF-2, CL-3)',
      (tester) async {
    final controller = FirstAidController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await tester.tap(find.text('Ninguna seleccionada'));
    await tester.pumpAndSettle();

    expect(find.text('0–3 meses · [0,3)'), findsOneWidget);
    expect(find.text('3–12 meses · [3,12)'), findsOneWidget);
    expect(find.text('1–3 años · [12,36)'), findsOneWidget);
    expect(find.text('4–5 años · [36,60]'), findsOneWidget);
  });

  testWidgets('choosing emergency and band shows numbered steps and do-not '
      'section (RF-1, RF-2, RF-3, RF-4)', (tester) async {
    final controller = FirstAidController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickEmergency(tester, 'Atragantamiento');
    await pickBand(tester, '0–3 meses · [0,3)');

    expect(find.text('Qué hacer'), findsOneWidget);
    expect(find.text('Qué NO hacer'), findsOneWidget);
    expect(find.textContaining('1. Comprueba'), findsOneWidget);
    expect(find.textContaining('2. Si no respira'), findsOneWidget);
  });

  testWidgets('severity indicator is distinguished by semantic label, not only '
      'color (RF-5, RNF-5)', (tester) async {
    final controller = FirstAidController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickEmergency(tester, 'Ahogamiento');
    await pickBand(tester, '1–3 años · [12,36)');

    expect(find.textContaining('Urgencia'), findsWidgets);
  });

  testWidgets('severity adapts by age band on the same emergency (RF-2, RF-5)',
      (tester) async {
    final controller = FirstAidController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickEmergency(tester, 'Fiebre alta');
    await pickBand(tester, '0–3 meses · [0,3)');
    expect(find.textContaining('Urgencia'), findsWidgets);

    // Change band: tap the currently shown band in the dropdown to reopen it.
    await tester.tap(find.text('0–3 meses · [0,3)').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('4–5 años · [36,60]').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('Consulta'), findsWidgets);
  });

  testWidgets('medical disclaimer visible with and without selection (RF-6, '
      'CL-1, CL-2)', (tester) async {
    final controller = FirstAidController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(find.text(_disclaimer), findsOneWidget);

    await pickEmergency(tester, 'Quemaduras');
    await pickBand(tester, '3–12 meses · [3,12)');
    expect(find.text(_disclaimer), findsOneWidget);
  });

  testWidgets('long content scrolls without cutting info (CL-9, RNF-2)',
      (tester) async {
    final controller = FirstAidController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickEmergency(tester, 'Atragantamiento');
    await pickBand(tester, '0–3 meses · [0,3)');

    final scrollable = find.byType(SingleChildScrollView);
    expect(scrollable, findsWidgets);
    final elem = tester.widget<SingleChildScrollView>(scrollable.first);
    expect(elem.scrollDirection, Axis.vertical);

    await tester.ensureVisible(find.textContaining('4. Llama a emergencias')
        .first);
    await tester.pumpAndSettle();
    expect(find.textContaining('4. Llama a emergencias'), findsOneWidget);
  });

  testWidgets('layout renders at 320dp without overflow (RNF-2, CL-10)',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final controller = FirstAidController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(tester.takeException(), isNull);

    await pickEmergency(tester, 'Convulsiones');
    await pickBand(tester, '0–3 meses · [0,3)');
    expect(find.textContaining('Coloca'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('labels are centralized in Spanish via l10n (§6)', (tester) async {
    final controller = FirstAidController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(find.text('Primeros auxilios'), findsOneWidget);
    expect(find.text('Elige una situación de emergencia'), findsWidgets);
    expect(find.text('Elige la franja de edad del niño'), findsOneWidget);
  });
}
