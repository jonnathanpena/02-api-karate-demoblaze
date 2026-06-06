## Why

El escenario `@login @positivo` llama a `/signup` de forma inline antes de ejecutar `/login`, creando acoplamiento estructural entre dos endpoints distintos: un fallo en signup silencia el defecto real en login y los reportes mezclan responsabilidades. `standard_test_user` ya existe en el `Background` como usuario garantizado preexistente, por lo que el setup inline es redundante y contrario al principio de aislamiento de pruebas.

## What Changes

- Eliminar el bloque `Given path '/signup' … Then status 200` del escenario `Login con credenciales correctas retorna token de sesion`.
- Reemplazar `nuevoUsuario` por `usuarioExistente` (`standard_test_user`) en el `request` de `/login` dentro de ese escenario.
- Documentar en un comentario inline la decisión de diseño: el usuario preexistente se gestiona fuera del feature (registro manual o fixture de base de datos), y el Background ya lo declara como variable de contexto compartida.
- No se introduce lógica Java `@BeforeAll` en esta iteración: la cuenta `standard_test_user` se asume persistente en el entorno de pruebas (decisión registrada en `design.md`).

## Capabilities

### New Capabilities

- `login-test-isolation`: El contrato del escenario de login positivo queda acotado exclusivamente al endpoint `/login`: envía credenciales válidas de un usuario preexistente y valida que la respuesta sea un token de sesión (`#string`, longitud > 0). No existe llamada cruzada a `/signup` dentro del mismo escenario.

### Modified Capabilities

<!-- Ninguna: los requisitos de los escenarios de signup y del login negativo no cambian. -->

## Impact

- **`src/test/resources/demoblaze/auth.feature`**: modificación del escenario `@login @positivo` (eliminación de 4 líneas de setup + sustitución de variable).
- **Sin cambios** en `karate-config.js`, `pom.xml`, ni en los runners JUnit 5.
- **Sin cambios** en los escenarios `@signup @positivo`, `@signup @negativo` ni `@login @negativo`.
- El entorno de pruebas debe garantizar que `standard_test_user` exista en Demoblaze antes de la ejecución (convención de entorno, no de código).
