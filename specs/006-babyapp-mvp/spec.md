# Especificación 006 — Tips rápidos de rutina diaria

## Contexto y objetivo

Muchas madres con niños de 0 a 5 años buscan orientación práctica y concisa
sobre cómo organizar las rutinas diarias de su bebé. Esta función ofrece
**tips breves y accionables** para los momentos clave del día (mañana, siesta,
baño, alimentación, juego/estimulación y noche), adaptados por franja de edad.
Cada tip incluye la referencia a la fuente o recomendación que lo respalda.
El objetivo es reducir la carga cognitiva de la madre, proporcionando
orientación confiable sin sobrecargarla de información.

## Usuarios

- Madres con hijos de 0 a 5 años que buscan guía rápida y práctica para
  organizar el día a día.
- Cuidadores primarios que necesitan recordatorios concisos de buenas prácticas.

## Historias de usuario

- HU-1: Como madre, quiero ver los tips del momento del día que selecciono,
  para saber qué hacer en ese momento específico con mi hijo.
- HU-2: Como madre, quiero que los tips se adapten a la edad de mi hijo, para
  recibir consejos relevantes a su etapa de desarrollo.
- HU-3: Como madre, quiero ver la fuente o recomendación de cada tip, para
  confiar en la información que me dan.
- HU-4: Como madre, quiero ver todos los tips de golpe sin tener que expandir
  nada, para leerlos rápidamente.

## Requisitos funcionales

RF-1 — Momentos del día
- The la lista de momentos del día sea mostrada al usuario.
- Where el usuario accede a la función de tips de rutina.
- When el usuario abre la pantalla de tips.

RF-2 — Adaptación por franja de edad
- The los tips mostrados correspondan a la franja de edad seleccionada.
- Where el usuario ha seleccionado un momento del día.
- When el usuario selecciona o cambia la franja de edad.
- The las franjas sean las 4 globales de la app: 0–3 meses, 3–12 meses, 1–3
  años y 4–5 años, con límites [0,3), [3,12), [12,36) y [36,60] meses (fuente
  única compartida con las funciones 001, 002, 004 y 005).

RF-3 — Contenido por momento
- The se muestren todos los tips del momento seleccionado de forma simultánea.
- Where el usuario ha seleccionado un momento del día.
- When el usuario selecciona un momento.
- The cada tip sea un mensaje corto (máximo 2 líneas en pantalla) y accionable
  (empieza con verbo en infinitivo o imperativo).
- The la cantidad de tips sea variable según el momento y la franja de edad
  (no fija).

RF-4 — Referencia a fuente
- The cada tip muestre su fuente o recomendación debajo o junto al mensaje.
- Where el tip es renderizado en pantalla.
- When se muestra el contenido del momento.

RF-5 — Sin niveles de prioridad
- The todos los tips se presenten con el mismo estilo visual; no hay
  distinción por prioridad o urgencia.
- Where se renderiza la lista de tips.
- When se muestra el contenido de cualquier momento.

RF-6 — Disclaimer médico
- The el disclaimer "Esta información es orientativa y no sustituye el consejo
  de un profesional de salud" se muestre siempre, independientemente del
  momento o franja seleccionados.
- Where se renderiza la pantalla de tips.
- When el usuario visualiza cualquier contenido.

## Requisitos no funcionales

- RNF-1 Rendimiento: la selección de momento y franja de edad debe responder
  en <200 ms, sin llamadas de red.
- RNF-2 Usabilidad: la pantalla debe ser legible en dispositivos con ≥320 dp
  de ancho, con scroll para contenido largo.
- RNF-3 Persistencia: ninguna; la selección de momento y franja es estado
  efímero de sesión (app stateless) y no se conserva al reabrir la app.
- RNF-4 Mantenibilidad: el contenido y las reglas de franja viven aislados de
  la interfaz, en lógica pura.
- RNF-5 Accesibilidad: texto legible y con contraste suficiente; los tips se
  diferencian por contenido de texto, no solo por color o ícono.
- RNF-6 Autonomía: funciona sin conexión, sin permisos y sin dependencias
  nuevas.

## Casos límite

- CL-1 Sin franja seleccionada: (RF-2, RF-3) se pide elegir; no se muestran
  tips, pero el aviso médico (RF-6) sí se muestra.
- CL-2 Sin momento seleccionado: (RF-3) se muestra la lista de momentos
  disponibles sin contenido de tips.
- CL-3 Momento sin tips para una franja: (RF-3) si un momento no tiene tips
  para una franja específica, se omite del render (no se muestra vacío).
- CL-4 Cambio de franja: (RF-2, RF-3) al cambiar de franja de edad, los tips
  se actualizan inmediatamente sin recarga.
- CL-5 Cambio de momento: (RF-3) al cambiar de momento, los tips del nuevo
  momento reemplazan a los anteriores.
- CL-6 Reinicio de sesión: (RNF-3) al cerrar y abrir la app, la selección de
  momento y franja se pierde; se vuelve al estado sin selección.
- CL-7 Selección doble idéntica: (RF-3) elegir dos veces el mismo momento no
  altera ni duplica el contenido (idempotencia).
- CL-8 Cobertura 6×4: toda combinación momento×franja debe tener al menos 1
  tip; un momento sin tips para una franja se omite (CL-3), pero que un
  momento no tenga tips en ninguna de las 4 franjas es un error de contenido.
- CL-9 Texto ampliado (zoom de accesibilidad): el contenido se mantiene
  legible con scroll, sin cortarse (RNF-2, RNF-5).
- CL-10 Pantalla pequeña u orientación horizontal: el contenido sigue siendo
  legible (RNF-2).

## Fuera de alcance (MVP)

- Notificaciones o recordatorios de rutina.
- Creación de rutinas personalizadas por el usuario.
- Persistencia de la última selección.
- Tips en idiomas distintos al español.
- Contenido multimedia (imágenes, videos).
- Conexión con calendario o agenda del dispositivo.
- Registro o seguimiento del cumplimiento de rutinas.
- Multibebé.

## Decisiones de contenido

Fuentes de referencia: guías de la OMS (Organización Mundial de la Salud) y
AAP (Academia Americana de Pediatría) sobre rutinas de sueño, alimentación,
estimulación y cuidados diarios en la primera infancia. Contenido definido el
31-ago-2026, revisable al actualizar las referencias.

Regla de redacción: cada tip es un mensaje corto (máximo 2 líneas) y
accionable (empieza con verbo en infinitivo o imperativo). Si se usa un término
técnico, se acompaña de aclaración entre paréntesis. Todos los tips incluyen
la referencia a la fuente que los respalda.

Inventario cerrado de fuentes permitidas en el MVP: OMS, AAP, guías de
lactancia materna de la OMS.

Inventario cerrado de momentos del día: Mañana, Siesta, Baño, Alimentación,
Juego/estimulación, Noche.

Franjas y límites iguales a las funciones 001/002/004/005, con fuente única
de verdad: los límites [0,3), [3,12), [12,36) y [36,60] meses viven en una
definición compartida de la app y ninguna spec los redefine; los tests
verifican que las funciones usan los mismos límites.

Estructura del contenido por momento y franja (pendiente de definición
completa según referencias): para cada combinación momento×franja se definirá
la lista de tips, cada uno con su mensaje y su fuente. El inventario completo
se documentará en este apartado al aprobar la spec, con trazabilidad a las
fuentes citadas.

## Arquitectura y contratos (constitución §2, §3)

Esta sección satisface los requisitos mínimos de la constitución §2 y §3 para
esta spec.

### Casos de uso (Use Cases)

| Caso de uso | Flujo | RF asociado |
|---|---|---|
| `GetRoutineTips` | Dado un `momentId` y un `AgeBand`, devuelve `List<RoutineTip>` o `null` si no hay franja. | RF-1, RF-2, RF-3, RF-4 |
| `GetAvailableMoments` | Devuelve la lista de momentos del día disponibles. | RF-1 |
| `GetMedicalDisclaimer` | Devuelve el aviso médico (constante única siempre disponible). | RF-6 |

No hay más casos de uso porque la función es una guía estática; la selección
de momento y franja (RF-1, RF-2) son responsabilidad del controller en
Presentation.

### Contratos de repositorio (I/O y Repository Interfaces)

No existe fuente de datos ni repositorio. El contenido vive como constantes en
la capa Domain como datos tipados. No hay I/O que contratar.

### Estrategia de fallos de dominio

No hay fallos de dominio posibles: la entrada es la selección de un momento
válido (enum cerrado, imposible un valor inválido) y de una franja válida
(enum cerrado compartido). El caso "sin franja" o "sin momento" se maneja en
el controller como estado `null`, no como fallo de dominio. Un momento sin
tips para una franja se omite (CL-3); un momento sin tips en las 4 franjas
se descarta del contenido con registro (error de contenido, no fallo de
dominio del usuario).

### Persistencia

Declaración explícita conforme §5: **sin persistencia**. La selección de
momento y franja es estado efímero de sesión (app stateless); no se escribe a
disco, preferencias ni almacenamiento local. No existe repository de
persistencia ni data source local.

## Criterios de finalización

- Todos los RF verificables y cumplidos, y los casos límite resueltos.
- El contenido de las 6 combinaciones momento×franja es trazable a las
  referencias citadas y revisado.
- Motor de contenido (momento×franja → tips con mensaje y fuente) cubierto
  por tests unitarios, incluida la cobertura 6×4 (CL-8), el momento sin tips
  para una franja (CL-3), el momento sin tips en ninguna franja y los
  límites compartidos con 001/002/004/005 (CL-3 de las otras specs).
- Sin dependencias nuevas y sin persistencia.
- Cumple §2 de la constitución: casos de uso, ausencia de repositorio
  justificada, estrategia de fallos declarada y mecanismo de persistencia
  declarado.
- `flutter pub get && flutter analyze && flutter test` → 0/0/0.

## Dudas abiertas

Ninguna.
