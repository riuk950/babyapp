// First-aid guide model (spec 007 RF-2..RF-5). Pure Dart: must not import
// Flutter or any framework (constitution §3A).

import '../age/age_band.dart';
import 'emergency_type.dart';
import 'firstaid_step.dart';
import 'severity_level.dart';

/// Complete first-aid guide for one emergency x age-band combination: the
/// numbered "what to do" steps, the separate "what NOT to do" section, and a
/// severity indicator (RF-2..RF-5).
class EmergencyGuide {
  const EmergencyGuide({
    required this.emergency,
    required this.ageBand,
    required this.severity,
    required this.steps,
    required this.doNot,
  });

  /// The emergency situation covered (RF-1).
  final EmergencyType emergency;

  /// The age band the guide is adapted to (RF-2).
  final AgeBand ageBand;

  /// Mutually exclusive severity indicator: `urgency` or `consult` (RF-5).
  final SeverityLevel severity;

  /// Numbered steps of what to do, in order (RF-3).
  final List<FirstAidStep> steps;

  /// Numbered steps of what NOT to do, in order (RF-4).
  final List<FirstAidStep> doNot;
}
