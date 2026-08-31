// First-aid emergency situations — closed inventory of 12 (spec 007 Decisiones
// de contenido, RF-1). Pure Dart: must not import Flutter or any framework
// (constitution §3A).

/// First-aid emergency situation for which a guide is offered.
enum EmergencyType {
  choking('Atragantamiento'),
  burns('Quemaduras'),
  falls('Caídas'),
  bitesStings('Picaduras y mordeduras'),
  seizures('Convulsiones'),
  highFever('Fiebre alta'),
  bleedingWounds('Heridas sangrantes'),
  poisoning('Intoxicación'),
  headInjury('Golpe en la cabeza'),
  anaphylaxis('Alergias graves'),
  drowning('Ahogamiento'),
  foreignObject('Objetos en ojos, orejas o nariz');

  const EmergencyType(this.label);

  /// Spanish label shown to the user (RF-1).
  final String label;
}
