## Why

The project's documentation lives in plain-text files (`readme.txt`, `conclusiones.txt`) that are invisible to GitHub/GitLab Markdown renderers and incompatible with standard repository conventions. A proper `README.md` at the repo root enables automatic rendering on the platform, improves onboarding for reviewers, and serves as the single authoritative reference for running and understanding the test suite.

## What Changes

- Add `README.md` at the project root, written in Markdown.
- Content migrated and enriched from `readme.txt` and `conclusiones.txt`:
  - Project overview and purpose (Sofka QA Automation Challenge – Exercise 2)
  - Prerequisites (Java 21, Maven Wrapper, internet access)
  - Execution commands (full suite + tag filters)
  - Project structure diagram
  - Test scenarios summary (4 scenarios: signup/login × positive/negative)
  - API findings (non-semantic HTTP codes, JSON response contracts, plain-text password risk)
  - CI/CD badge pointing to the GitHub Actions workflow
- `readme.txt` and `conclusiones.txt` are **not deleted** – they remain as-is.

## Capabilities

### New Capabilities

- `project-readme`: Root-level `README.md` that documents the project purpose, prerequisites, execution instructions, test scenario inventory, project structure, and API quality findings.

### Modified Capabilities

## Impact

- New file: `README.md` at project root.
- No changes to existing source code, feature files, or runner classes.
- No changes to `pom.xml` or Maven Wrapper.
- GitHub Actions badge requires the workflow file `.github/workflows/karate-tests.yml` to already exist (it does).
