# Tasks 003 — Cómo almacenar leche materna

Tareas en orden de dependencia. Cada una ≤ 20–30 min. Coordinación con
`specs/003-babyapp-mvp/spec.md` y `plan.md`. Identificadores en inglés,
mensajes de usuario en español (§6). Nada en `core/domain/` importa Flutter
(§3A). Sin dependencias nuevas (RNF-6).

## Fase 0 — Lógica pura (`core/domain/`)

- [x] T1. Secciones y modelos en `core/domain/breastmilk/`
      RF: RF-1, RF-2, RF-3, RF-5 · plan §2, §3
      Hecho cuando: `BreastMilkSection` enum con las 4 secciones (Extracción,
      Almacenamiento, Descongelado y uso, Higiene y seguridad) y sus etiquetas en
      español; modelos tipados `SectionContent` y `StorageTimeRow` sin importar
      Flutter y sin otro contenido además del type.

- [x] T2. Contenido 4/4 en `core/domain/breastmilk/breastmilk_content.dart`
      RF: RF-1, RF-2, RF-3, RF-5 · CL-7 · plan §3
      Hecho cuando: `contentFor(BreastMilkSection?)` devuelve las 4 secciones
      completas según Decisiones de la spec (bestPractices no vacías en todas),
      los bloques destacados (highlights + storageTimeRows) aparecen solo donde
      la regla de RF-3 los prevé (Extracción vacía), la tabla de tiempos es única
      en Almacenamiento con las 5 filas y solo valores recomendados (4 días / 6
      meses, sin "aceptables"), el término BPA lleva su aclaración embebida, el
      disclaimer médico es constante única, y sin sección devuelve `null`.

- [x] T3. Tests unitarios de `core/domain/`
      RF: RF-1, RF-2, RF-3, RF-5 · CL-7 · plan §6
      Hecho cuando: `breastmilk_section_test` y `breastmilk_content_test` pasan
      (4 secciones y etiquetas; 4/4; highlights/tabla vacíos solo en Extracción;
      disclaimer siempre; determinismo; tabla única con 5 filas; inventario
      cerrado de términos; sin sección → `null`).

## Fase 1 — Presentación

- [x] T4. Configurar l10n en `main.dart`; crear ARB base para español.
      RF: §6 · plan §5(10)
      Hecho cuando: `flutter analyze` sin hallazgos y la app compila con locale
      español por defecto.

- [x] T5. Controller en `features/breastmilk/presentation/`
      RF: RF-1, RF-4 · CL-2, CL-8 · RNF-3 · plan §2, §5(5,7)
      Hecho cuando: los tests del controller verifican sin sección → contenido
      `null` con aviso médico; elegir sección → contenido; cambiar → sustituye;
      misma sección dos veces → idempotente; reinicio → `null`.

- [x] T6. Pantalla (renderiza y delega) en `features/breastmilk/presentation/`
      RF: RF-1..RF-5 · RNF-2, RNF-5 · CL-1/3/4/8/9 · §6 · plan §2
      Hecho cuando: lista con las 4 secciones; tras elegir muestra las mejores
      prácticas; bloques destacados con prefijo "Aviso de seguridad" y etiqueta
      semántica sin sustituir el contenido informativo; tabla de tiempos solo en
      Almacenamiento, refluyendo a lista a ≤320 dp; aviso médico siempre visible
      (con y sin sección); scroll de contenido largo; el gesto/botón de atrás del
      sistema vuelve a la lista en estado sin sección sin recordar la anterior;
      etiquetas vía l10n en español.

- [x] T7. Integración en `main.dart` (home = BreastMilkPage)
      RF: RF-1 · RNF-5 · plan §2
      Hecho cuando: la app arranca directamente en la pantalla de leche materna,
      con tema legible y sin la demo del contador.

## Fase 2 — Verificación

- [x] T8. Widget test de la pantalla
      RF: RF-1..RF-5 · RNF-2, RNF-5 · §6 · plan §6
      Hecho cuando: el widget test cubre lista de secciones, contenido tras
      elegir, bloque destacado con prefijo y semántica, aviso médico siempre,
      scroll, reflujo de tabla, retorno con atrás, layout ≥320 dp y etiquetas
      vía l10n en español.

- [x] T9. Gate final
      RF: todos · §4 · plan §4
      Hecho cuando: `flutter pub get && flutter analyze && flutter test`
      devuelven 0/0/0 y la cobertura RF↔partes del plan §7 está verde.

**Nota de coordinación**: igual que en 002, `main.dart` usa como pantalla inicial
(home) la de esta función de forma temporal. La navegación final entre las
funciones 001, 002 y 003 se define en un paso de integración posterior, fuera de
este plan.
