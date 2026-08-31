// Content source for the daily-routine tips feature (spec 006 §3). Tips for
// each moment x band combination live here as typed constants — deterministic
// (RF-5), synchronous and without I/O. Pure Dart: must not import Flutter
// (constitution §3A).
//
// Sources: WHO (OMS) and AAP paediatric guidance on sleep, feeding,
// stimulation and daily care in early childhood (spec 006 Decisiones de
// contenido).

import '../age/age_band.dart';
import 'routine_moment.dart';
import 'routine_tip.dart';

/// Medical disclaimer shown always, including no-selection states (RF-6).
const String medicalDisclaimer =
    'Esta información es orientativa y no sustituye el consejo de un '
    'profesional de salud.';

/// Short Spanish label for a band (RF-2), matching the shared boundaries.
String _bandLabel(AgeBand band) {
  switch (band) {
    case AgeBand.newborn0to3:
      return '0–3 meses';
    case AgeBand.infant3to12:
      return '3–12 meses';
    case AgeBand.toddler12to36:
      return '1–3 años';
    case AgeBand.child36to60:
      return '4–5 años';
  }
}

/// Bounds of a band in months, e.g. "[0,3)" (RF-2, CL-3).
String _bandRange(AgeBand band) {
  switch (band) {
    case AgeBand.newborn0to3:
      return '[0,3)';
    case AgeBand.infant3to12:
      return '[3,12)';
    case AgeBand.toddler12to36:
      return '[12,36)';
    case AgeBand.child36to60:
      return '[36,60]';
  }
}

/// Returns the 6 moments of the day (RF-1).
List<RoutineMoment> availableMoments() => List.unmodifiable(RoutineMoment.values);

/// Combines band label and range for the selector option (RF-2).
String bandOption(AgeBand band) => '${_bandLabel(band)} · ${_bandRange(band)}';

const Map<RoutineMoment, Map<AgeBand, List<RoutineTip>>> _tips = {
  RoutineMoment.morning: {
    AgeBand.newborn0to3: [
      RoutineTip(
        message:
            'Abre las cortinas para que la luz natural ayude a regular el '
            'ritmo circadiano del bebé.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Habla o canta al bebé mientras lo vistes para estimular su '
            'lenguaje.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.infant3to12: [
      RoutineTip(
        message:
            'Abre las cortinas al despertar y saluda al bebé para marcar el '
            'inicio del día.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Ofrece un rato de boca abajo visible para fortalecer cuello y '
            'espalda.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.toddler12to36: [
      RoutineTip(
        message:
            'Crea una rutina fija de mañana con desayuno, aseo y juego libre.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Invita al niño a participar al vestirse para fomentar su '
            'autonomía.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.child36to60: [
      RoutineTip(
        message: 'Establece una hora fija de despertar para regular su '
            'descanso.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Acompaña el desayuno conversando sobre el día que empieza.',
        source: 'Recomendación de la AAP',
      ),
    ],
  },
  RoutineMoment.nap: {
    AgeBand.newborn0to3: [
      RoutineTip(
        message:
            'Respeta las siestas cortas al primer signo de sueño sin forzar '
            'un horario.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Ambienta la habitación con poca luz para que la siesta sea '
            'reparadora.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.infant3to12: [
      RoutineTip(
        message:
            'Mantén una rutina corta de siesta (canción o mecer) antes de '
            'dormir.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Acuesta al bebé despierto pero somnoliento para que aprenda a '
            'dormirse solo.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.toddler12to36: [
      RoutineTip(
        message:
            'Establece una siesta a la misma hora cada día para consolidar su '
            'ritmo.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message: 'Reduce la duración de la siesta si dificulta el sueño '
            'nocturno.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.child36to60: [
      RoutineTip(
        message:
            'Ofrece una siesta o un rato de descanso tranquilo si el niño aún '
            'se cansa.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message: 'Ajusta la siesta para no retrasar la hora de acostarse.',
        source: 'Recomendación de la AAP',
      ),
    ],
  },
  RoutineMoment.bath: {
    AgeBand.newborn0to3: [
      RoutineTip(
        message:
            'Baña al bebé con agua tibia (37 °C) en un ambiente cálido y sin '
            'corrientes.',
        source: 'Recomendación de la AAP',
      ),
      RoutineTip(
        message: 'Seca bien los pliegues de la piel para evitar irritaciones.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.infant3to12: [
      RoutineTip(
        message:
            'Usa el baño como rutina relajante antes de la noche, siempre a la '
            'misma hora.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Lava con jabón suave y aclara bien para no resecar la piel.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.toddler12to36: [
      RoutineTip(
        message:
            'Haz del baño un momento de juego tranquilo supervisado en la '
            'bañera.',
        source: 'Recomendación de la AAP',
      ),
      RoutineTip(
        message:
            'Prepara el baño con todo a mano y sin agua en exceso para mayor '
            'seguridad.',
        source: 'Recomendación de la OMS',
      ),
    ],
    AgeBand.child36to60: [
      RoutineTip(
        message:
            'Acompaña el baño con agua templada y un jabón suave para cuidar '
            'su piel.',
        source: 'Recomendación de la AAP',
      ),
      RoutineTip(
        message:
            'Aprovecha el baño para un momento de calma y conversación del '
            'día.',
        source: 'Recomendación de la OMS',
      ),
    ],
  },
  RoutineMoment.feeding: {
    AgeBand.newborn0to3: [
      RoutineTip(
        message:
            'Ofrece el pecho a demanda, al menos 8–12 veces al día, para '
            'asegurar una buena lactancia.',
        source: 'Recomendación de la OMS lactancia',
      ),
      RoutineTip(
        message:
            'Sigue la señal de hambre del bebé y no esperes a que llore para '
            'amamantar.',
        source: 'Recomendación de la OMS lactancia',
      ),
    ],
    AgeBand.infant3to12: [
      RoutineTip(
        message:
            'Introduce alimentos complementarios desde los 6 meses manteniendo '
            'la lactancia.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Ofrece un alimento nuevo a la vez y con calma para aceptar '
            'nuevos sabores.',
        source: 'Recomendación de la OMS',
      ),
    ],
    AgeBand.toddler12to36: [
      RoutineTip(
        message:
            'Ofrece comidas variadas y en porciones pequeñas para respetar su '
            'apetito.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Establece horarios fijos de comida y evita distracciones como la '
            'pantalla.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.child36to60: [
      RoutineTip(
        message:
            'Acompaña las comidas en familia para modelar hábitos '
            'saludables.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Invita al niño a probar alimentos, sin forzar, para ampliar su '
            'dieta.',
        source: 'Recomendación de la AAP',
      ),
    ],
  },
  RoutineMoment.play: {
    AgeBand.newborn0to3: [
      RoutineTip(
        message:
            'Juega cara a cara con el bebé para fortalecer el vínculo y su '
            'atención.',
        source: 'Recomendación de la AAP',
      ),
      RoutineTip(
        message:
            'Coloca juguetes sencillos en blanco y negro cerca de su vista.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.infant3to12: [
      RoutineTip(
        message:
            'Practica el juego de esconder y aparecer para desarrollar la '
            'permanencia del objeto.',
        source: 'Recomendación de la AAP',
      ),
      RoutineTip(
        message:
            'Lee en voz alta a diario para estimular el lenguaje desde '
            'pequeños.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.toddler12to36: [
      RoutineTip(
        message:
            'Juega a imitar sonidos y gestos para apoyar el desarrollo del '
            'lenguaje.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Ofrece juegos de apilar y encajar para practicar la '
            'coordinación.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.child36to60: [
      RoutineTip(
        message:
            'Invita a juegos de imaginar (como un bloque que es un teléfono) '
            'para potenciar la creatividad.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Practica juegos de turnos y reglas sencillas para aprender a '
            'compartir.',
        source: 'Recomendación de la AAP',
      ),
    ],
  },
  RoutineMoment.night: {
    AgeBand.newborn0to3: [
      RoutineTip(
        message:
            'Acuesta al bebé boca arriba en su cuna para dormir con '
            'seguridad.',
        source: 'Recomendación de la AAP',
      ),
      RoutineTip(
        message:
            'Mantén la noche tranquila y con luz tenue para distinguirla del '
            'día.',
        source: 'Recomendación de la OMS',
      ),
    ],
    AgeBand.infant3to12: [
      RoutineTip(
        message:
            'Establece una rutina fija de noche (baño, canción, acueste) para '
            'anticipar el sueño.',
        source: 'Recomendación de la AAP',
      ),
      RoutineTip(
        message:
            'Acuesta al bebé somnoliento pero despierto para que aprenda a '
            'dormir solo.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.toddler12to36: [
      RoutineTip(
        message:
            'Apunta una rutina constante de acueste a la misma hora cada '
            'noche.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Apaga pantallas al menos una hora antes de dormir para facilitar '
            'el sueño.',
        source: 'Recomendación de la AAP',
      ),
    ],
    AgeBand.child36to60: [
      RoutineTip(
        message:
            'Establece una hora fija de dormir y una rutina calmada para '
            'preparar el sueño.',
        source: 'Recomendación de la OMS',
      ),
      RoutineTip(
        message:
            'Reduce la luz y el ruido en casa al acercarse la hora de dormir.',
        source: 'Recomendación de la AAP',
      ),
    ],
  },
};

/// Returns the tips for a [moment] within a [band], or `null` when either the
/// moment or the band is missing (RF-1, RF-2, CL-1, CL-2).
List<RoutineTip>? tipsFor(RoutineMoment? moment, AgeBand? band) {
  if (moment == null || band == null) return null;
  return _tips[moment]?[band];
}
