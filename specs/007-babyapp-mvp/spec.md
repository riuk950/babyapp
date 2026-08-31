# Especificación 007 — Primeros auxilios básicos

## Contexto y objetivo

Los padres y cuidadores de niños de 0 a 5 años necesitan instrucciones claras y
concisas sobre cómo actuar en situaciones de emergencia de primeros auxilios.
Esta función ofrece una guía de referencia rápida: al elegir una situación de
emergencia y la franja de edad del niño, la usuaria ve los pasos numerados de
qué hacer, qué NO hacer, y un indicador de gravedad que le ayuda a decidir si
debe acudir a urgencias, consultar con el pediatra o actuar en casa. Objetivo:
reducir el pánico en situaciones de estrés y proporcionar orientación segura y
confiable, sin sustituir el consejo médico profesional.

## Usuarios

- Madres, padres y cuidadores de niños de 0 a 5 años.
- Sin formación técnica: la interfaz y el contenido deben ser claros y sin
  jerga.

## Historias de usuario

- HU-1: Como madre, quiero ver los pasos de primeros auxilios para la
  emergencia que estoy enfrentando, para saber cómo actuar de inmediato.
- HU-2: Como madre, quiero que los pasos se adapten a la edad de mi hijo, para
  recibir instrucciones relevantes a su etapa.
- HU-3: Como madre, quiero saber la gravedad de la situación, para decidir si
  debo acudir a urgencias o puedo actuar en casa.
- HU-4: Como madre, quiero ver qué NO hacer, para evitar errores que puedan
  empeorar la situación.
- HU-5: Como madre, quiero ver todos los pasos de golpe sin tener que expandir
  nada, para leerlos rápidamente en una situación de estrés.

## Requisitos funcionales

RF-1 — Situaciones de emergencia
- The la lista de situaciones de emergencia sea mostrada al usuario.
- Where el usuario accede a la función de primeros auxilios.
- When el usuario abre la pantalla de primeros auxilios.

RF-2 — Adaptación por franja de edad
- The los pasos mostrados correspondan a la franja de edad seleccionada.
- Where el usuario ha seleccionado una situación de emergencia.
- When el usuario selecciona o cambia la franja de edad.
- The las franjas sean las 4 globales de la app: 0–3 meses, 3–12 meses, 1–3
  años y 4–5 años, con límites [0,3), [3,12), [12,36) y [36,60] meses (fuente
  única compartida con las funciones 001, 002, 004, 005 y 006).

RF-3 — Pasos numerados de primeros auxilios
- The se muestren los pasos de la emergencia seleccionada de forma simultánea,
  numerados secuencialmente (Paso 1, Paso 2, Paso 3…).
- Where el usuario ha seleccionado una situación de emergencia.
- When el usuario selecciona una emergencia.
- The cada paso sea una instrucción clara y accionable (empieza con verbo en
  infinitivo o imperativo).
- The la cantidad de pasos sea variable según la emergencia y la franja de edad
  (no fija).

RF-4 — Qué NO hacer
- The, junto a los pasos de qué sí hacer, se muestre una sección separada con
  las acciones que NO se deben realizar para esa emergencia y esa franja de
  edad.
- Where el usuario ha seleccionado una situación de emergencia.
- When se renderiza el contenido de la emergencia.

RF-5 — Indicador de gravedad
- The cada emergencia muestre un indicador de gravedad con dos niveles,
  mutuamente excluyentes: "urgencia" (acudir a urgencias de inmediato) o
  "consulta" (consultar con el pediatra o actuar en casa con vigilancia).
- Where el usuario ha seleccionado una situación de emergencia.
- When se renderiza el contenido de la emergencia.
- The el indicador de gravedad se distinga del contenido informativo por texto,
  no solo por color.

RF-6 — Disclaimer médico
- The el disclaimer "Esta información es orientativa y no sustituye el consejo
  de un profesional de salud" se muestre siempre, independientemente de la
  emergencia o franja seleccionadas.
- Where se renderiza la pantalla de primeros auxilios.
- When el usuario visualiza cualquier contenido.

## Requisitos no funcionales

- RNF-1 Rendimiento: la selección de emergencia y franja de edad debe responder
  en <200 ms, sin llamadas de red.
- RNF-2 Usabilidad: la pantalla debe ser legible en dispositivos con ≥320 dp de
  ancho, con scroll para contenido largo.
- RNF-3 Persistencia: ninguna; la selección de emergencia y franja es estado
  efímero de sesión (app stateless) y no se conserva al reabrir la app.
- RNF-4 Mantenibilidad: el contenido y las reglas de franja viven aislados de
  la interfaz, en lógica pura.
- RNF-5 Accesibilidad: texto legible y con contraste suficiente; el indicador
  de gravedad se distingue también por texto, no solo por color.
- RNF-6 Autonomía: funciona sin conexión, sin permisos y sin dependencias
  nuevas.

## Casos límite

- CL-1 Sin franja seleccionada: (RF-2, RF-3) se pide elegir; no se muestran
  pasos, pero el aviso médico (RF-6) sí se muestra.
- CL-2 Sin emergencia seleccionada: (RF-3) se muestra la lista de emergencias
  disponibles sin contenido de pasos.
- CL-3 Emergencia sin pasos para una franja: (RF-3) si una emergencia no tiene
  pasos para una franja específica, se omite del render (no se muestra vacía).
- CL-4 Cambio de franja: (RF-2, RF-3) al cambiar de franja de edad, los pasos
  se actualizan inmediatamente sin recarga.
- CL-5 Cambio de emergencia: (RF-3) al cambiar de emergencia, los pasos de la
  nueva emergencia reemplazan a los anteriores.
- CL-6 Reinicio de sesión: (RNF-3) al cerrar y abrir la app, la selección de
  emergencia y franja se pierde; se vuelve al estado sin selección.
- CL-7 Selección doble idéntica: (RF-3) elegir dos veces la misma emergencia no
  altera ni duplica el contenido (idempotencia).
- CL-8 Emergencia sin gravedad: (RF-5) toda emergencia definida debe tener un
  indicador de gravedad válido ("urgencia" o "consulta"); una emergencia sin
  gravedad es un error de contenido.
- CL-9 Contenido largo (pasos + qué no hacer): (RNF-2) el scroll no corta ni
  oculta información.
- CL-10 Pantalla pequeña u orientación horizontal: (RNF-2) el contenido sigue
  siendo legible.
- CL-11 Texto ampliado (zoom de accesibilidad): (RNF-2, RNF-5) el contenido se
  mantiene legible con scroll, sin cortarse.

## Fuera de alcance (MVP)

- Llamadas de emergencia o enlaces externos a servicios de emergencia.
- Videos o tutoriales de primeros auxilios.
- Persistencia de la última selección.
- Contenido en idiomas distintos al español.
- Simuladores o guías interactivas paso a paso.
- Primeros auxilios para adultos.
- Multibebé.

## Decisiones de contenido

Fuentes de referencia: guías de primeros auxilios pediátricos de la Cruz Roja,
AAP (Academia Americana de Pediatría) y SEMES (Sociedad Española de Medicina de
Urgencias y Emergencias). Contenido definido el 31-ago-2026, revisable al
actualizar las referencias.

Regla de redacción: cada paso es una instrucción clara y accionable (empieza
con verbo en infinitivo o imperativo). La sección de "qué NO hacer" usa la
misma estructura numerada. Si se usa un término técnico, se acompaña de
aclaración entre paréntesis.

Inventario cerrado de situaciones de emergencia (MVP):
- Atragantamiento (obstrucción de vía aérea)
- Quemaduras (térmicas, por líquidos, por contacto)
- Caídas
- Picaduras y mordeduras (insectos, animales, personas)
- Convulsiones
- Fiebre alta
- Heridas sangrantes
- Intoxicación/ingestión de sustancias
- Golpe en la cabeza
- Alergias graves/anafilaxia
- Ahogamiento/near-drowning
- Objetos en ojos/orejas/nariz

Franjas y límites iguales a las funciones 001/002/004/005/006, con fuente única
de verdad: los límites [0,3), [3,12), [12,36) y [36,60] meses viven en una
definición compartida de la app y ninguna spec los redefine; los tests
verifican que las funciones usan los mismos límites.

Inventario cerrado de niveles de gravedad (RF-5):
- "urgencia": requiere atención médica inmediata, el mismo día, sin demora
  programable.
- "consulta": requiere valoración por el pediatra pero no es emergencia; puede
  atenderse en el mismo día o en 24–48 h, o actuarse en casa con vigilancia.

Estructura del contenido por emergencia y franja (pendiente de definición
completa según referencias): para cada combinación emergencia×franja se
definirán los pasos numerados, la sección de qué NO hacer, y el nivel de
gravedad. El inventario completo se documentará en este apartado al aprobar la
spec, con trazabilidad a las fuentes citadas.

## Arquitectura y contratos (constitución §2, §3)

Esta sección satisface los requisitos mínimos de la constitución §2 y §3 para
esta spec.

### Casos de uso (Use Cases)

| Caso de uso | Flujo | RF asociado |
|---|---|---|
| `GetFirstAidGuide` | Dada una emergencia (o sin ella) y una franja (o sin ella), devuelve los pasos numerados, la sección de qué NO hacer y el nivel de gravedad, o `null`. | RF-1, RF-2, RF-3, RF-4, RF-5 |
| `GetAvailableEmergencies` | Devuelve la lista de situaciones de emergencia disponibles. | RF-1 |
| `GetMedicalDisclaimer` | Devuelve el aviso médico (constante única siempre disponible). | RF-6 |

No hay más casos de uso porque la función es una guía estática; la selección de
emergencia y franja (RF-1, RF-2) son responsabilidad del controller en
Presentation.

### Contratos de repositorio (I/O y Repository Interfaces)

No existe fuente de datos ni repositorio. El contenido vive como constantes en
la capa Domain como datos tipados. No hay I/O que contratar.

### Estrategia de fallos de dominio

No hay fallos de dominio posibles: la entrada es la selección de una emergencia
válida (enum cerrado, imposible un valor inválido) y de una franja válida (enum
cerrado compartido). El caso "sin emergencia" o "sin franja" se maneja en el
controller como estado `null`, no como fallo de dominio. Una emergencia sin
pasos para una franja se omite (CL-3); una emergencia sin pasos en las 4
franjas se descarta del contenido con registro (error de contenido, no fallo de
dominio del usuario).

### Persistencia

Declaración explícita conforme §5: **sin persistencia**. La selección de
emergencia y franja es estado efímero de sesión (app stateless); no se escribe
a disco, preferencias ni almacenamiento local. No existe repository de
persistencia ni data source local.

## Criterios de finalización

- Todos los RF verificables y cumplidos, y los casos límite resueltos.
- El contenido de las emergencias × franjas es trazable a las referencias
  citadas y revisado.
- Motor de contenido (emergencia×franja → pasos + qué no hacer + gravedad)
  cubierto por tests unitarios, incluida la cobertura de emergencias definidas
  (CL-8), la emergencia sin pasos para una franja (CL-3), los límites
  compartidos con otras specs (CL-3).
- Sin dependencias nuevas y sin persistencia.
- Cumple §2 de la constitución: casos de uso, ausencia de repositorio
  justificada, estrategia de fallos declarada y mecanismo de persistencia
  declarado.
- `flutter pub get && flutter analyze && flutter test` → 0/0/0.

## Dudas abiertas

Ninguna.
