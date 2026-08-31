# Plan 001 — Cómo vestir al bebé según la temperatura

Traduce `specs/001-babyapp-mvp/spec.md` a una estructura implementable que
respeta la constitución: stack mínimo (§1), Clean Architecture con capas
Domain/Data/Presentation (§3), stateless (§5), tests en verde (§4),
identificadores en inglés/mensajes en español vía l10n (§6) y requisitos
mínimos de spec (§2).

## 1. Dependencias — RF-2, RF-4 · constitución §1

Aprobadas en bloque, añadidas a `pubspec.yaml`:
- `http` → cliente HTTP (restringido a capa Data).
- `geolocator` → acceso GPS (restringido a capa Data).

Sin nada más: JSON con `dart:convert`, estado con `ChangeNotifier` +
`ListenableBuilder` (ambos de Flutter), tests con `flutter_test`. Strings de
UI centralizados vía l10n (lib/app_localizations.dart).

## 2. Estructura de módulos (Clean Architecture §3)

```
lib/
  main.dart                                           → arranque + MaterialApp con delegates l10n   · §6
  core/                                               → dominio puro (sin framework)                · §3A
    domain/
      temperature/
        manual_input_parser.dart                      · RF-1, CL-1, CL-4
        effective_temperature.dart                    · RF-3, RF-4, RF-9, CL-5..CL-9, CL-11, CL-8
        extreme_threshold.dart                        · RF-8, CL-3
      clothing/
        age_band.dart                                 · RF-6, CL-13, franjas [0,3)[3,12)[12,36)[36,60]
        recommendation_table.dart                     · RF-7, tabla y ajustes por franja
        clothing_recommendation.dart                  → entidad ClothingRecommendation
      contracts/
        weather_repository.dart                       → interfaz abstracta WeatherRepository      · §2, §3A
        geo_repository.dart                           → interfaz abstracta GeoRepository          · §2, §3A
      failures/
        failures.dart                                 → GeoFailure, ManualInputFailure            · §2
    data/                                             → implementa repositorios (I/O, GPS, HTTP)   · §3B
      geo/
        geolocator_service.dart                       → implementa GeoRepository con geolocator   · RF-2, CL-12
      weather/
        open_meteo.dart                               → HTTP + parseo JSON (DTOs)                  · RF-2, CL-11
        weather_repository_impl.dart                  → implementa WeatherRepository               · RF-2, RF-4
  features/clothing/
    presentation/
      clothing_controller.dart                        → estado efímero (cambio de franja, carga)   · RF-5, RF-6, §5
      clothing_page.dart                              → renderiza y delega                         · RF-1..RF-8, RNF-2
      l10n/
        app_localizations.dart                        → centraliza strings español (ARB)          · §6
test/
  core/domain/temperature/…                           · RF-1..RF-9 (unit tests puros)
  core/domain/clothing/…                              · RF-6, RF-7
  core/data/…                                        · fakes del repository (sin red)
  features/clothing/presentation/…                    · controller + widget
```

Regla clave: `core/domain/` y sus tests no importan Flutter ni `dart:io`
(verificable al ejecutarse en VM pura). La pantalla no calcula nada: delega
en el controller y éste invoca casos de uso o delega en repository.

## 3. Modelo de datos JSON — RF-2, RF-4 · §3B (solo transporte, sin persistencia)

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

DTOs de frontera (en `data/weather/`): `WeatherResponse.fromJson(…)` →
`TemperatureReading(tenths)` (el adaptador convierte a décimas enteras con
aritmética int para evitar errores de coma flotante y descarta lecturas fuera
de −30…50 → `null`, RF-4/CL-11). Los DTOs se mapean a entidades de dominio
`TemperatureReading` en `core/domain/`.

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
manualIgnored` (los textos exactos en español viven en la UI via l10n, RF-4/HU-4).

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
5. **Estado: `ChangeNotifier` + `ListenableBuilder` de Flutter** en el controller; el estado de carga/clima es efímero (§5) · RF-5. Descartado: `provider`/`riverpod`/`bloc` (paquetes extra contra el stack mínimo).
6. **Sin persistencia** — la spec declara stateless (RNF-3, Fuera de alcance) · §5. Descartado: `shared_preferences` (no hay nada que persistir en el MVP).
7. **Números como décimas enteras en `core/domain/`** para promedio/redondeo · RF-3, CL-8. Descartado: `double` directo (errores de coma flotante en 0,1/0,2 que romperían el determinismo de RF-9).
8. **Fallback simétrico en `computeEffective()`** puro: geo no disponible → manual sola; manual no válida → geo sola · RF-4, CL-5, CL-6. Descartado: imitar CL-5 antiguo ("error igualmente"), que QA consideró contradictorio.
9. **Umbrales sobre la efectiva redondeada** (no sobre el promedio con decimales) · RF-8/CL-3. Descartado: evaluar sobre valor sin redondear (mostraría avisos inconsistentes con lo mostrado).
10. **Reintento de permiso en `AppLifecycleListener` (resume)** · RF-2, CL-12. Descartado: polling con temporizador (gasto innecesario).
11. **l10n centralizada vía `MaterialApp` con `localizationsDelegates`** · §6. Descartado: strings hardcodeados en widgets (no centralizados; rompe §6).
12. **Repositorios como interfaces abstractas en `core/domain/contracts/`** · §2, §3A. Descartado: repositorios concretos en dominio (rompe la regla de dependencia §3).

## 6. Estrategia de tests — §4

`test/core/domain/temperature/manual_input_parser_test.dart` · RF-1, CL-1, CL-4: −30/50 válidos; vacío, solo espacios, no numérico, >1 decimal y fuera de rango → `ManualInputError`; coma y punto; signos ±; espacios alrededor.
`test/core/domain/temperature/effective_temperature_test.dart` · RF-3, RF-4, RF-9, CL-5..CL-9, CL-11, CL-8: promedio de dos fuentes; redondeo half-up 19,5→20, −2,4→−2, −2,5→−2, −2,6→−3, 19,4→19; fallback manual-sola y geo-sola con `notice`; ninguna fuente → `null`; geo fuera de rango → no disponible; determinismo (misma entrada → mismo resultado).
`test/core/domain/temperature/extreme_threshold_test.dart` · RF-8, CL-3: 0→frío, 30→calor, 1..29→ninguno; umbral independiente de los cortes de tabla.
`test/core/domain/clothing/age_band_test.dart` · RF-6, CL-13: pertenencia en 3, 12, 36, 60 meses; sin franja → sin recomendación.
`test/core/domain/clothing/recommendation_table_test.dart` · RF-7: límites de rango −6/5/6/12/13/17/18/24/25/29/30/50; ajuste recién nacido (+1 capa en ≤12 °C); continuidad sin huecos.
`test/features/clothing/presentation/clothing_controller_test.dart` · RF-5, RF-6, CL-10: geo tardía actualiza efectiva; cambio de franja re-evalúa; estado de carga; con fakes del repository (sin red).
`test/features/clothing/presentation/clothing_page_test.dart` (widget) · RF-7, RF-8, RNF-2, §6: muestra recomendación y aviso sin sustituirla; errores RF-1; textos vía l10n en español; layout ≥320 dp.

Verificación de fin: `flutter pub get && flutter analyze && flutter test` → 0/0/0.

## 7. Cobertura RF ↔ partes

| RF | Módulo | Tests |
|---|---|---|
| RF-1 | `core/domain/…/manual_input_parser.dart` | parser_test |
| RF-2 | `data/` (geo, open_meteo, repository_impl) + controller | controller_test |
| RF-3 | `core/domain/…/effective_temperature.dart` | effective_temperature_test |
| RF-4 | `core/domain/…/effective_temperature.dart` + `data/` + UI | effective_temperature_test + controller/widget |
| RF-5 | `features/clothing/presentation/clothing_controller.dart` | controller_test |
| RF-6 | `core/domain/…/age_band.dart` + controller | age_band + controller |
| RF-7 | `core/domain/…/recommendation_table.dart` + UI | recommendation_table + widget |
| RF-8 | `core/domain/…/extreme_threshold.dart` + UI | extreme_threshold + widget |
| RF-9 | `core/domain/` (pureza + determinismo) | effective_temperature_test |
