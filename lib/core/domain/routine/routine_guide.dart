// Routine guide model (spec 006 RF-3). Pure Dart: must not import Flutter or
// any framework (constitution §3A).

import '../age/age_band.dart';
import 'routine_moment.dart';
import 'routine_tip.dart';

/// The routine tips for one [RoutineMoment] within one [AgeBand] (RF-3).
class RoutineGuide {
  const RoutineGuide({
    required this.moment,
    required this.ageBand,
    required this.tips,
  });

  /// The moment of the day these tips belong to.
  final RoutineMoment moment;

  /// The age band these tips are adapted for (RF-2).
  final AgeBand ageBand;

  /// The tips for this moment and band; an empty list means the combination is
  /// omitted (CL-3).
  final List<RoutineTip> tips;
}
