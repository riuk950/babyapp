// Typed models for the alert guidance content of one age band (spec 005 §3).
// Pure Dart: must not import Flutter or any framework (constitution §3A).

import '../age/age_band.dart';
import 'alert_sign.dart';

/// Development areas for alert signals — closed inventory of 5 (spec 005
/// Decisiones de contenido, conceptually equal to feature 004). Kept as its
/// own enum so features evolve independently (plan decision 8).
enum AlertArea {
  grossMotor('Motricidad gruesa'),
  fineMotor('Motricidad fina'),
  language('Lenguaje'),
  socialEmotional('Social/afectivo'),
  cognitive('Cognitivo');

  const AlertArea(this.label);

  /// Spanish label shown to the user (RF-2).
  final String label;
}

/// A single alert signal with its unique urgency level and action guide
/// (RF-2, RF-3). The level is data, never inferred by heuristics (CL-11).
class AlertSignal {
  const AlertSignal({
    required this.signal,
    required this.level,
    required this.action,
  });

  /// The alert text; clinical terms include an everyday clarification (RF-2).
  final String signal;

  /// The single urgency level for this signal (RF-3).
  final AlertLevel level;

  /// Plain-language action guide: what to do and with what urgency (RF-3).
  final String action;
}

/// The alert signals of one development area within an age band (RF-2). An
/// empty [signals] list means the area is omitted from the render (CL-10).
class AreaAlerts {
  const AreaAlerts({
    required this.area,
    required this.label,
    required this.signals,
  });

  final AlertArea area;

  /// Spanish label of the area (RF-2).
  final String label;

  final List<AlertSignal> signals;
}

/// The complete alert guide for one [AgeBand] (RF-1..RF-3). Deterministic:
/// for a given band the fields never change (RF-5).
class AlertGuide {
  const AlertGuide({
    required this.band,
    required this.label,
    required this.rangeMonths,
    required this.areas,
    required this.medicalDisclaimer,
  });

  /// The age band this guide belongs to (shared source, CL-3).
  final AgeBand band;

  /// Human-readable band label, e.g. "0–3 meses" (RF-1).
  final String label;

  /// Bounds expressed in months, e.g. "[0,3)" (RF-1, CL-3).
  final String rangeMonths;

  /// Signals grouped by area; areas with no signals are omitted (CL-10).
  final List<AreaAlerts> areas;

  /// Legal disclaimer shown always (RF-3).
  final String medicalDisclaimer;
}
