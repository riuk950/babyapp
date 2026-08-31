// The age bands and their boundaries live in `../age/age_band.dart` (single
// shared source, spec 002 CL-3). 001 re-exports them here so its stable
// `ageBandForMonths` surface remains available without a copy.
export '../age/age_band.dart' show AgeBand, ageBandForMonths;
