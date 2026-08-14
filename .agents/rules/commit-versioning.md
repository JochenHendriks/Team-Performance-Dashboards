# Git Commit, Versioning & Tagging Rule

Whenever creating git commits, releasing updates, or modifying dashboard files in this repository:

## 1. Version Increment Checklist
Before creating a commit for changes in `Capgemini/Klanten/Politie/DPC/Loki/Dashboard V10.html`:
- Check the current version tag (`v10.X.Y`) and date (`DD-MM-YYYY`).
- Increment the version number according to Semantic Versioning:
  - **Patch (`v10.1.X`)**: Bugfixes, minor UI adjustments.
  - **Minor (`v10.X.0`)**: New features, new filter controls, metric calculation updates.
  - **Major (`vX.0.0`)**: Breaking changes, new major dashboard versions.
- Ensure the version and date are updated across all 3 references in `Dashboard V10.html`:
  1. **Header Badge**: `<span id="versionBadge">v10.X.Y (DD-MM-YYYY)</span>`
  2. **Footer**: `DORA & Performance Dashboard V10 • Versie 10.X.Y (DD-MM-YYYY)`
  3. **JavaScript Constant**: `const DASHBOARD_VERSION = "10.X.Y";`

## 2. Commit & Tag Protocol
When releasing a change:
1. **Commit Message Format:**
   `git commit -m "release(v10.X.Y): <korte beschrijving van de wijzigingen>"`
2. **Git Tag Creation:**
   `git tag -a v10.X.Y -m "Release v10.X.Y: <korte beschrijving>"`
3. **Push Commits and Tags:**
   `git push origin main --tags`

## 3. Pre-Push Verification
- Verify that the HTML version string, git commit message tag, and git release tag (`v10.X.Y`) match 1-on-1 before pushing.
