import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/firstaid/severity_level.dart';

void main() {
  group('SeverityLevel inventory (RF-5, CL-8)', () {
    test('enum has exactly the 2 mutually exclusive levels (RF-5, CL-8)', () {
      expect(SeverityLevel.values, hasLength(2));
      expect(SeverityLevel.values, contains(SeverityLevel.urgency));
      expect(SeverityLevel.values, contains(SeverityLevel.consult));
    });

    test('every level has a non-empty Spanish label (RF-5)', () {
      for (final level in SeverityLevel.values) {
        expect(level.label, isNotEmpty, reason: 'label vacía para $level');
        expect(level.label, isNot(contains('_')),
            reason: 'label debe estar en español');
      }
    });

    test('every level has a non-empty Spanish action guide (RF-5)', () {
      for (final level in SeverityLevel.values) {
        expect(level.actionGuide, isNotEmpty,
            reason: 'guía vacía para $level');
      }
    });

    test('urgency and consult are semantically different (RF-5, CL-8)', () {
      expect(SeverityLevel.urgency.label,
          isNot(SeverityLevel.consult.label));
      expect(SeverityLevel.urgency.actionGuide,
          isNot(SeverityLevel.consult.actionGuide));
    });
  });
}
