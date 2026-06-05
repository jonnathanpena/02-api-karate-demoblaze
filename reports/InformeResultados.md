# Informe de Resultados - Pruebas API Karate (Demoblaze)

**Fecha:** 2026-06-05  
**Proyecto:** API Karate - Demoblaze Auth  
**Versión:** 1.0.0

---

## Resumen Ejecutivo

Se ejecutaron pruebas automatizadas de API REST utilizando Karate DSL sobre los endpoints de autenticación de Demoblaze (Signup y Login). Se implementaron 4 escenarios de prueba cubriendo casos positivos y negativos para validar el comportamiento de la API.

---

## Métricas de Ejecución

| Métrica | Valor |
|---------|-------|
| **Total de Escenarios** | 4 |
| **Escenarios Exitosos** | 4 |
| **Escenarios Fallidos** | 0 |
| **Tasa de Éxito** | 100% |
| **Tiempo de Ejecución** | ~2 segundos |
| **Framework** | Karate DSL 1.4.1 + JUnit 5 |

---

## Escenarios de Prueba

### 1. SIGNUP - Crear Usuario Nuevo (Positivo)
- **Tag:** @signup @positivo
- **Endpoint:** POST /signup
- **Resultado:** ✅ PASSED
- **Estado HTTP:** 200
- **Validación:** Usuario creado exitosamente (body null/vacio)

### 2. SIGNUP - Usuario Duplicado (Negativo)
- **Tag:** @signup @negativo
- **Endpoint:** POST /signup
- **Resultado:** ✅ PASSED
- **Estado HTTP:** 200
- **Validación:** Retorna mensaje "This user already exist."

### 3. LOGIN - Credenciales Correctas (Positivo)
- **Tag:** @login @positivo
- **Endpoint:** POST /login
- **Resultado:** ✅ PASSED
- **Estado HTTP:** 200
- **Validación:** Retorna token de sesión (string no nulo)

### 4. LOGIN - Credenciales Incorrectas (Negativo)
- **Tag:** @login @negativo
- **Endpoint:** POST /login
- **Resultado:** ✅ PASSED
- **Estado HTTP:** 200
- **Validación:** Retorna mensaje "Wrong password."

---

## Hallazgos del API

### 1. Status Code No Semántico
La API de Demoblaze retorna HTTP 200 tanto para éxito como para error. Esto viola el principio REST de usar códigos HTTP semánticos (debería retornar 409 Conflict para usuario duplicado, 401 para credenciales inválidas). Es un hallazgo de calidad de API importante.

### 2. Body de Respuesta Inconsistente
- **Signup exitoso:** body null o vacío (no hay confirmación)
- **Signup fallido:** body = string plano "This user already exist."
- **Login exitoso:** body = token de sesión (string)
- **Login fallido:** body = string plano "Wrong password."

Sin estructura JSON consistente. Dificulta la automatización robusta.

### 3. Password en Texto Plano
La API recibe la password sin encriptar en el body JSON. Riesgo de seguridad: passwords expuestas en tráfico HTTP/logs. **RECOMENDACIÓN:** usar HTTPS (ya implementado) + cifrado en cliente.

### 4. Sin Validación de Complejidad
El endpoint signup no valida complejidad de password ni formato de username. Cualquier string es aceptado.

### 5. Karate DSL - Valoración
Karate demostró ser ideal para pruebas de API: sintaxis expresiva, soporte nativo de JSON/XML, no requiere código Java adicional para los assertions, y genera reporte HTML automáticamente.

---

## Recomendaciones

- Agregar validación de schema JSON con `match schema` para cada respuesta
- Parametrizar datos de prueba con un archivo CSV o tabla de ejemplos
- Integrar en CI/CD para ejecución en cada merge
- Reportar al equipo de desarrollo los hallazgos 1, 2, 3 como bugs/mejoras

---

## Evidencias

- **Reporte HTML Karate:** `target/karate-reports/karate-summary.html`
- **Feature File:** `src/test/resources/demoblaze/auth.feature`
- **Runner JUnit:** `src/test/java/com/sofka/qa/demoblaze/runners/DemoblazeRunner.java`

---

**Preparado por:** QA Automation Team  
**Tecnología:** Karate DSL + Maven + Java 21
