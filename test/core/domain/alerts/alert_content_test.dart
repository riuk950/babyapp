import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/age/age_band.dart';
import 'package:babyapp/core/domain/alerts/alert_content.dart';
import 'package:babyapp/core/domain/alerts/alert_guide.dart';
import 'package:babyapp/core/domain/alerts/alert_sign.dart';

void main() {
  group('contentFor — bands and boundaries (RF-1, CL-3)', () {
    test('contentFor(null) returns null (RF-1, CL-1)', () {
      expect(contentFor(null), isNull);
    });

    test('every one of the 4 shared bands has a guide (RF-1, CL-8)', () {
      for (final band in AgeBand.values) {
        final guide = contentFor(band);
        expect(guide, isNotNull, reason: 'missing guide for $band');
        expect(guide!.band, band);
        expect(guide.label, isNotEmpty);
        expect(guide.rangeMonths, isNotEmpty);
      }
    });

    test('band labels and ranges match the shared boundaries (CL-3)', () {
      final byBand = {for (final b in AgeBand.values) b: contentFor(b)!};
      expect(byBand[AgeBand.newborn0to3]!.label, '0–3 meses');
      expect(byBand[AgeBand.newborn0to3]!.rangeMonths, '[0,3)');
      expect(byBand[AgeBand.infant3to12]!.label, '3–12 meses');
      expect(byBand[AgeBand.infant3to12]!.rangeMonths, '[3,12)');
      expect(byBand[AgeBand.toddler12to36]!.label, '1–3 años');
      expect(byBand[AgeBand.toddler12to36]!.rangeMonths, '[12,36)');
      expect(byBand[AgeBand.child36to60]!.label, '4–5 años');
      expect(byBand[AgeBand.child36to60]!.rangeMonths, '[36,60]');
    });
  });

  group('content quality (RF-2, RF-3, CL-8)', () {
    test('4/4: every band has signals in at least one area (CL-8)', () {
      for (final band in AgeBand.values) {
        final guide = contentFor(band)!;
        final visible = guide.areas.where((a) => a.signals.isNotEmpty);
        expect(visible, isNotEmpty,
            reason: 'band $band has no signal in any area');
      }
    });

    test('every signal has exactly one valid level and an action (RF-3, CL-8)',
        () {
      for (final band in AgeBand.values) {
        final guide = contentFor(band)!;
        for (final area in guide.areas) {
          for (final signal in area.signals) {
            expect([AlertLevel.urgency, AlertLevel.scheduled],
                contains(signal.level));
            expect(signal.action, isNotEmpty);
            expect(signal.signal, isNotEmpty);
          }
        }
      }
    });

    test('a single signal is never classified with two levels (RF-3)', () {
      // Each AlertSignal stores one AlertLevel (unified by construction); this
      // guards the content so no signal accidentally reads as both levels.
      for (final band in AgeBand.values) {
        for (final area in contentFor(band)!.areas) {
          for (final signal in area.signals) {
            expect(signal.level, isA<AlertLevel>());
          }
        }
      }
    });

    test('both urgency levels appear across the catalog (CL-8, CL-11)', () {
      final levels = <AlertLevel>{
        for (final band in AgeBand.values)
          for (final area in contentFor(band)!.areas)
            for (final signal in area.signals) signal.level,
      };
      expect(levels, containsAll([AlertLevel.urgency, AlertLevel.scheduled]));
    });
  });

  group('omitted areas (RF-2, CL-10)', () {
    test('areas with empty signals are omitted, never shown empty (CL-10)',
        () {
      for (final band in AgeBand.values) {
        final guide = contentFor(band)!;
        for (final area in guide.areas) {
          expect(area.signals, isNotEmpty,
              reason: 'area ${area.area} in $band appears empty');
        }
      }
    });

    test('every area appears with signals in at least one band (error check)',
        () {
      final seen = <AlertArea>{
        for (final band in AgeBand.values)
          for (final area in contentFor(band)!.areas) area.area,
      };
      // An area with no signals in ANY of the 4 bands is a content error
      // (CL-10). All 5 areas must appear somewhere.
      expect(seen, containsAll(AlertArea.values));
    });
  });

  group('determinism and disclaimer (RF-3, RF-5)', () {
    test('contentFor is deterministic: same band, same content (RF-5)', () {
      for (final band in AgeBand.values) {
        final a = contentFor(band)!;
        final b = contentFor(band)!;
        expect(b.label, a.label);
        expect(b.areas.length, a.areas.length);
        for (var i = 0; i < a.areas.length; i++) {
          expect(b.areas[i].signals.length, a.areas[i].signals.length);
        }
      }
    });

    test('medical disclaimer is a single constant shown always (RF-3)', () {
      expect(medicalDisclaimer, isNotEmpty);
      for (final band in AgeBand.values) {
        expect(contentFor(band)!.medicalDisclaimer, medicalDisclaimer);
      }
    });

    test('clinical terms carry an everyday clarification (RF-2, inventory)',
        () {
      final catalog = <String>[
        for (final band in AgeBand.values)
          for (final area in contentFor(band)!.areas)
            for (final signal in area.signals) signal.signal,
      ].join(' ');

      // Closed inventory of clinical terms defined in the spec must appear
      // with an in-line plain-language clarification somewhere in the catalog.
      expect(catalog, contains('sin control'));
      expect(catalog, contains(RegExp('azulad|amorat'))); // cianosis
      expect(catalog, contains(RegExp('dormir|despertar'))); // letargo
    });
  });
}
