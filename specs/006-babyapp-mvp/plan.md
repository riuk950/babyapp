# Plan 006 — Tips rápidos de rutina diaria

Traduce `specs/006-babyapp-mvp/spec.md` a una estructura implementable que
respeta la constitución: sin dependencias nuevas (§1 y RNF-6), Clean Architecture
con capas Domain/Presentation (§3), stateless (§5), tests en verde (§4),
identificadores en inglés/mensajes en español vía l10n (§6) y requisitos
mínimos de spec (§2).

## 1. Dependencias — RNF-6 · constitución §1

Sin dependencias nuevas: la función es una guía estática por momento y franja.
La aprobación HTTP/GPS de la constitución es solo para funciones de clima y no
se usa aquí. `flutter test` y `flutter analyze` ya presentes. Strings de UI
centralizados vía l10n (lib/app_localizations.dart).

## 2. Estructura de módulos (Clean Architecture §3)

```
lib/
  main.dart                                          → arranque + MaterialApp con delegates l10n   · §6
  core/
    domain/                                          → LÓGICA PURA (sin framework)                · §3A
      age/
        age_band.dart                                → franjas y límites [0,3)[3,12)[12,36)[36,60] (fuente única) · RF-2, CL-3
      routine/
        routine_moment.dart                          → enum de los 6 momentos del día + etiquetas · RF-1, CL-8
        routine_tip.dart                             → modelo tipado (RoutineTip { message, source }) · RF-3, RF-4
        routine_guide.dart                           → modelo tipado (RoutineGuide { momentId, ageBandId, tips }) · RF-3
        routine_content.dart                         → contenido 6×4 + tipsFor(Moment?, AgeBand?) · RF-1..RF-4, RF-6, CL-3/8
  features/routine/
    presentation/
      routine_controller.dart                        → estado efímero (momento + franja elegidos) · RF-1, RF-2, RNF-3, CL-1/2/6
      routine_page.dart                              → renderiza lista de momentos y tips por día  · RF-1..RF-6, RNF-2/5, CL-4/5/9/10
      l10n/
        app_localizations.dart                       → centraliza strings español (ARB)           · §6
test/
  core/domain/routine/routine_moment_test.dart       · RF-1, CL-8
  core/domain/routine/routine_content_test.dart      · RF-1..RF-4, RF-6, CL-3/8
  core/domain/age/age_band_test.dart                 · RF-2, CL-3
  features/routine/presentation/routine_controller_test.dart · RF-1, RF-2, CL-1/2/6/7
  features/routine/presentation/routine_page_test.dart       · RF-1..RF-6, RNF-2/5, §6
```

**Capa Data: ausente** (justificado §2.3): la función no tiene fuente de datos
ni I/O; el contenido vive como constantes en `core/domain/`. No hay repository.

**Coordinación (fuente única, CL-3)**: `core/domain/age/age_band.dart` es la
definición compartida de franjas que las funciones 001, 002, 004 y 005 también
usan; esta función importa la misma fuente y los tests verifican la igualdad de
límites (CL-3). La pantalla será el `home` temporal de `main.dart`; la
navegación final no pertenece a esta spec y se define en un paso de integración
posterior.

## 3. Modelo de datos — RF-3, RF-4 con ejemplo

El contenido vive como constantes Dart tipadas en `core/domain/` (determinista,
RNF-4, sin async). El JSON es el formato canónico de cada entrada (informativo;
nunca se persiste, §5) y sirve de contrato si el contenido migrara a asset:

```json
{
  "momentId": "morning",
  "label": "Mañana",
  "tips": [
    {
      "ageBandId": "baby0to3",
      "items": [
        {
          "message": "Abre las cortinas para que la luz natural ayude a regular el ritmo circadiano del bebé.",
          "source": "Recomendación de la OMS"
        },
        {
          "message": "Habla o canta al bebé mientras lo vistes, para estimular su lenguaje.",
          "source": "Recomendación de la AAP"
        }
      ]
    }
  ]
}
```

Modelos en `core/domain/routine/`:
- `RoutineMoment` enum con los 6 momentos (morning, nap, bath, feeding,
  play, night) y su etiqueta en español (RF-1).
- `RoutineTip` { message: String, source: String } — un tip con su fuente
  (RF-3, RF-4).
- `RoutineGuide` { moment: RoutineMoment, ageBand: AgeBand,
  tips: List<RoutineTip> } — tips de un momento para una franja.
- `contentFor(RoutineMoment?, AgeBand?)` → `null` sin momento o sin franja
  (RF-1, RF-2, CL-1, CL-2); la función devuelve los tips o `null`.
- `availableMoments()` → lista de los 6 momentos (RF-1).
- Disclaimer como constante única siempre disponible (RF-6).

Regla de contenido (RF-3, CL-3): un momento sin tips para una franja se omite
del render (no se muestra vacía); un momento sin tips en las 4 franjas es un
error de contenido y no se mostrará.

## 4. Comandos, salidas y códigos de salida

| Comando | Salida esperada | Exit code |
|---|---|---|
| `flutter pub get` | `Got dependencies!` (sin cambios) | 0 |
| `flutter analyze` | `No issues found!` | 0 (≠0 si hay hallazgos) |
| `flutter test` | `All tests passed!` | 0 (≠0 si algún test falla) |
| `flutter run` | App lanzada en dispositivo | 0 al detener con Ctrl+C (130); 1 si compila mal |

## 5. Decisiones técnicas justificadas (y alternativa descartada)

1. **Contenido en constantes Dart tipadas en `core/domain/`** · RF-3, RNF-4.
   Descartado: cargar JSON como asset (añade async para contenido estático;
   RNF-1).
2. **Momentos como `enum` fijo de 6 valores** · RF-1, RNF-4. Descartado:
   momentos como strings sueltos (errores de escritura y contenido no trazable).
3. **Tips como mensajes cortos, sin expandibilidad** · RF-3, RF-5, HU-4.
   Descartado: tips expandibles con detalle (complejidad innecesaria para
   mensajes de 2 líneas; la usuaria quiere leer rápido).
4. **Franjas compartidas en `core/domain/age/age_band.dart` como fuente
   única** · RF-2, CL-3. Descartado: definir franjas duplicadas por función
   (riesgo de desincronización con 001/002/004/005).
5. **Capa Data ausente, justificada** · §2, §3. Descartado: repository
   genérico vacío innecesario para contenido estático sin I/O.
6. **Estado efímero con `ChangeNotifier` de Flutter** en el controller ·
   RF-1, RF-2, RNF-3. Descartado: `provider`/`riverpod` (dependencia extra
   contra el stack mínimo).
7. **Sin persistencia** · RNF-3. Descartado: `shared_preferences` (nada que
   conservar).
8. **Todos los tips con el mismo peso visual** · RF-5. Descartado: niveles de
   prioridad o urgencia (la spec los rechaza explícitamente; es una guía
   orientativa, no un sistema de alertas).
9. **Fuente referenciada en cada tip** · RF-3, HU-3. Descartado: fuente solo
   al final de la sección (la usuaria no sabría qué tip viene de qué fuente).
10. **l10n centralizada vía `MaterialApp` con `localizationsDelegates`** · §6.
    Descartado: strings hardcodeados en widgets (no centralizados; rompe §6).

## 6. Estrategia de tests — §4

`test/core/domain/routine/routine_moment_test.dart` · RF-1, CL-8: los 6
momentos con sus etiquetas en español; orden estable; sin valores fuera de
rango (enum cerrado).

`test/core/domain/routine/routine_content_test.dart` · RF-1..RF-4, RF-6,
CL-3, CL-8: 6×4 (toda combinación momento×franja tiene al menos 1 tip);
cada tip tiene mensaje corto (≤2 líneas) y fuente no vacía; disclaimer
presente siempre (constante única); determinismo (misma entrada → mismo
contenido); momento sin tips para una franja → se omite (CL-3); momento
sin tips en las 4 franjas → error y no se muestra; sin momento → `null`;
sin franja → `null`.

`test/core/domain/age/age_band_test.dart` · RF-2, CL-3: pertenencia en 0, 3,
12, 36, 60 meses; límites iguales a la definición compartida de 001/002/004/005.

`test/features/routine/presentation/routine_controller_test.dart` · RF-1,
RF-2, CL-1, CL-2, CL-6, CL-7: sin momento → sin tips y aviso médico; sin
franja → sin tips y aviso médico; elegir momento y franja → tips; cambiar
momento → sustituye; cambiar franja → sustituye; misma selección dos veces
→ idempotente; reinicio → `null`.

`test/features/routine/presentation/routine_page_test.dart` (widget) ·
RF-1..RF-6, RNF-2, RNF-5, §6: lista con 6 momentos; contenido tras elegir
momento y franja; tips con mensaje y fuente; aviso médico siempre visible
(con y sin selección); scroll de contenido largo; layout ≥320 dp; etiquetas
vía l10n en español.

Verificación de fin: `flutter pub get && flutter analyze && flutter test` →
0/0/0.

## 7. Cobertura RF ↔ partes

| RF | Módulo | Tests |
|---|---|---|
| RF-1 | `core/domain/routine/routine_moment.dart` + `routine_content.dart` + controller | moment + content + controller + page |
| RF-2 | `core/domain/age/age_band.dart` + `routine_content.dart` + controller | age_band + content + controller |
| RF-3 | `core/domain/routine/routine_guide.dart` + `routine_content.dart` + page | guide + content + page |
| RF-4 | `core/domain/routine/routine_tip.dart` + `routine_content.dart` + page | tip + content + page |
| RF-5 | `core/domain/routine/routine_content.dart` (pureza, mismo peso) | content |
| RF-6 | `core/domain/routine/routine_content.dart` (disclaimer constante) | content + page |
