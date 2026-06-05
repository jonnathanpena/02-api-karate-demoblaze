INSTRUCCIONES DE EJECUCION - API Karate (Demoblaze)
====================================================

REQUISITOS
----------
- Java 21+          (verificar: java -version)
- Maven Wrapper     (incluido: ./mvnw)
- Conexion a internet (prueba contra api.demoblaze.com)

VERSIONES CLAVE
---------------
- Karate DSL : 1.4.1
- JUnit      : 5.11.4
- Java target: 21

EJECUCION
---------
1. Clonar el repositorio y ubicarse en la raiz del proyecto.

2. Ejecutar todos los escenarios:
   ./mvnw test

3. Ejecutar solo escenarios @signup:
   ./mvnw test -Dkarate.options="--tags @signup"

4. Ejecutar solo escenarios @login:
   ./mvnw test -Dkarate.options="--tags @login"

5. Ejecutar solo escenarios positivos:
   ./mvnw test -Dkarate.options="--tags @positivo"

6. Ver reporte HTML:
   Abrir: target/karate-reports/karate-summary.html

ESTRUCTURA
----------
src/test/resources/
  karate-config.js          -> Configuracion global (URL base, timeouts)
  demoblaze/auth.feature    -> Los 4 escenarios de prueba

src/test/java/.../runners/
  DemoblazeRunner.java      -> Runner JUnit5
