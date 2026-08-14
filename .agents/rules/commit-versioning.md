# Git Commit & Version Management Rule

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

## 2. Commit Message Structure
Always include the version tag at the beginning of the Git commit message:
- Format: `release(v10.X.Y): <korte beschrijving van de wijzigingen>`
- Example: `release(v10.2.0): Flexibele JQL API filters toegevoegd voor status, team en datumrange`

## 3. Pre-Commit Verification
- Verify that the version string in `Dashboard V10.html` and the version tag in the commit message match 1-on-1.
