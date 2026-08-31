import 'package:flutter/foundation.dart';

import '../../../core/domain/age/age_band.dart';
import '../../../core/domain/sleep/sleep_content.dart' as content;
import '../../../core/domain/sleep/sleep_guide.dart';

/// Presentation controller owning the transient (ephemeral) selection state of
/// the sleep screen (RF-1, RF-4, RNF-3). It delegates to the pure domain
/// `guideFor`. No persistence is performed (RNF-3).
class SleepController extends ChangeNotifier {
  SleepController();

  AgeBand? _band;

  AgeBand? get band => _band;

  /// The sleep guide for the selected band, or `null` when none is selected
  /// (RF-1, CL-1).
  SleepGuide? get guide => content.guideFor(_band);

  /// Medical disclaimer shown always, including the no-selection state (RF-3).
  String get medicalDisclaimer => content.medicalDisclaimer;

  /// Selects a band, replacing any previous content (RF-4). Selecting the same
  /// band again is idempotent (CL-9). Passing `null` clears the selection
  /// (RF-1).
  void selectBand(AgeBand? band) {
    _band = band;
    notifyListeners();
  }

  /// Resets to the no-selection state (CL-6, RNF-3).
  void reset() {
    _band = null;
    notifyListeners();
  }
}
