## Context

El proyecto ejecuta 4 escenarios Karate DSL contra los endpoints públicos de Demoblaze (`/signup`, `/login`). El stack es Java 21 + Maven Wrapper (`./mvnw`) + Karate 1.4.1 + JUnit 5. Los tests se ejecutan a través de `maven-surefire-plugin` buscando clases `**/*Runner.java`. El reporte HTML se genera en `target/karate-reports/` al finalizar la suite.

Actualmente no existe ningún pipeline de CI: toda ejecución es manual desde el entorno local del desarrollador.

## Goals / Non-Goals

**Goals:**
- Ejecutar `./mvnw test` en cada `push` y `pull_request` sobre `main` usando un runner Ubuntu con Java 21.
- Publicar `target/karate-reports/` como artefacto descargable de GitHub Actions, incluso cuando los tests fallen.
- Cachear dependencias Maven (`~/.m2`) para reducir el tiempo de build en ejecuciones sucesivas.

**Non-Goals:**
- Modificar los tests existentes, la configuración de Karate o el `pom.xml`.
- Configurar ambientes adicionales (staging, producción) o múltiples versiones de Java.
- Integrar notificaciones externas (Slack, email, etc.).
- Paralelizar la ejecución de tests.

## Decisions

### 1. Distribución de Java: Temurin 21

**Decisión**: Usar `actions/setup-java@v4` con `distribution: temurin` y `java-version: '21'`.

**Rationale**: Temurin (Eclipse Adoptium) es la distribución OpenJDK más usada en GitHub Actions y está alineada con `maven.compiler.release=21` del `pom.xml`. La acción `setup-java@v4` soporta caché de Maven integrada con `cache: maven`, eliminando un paso separado de caché.

**Alternativa descartada**: `zulu` o `corretto` — funcionales pero sin ventaja sobre Temurin para este caso.

### 2. Caché de dependencias: integrada en `setup-java`

**Decisión**: Activar `cache: maven` dentro de `setup-java@v4` en lugar de usar `actions/cache` por separado.

**Rationale**: Reduce la configuración del workflow a un solo paso. La acción cachea `~/.m2/repository` usando el `pom.xml` como clave de caché automáticamente.

### 3. Permisos del Maven Wrapper

**Decisión**: Agregar un paso explícito `chmod +x mvnw` antes de ejecutar los tests.

**Rationale**: Git no garantiza que el bit de ejecución se preserve en todos los sistemas operativos. En runners Ubuntu de GitHub Actions, `mvnw` puede no tener permisos de ejecución si fue commiteado desde Windows, causando un error `Permission denied`.

**Alternativa descartada**: Ejecutar `mvn test` instalando Maven con una acción separada — añade complejidad y rompe el pin de versión del Maven Wrapper.

### 4. Subida de reporte: `if: always()`

**Decisión**: Usar `actions/upload-artifact@v4` con `if: always()` para subir `target/karate-reports/`.

**Rationale**: El valor del reporte es mayor cuando los tests fallan (diagnóstico de CI). Con `if: always()`, el artefacto se sube independientemente del resultado del paso de tests. Si el directorio no existe (build roto antes de los tests), `upload-artifact` simplemente no sube nada sin romper el workflow.

### 5. Trigger: `push` y `pull_request` sobre `main`

**Decisión**: Disparar el workflow en `push` a `main` y `pull_request` apuntando a `main`.

**Rationale**: Cubre el flujo estándar de trabajo: validar antes del merge (PR) y confirmar el estado después del merge (push). No se añaden triggers de `schedule` para evitar carga innecesaria sobre la API pública de Demoblaze.

## Risks / Trade-offs

- **Dependencia de API externa** → Los tests llaman a `api.demoblaze.com`, un servicio público que puede estar caído o con rate-limiting. Los tests pueden fallar de forma intermitente por causas ajenas al código. Mitigación: aceptar como limitación conocida; añadir `continue-on-error: false` para que los fallos sean visibles y no silenciados.

- **Nombres de usuario duplicados en CI** → Los escenarios de signup generan usernames con timestamp (`karate.now`). En runners efímeros de GitHub Actions el reloj es confiable, por lo que la probabilidad de colisión es mínima. Mitigación: la lógica existente ya maneja esto; no requiere cambio.

- **Reporte no generado si el build falla antes de los tests** → `target/karate-reports/` solo existe después de que Surefire ejecuta al menos un test. Si Maven falla en compilación, no habrá reporte que subir. Mitigación: `upload-artifact` con `if: always()` es tolerante a directorios inexistentes (no lanza error).

- **Caché invalidada frecuentemente** → La clave de caché depende del `pom.xml`. Cualquier cambio en dependencias invalida la caché y el primer build tras el cambio será más lento. Trade-off aceptable dado el tamaño reducido del proyecto.

## Migration Plan

1. Crear `.github/workflows/karate-tests.yml` con el contenido definido en las specs.
2. Hacer commit y push a `main` (o abrir un PR) para disparar el workflow por primera vez.
3. Verificar en la pestaña **Actions** de GitHub que el job pasa y que el artefacto `karate-reports` aparece en la sección de artefactos del run.
4. Si el workflow falla por permisos del wrapper, verificar que el paso `chmod +x mvnw` está presente.

**Rollback**: Eliminar o deshabilitar el archivo `.github/workflows/karate-tests.yml`. No hay efecto sobre el código de tests ni la configuración existente.

## Open Questions

- ¿Se requiere que el workflow falle el PR si los tests producen errores de red (API de Demoblaze no disponible)? Por ahora se asume que sí, sin retry automático.
- ¿Se desea retener los artefactos de reporte más de los 90 días por defecto de GitHub? Si es así, configurar `retention-days` en el paso de upload.
