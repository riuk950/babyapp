import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/features/breastmilk/presentation/breastmilk_controller.dart';
import 'package:babyapp/features/breastmilk/presentation/breastmilk_page.dart';
import 'package:babyapp/features/breastmilk/presentation/l10n/app_localizations.dart';

const _disclaimer =
    'Esta información es orientativa y no sustituye el consejo de un '
    'profesional de lactancia o de salud.';

void main() {
  Future<void> pumpApp(WidgetTester tester, BreastMilkController controller) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: BreastMilkPage(controller: controller),
      ),
    );
    await tester.pumpAndSettle();
  }

  BreastMilkController makeController() => BreastMilkController();

  Future<void> openSection(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  testWidgets('section list shows the 4 sections (RF-1)', (tester) async {
    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(find.text('Extracción'), findsOneWidget);
    expect(find.text('Almacenamiento'), findsOneWidget);
    expect(find.text('Descongelado y uso'), findsOneWidget);
    expect(find.text('Higiene y seguridad'), findsOneWidget);
  });

  testWidgets('choosing a section shows best practices (RF-2)', (tester) async {
    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await openSection(tester, 'Almacenamiento');

    expect(find.text('Mejores prácticas'), findsOneWidget);
    expect(find.textContaining('parte trasera de la nevera'), findsOneWidget);
    expect(find.textContaining('sin BPA'), findsOneWidget);
    expect(find.text('Tiempos de conservación recomendados'), findsOneWidget);
  });

  testWidgets('highlighted block has prefix and semantics without replacing info (RF-3)',
      (tester) async {
    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await openSection(tester, 'Almacenamiento');

    // Visible prefix "Aviso de seguridad" on the highlighted text.
    expect(
      find.textContaining('Aviso de seguridad: No guardar la leche'),
      findsOneWidget,
    );
    // Screen-reader semantic label carries the same prefix (RNF-5).
    expect(
      find.bySemanticsLabel(RegExp('Aviso de seguridad: No guardar la leche')),
      findsOneWidget,
    );
    // Informational content is still present alongside the highlight.
    expect(find.text('Mejores prácticas'), findsOneWidget);
  });

  testWidgets('medical disclaimer visible without and with a section (RF-3)',
      (tester) async {
    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(find.text(_disclaimer), findsOneWidget);

    await openSection(tester, 'Almacenamiento');
    expect(find.text(_disclaimer), findsOneWidget);
  });

  testWidgets('long content scrolls without cutting info (CL-3, RNF-2)',
      (tester) async {
    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await openSection(tester, 'Almacenamiento');

    final scrollable = find.byType(SingleChildScrollView);
    expect(scrollable, findsOneWidget);
    expect(
      tester.widget<SingleChildScrollView>(scrollable).scrollDirection,
      Axis.vertical,
    );

    final disclaimer = find.text(_disclaimer);
    await tester.ensureVisible(disclaimer);
    await tester.pumpAndSettle();
    expect(disclaimer, findsOneWidget);
  });

  testWidgets('storage table reflows to a list at 320dp (CL-9, RNF-2)',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await openSection(tester, 'Almacenamiento');

    // Table headers are gone; rows reflow as a list and nothing is cut.
    expect(find.text('Lugar'), findsNothing);
    expect(find.text('Ambiente'), findsOneWidget);
    expect(find.textContaining('hasta 4 h'), findsOneWidget);
    expect(find.text('Congelador'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('system back returns to the list without a section (CL-8, RF-1)',
      (tester) async {
    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    await openSection(tester, 'Almacenamiento');
    expect(find.text('Mejores prácticas'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Back on the list, no section remembered.
    expect(find.text('Mejores prácticas'), findsNothing);
    expect(find.text('Extracción'), findsOneWidget);
    expect(find.text('Elige una sección'), findsOneWidget);
    expect(controller.section, isNull);
  });

  testWidgets('layout renders at 320dp without overflow (RNF-2, CL-4, CL-6)',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(tester.takeException(), isNull);

    await openSection(tester, 'Higiene y seguridad');
    expect(find.text('Mejores prácticas'), findsOneWidget);
    expect(find.textContaining('Aviso de seguridad'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('labels are centralized in Spanish via l10n (§6)', (tester) async {
    final controller = makeController();
    addTearDown(controller.dispose);
    await pumpApp(tester, controller);

    expect(find.text('Cómo almacenar leche materna'), findsOneWidget);
    expect(find.text('Elige una sección'), findsOneWidget);

    await openSection(tester, 'Descongelado y uso');
    expect(find.text('Mejores prácticas'), findsOneWidget);
    expect(find.textContaining('Aviso de seguridad'), findsWidgets);
  });
}
