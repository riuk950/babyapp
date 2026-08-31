import '../../domain/contracts/geo_repository.dart';
import '../../domain/contracts/weather_repository.dart';
import '../../domain/entities/geo.dart';
import '../../domain/failures/failures.dart';
import 'open_meteo.dart';

/// Implements [WeatherRepository] by orchestrating the geo source and the
/// HTTP weather API, classifying failures into domain [GeoFailure] values
/// (RF-2, RF-4 · RNF-6).
class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl({
    required this.geoRepository,
    required this.api,
  });

  final GeoRepository geoRepository;
  final WeatherApi api;

  @override
  Future<GeoTemperatureResult> fetchCurrentTemperature() async {
    final GeoPosition position;
    try {
      position = await geoRepository.getCurrentPosition();
    } on GeoRepositoryException catch (e) {
      return GeoTemperatureFailure(e.failure);
    } catch (_) {
      return const GeoTemperatureFailure(GeoFailure.noService);
    }

    return api.fetchTemperature(position);
  }
}
