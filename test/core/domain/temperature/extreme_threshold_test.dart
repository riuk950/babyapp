import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/models.dart';
import 'package:babyapp/core/domain/temperature/extreme_threshold.dart';

void main() {
  group('evaluateExtreme — RF-8, CL-3', () {
    test('effective value 0 -> cold', () {
      expect(evaluateExtreme(0), ExtremeLevel.cold);
    });

    test('effective value 30 -> heat', () {
      expect(evaluateExtreme(30), ExtremeLevel.heat);
    });

    test('effective values 1..29 -> none', () {
      for (var v = 1; v <= 29; v++) {
        expect(evaluateExtreme(v), ExtremeLevel.none, reason: 'v=$v');
      }
    });

    test('below 0 -> cold, above 30 -> heat', () {
      expect(evaluateExtreme(-30), ExtremeLevel.cold);
      expect(evaluateExtreme(-1), ExtremeLevel.cold);
      expect(evaluateExtreme(31), ExtremeLevel.heat);
      expect(evaluateExtreme(50), ExtremeLevel.heat);
    });
  });
}
