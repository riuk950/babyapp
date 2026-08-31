// Resolves the "last hit reached" rule for each area (spec 004 RF-2, CL-3,
// CL-9, CL-10). Pure Dart, no Flutter imports (constitution §3A).
import 'development_area.dart';
import 'milestone_content.dart';
import 'milestone_guide.dart';
import 'milestone_month.dart';

/// Provides the content of a month. In production this is `contentFor`;
/// tests inject a stub to exercise edge cases (CL-10).
typedef MonthContentProvider = MonthContent? Function(MilestoneMonth? month);

/// Builds the [ResolvedMonth] for [month]: for each area, it shows that
/// month's new milestones when present; otherwise the most recent prior hit
/// marked as a reference (RF-2, RNF-5). An area with no milestones in any month
/// is omitted (CL-10). Month 1 always has new milestones, so it never resolves
/// backward (CL-9).
ResolvedMonth resolveMonth(
  MilestoneMonth month, {
  MonthContentProvider? provider,
}) {
  final lookup = provider ?? contentFor;
  final content = lookup(month)!;

  final resolvedAreas = <ResolvedArea>[];
  for (final areaMeta in content.areas) {
    final area = areaMeta.area;

    if (areaMeta.newMilestones.isNotEmpty) {
      resolvedAreas.add(ResolvedArea(
        area: area,
        label: areaMeta.label,
        items: [
          for (final text in areaMeta.newMilestones) MilestoneItem(text),
        ],
        alarmSigns: areaMeta.alarmSigns,
        isLastHitReference: false,
      ));
      continue;
    }

    final lastHit = _lastHitBefore(area, month, lookup);
    if (lastHit == null) continue; // omit area with no hits anywhere (CL-10)

    resolvedAreas.add(ResolvedArea(
      area: area,
      label: areaMeta.label,
      items: [MilestoneItem(lastHit)],
      alarmSigns: areaMeta.alarmSigns,
      isLastHitReference: true,
    ));
  }

  return ResolvedMonth(
    month: month,
    label: content.label,
    areas: resolvedAreas,
    medicalDisclaimer: content.medicalDisclaimer,
  );
}

/// Returns the most recent prior milestone for [area] before [current], or
/// `null` when no prior month has a new milestone for that area.
String? _lastHitBefore(
  DevelopmentArea area,
  MilestoneMonth current,
  MonthContentProvider lookup,
) {
  for (var n = current.number - 1; n >= 1; n--) {
    final prior = lookup(MilestoneMonth.forNumber(n));
    if (prior == null) continue;
    final areaMeta =
        prior.areas.where((a) => a.area == area).toList();
    if (areaMeta.isNotEmpty && areaMeta.last.newMilestones.isNotEmpty) {
      return areaMeta.last.newMilestones.last;
    }
  }
  return null;
}
