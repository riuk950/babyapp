# Plan 001 — Cómo vestir al bebé según la temperatura

Traduce `specs/001-babyapp-mvp/spec.md` a una estructura implementable que
respeta la constitución: stack mínimo (principio 1), lógica pura separada de la
interfaz (principio 3), stateless (principio 5), tests en verde (principio 4) e
identificadores en inglés/mensajes en español (principio 6).

## 1. Dependencias — RF-2, RF-4 · constitución principio 1

Aprobadas en bloque, añadidas a `pubspec.yaml`:
- `http` → cliente HTTP.
- `geolocator` → acceso GPS.

Sin nada más: JSON con `dart:convert`, estado con `ChangeNotifier` +
`ListenableBuilder` (ambos de Flutter), tests con `flutter_test`.

## 2. Estructura de módulos

```
lib/
  main.dart                                  → arranque + tema (solo material)               · RF-7, RNF-5
  core/                                      → LÓGICA PURA (sin importar flutter)           · principio 3, RNF-4
    temperature/
      manual_input_parser.dart               · RF-1, CL-1, CL-4
      effective_temperature.dart             · RF-3, RF-4, CL-5..CL-9, CL-11, CL-8
      extreme_threshold.dart                 · RF-8, CL-3
    clothing/
      age_band.dart                          · RF-6, CL-13, franjas [0,3)[3,12)[12,36)[36,60]
      recommendation_table.dart              · RF-7, tabla y ajustes por franja
    models.dart                              → tipos de dominio (sin I/O)
  data/                                      → EFECTOS red + GPS                          · RF-2, RF-4, RNF-6
    geo/geo_service.dart                     → posición GPS                                · RF-2, CL-12
    weather/open_meteo.dart                  → HTTP + parseo JSON                          · RF-2, CL-11
    weather/weather_repository.dart          → orquesta geo+HTTP, clasifica fallos          · RF-2, RF-4
  features/clothing/
    application/clothing_controller.dart     → estado efímero de sesión                    · RF-5, RF-6, principio 5
    presentation/clothing_page.dart          → renderiza y delega                          · RF-1..RF-8, RNF-2
test/
  core/…            unit tests               · RF-1..RF-9
  features/…        controller + widget      · RF-5..RF-8
```

Regla clave: `core/` y sus tests no importan Flutter ni `dart:io` (verificable
con las tests ejecutándose en VM pura). La pantalla no calcula nada: delega en
el controller y éste en `core/`.

## 3. Modelo de datos JSON — RF-2, RF-4 · principio 5 (solo transporte, sin persistencia)

Ejemplo de consulta a Open-Meteo (sin API key):

```
GET https://api.open-meteo.com/v1/forecast
    ?latitude=40.41&longitude=-3.70&current=temperature_2m
```

Respuesta:

```json
{
  "latitude": 40.41,
  "longitude": -3.70,
  "current": { "time": "2026-08-28T09:00", "temperature_2m": 21.3 }
}
```

DTOs de frontera: `WeatherResponse.fromJson(…)` → `TemperatureReading(tenths)`
(el adaptador convierte a décimas enteras con aritmética int para evitar errores
de coma flotante y descarta lecturas fuera de −30…50 → `null`, RF-4/CL-11).

Resultado canónico interno (informativo; nunca se persiste):

```json
{
  "effectiveCelsius": 21,
  "source": "average",
  "ageBand": "toddler12to36",
  "notice": null,
  "recommendation": "Body manga corta de algodón + pantalón; chaleco fino opcional",
  "extreme": "none"
}
```

`source`: `average | manualOnly | geoOnly`; `notice`: `geoUnavailable |
manualIgnored` (los textos exactos en español viven en la UI, RF-4/HU-4).

## 4. Comandos, salidas y códigos de salida

| Comando | Salida esperada | Exit code |
|---|---|---|
| `flutter pub get` | `Got dependencies!` | 0 |
| `flutter analyze` | `No issues found!` | 0 (≠0 si hay hallazgos) |
| `flutter test` | `All tests passed!` | 0 (≠0 si algún test falla) |
| `flutter run` | App lanzada en dispositivo | 0 al detener con Ctrl+C (130); 1 si compila mal |

`flutter analyze` actúa como gate añadido (flutter_lints ya viene en el
proyecto); los tres comandos del AGENTS quedan cubiertos.

## 5. Decisiones técnicas justificadas (y alternativa descartada)

1. **Cliente HTTP: `http`** — oficial, mínima superficie · RF-2. Descartado: `dio` (interceptores y peso innecesarios para una sola llamada).
2. **GPS: `geolocator`** — declaración de permisos y API estable · RF-2, RF-4. Descartado: `location` (menos soporte activo).
3. **Servicio meteorológico: Open-Meteo** — gratis y sin API key (no hay secretos que gestionar, cae en RNF-3) · RF-2. Descartado: OpenWeather/WeatherAPI (requieren API key y gestión de claves).
4. **JSON: `dart:convert` nativo** · RF-2. Descartado: `json_serializable`/`freezed` (generación de código y `build_runner`, dependencia extra).
5. **Estado: `ChangeNotifier` + `ListenableBuilder` de Flutter** en el controller; el estado de carga/clima es efímero (principio 5) · RF-5. Descartado: `provider`/`riverpod`/`bloc` (paquetes extra contra el stack mínimo).
6. **Sin persistencia** — la spec declara stateless (RNF-3, Fuera de alcance) · principio 5. Descartado: `shared_preferences` (no hay nada que persistir en el MVP).
7. **Números como décimas enteras en `core/`** para promedio/redondeo · RF-3, CL-8. Descartado: `double` directo (errores de coma flotante en 0,1/0,2 que romperían el determinismo de RF-9).
8. **Fallback simétrico en `computeEffective()`** puro: geo no disponible → manual sola; manual no válida → geo sola · RF-4, CL-5, CL-6. Descartado: imitar CL-5 antiguo ("error igualmente"), que QA consideró contradictorio.
9. **Umbrales sobre la efectiva redondeada** (no sobre el promedio con decimales) · RF-8/CL-3. Descartado: evaluar sobre valor sin redondear (mostraría avisos inconsistentes con lo mostrado).
10. **Reintento de permiso en `AppLifecycleListener` (resume)** · RF-2, CL-12. Descartado: polling con temporizador (gasto innecesario).

## 6. Estrategia de tests — principio 4

`test/core/temperature/manual_input_parser_test.dart` · RF-1, CL-1, CL-4: −30/50 válidos; vacío, solo espacios, no numérico, >1 decimal y fuera de rango → `ManualInputError`; coma y punto; signos ±; espacios alrededor.
`test/core/temperature/effective_temperature_test.dart` · RF-3, RF-4, RF-9, CL-5..CL-9, CL-11, CL-8: promedio de dos fuentes; redondeo half-up 19,5→20, −2,4→−2, −2,5→−2, −2,6→−3, 19,4→19; fallback manual-sola y geo-sola con `notice`; ninguna fuente → `null`; geo fuera de rango → no disponible; determinismo (misma entrada → mismo resultado).
`test/core/temperature/extreme_threshold_test.dart` · RF-8, CL-3: 0→frío, 30→calor, 1..29→ninguno; umbral independiente de los cortes de tabla.
`test/core/clothing/age_band_test.dart` · RF-6, CL-13: pertenencia en 3, 12, 36, 60 meses; sin franja → sin recomendación.
`test/core/clothing/recommendation_table_test.dart` · RF-7: límites de rango −6/5/6/12/13/17/18/24/25/29/30/50; ajuste recién nacido (+1 capa en ≤12 °C); continuidad sin huecos.
`test/features/clothing/application/clothing_controller_test.dart` · RF-5, RF-6, CL-10: geo tardía actualiza efectiva; cambio de franja re-evalúa; estado de carga; con fakes del repository (sin red).
`test/features/clothing/presentation/clothing_page_test.dart` (widget) · RF-7, RF-8, RNF-2, principio 6: muestra recomendación y aviso sin sustituirla; errores RF-1; textos en español; layout ≥320 dp.

Verificación de fin: `flutter pub get && flutter analyze && flutter test` → 0/0/0.

## 7. Cobertura RF ↔ partes

| RF | Módulo | Tests |
|---|---|---|
| RF-1 | `core/…manual_input_parser.dart` | parser_test |
| RF-2 | `data/` (geo, open_meteo, repository) + controller | controller_test |
| RF-3 | `core/…effective_temperature.dart` | effective_temperature_test |
| RF-4 | `core/…effective_temperature.dart` + `data/` + UI | effective_temperature_test + controller/widget |
| RF-5 | `application/clothing_controller.dart` | controller_test |
| RF-6 | `core/…age_band.dart` + controller | age_band + controller |
| RF-7 | `core/…recommendation_table.dart` + UI | recommendation_table + widget |
| RF-8 | `core/…extreme_threshold.dart` + UI | extreme_threshold + widget |
| RF-9 | `core/` (pureza + determinismo) | effective_temperature_test |