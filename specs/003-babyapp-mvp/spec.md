# Especificación 003 — Cómo almacenar leche materna

## Contexto y objetivo

La leche materna extraída debe manejarse con criterios claros de tiempo,
temperatura e higiene para ser segura. Esta función ofrece una guía de
referencia rápida por secciones navegables (extracción, almacenamiento,
descongelado y uso, higiene y seguridad) con mejores prácticas, tiempos de
conservación y avisos destacados de seguridad. Objetivo: reducir la duda y el
error al conservar y usar la leche materna, sin sustituir el consejo de un
profesional de lactancia o de salud.

## Usuarios

- Madres, padres y cuidadores de niños de 0 a 5 años. También madres que se
  extraen leche (por trabajo, separación o producción).
- Sin formación técnica: la interfaz y el contenido deben ser claros y sin jerga.

## Historias de usuario

- HU-1: Como madre que se extrae leche, quiero saber cuánto tiempo dura la leche
  en cada lugar de conservación, para no echarla a perder.
- HU-2: Como usuaria, quiero conocer las mejores prácticas de extracción y
  almacenamiento, para mantener la leche segura y en buen estado.
- HU-3: Como usuaria, quiero saber cómo descongelar y usar la leche sin perder
  calidad ni seguridad.
- HU-4: Como usuaria, quiero identificar los signos de leche en mal estado,
  para saber cuándo desecharla.

## Requisitos funcionales

RF-1 — Navegación por secciones
- The secciones serán 4: Extracción, Almacenamiento, Descongelado y uso, e Higiene y seguridad, seleccionables de una lista.
- Where no hay sección seleccionada, el sistema pedirá elegir una y no mostrará contenido informativo (el aviso médico de RF-3 sí se muestra).
- When la usuaria selecciona una sección, el sistema mostrará el contenido de esa sección.
- When la usuaria retrocede (gesto o botón de atrás del sistema) desde una sección, el sistema volverá a la lista en estado sin sección seleccionada, sin recordar la anterior.

RF-2 — Contenido de sección
- When hay una sección seleccionada, el sistema mostrará el contenido de esa sección (mejores prácticas, tiempos y datos propios de la sección según lo definido en Decisiones de contenido) en lenguaje sencillo.
- The términos técnicos o científicos irán acompañados de una aclaración en lenguaje cotidiano; el inventario cerrado de términos está en Decisiones de contenido (actualmente solo "BPA").

RF-3 — Bloques destacados y aviso médico
- Where existe riesgo de seguridad crítico (tiempos máximos, prohibiciones de uso, signos de alerta), el sistema mostrará bloques de contenido destacados dentro de la sección. Por esta regla, la sección Extracción queda sin bloques destacados (no contiene prohibiciones).
- The bloques destacados se distinguirán del contenido informativo mediante estilo y un prefijo de texto fijo "Aviso de seguridad", con su etiqueta semántica para lectores de pantalla, y no lo sustituirán.
- The aviso "Esta información es orientativa y no sustituye el consejo de un profesional de lactancia o de salud" se mostrará siempre, incluido el estado sin sección seleccionada.

RF-4 — Cambio de sección
- When la usuaria cambia de sección con otra ya visible, el sistema sustituirá todo el contenido por el de la nueva sección sin acciones adicionales.

RF-5 — Respuesta determinista
- When se repite la selección de la misma sección, el sistema devolverá siempre el mismo contenido.

## Requisitos no funcionales

- RNF-1 Rendimiento: el contenido se muestra en la misma interacción, sin llamadas de red.
- RNF-2 Usabilidad: pantalla legible en ≥320 dp de ancho, con scroll para contenido largo.
- RNF-3 Persistencia: ninguna; la selección de sección es estado efímero de sesión (app stateless) y no se conserva al reabrir la app.
- RNF-4 Mantenibilidad: el contenido y las reglas de sección viven aislados de la interfaz, en lógica pura.
- RNF-5 Accesibilidad: texto legible y con contraste suficiente; los bloques destacados son distinguibles también por texto (prefijo fijo "Aviso de seguridad" en su etiqueta semántica), no solo por color.
- RNF-6 Autonomía: funciona sin conexión, sin permisos y sin dependencias nuevas (la aprobación HTTP/GPS de la constitución es solo para clima y no aplica aquí).

## Casos límite

- CL-1 Sin sección seleccionada: se pide elegir; no hay contenido informativo, pero el aviso médico (RF-3) sí se muestra.
- CL-2 Cambio rápido entre secciones: el contenido mostrado corresponde siempre a la última selección (RF-4); seleccionar la misma sección dos veces no cambia el estado (idempotencia).
- CL-3 Contenido largo (p. ej., tabla de tiempos): el scroll no corta ni oculta información.
- CL-4 Pantalla pequeña u orientación horizontal: el contenido sigue siendo legible (RNF-2).
- CL-5 Reinicio de la app: al reabrir no se conserva la selección (stateless, RNF-3) y se vuelve al estado sin sección.
- CL-6 Texto ampliado (zoom de accesibilidad): el contenido se mantiene legible con scroll, sin cortarse.
- CL-7 Cobertura 4/4: todas las secciones tienen completo su contenido; los bloques destacados aparecen solo donde la regla de RF-3 los prevé.
- CL-8 Retorno desde una sección: el gesto o botón de atrás del sistema vuelve a la lista en estado sin sección, sin recordar la anterior (RF-1).
- CL-9 Tabla en pantalla estrecha (≤320 dp): la tabla de tiempos se refluye a lista (Lugar → tiempo) sin cortar ni ocultar datos (extiende CL-3 y CL-4).

## Fuera de alcance (MVP)

- Entrada de datos del usuario, calculadoras o tablas filtrantes.
- Registro o seguimiento de extracciones, recordatorios y temporizadores.
- Persistencia de preferencias, multibebé y opciones de compartir.
- Vídeos, animaciones o material descargable.

## Decisiones de contenido

Fuentes de referencia: guías de manejo de leche materna de AEP, AAP y CDC
(tiempos y prácticas orientativos, revisables). Contenido definido el
28-ago-2026, revisable al actualizar las referencias. Tiempos de conservación
(única fuente: bloque destacado de la sección Almacenamiento, sin duplicarse
como contenido normal):

| Lugar | Temperatura | Tiempo recomendado |
|---|---|---|
| Ambiente | ≤25 °C | hasta 4 h |
| Nevera | ~4 °C | hasta 4 días |
| Congelador | −18 °C | 6 meses |
| Descongelada en nevera | — | usar antes de 24 h |
| Descongelada a temperatura ambiente | — | usar en 1–2 h |

Los valores "hasta 8 días" (nevera) y "hasta 12 meses" (congelador) son
documentación interna de límites aceptables, no contenido visible al usuario.

Contenido por sección (mejores prácticas):
- **Extracción**: extraer cada 2–3 h si el bebé no mama; manos y recipientes limpios; raciones pequeñas (60–120 ml) para no desperdiciar; no llenar al borde (dejar espacio para expansión al congelar); etiquetar con fecha.
- **Almacenamiento**: guardar en la parte trasera de la nevera (más fría), no en la puerta; recipientes de vidrio o plástico sin BPA (sustancia usada en algunos plásticos que se recomienda evitar); si se mezclan extracciones, enfriar la nueva antes de añadirla a leche ya fría.
- **Descongelado y uso**: descongelar en nevera o en baño tibio, nunca en microondas ni a fuego directo; agitar suavemente; una capa de grasa separada es normal; no volver a congelar ni recalentar más de una vez; desechar las sobras de un biberón parcialmente consumido.
- **Higiene y seguridad**: lavarse las manos y el material; esterilizar los equipos para menores de 3 meses; no compartir leche entre niños.

Bloques destacados de seguridad (contenido destacado por sección, con prefijo
visible "Aviso de seguridad" según RF-3; la sección Extracción no tiene bloques
destacados por la regla de RF-3):
- Almacenamiento: tabla de tiempos máximos en bloque destacado; "no guardar en la puerta de la nevera".
- Descongelado y uso: "nunca en microondas", "no volver a congelar", "24 h en nevera".
- Higiene y seguridad: signos de leche en mal estado (olor o sabor rancio/agrio, grumos anómalos) y "en caso de duda, consulta a tu profesional de lactancia o al pediatra".

Aviso médico de RF-3 y regla de redacción: los términos técnicos llevan
aclaración cotidiana. Inventario cerrado de términos con aclaración (actual):
"BPA (sustancia usada en algunos plásticos que se recomienda evitar)". Ampliar
el inventario requiere actualizar esta spec.

## Arquitectura y contratos (constitución §2, §3)

Esta sección satisface los requisitos mínimos de la constitución §2 y §3 para
esta spec.

### Casos de uso (Use Cases)

| Caso de uso | Flujo | RF asociado |
|---|---|---|
| `GetBreastMilkGuide` | Dada una sección (o sin ella), devuelve el contenido de esa sección o `null`. | RF-1, RF-2 |
| `GetMedicalDisclaimer` | Devuelve el aviso médico (constante única siempre disponible). | RF-3 |

### Contratos de repositorio (I/O y Repository Interfaces)

No existe fuente de datos ni repositorio. El contenido vive como constantes en
la capa Domain como datos tipados. No hay I/O que contratar.

### Estrategia de fallos de dominio

No hay fallos de dominio posibles: la entrada es la selección de una sección
válida (enum cerrado, imposible un valor inválido). El caso "sin sección" se
maneja en el controller como estado `null`, no como fallo de dominio.

### Persistencia

Declaración explícita conforme §5: **sin persistencia**. La selección de
sección es estado efímero de sesión (app stateless); no se escribe a disco,
preferencias ni almacenamiento local. No existe repository de persistencia ni
data source local.

## Criterios de finalización

- Todos los RF verificables y cumplidos, y los casos límite resueltos.
- El contenido de las 4 secciones es trazable a la referencia citada y revisado.
- El motor de contenido (sección → contenido con sus bloques destacados) cubierto por tests unitarios, incluida la cobertura 4/4 (CL-7).
- Sin dependencias nuevas y sin persistencia.
- Cumple §2 de la constitución: casos de uso, ausencia de repositorio justificada,
  estrategia de fallos declarada y mecanismo de persistencia declarado.

## Dudas abiertas

- Ninguna: secciones, contenido y bloques destacados quedan definidos en Decisiones de contenido (pendientes solo de tu revisión al aprobar esta spec).