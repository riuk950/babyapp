import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:babyapp/core/domain/contracts/weather_repository.dart';
import 'package:babyapp/core/domain/entities/geo.dart';
import 'package:babyapp/core/domain/failures/failures.dart';
import 'package:babyapp/core/domain/models.dart';
import 'package:babyapp/features/clothing/presentation/clothing_controller.dart';

class _FakeWeatherRepository implements WeatherRepository {
  GeoTemperatureResult? result;
  Completer<GeoTemperatureResult>? completer;
  int calls = 0;

  @override
  Future<GeoTemperatureResult> fetchCurrentTemperature() {
    calls++;
    final c = completer;
    if (c != null) return c.future;
    return Future.value(result);
  }
}

void main() {
  late _FakeWeatherRepository repo;
  late ClothingController controller;

  setUp(() {
    repo = _FakeWeatherRepository();
    controller = ClothingController(weatherRepository: repo);
  });

  tearDown(() => controller.dispose());

  group('ClothingController — RF-1(wiring), RF-5, RF-6, CL-10, CL-12', () {
    test('manual input is parsed and used (RF-1 wiring)', () {
      controller.setManualTemperature('20');
      expect(controller.manualTenths, 200);
      expect(controller.manualError, isNull);
      expect(controller.effective, isNotNull);
      expect(controller.effective!.celsius, 20);
      expect(controller.effective!.source, EffectiveTemperatureSource.manualOnly);
    });

    test('invalid manual input produces a typed error (RF-1)', () {
      controller.setManualTemperature('abc');
      expect(controller.manualTenths, isNull);
      expect(controller.manualError, ManualInputFailure.notNumeric);
      expect(controller.effective, isNull);
    });

    test('no age band -> no recommendation even with effective temp (RF-6)', () {
      controller.setManualTemperature('20');
      expect(controller.effective, isNotNull);
      expect(controller.recommendation, isNull);
    });

    test('changing age band re-evaluates the recommendation (CL-10)', () {
      controller.setManualTemperature('20');
      controller.setAgeBand(AgeBand.toddler12to36);
      final first = controller.recommendation;
      expect(first, isNotEmpty);

      controller.setManualTemperature('-5');
      controller.setAgeBand(AgeBand.toddler12to36);
      final base = controller.recommendation;

      controller.setAgeBand(AgeBand.newborn0to3);
      expect(controller.recommendation, isNot(base));
      expect(controller.recommendation, contains('1 capa'));
    });

    test('late geo updates the effective temperature (RF-5)', () async {
      controller.setManualTemperature('19.5');
      repo.completer = Completer<GeoTemperatureResult>();
      final pending = controller.fetchGeo();

      expect(controller.isGeoLoading, isTrue);
      expect(controller.effective!.source, EffectiveTemperatureSource.manualOnly);

      repo.completer!.complete(const GeoTemperatureSuccess(TemperatureReading(200)));
      await pending;

      expect(controller.isGeoLoading, isFalse);
      expect(controller.effective, isNotNull);
      expect(controller.effective!.source, EffectiveTemperatureSource.average);
      expect(controller.effective!.celsius, 20);
    });

    test('shows loading state while geo loads (RF-5)', () async {
      repo.completer = Completer<GeoTemperatureResult>();
      final pending = controller.fetchGeo();
      expect(controller.isGeoLoading, isTrue);
      repo.completer!.complete(const GeoTemperatureSuccess(TemperatureReading(200)));
      await pending;
      expect(controller.isGeoLoading, isFalse);
    });

    test('geo failure falls back to manual with geoUnavailable notice (RF-4)', () async {
      controller.setManualTemperature('20');
      repo.result = const GeoTemperatureFailure(GeoFailure.timeout);
      await controller.fetchGeo();
      expect(controller.effective!.source, EffectiveTemperatureSource.manualOnly);
      expect(controller.notice, NoticeType.geoUnavailable);
    });

    test('retries geo on resume when it previously failed (CL-12, RF-2)', () async {
      repo.result = const GeoTemperatureFailure(GeoFailure.permissionDenied);
      await controller.fetchGeo();
      expect(repo.calls, 1);
      expect(controller.effective, isNull);

      repo.result = const GeoTemperatureSuccess(TemperatureReading(200));
      controller.onResume();
      await pumpEventQueue();
      expect(repo.calls, 2);
      expect(controller.effective, isNotNull);
    });

    test('does not retry on resume when geo already succeeded (RF-2)', () async {
      repo.result = const GeoTemperatureSuccess(TemperatureReading(200));
      await controller.fetchGeo();
      final callsAfterSuccess = repo.calls;
      controller.onResume();
      await pumpEventQueue();
      expect(repo.calls, callsAfterSuccess);
    });
  });
}
