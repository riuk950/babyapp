import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/breastmilk/breastmilk_section.dart';

void main() {
  group('BreastMilkSection — RF-1, CL-1, CL-8', () {
    test('exactly 4 sections in stable order', () {
      expect(BreastMilkSection.values, hasLength(4));
      expect(BreastMilkSection.values.toSet(), hasLength(4));
      expect(BreastMilkSection.values, [
        BreastMilkSection.extraction,
        BreastMilkSection.storage,
        BreastMilkSection.defrosting,
        BreastMilkSection.hygiene,
      ]);
    });

    test('each section has a Spanish label (RF-1)', () {
      expect(BreastMilkSection.extraction.label, 'Extracción');
      expect(BreastMilkSection.storage.label, 'Almacenamiento');
      expect(BreastMilkSection.defrosting.label, 'Descongelado y uso');
      expect(BreastMilkSection.hygiene.label, 'Higiene y seguridad');
    });

    test('labels are unique across sections', () {
      final labels = BreastMilkSection.values.map((s) => s.label).toList();
      expect(labels.toSet(), hasLength(labels.length));
    });
  });
}
