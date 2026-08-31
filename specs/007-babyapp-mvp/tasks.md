# Tasks 007 — Primeros auxilios básicos

Tareas ordenadas por dependencia, cada una ≤20–30 min. Cada tarea indica los RF
que cubre y una línea "Hecho cuando:" verificable. Base: `spec.md` (RF/CL) y
`plan.md` (módulos/test).

## Fase A — Lógica pura en `core/domain/`

- [x] **T-1** Confirmar `core/domain/age/age_band.dart` compartido (franjas
  [0,3)[3,12)[12,36)[36,60]) y su test. Cubre: RF-2, CL-3.
  - Hecho cuando: `age_band_test.dart` en verde con límites iguales a
    001/002/004/005/006 (pertenencia en 0, 3, 12, 36, 60 meses).

- [x] **T-2** Definir `EmergencyType` (enum de 12 situaciones de emergencia con
  etiquetas en español: atragantamiento, quemaduras, caídas, picaduras y
  mordeduras, convulsiones, fiebre alta, heridas sangrantes, intoxicación,
  golpe en la cabeza, alergias graves, ahogamiento, objetos en ojos/orejas/
  nariz). Cubre: RF-1.
  - Hecho cuando: `flutter analyze` sin hallazgos y `emergency_type_test.dart`
    en verde (12 emergencias, orden estable, etiquetas en español, inventario
    cerrado).

- [x] **T-3** Definir `SeverityLevel` (enum: `urgency` / `consult`) con su
  etiqueta y guía de acción en español. Cubre: RF-5, CL-8.
  - Hecho cuando: `severity_level_test.dart` en verde (2 niveles, etiquetas y
    guía, inventario cerrado).

- [x] **T-4** Definir modelos tipados `FirstAidStep` { order, text } y
  `EmergencyGuide` { emergency, ageBand, severity, steps, doNot } en
  `firstaid_step.dart` / `firstaid_guide.dart`. Cubre: RF-3, RF-4, RF-5.
  - Hecho cuando: los modelos compilan y `flutter analyze` sin hallazgos.

- [x] **T-5** Implementar `firstaid_content.dart`: contenido por
  emergencia×franja y `contentFor(EmergencyType?, AgeBand?)` → `null` sin
  emergencia o sin franja; disclaimer como constante única. Cubre: RF-1..RF-5,
  CL-3, CL-8.
  - Hecho cuando: `firstaid_content_test.dart` en verde (toda emergencia con
    contenido en al menos una franja y gravedad válida; pasos con `order`
    secuencial y `text` no vacío; sección "qué no hacer" presente; disclaimer;
    determinismo; sin emergencia → `null`; sin franja → `null`; emergencia sin
    pasos para una franja → se omite; emergencia sin pasos en las 4 → error).

## Fase B — Estado efímero (presentation)

- [x] **T-6** Implementar `FirstAidController` en
  `features/firstaid/presentation/` (ChangeNotifier): emergencia y franja
  seleccionados; expone la guía vía `contentFor`. Cubre: RF-1, RF-2, RNF-3,
  CL-1, CL-2, CL-6, CL-7.
  - Hecho cuando: `firstaid_controller_test.dart` en verde (sin emergencia →
    sin guía y aviso médico; sin franja → sin guía y aviso médico; elegir
    emergencia y franja → guía; cambiar emergencia → sustituye; cambiar franja
    → sustituye; misma selección → idempotente; reinicio → `null`).

## Fase C — Presentación, l10n y arranque

- [x] **T-7** Configurar `localizationsDelegates` y `supportedLocales` en
  `main.dart`; crear ARB base para strings español. Cubre: §6.
  - Hecho cuando: `flutter analyze` sin hallazgos y la app compila con locale
    español por defecto.

- [x] **T-8** Implementar `FirstAidPage` (widget) en
  `features/firstaid/presentation/`: lista de 12 emergencias y, al elegir
  emergencia y franja, los pasos numerados + sección "qué no hacer" + indicador
  de gravedad; aviso médico siempre visible. Cubre: RF-1..RF-6, RNF-2, RNF-5,
  CL-4, CL-5, CL-9, CL-10, CL-11, §6.
  - Hecho cuando: `firstaid_page_test.dart` en verde (lista con 12
    emergencias; contenido tras elegir; pasos numerados + "qué no hacer";
    gravedad distinguida por etiqueta semántica; aviso médico siempre; scroll
    largo; layout ≥320 dp; etiquetas vía l10n en español).

- [x] **T-9** Conectar `FirstAidPage` como `home` temporal en `main.dart`.
  Cubre: RF-1, RNF-5.
  - Hecho cuando: `flutter run` lanza la app y se ve la lista de emergencias
    desde el arranque.

## Fase D — Verificación final

- [x] **T-10** Ejecutar `flutter pub get && flutter analyze && flutter test`;
   corregir cualquier hallazgo con su test. Cubre: todos los RF.
  - Hecho cuando: los tres comandos terminan en exit 0/0/0.

---

Nota de dependencia: T-1, T-2 y T-3 son independientes y base de T-4; T-5
depende de T-4; T-6 depende de T-5; T-7 es independiente (puede ejecutarse en
paralelo con T-1–T-6); T-8 depende de T-6 y T-7; T-9 depende de T-8; T-10
cierra.
