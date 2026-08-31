import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/age/age_band.dart';
import 'package:babyapp/features/alerts/presentation/alert_controller.dart';

void main() {
  test('no band -> no guide but a medical disclaimer (RF-1, RF-3, CL-1)', () {
    final controller = AlertController();
    addTearDown(controller.dispose);

    expect(controller.band, isNull);
    expect(controller.guide, isNull);
    expect(controller.medicalDisclaimer, isNotEmpty);
  });

  test('selecting a band exposes its guide (RF-1, RF-2)', () {
    final controller = AlertController();
    addTearDown(controller.dispose);

    controller.selectBand(AgeBand.toddler12to36);
    expect(controller.band, AgeBand.toddler12to36);
    expect(controller.guide, isNotNull);
    expect(controller.guide!.label, '1–3 años');
  });

  test('changing band replaces the whole guide (RF-4, CL-2)', () {
    final controller = AlertController();
    addTearDown(controller.dispose);

    controller.selectBand(AgeBand.newborn0to3);
    final first = controller.guide;
    controller.selectBand(AgeBand.child36to60);
    expect(controller.guide, isNot(same(first)));
    expect(controller.guide!.label, '4–5 años');
  });

  test('selecting the same band twice is idempotent (CL-2, CL-9, RF-5)', () {
    final controller = AlertController();
    addTearDown(controller.dispose);

    controller.selectBand(AgeBand.infant3to12);
    final a = controller.guide;
    controller.selectBand(AgeBand.infant3to12);
    expect(controller.band, AgeBand.infant3to12);
    expect(controller.guide, a);
  });

  test('reset clears the selection to the no-band state (RNF-3, CL-6)', () {
    final controller = AlertController();
    addTearDown(controller.dispose);

    controller.selectBand(AgeBand.newborn0to3);
    controller.reset();
    expect(controller.band, isNull);
    expect(controller.guide, isNull);
  });

  test('selecting null clears the content (RF-1, CL-1)', () {
    final controller = AlertController();
    addTearDown(controller.dispose);

    controller.selectBand(AgeBand.newborn0to3);
    controller.selectBand(null);
    expect(controller.band, isNull);
    expect(controller.guide, isNull);
  });
}
