import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/data/weather/open_meteo.dart';
import 'package:babyapp/core/data/weather/weather_repository_impl.dart';
import 'package:babyapp/core/domain/contracts/geo_repository.dart';
import 'package:babyapp/core/domain/entities/geo.dart';
import 'package:babyapp/core/domain/failures/failures.dart';
import 'package:babyapp/core/domain/models.dart';

class _FakeGeo implements GeoRepository {
  _FakeGeo({this.error});
  final Object? error;

  @override
  Future<GeoPosition> getCurrentPosition() async {
    if (error != null) throw error!;
    return const GeoPosition(latitude: 40.41, longitude: -3.70);
  }
}

class _FakeApi implements WeatherApi {
  _FakeApi(this.result);
  final GeoTemperatureResult result;

  @override
  Future<GeoTemperatureResult> fetchTemperature(GeoPosition position) async {
    return result;
  }
}

void main() {
  group('WeatherRepositoryImpl — RF-2, RF-4, RNF-6', () {
    test('geo ok + api ok returns the geotemperature in range', () async {
      final repo = WeatherRepositoryImpl(
        geoRepository: _FakeGeo(),
        api: _FakeApi(const GeoTemperatureSuccess(TemperatureReading(213))),
      );
      final result = await repo.fetchCurrentTemperature();
      expect(result, isA<GeoTemperatureSuccess>());
      expect((result as GeoTemperatureSuccess).reading.tenths, 213);
    });

    test('geo permission denied -> permissionDenied failure', () async {
      final repo = WeatherRepositoryImpl(
        geoRepository: _FakeGeo(
          error: const GeoRepositoryException(GeoFailure.permissionDenied),
        ),
        api: _FakeApi(const GeoTemperatureSuccess(TemperatureReading(213))),
      );
      final result = await repo.fetchCurrentTemperature();
      expect(result, isA<GeoTemperatureFailure>());
      expect(
        (result as GeoTemperatureFailure).failure,
        GeoFailure.permissionDenied,
      );
    });

    test('geo no service -> noService failure', () async {
      final repo = WeatherRepositoryImpl(
        geoRepository: _FakeGeo(
          error: const GeoRepositoryException(GeoFailure.noService),
        ),
        api: _FakeApi(const GeoTemperatureSuccess(TemperatureReading(213))),
      );
      final result = await repo.fetchCurrentTemperature();
      expect(result, isA<GeoTemperatureFailure>());
      expect((result as GeoTemperatureFailure).failure, GeoFailure.noService);
    });

    test('api network failure -> timeout failure', () async {
      final repo = WeatherRepositoryImpl(
        geoRepository: _FakeGeo(),
        api: _FakeApi(const GeoTemperatureFailure(GeoFailure.timeout)),
      );
      final result = await repo.fetchCurrentTemperature();
      expect(result, isA<GeoTemperatureFailure>());
      expect((result as GeoTemperatureFailure).failure, GeoFailure.timeout);
    });

    test('api service failure -> service failure', () async {
      final repo = WeatherRepositoryImpl(
        geoRepository: _FakeGeo(),
        api: _FakeApi(const GeoTemperatureFailure(GeoFailure.noService)),
      );
      final result = await repo.fetchCurrentTemperature();
      expect(result, isA<GeoTemperatureFailure>());
      expect((result as GeoTemperatureFailure).failure, GeoFailure.noService);
    });

    test('api invalid data -> invalidData failure', () async {
      final repo = WeatherRepositoryImpl(
        geoRepository: _FakeGeo(),
        api: _FakeApi(const GeoTemperatureFailure(GeoFailure.invalidData)),
      );
      final result = await repo.fetchCurrentTemperature();
      expect(result, isA<GeoTemperatureFailure>());
      expect((result as GeoTemperatureFailure).failure, GeoFailure.invalidData);
    });
  });
}
