import '../models.dart';

/// Evaluates the extreme-temperature warning on the already-rounded effective
/// temperature, independently of the recommendation table cuts (RF-8, CL-3).
///
/// - `<= 0` -> [ExtremeLevel.cold]
/// - `>= 30` -> [ExtremeLevel.heat]
/// - otherwise -> [ExtremeLevel.none]
ExtremeLevel evaluateExtreme(int effectiveCelsius) {
  if (effectiveCelsius <= 0) return ExtremeLevel.cold;
  if (effectiveCelsius >= 30) return ExtremeLevel.heat;
  return ExtremeLevel.none;
}
