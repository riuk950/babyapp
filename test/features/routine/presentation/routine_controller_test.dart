import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/age/age_band.dart';
import 'package:babyapp/core/domain/routine/routine_moment.dart';
import 'package:babyapp/features/routine/presentation/routine_controller.dart';

void main() {
  test('no moment and no band -> no tips but a medical disclaimer (RF-1, '
      'RF-2, RF-6, CL-1, CL-2)', () {
    final controller = RoutineController();
    addTearDown(controller.dispose);

    expect(controller.moment, isNull);
    expect(controller.band, isNull);
    expect(controller.tips, isNull);
    expect(controller.medicalDisclaimer, isNotEmpty);
  });

  test('no band -> no tips even with a moment (RF-2, CL-1)', () {
    final controller = RoutineController();
    addTearDown(controller.dispose);

    controller.selectMoment(RoutineMoment.morning);
    expect(controller.tips, isNull);
  });

  test('selecting moment and band exposes tips (RF-1, RF-2, RF-3)', () {
    final controller = RoutineController();
    addTearDown(controller.dispose);

    controller.selectMoment(RoutineMoment.morning);
    controller.selectBand(AgeBand.newborn0to3);
    expect(controller.moment, RoutineMoment.morning);
    expect(controller.band, AgeBand.newborn0to3);
    expect(controller.tips, isNotEmpty);
  });

  test('changing moment replaces the tips (RF-3, CL-5)', () {
    final controller = RoutineController();
    addTearDown(controller.dispose);

    controller.selectMoment(RoutineMoment.morning);
    controller.selectBand(AgeBand.newborn0to3);
    final first = controller.tips;
    controller.selectMoment(RoutineMoment.night);
    expect(controller.tips, isNot(same(first)));
    expect(
      controller.tips!.first.message,
      contains('Acuesta'),
    );
  });

  test('changing band replaces the tips (RF-2, CL-4)', () {
    final controller = RoutineController();
    addTearDown(controller.dispose);

    controller.selectMoment(RoutineMoment.feeding);
    controller.selectBand(AgeBand.newborn0to3);
    controller.selectBand(AgeBand.child36to60);
    expect(controller.band, AgeBand.child36to60);
    expect(
      controller.tips!.first.message,
      contains('Acompaña'),
    );
  });

  test('selecting the same moment and band twice is idempotent (CL-7, RF-5)',
      () {
    final controller = RoutineController();
    addTearDown(controller.dispose);

    controller.selectMoment(RoutineMoment.bath);
    controller.selectBand(AgeBand.infant3to12);
    final a = controller.tips;
    controller.selectMoment(RoutineMoment.bath);
    controller.selectBand(AgeBand.infant3to12);
    expect(controller.tips, a);
  });

  test('reset clears both selections (RNF-3, CL-6)', () {
    final controller = RoutineController();
    addTearDown(controller.dispose);

    controller.selectMoment(RoutineMoment.play);
    controller.selectBand(AgeBand.toddler12to36);
    controller.reset();
    expect(controller.moment, isNull);
    expect(controller.band, isNull);
    expect(controller.tips, isNull);
  });

  test('selecting null moment or band clears the tips (RF-1, RF-2, CL-1, '
      'CL-2)', () {
    final controller = RoutineController();
    addTearDown(controller.dispose);

    controller.selectMoment(RoutineMoment.morning);
    controller.selectBand(AgeBand.newborn0to3);
    controller.selectMoment(null);
    expect(controller.tips, isNull);
    controller.selectMoment(RoutineMoment.morning);
    controller.selectBand(null);
    expect(controller.tips, isNull);
  });
}
