import '../models.dart';

/// Computes the effective temperature from the available sources (RF-3, RF-4).
///
/// - Both manual and geo available: returns the average, rounded half-up
///   toward +∞ (CL-8).
/// - Manual only: fallback, source `manualOnly`, notice `geoUnavailable`.
/// - Geo only: fallback, source `geoOnly`, notice `manualIgnored`.
/// - Geo reading outside -30..50 is treated as unavailable (CL-11).
/// - No valid source: returns `null` (RF-4).
///
/// Deterministic: same input always yields the same result (RF-9).
EffectiveTemperature? computeEffectiveTemperature({
  int? manualTenths,
  TemperatureReading? geo,
}) {
  final hasManual = manualTenths != null;
  final hasGeo = geo != null && _isInRange(geo.tenths);

  if (!hasManual && !hasGeo) return null;

  if (hasManual && hasGeo) {
    return EffectiveTemperature(
      celsius: _roundHalfUp((manualTenths + geo.tenths) / 2),
      source: EffectiveTemperatureSource.average,
    );
  }

  if (hasManual) {
    return EffectiveTemperature(
      celsius: _roundHalfUp(manualTenths),
      source: EffectiveTemperatureSource.manualOnly,
      notice: NoticeType.geoUnavailable,
    );
  }

  return EffectiveTemperature(
    celsius: _roundHalfUp(geo!.tenths),
    source: EffectiveTemperatureSource.geoOnly,
    notice: NoticeType.manualIgnored,
  );
}

bool _isInRange(int tenths) => tenths >= -300 && tenths <= 500;

/// Rounds tenths of a degree to the nearest whole degree, half-up toward +∞.
///
/// e.g. 19.5 -> 20, -2.5 -> -2, -2.4 -> -2, -2.6 -> -3, 19.4 -> 19.
int _roundHalfUp(num tenths) => ((tenths / 10) + 0.5).floor();
