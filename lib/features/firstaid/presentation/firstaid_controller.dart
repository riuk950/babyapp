import 'package:flutter/foundation.dart';

import '../../../core/domain/age/age_band.dart';
import '../../../core/domain/firstaid/emergency_type.dart';
import '../../../core/domain/firstaid/firstaid_content.dart' as src;
import '../../../core/domain/firstaid/firstaid_guide.dart';

/// Presentation controller owning the transient (ephemeral) selection state of
/// the first-aid screen: the chosen emergency and age band (RF-1, RF-2,
/// RNF-3). It delegates to the pure domain `contentFor`. No persistence is
/// performed (RNF-3).
class FirstAidController extends ChangeNotifier {
  FirstAidController();

  EmergencyType? _emergency;
  AgeBand? _band;

  EmergencyType? get emergency => _emergency;
  AgeBand? get band => _band;

  /// The guide for the selected emergency and band, or `null` when either is
  /// missing (RF-1, RF-2, RF-3, CL-1, CL-2, CL-3).
  EmergencyGuide? get guide => src.contentFor(_emergency, _band);

  /// Medical disclaimer shown always, including no-selection states (RF-6).
  String get medicalDisclaimer => src.medicalDisclaimer;

  /// The 12 emergency situations (RF-1).
  List<EmergencyType> get emergencies => src.availableEmergencies();

  /// Selects an emergency, replacing any previous content (RF-3, CL-5).
  /// Selecting the same emergency again is idempotent (CL-7). `null` clears it
  /// (RF-1).
  void selectEmergency(EmergencyType? emergency) {
    _emergency = emergency;
    notifyListeners();
  }

  /// Selects an age band, updating the guide (RF-2, CL-4). `null` clears it
  /// (RF-2).
  void selectBand(AgeBand? band) {
    _band = band;
    notifyListeners();
  }

  /// Resets both selections (CL-6, RNF-3).
  void reset() {
    _emergency = null;
    _band = null;
    notifyListeners();
  }
}
