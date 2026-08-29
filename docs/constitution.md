# Constitución

1. **Stack mínimo**: solo Flutter y Dart. Toda dependencia extra se aprueba antes en la spec. Aprobadas en bloque: cliente HTTP y acceso GPS (funciones de clima).
2. **Spec-código**: cada función tiene su spec activa (`specs/<id-funcion>/spec.md`); código sin spec no entra al repo.
3. **Separación**: lógica pura en `lib/core` sin importar Flutter; las pantallas solo renderizan y delegan.
4. **Tests**: `flutter test` siempre en verde; la lógica pura exige tests unitarios y cada fix incluye su test.
5. **Persistencia**: un único mecanismo declarado en la spec; nada de guardar datos por vías ad-hoc. El estado efímero de sesión no es persistencia.
6. **Idioma**: identificadores, archivos y tests en inglés; mensajes visibles al usuario en español.