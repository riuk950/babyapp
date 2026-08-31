// Urgency level for an alert signal (spec 005 RF-3, CL-8). Pure Dart: must
// not import Flutter or any framework (constitution §3A).
//
// Each signal carries exactly one level. The level is data carried in the
// content, never inferred by heuristics at runtime (CL-11).

/// Whether a signal warrants an emergency visit or a scheduled appointment.
enum AlertLevel {
  /// Requires immediate medical attention, same day, without schedulable
  /// delay (e.g. breathing difficulty, seizure, severe dehydration).
  urgency('Urgencia'),

  /// Requires paediatric assessment but is not an emergency; may include the
  /// "consulta pronto" hint when it must be seen within 24–48 h.
  scheduled('Consulta programada');

  const AlertLevel(this.label);

  /// Short Spanish label identifying the level by text, not only by color
  /// (RF-3, RNF-5).
  final String label;
}
