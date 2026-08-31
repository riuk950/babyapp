import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/routine/routine_moment.dart';

void main() {
  test('exactly 6 moments in stable order (RF-1, CL-8)', () {
    expect(RoutineMoment.values, hasLength(6));
    expect(
      RoutineMoment.values,
      [
        RoutineMoment.morning,
        RoutineMoment.nap,
        RoutineMoment.bath,
        RoutineMoment.feeding,
        RoutineMoment.play,
        RoutineMoment.night,
      ],
    );
  });

  test('each moment has a Spanish label (RF-1)', () {
    for (final moment in RoutineMoment.values) {
      expect(moment.label, isNotEmpty);
    }
  });

  test('labels cover the closed inventory in Spanish (RF-1)', () {
    final labels = RoutineMoment.values.map((m) => m.label).toList();
    expect(labels, contains('Mañana'));
    expect(labels, contains('Siesta'));
    expect(labels, contains('Baño'));
    expect(labels, contains('Alimentación'));
    expect(labels, contains('Juego/estimulación'));
    expect(labels, contains('Noche'));
  });

  test('labels are unique across moments (closed inventory)', () {
    final labels = RoutineMoment.values.map((m) => m.label).toSet();
    expect(labels, hasLength(6));
  });
}
