import '../failures/failures.dart';
import '../models.dart';

/// A geographic position (latitude/longitude) returned by the geo source.
class GeoPosition {
  const GeoPosition({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

/// Result of fetching the ambient temperature by geolocation (RF-2).
///
/// Either a valid [GeoTemperatureSuccess] carrying a [TemperatureReading], or
/// a typed [GeoTemperatureFailure] carrying a [GeoFailure].
sealed class GeoTemperatureResult {
  const GeoTemperatureResult();
}

class GeoTemperatureSuccess extends GeoTemperatureResult {
  const GeoTemperatureSuccess(this.reading);

  final TemperatureReading reading;
}

class GeoTemperatureFailure extends GeoTemperatureResult {
  const GeoTemperatureFailure(this.failure);

  final GeoFailure failure;
}
