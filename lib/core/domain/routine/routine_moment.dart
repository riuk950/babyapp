// Daily routine moments — closed inventory of 6 (spec 006 Decisiones de
// contenido, RF-1). Pure Dart: must not import Flutter or any framework
// (constitution §3A).

/// Moment of the day for which routine tips are shown.
enum RoutineMoment {
  morning('Mañana'),
  nap('Siesta'),
  bath('Baño'),
  feeding('Alimentación'),
  play('Juego/estimulación'),
  night('Noche');

  const RoutineMoment(this.label);

  /// Spanish label shown to the user (RF-1).
  final String label;
}
