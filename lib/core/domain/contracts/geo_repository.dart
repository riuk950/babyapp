import '../entities/geo.dart';
import '../failures/failures.dart';

/// Interface for obtaining the device's geographic position (RF-2, §2).
///
/// Implementations may signal failure by throwing a domain-typed
/// [GeoRepositoryException].
abstract class GeoRepository {
  Future<GeoPosition> getCurrentPosition();
}
