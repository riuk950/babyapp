// Typed models for the milestones guide (spec 004). Pure Dart, no Flutter
// imports (constitution §3A). Identifiers in English; user-visible strings in
// Spanish.
import 'development_area.dart';
import 'milestone_month.dart';

/// A single milestone shown for an area or a month.
class MilestoneItem {
  const MilestoneItem(this.text);

  final String text;
}

/// Raw per-area content for a month: new milestones and alarm signs. This does
/// NOT carry resolved "last hit" data — that is produced by
/// `last_hit_resolver.dart` (RF-2, CL-3).
class AreaMilestones {
  const AreaMilestones({
    required this.area,
    required this.label,
    required this.newMilestones,
    required this.alarmSigns,
  });

  final DevelopmentArea area;
  final String label;
  final List<String> newMilestones;
  final List<String> alarmSigns;
}

/// Full content of one month (RF-1..RF-3, RF-5).
class MonthContent {
  const MonthContent({
    required this.month,
    required this.label,
    required this.areas,
    required this.medicalDisclaimer,
  });

  final MilestoneMonth month;
  final String label;
  final List<AreaMilestones> areas;
  final String medicalDisclaimer;
}

/// One resolved area for rendering: the items to show plus its alarm signs.
/// [isLastHitReference] marks whether the items are a prior month's last hit
/// rather than that month's new milestones (RF-2, RNF-5).
class ResolvedArea {
  const ResolvedArea({
    required this.area,
    required this.label,
    required this.items,
    required this.alarmSigns,
    required this.isLastHitReference,
  });

  final DevelopmentArea area;
  final String label;
  final List<MilestoneItem> items;
  final List<String> alarmSigns;
  final bool isLastHitReference;
}

/// A [MonthContent] together with its area-resolution for display (plan §3).
class ResolvedMonth {
  const ResolvedMonth({
    required this.month,
    required this.label,
    required this.areas,
    required this.medicalDisclaimer,
  });

  final MilestoneMonth month;
  final String label;
  final List<ResolvedArea> areas;
  final String medicalDisclaimer;
}
