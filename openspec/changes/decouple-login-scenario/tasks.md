## 1. Modificar auth.feature

- [x] 1.1 Eliminar el bloque inline de `/signup` (los 4 pasos: `Given path '/signup'`, `And request`, `When method POST`, `Then status 200`) del escenario `@login @positivo` en `src/test/resources/demoblaze/auth.feature`
- [x] 1.2 Reemplazar `#(nuevoUsuario)` por `#(usuarioExistente)` en el campo `username` del request de `/login` dentro del escenario `@login @positivo`
- [x] 1.3 Agregar un comentario inline en el escenario `@login @positivo` que indique que `usuarioExistente` (`standard_test_user`) es un prerrequisito de entorno gestionado externamente, no por código de test

## 2. Verificación

- [x] 2.1 Ejecutar `./mvnw test` y confirmar que los 4 escenarios (`@signup @positivo`, `@signup @negativo`, `@login @positivo`, `@login @negativo`) reportan PASS
- [x] 2.2 Confirmar que el reporte HTML se genera en `target/karate-reports/karate-summary.html`
- [x] 2.3 Revisar el código final del escenario `@login @positivo` y verificar que no contiene ningún paso `Given path '/signup'`
