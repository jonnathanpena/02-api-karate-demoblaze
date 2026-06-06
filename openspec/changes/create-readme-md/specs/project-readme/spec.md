## ADDED Requirements

### Requirement: README.md file exists at project root
The project SHALL contain a `README.md` file located at the repository root. The file SHALL be written in standard GitHub-flavored Markdown so that it renders automatically on GitHub and GitLab.

#### Scenario: File is present and rendered on the platform
- **WHEN** a reviewer navigates to the repository root on GitHub
- **THEN** `README.md` is automatically rendered as formatted HTML

### Requirement: CI/CD status badge
The `README.md` SHALL include a GitHub Actions badge at the top of the document that reflects the current build status of the `karate-tests.yml` workflow on the `main` branch.

#### Scenario: Badge links to the correct workflow
- **WHEN** a reviewer reads the README header
- **THEN** a badge labelled "Karate API Tests" is visible and links to the GitHub Actions workflow for the `main` branch

### Requirement: Project overview section
The `README.md` SHALL contain a section that describes the project purpose, its origin (Sofka QA Automation Challenge – Exercise 2), and the API under test (`https://api.demoblaze.com`).

#### Scenario: Purpose is clearly stated
- **WHEN** a new team member reads the README
- **THEN** they can identify the project as REST API tests for Demoblaze signup and login endpoints using Karate DSL

### Requirement: Prerequisites section
The `README.md` SHALL document all prerequisites required to run the test suite: Java 21+, Maven Wrapper (included), and an active internet connection to reach `api.demoblaze.com`. It SHALL also list the key library versions (Karate DSL 1.4.1, JUnit 5).

#### Scenario: Prerequisites are complete and actionable
- **WHEN** a developer sets up the project from scratch
- **THEN** the prerequisites section lists every dependency needed before executing any test command

### Requirement: Execution commands section
The `README.md` SHALL provide copy-pastable shell commands for: running the full test suite, filtering by `@signup`, filtering by `@login`, filtering by `@positivo`, and opening the HTML report.

#### Scenario: Full suite command is present
- **WHEN** a developer reads the execution section
- **THEN** the command `./mvnw test` is shown as the command to run all scenarios

#### Scenario: Tag-filtered commands are present
- **WHEN** a developer reads the execution section
- **THEN** commands using `-Dkarate.options="--tags @<tag>"` are shown for `@signup`, `@login`, and `@positivo`

#### Scenario: HTML report path is indicated
- **WHEN** a developer reads the execution section
- **THEN** the path `target/karate-reports/karate-summary.html` is listed as the location of the generated report

### Requirement: Project structure section
The `README.md` SHALL include a directory tree or table describing the key source files: `src/test/resources/karate-config.js`, `src/test/resources/demoblaze/auth.feature`, the JUnit5 runner class, and `.github/workflows/karate-tests.yml`.

#### Scenario: Structure diagram covers all key files
- **WHEN** a reviewer reads the project structure section
- **THEN** every critical file path is mentioned with a brief description of its purpose

### Requirement: Test scenarios inventory
The `README.md` SHALL contain a summary table or list of all 4 implemented test scenarios, identifying each by endpoint, type (positive/negative), tag, expected status code, and expected response body.

#### Scenario: All four scenarios are listed
- **WHEN** a reviewer reads the scenarios section
- **THEN** the following four scenarios are documented: signup (new user), signup (duplicate user), login (correct credentials), and login (wrong credentials)

#### Scenario: Expected response contract is shown per scenario
- **WHEN** a reviewer reads a scenario entry
- **THEN** the expected HTTP status code (200 for all) and the expected response body are specified for that scenario

### Requirement: API findings section
The `README.md` SHALL include a section documenting the API quality findings discovered during testing: non-semantic HTTP status codes, JSON response contracts, plain-text password transmission, and absence of input validation.

#### Scenario: Non-semantic status code finding is documented
- **WHEN** a reviewer reads the API findings section
- **THEN** it is noted that the API returns HTTP 200 for both success and error cases, violating REST semantics

#### Scenario: Security finding is documented
- **WHEN** a reviewer reads the API findings section
- **THEN** it is noted that passwords are transmitted in plain text in the request body, with a recommendation to add client-side encryption
