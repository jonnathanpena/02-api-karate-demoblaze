## ADDED Requirements

### Requirement: Workflow trigger on push and pull_request to main
The CI workflow file (`.github/workflows/karate-tests.yml`) SHALL be triggered automatically on `push` events and `pull_request` events targeting the `main` branch.

#### Scenario: Push to main triggers the workflow
- **WHEN** a commit is pushed to the `main` branch
- **THEN** the GitHub Actions workflow runs automatically

#### Scenario: Pull request targeting main triggers the workflow
- **WHEN** a pull request is opened or updated with `main` as the base branch
- **THEN** the GitHub Actions workflow runs automatically

### Requirement: Java 21 environment using Temurin distribution
The workflow SHALL configure the runner with Java 21 using `actions/setup-java@v4` with `distribution: temurin` and `java-version: '21'`. Maven dependency caching SHALL be enabled via `cache: maven` in the same step.

#### Scenario: Java 21 is available during test execution
- **WHEN** the workflow job starts on `ubuntu-latest`
- **THEN** Java 21 (Temurin) is set up and available on the runner's PATH

#### Scenario: Maven cache is restored when pom.xml is unchanged
- **WHEN** the workflow runs and `~/.m2/repository` was cached from a previous run with the same `pom.xml`
- **THEN** the cache is restored, reducing dependency download time

### Requirement: Maven Wrapper executable permission
The workflow SHALL include a step to run `chmod +x mvnw` before executing any Maven command to ensure the wrapper script is executable on the Ubuntu runner regardless of how it was committed.

#### Scenario: chmod step runs before mvnw invocation
- **WHEN** the workflow reaches the test execution phase
- **THEN** `mvnw` has executable permissions set and can be invoked directly

### Requirement: Test suite execution via Maven Wrapper
The workflow SHALL execute the full Karate test suite by running `./mvnw test`. All 4 scenarios (signup success, signup duplicate, login success, login wrong credentials) MUST be executed. The step SHALL fail the workflow job if any test fails.

#### Scenario: All tests pass
- **WHEN** `./mvnw test` runs and all 4 Karate scenarios pass
- **THEN** the workflow step exits with code 0 and the job continues

#### Scenario: A test failure fails the job
- **WHEN** `./mvnw test` runs and at least one Karate scenario fails
- **THEN** the workflow step exits with a non-zero code and the job is marked as failed

### Requirement: Karate report uploaded as GitHub Actions artifact
The workflow SHALL upload the directory `target/karate-reports/` as a GitHub Actions artifact named `karate-reports` using `actions/upload-artifact@v4` with the condition `if: always()`, so the report is available whether the test step passed or failed.

#### Scenario: Report artifact uploaded after passing tests
- **WHEN** `./mvnw test` completes successfully and `target/karate-reports/` exists
- **THEN** the artifact `karate-reports` is available for download from the GitHub Actions run summary

#### Scenario: Report artifact uploaded after failing tests
- **WHEN** `./mvnw test` exits with a failure and `target/karate-reports/` exists
- **THEN** the artifact `karate-reports` is still uploaded and available for download

#### Scenario: Upload step does not fail when report directory is absent
- **WHEN** Maven fails during compilation before any test is executed and `target/karate-reports/` does not exist
- **THEN** the upload step completes without error and no artifact is attached
