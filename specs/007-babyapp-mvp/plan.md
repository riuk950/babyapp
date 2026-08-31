# Plan 007 — Primeros auxilios básicos

Traduce `specs/007-babyapp-mvp/spec.md` a una estructura implementable que
respeta la constitución: sin dependencias nuevas (§1 y RNF-6), Clean Architecture
con capas Domain/Presentation (§3), stateless (§5), tests en verde (§4),
identificadores en inglés/mensajes en español vía l10n (§6) y requisitos
mínimos de spec (§2).

## 1. Dependencias — RNF-6 · constitución §1

Sin dependencias nuevas: la función es una guía estática por emergencia y
franja. La aprobación HTTP/GPS de la constitución es solo para funciones de
clima y no se usa aquí. `flutter test` y `flutter analyze` ya presentes. Strings
de UI centralizados vía l10n (lib/app_localizations.dart).

## 2. Estructura de módulos (Clean Architecture §3)

```
lib/
  main.dart                                          → arranque + MaterialApp con delegates l10n   · §6
  core/
    domain/                                          → LÓGICA PURA (sin framework)                · §3A
      age/
        age_band.dart                                → franjas y límites [0,3)[3,12)[12,36)[36,60] (fuente única) · RF-2, CL-3
      firstaid/
        emergency_type.dart                          → enum de las situaciones de emergencia + etiquetas · RF-1, CL-8
        severity_level.dart                          → enum de gravedad (urgency / consult)        · RF-5, CL-8
        firstaid_step.dart                           → modelo tipado (FirstAidStep { order, text }) · RF-3
        firstaid_guide.dart                          → modelos tipados (EmergencyGuide, FirstAidGuide) · RF-2..RF-5
        firstaid_content.dart                        → contenido por emergencia·franja + contentFor(Emergency?, AgeBand?) · RF-1..RF-5, CL-3/8
  features/firstaid/
    presentation/
      firstaid_controller.dart                       → estado efímero (emergencia + franja elegidos) · RF-1, RF-2, RNF-3, CL-1/2/6/7
      firstaid_page.dart                             → renderiza lista y pasos por emergencia       · RF-1..RF-6, RNF-2/5, CL-4/5/9/10/11
      l10n/
        app_localizations.dart                       → centraliza strings español (ARB)             · §6
test/
  core/domain/firstaid/emergency_type_test.dart      · RF-1, CL-8
  core/domain/firstaid/severity_level_test.dart      · RF-5, CL-8
  core/domain/firstaid/firstaid_content_test.dart    · RF-1..RF-5, CL-3/8
  core/domain/age/age_band_test.dart                 · RF-2, CL-3
  features/firstaid/presentation/firstaid_controller_test.dart · RF-1, RF-2, CL-1/2/6/7
  features/firstaid/presentation/firstaid_page_test.dart       · RF-1..RF-6, RNF-2/5, §6
```

**Capa Data: ausente** (justificado §2.3): la función no tiene fuente de datos
ni I/O; el contenido vive como constantes en `core/domain/`. No hay repository.

**Coordinación (fuente única, CL-3)**: `core/domain/age/age_band.dart` es la
definición compartida de franjas que las funciones 001, 002, 004, 005 y 006
también usan; esta función importa la misma fuente y los tests verifican la
igualdad de límites (CL-3). La pantalla será el `home` temporal de `main.dart`;
la navegación final no pertenece a esta spec y se define en un paso de
integración posterior.

## 3. Modelo de datos — RF-3, RF-4, RF-5 con ejemplo

El contenido vive como constantes Dart tipadas en `core/domain/` (determinista,
RNF-4, sin async). El JSON es el formato canónico de cada entrada (informativo;
nunca se persiste, §5) y sirve de contrato si el contenido migrara a asset:

```json
{
  "emergencyType": "choking",
  "label": "Atragantamiento",
  "ageBandId": "baby0to3",
  "severity": "urgency",
  "steps": [
    { "order": 1, "text": "Comprueba si el bebé tose o respira." },
    { "order": 2, "text": "Si no respira, colócalo boca abajo sobre tu antebrazo." },
    { "order": 3, "text": "Da 5 golpes firmes en la espalda entre los omóplatos." }
  ],
  "doNot": [
    { "order": 1, "text": "No introduzcas los dedos en la boca del bebé a ciegas." },
    { "order": 2, "text": "No le des agua ni alimentos." }
  ]
}
```

Modelos en `core/domain/firstaid/`:
- `EmergencyType` enum con las 12 situaciones de emergencia (choking, burns,
  falls, bites_stings, seizures, high_fever, bleeding_wounds, poisoning,
  head_injury, anaphylaxis, drowning, foreign_object) y su etiqueta en español
  (RF-1).
- `SeverityLevel` enum con dos valores: `urgency` y `consult`, con su etiqueta
  y guía de acción en español (RF-5); único por emergencia.
- `FirstAidStep` { order: int, text: String } — un paso numerado (RF-3).
- `EmergencyGuide` { emergency: EmergencyType, ageBand: AgeBand,
  severity: SeverityLevel, steps: List<FirstAidStep>,
  doNot: List<FirstAidStep> } — pasos + qué no hacer + gravedad para una
  combinación (RF-2..RF-5).
- `contentFor(EmergencyType?, AgeBand?)` → `null` sin emergencia o sin franja
  (RF-1, RF-2, CL-1, CL-2).
- `availableEmergencies()` → lista de las 12 situaciones (RF-1).
- Disclaimer como constante única siempre disponible (RF-6).

Regla de contenido (RF-3, CL-3): una emergencia sin pasos para una franja se
omite del render (no se muestra vacía); una emergencia sin pasos en las 4
franjas es un error de contenido y no se mostrará. Toda emergencia definida
tiene un `SeverityLevel` válido (CL-8).

## 4. Comandos, salidas y códigos de salida

| Comando | Salida esperada | Exit code |
|---|---|---|
| `flutter pub get` | `Got dependencies!` (sin cambios) | 0 |
| `flutter analyze` | `No issues found!` | 0 (≠0 si hay hallazgos) |
| `flutter test` | `All tests passed!` | 0 (≠0 si algún test falla) |
| `flutter run` | App lanzada en dispositivo | 0 al detener con Ctrl+C (130); 1 si compila mal |

## 5. Decisiones técnicas justificadas (y alternativa descartada)

1. **Contenido en constantes Dart tipadas en `core/domain/`** · RF-2, RF-5,
   RNF-4. Descartado: cargar JSON como asset (añade async para contenido
   estático; RNF-1).
2. **Emergencias como `enum` fijo de 12 valores** · RF-1, RNF-4. Descartado:
   emergencias como strings sueltos (errores de escritura y contenido no
   trazable).
3. **Pasos numerados como datos tipados (`FirstAidStep`)** · RF-3.
   Descartado: pasos como lista de strings (pierde el orden explícito y la
   trazabilidad).
4. **`SeverityLevel` como `enum` cerrado, dato y no heurística** · RF-5,
   CL-8. Descartado: inferir gravedad por palabras clave en runtime
   (introduce falsas alarmas y rompe determinismo).
5. **Franjas compartidas en `core/domain/age/age_band.dart` como fuente
   única** · RF-2, CL-3. Descartado: definir franjas duplicadas por función
   (riesgo de desincronización con 001/002/004/005/006).
6. **Capa Data ausente, justificada** · §2, §3. Descartado: repository
   genérico vacío innecesario para contenido estático sin I/O.
7. **Estado efímero con `ChangeNotifier` de Flutter** en el controller ·
   RF-1, RF-2, RNF-3. Descartado: `provider`/`riverpod` (dependencia extra
   contra el stack mínimo).
8. **Sin persistencia** · RNF-3. Descartado: `shared_preferences` (nada que
   conservar).
9. **Guía numerada, sin expandibilidad** · RF-3, HU-5. Descartado: pasos
   expandibles con detalle (complejidad innecesaria; en una emergencia la
   usuaria quiere leer rápido).
10. **"Qué NO hacer" como sección separada numerada** · RF-4, HU-4.
    Descartado: mezclar lo que no se debe hacer dentro de los pasos positivos
    (distraería y aumentaría el riesgo de confusión).
11. **Indicador de gravedad por etiqueta semántica + estilo, no solo color** ·
    RF-5, RNF-5. Descartado: distinguir solo por color (falla accesibilidad y
    la spec lo exige por texto).
12. **l10n centralizada vía `MaterialApp` con `localizationsDelegates`** ·
    §6. Descartado: strings hardcodeados en widgets (no centralizados; rompe
    §6).

## 6. Estrategia de tests — §4

`test/core/domain/firstaid/emergency_type_test.dart` · RF-1, CL-8: las 12
emergencias con sus etiquetas en español; orden estable; sin valores fuera de
rango (enum cerrado).

`test/core/domain/firstaid/severity_level_test.dart` · RF-5, CL-8: los 2
niveles con su etiqueta y guía en español; sin valores fuera de rango (enum
cerrado).

`test/core/domain/firstaid/firstaid_content_test.dart` · RF-1..RF-5, CL-3,
CL-8: toda emergencia definida tiene contenido en al menos una franja y un
`SeverityLevel` válido; cada paso tiene `order` secuencial y `text` no vacío;
la sección "qué no hacer" (doNot) está presente; disclaimer presente siempre
(constante única); determinismo (misma entrada → mismo contenido); emergencia
sin pasos para una franja → se omite (CL-3); emergencia sin pasos en las 4
franjas → error y no se muestra; sin emergencia → `null`; sin franja → `null`.

`test/core/domain/age/age_band_test.dart` · RF-2, CL-3: pertenencia en 0, 3,
12, 36, 60 meses; límites iguales a la definición compartida de
001/002/004/005/006.

`test/features/firstaid/presentation/firstaid_controller_test.dart` · RF-1,
RF-2, CL-1, CL-2, CL-6, CL-7: sin emergencia → sin guía y aviso médico; sin
franja → sin guía y aviso médico; elegir emergencia y franja → guía; cambiar
emergencia → sustituye; cambiar franja → sustituye; misma selección dos veces
→ idempotente; reinicio → `null`.

`test/features/firstaid/presentation/firstaid_page_test.dart` (widget) ·
RF-1..RF-6, RNF-2, RNF-5, §6: lista con las emergencias; contenido tras elegir
emergencia y franja; pasos numerados + sección "qué no hacer"; indicador de
gravedad distinguido por etiqueta semántica (no solo color); aviso médico
siempre visible (con y sin selección); scroll de contenido largo; layout ≥320
dp; etiquetas vía l10n en español.

Verificación de fin: `flutter pub get && flutter analyze && flutter test` →
0/0/0.

## 7. Cobertura RF ↔ partes

| RF | Módulo | Tests |
|---|---|---|
| RF-1 | `core/domain/firstaid/emergency_type.dart` + `firstaid_content.dart` + controller | emergency_type + content + controller + page |
| RF-2 | `core/domain/age/age_band.dart` + `firstaid_content.dart` + controller | age_band + content + controller |
| RF-3 | `core/domain/firstaid/firstaid_step.dart` + `firstaid_content.dart` + page | step + content + page |
| RF-4 | `core/domain/firstaid/firstaid_content.dart` + page (sección "qué no hacer") | content + page |
| RF-5 | `core/domain/firstaid/severity_level.dart` + `firstaid_content.dart` + page | severity + content + page |
| RF-6 | `core/domain/firstaid/firstaid_content.dart` (disclaimer constante) | content + page |
