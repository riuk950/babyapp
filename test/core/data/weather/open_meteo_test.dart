import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/data/weather/open_meteo.dart';

void main() {
  group('WeatherResponseDto.fromJson — RF-2, CL-11', () {
    test('parses the example response to whole tenths', () {
      final json = <String, dynamic>{
        'latitude': 40.41,
        'longitude': -3.70,
        'current': <String, dynamic>{
          'time': '2026-08-28T09:00',
          'temperature_2m': 21.3,
        },
      };
      final reading = WeatherResponseDto.fromJson(json);
      expect(reading, isNotNull);
      expect(reading!.tenths, 213);
    });

    test('boundary values -30 and 50 are valid (CL-11)', () {
      final cold = WeatherResponseDto.fromJson(
        <String, dynamic>{'current': <String, dynamic>{'temperature_2m': -30.0}},
      );
      expect(cold!.tenths, -300);

      final hot = WeatherResponseDto.fromJson(
        <String, dynamic>{'current': <String, dynamic>{'temperature_2m': 50.0}},
      );
      expect(hot!.tenths, 500);
    });

    test('reading outside -30..50 returns null (CL-11)', () {
      expect(
        WeatherResponseDto.fromJson(
          <String, dynamic>{'current': <String, dynamic>{'temperature_2m': 51.0}},
        ),
        isNull,
      );
      expect(
        WeatherResponseDto.fromJson(
          <String, dynamic>{'current': <String, dynamic>{'temperature_2m': -31.0}},
        ),
        isNull,
      );
    });

    test('missing current or temperature_2m returns null', () {
      expect(WeatherResponseDto.fromJson(<String, dynamic>{}), isNull);
      expect(
        WeatherResponseDto.fromJson(<String, dynamic>{'current': <String, dynamic>{}}),
        isNull,
      );
    });
  });
}
