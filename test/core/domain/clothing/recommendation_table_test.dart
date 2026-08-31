import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/models.dart';
import 'package:babyapp/core/domain/clothing/recommendation_table.dart';

void main() {
  group('recommendationFor — RF-7', () {
    const band = AgeBand.infant3to12;

    test('range limits fall into a single expected range', () {
      // -6 -> first range (-30..-6)
      expect(temperatureRangeIndexFor(-6), 0);
      // 5 -> second (-5..5)
      expect(temperatureRangeIndexFor(5), 1);
      // 6 -> third (6..12)
      expect(temperatureRangeIndexFor(6), 2);
      expect(temperatureRangeIndexFor(12), 2);
      // 13 -> fourth (13..17)
      expect(temperatureRangeIndexFor(13), 3);
      expect(temperatureRangeIndexFor(17), 3);
      // 18 -> fifth (18..24)
      expect(temperatureRangeIndexFor(18), 4);
      expect(temperatureRangeIndexFor(24), 4);
      // 25 -> sixth (25..29)
      expect(temperatureRangeIndexFor(25), 5);
      expect(temperatureRangeIndexFor(29), 5);
      // 30 -> seventh (30..50)
      expect(temperatureRangeIndexFor(30), 6);
      expect(temperatureRangeIndexFor(50), 6);
    });

    test('domain -30..50 has no gaps (CL-2)', () {
      for (var celsius = -30; celsius <= 50; celsius++) {
        final index = temperatureRangeIndexFor(celsius);
        expect(index, isNonNegative, reason: 'celsius=$celsius');
        expect(recommendationFor(celsius, band), isNotEmpty,
            reason: 'celsius=$celsius');
      }
    });

    test('base ranges are contiguous with no gaps', () {
      // Verify that the full integer domain maps to the same set of ranges
      // covered by the extreme boundaries (a full sweep already asserts this).
      expect(temperatureRangeIndexFor(-30), 0);
      expect(temperatureRangeIndexFor(-7), 0);
      // boundary just below -6
      expect(temperatureRangeIndexFor(-6), 0);
      // first value of the next range
      expect(temperatureRangeIndexFor(-5), 1);
      // end of domain
      expect(temperatureRangeIndexFor(50), 6);
    });

    test('newborn gets +1 layer when temperature <= 12 C (RF-7)', () {
      const newborn = AgeBand.newborn0to3;
      expect(recommendationFor(12, newborn), contains('1 capa'));
      expect(recommendationFor(5, newborn), contains('1 capa'));
      expect(recommendationFor(-30, newborn), contains('1 capa'));
    });

    test('newborn has no extra layer above 12 C', () {
      const newborn = AgeBand.newborn0to3;
      expect(recommendationFor(13, newborn), isNot(contains('1 capa')));
      expect(recommendationFor(30, newborn), isNot(contains('1 capa')));
    });

    test('non-newborn bands do not add an extra layer', () {
      expect(recommendationFor(5, AgeBand.infant3to12),
          isNot(contains('1 capa')));
      expect(recommendationFor(12, AgeBand.toddler12to36),
          isNot(contains('1 capa')));
    });

    test('exact base texts (RF-7)', () {
      expect(
        recommendationFor(20, band),
        'Body manga corta de algodón + pantalón; chaleco fino opcional',
      );
      expect(
        recommendationFor(-5, band),
        'Body manga larga + jersey + chaqueta de abrigo; gorro',
      );
      expect(
        recommendationFor(35, band),
        'Solo body/babador de algodón transpirable',
      );
    });
  });
}
