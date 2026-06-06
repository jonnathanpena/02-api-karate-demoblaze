## 1. Preparación de contenido

- [x] 1.1 Revisar `readme.txt` y extraer secciones: prerrequisitos, versiones clave y comandos de ejecución
- [x] 1.2 Revisar `conclusiones.txt` y extraer: inventario de escenarios de prueba y hallazgos de la API

## 2. Crear README.md

- [x] 2.1 Crear el archivo `README.md` en la raíz del repositorio
- [x] 2.2 Agregar badge de GitHub Actions (CI/CD) con placeholder `YOUR_GITHUB_USERNAME/YOUR_REPO_NAME`
- [x] 2.3 Agregar sección de descripción del proyecto (propósito, origen Sofka QA Automation Challenge – Ejercicio 2, y API bajo prueba)
- [x] 2.4 Agregar sección de prerrequisitos (Java 21+, Maven Wrapper incluido, conexión a internet, versiones Karate DSL 1.4.1 y JUnit 5)
- [x] 2.5 Agregar sección de comandos de ejecución con bloques de código copiables: suite completa, filtros por `@signup`, `@login`, `@positivo`, y ruta del reporte HTML
- [x] 2.6 Agregar sección de estructura del proyecto con árbol de directorios que incluya los archivos clave (`karate-config.js`, `auth.feature`, runner JUnit 5, `karate-tests.yml`)
- [x] 2.7 Agregar tabla de inventario de los 4 escenarios de prueba (endpoint, tipo, tag, status code esperado, response body esperado)
- [x] 2.8 Agregar sección de hallazgos de la API (status codes no semánticos, contrato de respuesta JSON, contraseñas en texto plano, ausencia de validación de entrada)

## 3. Verificación

- [x] 3.1 Confirmar que `README.md` existe en la raíz del repositorio y se renderiza correctamente en Markdown
- [x] 3.2 Verificar que el badge referencia el workflow `karate-tests.yml` en la rama `main`
- [x] 3.3 Verificar que los cuatro escenarios están completos en la tabla de inventario
- [x] 3.4 Confirmar que `readme.txt` y `conclusiones.txt` no fueron modificados
