import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/features/milestones/presentation/l10n/app_localizations.dart';
import 'package:babyapp/features/milestones/presentation/milestone_controller.dart';
import 'package:babyapp/features/milestones/presentation/milestone_page.dart';

const _disclaimer =
    'Esta información es orientativa y no sustituye el consejo de un '
    'profesional de salud.';

void main() {
  Future<void> pumpApp(
      WidgetTester tester, MilestoneController controller) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MilestonePage(controller: controller),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> selectMonth(WidgetTester tester, int number) async {
    final listScrollable = find
        .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
        .first;
    final target = find.text('Mes $number').hitTestable();
    await tester.scrollUntilVisible(target, 120, scrollable: listScrollable);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  testWidgets('list shows the search field and scrollable month list (RF-1, '
      'RNF-2)', (tester) async {
    final controller = MilestoneController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(find.text('Buscar por número o edad (p. ej., 7)'), findsOneWidget);
    expect(find.text('Mes 1'), findsOneWidget);
    expect(find.text('Elige el mes del bebé (1 a 60 meses)'), findsOneWidget);
    // The list is scrollable: later months are reachable by scrolling.
    final listScrollable = find
        .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(find.text('Mes 60'), 300,
        scrollable: listScrollable);
    expect(find.text('Mes 60'), findsOneWidget);
  });

  testWidgets('search filters the month list and shows a notice on no results '
      '(RF-1, CL-12)', (tester) async {
    final controller = MilestoneController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await tester.enterText(find.byType(TextField), '7');
    await tester.pumpAndSettle();
    expect(find.text('Mes 7'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zzzz-no-existe');
    await tester.pumpAndSettle();
    expect(find.text('No hay meses que coincidan con tu búsqueda'),
        findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(find.text('Mes 1'), findsOneWidget);
  });

  testWidgets('choosing a month shows per-area milestones (RF-1, RF-2)',
      (tester) async {
    final controller = MilestoneController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await selectMonth(tester, 7);
    // All 5 areas are present for month 7.
    expect(find.text('Motricidad gruesa'), findsOneWidget);
    expect(find.text('Motricidad fina'), findsOneWidget);
    expect(find.text('Lenguaje'), findsOneWidget);
    expect(find.text('Social/afectivo'), findsOneWidget);
    expect(find.text('Cognitivo'), findsOneWidget);
    // Month 7 language new milestones are shown.
    expect(find.textContaining('Balbucea series de sonidos'), findsOneWidget);
  });

  testWidgets('last hit is distinguished by text and semantics, not only color '
      '(RF-2, RNF-5, CL-3)', (tester) async {
    final controller = MilestoneController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    // Month 13 fine motor has no new milestone -> resolves to month 12's hit.
    await selectMonth(tester, 13);
    expect(
      find.textContaining(
          'Último hito alcanzado: Pasa las páginas de un libro de cartón'),
      findsOneWidget,
    );
    // Screen-reader semantic label also identifies the previous hit (RNF-5).
    expect(
      find.bySemanticsLabel(RegExp(
          'Último hito alcanzado: Pasa las páginas de un libro de cartón')),
      findsOneWidget,
    );
  });

  testWidgets('alarm signs are highlighted per area without replacing info '
      '(RF-3)', (tester) async {
    final controller = MilestoneController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    // Month 12 has alarm signs in all 5 areas.
    await selectMonth(tester, 12);
    expect(find.text('Señales de alarma'), findsNWidgets(5));
    expect(find.textContaining('No se sienta solo'), findsOneWidget);
    // Informational milestones still present alongside the alarms (RF-3).
    expect(find.text('Motricidad gruesa'), findsOneWidget);
    expect(find.textContaining('Da sus primeros pasos solo'), findsOneWidget);
  });

  testWidgets('medical disclaimer is visible with and without a month (RF-3, '
      'CL-1)', (tester) async {
    final controller = MilestoneController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    // With a month: the detail shows the disclaimer (RF-3).
    await selectMonth(tester, 7);
    expect(find.text(_disclaimer), findsOneWidget);

    // Back to the no-month list (CL-1).
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Elige el mes del bebé (1 a 60 meses)'), findsOneWidget);

    // Without a month: the disclaimer lives at the bottom of the scrollable
    // month list (RF-3).
    final listScrollable = find
        .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(find.text(_disclaimer), 400,
        scrollable: listScrollable);
    expect(find.text(_disclaimer), findsOneWidget);
  });

  testWidgets('long content scrolls without cutting info (CL-4, RNF-2)',
      (tester) async {
    final controller = MilestoneController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await selectMonth(tester, 60);
    final scroll = find.byType(SingleChildScrollView);
    expect(scroll, findsWidgets);
    final disclaimer = find.text(_disclaimer);
    await tester.ensureVisible(disclaimer);
    await tester.pumpAndSettle();
    expect(disclaimer, findsOneWidget);
  });

  testWidgets('layout renders at 320dp without overflow (RNF-2, CL-5, CL-7)',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final controller = MilestoneController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(tester.takeException(), isNull);

    await selectMonth(tester, 12);
    expect(find.text('Señales de alarma'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('labels are centralized in Spanish via l10n (§6)', (tester) async {
    final controller = MilestoneController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(find.text('Hitos de desarrollo'), findsOneWidget);
    expect(find.text('Elige el mes del bebé (1 a 60 meses)'), findsOneWidget);

    await selectMonth(tester, 12);
    expect(find.text('Señales de alarma'), findsNWidgets(5));
  });
}
