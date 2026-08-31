# Tasks 001 — Cómo vestir al bebé según la temperatura

Tareas en orden de dependencia. Cada una ≤ 20–30 min. Coordinación con
`specs/001-babyapp-mvp/spec.md` y `plan.md`. Identificadores en inglés,
mensajes de usuario en español (§6). Nada en `core/domain/` importa Flutter
(§3A).

## Fase 0 — Base

- [ ] T1. Añadir dependencias aprobadas
      RF: RF-2, RF-4 · plan §1
      Hecho cuando: `pubspec.yaml` incluye `http` y `geolocator`, y
      `flutter pub get` sale con exit 0.

- [ ] T2. Definir tipos de dominio en `core/domain/`
      RF: RF-6, RF-7, RF-8 · plan §2 (`core/domain/models.dart`)
      Hecho cuando: existen `AgeBand`, `ManualInputResult`,
      `TemperatureReading`, `EffectiveTemperature`, `NoticeType`,
      `ExtremeLevel` y `ClothingRecommendation`, sin importar Flutter, y
      `flutter analyze` no reporta nada en ese archivo.

## Fase 1 — Lógica pura (`core/domain/`) + tests unitarios

- [ ] T3. Parser de entrada manual (formato y validación)
      RF: RF-1 · CL-1, CL-4 · plan §2, §6
      Hecho cuando: impares vacío / solo espacios / no numérico / >1 decimal /
      fuera de −30…50; valida coma y punto (±), espacios alrededor y extremos
      −30/50; todos los tests pasan.

- [ ] T4. Temperatura efectiva: promedio, redondeo half-up y fallback
      RF: RF-3, RF-4, RF-9 · CL-5..CL-9, CL-11, CL-8 · plan §2, §6
      Hecho cuando: promedia dos fuentes; redondea 19,5→20, −2,4→−2, −2,5→−2,
      −2,6→−3, 19,4→19; fallback manual-sola y geo-sola con `NoticeType`;
      sin fuentes → `null`; geo fuera de −30…50 → no disponible; misma entrada
      → mismo resultado.

- [ ] T5. Umbral de extremo
      RF: RF-8 · CL-3 · plan §2, §6
      Hecho cuando: 0→`cold`, 30→`heat`, 1..29→`none`, y el valor entero
      redondeado es la entrada única (no el promedio con decimales).

- [ ] T6. Franjas de edad
      RF: RF-6 · CL-13 · plan §2, §6
      Hecho cuando: pertenencia correcta en 0, 3, 12, 36, 60 meses
      ([0,3)[3,12)[12,36)[36,60]) y sin franja → sin recomendación.

- [ ] T7. Tabla de recomendación y ajustes por franja
      RF: RF-7 · plan §2, §6
      Hecho cuando: límites −6/5/6/12/13/17/18/24/25/29/30/50 caen en el rango
      esperado (un único rango); recién nacido suma 1 capa en ≤12 °C; el
      dominio −30…50 queda sin huecos.

## Fase 2 — Efectos (`data/`) + repository

- [ ] T8. Contratos de repository en `core/domain/contracts/`
      RF: RF-2, RF-4 · plan §2
      Hecho cuando: `WeatherRepository` y `GeoRepository` son interfaces
      abstractas sin dependencias de framework, y `flutter analyze` sin
      hallazgos.

- [ ] T9. Adaptador Open-Meteo (HTTP + JSON) en `data/weather/`
      RF: RF-2 · CL-11 · plan §2, §3
      Hecho cuando: parsea la respuesta de ejemplo a `TemperatureReading` en
      décimas enteras y una lectura fuera de −30…50 devuelve `null`.

- [ ] T10. Servicio de geolocalización en `data/geo/`
      RF: RF-2 · plan §2
      Hecho cuando: `geolocator_service.dart` devuelve lat/long vía
      `geolocator` o un `GeoFailure` tipado (denegado, no disponible), sin
      lógica de negocio.

- [ ] T11. WeatherRepository (orquesta geo + HTTP, clasifica fallos) en
      `data/weather/`
      RF: RF-2, RF-4 · RNF-6 · plan §2, §5(8)
      Hecho cuando: con fakes del geo y del HTTP devuelve una geoTemperatura
      dentro de rango, o clasifica el fallo (permiso, red, servicio, datos
      inválidos) de forma testeada sin red real.

## Fase 3 — Presentación y arranque

- [ ] T12. Configurar l10n en `main.dart`; crear ARB base para español.
      RF: §6 · plan §5(11)
      Hecho cuando: `flutter analyze` sin hallazgos y la app compila con locale
      español por defecto.

- [ ] T13. Controller de la pantalla en `features/clothing/presentation/`
      RF: RF-1(wiring), RF-5, RF-6 · CL-10, CL-12 · plan §2, §5(5,10)
      Hecho cuando: con fakes, la geo tardía actualiza la efectiva; cambiar de
      franja re-evalúa; sin franja no recomienda; muestra estado de carga; al
      volver al primer plano reintenta la consulta si antes falló.

- [ ] T14. Pantalla (renderiza y delega) en `features/clothing/presentation/`
      RF: RF-1..RF-8 · RNF-2, RNF-5 · §6 · plan §2, §3
      Hecho cuando: presenta campo manual, selector de franja, indicador de
      carga, recomendación, aviso de extremo sin sustituirla, y los textos
      exactos de RF-1 y RF-4 en español vía l10n.

- [ ] T15. Arranque y tema de la app
      RF: RF-7 · RNF-5 · plan §2
      Hecho cuando: `main.dart` lanza la pantalla de clima con un tema legible
      (contraste suficiente) y sin la demo del contador.

## Fase 4 — Verificación

- [ ] T16. Widget test de la pantalla
      RF: RF-7, RF-8 · RNF-2 · §6 · plan §6
      Hecho cuando: el widget test verifica recomendación, aviso sin
      reemplazarla, errores RF-1 y layout ≥320 dp con textos vía l10n en
      español.

- [ ] T17. Gate final
      RF: todos · §4 · plan §4
      Hecho cuando: `flutter pub get && flutter analyze && flutter test`
      devuelven 0/0/0 y toda la cobertura de RF del plan §7 está verde.
