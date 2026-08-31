import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/age/age_band.dart';
import 'package:babyapp/core/domain/sleep/sleep_content.dart';

void main() {
  const bands = AgeBand.values;

  group('guideFor — RF-1, RF-5, CL-3', () {
    test('no band -> null (RF-1)', () {
      expect(guideFor(null), isNull);
    });

    test('each band has a guide (4/4 coverage, CL-8)', () {
      for (final band in bands) {
        expect(guideFor(band), isNotNull, reason: 'missing guide for $band');
      }
    });

    test('deterministic: same band always returns same content (RF-5, CL-9)', () {
      for (final band in bands) {
        final first = guideFor(band)!;
        final second = guideFor(band)!;
        expect(second.band, first.band);
        expect(second.totalHoursPerDay, first.totalHoursPerDay);
        expect(second.naps, first.naps);
        expect(second.bedtimeSchedule, first.bedtimeSchedule);
        expect(second.insufficientSleepSigns, first.insufficientSleepSigns);
        expect(second.alarmSigns, first.alarmSigns);
      }
    });

    test('every band maps to its own typed placeholder fields (RF-2)', () {
      for (final band in bands) {
        final guide = guideFor(band)!;
        expect(guide.band, band);
        expect(guide.label, isNotEmpty);
        expect(guide.rangeMonths, isNotEmpty);
        expect(guide.totalHoursPerDay, isNotEmpty);
        expect(guide.naps, isNotEmpty);
        expect(guide.bedtimeSchedule, isNotEmpty);
      }
    });
  });

  group('content completeness 4/4 (CL-8)', () {
    test('every band fills every field (RF-2, RF-3)', () {
      for (final band in bands) {
        final guide = guideFor(band)!;
        expect(guide.insufficientSleepSigns, isNotEmpty,
            reason: '$band missing insufficient-sleep signs');
        expect(guide.alarmSigns, isNotEmpty,
            reason: '$band missing alarm signs');
        expect(guide.medicalDisclaimer, isNotEmpty,
            reason: '$band missing disclaimer');
      }
    });

    test('alarm signs of every band carry an everyday clarification (RF-2)',
        () {
      for (final band in bands) {
        final guide = guideFor(band)!;
        for (final alarm in guide.alarmSigns) {
          final lower = alarm.toLowerCase();
          // Clinical terms must carry an embedded everyday clarification
          // wherever they appear (redaction rule, RF-2).
          if (lower.contains('pausas respiratorias')) {
            expect(
              lower.contains('paradas breves de la respiración'),
              isTrue,
              reason: 'missing everyday clarification of respiratory pauses '
                  'in "$alarm" ($band)',
            );
          }
          if (lower.contains('letargo')) {
            expect(
              lower.contains('somnolencia'),
              isTrue,
              reason: 'missing everyday clarification of "letargo" '
                  'in "$alarm" ($band)',
            );
          }
        }
      }
    });
  });

  group('medical disclaimer (RF-3)', () {
    test('disclaimer is present and identical in every band and constant', () {
      final first = guideFor(bands.first)!.medicalDisclaimer;
      expect(first, medicalDisclaimer);
      for (final band in bands) {
        expect(guideFor(band)!.medicalDisclaimer, medicalDisclaimer);
      }
    });
  });

  group('boundaries match the shared 001 definition (CL-3)', () {
    test('guide band for boundary months follows shared ageBandForMonths', () {
      expect(guideFor(ageBandForMonths(0))!.band, AgeBand.newborn0to3);
      expect(guideFor(ageBandForMonths(3))!.band, AgeBand.infant3to12);
      expect(guideFor(ageBandForMonths(12))!.band, AgeBand.toddler12to36);
      expect(guideFor(ageBandForMonths(36))!.band, AgeBand.child36to60);
      expect(guideFor(ageBandForMonths(60))!.band, AgeBand.child36to60);
      expect(guideFor(ageBandForMonths(61)), isNull);
    });
  });
}
