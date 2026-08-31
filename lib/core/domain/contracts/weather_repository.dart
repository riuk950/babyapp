import '../entities/geo.dart';

/// Interface for fetching the current ambient temperature by geolocation
/// (RF-2, RF-4 · §2).
abstract class WeatherRepository {
  Future<GeoTemperatureResult> fetchCurrentTemperature();
}
