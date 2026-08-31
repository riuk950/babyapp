import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/age/age_band.dart';
import 'package:babyapp/core/domain/firstaid/emergency_type.dart';
import 'package:babyapp/core/domain/firstaid/firstaid_content.dart';
import 'package:babyapp/core/domain/firstaid/severity_level.dart';

void main() {
  group('availableEmergencies and null handling (RF-1, RF-2, CL-1, CL-2)', () {
    test('availableEmergencies returns the 12 emergencies (RF-1)', () {
      expect(availableEmergencies(), hasLength(12));
      expect(
          availableEmergencies().toSet(), EmergencyType.values.toSet());
    });

    test('contentFor(null band) returns null (RF-2, CL-1)', () {
      for (final emergency in EmergencyType.values) {
        expect(contentFor(emergency, null), isNull);
      }
    });

    test('contentFor(null emergency) returns null (RF-3, CL-2)', () {
      for (final band in AgeBand.values) {
        expect(contentFor(null, band), isNull);
      }
    });
  });

  group('content validity (RF-2..RF-5, CL-8)', () {
    test('every emergency has content with a valid severity (CL-8)', () {
      for (final emergency in EmergencyType.values) {
        final combos = AgeBand.values
            .map((band) => contentFor(emergency, band))
            .where((g) => g != null)
            .toList();
        expect(combos, isNotEmpty,
            reason: '$emergency has no content in any band (CL-8)');
        for (final guide in combos) {
          expect(
            guide!.severity,
            anyOf(SeverityLevel.urgency, SeverityLevel.consult),
            reason: 'gravedad inválida para $emergency',
          );
        }
      }
    });

    test('steps are sequentially numbered and non-empty (RF-3)', () {
      for (final emergency in EmergencyType.values) {
        for (final band in AgeBand.values) {
          final guide = contentFor(emergency, band);
          if (guide == null) continue;
          expect(guide.steps, isNotEmpty);
          expect(guide.steps.length,
              guide.steps.last.order,
              reason: 'orders must run 1..n',
              );
          expect(guide.steps.first.order, 1);
          for (final step in guide.steps) {
            expect(step.text, isNotEmpty,
                reason: 'paso vacío para $emergency/$band');
          }
          for (var i = 0; i < guide.steps.length - 1; i++) {
            expect(guide.steps[i + 1].order - guide.steps[i].order, 1,
                reason: 'pasos deben ser consecutivos');
          }
        }
      }
    });

    test('do-not section is present and non-empty (RF-4)', () {
      for (final emergency in EmergencyType.values) {
        for (final band in AgeBand.values) {
          final guide = contentFor(emergency, band);
          if (guide == null) continue;
          expect(guide.doNot, isNotEmpty,
              reason: '$emergency/$band lacks doNot (RF-4)');
          expect(guide.doNot.first.order, 1);
          for (final step in guide.doNot) {
            expect(step.text, isNotEmpty);
          }
        }
      }
    });

    test('content is deterministic: same input, same guide (RF-5)', () {
      for (final emergency in EmergencyType.values) {
        for (final band in AgeBand.values) {
          final a = contentFor(emergency, band);
          final b = contentFor(emergency, band);
          if (a == null) {
            expect(b, isNull);
            continue;
          }
          expect(b, isNotNull);
          expect(a.steps.length, b!.steps.length);
          expect(a.doNot.length, b.doNot.length);
          expect(a.severity, b.severity);
        }
      }
    });

    test('medical disclaimer is a single constant (RF-6)', () {
      expect(medicalDisclaimer, isNotEmpty);
    });
  });

  group('band adaptation and coverage (RF-2, CL-3, CL-8)', () {
    test('emergency without steps for one band is omitted (CL-3)', () {
      for (final emergency in EmergencyType.values) {
        for (final band in AgeBand.values) {
          final guide = contentFor(emergency, band);
          expect(guide == null || guide.steps.isNotEmpty, isTrue);
        }
      }
    });

    test('at least one emergency appears in every band (error check, CL-8)',
        () {
      for (final band in AgeBand.values) {
        final any = EmergencyType.values
            .any((e) => contentFor(e, band) != null);
        expect(any, isTrue, reason: 'no emergency has content for $band');
      }
    });
  });
}
