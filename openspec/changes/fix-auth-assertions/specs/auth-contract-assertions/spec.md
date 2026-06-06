## ADDED Requirements

### Requirement: Signup duplicate user returns error object
El endpoint `/signup` SHALL retornar el errorMessage `"This user already exist."` cuando se
intenta registrar un usuario que ya existe. La aserción MUST tolerar tanto una respuesta
`application/json` (objeto JSON) como `text/plain` (string crudo) usando `karate.fromString`
para parsear el body en ambos casos, o bien un match directo al objeto JSON si el
`Content-Type` es `application/json`.

#### Scenario: Signup con usuario duplicado retorna errorMessage correcto
- **WHEN** se hace POST a `/signup` con un username que ya existe en el sistema
- **THEN** el status code es 200
- **THEN** el body parseado contiene `errorMessage` igual a `"This user already exist."`

#### Scenario: Signup con usuario duplicado no retorna campo inesperado
- **WHEN** se hace POST a `/signup` con un username duplicado
- **THEN** la respuesta no contiene un campo distinto a `errorMessage`

### Requirement: Login con credenciales inválidas retorna errorMessage
El endpoint `/login` SHALL retornar el objeto `{"errorMessage": "Wrong password."}` cuando las
credenciales proporcionadas son incorrectas. La aserción MUST hacer match al campo `errorMessage`
con el valor `"Wrong password."`, usando `karate.fromString` si el `Content-Type` es `text/plain`,
alignada con la estrategia del escenario `@signup @negativo`.

#### Scenario: Login con password incorrecto retorna errorMessage correcto
- **WHEN** se hace POST a `/login` con un username válido y un password incorrecto
- **THEN** el status code es 200
- **THEN** el body parseado contiene `errorMessage` igual a `"Wrong password."`

#### Scenario: Login con credenciales inválidas no expone token de sesión
- **WHEN** se hace POST a `/login` con credenciales inválidas
- **THEN** el body no contiene ningún token ni campo de sesión
