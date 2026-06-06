## Context

`auth.feature` contiene dos escenarios negativos cuyas aserciones no coinciden con las
respuestas reales de la API de Demoblaze:

| Escenario | Aserción actual | Respuesta real observada |
|---|---|---|
| `@signup @negativo` | `match response.errorMessage == 'This user already exist.'` | String crudo `{"errorMessage": "This user already exist."}` |
| `@login @negativo` | `match response.errorMessage == 'User does not exist.'` | Objeto JSON `{"errorMessage": "Wrong password."}` |

Karate DSL parsea el `Content-Type` de la respuesta para decidir si trata el body como JSON o
como string. Si la API devuelve `Content-Type: text/plain` (o similar), Karate expone `response`
como `String`, no como `Map`, y `response.errorMessage` produce `null`/error en lugar del valor
esperado. Para el caso de login fallido la API devuelve `{"errorMessage": "Wrong password."}` con `Content-Type` que puede ser `text/plain` (string crudo) o `application/json`; en ambos casos se aplica la misma estrategia de parseo que para el signup negativo.

## Goals / Non-Goals

**Goals:**
- Reemplazar las dos aserciones incorrectas por matches fieles al contrato real observado.
- Actualizar `conclusiones.txt` con los hallazgos precisos.
- Que los 4 escenarios pasen (`PASS`) en la siguiente ejecución de Maven.

**Non-Goals:**
- No modificar la lógica de los escenarios positivos.
- No agregar escenarios nuevos.
- No cambiar dependencias, runner ni configuración de Karate.
- No corregir comportamientos incorrectos en la API (eso queda como hallazgo documentado).

## Decisions

### Decisión 1 — Estrategia de match para `@signup @negativo`

**Opción A** (elegida): Usar `match response == {"errorMessage": "This user already exist."}`
si Karate parsea la respuesta como JSON.  
**Opción B**: Si `Content-Type` es `text/plain`, el response llega como `String`; en ese caso
usar `match response contains 'This user already exist.'` o parsear con
`def parsed = karate.fromString(response)` y luego `match parsed.errorMessage == '...'`.

Se elige **primero verificar** el `Content-Type` real del endpoint. Si la API envía
`application/json` → Opción A. Si envía `text/plain` → Opción B con parseo explícito.
La implementación debe elegir el mínimo cambio que produzca PASS de forma robusta.

### Decisión 2 — Match para `@login @negativo`

La respuesta real observada es `{"errorMessage": "Wrong password."}`. La aserción correcta es:
```
* match response == {errorMessage: 'Wrong password.'}
```
Si el `Content-Type` es `text/plain`, se usa `karate.fromString(response)` antes del match,
alineando la estrategia con la Decisión 1.

### Decisión 3 — Actualización de `conclusiones.txt`

Se corrige el punto 2 de la sección `HALLAZGOS DEL API` para reflejar la respuesta real
de cada escenario y se añade una nota sobre el hallazgo de la inconsistencia detectada en
la documentación previa (que indicaba strings planos cuando la realidad difiere).

## Risks / Trade-offs

- **[Riesgo] La API puede cambiar su comportamiento entre ejecuciones** →
  Los escenarios deben ejecutarse contra el entorno real antes de considerar el fix
  como definitivo. Los mocks no aplican aquí (suite apunta a producción).
- **[Riesgo] Content-Type no consistente** → Si en alguna ejecución la API devuelve
  `application/json` y en otra `text/plain`, la aserción puede ser frágil.
  Mitigación: usar `match response contains` o `karate.fromString` para tolerar ambos.
- **[Trade-off] Simplicidad vs. robustez** → Se prefiere el match más directo posible
  para mantener la feature legible; se acepta que si la API cambia el contrato se
  deberá revisar nuevamente.
