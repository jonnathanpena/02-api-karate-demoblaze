## Why

Los tests de Karate DSL contra los endpoints de autenticación de Demoblaze se ejecutan únicamente en local. Se requiere un pipeline de CI que ejecute automáticamente la suite completa en cada push/PR y publique el reporte HTML como evidencia descargable.

## What Changes

- Agregar `.github/workflows/karate-tests.yml` — workflow de GitHub Actions que ejecuta `./mvnw test` sobre la suite Karate en un runner Ubuntu con Java 21.
- Publicar los artefactos del reporte Karate (`target/karate-reports/`) al final de cada ejecución del workflow.
- El workflow se dispara en `push` y `pull_request` sobre la rama `main`.

## Capabilities

### New Capabilities

- `github-actions-ci-workflow`: Workflow de GitHub Actions (YAML) que compila, ejecuta los tests Karate con Maven y sube el reporte HTML como artefacto de GitHub.

### Modified Capabilities

## Impact

- Nuevo archivo: `.github/workflows/karate-tests.yml`.
- No se modifica código de tests ni configuración de Maven/Karate existente.
- Requiere que el repositorio esté alojado en GitHub con Actions habilitado.
- Java 21 y Maven Wrapper (`./mvnw`) deben funcionar en `ubuntu-latest`.
