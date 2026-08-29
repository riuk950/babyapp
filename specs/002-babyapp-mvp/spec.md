# Especificación 002 — Cuánto debe dormir por edad

## Contexto y objetivo

El sueño del bebé es una de las mayores fuentes de dudas en los primeros años.
Esta función ofrece una guía de referencia rápida: al elegir la franja de edad,
la madre ve cuánto debe dormir su hijo (horas totales, siestas, horario
orientativo), qué señales indican sueño insuficiente y cuándo conviene consultar
al pediatra. Objetivo: reducir la incertidumbre y ayudar a distinguir lo normal
de lo preocupante, sin sustituir el consejo médico.

## Usuarios

- Madres, padres y cuidadores de niños de 0 a 5 años.
- Sin formación técnica: la interfaz y el contenido deben ser claros y sin jerga.

## Historias de usuario

- HU-1: Como madre, quiero consultar cuántas horas y siestas necesita mi hijo
  según su edad, para organizar su descanso.
- HU-2: Como usuaria, quiero un horario orientativo de acostarse y despertar,
  para saber cuándo empezar la rutina.
- HU-3: Como usuaria, quiero conocer las señales de sueño insuficiente, para
  reaccionar a tiempo.
- HU-4: Como usuaria, quiero ver cuándo consultar al pediatra, para distinguir
  lo normal de lo preocupante.

## Requisitos funcionales

RF-1 — Selección de franja de edad
- The franjas serán las 4 globales de la app: 0–3 meses, 3–12 meses, 1–3 años y 4–5 años, con límites [0,3), [3,12), [12,36) y [36,60] meses (fuente única compartida con la función 001).
- Where se muestra la lista de franjas, cada opción incluirá su etiqueta y su rango en meses, para guiar la elección incluso en los límites exactos (3, 12, 36 meses).
- Where no hay franja seleccionada, el sistema pedirá elegir una y no mostrará contenido informativo (el aviso médico de RF-3 sí se muestra).
- When la usuaria selecciona una franja, el sistema mostrará la información de esa franja.

RF-2 — Contenido de patrones de sueño
- When hay una franja seleccionada, el sistema mostrará para esa franja: horas totales por día (rango recomendado), número y duración de siestas, horario orientativo de acostarse y despertar, y señales de sueño insuficiente.
- The contenido se mostrará en lenguaje sencillo; los términos clínicos (p. ej. "pausas respiratorias", "letargo") irán siempre acompañados de una aclaración en lenguaje cotidiano (regla de redacción, ver Decisiones de contenido).

RF-3 — Señales de alarma y aviso médico
- Where hay una franja seleccionada, el sistema mostrará el bloque de señales de alarma de esa franja.
- The bloque de alarma destacará visualmente y se distinguirá del contenido informativo.
- The aviso "Esta información es orientativa y no sustituye el consejo de un profesional de salud" se mostrará siempre, incluido el estado sin franja seleccionada (RF-1).

RF-4 — Cambio de franja
- When la usuaria cambia de franja con otra ya visible, el sistema sustituirá todo el contenido por el de la nueva franja sin acciones adicionales.

RF-5 — Respuesta determinista
- When se repite la selección de la misma franja, el sistema devolverá siempre el mismo contenido.

## Requisitos no funcionales

- RNF-1 Rendimiento: el contenido se muestra en la misma interacción, sin llamadas de red.
- RNF-2 Usabilidad: pantalla legible en ≥320 dp de ancho, con scroll para contenido largo.
- RNF-3 Persistencia: ninguna; la selección es estado efímero de sesión (app stateless) y no se conserva al reabrir la app. Elegir una franja en la función 001 no afecta a esta función.
- RNF-4 Mantenibilidad: el contenido y las reglas de franja viven aislados de la interfaz, en lógica pura.
- RNF-5 Accesibilidad: texto legible y con contraste suficiente.
- RNF-6 Autonomía: funciona sin conexión, sin permisos y sin nuevas dependencias (la aprobación HTTP/GPS de la constitución es solo para funciones de clima y no aplica aquí).

## Casos límite

- CL-1 Sin franja seleccionada: se pide elegir; no hay contenido informativo, pero el aviso médico (RF-3) sí se muestra.
- CL-2 Cambio rápido entre franjas: el contenido mostrado corresponde siempre a la última selección (RF-4); seleccionar la misma franja dos veces no cambia el estado (idempotencia).
- CL-3 Límites de las franjas: coinciden exactamente con la función 001 — [0,3), [3,12), [12,36) y [36,60] meses. En el límite exacto (3, 12, 36 meses) la lista muestra el rango de cada franja y la elección la decide la usuaria.
- CL-4 Contenido largo (señales de alarma): el scroll no corta ni oculta información.
- CL-5 Pantalla pequeña u orientación horizontal: el contenido sigue siendo legible (RNF-2).
- CL-6 Reinicio de la app: al reabrir no se conserva la selección (stateless, RNF-3) y se vuelve al estado sin franja.
- CL-7 Texto ampliado (zoom de accesibilidad): el contenido se mantiene legible con scroll, sin cortarse.
- CL-8 Cobertura 4/4: todas las franjas tienen completo cada campo (horas, siestas, horario, señales, alarma).
- CL-9 Selección doble idéntica: elegir dos veces la misma franja no altera ni duplica el contenido.

## Fuera de alcance (MVP)

- Calculadora u horario interactivo (p. ej., siguiente siesta según hora de despertar).
- Registro o seguimiento del sueño del niño.
- Notificaciones, alarmas y multibebé.
- Persistencia de preferencias.
- Franjas adicionales o contenido más fino que las 4 franjas globales.

## Decisiones de contenido

Fuentes de referencia: recomendaciones de sueño infantil de AEP/AAP/NHS (tabla
orientativa por franja). Franjas y límites iguales a la función 001, con una
única fuente de verdad: los límites [0,3), [3,12), [12,36) y [36,60] meses
viven en una definición compartida de la app y ninguna spec los redefine; los
tests verifican que ambas funciones usan los mismos límites.

Regla de redacción: los términos clínicos de las señales de alarma van
acompañados de una aclaración en lenguaje cotidiano al mostrarse (resuelve la
exigencia de lenguaje sencillo de RF-2).

Coherencia aritmética: las horas totales por día son la suma del sueño
nocturno del horario orientativo más las siestas; la tabla está revisada para
que los rangos cuadren (p. ej., 4–5 años: noche 9,5–11,5 h + siesta opcional
0–1 h = 9,5–12,5 h, dentro de 10–13 h).

| Franja | Horas totales/24 h | Siestas | Horario orientativo |
|---|---|---|---|
| 0–3 meses | 14–17 h | 3–4 siestas cortas (15 min–2 h), sin patrón fijo | Sin horario fijo; ventana de sueño 45–75 min; acostar al primer signo de sueño |
| 3–12 meses | 12–16 h | 2–3; desde ~6 meses, 2 siestas de 1–2 h | Acostar 19:30–20:30; despertar 6:30–8:00 |
| 1–3 años | 11–14 h | 1 siesta de tarde, 1–2 h | Acostar 19:30–21:00; despertar 6:30–8:00; siesta no más tarde de las 16:00 |
| 4–5 años | 10–13 h | Sin siesta obligatoria; opcional corta (30–60 min) | Acostar 20:00–21:00; despertar 6:30–7:30 |

Señales de sueño insuficiente:
- 0–3 meses: irritabilidad, frotarse los ojos, bostezos frecuentes, dificultad para dormirse, despertares muy frecuentes.
- 3–12 meses: irritabilidad diurna, menos juego, >3–4 despertares nocturnos sin calmarse.
- 1–3 años: mal humor, rabietas, hiperactividad al final del día, resistencia a dormir.
- 4–5 años: irritabilidad, falta de atención, resistencia a acostarse, despertares nocturnos frecuentes.

Señales de alarma (consultar al pediatra):
- Cualquier franja: ronquido intenso habitual o pausas respiratorias al dormir, respiración ruidosa, sueño excesivo con letargo o mala ganancia de peso, dificultad para despertar, regresión de sueño persistente >2 semanas con irritabilidad.
- Solo 0–3 meses: coloración amoratada/azulada al dormir.

Aviso legal incluido en RF-3: la información no sustituye consejo médico profesional.

## Criterios de finalización

- Todos los RF verificables y cumplidos, y los casos límite resueltos.
- El contenido de la tabla es trazable a la referencia citada, aritméticamente coherente y revisado.
- El motor de contenido (franja → contenido) cubierto por tests unitarios, incluida la cobertura 4/4 (CL-8).
- Los tests verifican que los límites de franjas coinciden con la función 001 (fuente única).
- Sin dependencias nuevas y sin persistencia.

## Dudas abiertas

- Ninguna: la selección de franjas y el contenido quedan definidos en Decisiones de contenido (pendientes solo de tu revisión al aprobar esta spec).