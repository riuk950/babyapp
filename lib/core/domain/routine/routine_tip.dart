// Routine tip model (spec 006 RF-3, RF-4). Pure Dart: must not import Flutter
// or any framework (constitution §3A).

/// A single short, actionable routine tip (≤2 lines) with the source or
/// recommendation that backs it (RF-3, RF-4).
class RoutineTip {
  const RoutineTip({required this.message, required this.source});

  /// The short actionable message, in Spanish, beginning with an infinitive or
  /// imperative verb (RF-3).
  final String message;

  /// The source or recommendation (OMS, AAP, OMS lactancia) backing this tip
  /// (RF-4).
  final String source;
}
