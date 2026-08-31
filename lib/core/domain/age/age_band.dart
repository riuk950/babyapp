// Single shared source of truth for the child age bands (spec 002 §2, CL-3).
// Both the clothing feature (001, RF-6) and the sleep feature (002, RF-1) use
// these bands and boundaries. Pure Dart: must not import Flutter (§3A).

/// Life stage the child belongs to, used to adjust age-dependent guidance.
///
/// Bands follow the app contract: each band includes its lower bound and
/// excludes its upper bound — [0,3), [3,12), [12,36), [36,60] months (RF-1,
/// RF-6, CL-3).
enum AgeBand {
  newborn0to3,
  infant3to12,
  toddler12to36,
  child36to60,
}

/// Returns the [AgeBand] for a child's age in months (RF-6, CL-13).
///
/// Returns `null` when the age is outside the supported [0,60] range.
AgeBand? ageBandForMonths(int months) {
  if (months < 0) return null;
  if (months < 3) return AgeBand.newborn0to3;
  if (months < 12) return AgeBand.infant3to12;
  if (months < 36) return AgeBand.toddler12to36;
  if (months <= 60) return AgeBand.child36to60;
  return null;
}
