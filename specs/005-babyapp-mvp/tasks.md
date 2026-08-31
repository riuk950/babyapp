# Tasks 005 — Señales de alerta

Tareas ordenadas por dependencia, cada una ≤20–30 min. Cada tarea indica los RF
que cubre y una línea "Hecho cuando:" verificable. Base: `spec.md` (RF/CL) y
`plan.md` (módulos/test).

## Fase A — Lógica pura en `core/domain/`

- [ ] **T-1** Confirmar `core/domain/age/age_band.dart` compartido (franjas
  [0,3)[3,12)[12,36)[36,60]) y su test. Cubre: RF-1, CL-3.
  - Hecho cuando: `age_band_test.dart` en verde con límites iguales a
    001/002/004 (pertenencia en 0, 3, 12, 36, 60 meses).

- [ ] **T-2** Definir `AlertLevel` (enum: `urgency` / `scheduled`) con su
  etiqueta/guía en español. Cubre: RF-3, CL-8.
  - Hecho cuando: `flutter analyze` sin hallazgos y el enum compila con los 2
    valores y sus textos en español.

- [ ] **T-3** Definir modelos tipados `AlertSignal`, `AreaAlerts` y `AlertGuide`
  en `alert_guide.dart`. Cubre: RF-2, RF-3, RF-5.
  - Hecho cuando: `alert_guide_test.dart` en verde (cada señal tiene un único
    `AlertLevel` válido; determinismo del modelo).

- [ ] **T-4** Implementar `alert_content.dart`: contenido 4/4 y
  `contentFor(AgeBand?)` → `null` sin franja; disclaimer como constante única;
  áreas con `signals` vacío se omiten. Cubre: RF-1, RF-2, RF-3, RF-5, CL-8,
  CL-10.
  - Hecho cuando: `alert_content_test.dart` en verde (4/4 con señales en al
    menos un área y cada señal con su nivel; área vacía omitida; área sin
    señales en las 4 franjas → error y no se muestra; determinismo; disclaimer
    presente; sin franja → `null`).

## Fase B — Estado efímero (presentation)

- [ ] **T-5** Implementar `AlertController` en `features/alerts/presentation/`
  (ChangeNotifier): franja seleccionada; expone la guía vía `contentFor`. Cubre:
  RF-1, RF-4, RNF-3, CL-1, CL-2, CL-6, CL-9.
  - Hecho cuando: `alert_controller_test.dart` en verde (sin franja → sin guía
    y aviso médico; elegir → guía; cambiar → sustituye; misma franja →
    idempotente; reinicio → `null`).

## Fase C — Presentación, l10n y arranque

- [ ] **T-6** Configurar `localizationsDelegates` y `supportedLocales` en
  `main.dart`; crear ARB base para strings español. Cubre: §6.
  - Hecho cuando: `flutter analyze` sin hallazgos y la app compila con locale
    español por defecto.

- [ ] **T-7** Implementar `AlertPage` (widget) en
  `features/alerts/presentation/`: lista de 4 franjas y, al elegir, las señales
  de las 5 áreas todas a la vez con su nivel de urgencia distinguido por etiqueta
  semántica. Cubre: RF-1..RF-5, RNF-2, RNF-5, CL-1, CL-4, CL-5, CL-7, CL-10,
  §6.
  - Hecho cuando: `alert_page_test.dart` en verde (lista con rango; señales por
    área tras elegir; nivel distinguido por texto y no solo color; aviso médico
    siempre; scroll largo; layout ≥320 dp; etiquetas vía l10n en español).

- [ ] **T-8** Conectar `AlertPage` como `home` temporal en `main.dart`. Cubre:
  RF-1, RNF-5.
  - Hecho cuando: `flutter run` lanza la app y se ve la lista de franjas desde
    el arranque.

## Fase D — Verificación final

- [ ] **T-9** Ejecutar `flutter pub get && flutter analyze && flutter test`;
   corregir cualquier hallazgo con su test. Cubre: todos los RF.
  - Hecho cuando: los tres comandos terminan en exit 0/0/0.

---

Nota de dependencia: T-1 y T-2 son independientes y base de T-3; T-3 precede a
T-4; T-5 depende de T-4; T-6 es independiente (puede ejecutarse en paralelo con
T-1–T-5); T-7 depende de T-5 y T-6; T-8 depende de T-7; T-9 cierra.
