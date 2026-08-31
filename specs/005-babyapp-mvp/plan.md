# Plan 005 — Señales de alerta

Traduce `specs/005-babyapp-mvp/spec.md` a una estructura implementable que
respeta la constitución: sin dependencias nuevas (§1 y RNF-6), Clean Architecture
con capas Domain/Presentation (§3), stateless (§5), tests en verde (§4),
identificadores en inglés/mensajes en español vía l10n (§6) y requisitos
mínimos de spec (§2).

## 1. Dependencias — RNF-6 · constitución §1

Sin dependencias nuevas: la función es una guía estática por franja. La
aprobación HTTP/GPS de la constitución es solo para funciones de clima y no se
usa aquí. `flutter test` y `flutter analyze` ya presentes. Strings de UI
centralizados vía l10n (lib/app_localizations.dart).

## 2. Estructura de módulos (Clean Architecture §3)

```
lib/
  main.dart                                          → arranque + MaterialApp con delegates l10n   · §6
  core/
    domain/                                          → LÓGICA PURA (sin framework)                · §3A
      age/
        age_band.dart                                → franjas y límites [0,3)[3,12)[12,36)[36,60] (fuente única) · RF-1, CL-3
      alerts/
        alert_sign.dart                              → enum de nivel de urgencia (urgency / scheduled) · RF-3, CL-8
        alert_guide.dart                             → modelos tipados (AlertGuide, AreaAlerts, AlertSignal) · RF-2, RF-3, RF-5
        alert_content.dart                           → contenido 4/4 + contentFor(AgeBand?) y disclaimer · RF-1..RF-3, RF-5, CL-8/10
  features/alerts/
    presentation/
      alert_controller.dart                          → estado efímero de sesión (franja elegida)  · RF-1, RF-4, RNF-3, CL-1/2/6/9
      alert_page.dart                                → renderiza lista de franjas y señales por área · RF-1..RF-5, RNF-2/5, CL-1/4/5/7/10
      l10n/
        app_localizations.dart                       → centraliza strings español (ARB)           · §6
test/
  core/domain/age/age_band_test.dart                 · RF-1, CL-3
  core/domain/alerts/alert_guide_test.dart           · RF-2, RF-3, RF-5, CL-8, CL-10
  core/domain/alerts/alert_content_test.dart         · RF-1, RF-2, RF-3, RF-5, CL-8, CL-10
  features/alerts/presentation/alert_controller_test.dart · RF-1, RF-4, CL-1, CL-2, CL-6, CL-9
  features/alerts/presentation/alert_page_test.dart        · RF-1..RF-5, RNF-2/5, §6
```

**Capa Data: ausente** (justificado §2.3): la función no tiene fuente de datos
ni I/O; el contenido vive como constantes en `core/domain/`. No hay repository.

**Coordinación (fuente única, CL-3)**: `core/domain/age/age_band.dart` es la
definición compartida de franjas que las funciones 001, 002 y 004 también usan;
esta función importa la misma fuente y los tests verifican la igualdad de
límites (CL-3). Las 5 áreas de desarrollo coinciden con la función 004
(inventario cerrado en `core/domain/alerts/`; no se reutiliza el enum de 004
para no acoplar funciones, ver decisión 8). La pantalla será el `home` temporal
de `main.dart` (igual que en 002/003/004); la navegación final no pertenece a
esta spec y se define en un paso de integración posterior.

## 3. Modelo de datos JSON — RF-2, RF-3 con ejemplo

El contenido vive como constantes Dart tipadas en `core/domain/` (determinista,
RF-5, sin async). El JSON es el formato canónico de cada entrada (informativo;
nunca se persiste, §5) y sirve de contrato si el contenido migrara a asset:

```json
{
  "ageBandId": "baby0to3",
  "label": "0–3 meses",
  "rangeMonths": "[0,3)",
  "areas": [
    {
      "area": "gross_motor",
      "label": "Motricidad gruesa",
      "signals": [
        {
          "signal": "No sostiene la cabeza firme",
          "level": "scheduled",
          "action": "Consulta pronto con tu pediatra (en 24–48 h).",
          "isUrgency": false
        },
        {
          "signal": "Dificultad para respirar (cianosis en labios)",
          "level": "urgency",
          "action": "Acude a urgencias de inmediato.",
          "isUrgency": true
        }
      ]
    },
    {
      "area": "language",
      "label": "Lenguaje",
      "signals": []
    }
  ],
  "medicalDisclaimer": "Esta información es orientativa y no sustituye el consejo de un profesional de salud."
}
```

Modelos en `core/domain/alerts/`:
- `AlertLevel` enum con dos valores: `urgency` y `scheduled` (único por señal,
  RF-3) y su etiqueta/gua en español (RF-3).
- `AlertSignal { signal, level, action }` — una señal con su nivel (RF-3).
- `AreaAlerts { area, label, signals: List<AlertSignal> }` — señales de un área.
- `AlertGuide { ageBand, label, rangeMonths, areas: List<AreaAlerts>,
  medicalDisclaimer }`.
- `contentFor(AgeBand?)` → `null` sin franja (RF-1); disclaimer constante única
  siempre disponible (RF-3). `AlertLevel` es mapeable a texto de acción que la
  UI muestra; el nivel nunca se deduce por heurística, es dato (CL-11).

Regla de contenido (RF-2, CL-10): un área con `signals` vacío dentro de una
franja se omite del render (no se muestra vacía); un área sin señales en las 4
franjas es un error de contenido y no se mostrará.

## 4. Comandos, salidas y códigos de salida

| Comando | Salida esperada | Exit code |
|---|---|---|
| `flutter pub get` | `Got dependencies!` (sin cambios) | 0 |
| `flutter analyze` | `No issues found!` | 0 (≠0 si hay hallazgos) |
| `flutter test` | `All tests passed!` | 0 (≠0 si algún test falla) |
| `flutter run` | App lanzada en dispositivo | 0 al detener con Ctrl+C (130); 1 si compila mal |

## 5. Decisiones técnicas justificadas (y alternativa descartada)

1. **Contenido en constantes Dart tipadas en `core/domain/`** · RF-2, RF-3, RF-5. Descartado: cargar JSON como asset (añade async para contenido estático; RNF-1).
2. **Franjas compartidas en `core/domain/age/age_band.dart` como fuente única** · RF-1, CL-3. Descartado: definir franjas duplicadas por función (riesgo de desincronización con 001/002/004).
3. **Nivel de urgencia como `enum` cerrado (`AlertLevel`), único por señal** · RF-3, CL-8. Descartado: texto libre para el nivel (inconsistente y no determinista; rompería RF-5).
4. **Nivel como dato, no heurística** · CL-11. Descartado: inferir urgencia por palabras clave o umbrales en runtime (introduce falsas alarmas y rompe determinismo).
5. **Capa Data ausente, justificada** · §2, §3. Descartado: repository genérico vacío innecesario para contenido estático sin I/O.
6. **Estado efímero con `ChangeNotifier` de Flutter** en el controller · RF-1, RF-4, RNF-3. Descartado: `provider`/`riverpod` (dependencia extra contra el stack mínimo).
7. **Sin persistencia** · RNF-3. Descartado: `shared_preferences` (nada que conservar).
8. **Áreas de desarrollo como enum propio en `core/domain/alerts/`** (coincidente con 004 pero no compartido) · RF-2, RF-3. Descartado: importar el enum de la función 004 (acopla funciones que deben evolucionar por separado; 005 añade además señales/áreas no presentes en 004). Los tests verifican la igualdad de las 5 áreas con 004 (fuente única conceptual).
9. **Diferenciación del nivel de urgencia por etiqueta semántica + estilo, no solo color** · RF-3, RNF-5. Descartado: distinguir solo por color (falla accesibilidad y la spec lo exige por texto).
10. **l10n centralizada vía `MaterialApp` con `localizationsDelegates`** · §6. Descartado: strings hardcodeados en widgets (no centralizados; rompe §6).

## 6. Estrategia de tests — §4

`test/core/domain/age/age_band_test.dart` · RF-1, CL-3: pertenencia en 0, 3, 12, 36, 60 meses; límites iguales a la definición compartida de 001/002/004.

`test/core/domain/alerts/alert_guide_test.dart` · RF-2, RF-3, RF-5, CL-8, CL-10: modelos; cada señal tiene un único `AlertLevel` válido ("urgency" o "scheduled"); el nivel es dato, no se infiere; determinismo.

`test/core/domain/alerts/alert_content_test.dart` · RF-1, RF-2, RF-3, RF-5, CL-8, CL-10: 4/4 (toda franja con señales en al menos un área y cada señal con su nivel); un área con `signals` vacío en una franja se omite (CL-10); área sin señales en las 4 franjas → error y no se muestra; determinismo; disclaimer presente siempre (constante única); términos clínicos con aclaración embebida; sin franja → `null`.

`test/features/alerts/presentation/alert_controller_test.dart` · RF-1, RF-4, CL-1, CL-2, CL-6, CL-9: sin franja → sin guía y con aviso médico; elegir → guía; cambiar → sustituye; misma franja dos veces → idempotente; reinicio → `null`.

`test/features/alerts/presentation/alert_page_test.dart` (widget) · RF-1..RF-5, RNF-2/5, §6: lista con 4 franjas y rango en meses; señales por área todas a la vez tras elegir; nivel de urgencia distinguido por etiqueta semántica (no solo color); aviso médico siempre visible (con y sin franja); scroll de contenido largo (5 áreas); layout ≥320 dp; etiquetas vía l10n en español.

Verificación de fin: `flutter pub get && flutter analyze && flutter test` → 0/0/0.

## 7. Cobertura RF ↔ partes

| RF | Módulo | Tests |
|---|---|---|
| RF-1 | `core/domain/age/age_band.dart` + `core/domain/alerts/alert_content.dart` + controller | age_band + alert_content + controller + page |
| RF-2 | `core/domain/alerts/alert_guide.dart` + `alert_content.dart` + page | alert_guide + alert_content + page |
| RF-3 | `core/domain/alerts/alert_sign.dart` + `alert_content.dart` + page | alert_guide + alert_content + page |
| RF-4 | `features/alerts/presentation/alert_controller.dart` + page | controller + page |
| RF-5 | `core/domain/alerts/` (pureza + determinismo) | alert_guide + alert_content |
