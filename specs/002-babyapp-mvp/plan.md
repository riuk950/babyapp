# Plan 002 — Cuánto debe dormir por edad

Traduce `specs/002-babyapp-mvp/spec.md` a una estructura implementable que
respeta la constitución: sin dependencias nuevas (principio 1 y RNF-6), lógica
pura aislada (principio 3), stateless (principio 5), tests en verde (principio
4) y mensajes visibles en español (principio 6).

## 1. Dependencias — RNF-6 · constitución principio 1

Sin dependencias nuevas: la función es una guía estática. La aprobación
HTTP/GPS de la constitución es solo para funciones de clima y no se usa aquí.
Junto con `dart:convert` (no aplica: no hay red ni JSON de entrada), `flutter test`
y `flutter analyze` ya presentes.

## 2. Estructura de módulos

```
lib/
  main.dart                       → arranque + tema (pantalla inicial = sueño)   · RF-1, RNF-5
  core/                           → LÓGICA PURA (sin importar flutter)          · principio 3, RNF-4
    age/
      age_band.dart               → franjas y límites [0,3)[3,12)[12,36)[36,60]  · RF-1, CL-3
    sleep/
      sleep_guide.dart            → modelo del contenido (campos tipados)       · RF-2, RF-3, RF-5
      sleep_content.dart          → contenido 4/4 + guía para una franja        · RF-1, RF-2, RF-3, CL-8
  features/sleep/
    application/
      sleep_controller.dart       → estado efímero de sesión (franja elegida)   · RF-1, RF-4, RNF-3, CL-2, CL-6
    presentation/
      sleep_page.dart             → renderiza lista de franjas y contenido      · RF-1..RF-5, RNF-2, RNF-5, CL-4/5/7
test/
  core/sleep/sleep_content_test.dart      → RF-2, RF-3, RF-5, CL-3, CL-8
  core/age/age_band_test.dart             → RF-1, CL-3
  features/sleep/sleep_controller_test.dart · RF-1, RF-4, CL-2, CL-6, CL-9
  features/sleep/sleep_page_test.dart       · RF-1..RF-5, RNF-2, RNF-5, principio 6
```

**Coordinación (fuente única, CL-3)**: `core/age/age_band.dart` es la definición
compartida de franjas que la función 001 también usa. Al implementar 002, la
`AgeBand` del plan 001 pasa a vivir en `core/age/` y ambas funciones importan la
misma fuente; los tests verifican la igualdad de límites (CL-3). La navegación
entre la función 001 (clima) y 002 (sueño) no pertenece a ninguna de las dos
specs y se define en un paso de integración posterior, fuera de este plan.

## 3. Modelo de datos JSON — RF-2, RF-3 con ejemplo

El contenido vive como constantes Dart tipadas en `core/` (determinista, RF-5,
sin async). El JSON es el formato canónico de cada entrada (informativo; nunca
se persiste, principio 5) y sirve de contrato si el contenido migrara a asset:

```json
{
  "ageBandId": "baby3to12",
  "label": "3–12 meses",
  "rangeMonths": "[3,12)",
  "totalHoursPerDay": "12–16 h",
  "naps": "2–3; desde ~6 meses, 2 siestas de 1–2 h",
  "bedtimeSchedule": "Acostar 19:30–20:30; despertar 6:30–8:00",
  "insufficientSleepSigns": ["irritabilidad diurna", "menos juego",
    ">3–4 despertares nocturnos sin calmarse"],
  "alarmSigns": ["ronquido intenso habitual o pausas respiratorias (paradas
    breves de la respiración) al dormir", "…"],
  "medicalDisclaimer": "Esta información es orientativa y no sustituye el
    consejo de un profesional de salud."
}
```

`SleepGuide` (core): campos `band`, `label`, `rangeMonths`, `totalHoursPerDay`,
`naps`, `bedtimeSchedule`, `insufficientSleepSigns`, `alarmSigns`,
`medicalDisclaimer`. La función `guideFor(AgeBand?)` devuelve el contenido o
`null` sin franja (RF-1). Los términos clínicos incluyen ya su aclaración
cotidiana (regla de redacción de la spec, RF-2).

## 4. Comandos, salidas y códigos de salida

| Comando | Salida esperada | Exit code |
|---|---|---|
| `flutter pub get` | `Got dependencies!` (sin cambios) | 0 |
| `flutter analyze` | `No issues found!` | 0 (≠0 si hay hallazgos) |
| `flutter test` | `All tests passed!` | 0 (≠0 si algún test falla) |
| `flutter run` | App lanzada en dispositivo | 0 al detener con Ctrl+C (130); 1 si compila mal |

## 5. Decisiones técnicas justificadas (y alternativa descartada)

1. **Contenido en constantes Dart tipadas en `core/`** · RF-2, RF-3, RF-5. Descartado: cargar JSON como asset (añade async y estados de carga para contenido estático; RNF-1).
2. **Franjas compartidas en `core/age/age_band.dart` como fuente única** · RF-1, CL-3. Descartado: definir AgeBand duplicada en cada función (riesgo de desincronización con la función 001).
3. **Sin repository/efectos**: no hay red ni GPS (RNF-6), así que no hay capa `data/` en esta función · RNF-6. Descartado: repository genérico vacío innecesario.
4. **Estado efímero con `ChangeNotifier` de Flutter** en el controller · RF-1, RF-4, RNF-3. Descartado: `provider`/`riverpod` (dependencia extra contra el stack mínimo).
5. **Sin persistencia** · RNF-3. Descartado: `shared_preferences` (nada que conservar).
6. **Redacción con aclaraciones embebidas** para términos clínicos · RF-2, RF-3. Descartado: glosario interactivo o reescritura condicional (complejidad sin valor para el MVP).
7. **Reinicio sin estado**: al abrir la app la franja seleccionada es `null` (CL-6) · RNF-3. Descartado: restaurar la última selección (rompería stateless).

## 6. Estrategia de tests — principio 4

`test/core/age/age_band_test.dart` · RF-1, CL-3: pertenencia en 0, 3, 12, 36, 60 meses; límites iguales a la definición compartida de 001.
`test/core/sleep/sleep_content_test.dart` · RF-2, RF-3, RF-5, CL-3, CL-8: las 4 franjas devuelven todos los campos completos (4/4); determinismo (misma franja → mismo contenido); disclaimer presente siempre; cada término clínico de las alarmas lleva aclaración; sin franja → `null`.
`test/features/sleep/application/sleep_controller_test.dart` · RF-1, RF-4, CL-2, CL-6, CL-9: sin franja → sin guía y con aviso médico; elegir franja → guía; cambiar → sustituye; misma franja dos veces → idempotente; reinicio → `null`.
`test/features/sleep/presentation/sleep_page_test.dart` (widget) · RF-1..RF-5, RNF-2, RNF-5, principio 6: lista con rango en meses; contenido tras elegir; bloque de alarma destacado sin sustituir el informativo; aviso médico siempre visible; scroll de contenido largo; layout ≥320 dp; etiquetas en español.

Verificación de fin: `flutter pub get && flutter analyze && flutter test` → 0/0/0.

## 7. Cobertura RF ↔ partes

| RF | Módulo | Tests |
|---|---|---|
| RF-1 | `core/age/age_band.dart` + `core/sleep/sleep_content.dart` + controller | age_band + sleep_content + controller + page |
| RF-2 | `core/sleep/sleep_guide.dart` + `sleep_content.dart` + page | sleep_content + page |
| RF-3 | `core/sleep/sleep_content.dart` + page | sleep_content + page |
| RF-4 | `application/sleep_controller.dart` + page | controller + page |
| RF-5 | `core/sleep/sleep_content.dart` (pureza) | sleep_content |