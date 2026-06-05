## Why

`DemoblazeRunner` uses `@Test void` (plain JUnit 5) without asserting the Karate result count, so any failing Karate scenario is silently swallowed — the Maven build stays green even when API contract validations break. Additionally, `.relativeTo(getClass())` is applied alongside an explicit `classpath:` prefix, which can conflict with classpath-root path resolution.

## What Changes

- Replace `@Test void testAuthFlow()` with the `@Karate.Test Karate` pattern so JUnit 5 receives individual scenario results and reports failures correctly.
- Remove `.relativeTo(getClass())` — it is only meaningful for package-relative paths, not for explicit `classpath:` paths.
- Retain `.outputCucumberJson(true)` for Cucumber report generation.

## Capabilities

### New Capabilities
- `runner-junit5-integration`: Correct JUnit 5 runner wiring for Karate so that scenario-level PASS/FAIL results are surfaced as JUnit test outcomes and `./mvnw test` exits non-zero on any API contract failure.

### Modified Capabilities

## Impact

- `src/test/java/com/sofka/qa/demoblaze/runners/DemoblazeRunner.java` — sole change.
- No changes to feature files, `karate-config.js`, or `pom.xml`.
- `./mvnw test` will now fail the build when any of the 4 scenarios fail, matching the acceptance criterion that each scenario reports PASS/FAIL with evidence.
