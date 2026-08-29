# Tasks 002 — Cuánto debe dormir por edad

Tareas en orden de dependencia. Cada una ≤ 20–30 min. Coordinación con
`specs/002-babyapp-mvp/spec.md` y `plan.md`. Identificadores en inglés,
mensajes de usuario en español (principio 6). Nada en `core/` importa Flutter
(principio 3). Sin dependencias nuevas (RNF-6).

## Fase 0 — Base compartida y lógica pura (`core/`)

- [ ] T1. Fuente única de franjas en `core/age/age_band.dart`
      RF: RF-1 · CL-3 · plan §2
      Hecho cuando: define las 4 franjas con límites [0,3) [3,12) [12,36) [36,60],
      la función 001 la reutiliza sin copias, y `flutter analyze` no reporta nada.

- [ ] T2. Modelo `SleepGuide` en `core/sleep/sleep_guide.dart`
      RF: RF-2, RF-3 · plan §3
      Hecho cuando: define los campos tipados (`band`, `label`, `rangeMonths`,
      `totalHoursPerDay`, `naps`, `bedtimeSchedule`, `insufficientSleepSigns`,
      `alarmSigns`, `medicalDisclaimer`) sin importar Flutter.

- [ ] T3. Contenido 4/4 en `core/sleep/sleep_content.dart` + `guideFor(AgeBand?)`
      RF: RF-1, RF-2, RF-3, RF-5 · CL-8 · plan §3
      Hecho cuando: las 4 franjas tienen completo cada campo, sin franja → `null`,
      el disclaimer está en todas, y cada término clínico lleva aclaración.

- [ ] T4. Tests unitarios de `core/`
      RF: RF-1, RF-2, RF-3, RF-5 · CL-3, CL-8 · plan §6
      Hecho cuando: `age_band_test` y `sleep_content_test` pasan (pertenencia en
      0/3/12/36/60; 4/4; determinismo; límites coinciden con 001).

## Fase 1 — Interfaz (`features/sleep/`)

- [ ] T5. Controller de sesión efímera
      RF: RF-1, RF-4 · CL-2, CL-6, CL-9 · RNF-3 · plan §2, §5(4,7)
      Hecho cuando: los tests del controller verifican sin franja → guía `null`
      con aviso médico; elegir → guía; cambiar → sustituye; misma franja dos veces
      → idempotente; reinicio → `null`.

- [ ] T6. Pantalla (renderiza y delega)
      RF: RF-1..RF-5 · RNF-2, RNF-5 · CL-4/5/7 · plan §2
      Hecho cuando: lista con etiqueta y rango en meses; tras elegir muestra
      horas, siestas, horario y señales; bloque de alarma destacado sin sustituir
      el contenido informativo; aviso médico siempre visible; scroll de contenido
      largo; legible a ≥320 dp.

- [ ] T7. Integración en `main.dart` (home = SleepPage)
      RF: RF-1 · RNF-5 · plan §2
      Hecho cuando: la app arranca directamente en la pantalla de sueño, con tema
      legible y sin la demo del contador.

## Fase 2 — Verificación

- [ ] T8. Widget test de la pantalla
      RF: RF-1..RF-5 · RNF-2, RNF-5 · principio 6 · plan §6
      Hecho cuando: el widget test cubre lista con rangos, contenido tras elegir,
      aviso médico, bloque de alarma, scroll, layout ≥320 dp y etiquetas en español.

- [ ] T9. Gate final
      RF: todos · principio 4 · plan §4
      Hecho cuando: `flutter pub get && flutter analyze && flutter test`
      devuelven 0/0/0 y la cobertura RF↔partes del plan §7 está verde.

**Nota de coordinación**: T1 está diseñada para ejecutarse junto a la función 001
(plan 001/T6), que dejará de definir su propia `AgeBand`. Si 001 aún no está
implementada, T1 crea la fuente única y 001 la consumirá al implementarse.