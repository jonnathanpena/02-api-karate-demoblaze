## 1. Crear estructura del directorio

- [x] 1.1 Crear el directorio `.github/workflows/` en la raíz del repositorio

## 2. Crear el archivo de workflow

- [x] 2.1 Crear `.github/workflows/karate-tests.yml` con los triggers `push` y `pull_request` apuntando a `main`
- [x] 2.2 Definir el job `karate-tests` sobre `ubuntu-latest`
- [x] 2.3 Añadir el step `actions/checkout@v4` para clonar el repositorio
- [x] 2.4 Añadir el step `actions/setup-java@v4` con `distribution: temurin`, `java-version: '21'` y `cache: maven`
- [x] 2.5 Añadir el step `chmod +x mvnw` para garantizar permisos de ejecución del Maven Wrapper
- [x] 2.6 Añadir el step `./mvnw test` para ejecutar la suite completa de Karate
- [x] 2.7 Añadir el step `actions/upload-artifact@v4` con `name: karate-reports`, `path: target/karate-reports/` y `if: always()`

## 3. Verificar precondiciones del repositorio

- [x] 3.1 Confirmar que `mvnw` está commiteado en el repositorio (`git ls-files mvnw`)
- [x] 3.2 Verificar que el bit de ejecución de `mvnw` está preservado en Git (`git ls-files --eol mvnw`)

## 4. Integrar y validar en GitHub

- [ ] 4.1 Hacer commit del archivo `.github/workflows/karate-tests.yml` con un mensaje descriptivo
- [ ] 4.2 Hacer push a `main` o abrir un Pull Request apuntando a `main` para disparar el workflow
- [ ] 4.3 Verificar en la pestaña **Actions** de GitHub que el job `karate-tests` se ejecuta correctamente
- [ ] 4.4 Confirmar que el artefacto `karate-reports` aparece como descargable en el resumen del run
