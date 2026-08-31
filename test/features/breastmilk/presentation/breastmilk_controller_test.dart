import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/breastmilk/breastmilk_section.dart';
import 'package:babyapp/features/breastmilk/presentation/breastmilk_controller.dart';

void main() {
  late BreastMilkController controller;

  setUp(() => controller = BreastMilkController());
  tearDown(() => controller.dispose());

  group('BreastMilkController — RF-1, RF-4, CL-2, CL-8, RNF-3', () {
    test('no section -> content null with medical disclaimer (RF-1, CL-1)',
        () {
      expect(controller.content, isNull);
      expect(controller.medicalDisclaimer, isNotEmpty);
    });

    test('selecting a section shows its content (RF-1)', () {
      controller.selectSection(BreastMilkSection.storage);
      expect(controller.content, isNotNull);
      expect(controller.content!.section, BreastMilkSection.storage);
      expect(controller.content!.bestPractices, isNotEmpty);
    });

    test('changing section replaces the whole content (RF-4, CL-2)', () {
      controller.selectSection(BreastMilkSection.extraction);
      final extraction = controller.content!;
      controller.selectSection(BreastMilkSection.hygiene);
      expect(controller.content, isNotNull);
      expect(controller.content!.section, BreastMilkSection.hygiene);
      expect(controller.content!.section, isNot(extraction.section));
      expect(controller.content!.bestPractices, isNot(extraction.bestPractices));
    });

    test('selecting the same section twice is idempotent (CL-8)', () {
      controller.selectSection(BreastMilkSection.defrosting);
      final first = controller.content!;
      controller.selectSection(BreastMilkSection.defrosting);
      expect(controller.content!.section, first.section);
      expect(controller.content!.bestPractices, first.bestPractices);
    });

    test('reset clears the selection (CL-8, RNF-3)', () {
      controller.selectSection(BreastMilkSection.storage);
      expect(controller.content, isNotNull);
      controller.reset();
      expect(controller.content, isNull);
      expect(controller.medicalDisclaimer, isNotEmpty);
    });

    test('selecting null clears the content (RF-1)', () {
      controller.selectSection(BreastMilkSection.storage);
      controller.selectSection(null);
      expect(controller.content, isNull);
    });
  });
}
