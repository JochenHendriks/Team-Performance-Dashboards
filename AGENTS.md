# Team Performance Dashboards - AI Agent Guidelines & Workflow Rules

## Versioning & Git Commit Protocol

Whenever modifying the dashboard or preparing commits for GitHub:

1. **Version Update Requirement:**
   - Always update the version number (`v10.X.Y`) and date in `Capgemini/Klanten/Politie/DPC/Loki/Dashboard V10.html` when making changes.
   - Synchronize all 3 version locations in `Dashboard V10.html`:
     - Header Badge (`#versionBadge`)
     - Footer (`<footer>`)
     - JS Constant (`const DASHBOARD_VERSION`)

2. **Git Commit Message Format:**
   - Always format commit messages with the version number:
     `release(v10.X.Y): <beschrijving van de wijzigingen>`
