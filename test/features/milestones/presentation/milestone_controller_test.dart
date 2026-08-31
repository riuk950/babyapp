import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/milestones/milestone_month.dart';
import 'package:babyapp/features/milestones/presentation/milestone_controller.dart';

void main() {
  late MilestoneController controller;

  setUp(() => controller = MilestoneController());
  tearDown(() => controller.dispose());

  group('MilestoneController — RF-1, RF-4, RNF-3, CL-1, CL-2, CL-6, CL-12', () {
    test('no month -> no resolved content but a medical disclaimer (RF-1, '
        'CL-1, RF-3)', () {
      expect(controller.resolvedContent, isNull);
      expect(controller.medicalDisclaimer, isNotEmpty);
    });

    test('selecting a month exposes its resolved content (RF-1, RF-2)', () {
      controller.selectMonth(MilestoneMonth.month7);
      expect(controller.resolvedContent, isNotNull);
      expect(controller.resolvedContent!.month, MilestoneMonth.month7);
      expect(controller.resolvedContent!.areas, isNotEmpty);
    });

    test('changing month replaces the whole resolved content (RF-4, CL-2)',
        () {
      controller.selectMonth(MilestoneMonth.month1);
      final first = controller.resolvedContent!;
      controller.selectMonth(MilestoneMonth.month24);
      expect(controller.resolvedContent, isNotNull);
      expect(controller.resolvedContent!.month, MilestoneMonth.month24);
      expect(controller.resolvedContent!.month, isNot(first.month));
    });

    test('selecting the same month twice is idempotent (CL-2, RF-5)', () {
      controller.selectMonth(MilestoneMonth.month13);
      final first = controller.resolvedContent!;
      controller.selectMonth(MilestoneMonth.month13);
      expect(controller.resolvedContent!.month, first.month);
      expect(controller.resolvedContent!.areas.map((a) => a.label).toList(),
          first.areas.map((a) => a.label).toList());
    });

    test('reset clears the selection (RNF-3, CL-6)', () {
      controller.selectMonth(MilestoneMonth.month7);
      expect(controller.resolvedContent, isNotNull);
      controller.reset();
      expect(controller.resolvedContent, isNull);
      expect(controller.medicalDisclaimer, isNotEmpty);
    });

    test('selecting null clears the content (RF-1)', () {
      controller.selectMonth(MilestoneMonth.month7);
      controller.selectMonth(null);
      expect(controller.resolvedContent, isNull);
    });

    test('search returns matching months by number (RF-1)', () {
      expect(controller.filteredMonths, hasLength(60));
      controller.setQuery('7');
      expect(controller.filteredMonths, contains(MilestoneMonth.month7));
    });

    test('search matches the age label text (RF-1, CL-12)', () {
      controller.setQuery('59 a 60 meses');
      final results = controller.filteredMonths;
      expect(results, contains(MilestoneMonth.month60));
      expect(results.every((m) => m.ageLabel.contains('59 a 60 meses')), isTrue);
    });

    test('search with no results -> empty list and a no-results notice '
        '(CL-12)', () {
      controller.setQuery('zzzz-no-existe');
      expect(controller.filteredMonths, isEmpty);
      expect(controller.hasNoSearchResults, isTrue);
    });

    test('clearing the search restores the full list (CL-12)', () {
      controller.setQuery('zzzz');
      expect(controller.hasNoSearchResults, isTrue);
      controller.clearQuery();
      expect(controller.filteredMonths, hasLength(60));
      expect(controller.hasNoSearchResults, isFalse);
    });
  });
}
