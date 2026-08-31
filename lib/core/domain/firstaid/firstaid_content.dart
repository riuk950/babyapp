// First-aid content source (spec 007). Guides for each emergency x age-band
// combination live here as typed constants — deterministic (RF-5), synchronous
// and without I/O. Pure Dart: must not import Flutter (constitution §3A).
//
// Sources: paediatric first-aid guidance from the Red Cross, the AAP and SEMES
// (spec 007 Decisiones de contenido), reviewed 31-ago-2026.

import '../age/age_band.dart';
import 'emergency_type.dart';
import 'firstaid_guide.dart';
import 'firstaid_step.dart';
import 'severity_level.dart';

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

/// Returns the 12 emergency situations (RF-1).
List<EmergencyType> availableEmergencies() =>
    List.unmodifiable(EmergencyType.values);

/// Combines band label and range for the selector option (RF-2).
String bandOption(AgeBand band) => '${_bandLabel(band)} · ${_bandRange(band)}';

const Map<EmergencyType, Map<AgeBand, EmergencyGuide>> _guides = {
  EmergencyType.choking: {
    AgeBand.newborn0to3: EmergencyGuide(
      emergency: EmergencyType.choking,
      ageBand: AgeBand.newborn0to3,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Comprueba si el bebé tose, llora o respira.'),
        FirstAidStep(order: 2, text: 'Si no respira, colócalo boca abajo sobre tu antebrazo, con la cabeza más baja que el cuerpo.'),
        FirstAidStep(order: 3, text: 'Da 5 golpes firmes en la espalda, entre los omóplatos.'),
        FirstAidStep(order: 4, text: 'Llama a emergencias si sigue sin respirar.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No introduzcas los dedos en la boca del bebé a ciegas.'),
        FirstAidStep(order: 2, text: 'No le des agua, leche ni alimentos.'),
      ],
    ),
    AgeBand.infant3to12: EmergencyGuide(
      emergency: EmergencyType.choking,
      ageBand: AgeBand.infant3to12,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Comprueba si el bebé tose, llora o respira.'),
        FirstAidStep(order: 2, text: 'Si tose con fuerza, anímalo a seguir tosiendo.'),
        FirstAidStep(order: 3, text: 'Si no respira, colócalo boca abajo y da 5 golpes entre los omóplatos.'),
        FirstAidStep(order: 4, text: 'Llama a emergencias si sigue obstruido.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No hagas el barrido digital a ciegas en la boca.'),
        FirstAidStep(order: 2, text: 'No le des agua para "ayudarle a pasar" la obstrucción.'),
      ],
    ),
    AgeBand.toddler12to36: EmergencyGuide(
      emergency: EmergencyType.choking,
      ageBand: AgeBand.toddler12to36,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Anima al niño a toser con fuerza si puede hacerlo.'),
        FirstAidStep(order: 2, text: 'Si no tose ni respira, colócate detrás y aplica compresiones abdominales.'),
        FirstAidStep(order: 3, text: 'Alterna 5 golpes en la espalda con 5 compresiones abdominales.'),
        FirstAidStep(order: 4, text: 'Llama a emergencias si la obstrucción persiste.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No introduzcas los dedos en la boca si no ves el objeto.'),
        FirstAidStep(order: 2, text: 'No le des líquidos para bajar el objeto atascado.'),
      ],
    ),
    AgeBand.child36to60: EmergencyGuide(
      emergency: EmergencyType.choking,
      ageBand: AgeBand.child36to60,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Anima al niño a toser con fuerza si puede hacerlo.'),
        FirstAidStep(order: 2, text: 'Si no tose ni respira, aplica compresiones abdominales desde detrás.'),
        FirstAidStep(order: 3, text: 'Alterna 5 golpes en la espalda con 5 compresiones abdominales.'),
        FirstAidStep(order: 4, text: 'Llama a emergencias si el niño queda inconsciente.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No realices compresiones si el niño tose con fuerza.'),
        FirstAidStep(order: 2, text: 'No le des alimentos ni bebidas mientras esté obstruido.'),
      ],
    ),
  },
  EmergencyType.burns: {
    AgeBand.newborn0to3: EmergencyGuide(
      emergency: EmergencyType.burns,
      ageBand: AgeBand.newborn0to3,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Enfría la zona con agua corriente fresca durante 10–20 minutos.'),
        FirstAidStep(order: 2, text: 'Retira con cuidado la ropa que no esté pegada a la piel.'),
        FirstAidStep(order: 3, text: 'Cubre la quemadura con un paño limpio o apósito estéril.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No apliques hielo directo sobre la piel.'),
        FirstAidStep(order: 2, text: 'No revientes las ampollas que puedan formarse.'),
        FirstAidStep(order: 3, text: 'No uses pomadas, mantequilla ni pasta de dientes.'),
      ],
    ),
    AgeBand.infant3to12: EmergencyGuide(
      emergency: EmergencyType.burns,
      ageBand: AgeBand.infant3to12,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Enfría la quemadura con agua corriente fresca durante 10–20 minutos.'),
        FirstAidStep(order: 2, text: 'Retira anillos o ropa si no están pegados a la piel.'),
        FirstAidStep(order: 3, text: 'Cubre con un apósito limpio y consulta al pediatra.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No apliques hielo directo.'),
        FirstAidStep(order: 2, text: 'No revientes las ampollas.'),
        FirstAidStep(order: 3, text: 'No apliques remedios caseros sobre la herida.'),
      ],
    ),
    AgeBand.toddler12to36: EmergencyGuide(
      emergency: EmergencyType.burns,
      ageBand: AgeBand.toddler12to36,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Enfría la zona con agua corriente durante 10–20 minutos.'),
        FirstAidStep(order: 2, text: 'Retira la ropa que no esté pegada y cubre con un paño limpio.'),
        FirstAidStep(order: 3, text: 'Consulta al pediatra para valorar la quemadura.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No apliques hielo ni agua muy fría.'),
        FirstAidStep(order: 2, text: 'No revientes las ampollas.'),
        FirstAidStep(order: 3, text: 'No apliques pomadas ni grasas.'),
      ],
    ),
    AgeBand.child36to60: EmergencyGuide(
      emergency: EmergencyType.burns,
      ageBand: AgeBand.child36to60,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Enfría la quemadura con agua corriente fresca 10–20 minutos.'),
        FirstAidStep(order: 2, text: 'Cubre con un apósito estéril sin apretar.'),
        FirstAidStep(order: 3, text: 'Consulta al pediatra si la zona duele mucho o es extensa.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No apliques hielo directo.'),
        FirstAidStep(order: 2, text: 'No revientes las ampollas.'),
        FirstAidStep(order: 3, text: 'No uses algodón que pueda dejar pelusa en la herida.'),
      ],
    ),
  },
  EmergencyType.falls: {
    AgeBand.newborn0to3: EmergencyGuide(
      emergency: EmergencyType.falls,
      ageBand: AgeBand.newborn0to3,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Mantén la calma y observa al bebé sin moverlo bruscamente.'),
        FirstAidStep(order: 2, text: 'Comprueba si respira con normalidad y está consciente.'),
        FirstAidStep(order: 3, text: 'Consulta al pediatra tras cualquier caída en esta edad.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No lo sacudas ni lo levantes con brusquedad.'),
        FirstAidStep(order: 2, text: 'No le des comida ni bebida hasta valorarlo.'),
      ],
    ),
    AgeBand.infant3to12: EmergencyGuide(
      emergency: EmergencyType.falls,
      ageBand: AgeBand.infant3to12,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Consuela al bebé y revisa que se mueve con normalidad.'),
        FirstAidStep(order: 2, text: 'Enfría el golpe con un paño frío si hay hinchazón.'),
        FirstAidStep(order: 3, text: 'Observa vómitos o somnolencia y consulta al pediatra.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No lo dejes dormir sin vigilancia tras el golpe.'),
        FirstAidStep(order: 2, text: 'No apliques hielo directo sobre la piel.'),
      ],
    ),
    AgeBand.toddler12to36: EmergencyGuide(
      emergency: EmergencyType.falls,
      ageBand: AgeBand.toddler12to36,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Tranquiliza al niño y valora si se mueve con normalidad.'),
        FirstAidStep(order: 2, text: 'Aplica frío con un paño sobre el golpe.'),
        FirstAidStep(order: 3, text: 'Vigila en casa y consulta si aparecen vómitos o somnolencia.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No lo dejes solo en las horas siguientes.'),
        FirstAidStep(order: 2, text: 'No le des analgésicos sin consultar.'),
      ],
    ),
    AgeBand.child36to60: EmergencyGuide(
      emergency: EmergencyType.falls,
      ageBand: AgeBand.child36to60,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Valora si el niño responde y se mueve con normalidad.'),
        FirstAidStep(order: 2, text: 'Aplica frío con un paño sobre la zona del golpe.'),
        FirstAidStep(order: 3, text: 'Consulta al pediatra si el dolor es intenso o no camina bien.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No lo fuerces a moverse si le duele.'),
        FirstAidStep(order: 2, text: 'No le des alimento ni bebida si está muy somnoliento.'),
      ],
    ),
  },
  EmergencyType.bitesStings: {
    AgeBand.newborn0to3: EmergencyGuide(
      emergency: EmergencyType.bitesStings,
      ageBand: AgeBand.newborn0to3,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Lava la zona con agua y jabón suave.'),
        FirstAidStep(order: 2, text: 'Aplica frío con un paño para reducir la hinchazón.'),
        FirstAidStep(order: 3, text: 'Consulta al pediatra, sobre todo si es mordedura de animal.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No apliques barro ni remedios caseros.'),
        FirstAidStep(order: 2, text: 'No rompas las ampollas de la picadura.'),
      ],
    ),
    AgeBand.infant3to12: EmergencyGuide(
      emergency: EmergencyType.bitesStings,
      ageBand: AgeBand.infant3to12,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Retira el aguijón raspando, sin pinzas si es posible.'),
        FirstAidStep(order: 2, text: 'Lava la zona con agua y jabón.'),
        FirstAidStep(order: 3, text: 'Aplica frío y consulta si se inflama mucho.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No aprietes el aguijón para extraerlo.'),
        FirstAidStep(order: 2, text: 'No apliques pasta de dientes ni vinagre.'),
      ],
    ),
    AgeBand.toddler12to36: EmergencyGuide(
      emergency: EmergencyType.bitesStings,
      ageBand: AgeBand.toddler12to36,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Retira el aguijón raspando con una tarjeta o uña.'),
        FirstAidStep(order: 2, text: 'Lava la zona y aplica frío local.'),
        FirstAidStep(order: 3, text: 'Consulta al pediatra ante hinchazón que crece o mordedura animal.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No aprietes ni pinches la zona de la picadura.'),
        FirstAidStep(order: 2, text: 'No apliques remedios caseros sobre la herida.'),
      ],
    ),
    AgeBand.child36to60: EmergencyGuide(
      emergency: EmergencyType.bitesStings,
      ageBand: AgeBand.child36to60,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Lava la zona con agua y jabón.'),
        FirstAidStep(order: 2, text: 'Aplica frío para calmar el picor y la hinchazón.'),
        FirstAidStep(order: 3, text: 'Consulta si sospechas mordedura de animal o mala evolución.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No rasques ni rompas la piel de la picadura.'),
        FirstAidStep(order: 2, text: 'No apliques sustancias caseras no indicadas.'),
      ],
    ),
  },
  EmergencyType.seizures: {
    AgeBand.newborn0to3: EmergencyGuide(
      emergency: EmergencyType.seizures,
      ageBand: AgeBand.newborn0to3,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Coloca al bebé de lado sobre una superficie blanda.'),
        FirstAidStep(order: 2, text: 'Aparta objetos que puedan herirlo.'),
        FirstAidStep(order: 3, text: 'Cronometra la duración de la crisis.'),
        FirstAidStep(order: 4, text: 'Llama a emergencias, sobre todo si dura más de 5 minutos.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No sujetes ni contengas los movimientos del bebé.'),
        FirstAidStep(order: 2, text: 'No introduzcas nada en su boca.'),
        FirstAidStep(order: 3, text: 'No le des agua ni medicación por vía oral.'),
      ],
    ),
    AgeBand.infant3to12: EmergencyGuide(
      emergency: EmergencyType.seizures,
      ageBand: AgeBand.infant3to12,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Coloca al bebé de lado en un lugar seguro.'),
        FirstAidStep(order: 2, text: 'Retira objetos que puedan causar daño.'),
        FirstAidStep(order: 3, text: 'Cronometra la crisis y llama a emergencias.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No introduzcas nada en la boca.'),
        FirstAidStep(order: 2, text: 'No sujetes al bebé ni restrinjas sus movimientos.'),
      ],
    ),
    AgeBand.toddler12to36: EmergencyGuide(
      emergency: EmergencyType.seizures,
      ageBand: AgeBand.toddler12to36,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Coloca al niño de lado sobre una superficie blanda.'),
        FirstAidStep(order: 2, text: 'Aleja objetos peligrosos de su alrededor.'),
        FirstAidStep(order: 3, text: 'Controla la duración y llama a emergencias.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No le introduzcas nada en la boca.'),
        FirstAidStep(order: 2, text: 'No lo sujetes ni intentes frenar la crisis.'),
      ],
    ),
    AgeBand.child36to60: EmergencyGuide(
      emergency: EmergencyType.seizures,
      ageBand: AgeBand.child36to60,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Coloca al niño de lado en un lugar seguro.'),
        FirstAidStep(order: 2, text: 'Aleja objetos y observa la duración.'),
        FirstAidStep(order: 3, text: 'Llama a emergencias si dura más de 5 minutos o es la primera vez.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No introduzcas objetos en su boca.'),
        FirstAidStep(order: 2, text: 'No lo sujetes durante la crisis.'),
      ],
    ),
  },
  EmergencyType.highFever: {
    AgeBand.newborn0to3: EmergencyGuide(
      emergency: EmergencyType.highFever,
      ageBand: AgeBand.newborn0to3,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Mide la temperatura con termómetro rectal.'),
        FirstAidStep(order: 2, text: 'Desabriga al bebé y ofrece hidratación frecuente.'),
        FirstAidStep(order: 3, text: 'Consulta en urgencias: fiebre en un bebé menor de 3 meses siempre es grave.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No administres antitérmicos sin indicación médica.'),
        FirstAidStep(order: 2, text: 'No apliques agua fría o alcohol para bajar la fiebre.'),
      ],
    ),
    AgeBand.infant3to12: EmergencyGuide(
      emergency: EmergencyType.highFever,
      ageBand: AgeBand.infant3to12,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Mide la temperatura y observa el estado general del bebé.'),
        FirstAidStep(order: 2, text: 'Ofrece líquidos y evita arroparlo en exceso.'),
        FirstAidStep(order: 3, text: 'Consulta al pediatra si la fiebre es alta o dura más de 48 horas.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No alternes antitérmicos sin indicación.'),
        FirstAidStep(order: 2, text: 'No apliques frío intenso ni alcohol.'),
      ],
    ),
    AgeBand.toddler12to36: EmergencyGuide(
      emergency: EmergencyType.highFever,
      ageBand: AgeBand.toddler12to36,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Mide la temperatura y valora el estado general.'),
        FirstAidStep(order: 2, text: 'Hidrata al niño y mantén la ropa ligera.'),
        FirstAidStep(order: 3, text: 'Consulta al pediatra si la fiebre no cede o hay decaimiento.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No lo abrigues en exceso.'),
        FirstAidStep(order: 2, text: 'No le des aspirina.'),
      ],
    ),
    AgeBand.child36to60: EmergencyGuide(
      emergency: EmergencyType.highFever,
      ageBand: AgeBand.child36to60,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Mide la temperatura y observa el estado general.'),
        FirstAidStep(order: 2, text: 'Ofrece líquidos y vigilancia en casa.'),
        FirstAidStep(order: 3, text: 'Consulta al pediatra si persiste o empeora.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No alternes antitérmicos sin supervisión médica.'),
        FirstAidStep(order: 2, text: 'No apliques baños de agua fría.'),
      ],
    ),
  },
  EmergencyType.bleedingWounds: {
    AgeBand.newborn0to3: EmergencyGuide(
      emergency: EmergencyType.bleedingWounds,
      ageBand: AgeBand.newborn0to3,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Presiona directamente la herida con un paño limpio.'),
        FirstAidStep(order: 2, text: 'Mantén la presión sin retirar el paño si empapa.'),
        FirstAidStep(order: 3, text: 'Consulta si el sangrado no cesa o la herida es profunda.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No retires el paño para "mirar" mientras sangra.'),
        FirstAidStep(order: 2, text: 'No apliques alcohol directamente en la herida abierta.'),
      ],
    ),
    AgeBand.infant3to12: EmergencyGuide(
      emergency: EmergencyType.bleedingWounds,
      ageBand: AgeBand.infant3to12,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Presiona la herida con un paño limpio para frenar el sangrado.'),
        FirstAidStep(order: 2, text: 'Lava suavemente con agua y jabón al cesar la hemorragia.'),
        FirstAidStep(order: 3, text: 'Consulta si el corte es profundo o requiere puntos.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No retires el paño mientras sigue sangrando.'),
        FirstAidStep(order: 2, text: 'No apliques algodón directo sobre la herida.'),
      ],
    ),
    AgeBand.toddler12to36: EmergencyGuide(
      emergency: EmergencyType.bleedingWounds,
      ageBand: AgeBand.toddler12to36,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Aplica presión directa con un paño limpio.'),
        FirstAidStep(order: 2, text: 'Lava con agua y jabón al controlar el sangrado.'),
        FirstAidStep(order: 3, text: 'Consulta si el corte es profundo o el sangrado abundante.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No uses torniquetes salvo indicación.'),
        FirstAidStep(order: 2, text: 'No apliques sustancias sobre la herida abierta.'),
      ],
    ),
    AgeBand.child36to60: EmergencyGuide(
      emergency: EmergencyType.bleedingWounds,
      ageBand: AgeBand.child36to60,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Presiona la herida con un paño limpio.'),
        FirstAidStep(order: 2, text: 'Lava la zona con agua y jabón.'),
        FirstAidStep(order: 3, text: 'Consulta si sangra mucho o no se detiene.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No retires objetos clavados en la herida.'),
        FirstAidStep(order: 2, text: 'No apliques torniquetes salvo indicación médica.'),
      ],
    ),
  },
  EmergencyType.poisoning: {
    AgeBand.newborn0to3: EmergencyGuide(
      emergency: EmergencyType.poisoning,
      ageBand: AgeBand.newborn0to3,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Retira la sustancia del alcance del bebé.'),
        FirstAidStep(order: 2, text: 'Conserva el envase o residuos de lo ingerido.'),
        FirstAidStep(order: 3, text: 'Llama a urgencias o al centro de intoxicaciones inmediatamente.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No induzcas el vómito sin indicación.'),
        FirstAidStep(order: 2, text: 'No le des leche ni agua para "diluir" el tóxico sin indicación.'),
      ],
    ),
    AgeBand.infant3to12: EmergencyGuide(
      emergency: EmergencyType.poisoning,
      ageBand: AgeBand.infant3to12,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Aleja la sustancia y comprueba si hay restos en la boca.'),
        FirstAidStep(order: 2, text: 'Guarda el envase para identificarlo.'),
        FirstAidStep(order: 3, text: 'Llama a urgencias o al centro de intoxicaciones.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No induzcas el vómito sin indicación médica.'),
        FirstAidStep(order: 2, text: 'No le des líquidos para "limpiar" sin indicación.'),
      ],
    ),
    AgeBand.toddler12to36: EmergencyGuide(
      emergency: EmergencyType.poisoning,
      ageBand: AgeBand.toddler12to36,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Retira la sustancia y revisa la boca del niño.'),
        FirstAidStep(order: 2, text: 'Conserva el envase de la sustancia.'),
        FirstAidStep(order: 3, text: 'Llama a urgencias o al centro de intoxicaciones de inmediato.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No induzcas el vómito sin indicación.'),
        FirstAidStep(order: 2, text: 'No le des alimento ni bebida sin indicación.'),
      ],
    ),
    AgeBand.child36to60: EmergencyGuide(
      emergency: EmergencyType.poisoning,
      ageBand: AgeBand.child36to60,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Retira la sustancia y evalúa al niño.'),
        FirstAidStep(order: 2, text: 'Conserva el envase de lo ingerido.'),
        FirstAidStep(order: 3, text: 'Llama a urgencias o al centro de intoxicaciones.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No provoques el vómito sin indicación.'),
        FirstAidStep(order: 2, text: 'No le des remedios caseros.'),
      ],
    ),
  },
  EmergencyType.headInjury: {
    AgeBand.newborn0to3: EmergencyGuide(
      emergency: EmergencyType.headInjury,
      ageBand: AgeBand.newborn0to3,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Mantén al bebé quieto y observa su nivel de consciencia.'),
        FirstAidStep(order: 2, text: 'Vigila vómitos, somnolencia o llanto inconsolable.'),
        FirstAidStep(order: 3, text: 'Acude a urgencias en un bebé menor de 3 meses tras golpearse la cabeza.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No lo dejes dormir sin vigilancia estrecha.'),
        FirstAidStep(order: 2, text: 'No lo muevas bruscamente.'),
      ],
    ),
    AgeBand.infant3to12: EmergencyGuide(
      emergency: EmergencyType.headInjury,
      ageBand: AgeBand.infant3to12,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Observa si el bebé está despierto y responde.'),
        FirstAidStep(order: 2, text: 'Aplica frío con un paño sobre el bulto.'),
        FirstAidStep(order: 3, text: 'Acude a urgencias si hay vómitos o pérdida de consciencia.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No lo dejes solo sin observación.'),
        FirstAidStep(order: 2, text: 'No apliques hielo directo.'),
      ],
    ),
    AgeBand.toddler12to36: EmergencyGuide(
      emergency: EmergencyType.headInjury,
      ageBand: AgeBand.toddler12to36,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Valora si el niño está despierto y se comporta con normalidad.'),
        FirstAidStep(order: 2, text: 'Aplica frío con un paño sobre el golpe.'),
        FirstAidStep(order: 3, text: 'Vigila en casa y consulta si aparecen vómitos o somnolencia.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No lo dejes dormir sin vigilarlo.'),
        FirstAidStep(order: 2, text: 'No le des analgésicos sin consultar.'),
      ],
    ),
    AgeBand.child36to60: EmergencyGuide(
      emergency: EmergencyType.headInjury,
      ageBand: AgeBand.child36to60,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Observa si el niño responde con normalidad.'),
        FirstAidStep(order: 2, text: 'Aplica frío con un paño sobre el golpe.'),
        FirstAidStep(order: 3, text: 'Consulta o acude a urgencias si hay vómitos o confusión.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No lo dejes solo tras el golpe.'),
        FirstAidStep(order: 2, text: 'No le des alimento si está muy somnoliento.'),
      ],
    ),
  },
  EmergencyType.anaphylaxis: {
    AgeBand.newborn0to3: EmergencyGuide(
      emergency: EmergencyType.anaphylaxis,
      ageBand: AgeBand.newborn0to3,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Llama a emergencias inmediatamente.'),
        FirstAidStep(order: 2, text: 'Administra el autoinyector de adrenalina si lo tienes indicado.'),
        FirstAidStep(order: 3, text: 'Coloca al bebé tumbado con las piernas elevadas si respira.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No demores en llamar a emergencias.'),
        FirstAidStep(order: 2, text: 'No le des alimentos ni bebidas.'),
      ],
    ),
    AgeBand.infant3to12: EmergencyGuide(
      emergency: EmergencyType.anaphylaxis,
      ageBand: AgeBand.infant3to12,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Llama a emergencias de inmediato.'),
        FirstAidStep(order: 2, text: 'Aplica el autoinyector de adrenalina si está indicado.'),
        FirstAidStep(order: 3, text: 'Mantén al bebé tumbado y observa la respiración.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No esperes a ver si "se le pasa".'),
        FirstAidStep(order: 2, text: 'No le des ni comida ni bebida.'),
      ],
    ),
    AgeBand.toddler12to36: EmergencyGuide(
      emergency: EmergencyType.anaphylaxis,
      ageBand: AgeBand.toddler12to36,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Llama a emergencias inmediatamente.'),
        FirstAidStep(order: 2, text: 'Usa el autoinyector de adrenalina si está indicado.'),
        FirstAidStep(order: 3, text: 'Tumba al niño y vigila su respiración.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No lo pongas de pie si se marea.'),
        FirstAidStep(order: 2, text: 'No le des alimento ni bebida.'),
      ],
    ),
    AgeBand.child36to60: EmergencyGuide(
      emergency: EmergencyType.anaphylaxis,
      ageBand: AgeBand.child36to60,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Llama a emergencias de inmediato.'),
        FirstAidStep(order: 2, text: 'Administra el autoinyector de adrenalina si está indicado.'),
        FirstAidStep(order: 3, text: 'Coloca al niño tumbado y observa la respiración.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No dudes ni esperes a que empeore.'),
        FirstAidStep(order: 2, text: 'No le ofrezcas alimentos ni bebidas.'),
      ],
    ),
  },
  EmergencyType.drowning: {
    AgeBand.newborn0to3: EmergencyGuide(
      emergency: EmergencyType.drowning,
      ageBand: AgeBand.newborn0to3,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Saca al bebé del agua con cuidado sin arriesgarte.'),
        FirstAidStep(order: 2, text: 'Comprueba si respira y si está consciente.'),
        FirstAidStep(order: 3, text: 'Llama a emergencias y, si no respira, inicia reanimación.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No pierdas tiempo intentando sacar el agua de los pulmones.'),
        FirstAidStep(order: 2, text: 'No apliques compresiones abdominales para drenar.'),
      ],
    ),
    AgeBand.infant3to12: EmergencyGuide(
      emergency: EmergencyType.drowning,
      ageBand: AgeBand.infant3to12,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Saca al bebé del agua de inmediato.'),
        FirstAidStep(order: 2, text: 'Comprueba respiración y pulso.'),
        FirstAidStep(order: 3, text: 'Llama a emergencias y comienza reanimación si no respira.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No esperes a secarlo o cambiarlo de ropa.'),
        FirstAidStep(order: 2, text: 'No intentes drenar agua del pecho por golpes en la espalda.'),
      ],
    ),
    AgeBand.toddler12to36: EmergencyGuide(
      emergency: EmergencyType.drowning,
      ageBand: AgeBand.toddler12to36,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Retira al niño del agua con seguridad.'),
        FirstAidStep(order: 2, text: 'Comprueba si respira y está consciente.'),
        FirstAidStep(order: 3, text: 'Llama a emergencias e inicia reanimación si es necesario.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No demores la llamada a emergencias.'),
        FirstAidStep(order: 2, text: 'No intentes drenar el agua por las vías de forma casera.'),
      ],
    ),
    AgeBand.child36to60: EmergencyGuide(
      emergency: EmergencyType.drowning,
      ageBand: AgeBand.child36to60,
      severity: SeverityLevel.urgency,
      steps: [
        FirstAidStep(order: 1, text: 'Saca al niño del agua con precaución.'),
        FirstAidStep(order: 2, text: 'Comprueba respiración y consciencia.'),
        FirstAidStep(order: 3, text: 'Llama a emergencias e inicia reanimación si no respira.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No pierdas tiempo en maniobras de drenaje.'),
        FirstAidStep(order: 2, text: 'No lo dejes solo, aunque parezca recuperado.'),
      ],
    ),
  },
  EmergencyType.foreignObject: {
    AgeBand.newborn0to3: EmergencyGuide(
      emergency: EmergencyType.foreignObject,
      ageBand: AgeBand.newborn0to3,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Mantén la calma y evita que el bebé se toque la zona.'),
        FirstAidStep(order: 2, text: 'Si está en la nariz u oído, no intentes extraerlo a ciegas.'),
        FirstAidStep(order: 3, text: 'Consulta al pediatra o acude a urgencias.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No introduzcas pinzas ni hisopos en el oído o la nariz.'),
        FirstAidStep(order: 2, text: 'No frotes el ojo.'),
      ],
    ),
    AgeBand.infant3to12: EmergencyGuide(
      emergency: EmergencyType.foreignObject,
      ageBand: AgeBand.infant3to12,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Evita que el bebé se introduzca más el objeto con sus manos.'),
        FirstAidStep(order: 2, text: 'Consulta al pediatra para valorar cómo extraerlo.'),
        FirstAidStep(order: 3, text: 'Si es en el ojo, lava con suero fisiológico sin frotar.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No intentes sacarlo con pinzas a ciegas.'),
        FirstAidStep(order: 2, text: 'No frotes el ojo.'),
      ],
    ),
    AgeBand.toddler12to36: EmergencyGuide(
      emergency: EmergencyType.foreignObject,
      ageBand: AgeBand.toddler12to36,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Pide al niño que sople suavemente para expulsar el objeto de la nariz.'),
        FirstAidStep(order: 2, text: 'Si está en el oído, no intentes extraerlo.'),
        FirstAidStep(order: 3, text: 'Consulta al pediatra o acude a urgencias.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No introduzcas objetos para intentar sacar el cuerpo extraño.'),
        FirstAidStep(order: 2, text: 'No frotes el ojo.'),
      ],
    ),
    AgeBand.child36to60: EmergencyGuide(
      emergency: EmergencyType.foreignObject,
      ageBand: AgeBand.child36to60,
      severity: SeverityLevel.consult,
      steps: [
        FirstAidStep(order: 1, text: 'Anima al niño a sonarse la nariz suavemente si el objeto está ahí.'),
        FirstAidStep(order: 2, text: 'Si está en el ojo, lava con suero fisiológico sin frotar.'),
        FirstAidStep(order: 3, text: 'Consulta al pediatra si no sale o duele.'),
      ],
      doNot: [
        FirstAidStep(order: 1, text: 'No intentes extraer objetos del oído con instrumentos.'),
        FirstAidStep(order: 2, text: 'No dejes que el niño se introduzca más el objeto.'),
      ],
    ),
  },
};

/// Returns the guide for an [emergency] within a [band], or `null` when either
/// the emergency or the band is missing (RF-1, RF-2, RF-3, CL-1, CL-2, CL-3).
EmergencyGuide? contentFor(EmergencyType? emergency, AgeBand? band) {
  if (emergency == null || band == null) return null;
  return _guides[emergency]?[band];
}
