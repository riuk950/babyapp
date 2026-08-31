import 'package:flutter/foundation.dart';

import '../../../core/domain/clothing/recommendation_table.dart';
import '../../../core/domain/contracts/weather_repository.dart';
import '../../../core/domain/entities/geo.dart';
import '../../../core/domain/models.dart';
import '../../../core/domain/temperature/effective_temperature.dart';
import '../../../core/domain/temperature/extreme_threshold.dart';
import '../../../core/domain/temperature/manual_input_parser.dart';

/// Presentation controller that owns the transient (ephemeral) state of the
/// clothing screen (RF-1..RF-8, §5). It delegates to pure domain logic and,
/// for geo, to the [WeatherRepository]. No persistence is performed.
class ClothingController extends ChangeNotifier {
  ClothingController({required WeatherRepository weatherRepository})
      : _repository = weatherRepository;

  final WeatherRepository _repository;

  int? _manualTenths;
  ManualInputFailure? _manualError;
  TemperatureReading? _geoReading;
  AgeBand? _ageBand;
  bool _isGeoLoading = false;
  bool _geoSucceeded = false;

  EffectiveTemperature? effective;
  String? recommendation;
  ExtremeLevel extreme = ExtremeLevel.none;
  NoticeType? notice;

  int? get manualTenths => _manualTenths;
  ManualInputFailure? get manualError => _manualError;
  AgeBand? get ageBand => _ageBand;
  bool get isGeoLoading => _isGeoLoading;

  void setManualTemperature(String input) {
    final result = parseManualTemperature(input);
    switch (result) {
      case ManualInputSuccess(:final tenths):
        _manualTenths = tenths;
        _manualError = null;
      case ManualInputError(:final failure):
        _manualTenths = null;
        _manualError = failure;
    }
    _recompute();
  }

  void setAgeBand(AgeBand? band) {
    _ageBand = band;
    _recompute();
  }

  /// Requests the ambient temperature by geolocation (RF-2). Updates the
  /// effective temperature when it arrives (RF-5).
  Future<void> fetchGeo() async {
    if (_isGeoLoading) return;
    _isGeoLoading = true;
    _recompute();

    final result = await _repository.fetchCurrentTemperature();

    _isGeoLoading = false;
    switch (result) {
      case GeoTemperatureSuccess(:final reading):
        _geoReading = reading;
        _geoSucceeded = true;
      case GeoTemperatureFailure():
        _geoReading = null;
    }
    _recompute();
  }

  /// Called when the app returns to the foreground: retries the geo query if
  /// it previously failed (RF-2, CL-12).
  void onResume() {
    if (_geoSucceeded || _isGeoLoading) return;
    fetchGeo();
  }

  void _recompute() {
    final EffectiveTemperature? computed;
    final NoticeType? shownNotice;

    if (_isGeoLoading) {
      // While loading, recommend with the manual source only and avoid
      // showing a false "geo unavailable" notice (RF-5).
      computed = computeEffectiveTemperature(manualTenths: _manualTenths);
      shownNotice = null;
    } else {
      computed =
          computeEffectiveTemperature(manualTenths: _manualTenths, geo: _geoReading);
      shownNotice = computed?.notice;
    }

    effective = computed;
    notice = shownNotice;
    extreme = computed == null ? ExtremeLevel.none : evaluateExtreme(computed.celsius);
    recommendation = (computed != null && _ageBand != null)
        ? recommendationFor(computed.celsius, _ageBand!)
        : null;

    notifyListeners();
  }
}
