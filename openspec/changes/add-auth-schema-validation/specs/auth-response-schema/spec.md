## ADDED Requirements

### Requirement: Error response schema contract file
A file `src/test/resources/demoblaze/schemas/error-response-schema.json` SHALL exist containing a Karate-native schema that defines the error response contract as `{ "errorMessage": "#string" }`. This file SHALL be referenced from any scenario that expects an error response object, using the classpath prefix `classpath:demoblaze/schemas/error-response-schema.json`.

#### Scenario: Schema file is loadable via Karate classpath
- **WHEN** a Karate scenario calls `read('classpath:demoblaze/schemas/error-response-schema.json')`
- **THEN** the file loads without error and resolves to `{ "errorMessage": "#string" }`

### Requirement: Signup success response schema assertion
The signup-success scenario in `auth.feature` SHALL include an inline schema assertion verifying that the response body is null. This assertion MUST be placed after all existing assertions in the scenario.

#### Scenario: Signup success body matches null schema
- **WHEN** the signup-success scenario completes with HTTP 200
- **THEN** `match response == #null` MUST pass

### Requirement: Signup duplicate response schema assertion
The signup-duplicate scenario in `auth.feature` SHALL include a schema assertion verifying that the response body matches the shared error response schema. This assertion MUST be placed after all existing assertions in the scenario.

#### Scenario: Signup duplicate body matches error schema
- **WHEN** the signup-duplicate scenario completes with the duplicate-user error response
- **THEN** `match response == read('classpath:demoblaze/schemas/error-response-schema.json')` MUST pass

### Requirement: Login success response schema assertion
The login-success scenario in `auth.feature` SHALL include an inline schema assertion verifying that the response body is a non-null string (the session token). This assertion MUST be placed after all existing assertions in the scenario.

#### Scenario: Login success body matches string schema
- **WHEN** the login-success scenario completes with HTTP 200 and a session token in the body
- **THEN** `match response == #string` MUST pass

### Requirement: Login invalid response schema assertion
The login-invalid scenario in `auth.feature` SHALL include a schema assertion verifying that the response body matches the shared error response schema. This assertion MUST be placed after all existing assertions in the scenario.

#### Scenario: Login invalid body matches error schema
- **WHEN** the login-invalid scenario completes with the invalid-credentials error response
- **THEN** `match response == read('classpath:demoblaze/schemas/error-response-schema.json')` MUST pass
