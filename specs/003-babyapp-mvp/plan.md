# Plan 003 — Cómo almacenar leche materna

Traduce `specs/003-babyapp-mvp/spec.md` a una estructura implementable que
respeta la constitución: sin dependencias nuevas (principio 1 y RNF-6), lógica
pura aislada (principio 3), stateless (principio 5), tests en verde (principio
4) y mensajes visibles en español (principio 6).

## 1. Dependencias — RNF-6 · constitución principio 1

Sin dependencias nuevas: la función es una guía estática por secciones. La
aprobación HTTP/GPS de la constitución es solo para funciones de clima y no se
usa aquí. `flutter test` y `flutter analyze` ya presentes.

## 2. Estructura de módulos

```
lib/
  main.dart                       → arranque + tema (pantalla inicial = 003 leche materna)  · RF-1, RNF-5
  core/                           → LÓGICA PURA (sin importar flutter)          · principio 3, RNF-4
    breastmilk/
      breastmilk_section.dart     → enumerado de las 4 secciones + etiquetas    · RF-1, CL-1, CL-8
      breastmilk_guide.dart       → modelos tipados (SectionContent, StorageTimeRow)  · RF-2, RF-3, RF-5
      breastmilk_content.dart     → contenido 4/4 + contentFor(Section?) y disclaimer  · RF-1, RF-2, RF-3, RF-5, CL-7
  features/breastmilk/
    application/
      breastmilk_controller.dart  → estado efímero de sesión (sección elegida)  · RF-1, RF-4, RNF-3, CL-2, CL-8
    presentation/
      breastmilk_page.dart        → renderiza lista y contenido                 · RF-1..RF-5, RNF-2, RNF-5, CL-1/3/4/8/9
test/
  core/breastmilk/breastmilk_section_test.dart   → RF-1, CL-1, CL-8
  core/breastmilk/breastmilk_content_test.dart   → RF-1, RF-2, RF-3, RF-5, CL-7
  features/breastmilk/breastmilk_controller_test.dart · RF-1, RF-4, CL-2, CL-8
  features/breastmilk/breastmilk_page_test.dart       · RF-1..RF-5, RNF-2, RNF-5, principio 6
```

**Coordinación**: la pantalla de esta función será el `home` temporal de `main.dart`
(igual que en 002). La navegación final entre las funciones 001 (clima), 002
(sueño) y 003 (leche materna) no pertenece a ninguna de las tres specs y se
define en un paso de integración posterior, fuera de este plan.

## 3. Modelo y contenido — RF-2, RF-3 con ejemplo

El contenido vive como constantes Dart tipadas en `core/` (determinista, RF-5,
sin async). El JSON es el formato canónico de cada entrada (informativo; nunca
se persiste, principio 5) y sirve de contrato si el contenido migrara a asset:

```json
{
  "id": "storage",
  "label": "Almacenamiento",
  "bestPractices": [
    "Guardar en la parte trasera de la nevera (más fría), no en la puerta.",
    "Usar recipientes de vidrio o plástico sin BPA (sustancia usada en algunos plásticos que se recomienda evitar).",
    "Si se mezclan extracciones, enfriar la nueva antes de añadirla a leche ya fría."
  ],
  "highlights": [
    "No guardar en la puerta de la nevera."
  ],
  "storageTimeRows": [
    { "place": "Ambiente", "temp": "≤25 °C", "duration": "hasta 4 h" },
    { "place": "Nevera", "temp": "~4 °C", "duration": "hasta 4 días" },
    { "place": "Congelador", "temp": "−18 °C", "duration": "6 meses" },
    { "place": "Descongelada en nevera", "temp": "—", "duration": "usar antes de 24 h" },
    { "place": "Descongelada a temperatura ambiente", "temp": "—", "duration": "usar en 1–2 h" }
  ],
  "medicalDisclaimer": "Esta información es orientativa y no sustituye el consejo de un profesional de lactancia o de salud."
}
```

Cuatro modelos en `core/breastmilk/`:
- `BreastMilkSection` enum con las 4 secciones (extraction, storage, defrosting,
  hygiene) y su etiqueta en español (RF-1).
- `StorageTimeRow` { place, temp, duration }.
- `SectionContent` { section, label, bestPractices, highlights,
  storageTimeRows, medicalDisclaimer }.
- `contentFor(BreastMilkSection?)` devuelve el contenido o `null` sin sección
  (RF-1); el disclaimer médico es una constante única siempre disponible
  (RF-3). `highlights` y `storageTimeRows` quedan vacíos/vacías en la sección
  Extracción por la regla de RF-3 (no contiene prohibiciones ni tiempos).
- La tabla de tiempos (storageTimeRows) es la **única fuente** de tiempos de
  conservación y pertenece al bloque destacado de Almacenamiento (RF-3, CL-9);
  los límites "aceptables" (8 días / 12 meses) de la spec no son contenido
  visible.

## 4. Comandos, salidas y códigos de salida

| Comando | Salida esperada | Exit code |
|---|---|---|
| `flutter pub get` | `Got dependencies!` (sin cambios) | 0 |
| `flutter analyze` | `No issues found!` | 0 (≠0 si hay hallazgos) |
| `flutter test` | `All tests passed!` | 0 (≠0 si algún test falla) |
| `flutter run` | App lanzada en dispositivo | 0 al detener con Ctrl+C (130); 1 si compila mal |

## 5. Decisiones técnicas justificadas (y alternativa descartada)

1. **Contenido en constantes Dart tipadas en `core/`** · RF-2, RF-3, RF-5. Descartado: cargar JSON como asset (añade async y estados de carga para contenido estático; RNF-1).
2. **Secciones como `enum` fijo de 4 valores** · RF-1, RF-4, RF-5. Descartado: secciones como strings sueltos (errores de escritura y contenido no trazable).
3. **Tabla de tiempos como datos tipados, única fuente, en el bloque destacado de Almacenamiento** · RF-3, CL-9. Descartado: duplicar los tiempos como contenido normal (fuentes divergentes, contradicción RF-2/RF-3).
4. **Sin repository/efectos**: no hay red ni GPS (RNF-6), así que no hay capa `data/` en esta función · RNF-6. Descartado: repository genérico vacío innecesario.
5. **Estado efímero con `ChangeNotifier` de Flutter** en el controller · RF-1, RF-4, RNF-3. Descartado: `provider`/`riverpod` (dependencia extra contra el stack mínimo).
6. **Sin persistencia** · RNF-3. Descartado: `shared_preferences` (nada que conservar).
7. **Retorno solo por el gesto/botón de atrás del sistema** (de vuelta a la lista sin sección, sin memoria) · RF-1, CL-8, RNF-3. Descartado: botón interno o recordar la última sección (rompería stateless y crearía dos vías de retorno).
8. **Tabla refluyendo a lista en ≤320 dp** (decisión de presentación, no de datos) · CL-9, RNF-2. Descartado: scroll horizontal o tablero mínimo fijo (peor lectura).
9. **Los bloques destacados llevan prefijo fijo "Aviso de seguridad" y etiqueta semántica** · RF-3, RNF-5. Descartado: distinguirlos solo por color (falla accesibilidad).

## 6. Estrategia de tests — principio 4

`test/core/breastmilk/breastmilk_section_test.dart` · RF-1, CL-1, CL-8: las 4 secciones con sus etiquetas; orden estable; sin valores inválidos posibles (enum).

`test/core/breastmilk/breastmilk_content_test.dart` · RF-1, RF-2, RF-3, RF-5, CL-7: 4/4 (bestPractices no vacías en todas; highlights y storageTimeRows vacíos solo en Extracción, regla RF-3); disclaimer presente siempre (constante única); determinismo; tabla con 5 filas única en Almacenamiento y sin valores "aceptables"; inventario de términos cerrado (BPA con aclaración embebida); sin sección → `null`.

`test/features/breastmilk/application/breastmilk_controller_test.dart` · RF-1, RF-4, CL-2, CL-8, RNF-3: sin sección → contenido `null` con aviso médico; elegir → contenido; cambiar → sustituye; misma sección dos veces → idempotente; reinicio → `null`.

`test/features/breastmilk/presentation/breastmilk_page_test.dart` (widget) · RF-1..RF-5, RNF-2, RNF-5, principio 6: lista con 4 secciones; contenido tras elegir; bloque destacado con prefijo "Aviso de seguridad" y etiqueta semántica sin sustituir el informativo; aviso médico siempre visible (con y sin sección); scroll de contenido largo; tabla refluyendo a lista a ≤320 dp; retorno con atrás → lista sin sección; etiquetas en español.

Verificación de fin: `flutter pub get && flutter analyze && flutter test` → 0/0/0.

## 7. Cobertura RF ↔ partes

| RF | Módulo | Tests |
|---|---|---|
| RF-1 | `core/breastmilk/breastmilk_section.dart` + `breastmilk_content.dart` + controller | section + content + controller + page |
| RF-2 | `core/breastmilk/breastmilk_guide.dart` + `breastmilk_content.dart` + page | content + page |
| RF-3 | `core/breastmilk/breastmilk_content.dart` + page | content + page |
| RF-4 | `application/breastmilk_controller.dart` + page | controller + page |
| RF-5 | `core/breastmilk/breastmilk_content.dart` (pureza) | content |