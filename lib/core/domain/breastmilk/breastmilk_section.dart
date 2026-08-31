// The breastmilk guide sections (spec 003). Pure Dart: must not import Flutter
// (constitution §3A).

/// The four navigable sections of the breastmilk storage guide (RF-1).
enum BreastMilkSection {
  extraction('Extracción'),
  storage('Almacenamiento'),
  defrosting('Descongelado y uso'),
  hygiene('Higiene y seguridad');

  const BreastMilkSection(this.label);

  /// User-facing Spanish label for the section (RF-1, §6).
  final String label;
}
