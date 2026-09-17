# Team Performance Dashboards - AI Agent Guidelines & Workflow Rules

## Versioning, Git Commit & Tagging Protocol

Whenever modifying the dashboard or preparing commits for GitHub:

1. **Version Update Requirement:**
   - Always update the version number (`v11.X.Y`) and date in `Capgemini/Klanten/Politie/DPC/Loki/Dashboard V11.html` when making changes.
   - Synchronize all 3 version locations in `Dashboard V11.html`:
     - Header Badge (`#versionBadge`)
     - Footer (`<footer>`)
     - JS Constant (`const DASHBOARD_VERSION`)

2. **Git Commit & Tagging Steps:**
   - **Commit format:** `release(v11.X.Y): <beschrijving van de wijzigingen>`
   - **Git Tag format:** `git tag -a v11.X.Y -m "Release v11.X.Y: <beschrijving>"`
   - **Push command:** `git push origin main --tags`
