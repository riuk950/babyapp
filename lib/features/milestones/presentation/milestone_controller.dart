import 'package:flutter/foundation.dart';

import '../../../core/domain/milestones/last_hit_resolver.dart';
import '../../../core/domain/milestones/milestone_content.dart' as src;
import '../../../core/domain/milestones/milestone_guide.dart';
import '../../../core/domain/milestones/milestone_month.dart';

/// Presentation controller owning the ephemeral (session-only) state of the
/// milestones screen: the selected month and the search filter (RF-1, RF-4,
/// RNF-3). It exposes the resolved content as a [ResolvedMonth]. No
/// persistence is performed (RNF-3).
class MilestoneController extends ChangeNotifier {
  MilestoneController();

  MilestoneMonth? _month;
  String _query = '';

  MilestoneMonth? get month => _month;

  /// The resolved content for the selected month, or `null` when none is
  /// selected (RF-1, RF-2, CL-1).
  ResolvedMonth? get resolvedContent =>
      _month == null ? null : resolveMonth(_month!);

  /// Medical disclaimer shown always, including the no-month state (RF-3).
  String get medicalDisclaimer => src.medicalDisclaimer;

  /// Months matching the search query by number or age label. Empty query
  /// returns all 60 months; no match returns an empty list (RF-1, CL-12).
  List<MilestoneMonth> get filteredMonths {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return List.unmodifiable(MilestoneMonth.values);
    return MilestoneMonth.values.where((m) {
      return m.number.toString().contains(q) ||
          m.ageLabel.toLowerCase().contains(q);
    }).toList();
  }

  /// True when the search yields no matches (CL-12).
  bool get hasNoSearchResults =>
      _query.trim().isNotEmpty && filteredMonths.isEmpty;

  /// Selects a month, replacing the previous resolved content (RF-4).
  /// Selecting the same month again is idempotent (CL-2). `null` clears it
  /// (RF-1).
  void selectMonth(MilestoneMonth? month) {
    _month = month;
    notifyListeners();
  }

  /// Updates the search filter (RF-1, CL-12). Does not clear the selection.
  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  /// Clears the search filter (CL-12).
  void clearQuery() {
    _query = '';
    notifyListeners();
  }

  /// Resets to the no-month state (RNF-3, CL-6). Keeps the search filter.
  void reset() {
    _month = null;
    notifyListeners();
  }
}
