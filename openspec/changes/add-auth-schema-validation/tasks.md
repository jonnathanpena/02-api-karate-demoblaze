## 1. Crear archivo de schema compartido

- [x] 1.1 Crear el directorio `src/test/resources/demoblaze/schemas/` si no existe
- [x] 1.2 Crear `src/test/resources/demoblaze/schemas/error-response-schema.json` con contenido `{ "errorMessage": "#string" }`

## 2. Agregar assertions de schema al escenario signup-success

- [x] 2.1 Localizar el escenario signup-success en `src/test/resources/demoblaze/auth.feature`
- [x] 2.2 Añadir `And match response == #null` después de los assertions existentes del escenario

## 3. Agregar assertions de schema al escenario signup-duplicate

- [x] 3.1 Localizar el escenario signup-duplicate en `auth.feature`
- [x] 3.2 Añadir `And match response == read('classpath:demoblaze/schemas/error-response-schema.json')` después de los assertions existentes del escenario

## 4. Agregar assertions de schema al escenario login-success

- [x] 4.1 Localizar el escenario login-success en `auth.feature`
- [x] 4.2 Añadir `And match response == #string` después de los assertions existentes del escenario

## 5. Agregar assertions de schema al escenario login-invalid

- [x] 5.1 Localizar el escenario login-invalid en `auth.feature`
- [x] 5.2 Añadir `And match response == read('classpath:demoblaze/schemas/error-response-schema.json')` después de los assertions existentes del escenario

## 6. Verificar que todos los escenarios pasan

- [x] 6.1 Ejecutar `./mvnw test` y confirmar que los 4 escenarios reportan PASS
- [x] 6.2 Verificar que el reporte HTML se genera en `target/karate-reports/karate-summary.html`
