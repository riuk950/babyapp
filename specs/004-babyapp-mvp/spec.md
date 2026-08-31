# Especificación 004 — Hitos de desarrollo mes a mes

## Contexto y objetivo

Los padres y cuidadores necesitan saber qué esperar del desarrollo de su hijo en
cada etapa. Esta función ofrece una guía de referencia rápida de hitos clave del
desarrollo infantil, organizada por mes (1 a 60 meses) y agrupada en 5 áreas:
motricidad gruesa, motricidad fina, lenguaje, social/afectivo y cognitivo. Para
cada mes se muestran los hitos esperados en cada área y, cuando un área no tiene
hito nuevo ese mes, se muestra el último hito alcanzado. Además, incluye alertas
de señales de alarma que indican cuándo consultar al pediatra. Objetivo: reducir
la incertidumbre sobre el desarrollo del niño y ayudar a detectar posibles
retrasos a tiempo, sin sustituir el consejo médico.

## Usuarios

- Madres, padres y cuidadores de niños de 0 a 5 años.
- Sin formación técnica: la interfaz y el contenido deben ser claros y sin jerga.

## Historias de usuario

- HU-1: Como madre, quiero consultar los hitos de desarrollo esperados para el
  mes actual de mi hijo, para saber si se desarrolla de forma esperada.
- HU-2: Como usuaria, quiero ver los hitos agrupados por áreas (motricidad,
  lenguaje, etc.), para identificar en qué aspectos va bien y en cuáles puede
  necesitar apoyo.
- HU-3: Como usuaria, quiero ver alertas de señales de alarma por mes, para
  saber cuándo debo consultar al pediatra.
- HU-4: Como usuaria, quiero que cuando un área no tenga hito nuevo este mes, se
  me muestre el último hito alcanzado, para tener una referencia actualizada.
- HU-5: Como usuaria, quiero navegar fácilmente entre los 60 meses, para
  consultar diferentes edades sin complicaciones.

## Requisitos funcionales

RF-1 — Selección de mes
- The meses serán 60: del 1 al 60, donde cada mes cubre un intervalo de edad
  de un mes (mes 1 = nacimiento a 1 mes cumplido, mes 2 = 1 a 2 meses
  cumplidos, ..., mes 60 = 59 a 60 meses cumplidos = justo antes de 5 años),
  seleccionables de una lista.
- Where no hay mes seleccionado, el sistema pedirá elegir uno y no mostrará
  contenido informativo (el aviso médico de RF-3 sí se muestra).
- When la usuaria selecciona un mes, el sistema mostrará el contenido de ese mes.
- The lista de 60 meses permitirá scroll y búsqueda por texto (p. ej., número
  de mes o edad en meses) para localizar un mes rápidamente.

RF-2 — Contenido de hitos por área
- When hay un mes seleccionado, el sistema mostrará para ese mes los hitos de
  desarrollo de cada una de las 5 áreas: motricidad gruesa, motricidad fina,
  lenguaje, social/afectivo y cognitivo.
- Where un área tiene al menos un hito nuevo para el mes seleccionado, el
  sistema mostrará todos los hitos nuevos de esa área para ese mes.
- Where un área no tiene hito nuevo para el mes seleccionado, el sistema
  mostrará el último hito alcanzado en esa área (el del mes más reciente
  anterior que tenga hito; ver caso base en Decisiones de contenido), y lo
  distinguirá visualmente del hito nuevo del mes como referencia a un hito
  anterior.
- Where un área no tiene ningún hito definido en ningún mes (error de
  contenido), el sistema no mostrará esa área y registrará el error.
- The contenido se mostrará en lenguaje sencillo; los términos clínicos irán
  acompañados de una aclaración en lenguaje cotidiano (regla de redacción, ver
  Decisiones de contenido).

RF-3 — Señales de alarma y aviso médico
- Where hay un mes seleccionado, el sistema mostrará las señales de alarma de
  ese mes específicas por área, asociadas a cada una de las 5 áreas y no como
  un bloque único general.
- The señales de alarma destacarán visualmente y se distinguirán del contenido
  informativo.
- The aviso "Esta información es orientativa y no sustituye el consejo de un
  profesional de salud" se mostrará siempre, incluido el estado sin mes
  seleccionado (RF-1).

RF-4 — Cambio de mes
- When la usuaria cambia de mes con otro ya visible, el sistema sustituirá todo
  el contenido por el del nuevo mes sin acciones adicionales.

RF-5 — Respuesta determinista
- When se repite la selección del mismo mes, el sistema devolverá siempre el
  mismo contenido.

## Requisitos no funcionales

- RNF-1 Rendimiento: el contenido se muestra en la misma interacción, sin
  llamadas de red.
- RNF-2 Usabilidad: pantalla legible en ≥320 dp de ancho, con scroll para
  contenido largo, incluida la lista de 60 meses (con su campo de búsqueda).
  Cada mes como unidad de contenido cabe en una pantalla con scroll razonable
  (el contenido de 5 áreas + alertas por área no debe exceder una longitud que
  dificulte la lectura; si algún mes lo excede, se revisará el contenido).
- RNF-3 Persistencia: ninguna; la selección de mes es estado efímero de sesión
  (app stateless) y no se conserva al reabrir la app.
- RNF-4 Mantenibilidad: el contenido y las reglas de mes viven aislados de la
  interfaz, en lógica pura.
- RNF-5 Accesibilidad: texto legible y con contraste suficiente. El "último
  hito alcanzado" (referencia a hito anterior) se distingue del hito nuevo no
  solo por color, sino también por texto (etiqueta semántica que identifica el
  hito como anterior).
- RNF-6 Autonomía: funciona sin conexión, sin permisos y sin dependencias
  nuevas.

## Casos límite

- CL-1 Sin mes seleccionado: se pide elegir; no hay contenido informativo, pero
  el aviso médico (RF-3) sí se muestra.
- CL-2 Cambio rápido o repetición de mes: el contenido mostrado corresponde
  siempre a la última selección (RF-4); seleccionar el mismo mes dos veces no
  cambia el estado (idempotencia).
- CL-3 Área sin hito nuevo en el mes: se muestra el último hito alcanzado,
  distinguido como referencia a un hito anterior (RF-2, RNF-5).
- CL-4 Contenido largo: el scroll no corta ni oculta información.
- CL-5 Pantalla pequeña u orientación horizontal: el contenido sigue siendo
  legible (RNF-2).
- CL-6 Reinicio de la app: al reabrir no se conserva la selección (stateless,
  RNF-3) y se vuelve al estado sin mes.
- CL-7 Texto ampliado (zoom de accesibilidad): el contenido se mantiene legible
  con scroll, sin cortarse.
- CL-8 Cobertura 60/60: todos los meses tienen contenido definido en las 5
  áreas (nuevo o último alcanzado) y en alertas por área.
- CL-9 Mes 1 (caso base): el primer mes siempre tiene hitos nuevos definidos
  en todas las áreas, de modo que la regla de "último hito alcanzado" tiene
  caso base.
- CL-10 Área sin hitos en ningún mes (error de contenido): el sistema no
  muestra esa área (RF-2).
- CL-11 Niño mayor de 60 meses: la lista termina en mes 60; no se ofrece
  selección fuera de rango.
- CL-12 Búsqueda sin resultados: el sistema avisará de que no hay meses que
  coincidan y seguirá permitiendo el scroll completo de la lista.

## Fuera de alcance (MVP)

- Registro o seguimiento del desarrollo del niño (app stateless).
- Comparativa entre niños o percentiles.
- Notificaciones, recordatorios y multibebé.
- Persistencia de preferencias.
- Contenido adicional más allá de los 60 meses.

## Decisiones de contenido

Fuentes de referencia: CDC (Learn the Signs. Act. Early.), OMS (Child Growth
Standards), AAP (Bright Futures) y material de desarrollo infantil de 0 a 5
años. Contenido definido el 31-ago-2026, revisable al actualizar las
referencias.

Regla de redacción: los términos clínicos van acompañados de una aclaración en
lenguaje cotidiano al mostrarse.

Definición de mes: cada mes cubre un intervalo de edad de un mes. Mes 1 =
nacimiento a 1 mes cumplido; mes 2 = 1 a 2 meses cumplidos; ...; mes 60 = 59 a
60 meses cumplidos (justo antes de 5 años). La selección es por número de mes
(1–60), no por edad en meses.

Definición de hito nuevo: un hito que aparece por primera vez en ese mes en la
fuente de referencia. No es sinónimo de "cualquier hito relevante para esa
edad"; es exclusivamente uno que no estaba presente en ningún mes anterior.

Caso base de mes 1 (resuelve CL-9): el primer mes tiene hitos nuevos definidos
en todas las 5 áreas (estado inicial del recién nacido en cada área). La regla
de "último hito alcanzado" (RF-2) nunca se aplica en mes 1 porque siempre hay
hito nuevo.

Inventario cerrado de términos clínicos con aclaración:
- "Tono muscular": firmeza con que el cuerpo sostiene posturas y movimientos.
- "Reflejo": movimiento automático e involuntario que el bebé hace sin querer.
- "Babalización" / " balbuceo": sonidos que el bebé hace sin sentido, como
  primer paso hacia el habla.
- "Separación ansiosa": molestia del bebé cuando se aleja de su cuidador
  principal.
- "Juego funcional": usar un objeto para su propósito (p. ej., beber de un
  vaso).
- "Simbolismo": usar un objeto para representar otro (p. ej., un bloque como
  teléfono). Ampliar el inventario requiere actualizar esta spec.

Áreas de desarrollo (inventario cerrado):
- Motricidad gruesa: control del cuerpo, gateo, marcha, equilibrio.
- Motricidad fina: coordinación mano-ojo, pinza, manipulación de objetos.
- Lenguaje: balbuceo, palabras, frases, comprensión y expresión.
- Social/afectivo: vínculo, interacción, juego, autonomía emocional.
- Cognitivo: curiosidad, resolución de problemas, imitación, atención.

Estructura del contenido por mes (pendiente de definición completa según
referencias): para cada mes se definirá (a) los hitos nuevos por área, (b) las
señales de alarma por mes y por área y (c) el contenido del aviso médico. El
inventario completo de hitos por mes es extenso (60 meses × 5 áreas) y se
documentará en este apartado al aprobar la spec, con trazabilidad a las fuentes
citadas.

## Arquitectura y contratos (constitución §2, §3)

Esta sección satisface los requisitos mínimos de la constitución §2 y §3 para
esta spec.

### Casos de uso (Use Cases)

| Caso de uso | Flujo | RF asociado |
|---|---|---|
| `GetMonthMilestones` | Dado un mes (o sin él), devuelve el contenido de hitos por áreas y alertas por área, o `null`. | RF-1, RF-2, RF-3 |
| `ResolveLastHit` | Para un área sin hito nuevo en un mes, busca y devuelve el último hito alcanzado del mes anterior; la UI lo marca como referencia. | RF-2, CL-3 |
| `GetMedicalDisclaimer` | Devuelve el aviso médico (constante única siempre disponible). | RF-3 |
| `FilterMonthsByText` | Dado un texto de búsqueda, devuelve la lista de meses que coinciden; lista vacía si no hay coincidencias. | RF-1, CL-12 |

### Contratos de repositorio (I/O y Repository Interfaces)

No existe fuente de datos ni repositorio. El contenido vive como constantes en
la capa Domain como datos tipados. No hay I/O que contratar.

### Estrategia de fallos de dominio

No hay fallos de dominio posibles: los meses son un enum cerrado (imposible un
valor inválido). El caso "sin mes" se maneja en el controller como estado
`null`. El caso "búsqueda sin resultados" (CL-12) se devuelve como lista vacía,
no como fallo. Un área sin hitos en ningún mes (CL-10) se omite del contenido,
registrando el error para el tester; no se eleva como excepción de dominio.

### Persistencia

Declaración explícita conforme §5: **sin persistencia**. La selección de mes y
el filtro de búsqueda son estado efímero de sesión (app stateless); no se escribe
a disco, preferencias ni almacenamiento local. No existe repository de
persistencia ni data source local.

## Criterios de finalización

- Todos los RF verificables y cumplidos, y los casos límite resueltos.
- El contenido de los 60 meses es trazable a las referencias citadas y
  revisado.
- El motor de contenido (mes → contenido con sus áreas y alertas por área)
  cubierto por tests unitarios, incluida la cobertura 60/60 (CL-8), el caso
  base de mes 1 (CL-9), la regla de "último hito alcanzado" (CL-3) y el área
  sin hitos (CL-10).
- Sin dependencias nuevas y sin persistencia.
- Cumple §2 de la constitución: casos de uso, ausencia de repositorio justificada,
  estrategia de fallos declarada y mecanismo de persistencia declarado.

## Dudas abiertas

- Ninguna: las dudas de la spec quedan resueltas (ver RF-1, RF-2 y RF-3 y sus
  casos límite asociados). Pendiente de tu revisión al aprobar esta spec.
