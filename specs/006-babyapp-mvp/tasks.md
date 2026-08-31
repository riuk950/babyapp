# Tasks 006 — Tips rápidos de rutina diaria

Tareas ordenadas por dependencia, cada una ≤20–30 min. Cada tarea indica los RF
que cubre y una línea "Hecho cuando:" verificable. Base: `spec.md` (RF/CL) y
`plan.md` (módulos/test).

## Fase A — Lógica pura en `core/domain/`

- [ ] **T-1** Confirmar `core/domain/age/age_band.dart` compartido (franjas
  [0,3)[3,12)[12,36)[36,60]) y su test. Cubre: RF-2, CL-3.
  - Hecho cuando: `age_band_test.dart` en verde con límites iguales a
    001/002/004/005 (pertenencia en 0, 3, 12, 36, 60 meses).

- [ ] **T-2** Definir `RoutineMoment` (enum de 6 momentos del día con etiquetas
  en español: Mañana, Siesta, Baño, Alimentación, Juego/estimulación, Noche).
  Cubre: RF-1.
  - Hecho cuando: `flutter analyze` sin hallazgos y `routine_moment_test.dart`
    en verde (6 momentos, orden estable, etiquetas en español, inventario
    cerrado).

- [ ] **T-3** Definir modelo tipado `RoutineTip` { message, source } en
  `routine_tip.dart`. Cubre: RF-3, RF-4.
  - Hecho cuando: los modelos compilan y `flutter analyze` sin hallazgos.

- [ ] **T-4** Definir modelo tipado `RoutineGuide` { moment, ageBand, tips } en
  `routine_guide.dart`. Cubre: RF-3.
  - Hecho cuando: los modelos compilan y `flutter analyze` sin hallazgos.

- [ ] **T-5** Implementar `routine_content.dart`: contenido 6×4 y
  `tipsFor(RoutineMoment?, AgeBand?)` → `null` sin momento o sin franja;
  disclaimer como constante única. Cubre: RF-1..RF-4, RF-6, CL-3, CL-8.
  - Hecho cuando: `routine_content_test.dart` en verde (6×4 con al menos 1
    tip por combinación; cada tip con mensaje y fuente; disclaimer presente;
    determinismo; sin momento → `null`; sin franja → `null`; momento sin tips
    para una franja → se omite; momento sin tips en las 4 franjas → error).

## Fase B — Estado efímero (presentation)

- [ ] **T-6** Implementar `RoutineController` en
  `features/routine/presentation/` (ChangeNotifier): momento y franja
  seleccionados; expone los tips vía `tipsFor`. Cubre: RF-1, RF-2, RNF-3,
  CL-1, CL-2, CL-6, CL-7.
  - Hecho cuando: `routine_controller_test.dart` en verde (sin momento → sin
    tips y aviso médico; sin franja → sin tips y aviso médico; elegir momento
    y franja → tips; cambiar momento → sustituye; cambiar franja → sustituye;
    misma selección → idempotente; reinicio → `null`).

## Fase C — Presentación, l10n y arranque

- [ ] **T-7** Configurar `localizationsDelegates` y `supportedLocales` en
  `main.dart`; crear ARB base para strings español. Cubre: §6.
  - Hecho cuando: `flutter analyze` sin hallazgos y la app compila con locale
    español por defecto.

- [ ] **T-8** Implementar `RoutinePage` (widget) en
  `features/routine/presentation/`: lista de 6 momentos y, al elegir momento
  y franja, los tips con mensaje corto y fuente; aviso médico siempre visible.
  Cubre: RF-1..RF-6, RNF-2, RNF-5, CL-4, CL-5, CL-9, CL-10, §6.
  - Hecho cuando: `routine_page_test.dart` en verde (lista con 6 momentos;
    contenido tras elegir momento y franja; tips con mensaje y fuente; aviso
    médico siempre; scroll largo; layout ≥320 dp; etiquetas vía l10n en
    español).

- [ ] **T-9** Conectar `RoutinePage` como `home` temporal en `main.dart`.
  Cubre: RF-1, RNF-5.
  - Hecho cuando: `flutter run` lanza la app y se ve la lista de momentos
    desde el arranque.

## Fase D — Verificación final

- [ ] **T-10** Ejecutar `flutter pub get && flutter analyze && flutter test`;
   corregir cualquier hallazgo con su test. Cubre: todos los RF.
  - Hecho cuando: los tres comandos terminan en exit 0/0/0.

---

Nota de dependencia: T-1 y T-2 son independientes y base de T-3/T-4; T-5
depende de T-3/T-4; T-6 depende de T-5; T-7 es independiente (puede ejecutarse
en paralelo con T-1–T-6); T-8 depende de T-6 y T-7; T-9 depende de T-8; T-10
cierra.
