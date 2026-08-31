import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/milestones/development_area.dart';

void main() {
  group('DevelopmentArea — RF-2, RF-3, CL-8', () {
    test('exactly 5 areas in stable order (RF-2, RF-3)', () {
      expect(DevelopmentArea.values, hasLength(5));
      expect(
        DevelopmentArea.values,
        [
          DevelopmentArea.grossMotor,
          DevelopmentArea.fineMotor,
          DevelopmentArea.language,
          DevelopmentArea.socialEmotional,
          DevelopmentArea.cognitive,
        ],
      );
    });

    test('each area has a Spanish label (RF-2)', () {
      for (final area in DevelopmentArea.values) {
        expect(area.label, isNotEmpty);
      }
      expect(DevelopmentArea.grossMotor.label, 'Motricidad gruesa');
      expect(DevelopmentArea.fineMotor.label, 'Motricidad fina');
      expect(DevelopmentArea.language.label, 'Lenguaje');
      expect(DevelopmentArea.socialEmotional.label, 'Social/afectivo');
      expect(DevelopmentArea.cognitive.label, 'Cognitivo');
    });

    test('labels are unique across areas (closed inventory)', () {
      final labels = DevelopmentArea.values.map((a) => a.label).toSet();
      expect(labels, hasLength(DevelopmentArea.values.length));
    });
  });
}
