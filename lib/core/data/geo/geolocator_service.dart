import 'package:geolocator/geolocator.dart';

import '../../domain/contracts/geo_repository.dart';
import '../../domain/entities/geo.dart';
import '../../domain/failures/failures.dart';

/// Implements [GeoRepository] using the `geolocator` plugin (RF-2, CL-12).
///
/// Thin adapter with no business logic: resolves permission and service
/// availability, then returns lat/long. Failures are signaled with the
/// domain-typed [GeoRepositoryException].
class GeolocatorService implements GeoRepository {
  const GeolocatorService();

  @override
  Future<GeoPosition> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const GeoRepositoryException(GeoFailure.noService);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const GeoRepositoryException(GeoFailure.permissionDenied);
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    );

    return GeoPosition(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
