## ADDED Requirements

### Requirement: Runner method uses @Karate.Test annotation
`DemoblazeRunner` SHALL declare the test method with the `@Karate.Test` annotation and a `Karate` return type so that JUnit 5 registers each Karate scenario as a distinct dynamic test and receives individual PASS/FAIL outcomes via the JUnit 5 lifecycle.

#### Scenario: Build fails when a scenario fails
- **WHEN** any Karate scenario in `auth.feature` produces a failure
- **THEN** `./mvnw test` exits with a non-zero code and Maven Surefire reports the scenario as a failed test

#### Scenario: Build succeeds when all scenarios pass
- **WHEN** all Karate scenarios in `auth.feature` pass
- **THEN** `./mvnw test` exits with code 0 and all dynamic tests are reported as PASS

### Requirement: Feature path uses absolute classpath reference without relativeTo
`DemoblazeRunner` SHALL resolve feature files using the `classpath:` prefix directly in `Karate.run(...)` and SHALL NOT chain `.relativeTo(getClass())`, which would incorrectly re-resolve the path relative to the runner's package directory.

#### Scenario: Feature file resolves from classpath root
- **WHEN** the runner calls `Karate.run("classpath:demoblaze/auth.feature")`
- **THEN** Karate resolves the feature file from the classpath root without path resolution errors

#### Scenario: Removing relativeTo does not break feature discovery
- **WHEN** `.relativeTo(getClass())` is absent and the path starts with `classpath:`
- **THEN** Karate locates `demoblaze/auth.feature` on the test classpath and all four scenarios are discovered

### Requirement: Cucumber JSON output is retained
`DemoblazeRunner` SHALL chain `.outputCucumberJson(true)` on the `Karate` builder so that a Cucumber-compatible JSON report is generated in `target/karate-reports/` after each test run.

#### Scenario: Cucumber JSON report is generated after execution
- **WHEN** the test suite completes execution (pass or fail)
- **THEN** a Cucumber JSON report file is present under `target/karate-reports/`
