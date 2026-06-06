## Why

Las aserciones en `auth.feature` no reflejan el comportamiento real de la API de Demoblaze.
Los escenarios negativos fallan o producen falsos positivos porque el contrato de respuesta
documentado no coincide con lo que la API entrega en producción, comprometiendo la confiabilidad
de la suite de pruebas.

## What Changes

- Corregir la aserción del escenario `@signup @negativo`: la API retorna el objeto JSON
  `{"errorMessage": "This user already exist."}` como string crudo (no como JSON parseado),
  por lo que `match response.errorMessage` falla; se debe hacer match al string completo o
  al campo parseado con la estrategia correcta de Karate.
- Corregir la aserción del escenario `@login @negativo`: la API retorna el objeto JSON
  `{"errorMessage": "Wrong password."}` cuando las credenciales son inválidas; el match debe
  apuntar al campo `errorMessage` con el valor correcto, usando la misma estrategia de parseo
  que el escenario `@signup @negativo`.
- Actualizar `conclusiones.txt` documentando los hallazgos exactos del contrato de respuesta
  observado.

## Capabilities

### New Capabilities
- `auth-contract-assertions`: Aserciones de contrato correctas para los endpoints
  `/signup` y `/login` de Demoblaze, alineadas con las respuestas reales de la API.

### Modified Capabilities
<!-- No hay specs previos; el proyecto no tiene openspec/specs/ con specs existentes. -->

## Impact

- **Archivo afectado**: `src/test/resources/demoblaze/auth.feature` (líneas 39 y 71).
- **Documentación afectada**: `conclusiones.txt` (sección HALLAZGOS DEL API, puntos 2 y nuevo hallazgo).
- Sin cambios en dependencias, configuración de Maven ni runner.
- Sin cambios en otros feature files.
