import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/age/age_band.dart';
import 'package:babyapp/core/domain/firstaid/emergency_type.dart';
import 'package:babyapp/core/domain/firstaid/severity_level.dart';
import 'package:babyapp/features/firstaid/presentation/firstaid_controller.dart';

void main() {
  test('no emergency and no band -> no guide but a medical disclaimer (RF-1, '
      'RF-2, RF-6, CL-1, CL-2)', () {
    final controller = FirstAidController();
    addTearDown(controller.dispose);

    expect(controller.emergency, isNull);
    expect(controller.band, isNull);
    expect(controller.guide, isNull);
    expect(controller.medicalDisclaimer, isNotEmpty);
  });

  test('no band -> no guide even with an emergency (RF-2, CL-1)', () {
    final controller = FirstAidController();
    addTearDown(controller.dispose);

    controller.selectEmergency(EmergencyType.choking);
    expect(controller.guide, isNull);
  });

  test('selecting emergency and band exposes a guide (RF-1, RF-2, RF-3)',
      () {
    final controller = FirstAidController();
    addTearDown(controller.dispose);

    controller.selectEmergency(EmergencyType.choking);
    controller.selectBand(AgeBand.newborn0to3);
    expect(controller.emergency, EmergencyType.choking);
    expect(controller.band, AgeBand.newborn0to3);
    expect(controller.guide, isNotNull);
    expect(controller.guide!.steps, isNotEmpty);
  });

  test('changing emergency replaces the guide (RF-3, CL-5)', () {
    final controller = FirstAidController();
    addTearDown(controller.dispose);

    controller.selectEmergency(EmergencyType.choking);
    controller.selectBand(AgeBand.newborn0to3);
    final first = controller.guide;
    controller.selectEmergency(EmergencyType.seizures);
    expect(controller.guide, isNot(same(first)));
    expect(controller.guide!.steps.first.text, contains('Coloca'));
  });

  test('changing band replaces the guide and adapts severity (RF-2, CL-4)',
      () {
    final controller = FirstAidController();
    addTearDown(controller.dispose);

    controller.selectEmergency(EmergencyType.highFever);
    controller.selectBand(AgeBand.newborn0to3);
    expect(controller.guide!.severity, SeverityLevel.urgency);
    controller.selectBand(AgeBand.child36to60);
    expect(controller.guide!.severity, SeverityLevel.consult);
  });

  test('selecting the same emergency and band twice is idempotent (CL-7, '
      'RF-3)', () {
    final controller = FirstAidController();
    addTearDown(controller.dispose);

    controller.selectEmergency(EmergencyType.burns);
    controller.selectBand(AgeBand.infant3to12);
    final a = controller.guide;
    controller.selectEmergency(EmergencyType.burns);
    controller.selectBand(AgeBand.infant3to12);
    expect(controller.guide, a);
  });

  test('reset clears both selections (RNF-3, CL-6)', () {
    final controller = FirstAidController();
    addTearDown(controller.dispose);

    controller.selectEmergency(EmergencyType.falls);
    controller.selectBand(AgeBand.toddler12to36);
    controller.reset();
    expect(controller.emergency, isNull);
    expect(controller.band, isNull);
    expect(controller.guide, isNull);
  });

  test('selecting null emergency or band clears the guide (RF-1, RF-2, '
      'CL-1, CL-2)', () {
    final controller = FirstAidController();
    addTearDown(controller.dispose);

    controller.selectEmergency(EmergencyType.choking);
    controller.selectBand(AgeBand.newborn0to3);
    controller.selectEmergency(null);
    expect(controller.guide, isNull);
    controller.selectEmergency(EmergencyType.choking);
    controller.selectBand(null);
    expect(controller.guide, isNull);
  });
}
