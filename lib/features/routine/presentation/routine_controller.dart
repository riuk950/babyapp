import 'package:flutter/foundation.dart';

import '../../../core/domain/age/age_band.dart';
import '../../../core/domain/routine/routine_content.dart' as src;
import '../../../core/domain/routine/routine_moment.dart';
import '../../../core/domain/routine/routine_tip.dart';

/// Presentation controller owning the transient (ephemeral) selection state of
/// the routine-tips screen: the chosen moment and age band (RF-1, RF-2,
/// RNF-3). It delegates to the pure domain `tipsFor`. No persistence is
/// performed (RNF-3).
class RoutineController extends ChangeNotifier {
  RoutineController();

  RoutineMoment? _moment;
  AgeBand? _band;

  RoutineMoment? get moment => _moment;
  AgeBand? get band => _band;

  /// The tips for the selected moment and band, or `null` when either is
  /// missing (RF-1, RF-2, CL-1, CL-2).
  List<RoutineTip>? get tips => src.tipsFor(_moment, _band);

  /// Medical disclaimer shown always, including no-selection states (RF-6).
  String get medicalDisclaimer => src.medicalDisclaimer;

  /// The 6 moments of the day (RF-1).
  List<RoutineMoment> get moments => src.availableMoments();

  /// Selects a moment, replacing any previous content (RF-3, CL-5). Selecting
  /// the same moment again is idempotent (CL-7). `null` clears it (RF-1).
  void selectMoment(RoutineMoment? moment) {
    _moment = moment;
    notifyListeners();
  }

  /// Selects an age band, updating the tips (RF-2, CL-4). `null` clears it
  /// (RF-2).
  void selectBand(AgeBand? band) {
    _band = band;
    notifyListeners();
  }

  /// Resets both selections (CL-6, RNF-3).
  void reset() {
    _moment = null;
    _band = null;
    notifyListeners();
  }
}
