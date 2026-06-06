[![Karate API Tests](https://github.com/jonnathanpena/02-api-karate-demoblaze/actions/workflows/karate-tests.yml/badge.svg?branch=main)](https://github.com/jonnathanpena/02-api-karate-demoblaze/actions/workflows/karate-tests.yml)

# API Karate – Demoblaze

## Descripción

Pruebas automatizadas de API REST para los endpoints de **signup** y **login** de [Demoblaze](https://api.demoblaze.com), desarrolladas con **Karate DSL** sobre JUnit 5.

Proyecto perteneciente al **Sofka QA Automation Challenge – Ejercicio 2**.

API bajo prueba: `https://api.demoblaze.com`

---

## Prerrequisitos

| Herramienta | Versión mínima | Verificación |
|---|---|---|
| Java | 21+ | `java -version` |
| Maven Wrapper | incluido (`./mvnw`) | `./mvnw --version` |
| Conexión a internet | — | acceso a `api.demoblaze.com` |

**Versiones clave de librerías:**

- Karate DSL: `1.4.1`
- JUnit: `5.11.4`
- Java target: `21`

---

## Ejecución

**Ejecutar toda la suite:**
```bash
./mvnw test
```

**Ejecutar solo escenarios `@signup`:**
```bash
./mvnw test -Dkarate.options="--tags @signup"
```

**Ejecutar solo escenarios `@login`:**
```bash
./mvnw test -Dkarate.options="--tags @login"
```

**Ejecutar solo escenarios positivos (`@positivo`):**
```bash
./mvnw test -Dkarate.options="--tags @positivo"
```

**Ver reporte HTML:**
```
target/karate-reports/karate-summary.html
```

---

## Estructura del proyecto

```
.
├── .github/
│   └── workflows/
│       └── karate-tests.yml          # Pipeline CI/CD (GitHub Actions)
├── src/
│   └── test/
│       ├── java/
│       │   └── .../runners/
│       │       └── DemoblazeRunner.java   # Runner JUnit 5
│       └── resources/
│           ├── karate-config.js          # Configuración global (URL base, timeouts)
│           └── demoblaze/
│               └── auth.feature          # Los 4 escenarios de prueba
├── pom.xml
└── README.md
```

---

## Inventario de escenarios de prueba

| # | Endpoint | Tipo | Tag | Status code esperado | Response body esperado |
|---|---|---|---|---|---|
| 1 | `/signup` | Positivo | `@signup @positivo` | `200` | `null` / vacío |
| 2 | `/signup` | Negativo | `@signup @negativo` | `200` | `{"errorMessage": "This user already exist."}` |
| 3 | `/login` | Positivo | `@login @positivo` | `200` | token de sesión (string) |
| 4 | `/login` | Negativo | `@login @negativo` | `200` | `{"errorMessage": "Wrong password."}` |

---

## Hallazgos del API

### 1. Status codes no semánticos
La API retorna **HTTP 200** tanto para éxito como para error, violando el principio REST de usar códigos HTTP semánticos. Los códigos esperados según REST serían:
- `409 Conflict` para usuario duplicado en signup.
- `401 Unauthorized` para credenciales inválidas en login.

### 2. Contrato de respuesta JSON
- **Signup exitoso:** body `null` o vacío, `Content-Type: application/json`.
- **Signup fallido:** `{"errorMessage": "This user already exist."}`, `Content-Type: application/json`.
- **Login exitoso:** token de sesión como string, `Content-Type: application/json`.
- **Login fallido (usuario inexistente):** `{"errorMessage": "User does not exist."}`.
- **Login fallido (password incorrecta):** `{"errorMessage": "Wrong password."}`.

### 3. Password en texto plano
La API recibe la contraseña sin cifrar en el body JSON. Riesgo de exposición en tráfico HTTP y logs. **Recomendación:** usar HTTPS (ya activo) más cifrado en el cliente.

### 4. Sin validación de entrada
El endpoint `/signup` no valida complejidad de contraseña ni formato de nombre de usuario. Cualquier string es aceptado sin restricción.
