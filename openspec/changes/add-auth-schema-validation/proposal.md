## Why

Los 4 escenarios de `auth.feature` validan status code y valores concretos del body, pero ninguno verifica la **estructura** del contrato de respuesta (schema del JSON). Esto permite que cambios silenciosos en el contrato de la API (tipos de datos, campos faltantes o adicionales) pasen desapercibidos. Agregar validación de schema refuerza la cobertura de contrato en el nivel más fundamental.

## What Changes

- Agregar validaciones `match … == #object` / `match … == #string` / `match … == #null` (o equivalente Karate schema matching) en los 4 escenarios existentes de `auth.feature`.
- Crear el directorio `src/test/resources/demoblaze/schemas/` con archivos JSON de schema reutilizables para cada tipo de respuesta.
- Referenciar los schemas desde los escenarios usando `read` / `karate.read()` o inline, según convención del proyecto.
- No se modifican los assertions existentes (status code, valores concretos); se **agregan** los de schema sin reemplazar nada.

## Capabilities

### New Capabilities

- `auth-response-schema`: Contratos de schema JSON para las 4 respuestas del flujo de autenticación Demoblaze (signup exitoso, signup duplicado, login exitoso, login inválido).

### Modified Capabilities

*(Sin cambios en requisitos existentes — solo se añaden aserciones de schema sobre comportamiento ya especificado.)*

## Impact

- **Archivos modificados**: `src/test/resources/demoblaze/auth.feature`
- **Archivos nuevos**: `src/test/resources/demoblaze/schemas/signup-success-schema.json`, `signup-duplicate-schema.json`, `login-success-schema.json`, `login-invalid-schema.json`
- **Sin impacto** en runner (`AuthTest.java`), `karate-config.js`, ni en ningún otro feature.
- **Sin dependencias nuevas** — Karate DSL 1.4.1 ya soporta schema matching nativo.
