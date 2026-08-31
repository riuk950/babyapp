// Pure domain types for the weather-to-clothing rules (spec 001).
// This file must not import Flutter or any framework (constitution §3A).

// [AgeBand] is defined once in `age/age_band.dart` (single shared source,
// spec 002 CL-3) and re-exported here so 001 keeps a stable import surface.
import 'age/age_band.dart';
export 'age/age_band.dart' show AgeBand;

/// Failure reasons for a manually entered temperature (RF-1).
enum ManualInputFailure {
  empty,
  notNumeric,
  tooManyDecimals,
  outOfRange,
}

/// Result of parsing and validating a manual temperature (RF-1).
///
/// On success it carries the temperature as whole tenths of a degree to avoid
/// floating point noise; on failure it carries a typed [ManualInputFailure].
sealed class ManualInputResult {
  const ManualInputResult();
}

/// A valid manual temperature, stored as whole tenths of a degree Celsius.
class ManualInputSuccess extends ManualInputResult {
  const ManualInputSuccess(this.tenths);

  final int tenths;
}

/// An invalid manual temperature, with the reason it was rejected.
class ManualInputError extends ManualInputResult {
  const ManualInputError(this.failure);

  final ManualInputFailure failure;
}

/// A single temperature reading (manual or geo), in whole tenths of a degree.
///
/// Geo readings outside -30..50 C are treated as unavailable (CL-11).
class TemperatureReading {
  const TemperatureReading(this.tenths);

  final int tenths;
}

/// Origin of the effective temperature used for the recommendation (RF-4).
enum EffectiveTemperatureSource {
  average,
  manualOnly,
  geoOnly,
}

/// Non-blocking notice about a degraded source, shown without replacing the
/// recommendation (RF-4 / HU-4).
enum NoticeType {
  geoUnavailable,
  manualIgnored,
}

/// Effective temperature: the value (already rounded to whole degrees) used to
/// consult the recommendation table, its source, and any fallback notice (RF-3,
/// RF-4).
class EffectiveTemperature {
  const EffectiveTemperature({
    required this.celsius,
    required this.source,
    this.notice,
  });

  final int celsius;
  final EffectiveTemperatureSource source;
  final NoticeType? notice;
}

/// Extreme-temperature warning level, evaluated on the rounded effective
/// temperature independently of the recommendation table cuts (RF-8 / CL-3).
enum ExtremeLevel {
  none,
  cold,
  heat,
}

/// Clothing recommendation for a temperature and age band, plus the extreme
/// warning state (RF-6, RF-7, RF-8).
class ClothingRecommendation {
  const ClothingRecommendation({
    required this.text,
    required this.effectiveCelsius,
    required this.ageBand,
    required this.extreme,
  });

  final String text;
  final int effectiveCelsius;
  final AgeBand ageBand;
  final ExtremeLevel extreme;
}
