import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/breastmilk/breastmilk_content.dart';
import 'package:babyapp/core/domain/breastmilk/breastmilk_section.dart';

void main() {
  const sections = BreastMilkSection.values;

  group('contentFor — RF-1, RF-5', () {
    test('no section -> null (RF-1)', () {
      expect(contentFor(null), isNull);
    });

    test('each section has content (4/4 coverage, CL-7)', () {
      for (final s in sections) {
        expect(contentFor(s), isNotNull, reason: 'missing content for $s');
      }
    });

    test('deterministic: same section always returns same content (RF-5)', () {
      for (final s in sections) {
        final a = contentFor(s)!;
        final b = contentFor(s)!;
        expect(b.bestPractices, a.bestPractices);
        expect(b.highlights, a.highlights);
        expect(b.storageTimeRows.length, a.storageTimeRows.length);
        expect(b.medicalDisclaimer, a.medicalDisclaimer);
      }
    });
  });

  group('content completeness 4/4 (CL-7, RF-2)', () {
    test('every section has non-empty bestPractices and disclaimer', () {
      for (final s in sections) {
        final content = contentFor(s)!;
        expect(content.section, s);
        expect(content.label, isNotEmpty);
        expect(content.bestPractices, isNotEmpty,
            reason: '$s missing best practices');
        expect(content.medicalDisclaimer, isNotEmpty,
            reason: '$s missing disclaimer');
      }
    });

    test('highlights and storageTimeRows empty ONLY in extraction (RF-3)', () {
      for (final s in sections) {
        final content = contentFor(s)!;
        if (s == BreastMilkSection.extraction) {
          expect(content.highlights, isEmpty,
              reason: 'extraction must have no highlighted blocks (RF-3)');
          expect(content.storageTimeRows, isEmpty,
              reason: 'extraction must have no storage times (RF-3)');
        } else {
          expect(content.highlights, isNotEmpty,
              reason: '$s must have a highlighted block (RF-3)');
        }
      }
    });
  });

  group('storage time table (RF-3, CL-9)', () {
    test('table is unique to storage with 5 rows', () {
      final storage = contentFor(BreastMilkSection.storage)!;
      expect(storage.storageTimeRows, hasLength(5));

      for (final s in sections) {
        if (s != BreastMilkSection.storage) {
          expect(contentFor(s)!.storageTimeRows, isEmpty,
              reason: '$s must not duplicate the storage table');
        }
      }
    });

    test('rows match the recommended table without "acceptable" limits', () {
      final rows = contentFor(BreastMilkSection.storage)!.storageTimeRows;
      expect(rows[0].place, 'Ambiente');
      expect(rows[0].duration, 'hasta 4 h');
      expect(rows[1].place, 'Nevera');
      expect(rows[1].duration, 'hasta 4 días');
      expect(rows[2].place, 'Congelador');
      expect(rows[2].duration, '6 meses');
      expect(rows[3].place, 'Descongelada en nevera');
      expect(rows[4].place, 'Descongelada a temperatura ambiente');

      // Only recommended values; internal acceptable limits are not shown.
      for (final row in rows) {
        expect(row.duration, isNot(contains('8 días')));
        expect(row.duration, isNot(contains('12 meses')));
      }
      final allText = rows.map((r) => '${r.place} ${r.duration}').join(' ');
      expect(allText, isNot(contains('aceptable')));
    });

    test('every row has place, temp and duration', () {
      for (final row in contentFor(BreastMilkSection.storage)!.storageTimeRows) {
        expect(row.place, isNotEmpty);
        expect(row.temp, isNotEmpty);
        expect(row.duration, isNotEmpty);
      }
    });
  });

  group('closed term inventory (RF-2)', () {
    test('BPA always carries its everyday clarification', () {
      const clarification = 'sustancia usada en algunos plásticos';
      for (final s in sections) {
        final content = contentFor(s)!;
        final all =
            content.bestPractices.join(' ').toLowerCase();
        if (all.contains('bpa')) {
          expect(
            (content.bestPractices.join(' ')).toLowerCase(),
            contains(clarification),
            reason: 'BPA without clarification in $s',
          );
        }
      }
    });
  });

  group('medical disclaimer (RF-3)', () {
    test('disclaimer is present and identical in every section + constant', () {
      final first = contentFor(sections.first)!.medicalDisclaimer;
      expect(first, medicalDisclaimer);
      for (final s in sections) {
        expect(contentFor(s)!.medicalDisclaimer, medicalDisclaimer);
      }
    });
  });
}
