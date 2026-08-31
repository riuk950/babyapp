import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/features/routine/presentation/l10n/app_localizations.dart';
import 'package:babyapp/features/routine/presentation/routine_controller.dart';
import 'package:babyapp/features/routine/presentation/routine_page.dart';

const _disclaimer =
    'Esta información es orientativa y no sustituye el consejo de un '
    'profesional de salud.';

void main() {
  Future<void> pumpApp(WidgetTester tester, RoutineController controller) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: RoutinePage(controller: controller),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pickMoment(WidgetTester tester, String option) async {
    await tester.tap(find.text('Elige un momento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  Future<void> pickBand(WidgetTester tester, String option) async {
    await tester.tap(find.text('Ninguna seleccionada'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  testWidgets('moment list shows the 6 moments with Spanish labels (RF-1, CL-2)',
      (tester) async {
    final controller = RoutineController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await tester.tap(find.text('Elige un momento'));
    await tester.pumpAndSettle();

    for (final label in [
      'Mañana', 'Siesta', 'Baño', 'Alimentación', 'Juego/estimulación', 'Noche',
    ]) {
      expect(find.text(label), findsWidgets);
    }
  });

  testWidgets('band list shows label and range for every band (RF-2, CL-3)',
      (tester) async {
    final controller = RoutineController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await tester.tap(find.text('Ninguna seleccionada'));
    await tester.pumpAndSettle();

    expect(find.text('0–3 meses · [0,3)'), findsOneWidget);
    expect(find.text('3–12 meses · [3,12)'), findsOneWidget);
    expect(find.text('1–3 años · [12,36)'), findsOneWidget);
    expect(find.text('4–5 años · [36,60]'), findsOneWidget);
  });

  testWidgets('choosing moment and band shows tips with message and source '
      '(RF-1, RF-2, RF-3, RF-4)', (tester) async {
    final controller = RoutineController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickMoment(tester, 'Mañana');
    await pickBand(tester, '0–3 meses · [0,3)');

    expect(find.textContaining('Abre las cortinas'), findsOneWidget);
    expect(find.textContaining('Habla o canta'), findsOneWidget);

    await tester.ensureVisible(find.textContaining('Recomendación de la OMS')
        .first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Recomendación de la OMS'), findsWidgets);
  });

  testWidgets('tips have equal visual weight, no urgency distinction (RF-5)',
      (tester) async {
    final controller = RoutineController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickMoment(tester, 'Siesta');
    await pickBand(tester, '1–3 años · [12,36)');

    expect(find.textContaining('Establece una siesta'), findsOneWidget);
    // No urgency/priority labels exist on the routine tips screen.
    expect(find.text('Urgencia'), findsNothing);
    expect(find.text('Consulta programada'), findsNothing);
  });

  testWidgets('medical disclaimer visible with and without selection (RF-6, '
      'CL-1, CL-2)', (tester) async {
    final controller = RoutineController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(find.text(_disclaimer), findsOneWidget);

    await pickMoment(tester, 'Noche');
    await pickBand(tester, '4–5 años · [36,60]');
    expect(find.text(_disclaimer), findsOneWidget);
  });

  testWidgets('long content scrolls without cutting info (CL-9, RNF-2)',
      (tester) async {
    final controller = RoutineController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await pickMoment(tester, 'Noche');
    await pickBand(tester, '4–5 años · [36,60]');

    final scrollable = find.byType(SingleChildScrollView);
    expect(scrollable, findsWidgets);
    final elem = tester.widget<SingleChildScrollView>(scrollable.first);
    expect(elem.scrollDirection, Axis.vertical);

    await tester.ensureVisible(find.textContaining('Reduce la luz').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Reduce la luz'), findsOneWidget);
  });

  testWidgets('layout renders at 320dp without overflow (RNF-2, CL-10)',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final controller = RoutineController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(tester.takeException(), isNull);

    await pickMoment(tester, 'Alimentación');
    await pickBand(tester, '0–3 meses · [0,3)');
    expect(find.textContaining('Ofrece el pecho'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('labels are centralized in Spanish via l10n (§6)', (tester) async {
    final controller = RoutineController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(find.text('Tips de rutina diaria'), findsOneWidget);
    expect(find.text('Elige un momento del día'), findsWidgets);
    expect(find.text('Elige la franja de edad del bebé'), findsOneWidget);
  });
}
