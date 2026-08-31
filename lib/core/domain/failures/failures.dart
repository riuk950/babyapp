/// Domain failure types (constitution §2, §3A). Pure Dart, no framework.
enum GeoFailure {
  permissionDenied,
  noService,
  timeout,
  invalidData,
}

/// Typed exception carrying a domain [GeoFailure]. Used by [GeoRepository]
/// implementations / orchestrators to signal failures as domain types instead
/// of generic exceptions.
class GeoRepositoryException implements Exception {
  const GeoRepositoryException(this.failure);

  final GeoFailure failure;

  @override
  String toString() => 'GeoRepositoryException($failure)';
}
