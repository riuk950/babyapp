import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/milestones/development_area.dart';
import 'package:babyapp/core/domain/milestones/milestone_content.dart';
import 'package:babyapp/core/domain/milestones/milestone_month.dart';

void main() {
  group('milestone_content — RF-1, RF-2, RF-3, RF-5, CL-8, CL-9', () {
    test('contentFor(null) returns null (RF-1, CL-1)', () {
      expect(contentFor(null), isNull);
    });

    test('60/60 coverage: every month has its 5 defined areas (CL-8)', () {
      for (final month in MilestoneMonth.values) {
        final content = contentFor(month);
        expect(content, isNotNull, reason: 'month ${month.number} missing');
        expect(content!.areas, hasLength(5),
            reason: 'month ${month.number} area count');
        for (final area in content.areas) {
          expect(area.label, isNotEmpty,
              reason: 'month ${month.number} ${area.area.name} label');
        }
      }
    });

    test('alarm signs are defined per area (not a general block) (RF-3, CL-8)',
        () {
      // Alarm sign data lives per area within each month (RF-3).
      for (final month in MilestoneMonth.values) {
        for (final area in contentFor(month)!.areas) {
          expect(area.alarmSigns, isNotNull);
        }
      }
      // Every area surfaces alarm signs in at least one month across the guide.
      for (final area in DevelopmentArea.values) {
        final anyAlarm = MilestoneMonth.values.any((m) =>
            contentFor(m)!.areas.any((a) =>
                a.area == area && a.alarmSigns.isNotEmpty));
        expect(anyAlarm, isTrue, reason: '${area.name} has no alarm anywhere');
      }
    });

    test('month 1 has new milestones in all 5 areas (CL-9, RF-2)', () {
      final content = contentFor(MilestoneMonth.month1)!;
      for (final area in content.areas) {
        expect(area.newMilestones, isNotEmpty,
            reason: 'month 1 ${area.area.name} has no new milestone');
      }
    });

    test('every month has at least one new milestone in some area (CL-8, RF-2)',
        () {
      for (final month in MilestoneMonth.values) {
        final content = contentFor(month)!;
        final anyNew = content.areas.any((a) => a.newMilestones.isNotEmpty);
        expect(anyNew, isTrue,
            reason: 'month ${month.number} has no new milestone at all');
      }
    });

    test('every month labels match its interval (RF-1)', () {
      for (final month in MilestoneMonth.values) {
        final content = contentFor(month)!;
        expect(content.label, month.ageLabel);
      }
    });

    test('medical disclaimer is present and identical in every month (RF-3)',
        () {
      expect(medicalDisclaimer, isNotEmpty);
      for (final month in MilestoneMonth.values) {
        expect(contentFor(month)!.medicalDisclaimer, medicalDisclaimer);
      }
    });

    test('clinical terms carry a plain-language clarification (RF-2, closed '
        'inventory)', () {
      // balbuceo explained as "sonidos sin sentido, primer paso hacia el habla"
      expect(
        _contains(contentFor(MilestoneMonth.month6)!, 'hace sonidos sin sentido'),
        isTrue,
      );
      // separación ansiosa explained in everyday Spanish before the term
      expect(
        _contains(contentFor(MilestoneMonth.month12)!,
            'se angustia si te alejas (separación ansiosa)'),
        isTrue,
      );
      // ansiedad ante extraños explained before the term
      expect(
        _contains(contentFor(MilestoneMonth.month9)!,
            'miedo a personas desconocidas (ansiedad ante extraños)'),
        isTrue,
      );
      // juego funcional explained with a concrete example
      expect(
        _contains(contentFor(MilestoneMonth.month18)!,
            'usar un objeto para su propósito'),
        isTrue,
      );
    });

    test('deterministic: same month always returns same content (RF-5)', () {
      for (final month in MilestoneMonth.values) {
        final a = contentFor(month)!;
        final b = contentFor(month)!;
        expect(identical(a, b), isTrue);
        expect(a.areas.map((x) => x.newMilestones).toList(),
            b.areas.map((x) => x.newMilestones).toList());
      }
    });
  });
}

bool _contains(Object content, String phrase) {
  final normalized = phrase.toLowerCase();
  for (final area in (content as dynamic).areas) {
    for (final m in area.newMilestones) {
      if (m.toLowerCase().contains(normalized)) return true;
    }
    for (final a in area.alarmSigns) {
      if (a.toLowerCase().contains(normalized)) return true;
    }
  }
  return false;
}
