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
| Node.js | 18+ | `node -v` — requerido para Husky (git hooks) |
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

## Git Hooks – Husky (pre-push)

El proyecto usa **[Husky 9](https://typicode.github.io/husky/)** para instalar un hook `pre-push` que ejecuta la suite completa de Karate **antes de cada `git push`**. Esto impide subir al repositorio remoto código que rompa los tests existentes.

### ¿Qué hace el hook?

```sh
# .husky/pre-push
./mvnw test
```

Antes de completar cualquier `git push`, Git ejecuta `./mvnw test`. Si algún escenario Karate falla, el push se **cancela automáticamente** y se muestra el reporte de error en la terminal.

### Setup inicial (una sola vez por clon)

> **Requisito:** Node.js ≥ 18 instalado (`node -v`).

```bash
npm install
```

El script `prepare` de `package.json` ejecuta `husky` automáticamente, configurando `core.hooksPath = .husky/_` y generando los stubs de todos los hooks de Git.

### Verificar que el hook está activo

```bash
git config core.hooksPath
# Salida esperada: .husky/_
```

Husky 9 configura Git con `core.hooksPath = .husky/_` en lugar de copiar archivos a `.git/hooks/`. Los stubs en `.husky/_/` delegan automáticamente a los scripts en `.husky/` (ej: `.husky/pre-push`).

### Omitir el hook puntualmente (no recomendado)

```bash
git push --no-verify
```

> ⚠️ Usar `--no-verify` solo en casos excepcionales (ej: push de documentación pura). **Nunca** para saltarse tests que fallan.

---

## Estructura del proyecto

```
.
├── .github/
│   └── workflows/
│       └── karate-tests.yml          # Pipeline CI/CD (GitHub Actions)
├── .husky/
│   └── pre-push                      # Hook: ejecuta ./mvnw test antes de cada push
├── src/
│   └── test/
│       ├── java/
│       │   └── .../runners/
│       │       └── DemoblazeRunner.java   # Runner JUnit 5
│       └── resources/
│           ├── karate-config.js          # Configuración global (URL base, timeouts)
│           └── demoblaze/
│               ├── auth.feature          # 3 Scenarios + 1 Scenario Outline (7 ejecuciones)
│               ├── data/
│               │   └── invalid-login-credentials.csv  # Datos CSV para login negativo
│               └── schemas/
│                   ├── error-response-schema.json     # Schema respuestas de error
│                   └── login-token-schema.json        # Schema token de login exitoso
├── package.json                      # Husky como devDependency
├── pom.xml
└── README.md
```

---

## Inventario de escenarios de prueba

| # | Endpoint | Tipo | Tag | Status code esperado | Response body esperado |
|---|---|---|---|---|---|
| 1 | `/signup` | Positivo | `@signup @positivo` | `200` | `null` / vacío / whitespace (`##string`) |
| 2 | `/signup` | Negativo | `@signup @negativo` | `200` | `{"errorMessage": "This user already exist."}` |
| 3 | `/login` | Positivo | `@login @positivo` | `200` | token `Auth_token: <base64>` (schema + format check) |
| 4a | `/login` | Negativo | `@login @negativo` | `200` | `{"errorMessage": "User does not exist."}` |
| 4b | `/login` | Negativo | `@login @negativo` | `200` | `{"errorMessage": "Wrong password."}` |
| 4c | `/login` | Negativo | `@login @negativo` | `200` | `{"errorMessage": "User does not exist."}` |
| 4d | `/login` | Negativo | `@login @negativo` | `200` | `{"errorMessage": "Wrong password."}` |

> Escenarios 4a–4d son filas del `Scenario Outline` parametrizado desde `invalid-login-credentials.csv`.
> **Total:** 7 escenarios ejecutados (`Tests run: 7, Failures: 0`).

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

### 5. Sin validación de payload vacío
`/signup` acepta `username: ""` y `password: ""` devolviendo `200 OK` sin mensaje de error, lo que permite registrar credenciales vacías en la base de datos.

### 6. HTTP 500 en `/login` con username vacío
`/login` con `{"username": "", "password": "cualquiera"}` devuelve **HTTP 500 Internal Server Error** en lugar de `200` + mensaje de error. El backend no valida la entrada antes de procesarla, causando un crash del servidor. Severidad: **alta** — exploitable para DoS o leakage de stack traces.

---

## Decisiones de diseño técnico

| Decisión | Justificación |
|---|---|
| **Username dinámico con `timestamp()`** | `java.lang.System.currentTimeMillis()` en el `Background` garantiza un usuario único por ejecución, eliminando colisiones en runs paralelos o consecutivos de CI |
| **`##string` en signup positivo** | El matcher opcional `##string` (null-o-string) es el correcto para un body que puede ser `null`, vacío o whitespace — el API retorna `\n` en signup exitoso |
| **`Scenario Outline` + CSV para login negativo** | Reemplaza el escenario único hardcodeado por 4 filas parametrizadas desde `invalid-login-credentials.csv`; añadir nuevos casos no requiere tocar el feature file |
| **Schema file `login-token-schema.json` + `isValidToken`** | El schema valida que la respuesta sea un string; la función JS valida el prefijo `Auth_token:` — separación de responsabilidades tipo/formato |
| **`standard_test_user` fijo para signup duplicado** | Usuario predefinido y permanente que garantiza reproducibilidad del escenario negativo sin dependencias entre tests |
| **`karate-config.js` con soporte multi-entorno** | Permite apuntar a `dev`, `staging` u otras URLs vía `-Dkarate.env=staging` sin modificar un solo feature file |
| **Tags combinados (`@signup @positivo`)** | Ejecución granular por endpoint O por tipo de prueba; un pipeline CI puede correr solo `@positivo` (smoke) en < 30 s |
| **`logPrettyRequest/Response: true`** | Logging estructurado de request y response en cada step; debugging sin instrumentación adicional ni herramientas externas |
| **`ssl: true` en configuración** | Fuerza validación del certificado TLS; cualquier downgrade a HTTP plano fallaría en el handshake, detectando configuraciones inseguras |
| **`connectTimeout: 10 000 ms` / `readTimeout: 15 000 ms`** | Valores conservadores para una API pública de demo; detectan degradación sin falsos positivos por latencia de red |

---

## Arquitectura del runner

Karate 1.4.x con JUnit 5 requiere el patrón `@Karate.Test Karate` (tipo de retorno + anotación) para que los fallos internos de Karate se propaguen como fallos JUnit y el pipeline CI falle correctamente:

```java
// ✅ Patrón correcto — fallos de Karate se propagan a JUnit
@Karate.Test
Karate testAuthFlow() {
    return Karate.run("classpath:demoblaze/auth.feature")
        .relativeTo(getClass())
        .outputCucumberJson(true);
}
```

Sin el tipo de retorno `Karate` y `@Karate.Test`, un `@Test void` construye el builder pero **nunca lo ejecuta**: JUnit no recibe excepción → `BUILD SUCCESS` aunque existan fallos internos de Karate. Verificar siempre el reporte en `target/karate-reports/karate-summary.html` tras cada ejecución.

---

## CI/CD – GitHub Actions

Pipeline configurado en `.github/workflows/karate-tests.yml`:

| Parámetro | Valor |
|---|---|
| **Trigger** | `push` y `pull_request` a `main` |
| **Runner** | `ubuntu-latest` |
| **Java** | `21` (distribution `temurin`) |
| **Comando** | `./mvnw test` |
| **Artefacto** | Reporte HTML de Karate (`target/karate-reports/`) publicado como artifact descargable por 30 días |
| **Fallo de pipeline** | Automático si algún escenario Karate falla (propagado vía `@Karate.Test`) |

Estado actual del pipeline visible en el badge al inicio de este documento.
