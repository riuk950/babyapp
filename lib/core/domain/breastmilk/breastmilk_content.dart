// Content source for the breastmilk guide (spec 003 §3). The content for each
// section lives here as typed constants — deterministic (RF-5), synchronous,
// without I/O. Pure Dart: must not import Flutter (constitution §3A).

import 'breastmilk_guide.dart';
import 'breastmilk_section.dart';

/// Medical disclaimer shown always, including the no-selection state (RF-3).
const String medicalDisclaimer =
    'Esta información es orientativa y no sustituye el consejo de un '
    'profesional de lactancia o de salud.';

const List<SectionContent> _allContent = [
  SectionContent(
    section: BreastMilkSection.extraction,
    label: 'Extracción',
    bestPractices: [
      'Extraer cada 2–3 h si el bebé no mama en ese momento',
      'Lavarse las manos y usar recipientes limpios',
      'Hacer raciones pequeñas (60–120 ml) para no desperdiciar',
      'No llenar los recipientes al borde: dejar espacio para la expansión al '
          'congelar',
      'Etiquetar cada recipiente con la fecha de extracción',
    ],
    highlights: [],
    storageTimeRows: [],
    medicalDisclaimer: medicalDisclaimer,
  ),
  SectionContent(
    section: BreastMilkSection.storage,
    label: 'Almacenamiento',
    bestPractices: [
      'Guardar en la parte trasera de la nevera (la más fría), no en la puerta',
      'Usar recipientes de vidrio o plástico sin BPA (sustancia usada en '
          'algunos plásticos que se recomienda evitar)',
      'Si se mezclan extracciones, enfriar la nueva antes de añadirla a leche '
          'ya fría',
    ],
    highlights: [
      'No guardar la leche en la puerta de la nevera.',
    ],
    storageTimeRows: [
      StorageTimeRow(place: 'Ambiente', temp: '≤25 °C', duration: 'hasta 4 h'),
      StorageTimeRow(place: 'Nevera', temp: '~4 °C', duration: 'hasta 4 días'),
      StorageTimeRow(place: 'Congelador', temp: '−18 °C', duration: '6 meses'),
      StorageTimeRow(
          place: 'Descongelada en nevera', temp: '—', duration: 'usar antes de 24 h'),
      StorageTimeRow(
          place: 'Descongelada a temperatura ambiente',
          temp: '—',
          duration: 'usar en 1–2 h'),
    ],
    medicalDisclaimer: medicalDisclaimer,
  ),
  SectionContent(
    section: BreastMilkSection.defrosting,
    label: 'Descongelado y uso',
    bestPractices: [
      'Descongelar en la nevera o en un baño de agua tibia',
      'Agitar suavemente antes de usar; una capa de grasa separada es normal',
      'No volver a congelar ni recalentar más de una vez',
      'Desechar las sobras de un biberón parcialmente consumido',
    ],
    highlights: [
      'Nunca descongelar en microondas ni a fuego directo.',
      'No volver a congelar la leche descongelada.',
      'La leche descongelada en la nevera se usa antes de 24 h.',
    ],
    storageTimeRows: [],
    medicalDisclaimer: medicalDisclaimer,
  ),
  SectionContent(
    section: BreastMilkSection.hygiene,
    label: 'Higiene y seguridad',
    bestPractices: [
      'Lavarse las manos y el material antes de manipular la leche',
      'Esterilizar los equipos de extracción para bebés menores de 3 meses',
      'No compartir leche entre niños',
    ],
    highlights: [
      'Olor o sabor rancio o agrio, y grumos anómalos, son signos de leche en '
          'mal estado: deséchala.',
      'En caso de duda, consulta a tu profesional de lactancia o al pediatra.',
    ],
    storageTimeRows: [],
    medicalDisclaimer: medicalDisclaimer,
  ),
];

/// Returns the [SectionContent] for [section], or `null` when no section is
/// selected (RF-1). Deterministic: the same [section] always maps to the same
/// content (RF-5).
SectionContent? contentFor(BreastMilkSection? section) {
  if (section == null) return null;
  for (final content in _allContent) {
    if (content.section == section) return content;
  }
  return null;
}
