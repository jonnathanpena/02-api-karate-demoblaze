## Context

The project currently ships two plain-text documentation files (`readme.txt` and `conclusiones.txt`) at the repo root. These files contain complete execution instructions and test findings but are invisible to GitHub/GitLab Markdown renderers. Reviewers navigating to the repository see no formatted documentation on the landing page.

The GitHub Actions workflow (`.github/workflows/karate-tests.yml`) already exists and runs on `push`/`pull_request` against `main`, making a CI badge immediately available.

No source code, feature files, `pom.xml`, or runner classes are affected by this change.

## Goals / Non-Goals

**Goals:**
- Produce a single `README.md` at the project root that renders automatically on GitHub.
- Consolidate content from `readme.txt` (execution) and `conclusiones.txt` (findings) into structured Markdown sections.
- Surface the GitHub Actions CI badge so build status is visible at a glance.
- Preserve the original plain-text files unchanged.

**Non-Goals:**
- Deleting or replacing `readme.txt` / `conclusiones.txt`.
- Changing any test code, feature files, or Maven configuration.
- Translating documentation to a different language (content stays in Spanish to match existing files).
- Adding new test scenarios or fixing API behavior.

## Decisions

**1. Single `README.md` at repo root, not inside `src/`**
The root is the canonical location rendered by GitHub. Placing it elsewhere would require manual navigation. Alternative (keeping docs only in plain-text files) offers no platform rendering benefit.

**2. Retain `readme.txt` and `conclusiones.txt` as-is**
These files may be referenced externally or be part of the exercise deliverable criteria (`readme.txt` and `conclusiones.txt` are listed as acceptance criteria). Deleting them risks breaking the stated requirements. Risk of duplication is acceptable given the small file size.

**3. CI badge points to the existing `karate-tests.yml` workflow**
The workflow name is `"Karate API Tests"` and the default branch is `main`. Badge URL follows the standard GitHub Actions badge format:
`https://github.com/<owner>/<repo>/actions/workflows/karate-tests.yml/badge.svg`
The owner/repo slug will be left as a placeholder (`YOUR_GITHUB_USERNAME/YOUR_REPO_NAME`) so the file is correct by structure and the author fills it in at commit time.

**4. README sections mirror the source files' structure**
Sections map directly to the existing plain-text content to avoid information loss:
- Project overview → new introductory paragraph
- Prerequisites + key versions → from `readme.txt`
- Execution commands → from `readme.txt` (fenced code blocks)
- Project structure → ASCII tree from `readme.txt`
- Test scenario inventory → table derived from `conclusiones.txt`
- API findings → numbered list from `conclusiones.txt`
- CI/CD badge → placed at top of file

**5. Language: Spanish**
All existing documentation is written in Spanish to match the project's origin (Sofka QA Automation Challenge). Switching language mid-project without direction would be inconsistent.

## Risks / Trade-offs

- **Badge placeholder** → The CI badge URL contains `YOUR_GITHUB_USERNAME/YOUR_REPO_NAME`. If committed without substitution, the badge renders as broken. Mitigation: note the substitution clearly in the README itself or in a comment.
- **Content drift** → Future changes to `readme.txt` or `conclusiones.txt` will not automatically propagate to `README.md`. Mitigation: the proposal explicitly states these files are kept but `README.md` becomes the authoritative reference; contributors should update `README.md` going forward.
- **No delete of plain-text files** → Two documentation sources will coexist and may diverge. This is an accepted trade-off to avoid breaking the exercise acceptance criteria.
