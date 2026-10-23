# Git Commit, Versioning & Tagging Rule

Whenever creating git commits, releasing updates, or modifying dashboard files in this repository:

## 1. Version Increment Checklist
Before creating a commit for changes in `Dashboard V12.html`:
- Check the current version tag (`v12.X.Y`) and date (`DD-MM-YYYY`).
- Increment the version number according to Semantic Versioning:
  - **Patch (`v12.7.X`)**: Bugfixes, minor UI adjustments.
  - **Minor (`v12.X.0`)**: New features, new filter controls, metric calculation updates.
  - **Major (`vX.0.0`)**: Breaking changes, new major dashboard versions.
- Ensure the version and date are updated across all 3 references in `Dashboard V12.html`:
  1. **Header Badge**: `<span id="versionBadge">v12.X.Y (DD-MM-YYYY)</span>`
  2. **Footer**: `DORA & Performance Dashboard V12 • Versie 12.X.Y (DD-MM-YYYY)`
  3. **JavaScript Constant**: `const DASHBOARD_VERSION = "12.X.Y";`

## 2. Commit & Tag Protocol
When releasing a change:
1. **Commit Message Format:**
   `git commit -m "release(v12.X.Y): <korte beschrijving van de wijzigingen>"`
2. **Git Tag Creation:**
   `git tag -a v12.X.Y -m "Release v12.X.Y: <korte beschrijving>"`
3. **Push Commits and Tags:**
   `git push origin main --tags`

## 3. Pre-Push Verification
- Verify that the HTML version string, git commit message tag, and git release tag (`v12.X.Y`) match 1-on-1 before pushing.
