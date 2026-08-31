// Development areas — closed inventory (spec 004 Decisiones de contenido).
// Pure Dart, no Flutter imports (constitution §3A). Labels are the 
// user-visible Spanish strings; identifiers are in English.
enum DevelopmentArea {
  grossMotor('Motricidad gruesa'),
  fineMotor('Motricidad fina'),
  language('Lenguaje'),
  socialEmotional('Social/afectivo'),
  cognitive('Cognitivo');

  const DevelopmentArea(this.label);

  /// Spanish label shown to the user (RF-2, RF-3).
  final String label;
}
