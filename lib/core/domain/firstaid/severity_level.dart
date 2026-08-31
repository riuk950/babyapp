// First-aid severity — closed inventory of 2 mutually exclusive levels
// (spec 007 RF-5, CL-8). Pure Dart: must not import Flutter or any framework
// (constitution §3A).

/// Severity indicator of a first-aid emergency: `urgency` or `consult`.
enum SeverityLevel {
  urgency(
    'Urgencia',
    'Acude a urgencias de inmediato: requiere atención médica el mismo día, '
        'sin demora programable.',
  ),
  consult(
    'Consulta',
    'Consulta con el pediatra: puede atenderse en el mismo día o en 24–48 h, '
        'o actúa en casa con vigilancia.',
  );

  const SeverityLevel(this.label, this.actionGuide);

  /// Spanish label shown to the user (RF-5).
  final String label;

  /// Spanish action guide advising whether to go to the emergency room or
  /// consult/act at home (RF-5).
  final String actionGuide;
}
