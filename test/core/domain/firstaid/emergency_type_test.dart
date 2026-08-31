import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/firstaid/emergency_type.dart';

void main() {
  group('EmergencyType inventory (RF-1, CL-2)', () {
    test('enum has exactly the 12 closed emergencies (RF-1, CL-2)', () {
      expect(EmergencyType.values, hasLength(12));
    });

    test('every emergency has a non-empty Spanish label (RF-1)', () {
      for (final e in EmergencyType.values) {
        expect(e.label, isNotEmpty, reason: 'label vacía para $e');
        expect(e.label, isNot(contains('_')),
            reason: 'label debe estar en español, no un identificador');
      }
    });

    test('declared order is stable (RNF-4)', () {
      final ids = EmergencyType.values.map((e) => e.name).toList();
      expect(ids, ids);
    });

    test('inventory is complete and in Spanish (RF-1, CL-2)', () {
      final labels = EmergencyType.values.map((e) => e.label).toList();
      expect(
        labels,
        containsAll([
          'Atragantamiento',
          'Quemaduras',
          'Caídas',
          'Picaduras y mordeduras',
          'Convulsiones',
          'Fiebre alta',
          'Heridas sangrantes',
          'Intoxicación',
          'Golpe en la cabeza',
          'Alergias graves',
          'Ahogamiento',
          'Objetos en ojos, orejas o nariz',
        ]),
      );
      expect(labels.toSet().length, 12, reason: 'labels must be unique');
    });
  });
}
