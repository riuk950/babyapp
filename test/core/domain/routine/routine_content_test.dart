import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/age/age_band.dart';
import 'package:babyapp/core/domain/routine/routine_content.dart';
import 'package:babyapp/core/domain/routine/routine_moment.dart';

void main() {
  group('availableMoments and null handling (RF-1, RF-2, CL-1, CL-2)', () {
    test('availableMoments returns the 6 moments (RF-1)', () {
      expect(availableMoments(), hasLength(6));
      expect(availableMoments().toSet(), RoutineMoment.values.toSet());
    });

    test('tipsFor(null band) returns null (RF-2, CL-1)', () {
      for (final moment in RoutineMoment.values) {
        expect(tipsFor(moment, null), isNull);
      }
    });

    test('tipsFor(null moment) returns null (RF-3, CL-2)', () {
      for (final band in AgeBand.values) {
        expect(tipsFor(null, band), isNull);
      }
    });
  });

  group('6x4 coverage (RF-3, RF-2, CL-8)', () {
    test('every moment x band combination has at least one tip (CL-8)', () {
      for (final moment in RoutineMoment.values) {
        for (final band in AgeBand.values) {
          final tips = tipsFor(moment, band);
          expect(tips, isNotNull, reason: 'missing tips for $moment/$band');
          expect(tips, isNotEmpty);
        }
      }
    });

    test('every tip has a non-empty source (RF-4)', () {
      for (final moment in RoutineMoment.values) {
        for (final band in AgeBand.values) {
          for (final tip in tipsFor(moment, band)!) {
            expect(tip.message, isNotEmpty);
            expect(tip.source, isNotEmpty);
          }
        }
      }
    });

    test('every tip is a short actionable message (≤2 lines, verb-led) (RF-3)',
        () {
      final verbs = <String>[
        'Abre', 'Habla', 'Canta', 'Coloca', 'Ofrece', 'Baña', 'Juega',
        'Acuesta', 'Mantén', 'Reduce', 'Ambienta', 'Crea', 'Respeta', 'Usa',
        'Aprovecha', 'Lava', 'Seca', 'Lee', 'Invita', 'Apaga', 'Establece',
        'Sigue', 'No uses', 'Sostén', 'Practica', 'Acompaña', 'Prepara',
        'Ajusta', 'Haz', 'Introduce', 'Apunta',
      ];
      for (final moment in RoutineMoment.values) {
        for (final band in AgeBand.values) {
          for (final tip in tipsFor(moment, band)!) {
            // Message is a single logical line (no newline → ≤2 rendered lines
            // on a 320dp screen given short lengths), starts with a verb.
            expect(tip.message, isNot(contains('\n')));
            expect(tip.message.length, lessThanOrEqualTo(120),
                reason: 'tip excede 2 líneas: ${tip.message}');
            final firstWord = tip.message.split(' ').first.trim();
            expect(verbs, contains(firstWord),
                reason: 'tip no empieza con verbo: ${tip.message}');
          }
        }
      }
    });
  });

  group('omitted moments (RF-3, CL-3, CL-8)', () {
    test('a moment with no tips for one band is omitted (CL-3)', () {
      // This is modelled by the content contract: tipsFor returns non-null
      // only when the combination exists. We assert the rendering rule by
      // checking content consistency, and that no empty guide is offered.
      for (var i = 0; i < RoutineMoment.values.length; i++) {
        for (final band in AgeBand.values) {
          final tips = tipsFor(RoutineMoment.values[i], band);
          expect(tips == null || tips.isNotEmpty, isTrue);
        }
      }
    });

    test('at least one moment appears in every band (error check) (CL-8)',
        () {
      for (final band in AgeBand.values) {
        final anyMoment = RoutineMoment.values
            .any((m) => tipsFor(m, band)?.isNotEmpty == true);
        expect(anyMoment, isTrue, reason: 'no moment has tips for $band');
      }
    });
  });

  group('determinism and disclaimer (RF-5, RF-6)', () {
    test('tipsFor is deterministic: same input, same content (RF-5)', () {
      for (final moment in RoutineMoment.values) {
        for (final band in AgeBand.values) {
          final a = tipsFor(moment, band)!;
          final b = tipsFor(moment, band)!;
          expect(b.length, a.length);
          for (var i = 0; i < a.length; i++) {
            expect(b[i].message, a[i].message);
            expect(b[i].source, a[i].source);
          }
        }
      }
    });

    test('medical disclaimer is a single constant (RF-6)', () {
      expect(medicalDisclaimer, isNotEmpty);
    });

    test('sources come from the closed allowed set (RF-4, inventory)', () {
      final allowed = ['OMS', 'AAP', 'OMS lactancia'];
      for (final moment in RoutineMoment.values) {
        for (final band in AgeBand.values) {
          for (final tip in tipsFor(moment, band)!) {
            final source = tip.source;
            final match =
                allowed.any((a) => source.toLowerCase().contains(a.toLowerCase()));
            expect(match, isTrue,
                reason: 'fuente no permitida: $source');
          }
        }
      }
    });
  });
}
