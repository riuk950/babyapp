# Plan 004 — Hitos de desarrollo mes a mes

Traduce `specs/004-babyapp-mvp/spec.md` a una estructura implementable que
respeta la constitución: sin dependencias nuevas (§1 y RNF-6), Clean Architecture
con capas Domain/Presentation (§3), stateless (§5), tests en verde (§4),
identificadores en inglés/mensajes en español vía l10n (§6) y requisitos
mínimos de spec (§2).

## 1. Dependencias — RNF-6 · constitución §1

Sin dependencias nuevas: la función es una guía estática por mes. La aprobación
HTTP/GPS de la constitución es solo para funciones de clima y no se usa aquí.
`flutter test` y `flutter analyze` ya presentes. Strings de UI centralizados
vía l10n (lib/app_localizations.dart).

## 2. Estructura de módulos (Clean Architecture §3)

```
lib/
  main.dart                                          → arranque + MaterialApp con delegates l10n   · §6
  core/
    domain/                                          → LÓGICA PURA (sin framework)                · §3A
      milestones/
        milestone_month.dart                         → enum de los 60 meses + etiqueta/edad       · RF-1, CL-11
        development_area.dart                        → enum de las 5 áreas + etiquetas            · RF-2, RF-3
        milestone_guide.dart                         → modelos tipados (MonthContent, AreaMilestones…) · RF-2, RF-3, RF-5
        milestone_content.dart                       → contenido 60/60 + contentFor(MilestoneMonth?) · RF-1..RF-3, RF-5, CL-8/9
        last_hit_resolver.dart                       → regla "último hito alcanzado" (lookup por área) · RF-2, CL-3, CL-10
  features/milestones/
    presentation/
      milestone_controller.dart                      → estado efímero (mes elegido + filtro de búsqueda) · RF-1, RF-4, RNF-3, CL-1/2/6/12
      milestone_page.dart                            → renderiza lista+búsqueda y contenido por mes   · RF-1..RF-5, RNF-2/5, CL-1/4/5/7/12
      l10n/
        app_localizations.dart                       → centraliza strings español (ARB)           · §6
test/
  core/domain/milestones/milestone_month_test.dart   · RF-1, CL-8, CL-11
  core/domain/milestones/development_area_test.dart  · RF-2, RF-3, CL-8
  core/domain/milestones/milestone_content_test.dart · RF-1, RF-2, RF-3, RF-5, CL-8, CL-9
  core/domain/milestones/last_hit_resolver_test.dart · RF-2, CL-3, CL-10
  features/milestones/presentation/milestone_controller_test.dart · RF-1, RF-4, CL-1, CL-2, CL-6, CL-12
  features/milestones/presentation/milestone_page_test.dart       · RF-1..RF-5, RNF-2/5, §6
```

**Capa Data: ausente** (justificado §2.3): la función no tiene fuente de datos
ni I/O; el contenido vive como constantes en `core/domain/`. No hay repository.

**Coordinación**: la pantalla de esta función será el `home` temporal de
`main.dart` (igual que en 002/003). La navegación final entre las funciones no
pertenece a ninguna spec y se define en un paso de integración posterior.

## 3. Modelo de datos JSON — RF-2, RF-3 con ejemplo

El contenido vive como constantes Dart tipadas en `core/domain/` (determinista,
RF-5, sin async). El JSON es el formato canónico de cada entrada (informativo;
nunca se persiste, §5) y sirve de contrato si el contenido migrara a asset:

```json
{
  "month": 7,
  "label": "Mes 7",
  "areas": [
    {
      "area": "gross_motor",
      "label": "Motricidad gruesa",
      "newMilestones": ["Se sienta solo unos segundos", "Se voltea hacia ambos lados"],
      "alarmSigns": ["No se sienta con apoyo", "No sostiene la cabeza firme"]
    },
    {
      "area": "fine_motor",
      "label": "Motricidad fina",
      "newMilestones": [],
      "alarmSigns": ["No pasa objetos de una mano a otra"],
      "_resolvedFromMonth": 5,
      "_resolvedMilestone": "Sostiene un juguete con ambas manos"
    }
  ],
  "medicalDisclaimer": "Esta información es orientativa y no sustituye el consejo de un profesional de salud."
}
```

Modelos en `core/domain/milestones/`:
- `MilestoneMonth` enum con los 60 meses, cada uno con `number` y
  `label`/`ageLabel` en español (base de la búsqueda de RF-1/CL-12).
- `DevelopmentArea` enum con las 5 áreas y sus etiquetas (RF-2, RF-3).
- `AreaMilestones { area, label, newMilestones, alarmSigns }` — sin datos
  "resueltos".
- `MonthContent { month, label, areas: List<AreaMilestones>,
  medicalDisclaimer }`.
- `contentFor(MilestoneMonth?)` → `null` sin mes (RF-1); disclaimer constante
  única siempre disponible (RF-3).
- `ResolvedMonth` = `MonthContent` + para cada área, un `ResolvedArea { area,
  label, items: List<MilestoneItem>, alarmSigns, isLastHitReference }`. El
  resolver (`last_hit_resolver.dart`) recorre meses anteriores por área para
  llenar `ResolvedArea` cuando `newMilestones` está vacío.

Regla de "último hito alcanzado" (RF-2, CL-3, CL-9): para cada área del mes
seleccionado, si `newMilestones` no está vacío → se muestran esos hitos nuevos;
si está vacío → se busca el mes anterior más reciente con `newMilestones` no
vacío en esa área y se usa su último hito; el resultado lleva
`isLastHitReference=true` para que la UI lo diferencie (RNF-5). Mes 1 siempre
tiene hitos en las 5 áreas (CL-9, no aplica el lookup). Área sin hitos en ningún
mes → se omite del render (RF-2, CL-10).

## 4. Comandos, salidas y códigos de salida

| Comando | Salida esperada | Exit code |
|---|---|---|
| `flutter pub get` | `Got dependencies!` (sin cambios) | 0 |
| `flutter analyze` | `No issues found!` | 0 (≠0 si hay hallazgos) |
| `flutter test` | `All tests passed!` | 0 (≠0 si algún test falla) |
| `flutter run` | App lanzada en dispositivo | 0 al detener con Ctrl+C (130); 1 si compila mal |

## 5. Decisiones técnicas justificadas (y alternativa descartada)

1. **Contenido en constantes Dart tipadas en `core/domain/`** · RF-2, RF-3, RF-5. Descartado: cargar JSON como asset (añade async para contenido estático; RNF-1).
2. **Meses como `enum` fijo de 60 valores** · RF-1, RF-5, CL-11. Descartado: rango numérico generado (no trazable a contenido por mes ni a etiquetas de búsqueda).
3. **`last_hit_resolver` aislado en lógica pura** · RF-2, CL-3, CL-10. Descartado: resolver dentro de la UI o del controller (rompe §3A y dificulta el test unitario del lookup).
4. **Resolución en un `ResolvedMonth` tipo por render** · RF-2, RF-4, RF-5. Descartado: mutar el contenido base al resolver (viola determinismo y reutilización).
5. **Capa Data ausente, justificada** · §2, §3. Descartado: repository genérico vacío innecesario para contenido estático sin I/O.
6. **Estado efímero con `ChangeNotifier` de Flutter** (mes elegido + filtro de búsqueda) · RF-1, RF-4, RNF-3. Descartado: `provider`/`riverpod` (dependencia extra contra el stack mínimo).
7. **Búsqueda como filtro local de memoria, sin persistencia** · RF-1, CL-12, RNF-3. Descartado: índice persistente o búsqueda en asset (complejidad y estado que rompería stateless).
8. **Sin persistencia** · RNF-3. Descartado: `shared_preferences` (nada que conservar).
9. **Alertas por área dentro de cada `AreaMilestones`** · RF-3. Descartado: bloque general de alarma (contradice la spec aprobada).
10. **Diferenciación del hito anterior por etiqueta semántica + estilo, no solo color** · RF-2, RNF-5. Descartado: distinguir solo por color (falla accesibilidad y la spec lo exige por texto).
11. **l10n centralizada vía `MaterialApp` con `localizationsDelegates`** · §6. Descartado: strings hardcodeados en widgets (no centralizados; rompe §6).

## 6. Estrategia de tests — §4

`test/core/domain/milestones/milestone_month_test.dart` · RF-1, CL-8, CL-11: 60 meses presentes, orden estable, etiquetas (mes 1 = nacimiento a 1 mes, mes 60 = 59–60), sin valores fuera de rango (enum cerrado).

`test/core/domain/milestones/development_area_test.dart` · RF-2, RF-3, CL-8: las 5 áreas con etiquetas en español; inventario cerrado.

`test/core/domain/milestones/milestone_content_test.dart` · RF-1, RF-2, RF-3, RF-5, CL-8, CL-9: 60/60 (todo mes tiene contenido en las 5 áreas y alertas por área); mes 1 con hitos nuevos en todas las áreas (CL-9); disclaimer constante presente (RF-3); determinismo (mismo mes → mismo contenido); sin mes → `null`; términos clínicos con aclaración embebida; cada mes tiene al menos un hito nuevo en alguna área (que la cobertura 60/60 no sea trivial, ver QA).

`test/core/domain/milestones/last_hit_resolver_test.dart` · RF-2, CL-3, CL-10: área con hitos → nuevo; área sin hito → último alcanzado del mes anterior con `isLastHitReference=true`; mes 1 nunca resuelve hacia atrás; área sin hitos en ningún mes → omitida.

`test/features/milestones/presentation/milestone_controller_test.dart` · RF-1, RF-4, CL-1, CL-2, CL-6, CL-12: sin mes → sin contenido y aviso médico; elegir → contenido; cambiar → sustituye; misma mes dos veces → idempotente; reinicio → `null`; filtro de búsqueda sin resultados → lista vacía con aviso (CL-12).

`test/features/milestones/presentation/milestone_page_test.dart` (widget) · RF-1..RF-5, RNF-2/5, §6: lista con 60 meses y campo de búsqueda; contenido tras elegir; hitos por área; hito anterior distinguido por etiqueta semántica (no solo color); alertas por área destacadas sin sustituir lo informativo; aviso médico siempre visible (con y sin mes); scroll de contenido largo; layout ≥320 dp; etiquetas vía l10n en español.

Verificación de fin: `flutter pub get && flutter analyze && flutter test` → 0/0/0.

## 7. Cobertura RF ↔ partes

| RF | Módulo | Tests |
|---|---|---|
| RF-1 | `core/domain/milestones/milestone_month.dart` + `milestone_content.dart` + controller | month + content + controller + page |
| RF-2 | `core/domain/milestones/milestone_guide.dart` + `milestone_content.dart` + `last_hit_resolver.dart` + page | content + resolver + page |
| RF-3 | `core/domain/milestones/milestone_content.dart` + page (alertas por área + disclaimer) | content + page |
| RF-4 | `features/milestones/presentation/milestone_controller.dart` + page | controller + page |
| RF-5 | `core/domain/` (pureza + determinismo) | content + resolver |
