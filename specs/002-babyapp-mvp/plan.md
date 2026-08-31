# Plan 002 — Cuánto debe dormir por edad

Traduce `specs/002-babyapp-mvp/spec.md` a una estructura implementable que
respeta la constitución: sin dependencias nuevas (§1 y RNF-6), Clean Architecture
con capas Domain/Presentation (§3), stateless (§5), tests en verde (§4),
identificadores en inglés/mensajes en español vía l10n (§6) y requisitos
mínimos de spec (§2).

## 1. Dependencias — RNF-6 · constitución §1

Sin dependencias nuevas: la función es una guía estática. La aprobación
HTTP/GPS de la constitución es solo para funciones de clima y no se usa aquí.
`flutter test` y `flutter analyze` ya presentes. Strings de UI centralizados
vía l10n (lib/app_localizations.dart).

## 2. Estructura de módulos (Clean Architecture §3)

```
lib/
  main.dart                                          → arranque + MaterialApp con delegates l10n   · §6
  core/
    domain/                                          → LÓGICA PURA (sin framework)                · §3A
      age/
        age_band.dart                                → franjas y límites [0,3)[3,12)[12,36)[36,60]  · RF-1, CL-3
      sleep/
        sleep_guide.dart                             → modelo del contenido (campos tipados)      · RF-2, RF-3, RF-5
        sleep_content.dart                           → contenido 4/4 + contentFor(AgeBand?)       · RF-1, RF-2, RF-3, CL-8
  features/sleep/
    presentation/
      sleep_controller.dart                          → estado efímero de sesión (franja elegida)  · RF-1, RF-4, RNF-3, CL-2, CL-6
      sleep_page.dart                                → renderiza lista de franjas y contenido     · RF-1..RF-5, RNF-2, RNF-5, CL-4/5/7
      l10n/
        app_localizations.dart                       → centraliza strings español (ARB)           · §6
test/
  core/domain/sleep/sleep_content_test.dart          · RF-2, RF-3, RF-5, CL-3, CL-8
  core/domain/age/age_band_test.dart                 · RF-1, CL-3
  features/sleep/presentation/sleep_controller_test.dart · RF-1, RF-4, CL-2, CL-6, CL-9
  features/sleep/presentation/sleep_page_test.dart        · RF-1..RF-5, RNF-2, RNF-5, §6
```

**Capa Data: ausente** (justificado §2.3): la función no tiene fuente de datos
ni I/O; el contenido vive como constantes en `core/domain/`. No hay repository.

**Coordinación (fuente única, CL-3)**: `core/domain/age/age_band.dart` es la
definición compartida de franjas que la función 001 también usa; ambas funciones
importan la misma fuente y los tests verifican la igualdad de límites (CL-3).
La navegación entre funciones no pertenece a esta spec.

## 3. Modelo de datos JSON — RF-2, RF-3 con ejemplo

El contenido vive como constantes Dart tipadas en `core/domain/` (determinista,
RF-5, sin async). El JSON es el formato canónico de cada entrada (informativo;
nunca se persiste, §5) y sirve de contrato si el contenido migrara a asset:

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

`SleepGuide` (core/domain): campos `band`, `label`, `rangeMonths`,
`totalHoursPerDay`, `naps`, `bedtimeSchedule`, `insufficientSleepSigns`,
`alarmSigns`, `medicalDisclaimer`. La función `guideFor(AgeBand?)` devuelve el
contenido o `null` sin franja (RF-1). Los términos clínicos incluyen ya su
aclaración cotidiana (regla de redacción de la spec, RF-2).

## 4. Comandos, salidas y códigos de salida

| Comando | Salida esperada | Exit code |
|---|---|---|
| `flutter pub get` | `Got dependencies!` (sin cambios) | 0 |
| `flutter analyze` | `No issues found!` | 0 (≠0 si hay hallazgos) |
| `flutter test` | `All tests passed!` | 0 (≠0 si algún test falla) |
| `flutter run` | App lanzada en dispositivo | 0 al detener con Ctrl+C (130); 1 si compila mal |

## 5. Decisiones técnicas justificadas (y alternativa descartada)

1. **Contenido en constantes Dart tipadas en `core/domain/`** · RF-2, RF-3, RF-5. Descartado: cargar JSON como asset (añade async y estados de carga para contenido estático; RNF-1).
2. **Franjas compartidas en `core/domain/age/age_band.dart` como fuente única** · RF-1, CL-3. Descartado: definir AgeBand duplicada en cada función (riesgo de desincronización con la función 001).
3. **Capa Data ausente, justificada** · §2, §3. Descartado: repository genérico vacío innecesario para contenido estático sin I/O.
4. **Estado efímero con `ChangeNotifier` de Flutter** en el controller · RF-1, RF-4, RNF-3. Descartado: `provider`/`riverpod` (dependencia extra contra el stack mínimo).
5. **Sin persistencia** · RNF-3. Descartado: `shared_preferences` (nada que conservar).
6. **Redacción con aclaraciones embebidas** para términos clínicos · RF-2, RF-3. Descartado: glosario interactivo o reescritura condicional (complejidad sin valor para el MVP).
7. **Reinicio sin estado**: al abrir la app la franja seleccionada es `null` (CL-6) · RNF-3. Descartado: restaurar la última selección (rompería stateless).
8. **l10n centralizada vía `MaterialApp` con `localizationsDelegates`** · §6. Descartado: strings hardcodeados en widgets (no centralizados; rompe §6).

## 6. Estrategia de tests — §4

`test/core/domain/age/age_band_test.dart` · RF-1, CL-3: pertenencia en 0, 3, 12, 36, 60 meses; límites iguales a la definición compartida de 001.
`test/core/domain/sleep/sleep_content_test.dart` · RF-2, RF-3, RF-5, CL-3, CL-8: las 4 franjas devuelven todos los campos completos (4/4); determinismo (misma franja → mismo contenido); disclaimer presente siempre; cada término clínico de las alarmas lleva aclaración; sin franja → `null`.
`test/features/sleep/presentation/sleep_controller_test.dart` · RF-1, RF-4, CL-2, CL-6, CL-9: sin franja → sin guía y con aviso médico; elegir franja → guía; cambiar → sustituye; misma franja dos veces → idempotente; reinicio → `null`.
`test/features/sleep/presentation/sleep_page_test.dart` (widget) · RF-1..RF-5, RNF-2, RNF-5, §6: lista con rango en meses; contenido tras elegir; bloque de alarma destacado sin sustituir el informativo; aviso médico siempre visible; scroll de contenido largo; layout ≥320 dp; etiquetas vía l10n en español.

Verificación de fin: `flutter pub get && flutter analyze && flutter test` → 0/0/0.

## 7. Cobertura RF ↔ partes

| RF | Módulo | Tests |
|---|---|---|
| RF-1 | `core/domain/age/age_band.dart` + `core/domain/sleep/sleep_content.dart` + controller | age_band + sleep_content + controller + page |
| RF-2 | `core/domain/sleep/sleep_guide.dart` + `sleep_content.dart` + page | sleep_content + page |
| RF-3 | `core/domain/sleep/sleep_content.dart` + page | sleep_content + page |
| RF-4 | `features/sleep/presentation/sleep_controller.dart` + page | controller + page |
| RF-5 | `core/domain/sleep/sleep_content.dart` (pureza) | sleep_content |
