## Context

`DemoblazeRunner` is the sole JUnit 5 entry point for the Karate suite. In its current form the method is annotated `@Test void`, so JUnit 5 treats the whole suite as a single, always-passing test — the return value of `Karate.run(...)` is discarded and individual scenario results never reach the JUnit lifecycle. As a consequence `./mvnw test` exits zero even when all four API scenarios fail.

A secondary issue is the chained call `.relativeTo(getClass())`: that helper resolves a path relative to the class's package directory on the classpath; using it together with an explicit `classpath:` prefix is redundant and can produce unexpected path resolution depending on the Karate version.

Current state (problematic):
```java
@Test
void testAuthFlow() {
    Karate.run("classpath:demoblaze/auth.feature")
        .relativeTo(getClass())
        .outputCucumberJson(true);
}
```

## Goals / Non-Goals

**Goals:**
- Surface each Karate scenario outcome as a distinct JUnit 5 dynamic test so that Maven Surefire can mark the build failed when any scenario fails.
- Remove the redundant `.relativeTo(getClass())` call to avoid ambiguous path resolution.
- Preserve Cucumber JSON output for downstream reporting.

**Non-Goals:**
- Changing feature file content, tag structure, or test data strategy.
- Modifying `karate-config.js`, `pom.xml`, or any other file.
- Parallelising test execution (out of scope for this fix).

## Decisions

### D1 — Use `@Karate.Test Karate` instead of `@Test void`

**Decision:** Replace the annotation and return type so the method becomes:
```java
@Karate.Test
Karate testAuthFlow() {
    return Karate.run("classpath:demoblaze/auth.feature")
                 .outputCucumberJson(true);
}
```

**Rationale:** `@Karate.Test` is Karate's JUnit 5 extension point. It registers a `DynamicContainer` with individual `DynamicTest` entries for each scenario; JUnit 5 and Surefire then receive a real PASS/FAIL per scenario. The `@Test void` pattern ignores the `Results` object entirely.

**Alternatives considered:**
- Keep `@Test void` and add `assertEquals(0, results.getFailCount())` — technically valid but verbose; the `@Karate.Test` pattern is the idiomatic, supported approach and gives richer Surefire output.
- Use `Karate.run(getClass())` with tag filtering — unnecessary complexity for a single-feature suite.

### D2 — Drop `.relativeTo(getClass())`

**Decision:** Remove the call.

**Rationale:** `classpath:demoblaze/auth.feature` is already an absolute classpath reference resolved from the classpath root. `.relativeTo(getClass())` would re-resolve the path relative to the package `com/sofka/qa/demoblaze/runners/`, producing `com/sofka/qa/demoblaze/runners/classpath:demoblaze/auth.feature`, which is incorrect. Removing it makes the path unambiguous.

**Alternatives considered:**
- Switch to a package-relative path and keep `.relativeTo(getClass())` — introduces unnecessary coupling between the runner package and the feature location.

## Risks / Trade-offs

- **Surefire version compatibility** → Karate `@Karate.Test` requires JUnit 5; the project already declares `karate-junit5:1.4.1` so no version risk exists.
- **Single dynamic container vs. multiple test methods** → All scenarios run inside one `@Karate.Test` method. If a future requirement needs scenario-level retry or filtering via Maven `-Dtest=`, individual `@Karate.Test` methods per feature would be needed. Acceptable for the current four-scenario suite.
- **No new dependencies** → The fix is purely a code change inside the existing class; no library additions, no pom changes, no risk of transitive conflicts.
