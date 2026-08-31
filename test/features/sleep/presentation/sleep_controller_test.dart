import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/age/age_band.dart';
import 'package:babyapp/features/sleep/presentation/sleep_controller.dart';

void main() {
  late SleepController controller;

  setUp(() => controller = SleepController());
  tearDown(() => controller.dispose());

  group('SleepController — RF-1, RF-4, CL-2, CL-6, CL-9, RNF-3', () {
    test('no band -> guide null with medical disclaimer visible (RF-1, CL-1)',
        () {
      expect(controller.guide, isNull);
      expect(controller.medicalDisclaimer, isNotEmpty);
    });

    test('selecting a band shows its guide (RF-1)', () {
      controller.selectBand(AgeBand.infant3to12);
      expect(controller.guide, isNotNull);
      expect(controller.guide!.band, AgeBand.infant3to12);
      expect(controller.guide!.totalHoursPerDay, isNotEmpty);
    });

    test('changing band replaces the whole guide (RF-4, CL-2)', () {
      controller.selectBand(AgeBand.newborn0to3);
      final newborn = controller.guide!;
      controller.selectBand(AgeBand.toddler12to36);
      expect(controller.guide, isNotNull);
      expect(controller.guide!.band, AgeBand.toddler12to36);
      expect(controller.guide!.band, isNot(newborn.band));
      expect(controller.guide!.totalHoursPerDay, isNot(newborn.totalHoursPerDay));
    });

    test('selecting the same band twice is idempotent (CL-9)', () {
      controller.selectBand(AgeBand.child36to60);
      final first = controller.guide!;
      controller.selectBand(AgeBand.child36to60);
      expect(controller.guide!.band, first.band);
      expect(controller.guide!.totalHoursPerDay, first.totalHoursPerDay);
    });

    test('reset clears the selection (CL-6, RNF-3)', () {
      controller.selectBand(AgeBand.newborn0to3);
      expect(controller.guide, isNotNull);
      controller.reset();
      expect(controller.guide, isNull);
      expect(controller.medicalDisclaimer, isNotEmpty);
    });

    test('selecting null clears the guide (RF-1)', () {
      controller.selectBand(AgeBand.infant3to12);
      controller.selectBand(null);
      expect(controller.guide, isNull);
    });
  });
}
