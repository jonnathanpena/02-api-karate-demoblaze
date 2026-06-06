## ADDED Requirements

### Requirement: Escenario de login positivo acotado exclusivamente a /login
El escenario `@login @positivo` SHALL realizar únicamente una llamada al endpoint `/login` usando las credenciales de un usuario preexistente (`usuarioExistente` = `standard_test_user`). No MUST existir ninguna llamada cruzada a `/signup` dentro de ese mismo escenario. El usuario preexistente es un prerrequisito de entorno gestionado fuera del código de test.

#### Scenario: Login exitoso con usuario preexistente retorna token de sesion
- **WHEN** el escenario `@login @positivo` ejecuta una petición POST a `/login` con `usuarioExistente` y `passValido`
- **THEN** el status HTTP de respuesta es 200, la respuesta es un `#string` no nulo y su longitud es mayor a 0

#### Scenario: Escenario de login positivo no llama a /signup
- **WHEN** el escenario `@login @positivo` ejecuta sus pasos completos
- **THEN** el único path invocado es `/login`; no existe ningún paso `Given path '/signup'` dentro de ese escenario

### Requirement: Variable de usuario preexistente declarada en Background
El `Background` del feature SHALL declarar `usuarioExistente` con el valor `standard_test_user` como variable de contexto compartida. Esta variable MUST ser la referenciada en el request del escenario `@login @positivo` en lugar de `nuevoUsuario`.

#### Scenario: Background expone usuarioExistente como variable de contexto
- **WHEN** se ejecuta cualquier escenario del feature
- **THEN** la variable `usuarioExistente` está disponible con el valor `'standard_test_user'`

#### Scenario: Request de login positivo usa usuarioExistente
- **WHEN** el escenario `@login @positivo` construye el cuerpo del request para `/login`
- **THEN** el campo `username` del request es `#(usuarioExistente)` y NO es `#(nuevoUsuario)`

### Requirement: Comentario inline documenta la decision de diseño sobre el usuario preexistente
El escenario `@login @positivo` SHALL incluir un comentario inline que explique que `usuarioExistente` es gestionado como prerrequisito de entorno fuera del feature, sin lógica Java `@BeforeAll`.

#### Scenario: Comentario inline presente en el escenario de login positivo
- **WHEN** se inspecciona el código del escenario `@login @positivo` en `auth.feature`
- **THEN** existe al menos un comentario (`#`) que hace referencia a que el usuario preexistente es un prerrequisito de entorno gestionado externamente
