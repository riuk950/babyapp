import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/models.dart';
import 'package:babyapp/core/domain/clothing/age_band.dart';

void main() {
  group('ageBandForMonths — RF-6, CL-13', () {
    test('membership at 0, 3, 12, 36, 60 months', () {
      expect(ageBandForMonths(0), AgeBand.newborn0to3);
      expect(ageBandForMonths(3), AgeBand.infant3to12);
      expect(ageBandForMonths(12), AgeBand.toddler12to36);
      expect(ageBandForMonths(36), AgeBand.child36to60);
      expect(ageBandForMonths(60), AgeBand.child36to60);
    });

    test('half-open boundaries exclusive of upper edge', () {
      expect(ageBandForMonths(2), AgeBand.newborn0to3);
      expect(ageBandForMonths(11), AgeBand.infant3to12);
      expect(ageBandForMonths(35), AgeBand.toddler12to36);
    });

    test('no band outside [0,60] -> no recommendation input (CL-13)', () {
      expect(ageBandForMonths(-1), isNull);
      expect(ageBandForMonths(61), isNull);
    });
  });
}
