// Typed models for the breastmilk guide (spec 003 §3). Pure Dart: must not
// import Flutter or any framework (constitution §3A).

import 'breastmilk_section.dart';

/// A single row of the recommended storage-time table (RF-3, CL-9): where the
/// milk is kept, at what temperature, and for how long (recommended only).
class StorageTimeRow {
  const StorageTimeRow({
    required this.place,
    required this.temp,
    required this.duration,
  });

  final String place;
  final String temp;
  final String duration;
}

/// Guidance content for a single [BreastMilkSection] (RF-2, RF-3).
class SectionContent {
  const SectionContent({
    required this.section,
    required this.label,
    required this.bestPractices,
    required this.highlights,
    required this.storageTimeRows,
    required this.medicalDisclaimer,
  });

  final BreastMilkSection section;
  final String label;
  final List<String> bestPractices;

  /// Critical safety blocks, shown as highlighted "Aviso de seguridad" (RF-3).
  /// Empty for the extraction section by the RF-3 rule.
  final List<String> highlights;

  /// Recommended storage-time table. Present only in the storage section
  /// (RF-3, CL-9).
  final List<StorageTimeRow> storageTimeRows;

  /// Medical disclaimer shown always (RF-3).
  final String medicalDisclaimer;
}
