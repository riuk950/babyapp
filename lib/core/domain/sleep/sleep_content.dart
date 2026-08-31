// Content source for the sleep feature (spec 002 §3). The guidance for each
// band lives here as typed constants — deterministic (RF-5), synchronous and
// without I/O. Pure Dart: must not import Flutter (constitution §3A).

import '../age/age_band.dart';
import 'sleep_guide.dart';

/// Medical disclaimer shown always, including the no-selection state (RF-3).
const String medicalDisclaimer =
    'Esta información es orientativa y no sustituye el consejo de un '
    'profesional de salud.';

const List<SleepGuide> _allGuides = [
  SleepGuide(
    band: AgeBand.newborn0to3,
    label: '0–3 meses',
    rangeMonths: '[0,3)',
    totalHoursPerDay: '14–17 h',
    naps: '3–4 siestas cortas (15 min–2 h), sin patrón fijo',
    bedtimeSchedule:
        'Sin horario fijo; ventana de sueño 45–75 min; acostar al primer '
        'signo de sueño',
    insufficientSleepSigns: [
      'Irritabilidad',
      'Frotarse los ojos',
      'Bostezos frecuentes',
      'Dificultad para dormirse',
      'Despertares muy frecuentes',
    ],
    alarmSigns: [
      'Ronquido intenso habitual o pausas respiratorias (paradas breves de la '
          'respiración) al dormir',
      'Respiración ruidosa',
      'Sueño excesivo con letargo (mucha somnolencia, difícil de despertar) o '
          'mala ganancia de peso',
      'Dificultad para despertar',
      'Regresión de sueño persistente más de 2 semanas con irritabilidad',
      'Coloración amoratada o azulada al dormir',
    ],
    medicalDisclaimer: medicalDisclaimer,
  ),
  SleepGuide(
    band: AgeBand.infant3to12,
    label: '3–12 meses',
    rangeMonths: '[3,12)',
    totalHoursPerDay: '12–16 h',
    naps: '2–3; desde ~6 meses, 2 siestas de 1–2 h',
    bedtimeSchedule: 'Acostar 19:30–20:30; despertar 6:30–8:00',
    insufficientSleepSigns: [
      'Irritabilidad diurna',
      'Menos juego',
      'Más de 3–4 despertares nocturnos sin calmarse',
    ],
    alarmSigns: [
      'Ronquido intenso habitual o pausas respiratorias (paradas breves de la '
          'respiración) al dormir',
      'Respiración ruidosa',
      'Sueño excesivo con letargo (mucha somnolencia, difícil de despertar) o '
          'mala ganancia de peso',
      'Dificultad para despertar',
      'Regresión de sueño persistente más de 2 semanas con irritabilidad',
    ],
    medicalDisclaimer: medicalDisclaimer,
  ),
  SleepGuide(
    band: AgeBand.toddler12to36,
    label: '1–3 años',
    rangeMonths: '[12,36)',
    totalHoursPerDay: '11–14 h',
    naps: '1 siesta de tarde, 1–2 h',
    bedtimeSchedule:
        'Acostar 19:30–21:00; despertar 6:30–8:00; siesta no más tarde de las '
        '16:00',
    insufficientSleepSigns: [
      'Mal humor',
      'Rabietas',
      'Hiperactividad al final del día',
      'Resistencia a dormir',
    ],
    alarmSigns: [
      'Ronquido intenso habitual o pausas respiratorias (paradas breves de la '
          'respiración) al dormir',
      'Respiración ruidosa',
      'Sueño excesivo con letargo (mucha somnolencia, difícil de despertar) o '
          'mala ganancia de peso',
      'Dificultad para despertar',
      'Regresión de sueño persistente más de 2 semanas con irritabilidad',
    ],
    medicalDisclaimer: medicalDisclaimer,
  ),
  SleepGuide(
    band: AgeBand.child36to60,
    label: '4–5 años',
    rangeMonths: '[36,60]',
    totalHoursPerDay: '10–13 h',
    naps: 'Sin siesta obligatoria; opcional corta (30–60 min)',
    bedtimeSchedule: 'Acostar 20:00–21:00; despertar 6:30–7:30',
    insufficientSleepSigns: [
      'Irritabilidad',
      'Falta de atención',
      'Resistencia a acostarse',
      'Despertares nocturnos frecuentes',
    ],
    alarmSigns: [
      'Ronquido intenso habitual o pausas respiratorias (paradas breves de la '
          'respiración) al dormir',
      'Respiración ruidosa',
      'Sueño excesivo con letargo (mucha somnolencia, difícil de despertar) o '
          'mala ganancia de peso',
      'Dificultad para despertar',
      'Regresión de sueño persistente más de 2 semanas con irritabilidad',
    ],
    medicalDisclaimer: medicalDisclaimer,
  ),
];

/// Returns the [SleepGuide] for [band], or `null` when no band is selected
/// (RF-1). Deterministic: the same [band] always maps to the same content
/// (RF-5, CL-9).
SleepGuide? guideFor(AgeBand? band) {
  if (band == null) return null;
  for (final guide in _allGuides) {
    if (guide.band == band) return guide;
  }
  return null;
}
