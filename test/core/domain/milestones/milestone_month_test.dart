import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/milestones/milestone_month.dart';

void main() {
  group('MilestoneMonth — RF-1, CL-8, CL-11', () {
    test('30 months from 1..60 in stable ascending order (RF-1, CL-8)', () {
      expect(MilestoneMonth.values, hasLength(60));
      expect(MilestoneMonth.values.first.number, 1);
      expect(MilestoneMonth.values.last.number, 60);
      for (var i = 0; i < MilestoneMonth.values.length; i++) {
        expect(MilestoneMonth.values[i].number, i + 1);
      }
    });

    test('month 1 has the base-case age label (CL-9)', () {
      expect(MilestoneMonth.values.first.ageLabel, 'Nacimiento a 1 mes');
    });

    test('month 60 has the correct ending label (CL-11)', () {
      expect(MilestoneMonth.values.last.ageLabel, '59 a 60 meses');
    });

    test('intermediate month label is the covered interval (RF-1)', () {
      // Month 7 covers 6 to 7 months.
      expect(MilestoneMonth.forNumber(7)!.ageLabel, '6 a 7 meses');
    });

    test('no value is out of 1..60 range (CL-11, closed enum)', () {
      for (final month in MilestoneMonth.values) {
        expect(month.number, inInclusiveRange(1, 60));
      }
    });

    test('duplicates are impossible: numbers are unique and 60/60 (RF-5)', () {
      final numbers = MilestoneMonth.values.map((m) => m.number).toSet();
      expect(numbers, hasLength(60));
    });
  });
}
