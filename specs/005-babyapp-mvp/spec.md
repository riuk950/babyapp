# Especificación 005 — Señales de alerta

## Contexto y objetivo

Los padres y cuidadores necesitan distinguir cuáles señales en la salud o el
desarrollo de su hijo son esperables y cuáles requieren atención médica, y con
qué urgencia. Esta función ofrece una guía de referencia rápida: al elegir una
franja de edad, la usuaria ve las señales de alerta de las 5 áreas de desarrollo
(motricidad gruesa, motricidad fina, lenguaje, social/afectivo y cognitivo)
todas a la vez, cada una con una guía clara de cuándo buscar atención médica
(urgencia vs. consulta programada). Objetivo: reducir la incertidumbre y ayudar
a decidir cuándo y con qué urgencia buscar ayuda profesional, sin sustituir el
consejo médico.

## Usuarios

- Madres, padres y cuidadores de niños de 0 a 5 años.
- Sin formación técnica: la interfaz y el contenido deben ser claros y sin jerga.

## Historias de usuario

- HU-1: Como madre, quiero seleccionar la franja de edad de mi hijo, para ver
  las señales de alerta relevantes para su etapa.
- HU-2: Como usuaria, quiero ver las señales de alerta de las 5 áreas de
  desarrollo de una vez, para detectar cuál puede necesitar atención.
- HU-3: Como usuaria, quiero saber, ante cada señal, si debo acudir a urgencias
  o consultar con el pediatra, para actuar con la urgencia correcta.
- HU-4: Como usuaria, quiero identificar cuándo una señal merece atención para
  distinguir lo normal de lo preocupante.

## Requisitos funcionales

RF-1 — Selección de franja de edad
- The franjas serán las 4 globales de la app: 0–3 meses, 3–12 meses, 1–3 años y
  4–5 años, con límites [0,3), [3,12), [12,36) y [36,60] meses (fuente única
  compartida con las funciones 001 y 002).
- Where se muestra la lista de franjas, cada opción incluirá su etiqueta y su
  rango en meses, para guiar la elección incluso en los límites exactos (3, 12,
  36 meses).
- Where no hay franja seleccionada, el sistema pedirá elegir una y no mostrará
  contenido informativo (el aviso médico de RF-3 sí se muestra).
- When la usuaria selecciona una franja, el sistema mostrará las señales de
  alerta de esa franja.

RF-2 — Contenido de señales de alerta
- When hay una franja seleccionada, el sistema mostrará las señales de alerta de
  las 5 áreas de desarrollo (motricidad gruesa, motricidad fina, lenguaje,
  social/afectivo y cognitivo) de esa franja, todas a la vez en la misma
  pantalla.
- Where una franja no tiene señales en alguna de las 5 áreas, esa área se omite
  y no se muestra vacía (CL-10).
- The contenido se mostrará en lenguaje sencillo; los términos clínicos irán
  acompañados de una aclaración en lenguaje cotidiano (regla de redacción,
  inventario en Decisiones de contenido).

RF-3 — Guía de urgencia y aviso médico
- Where hay una franja seleccionada, el sistema mostrará, junto a cada señal de
  alerta, su guía de cuándo buscar atención médica con un nivel (dos niveles
  posibles, mutuamente excluyentes por señal): "urgencia" (acudir a urgencias)
  o "consulta programada" (pedir cita con el pediatra). Cada señal lleva un
  único nivel.
- The nivel de cada señal se mostrará con su texto de guía de acción y se
  distinguirá del contenido informativo dentro de la misma pantalla por el
  nivel y por texto, no solo por el color.
- Where una señal corresponde a un cuadro que requiere atención en el mismo día
  o en 24–48 h sin llegar a urgencias, el sistema la clasificará como "consulta
  programada" e incluirá la indicación de "consulta pronto" en su guía de
  acción (ver umbral en Decisiones de contenido).
- The aviso "Esta información es orientativa y no sustituye el consejo de un
  profesional de salud" se mostrará siempre, incluido el estado sin franja
  seleccionada (RF-1).

RF-4 — Cambio de franja
- When la usuaria cambia de franja con otra ya visible, el sistema sustituirá
  todo el contenido por el de la nueva franja sin acciones adicionales.

RF-5 — Respuesta determinista
- When se repite la selección de la misma franja, el sistema devolverá siempre
  el mismo contenido.

## Requisitos no funcionales

- RNF-1 Rendimiento: el contenido se muestra en la misma interacción, sin
  llamadas de red.
- RNF-2 Usabilidad: pantalla legible en ≥320 dp de ancho, con scroll para
  contenido largo (5 áreas × señales en una pantalla).
- RNF-3 Persistencia: ninguna; la selección de franja es estado efímero de
  sesión (app stateless) y no se conserva al reabrir la app.
- RNF-4 Mantenibilidad: el contenido y las reglas de franja viven aislados de
  la interfaz, en lógica pura.
- RNF-5 Accesibilidad: texto legible y con contraste suficiente; la guía de
  urgencia se distingue también por texto, no solo por color.
- RNF-6 Autonomía: funciona sin conexión, sin permisos y sin dependencias
  nuevas.

## Casos límite

- CL-1 Sin franja seleccionada: se pide elegir; no hay contenido informativo,
  pero el aviso médico (RF-3) sí se muestra.
- CL-2 Cambio rápido entre franjas: el contenido mostrado corresponde siempre a
  la última selección (RF-4); seleccionar la misma franja dos veces no cambia el
  estado (idempotencia).
- CL-3 Límites de las franjas: coinciden exactamente con las funciones 001/002 —
  [0,3), [3,12), [12,36) y [36,60] meses. En el límite exacto (3, 12, 36 meses)
  la lista muestra el rango de cada franja y la elección la decide la usuaria.
- CL-4 Contenido largo (5 áreas × señales): el scroll no corta ni oculta
  información.
- CL-5 Pantalla pequeña u orientación horizontal: el contenido sigue siendo
  legible (RNF-2).
- CL-6 Reinicio de la app: al reabrir no se conserva la selección (stateless,
  RNF-3) y se vuelve al estado sin franja.
- CL-7 Texto ampliado (zoom de accesibilidad): el contenido se mantiene legible
  con scroll, sin cortarse.
- CL-8 Cobertura 4/4: toda franja definida tiene señales en al menos un área y
  cada señal tiene su nivel de urgencia ("urgencia" o "consulta programada").
  Que una franja tenga señales en las 5 áreas es esperado por contenido, pero
  no se exige como invarianza (una franja puede omitir un área sin señales).
- CL-9 Selección doble idéntica: elegir dos veces la misma franja no altera ni
  duplica el contenido.
- CL-10 Franja sin señales en un área: esa área se omite (no se muestra vacía
  sin explicación); es un caso legítimo de contenido, no un error (RF-2). Un
  área sin señales en **ninguna** de las 4 franjas sí es un error de contenido y
  el sistema no la mostrará.
- CL-11 Riesgo de falsa alarma: si una franja tuviera señales solo clasificadas
  como "urgencia", la guía de acción de cada una y el aviso médico (RF-3) siguen
  mostrándose; la app no añade refuerzos extra de urgencia por encima del
  contenido definido (el nivel es dato, no heurística).

## Fuera de alcance (MVP)

- Registro o seguimiento del estado de salud del niño (app stateless).
- Contactos de emergencia, llamadas o enlaces externos a atención médica.
- Notificaciones, recordatorios y multibebé.
- Persistencia de preferencias.
- Contenido clínico más allá de las 4 franjas globales.

## Decisiones de contenido

Fuentes de referencia: guías pediátricas de AEP/AAP/CDC sobre signos de alarma
en salud y desarrollo infantil de 0 a 5 años. Contenido definido el 31-ago-2026,
revisable al actualizar las referencias.

Regla de redacción: los términos clínicos van acompañados de una aclaración en
lenguaje cotidiano al mostrarse.

Umbral del nivel de urgencia (operacionaliza RF-3): el contenido clasifica cada
señal en un único nivel según el criterio de acción:
- "urgencia": requiere atención médica inmediata, el mismo día, sin demora
  programable (p. ej., dificultad para respirar, convulsión, signo de deshidratación grave, fiebre muy alta en un lactante).
- "consulta programada": requiere valoración por el pediatra pero no es
  emergencia; incluye la indicación "consulta pronto" cuando debe atenderse en
  el mismo día o en 24–48 h (p. ej., falta de un hito esperable, signo
  persistente de más de dos semanas).

Inventario cerrado de términos clínicos con aclaración (se ampliará al definir
el contenido completo):
- "Convulsión": movimiento que se repite sin control y puede hacer perder el
  conocimiento.
- "Cianosis": coloración azulada o amoratada de labios o piel por falta de
  oxígeno.
- "Letargo": sueño excesivo o dificultad anormal para despertar.
- "Deshidratación": el cuerpo pierde más líquido del que recibe (boca seca,
  pocos pañales mojados, fontanela hundida).
- "Fontanela": la zona blanda de la cabeza del bebé que cierra poco a poco.
- "Estridor": silbido o ruido al respirar. Ampliar el inventario requiere
  actualizar esta spec.

Franjas y límites iguales a las funciones 001/002, con fuente única de verdad:
los límites [0,3), [3,12), [12,36) y [36,60] meses viven en una definición
compartida de la app y ninguna spec los redefine; los tests verifican que ambas
funciones usan los mismos límites.

Áreas de desarrollo (inventario cerrado, iguales a la función 004): motricidad
gruesa, motricidad fina, lenguaje, social/afectivo y cognitivo.

Estructura del contenido por franja (pendiente de definición completa según
referencias): para cada franja se definirá, para cada área, la lista de señales
de alerta y, para cada señal, su nivel único de urgencia ("urgencia" o
"consulta programada") con la guía de acción correspondiente. El inventario
completo se documentará en este apartado al aprobar la spec, con trazabilidad a
las fuentes citadas.

## Arquitectura y contratos (constitución §2, §3)

Esta sección satisface los requisitos mínimos de la constitución §2 y §3 para
esta spec.

### Casos de uso (Use Cases)

| Caso de uso | Flujo | RF asociado |
|---|---|---|
| `GetAlertGuide` | Dada una franja (o sin ella), devuelve las señales de alerta por área con su nivel de urgencia, o `null`. | RF-1, RF-2, RF-3 |
| `GetMedicalDisclaimer` | Devuelve el aviso médico (constante única siempre disponible). | RF-3 |

No hay más casos de uso porque la función es una guía estática; la selección
de franja (RF-1, RF-4) son responsabilidad del controller en Presentation.

### Contratos de repositorio (I/O y Repository Interfaces)

No existe fuente de datos ni repositorio. El contenido vive como constantes en
la capa Domain como datos tipados. No hay I/O que contratar.

### Estrategia de fallos de dominio

No hay fallos de dominio posibles: la entrada es la selección de una franja
válida (enum cerrado, imposible un valor inválido). El caso "sin franja" se
maneja en el controller como estado `null`, no como fallo de dominio. Un área
sin señales en alguna franja se omite (CL-10); un área sin señales en las 4
franjas se descarta del contenido con registro (error de contenido, no fallo
de dominio del usuario).

### Persistencia

Declaración explícita conforme §5: **sin persistencia**. La selección de
franja es estado efímero de sesión (app stateless); no se escribe a disco,
preferencias ni almacenamiento local. No existe repository de persistencia ni
data source local.

## Criterios de finalización

- Todos los RF verificables y cumplidos, y los casos límite resueltos.
- El contenido de las 4 franjas es trazable a las referencias citadas y
  revisado.
- El motor de contenido (franja → señales por área con nivel de urgencia y guía
  de acción) cubierto por tests unitarios, incluida la cobertura 4/4 (CL-8),
  el área omitida por franja (CL-10), el área sin señales en ninguna franja y
  los límites compartidos con 001/002 (CL-3).
- Sin dependencias nuevas y sin persistencia.
- Cumple §2 de la constitución: casos de uso, ausencia de repositorio justificada,
  estrategia de fallos declarada y mecanismo de persistencia declarado.

## Dudas abiertas

- [NECESITA ACLARACIÓN] ¿El contenido de señales de alerta debe
  reutilizar/coincidir alguna señal de las funciones 002 (sueño) y 004 (hitos)
  ya definidas, o es un catálogo independiente?
