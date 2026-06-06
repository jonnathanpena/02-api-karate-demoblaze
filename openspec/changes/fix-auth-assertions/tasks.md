## 1. Diagnóstico

- [x] 1.1 Leer `src/test/resources/demoblaze/auth.feature` e identificar las líneas exactas de las aserciones incorrectas en `@signup @negativo` y `@login @negativo`
- [x] 1.2 Ejecutar `./mvnw test` y registrar los mensajes de fallo para confirmar el `Content-Type` real y el body devuelto por cada endpoint negativo

## 2. Fix: Escenario @signup @negativo

- [x] 2.1 Agregar `* def parsed = karate.fromString(response)` (o usar match directo al objeto JSON si el `Content-Type` es `application/json`) antes de la aserción de error en el escenario `@signup @negativo`
- [x] 2.2 Reemplazar `match response.errorMessage == 'This user already exist.'` por `match parsed.errorMessage == 'This user already exist.'` (o el equivalente robusto confirmado en 1.2)

## 3. Fix: Escenario @login @negativo

- [x] 3.1 Agregar `* def parsed = karate.fromString(response)` antes de la aserción en el escenario `@login @negativo`, alineando la estrategia con el escenario `@signup @negativo`
- [x] 3.2 Reemplazar la aserción existente por `match parsed.errorMessage == 'Wrong password.'`

## 4. Documentación

- [x] 4.1 Actualizar `conclusiones.txt`: corregir el punto 2 de la sección `HALLAZGOS DEL API` para reflejar el contrato real de cada escenario negativo (`errorMessage` exacto y `Content-Type` observado)
- [x] 4.2 Añadir una nota en `conclusiones.txt` sobre la inconsistencia detectada entre la documentación previa y el comportamiento real de la API (string crudo vs. objeto JSON)

## 5. Verificación

- [x] 5.1 Ejecutar `./mvnw test` y confirmar que los 4 escenarios (`@signup @positivo`, `@signup @negativo`, `@login @positivo`, `@login @negativo`) reportan PASS
- [x] 5.2 Verificar que el reporte HTML se genera correctamente en `target/karate-reports/karate-summary.html`
