# Especificación 001 — Cómo vestir al bebé según la temperatura

## Aprobación de dependencia externa

Dependencias aprobadas para esta función:
- (Constitución, principio 1) Cliente HTTP y acceso GPS, aprobados en bloque para funciones de clima.
- (Esta spec) Servicio meteorológico externo consultado por red, aprobado conforme al principio 1.

Con ellas la app obtiene la temperatura ambiente automáticamente. El estado en
memoria de RF-5 (clima cargando o llegada tardía) es efímero y no constituye
persistencia (principio 5; RNF-3).

## Contexto y objetivo

Madres con niños de 0 a 5 años necesitan respuestas rápidas y fiables sobre
crianza. La usuaria introduce una temperatura manual y además la app la obtiene
automáticamente según su ubicación; el sistema calcula el promedio y muestra qué
ropa vestir al niño de forma inmediata y comprensible. Objetivo: reducir la
incertidumbre y el error al vestir a un bebé.

## Usuarios

- Madres, padres y cuidadores de niños de 0 a 5 años.
- Sin formación técnica: la interfaz debe ser clara y sin jerga.

## Historias de usuario

- HU-1: Como madre, quiero ver la ropa recomendada para la temperatura efectiva
  (promedio) según la edad de mi hijo, para vestirle adecuadamente.
- HU-2: Como usuaria, quiero que la app obtenga la temperatura sola vía mi
  ubicación, para no tener que comprobarla yo.
- HU-3: Como usuaria, quiero saber cuándo la temperatura es peligrosa, para
  extremar precauciones.
- HU-4: Como usuaria, quiero que me avisen si introduzco un valor inválido o si
  la geolocalización falló, para saber qué hacer.

## Requisitos funcionales

RF-1 — Obtención manual de temperatura
- Where la usuaria introduce un número en Celsius (signo opcional, coma o punto como separador decimal, hasta un decimal; los espacios alrededor se ignoran), el sistema lo aceptará.
- Where la temperatura manual está entre −30 y 50 °C inclusive, el sistema la validará como fuente disponible.
- If la temperatura manual está vacía, no es numérica o tiene más de un decimal, entonces el sistema mostrará "Introduce una temperatura" y no la usará como fuente.
- If la temperatura manual está fuera de −30…50 °C, entonces el sistema mostrará "La temperatura debe estar entre −30 y 50 °C" y no la usará como fuente.

RF-2 — Obtención por geolocalización
- When se abre la pantalla, el sistema pedirá permiso de ubicación y consultará la temperatura ambiente del lugar al servicio meteorológico.
- When la geolocalización devuelve una temperatura dentro de −30…50 °C, el sistema la usará como fuente automática.
- When la app vuelve al primer plano con permiso de ubicación concedido, el sistema reintentará la consulta si antes no se obtuvo.

RF-3 — Promedio, redondeo y umbrales
- When existen temperatura manual válida y temperatura de geolocalización, el sistema calculará el promedio de ambas (cada fuente con hasta un decimal) y recomendará con él.
- Where el promedio tiene decimales, el sistema redondeará la temperatura efectiva al entero más cercano con convención half-up hacia +∞ (19,5 → 20; −2,5 → −2).
- Where la temperatura efectiva es 0 °C o menos, o 30 °C o más, el sistema activará el aviso de extremo (RF-8).

RF-4 — Fallback de fuentes
- Where la geolocalización no está disponible (permiso denegado, sin conexión, servicio no responde o datos inválidos), el sistema recomendará con la temperatura manual y mostrará "No se ha podido obtener el clima automático. Se usa tu temperatura manual."
- Where la temperatura manual no es válida pero sí lo es la de geolocalización, el sistema recomendará con la geolocalizada y mostrará "Tu temperatura manual no es válida. Se usa el clima de tu zona."
- Where la geolocalización devuelve una temperatura fuera de −30…50 °C, el sistema la tratará como fuente no disponible.
- Where no hay ninguna fuente válida, el sistema no recomendará y pedirá la temperatura manual.

RF-5 — Re-evaluación tardía de la geolocalización
- When la geolocalización llega después de una temperatura manual ya introducida, el sistema actualizará la temperatura efectiva y la recomendación en cuanto esté disponible.
- While la geolocalización carga y existe la manual, el sistema recomendará con la manual y mostrará un indicador de carga del clima.

RF-6 — Selección de franja de edad
- Where no hay franja seleccionada, el sistema la pedirá y no recomendará hasta elegir una.
- When la usuaria selecciona una franja de edad, el sistema re-evaluará la recomendación con la temperatura efectiva actual.

RF-7 — Generación de recomendación
- When existen una temperatura efectiva válida y una franja de edad, el sistema mostrará la recomendación de vestimenta para esa temperatura y franja, de forma inmediata y en lenguaje sencillo.

RF-8 — Aviso en temperaturas extremas
- Where la temperatura efectiva (entero ya redondeado y mostrado) es ≤0 °C o ≥30 °C, el sistema mostrará un aviso de precaución visible junto a la recomendación normal.
- The aviso destacará visualmente, no reemplazará a la recomendación y sus umbrales son independientes de los cortes de la tabla de recomendación.

RF-9 — Respuesta determinista
- When se repiten la misma temperatura manual, la misma franja y la misma temperatura de geolocalización, el sistema devolverá siempre la misma recomendación y el mismo estado de aviso.

## Requisitos no funcionales

- RNF-1 Rendimiento: la recomendación con la manual es inmediata; la automática se integra al llegar sin bloquear la interacción.
- RNF-2 Usabilidad: pantalla legible en ≥320 dp de ancho, sin jerga técnica.
- RNF-3 Privacidad: la ubicación se usa solo para consultar la temperatura; no se almacena en ningún momento.
- RNF-4 Mantenibilidad: la regla de recomendación (franja × temperatura efectiva, con redondeo) vive aislada de la interfaz en lógica pura.
- RNF-5 Accesibilidad: texto legible y con contraste suficiente.
- RNF-6 Resiliencia: funciona sin conexión con solo la temperatura manual (fallback).

## Casos límite

- CL-1 Manual exactamente −30 y 50 °C: válidas (inclusive).
- CL-2 Temperatura efectiva en el límite entre dos rangos: sin ambigüedad, los rangos enteros contiguos de la tabla asignan cada valor a un único rango.
- CL-3 Temperatura efectiva ≤0 °C o ≥30 °C: se muestra recomendación + aviso; 0 y 30 pertenecen respectivamente a los rangos −5…5 y 30…50 de la tabla.
- CL-4 Manual vacía, solo espacios, no numérica o con más de un decimal: mensaje de error y fuente no usada.
- CL-5 Manual inválida pero geo válida: se recomienda con la geo y se avisa de que la manual se ignoró (fallback simétrico, RF-4).
- CL-6 Geo no disponible (permiso denegado, sin red, servicio no responde o datos inválidos): manual sola + aviso (RF-4).
- CL-7 Geo tarda: recomienda con la manual mientras carga y actualiza al llegar.
- CL-8 Promedio con decimales: redondeo half-up hacia +∞ (19,5 → 20; −2,5 → −2).
- CL-9 Sin ninguna fuente válida: se pide la manual.
- CL-10 Cambio de franja sin reintroducir temperatura: se re-evalúa la recomendación.
- CL-11 Geo fuera de −30…50 °C (dato anómalo): se trata como no disponible; el promedio de dos fuentes válidas siempre cae dentro del rango, por lo que nunca se indexa fuera de la tabla.
- CL-12 Permiso denegado y concedido después: al volver al primer plano el sistema reintenta la consulta (RF-2).
- CL-13 Sin franja seleccionada: no hay recomendación aunque exista temperatura efectiva (RF-6).

## Fuera de alcance (MVP)

- Historial de consultas y configuración persistente (app stateless; la ubicación no se guarda).
- Fahrenheit o selector de unidades.
- Factores extra (humedad, viento, actividad, hora del día, estación).
- Multibebé, notificaciones y contactos de emergencia.
- Caché de la temperatura de geolocalización entre sesiones.

## Decisiones de contenido

Franjas de edad (guía para que la usuaria elija; cada franja incluye el límite
inferior y excluye el superior): 0–3 meses [0,3), 3–12 meses [3,12), 1–3 años
[12,36) y 4–5 años [36,60] meses.

Temperatura extrema (aviso RF-8): frío ≤0 °C y calor ≥30 °C, evaluados sobre la
temperatura efectiva (entero ya redondeado y mostrado). Los umbrales son
independientes de los cortes de la tabla.

Formato de entrada manual: número con signo opcional, coma o punto decimal,
hasta un decimal; los espacios alrededor se ignoran.

Redondeo de la efectiva: half-up hacia +∞ (0,5 o más sube al entero superior;
−2,5 → −2).

Tabla de recomendación por temperatura efectiva (entero redondeado). Los rangos
son contiguos y cubren −30…50 °C sin huecos ni solapes, de modo que cada
temperatura pertenece a un único rango:

| Rango | Ropa base |
|---|---|
| −30…−6 °C | Body térmico + body manga larga + jersey y chaqueta de abrigo; gorro |
| −5…5 °C | Body manga larga + jersey + chaqueta de abrigo; gorro |
| 6…12 °C | Body manga larga + chaqueta o sudadera ligera |
| 13…17 °C | Body manga larga; jersey fino opcional |
| 18…24 °C | Body manga corta de algodón + pantalón; chaleco fino opcional |
| 25…29 °C | Body manga corta de algodón; evitar abrigar |
| 30…50 °C | Solo body/babador de algodón transpirable |

Ajustes por franja de edad:
- 0–3 meses: +1 capa en los 3 rangos fríos (≤12 °C); en calor, ropa mínima transpirable.
- 3–12 meses: ropa base; capa extra opcional al dormir.
- 1–3 años: ropa base.
- 4–5 años: ropa base (puede quitarse la capa opcional de los rangos fríos).

## Arquitectura y contratos (constitución §2, §3)

Esta sección satisface los requisitos mínimos de la constitución §2 y §3 para
esta spec.

### Casos de uso (Use Cases)

| Caso de uso | Flujo | RF asociado |
|---|---|---|
| `ParseManualTemperature` | La usuaria introduce texto → el sistema valida, parsea y devuelve `ManualInputResult` (ok con décimas enteras o error tipado). | RF-1, CL-1, CL-4 |
| `FetchGeoTemperature` | Al abrir o volver al primer plano, el sistema pide permiso GPS y consulta Open-Meteo → devuelve `GeoTemperatureResult` (ok o error tipado). | RF-2, CL-6, CL-11, CL-12 |
| `ComputeEffectiveTemperature` | Dadas fuentes disponibles, calcula promedio (o fallback), redondea half-up → `TemperatureResult` (valor + source + notice). | RF-3, RF-4, RF-5, RF-8, CL-8 |
| `GetClothingRecommendation` | Dada temperatura efectiva y franja, devuelve la recomendación de vestimenta y el estado de aviso extremo. | RF-6, RF-7, RF-8 |
| `EvaluateExtremeNotice` | Evalúa la temperatura efectiva contra los umbrales ≤0 °C / ≥30 °C → `ExtremeNotice` (none / cold / heat). | RF-8, CL-3 |

### Contratos de repositorio (I/O y Repository Interfaces)

La capa Domain define interfaces; la capa Data las implementa con las
dependencias aprobadas (HTTP, GPS).

```dart
// domain/contracts/weather_repository.dart
abstract class WeatherRepository {
  Future<GeoTemperatureResult> fetchCurrentTemperature();
}

// domain/contracts/geo_repository.dart
abstract class GeoRepository {
  Future<GeoPosition> getCurrentPosition();
}
```

`GeoTemperatureResult` y `GeoPosition` viven en `domain/entities/`. Los DTOs
que mapean las respuestas de Open-Meteo y Geolocator viven en `data/`.

### Estrategia de fallos de dominio

Todos los fallos se representan como tipos de dominio, nunca como excepciones
genéricas:

```dart
// domain/failures/failures.dart
enum GeoFailure { permissionDenied, noService, timeout, invalidData }
enum ManualInputFailure { empty, notNumeric, tooManyDecimals, outOfRange }
```

Los casos de uso devuelven `Result<T>` (Success o Failure). Las UI leen el
estado de error y muestran el mensaje apropiado en español.

### Persistencia

Declaración explícita conforme §5: **sin persistencia**. La temperatura
obtenida es estado efímero de sesión; no se escribe a disco, preferencias ni
almacenamiento local. La selección de franja (RF-6) tampoco persiste (app
stateless). No existe repository de persistencia ni data source local.

## Criterios de finalización

- Todos los RF verificables y cumplidos, y los casos límite resueltos.
- La regla de recomendación (franja × temperatura efectiva) y el redondeo half-up (incluidos negativos) cubiertos por tests unitarios.
- Los fallbacks de RF-4 (geo no disponible y manual no válida) cubierto por tests.
- Sin dependencias adicionales a las aprobadas en esta spec y en la constitución.
- Cumple §2 de la constitución: casos de uso, contratos de repositorio,
  estrategia de fallos de dominio y mecanismo de persistencia declarado.

## Dudas abiertas

- Ninguna: resueltas (ver Decisiones de contenido y casos límite).