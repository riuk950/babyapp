import '../models.dart';

/// Returns the [AgeBand] for a child's age in months (RF-6, CL-13).
///
/// Bands: [0,3) [3,12) [12,36) [36,60] months. Returns `null` when the age is
/// outside the supported [0,60] range.
AgeBand? ageBandForMonths(int months) {
  if (months < 0) return null;
  if (months < 3) return AgeBand.newborn0to3;
  if (months < 12) return AgeBand.infant3to12;
  if (months < 36) return AgeBand.toddler12to36;
  if (months <= 60) return AgeBand.child36to60;
  return null;
}
