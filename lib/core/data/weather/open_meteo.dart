import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/geo.dart';
import '../../domain/failures/failures.dart';
import '../../domain/models.dart';

/// Fault boundary DTO for the Open-Meteo forecast response (RF-2, §3B).///
/// Kept pure so it can be unit-tested without a network. Maps the `current`
/// `temperature_2m` to whole tenths using integer arithmetic and discards
/// readings outside -30..50 C (returns `null`, CL-11).
class WeatherResponseDto {
  const WeatherResponseDto._(this.tenths);

  final int tenths;

  /// Parses the Open-Meteo JSON body into a [TemperatureReading], or `null`
  /// when the temperature is missing or outside -30..50 C.
  static TemperatureReading? fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    if (current is! Map<String, dynamic>) return null;
    final temp = current['temperature_2m'];
    if (temp is! num) return null;

    final tenths = (temp * 10).round();
    if (tenths < -300 || tenths > 500) return null;
    return TemperatureReading(WeatherResponseDto._(tenths).tenths);
  }
}

/// HTTP API boundary for fetching the ambient temperature (RF-2, §3B).
///
/// Returns a domain-typed [GeoTemperatureResult]: a reading on success, or a
/// [GeoFailure] on timeout/network, service, or invalid-data errors.
abstract class WeatherApi {
  Future<GeoTemperatureResult> fetchTemperature(GeoPosition position);
}

/// Concrete Open-Meteo client using `package:http` (restricted to data layer).
///
/// HTTP requests are encapsulated here; all business rules live in the domain.
class OpenMeteoApi implements WeatherApi {
  OpenMeteoApi({http.Client? client, this.timeout = const Duration(seconds: 10)})
      : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;

  @override
  Future<GeoTemperatureResult> fetchTemperature(GeoPosition position) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString(),
      'current': 'temperature_2m',
    });

    try {
      final response = await _client.get(uri).timeout(timeout);
      if (response.statusCode != 200) {
        return const GeoTemperatureFailure(GeoFailure.noService);
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return const GeoTemperatureFailure(GeoFailure.invalidData);
      }
      final reading = WeatherResponseDto.fromJson(decoded);
      if (reading == null) {
        return const GeoTemperatureFailure(GeoFailure.invalidData);
      }
      return GeoTemperatureSuccess(reading);
    } on TimeoutException {
      return const GeoTemperatureFailure(GeoFailure.timeout);
    } on http.ClientException {
      return const GeoTemperatureFailure(GeoFailure.timeout);
    } on FormatException {
      return const GeoTemperatureFailure(GeoFailure.invalidData);
    } catch (_) {
      return const GeoTemperatureFailure(GeoFailure.timeout);
    }
  }
}
