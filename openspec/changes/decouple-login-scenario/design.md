## Context

El escenario `@login @positivo` en `auth.feature` incluye actualmente un bloque inline que llama a `/signup` antes de ejecutar `/login`. Esto acopla dos responsabilidades distintas en un solo escenario: el registro de un usuario nuevo y la validación del token de sesión devuelto por el endpoint de login.

El `Background` ya declara `usuarioExistente = 'standard_test_user'` como variable compartida de contexto. Este usuario se asume persistente en el entorno de pruebas (convención de entorno gestionada fuera del código de test).

Estado actual (líneas 49–53 de `auth.feature`):
```
# Primero creamos el usuario para garantizar que existe
Given path '/signup'
And request { username: '#(nuevoUsuario)', password: '#(passValido)' }
When method POST
Then status 200
```

## Goals / Non-Goals

**Goals:**
- Eliminar el bloque de `/signup` inline del escenario `@login @positivo`.
- Sustituir `nuevoUsuario` por `usuarioExistente` en el request de `/login` dentro de ese escenario.
- Dejar el contrato del escenario acotado exclusivamente a validar el endpoint `/login`.
- Documentar con un comentario inline la decisión de diseño sobre el usuario preexistente.

**Non-Goals:**
- Introducir hooks Java (`@BeforeAll` / `@BeforeEach`) para aprovisionar el usuario en esta iteración.
- Modificar los escenarios `@signup @positivo`, `@signup @negativo` ni `@login @negativo`.
- Cambiar `karate-config.js`, `pom.xml` o los runners JUnit 5.

## Decisions

### 1. Usar `usuarioExistente` en lugar de `nuevoUsuario` para el login positivo

**Decisión:** Reemplazar el uso de `nuevoUsuario` (usuario creado dinámicamente por timestamp) con `usuarioExistente` (`standard_test_user`) en el escenario `@login @positivo`.

**Rationale:** `nuevoUsuario` existe únicamente para los escenarios de signup, donde el objetivo es probar el registro. En el escenario de login positivo, el objetivo es probar el endpoint `/login`; usar un usuario preexistente y estable elimina la dependencia en el estado de `/signup` y reduce la superficie de fallo espuria.

**Alternativa descartada:** Mantener `nuevoUsuario` y solo extraer el setup de signup a un `callonce`. Se descarta porque introduce un nuevo mecanismo de compartición de estado entre escenarios y añade complejidad innecesaria para un cambio cuyo alcance es puntual.

---

### 2. Convención de entorno para `standard_test_user` (sin hooks Java)

**Decisión:** `standard_test_user` se declara como prerrequisito de entorno fuera del código de test. No se automatiza su creación mediante hooks Java en esta iteración.

**Rationale:** La cuenta `standard_test_user` ya existe persistentemente en el entorno de pruebas de Demoblaze (evidenciado por su uso exitoso en `@signup @negativo`, que espera el error `This user already exist.`). Añadir un `@BeforeAll` escalaría la solución más allá del alcance del cambio y acoplaría el runner JUnit al estado del entorno de producción.

**Alternativa descartada:** Crear `standard_test_user` mediante `callonce` en `Background`. Se descarta porque produciría un fallo en el escenario `@signup @negativo` si el usuario aún no existe al correr en un entorno limpio, o introduciría orden de ejecución implícito entre escenarios.

## Risks / Trade-offs

- **[Riesgo] `standard_test_user` no existe en el entorno** → Mitigación: documentar en `readme.txt` / `conclusiones.txt` que la cuenta es un prerrequisito de entorno. La cuenta ya es referenciada en `@signup @negativo`, por lo que este riesgo es preexistente y no introducido por este cambio.
- **[Trade-off] Sin garantía programática de que el usuario existe en runtime** → A cambio se obtiene aislamiento de escenarios y reportes limpios. El trade-off es aceptable dado el alcance de la prueba técnica.

## Migration Plan

1. Eliminar el bloque inline de `/signup` (líneas 49–53 en `auth.feature`) del escenario `@login @positivo`.
2. Sustituir las referencias a `nuevoUsuario` por `usuarioExistente` en el request del escenario `@login @positivo`.
3. Agregar un comentario inline explicando que `usuarioExistente` es gestionado como prerrequisito de entorno.
4. Ejecutar `./mvnw test` y verificar que los 4 escenarios reportan PASS.
5. No se requiere rollback especial: el cambio es reversible restaurando las 4 líneas eliminadas.

## Open Questions

- **Contraseña de `standard_test_user`**: Se asume que la contraseña es `passValido` (`SofkaQ4Test!`), igual a la usada en el resto del feature. Confirmar que la cuenta en Demoblaze fue registrada con esa misma contraseña. Si difiere, será necesario declarar `passUsuarioExistente` como variable separada en el Background.
