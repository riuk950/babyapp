import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/milestones/development_area.dart';
import 'package:babyapp/core/domain/milestones/last_hit_resolver.dart';
import 'package:babyapp/core/domain/milestones/milestone_content.dart';
import 'package:babyapp/core/domain/milestones/milestone_guide.dart';
import 'package:babyapp/core/domain/milestones/milestone_month.dart';

void main() {
  group('last_hit_resolver — RF-2, CL-3, CL-10', () {
    test('area with a new milestone this month shows it (RF-2)', () {
      final resolved = resolveMonth(MilestoneMonth.month1);
      final cognitive = resolved.areas.firstWhere(
          (a) => a.area == DevelopmentArea.cognitive);
      expect(cognitive.isLastHitReference, isFalse);
      expect(cognitive.items, isNotEmpty);
    });

    test('area without new milestone resolves to the last prior hit, marked as '
        'reference (RF-2, CL-3)', () {
      // Month 13 too fine motor has no new milestone; month 12 does.
      final resolved = resolveMonth(MilestoneMonth.month13);
      final fine = resolved.areas
          .firstWhere((a) => a.area == DevelopmentArea.fineMotor);
      expect(fine.isLastHitReference, isTrue);
      expect(fine.items, hasLength(1));
      expect(fine.items.single.text, 'Pasa las páginas de un libro de cartón');
    });

    test('most recent prior month wins (RF-2, CL-3)', () {
      // Month 60 cognitive has its own milestone; month 59 does too, but let's
      // check a gap: month 17 fine has no new milestone,
      // month 16 fine has one -> last fine hit from month 16.
      final resolved = resolveMonth(MilestoneMonth.month17);
      final fine = resolved.areas
          .firstWhere((a) => a.area == DevelopmentArea.fineMotor);
      expect(fine.isLastHitReference, isTrue);
      expect(fine.items.single.text,
          'Quita la tapa de una caja'); // month 16 fine
    });

    test('month 1 never resolves backward (CL-9, RF-2)', () {
      final resolved = resolveMonth(MilestoneMonth.month1);
      expect(resolved.areas, hasLength(DevelopmentArea.values.length));
      for (final area in resolved.areas) {
        expect(area.isLastHitReference, isFalse,
            reason: '${area.area.name} resolved backward on month 1');
        expect(area.items, isNotEmpty);
      }
    });

    test('matching new-milestone months are untouched; resolved months carry '
        'the reference flag only where applicable (CL-3)', () {
      final resolved = resolveMonth(MilestoneMonth.month7);
      // Language has a new milestone at month 7.
      final lang = resolved.areas
          .firstWhere((a) => a.area == DevelopmentArea.language);
      expect(lang.isLastHitReference, isFalse);
      expect(lang.items.map((e) => e.text).toList(),
          ['Balbucea series de sonidos', 'Reacciona a su nombre']);
    });

    test('area with no milestone in any month is omitted (RF-2, CL-10)', () {
      final resolved = resolveMonth(MilestoneMonth.month1,
          provider: _providerWithoutFineMotor());
      expect(resolved.areas.any((a) => a.area == DevelopmentArea.fineMotor),
          isFalse);
      expect(resolved.areas, hasLength(4));
    });

    test('deterministic: repeated resolution equals previous (RF-5)', () {
      final a = resolveMonth(MilestoneMonth.month13);
      final b = resolveMonth(MilestoneMonth.month13);
      expect(a.areas.map((x) => x.items.map((e) => e.text)).toList(),
          b.areas.map((x) => x.items.map((e) => e.text)).toList());
    });
  });
}

// Builds a synthetic content provider where fine motor has no milestone in any
// month, so the resolver must omit that area (RF-2, CL-10).
MonthContentProvider _providerWithoutFineMotor() {
  return (month) {
    if (month == null) return null;
    final areas = <AreaMilestones>[
      for (final area in DevelopmentArea.values)
        if (area != DevelopmentArea.fineMotor)
          AreaMilestones(
            area: area,
            label: area.label,
            newMilestones: const ['Hito de prueba'],
            alarmSigns: const ['Alarma de prueba'],
          ),
    ];
    return MonthContent(
      month: month,
      label: month.ageLabel,
      areas: areas,
      medicalDisclaimer: medicalDisclaimer,
    );
  };
}
