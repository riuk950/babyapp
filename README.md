# Proyecto: babyapp

aplicación móvil para android y IOS bonita y práctica, diseñada para madres con niños de 0 a 5 años. El objetivo es proporcionar una guía rápida y accesible con información esencial sobre crianza directamente en sus teléfonos celulares.

## Funtions
```
- Cómo vestir al bebé según la temperatura: Una sección que ofrezca recomendaciones sobre la vestimenta adecuada para el bebé en función de la temperatura ambiente.
- Cuánto debe dormir por edad: Información detallada sobre los patrones de sueño recomendados para cada etapa de desarrollo del bebé y niño pequeño.
- Cómo almacenar leche materna: Guía práctica sobre las mejores prácticas para la extracción, almacenamiento y uso seguro de la leche materna.
- Qué hitos esperar cada mes: Un seguimiento del desarrollo del niño, destacando los hitos clave que se pueden esperar mes a mes desde el nacimiento hasta los 5 años.
- Señales de alerta: Información crucial sobre posibles señales de alerta en la salud o desarrollo del niño, indicando cuándo buscar atención médica.
- Tips rápidos de rutina: Consejos prácticos para establecer rutinas diarias que faciliten la organización y el bienestar familiar.
- Primera ayuda básica: Instrucciones claras y concisas sobre cómo actuar en situaciones de emergencia de primeros auxilios para bebés y niños.
```


## Estructura del proyecto

```

├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   └── storage_constants.dart
│   │   ├── errors/
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── extensions/
│   │   │   │   ├── string_extensions.dart
│   │   │   │   └── date_extensions.dart
│   │   ├── routing/
│   │   │   └── app_routes.dart
│   │   └── config/
│   │       ├── app_config.dart
│   │       └── services/
│   │           ├── logging_config.dart
│   │           └── theme_config.dart
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── user.dart
│   │   │   ├── product.dart
│   │   │   └── order.dart
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   └── product_model.dart
│   │   ├── usecases/
│   │   │   ├── login_usecase.dart
│   │   │   ├── register_usecase.dart
│   │   │   └── get_products_usecase.dart
│   │   ├── repositories/
│   │   │   ├── user_repository/
│   │   │   │   └── user_repository.dart
│   │   │   └── product_repository/
│   │   │       └── product_repository.dart
│   │   ├── errors/ (domain errors específicos)
│   │   │   └── auth_failure.dart
│   │   └── providers/
│   │       ├── auth_provider.dart      ← Riverpod Provider abstracto
│   │       └── product_provider.dart
│   │
│   ├── data/
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   └── local_constants.dart
│   │   ├── sources/
│   │   │   ├── remote/
│   │   │   │   ├── api/
│   │   │   │   │   ├── user_api.dart
│   │   │   │   │   └── product_api.dart
│   │   │   │   ├── api_models/
│   │   │   │   │   ├── user_response.dart
│   │   │   │   │   └── product_response.dart
│   │   │   │   ├── service/
│   │   │   │   │   ├── http_service.dart
│   │   │   │   │   └── api_config.dart
│   │   │   │   └── api_factory.dart
│   │   │   └── local/
│   │   │       ├── database/
│   │   │       │   ├── database_helper.dart
│   │   │       │   ├── user_table.dart
│   │   │       │   └── product_table.dart
│   │   │       ├── repository_impl/
│   │   │       │   ├── user_repository_impl.dart
│   │   │       │   └── product_repository_impl.dart
│   │   │       └── prefs/
│   │   │           ├── prefs_service.dart
│   │   │           └── user_prefs.dart
│   │   └── datasources/
│   │       ├── remote_data_source/
│   │       │   ├── user_data_source.dart
│   │       │   └── product_data_source.dart
│   │       └── local_data_source/
│   │           └── local_data_source.dart
│   │   └── data_riverprods/
│   │       ├── user_data_riverpod.dart
│   │       └── product_data_riverpod.dart
│   │
│   ├── presentation/
│   │   ├── routes/
│   │   │   └── routes_config.dart
│   │   ├── widgets/
│   │   │   ├── common_widgets/
│   │   │   │   ├── custom_button.dart
│   │   │   │   ├── custom_text_field.dart
│   │   │   │   └── loading_indicator.dart
│   │   │   └── features/
│   │   │       ├── login_screen.dart
│   │   │       ├── register_screen.dart
│   │   │       └── products_screen.dart
│   │   ├── pages/
│   │   │   ├── auth/
│   │   │   │   ├── login_page.dart
│   │   │   │   └── register_page.dart
│   │   │   └── home/
│   │   │       ├── products_page.dart
│   │   │       └── order_page.dart
│   │   │
│   │   ├── providers/ ← HERE en Riverpod
│   │   │   ├── auth_provider.dart       (NotifierProvider)
│   │   │   └── products_provider.dart   (AsyncNotifierProvider)
│   │   └── main.dart
│   │
│   └── riverpod/
│       ├── riverpod_app.dart           (Main)
│       ├── provider_config.dart        (AppProviderConfig)
│       └── auto_dispose.dart           (AutoDisposeProvider)
│
├── assets/
│   ├── images/
│   │   ├── logos/
│   │   ├── icons/
│   │   └── backgrounds/
│   └── fonts/
├── env/
│   └── prod/            # Ambiente de Produccion
│   └── dev/             # Ambientre de desarrollo
│
├── tests/
│   ├── unit/
│   │   ├── domain/
│   │   │   ├── user_test.dart
│   │   │   └── login_usecase_test.dart
│   │   └── data/
│   │       ├── http_service_test.dart
│   │       └── user_repository_impl_test.dart
│   └── integration/
│       └── auth_integration_test.dart
│
├── pubspec.yaml
├── analysis_options.yaml
├── .env.example
└── README.md

```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
