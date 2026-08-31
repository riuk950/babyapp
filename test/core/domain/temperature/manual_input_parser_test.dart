import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/models.dart';
import 'package:babyapp/core/domain/temperature/manual_input_parser.dart';

void main() {
  group('ManualInputParser — RF-1, CL-1, CL-4', () {
    test('accepts exact -30 and 50 inclusive (CL-1)', () {
      expect(parseManualTemperature('-30'), isA<ManualInputSuccess>());
      expect(parseManualTemperature('50'), isA<ManualInputSuccess>());
      expect(
        (parseManualTemperature('-30') as ManualInputSuccess).tenths,
        -300,
      );
      expect(
        (parseManualTemperature('50') as ManualInputSuccess).tenths,
        500,
      );
    });

    test('returns tenths (whole tenths of a degree)', () {
      expect(
        (parseManualTemperature('19.5') as ManualInputSuccess).tenths,
        195,
      );
      expect((parseManualTemperature('0') as ManualInputSuccess).tenths, 0);
      expect(
        (parseManualTemperature('21.3') as ManualInputSuccess).tenths,
        213,
      );
    });

    test('accepts comma or dot as decimal separator', () {
      expect(
        (parseManualTemperature('19,5') as ManualInputSuccess).tenths,
        195,
      );
      expect(
        (parseManualTemperature('19.5') as ManualInputSuccess).tenths,
        195,
      );
    });

    test('accepts optional sign and ignores surrounding spaces', () {
      expect(
        (parseManualTemperature('+5') as ManualInputSuccess).tenths,
        50,
      );
      expect((parseManualTemperature('-5') as ManualInputSuccess).tenths, -50);
      expect(
        (parseManualTemperature('  19.5  ') as ManualInputSuccess).tenths,
        195,
      );
    });

    test('rejects empty and only-whitespace input (CL-4)', () {
      expect(parseManualTemperature(''), isA<ManualInputError>());
      expect(
        (parseManualTemperature('') as ManualInputError).failure,
        ManualInputFailure.empty,
      );
      expect(parseManualTemperature('   '), isA<ManualInputError>());
      expect(
        (parseManualTemperature('   ') as ManualInputError).failure,
        ManualInputFailure.empty,
      );
    });

    test('rejects non-numeric input', () {
      expect(parseManualTemperature('abc'), isA<ManualInputError>());
      expect(
        (parseManualTemperature('abc') as ManualInputError).failure,
        ManualInputFailure.notNumeric,
      );
      expect(parseManualTemperature('12a'), isA<ManualInputError>());
      expect(parseManualTemperature('--5'), isA<ManualInputError>());
    });

    test('rejects more than one decimal digit', () {
      expect(parseManualTemperature('19.55'), isA<ManualInputError>());
      expect(
        (parseManualTemperature('19.55') as ManualInputError).failure,
        ManualInputFailure.tooManyDecimals,
      );
      expect(parseManualTemperature('3,1415'), isA<ManualInputError>());
      expect(
        (parseManualTemperature('3,1415') as ManualInputError).failure,
        ManualInputFailure.tooManyDecimals,
      );
    });

    test('rejects out-of-range input', () {
      expect(parseManualTemperature('-31'), isA<ManualInputError>());
      expect(
        (parseManualTemperature('-31') as ManualInputError).failure,
        ManualInputFailure.outOfRange,
      );
      expect(parseManualTemperature('51'), isA<ManualInputError>());
      expect(
        (parseManualTemperature('51') as ManualInputError).failure,
        ManualInputFailure.outOfRange,
      );
    });
  });
}
