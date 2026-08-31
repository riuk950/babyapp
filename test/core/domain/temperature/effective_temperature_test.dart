import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/models.dart';
import 'package:babyapp/core/domain/temperature/effective_temperature.dart';

void main() {
  group('computeEffectiveTemperature — RF-3, RF-4, RF-9', () {
    test('averages two available sources', () {
      final result = computeEffectiveTemperature(
        manualTenths: 195,
        geo: const TemperatureReading(200),
      );
      expect(result, isNotNull);
      expect(result!.celsius, 20);
      expect(result.source, EffectiveTemperatureSource.average);
      expect(result.notice, isNull);
    });

    test('rounds half-up toward +inf (CL-8)', () {
      // 19.5 -> 20
      expect(
        computeEffectiveTemperature(manualTenths: 195)!.celsius,
        20,
      );
      // -2.4 -> -2
      expect(computeEffectiveTemperature(manualTenths: -24)!.celsius, -2);
      // -2.5 -> -2
      expect(computeEffectiveTemperature(manualTenths: -25)!.celsius, -2);
      // -2.6 -> -3
      expect(computeEffectiveTemperature(manualTenths: -26)!.celsius, -3);
      // 19.4 -> 19
      expect(computeEffectiveTemperature(manualTenths: 194)!.celsius, 19);
    });

    test('manual-only fallback carries geoUnavailable notice (RF-4)', () {
      final result = computeEffectiveTemperature(manualTenths: 200);
      expect(result, isNotNull);
      expect(result!.source, EffectiveTemperatureSource.manualOnly);
      expect(result.notice, NoticeType.geoUnavailable);
    });

    test('geo-only fallback carries manualIgnored notice (RF-4)', () {
      final result = computeEffectiveTemperature(
        geo: const TemperatureReading(210),
      );
      expect(result, isNotNull);
      expect(result!.source, EffectiveTemperatureSource.geoOnly);
      expect(result.notice, NoticeType.manualIgnored);
      expect(result.celsius, 21);
    });

    test('geo outside -30..50 is treated as unavailable (CL-11)', () {
      final result = computeEffectiveTemperature(
        manualTenths: 200,
        geo: const TemperatureReading(-310), // -31 C
      );
      expect(result, isNotNull);
      expect(result!.source, EffectiveTemperatureSource.manualOnly);
      expect(result.notice, NoticeType.geoUnavailable);

      final resultHigh = computeEffectiveTemperature(
        manualTenths: 200,
        geo: const TemperatureReading(510), // 51 C
      );
      expect(resultHigh!.source, EffectiveTemperatureSource.manualOnly);
    });

    test('geo alone out of range behaves as no source', () {
      final result = computeEffectiveTemperature(
        geo: const TemperatureReading(600), // 60 C out of range
      );
      expect(result, isNull);
    });

    test('no source -> null (RF-4)', () {
      expect(computeEffectiveTemperature(), isNull);
    });

    test('deterministic: same input -> same result (RF-9)', () {
      final a = computeEffectiveTemperature(
        manualTenths: 195,
        geo: const TemperatureReading(200),
      );
      final b = computeEffectiveTemperature(
        manualTenths: 195,
        geo: const TemperatureReading(200),
      );
      expect(a!.celsius, b!.celsius);
      expect(a.source, b.source);
      expect(a.notice, b.notice);
    });
  });
}
