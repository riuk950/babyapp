import 'package:flutter/foundation.dart';

import '../../../core/domain/breastmilk/breastmilk_content.dart' as src;
import '../../../core/domain/breastmilk/breastmilk_guide.dart';
import '../../../core/domain/breastmilk/breastmilk_section.dart';

/// Presentation controller owning the transient (ephemeral) selection state of
/// the breastmilk screen (RF-1, RF-4, RNF-3). It delegates to the pure domain
/// `contentFor`. No persistence is performed (RNF-3).
class BreastMilkController extends ChangeNotifier {
  BreastMilkController();

  BreastMilkSection? _section;

  BreastMilkSection? get section => _section;

  /// The content for the selected section, or `null` when none is selected
  /// (RF-1, CL-1).
  SectionContent? get content => src.contentFor(_section);

  /// Medical disclaimer shown always, including the no-selection state (RF-3).
  String get medicalDisclaimer => src.medicalDisclaimer;

  /// Selects a section, replacing any previous content (RF-4). Selecting the
  /// same section again is idempotent (CL-8). Passing `null` clears it (RF-1).
  void selectSection(BreastMilkSection? section) {
    _section = section;
    notifyListeners();
  }

  /// Resets to the no-selection state (CL-8, RNF-3).
  void reset() {
    _section = null;
    notifyListeners();
  }
}
