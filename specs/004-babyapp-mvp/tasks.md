# Tasks 004 — Hitos de desarrollo mes a mes

Tareas ordenadas por dependencia, cada una ≤20–30 min. Cada tarea indica los RF
que cubre y una línea "Hecho cuando:" verificable. Base: `spec.md` (RF/CL) y
`plan.md` (módulos/test).

## Fase A — Lógica pura en `core/domain/milestones/`

- [ ] **T-1** Definir `DevelopmentArea` (enum con las 5 áreas y etiquetas en
  español). Cubre: RF-2, RF-3.
  - Hecho cuando: `flutter analyze` sin hallazgos y `development_area_test.dart`
    en verde (5 áreas, etiquetas en español, inventario cerrado).

- [ ] **T-2** Definir `MilestoneMonth` (enum de 60 meses con `number` y
  `ageLabel` en español). Cubre: RF-1, CL-11.
  - Hecho cuando: `milestone_month_test.dart` en verde (60 meses, orden estable,
    etiquetas mes 1 y mes 60, sin valores fuera de rango).

- [ ] **T-3** Definir modelos tipados `AreaMilestones`, `MonthContent` y
  `MilestoneItem` en `milestone_guide.dart`. Cubre: RF-2, RF-3, RF-5.
  - Hecho cuando: los modelos compilan y `flutter analyze` sin hallazgos (no
    requieren tests propios más allá del análisis).

- [ ] **T-4** Implementar `milestone_content.dart`: contenido 60/60 y
  `contentFor(MilestoneMonth?)` → `null` sin mes; disclaimer como constante
  única. Cubre: RF-1, RF-2, RF-3, RF-5, CL-8, CL-9.
  - Hecho cuando: `milestone_content_test.dart` en verde (60/60 con 5 áreas y
    alertas por área; mes 1 con hitos en todas las áreas; disclaimer presente;
    determinismo; sin mes → `null`; términos con aclaración; cada mes con al
    menos un hito nuevo en alguna área).

- [ ] **T-5** Implementar `last_hit_resolver.dart`: para cada área, si hay hito
  nuevo se muestra; si no, el último alcanzado del mes anterior con
  `isLastHitReference=true`; omitir área sin hitos en ningún mes; mes 1 nunca
  resuelve hacia atrás. Cubre: RF-2, CL-3, CL-10.
  - Hecho cuando: `last_hit_resolver_test.dart` en verde (área con/sin hitos,
    referencia marcada, mes 1, área omitida).

## Fase B — Estado efímero (presentation)

- [ ] **T-6** Implementar `MilestoneController` en
  `features/milestones/presentation/` (ChangeNotifier): mes seleccionado + filtro
  de búsqueda; expone contenido resuelto vía `ResolvedMonth`. Cubre: RF-1, RF-4,
  RNF-3, CL-1, CL-2, CL-6, CL-12.
  - Hecho cuando: `milestone_controller_test.dart` en verde (sin mes → sin
    contenido y aviso médico; elegir → contenido; cambiar → sustituye; mismo mes
    → idempotente; reinicio → `null`; búsqueda sin resultados → lista vacía con
    aviso).

## Fase C — Presentación, l10n y arranque

- [ ] **T-7** Configurar `localizationsDelegates` y `supportedLocales` en
  `main.dart`; crear ARB base para strings español. Cubre: §6.
  - Hecho cuando: `flutter analyze` sin hallazgos y la app compila con locale
    español por defecto.

- [ ] **T-8** Implementar `MilestonePage` (widget) en
  `features/milestones/presentation/` que renderiza la lista de 60 meses con
  campo de búsqueda y el contenido del mes por áreas, con hito anterior
  diferenciado por etiqueta semántica y alertas por área destacadas. Cubre:
  RF-1..RF-5, RNF-2, RNF-5, CL-1, CL-4, CL-5, CL-7, CL-12, §6.
  - Hecho cuando: `milestone_page_test.dart` en verde (lista+búsqueda, contenido
    por área, hito anterior diferenciado, alertas por área, aviso médico
    siempre, scroll, layout ≥320 dp, etiquetas vía l10n en español).

- [ ] **T-9** Conectar `MilestonePage` como `home` temporal en `main.dart`.
  Cubre: RF-1, RNF-5.
  - Hecho cuando: `flutter run` lanza la app y se ve la lista de meses desde el
    arranque.

## Fase D — Verificación final

- [ ] **T-10** Ejecutar `flutter pub get && flutter analyze && flutter test`;
   corregir cualquier hallazgo con su test. Cubre: todos los RF.
  - Hecho cuando: los tres comandos terminan en exit 0/0/0.

---

Nota de dependencia: T-1 y T-2 son independientes entre sí y base de T-3/T-4;
T-5 depende de T-4; T-6 depende de T-4/T-5; T-7 es independiente (puede
ejecutarse en paralelo con T-1–T-6); T-8 depende de T-6 y T-7; T-9 depende de
T-8; T-10 cierra.
