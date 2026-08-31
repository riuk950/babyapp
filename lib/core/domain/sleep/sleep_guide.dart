// Typed model for the sleep guidance content of one age band (spec 002 §3).
// Pure Dart: must not import Flutter or any framework (constitution §3A).

import '../age/age_band.dart';

/// Sleep guidance for a single [AgeBand]: how much to sleep, when, and when to
/// worry (RF-2, RF-3). Every clinical term in [alarmSigns] carries an everyday
/// clarification embedded in the string (RF-2, redaction rule).
class SleepGuide {
  const SleepGuide({
    required this.band,
    required this.label,
    required this.rangeMonths,
    required this.totalHoursPerDay,
    required this.naps,
    required this.bedtimeSchedule,
    required this.insufficientSleepSigns,
    required this.alarmSigns,
    required this.medicalDisclaimer,
  });

  /// The age band this guidance belongs to.
  final AgeBand band;

  /// Human-readable band label, e.g. "3–12 meses".
  final String label;

  /// Bounds expressed in months, e.g. "[3,12)".
  final String rangeMonths;

  /// Recommended total hours per 24 h, as a range.
  final String totalHoursPerDay;

  /// Number and duration of naps.
  final String naps;

  /// Orientative bedtime and wake time.
  final String bedtimeSchedule;

  /// Signs of insufficient sleep.
  final List<String> insufficientSleepSigns;

  /// When to consult the paediatrician; clinical terms include clarifications.
  final List<String> alarmSigns;

  /// Legal disclaimer shown always (RF-3).
  final String medicalDisclaimer;
}
