## Context

`auth.feature` cubre los 4 escenarios de autenticación Demoblaze con validaciones de status code y valores concretos del body. Sin embargo, ningún escenario verifica la **estructura del contrato** de respuesta. El objetivo de este cambio es agregar validaciones de schema de forma **aditiva** (sin tocar assertions existentes) para detectar cambios silenciosos en el contrato de la API.

Los contratos de respuesta observados en los 4 escenarios son:

| Escenario | Tipo de respuesta | Contrato |
|---|---|---|
| Signup exitoso | `null` | body es null |
| Signup duplicado | Objeto JSON | `{ errorMessage: string }` |
| Login exitoso | String primitivo | token no vacío |
| Login inválido | Objeto JSON | `{ errorMessage: string }` |

Stack relevante: Karate DSL 1.4.1, sin dependencias nuevas necesarias.

## Goals / Non-Goals

**Goals:**
- Agregar aserciones de schema a los 4 escenarios de `auth.feature` sin modificar los assertions actuales.
- Definir contratos de respuesta legibles y reutilizables en `src/test/resources/demoblaze/schemas/`.
- Cubrir los 3 formas de respuesta distintas: `null`, string primitivo y objeto `{errorMessage}`.

**Non-Goals:**
- Modificar, eliminar o reordenar los assertions de status code y valores concretos existentes.
- Agregar nuevos escenarios de prueba.
- Cambiar `AuthTest.java`, `karate-config.js` ni ningún otro feature.
- Adoptar JSON Schema estándar (draft-07 etc.) — fuera del alcance de Karate DSL nativo.

## Decisions

### 1. Karate-native schema notation sobre JSON Schema estándar

**Decisión**: Usar la notación de Karate DSL (`#string`, `#null`, `#object`, `#number`) tanto en los archivos `.json` de schema como en assertions inline, en lugar de JSON Schema estándar (draft-07 / draft-2020).

**Rationale**: Karate 1.4.1 soporta esta notación de forma nativa sin librerías adicionales. JSON Schema estándar requeriría un validador externo y añadiría complejidad innecesaria para contratos tan simples. La notación de Karate es directamente ejecutable con `match`.

**Alternativa descartada**: JSON Schema estándar con `JsonSchemaFactory` — introduce dependencia externa y verbosidad sin beneficio para este alcance.

---

### 2. Archivos de schema externos para objetos; assertions inline para primitivos y null

**Decisión**: Crear archivos JSON de schema en `src/test/resources/demoblaze/schemas/` únicamente para respuestas de tipo objeto. Las respuestas `null` y string primitivo se validan con assertions inline (`match response == #null`, `match response == #string`).

**Rationale**: Un archivo JSON para `null` o un string primitivo no aporta valor de documentación y sería artificioso. Los objetos JSON sí se benefician de un archivo externo porque documentan el contrato de forma explícita y son reusables.

**Alternativa descartada**: Todo inline — funciona pero dispersa los contratos en el feature, dificultando su lectura como documentación de API.

---

### 3. Un único `error-response-schema.json` compartido para los dos casos de error

**Decisión**: Los escenarios de signup-duplicado y login-inválido comparten la misma estructura de respuesta `{ errorMessage: string }`. Se usará un único archivo `error-response-schema.json` referenciado desde ambos escenarios.

**Rationale**: Evita duplicación de schema. Si el contrato de error cambia, solo hay un archivo que actualizar. Los mensajes concretos (`'This user already exist.'`, `'User does not exist.'`) ya son cubiertos por los assertions de valor existentes.

**Alternativa descartada**: Dos archivos separados (`signup-duplicate-schema.json`, `login-invalid-schema.json`) — redundantes dado que la estructura es idéntica.

---

### 4. Assertions aditivos, añadidos al final de cada escenario

**Decisión**: Las nuevas líneas `match` se agregan **después** de los assertions existentes en cada escenario, nunca reemplazándolos.

**Rationale**: El objetivo declarado en la propuesta es refuerzo de cobertura, no refactorización. Mantener el orden existente minimiza el riesgo de regresión y hace el diff más claro.

## Risks / Trade-offs

- **[Contrato inestable de API pública]** → Demoblaze es una demo pública sin SLA; su contrato puede cambiar. Mitigación: los schema tests fallarán explícitamente ante cualquier cambio, que es el comportamiento deseado.

- **[Inconsistencia de approach entre escenarios]** → Signup-exitoso y login-exitoso usan inline (`#null`, `#string`) mientras los casos de error usan archivo externo. Esta asimetría puede parecer inconsistente. Trade-off aceptado: refleja la naturaleza real de cada respuesta; forzar archivos para primitivos sería artificial.

- **[Resolución de classpath en `karate.read()`]** → La ruta debe usar el prefijo `classpath:` para funcionar tanto en ejecución IDE como con `./mvnw test`. Mitigación: usar siempre `read('classpath:demoblaze/schemas/error-response-schema.json')` en el feature.

## Migration Plan

No aplica migración de producción. El cambio es exclusivamente de pruebas. Para validar:

```bash
./mvnw test
```

El reporte se genera en `target/karate-reports/karate-summary.html`. Los 4 escenarios deben seguir en PASS tras el cambio.

No existe estrategia de rollback especial: revertir el commit es suficiente dado que los cambios son aditivos y no alteran el comportamiento del producto.

## Open Questions

*(Ninguna — los contratos de respuesta están completamente definidos por los assertions de valor existentes en `auth.feature`.)*
