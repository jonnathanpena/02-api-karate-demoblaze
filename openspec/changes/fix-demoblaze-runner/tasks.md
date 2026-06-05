## 1. Fix DemoblazeRunner annotation and return type

- [x] 1.1 Replace `@Test` with `@Karate.Test` on the `testAuthFlow` method in `DemoblazeRunner`
- [x] 1.2 Change the method return type from `void` to `Karate`
- [x] 1.3 Add `return` keyword before `Karate.run(...)` so the builder result is returned
- [x] 1.4 Remove the `.relativeTo(getClass())` chain call
- [x] 1.5 Remove the unused `import org.junit.jupiter.api.Test;` statement

## 2. Verify fix correctness

- [x] 2.1 Run `./mvnw test` and confirm exit code is 0 when all four scenarios pass
- [x] 2.2 Confirm Maven Surefire output reports individual dynamic tests (not a single always-passing test)
- [x] 2.3 Confirm `target/karate-reports/karate-summary.html` is generated after the run
- [x] 2.4 Confirm a Cucumber JSON report file is present under `target/karate-reports/`
