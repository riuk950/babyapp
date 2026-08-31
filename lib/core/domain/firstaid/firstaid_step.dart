// First-aid step model (spec 007 RF-3, RF-4). Pure Dart: must not import
// Flutter or any framework (constitution §3A).

/// A single numbered first-aid instruction (what to do or what NOT to do).
class FirstAidStep {
  const FirstAidStep({required this.order, required this.text});

  /// Sequential order starting at 1 (RF-3).
  final int order;

  /// The clear, actionable instruction in Spanish, beginning with an
  /// infinitive or imperative verb (RF-3, RF-4).
  final String text;
}
