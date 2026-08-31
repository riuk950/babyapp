// Content source for the alert-guide feature (spec 005 §3). The signals for
// each band live here as typed constants — deterministic (RF-5), synchronous
// and without I/O. Pure Dart: must not import Flutter (constitution §3A).
//
// Sources: AEP/AAP/CDC paediatric guidance on health and development alert
// signs for children 0–5 (spec 005 Decisiones de contenido).

import '../age/age_band.dart';
import 'alert_guide.dart';
import 'alert_sign.dart';

/// Medical disclaimer shown always, including the no-selection state (RF-3).
const String medicalDisclaimer =
    'Esta información es orientativa y no sustituye el consejo de un '
    'profesional de salud.';

const AlertLevel _urgency = AlertLevel.urgency;
const AlertLevel _scheduled = AlertLevel.scheduled;

const List<AlertGuide> _catalog = [
  AlertGuide(
    band: AgeBand.newborn0to3,
    label: '0–3 meses',
    rangeMonths: '[0,3)',
    areas: [
      AreaAlerts(
        area: AlertArea.grossMotor,
        label: 'Motricidad gruesa',
        signals: [
          AlertSignal(
            signal: 'Cianosis: coloración azulada o amoratada de labios o piel '
                'al respirar',
            level: _urgency,
            action: 'Acude a urgencias de inmediato.',
          ),
          AlertSignal(
            signal: 'No levanta la cabeza un poco al estar boca abajo',
            level: _scheduled,
            action: 'Consulta pronto con tu pediatra (en 24–48 h).',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.fineMotor,
        label: 'Motricidad fina',
        signals: [
          AlertSignal(
            signal: 'Manos siempre cerradas en puño y no las abre para tocar',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.language,
        label: 'Lenguaje',
        signals: [
          AlertSignal(
            signal: 'No reacciona a sonidos fuertes',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.socialEmotional,
        label: 'Social/afectivo',
        signals: [
          AlertSignal(
            signal: 'No fija la mirada en tu cara',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.cognitive,
        label: 'Cognitivo',
        signals: [
          AlertSignal(
            signal: 'Convulsión: movimiento que se repite sin control y puede '
                'hacer perder el conocimiento',
            level: _urgency,
            action: 'Acude a urgencias de inmediato.',
          ),
          AlertSignal(
            signal: 'No sigue con la mirada un objeto en movimiento',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
        ],
      ),
    ],
    medicalDisclaimer: medicalDisclaimer,
  ),
  AlertGuide(
    band: AgeBand.infant3to12,
    label: '3–12 meses',
    rangeMonths: '[3,12)',
    areas: [
      AreaAlerts(
        area: AlertArea.grossMotor,
        label: 'Motricidad gruesa',
        signals: [
          AlertSignal(
            signal: 'No se sienta solo hacia los 9 meses',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
          AlertSignal(
            signal: 'Convulsión: movimiento que se repite sin control y puede '
                'hacer perder el conocimiento',
            level: _urgency,
            action: 'Acude a urgencias de inmediato.',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.fineMotor,
        label: 'Motricidad fina',
        signals: [
          AlertSignal(
            signal: 'No pasa un objeto de una mano a la otra hacia los 7 meses',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.language,
        label: 'Lenguaje',
        signals: [
          AlertSignal(
            signal: 'No balbucea (no hace sonidos sin sentido) hacia los 6 '
                'meses',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.cognitive,
        label: 'Cognitivo',
        signals: [
          AlertSignal(
            signal: 'Letargo: mucho sueño o mucha dificultad para despertar',
            level: _urgency,
            action: 'Acude a urgencias de inmediato.',
          ),
        ],
      ),
    ],
    medicalDisclaimer: medicalDisclaimer,
  ),
  AlertGuide(
    band: AgeBand.toddler12to36,
    label: '1–3 años',
    rangeMonths: '[12,36)',
    areas: [
      AreaAlerts(
        area: AlertArea.fineMotor,
        label: 'Motricidad fina',
        signals: [
          AlertSignal(
            signal: 'No usa la pinza (no coge objetos pequeños con pulgar e '
                'índice) hacia los 18 meses',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.language,
        label: 'Lenguaje',
        signals: [
          AlertSignal(
            signal: 'No dice palabras sueltas hacia los 18 meses',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.socialEmotional,
        label: 'Social/afectivo',
        signals: [
          AlertSignal(
            signal: 'No juega a imitar los gestos de otras personas',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.cognitive,
        label: 'Cognitivo',
        signals: [
          AlertSignal(
            signal: 'Deshidratación grave: el cuerpo pierde más líquido del '
                'que recibe (boca seca, pocos pañales mojados, fontanela '
                'hundida)',
            level: _urgency,
            action: 'Acude a urgencias de inmediato.',
          ),
          AlertSignal(
            signal: 'Pierde habilidades que ya tenía (dejó de decir palabras '
                'que sabía)',
            level: _scheduled,
            action: 'Consulta pronto con tu pediatra (en 24–48 h).',
          ),
        ],
      ),
    ],
    medicalDisclaimer: medicalDisclaimer,
  ),
  AlertGuide(
    band: AgeBand.child36to60,
    label: '4–5 años',
    rangeMonths: '[36,60]',
    areas: [
      AreaAlerts(
        area: AlertArea.grossMotor,
        label: 'Motricidad gruesa',
        signals: [
          AlertSignal(
            signal: 'No se mantiene sobre un pie unos segundos',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.fineMotor,
        label: 'Motricidad fina',
        signals: [
          AlertSignal(
            signal: 'No dibuja una cruz simple ni abotona',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.language,
        label: 'Lenguaje',
        signals: [
          AlertSignal(
            signal: 'Su lenguaje resulta difícil de entender para otros',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.socialEmotional,
        label: 'Social/afectivo',
        signals: [
          AlertSignal(
            signal: 'Separación: llanto o angustia intensa que no cede al '
                'separarse de su cuidador principal',
            level: _scheduled,
            action: 'Consulta con tu pediatra.',
          ),
        ],
      ),
      AreaAlerts(
        area: AlertArea.cognitive,
        label: 'Cognitivo',
        signals: [
          AlertSignal(
            signal: 'Convulsión: movimiento que se repite sin control y puede '
                'hacer perder el conocimiento',
            level: _urgency,
            action: 'Acude a urgencias de inmediato.',
          ),
          AlertSignal(
            signal: 'Pierde habilidades de comunicación que ya tenía',
            level: _scheduled,
            action: 'Consulta pronto con tu pediatra (en 24–48 h).',
          ),
        ],
      ),
    ],
    medicalDisclaimer: medicalDisclaimer,
  ),
];

/// Returns the alert guide for [band], or `null` when no band is selected
/// (RF-1, CL-1).
AlertGuide? contentFor(AgeBand? band) {
  if (band == null) return null;
  for (final guide in _catalog) {
    if (guide.band == band) return guide;
  }
  return null;
}
