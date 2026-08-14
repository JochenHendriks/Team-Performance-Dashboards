$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$releases = @()
$startDate = [DateTime]"2026-01-05"
$teams = @("Team Alpha", "Team Beta", "Team Gamma", "Team Delta")
$priorities = @("Highest", "High", "Critical", "Major", "Medium", "Low", "Minor")

for ($i = 1; $i -le 55; $i++) {
    $rDate = $startDate.AddDays(($i - 1) * 6.5)
    $versionName = "v$([Math]::Floor(($i-1)/5) + 1).$(($i-1) % 5).0"
    if ($i % 7 -eq 0) { $versionName += "-hotfix" }
    
    $releases += [PSCustomObject]@{
        id          = (10000 + $i).ToString()
        name        = $versionName
        released    = $true
        releaseDate = $rDate.ToString("yyyy-MM-dd")
    }
}

$releases | ConvertTo-Json -Depth 5 | Out-File -FilePath "$scriptDir\versies.json" -Encoding utf8

$issues = @()
$issueKeyCounter = 101

$featureSummaries = @(
    "Implement SSO Authentication with Azure AD",
    "Add Export to Excel button in dashboard view",
    "Optimize SQL database query performance for large reports",
    "Design new dark mode UI palette for mobile users",
    "Integrate REST API endpoint for user profile updates",
    "Add multi-language support (NL / EN) in settings",
    "Refactor notification service to use WebSockets",
    "Implement automated PDF report generation",
    "Upgrade Chart.js library to version 4.4",
    "Add role-based access control for admin panel",
    "Create audit logging service for security compliance",
    "Implement cache layer for frequently queried metrics",
    "Design responsive sidebar navigation component",
    "Add CSV batch import functionality for customer data",
    "Improve page load time by enabling GZIP compression"
)

$bugSummaries = @(
    "Null pointer exception when saving user settings without team",
    "CORS header missing on REST API response for /search endpoint",
    "Incorrect total calculation in monthly CFR summary table",
    "Session timeout modal does not close after token refresh",
    "Memory leak in Chart.js component during live data polling",
    "Date picker fails to format Dutch local dates correctly",
    "Dropdown menu overflows container on mobile screens",
    "Filter reset button does not clear selected team checkboxes",
    "HTTP 500 error when uploading large JSON files > 10MB",
    "Export button fails silently when dataset is empty"
)

for ($rIdx = 0; $rIdx -lt $releases.Count; $rIdx++) {
    $rel = $releases[$rIdx]
    $rDate = [DateTime]::Parse($rel.releaseDate)
    $team = $teams[$rIdx % $teams.Count]
    $isHotfixRelease = ($rIdx % 7 -eq 6)
    
    if (-not $isHotfixRelease) {
        $numFeatures = ($rIdx % 3) + 1
        for ($f = 0; $f -lt $numFeatures; $f++) {
            $key = "LOKI-$issueKeyCounter"
            $issueKeyCounter++
            $created = $rDate.AddDays(- (10 + ($f * 2)))
            $resolved = $rDate.AddDays(- (1 + $f))
            $sum = $featureSummaries[($issueKeyCounter) % $featureSummaries.Count] + " ($($rel.name))"
            
            $issues += [PSCustomObject]@{
                key = $key
                fields = [PSCustomObject]@{
                    issuetype      = [PSCustomObject]@{ name = "Story" }
                    summary        = $sum
                    fixVersions    = @([PSCustomObject]@{ name = $rel.name })
                    versions       = @()
                    created        = $created.ToString("yyyy-MM-ddTHH:mm:ss.000+0100")
                    resolutiondate = $resolved.ToString("yyyy-MM-ddTHH:mm:ss.000+0100")
                    priority       = [PSCustomObject]@{ name = "Medium" }
                    status         = [PSCustomObject]@{ name = "Done"; statusCategory = [PSCustomObject]@{ key = "done" } }
                    updated        = $resolved.ToString("yyyy-MM-ddTHH:mm:ss.000+0100")
                    team           = [PSCustomObject]@{ name = $team }
                }
            }
        }
    }
    
    if ($rIdx % 2 -eq 0 -or $isHotfixRelease) {
        $numBugs = if ($isHotfixRelease) { 2 } else { 1 }
        for ($b = 0; $b -lt $numBugs; $b++) {
            $key = "LOKI-$issueKeyCounter"
            $issueKeyCounter++
            
            $isPost = ($b % 2 -eq 0) -or $isHotfixRelease
            if ($isPost) {
                $created = $rDate.AddDays(1 + ($b * 2))
                $resolved = $created.AddHours(12 + ($b * 8))
            } else {
                $created = $rDate.AddDays(-5)
                $resolved = $rDate.AddDays(-1)
            }
            
            $prio = $priorities[($issueKeyCounter) % $priorities.Count]
            $sum = $bugSummaries[($issueKeyCounter) % $bugSummaries.Count] + " ($($rel.name))"
            
            $affectedVers = @()
            if ($isPost -and ($b % 3 -ne 1)) {
                $affectedVers = @([PSCustomObject]@{ name = $rel.name })
            }
            
            $issues += [PSCustomObject]@{
                key = $key
                fields = [PSCustomObject]@{
                    issuetype      = [PSCustomObject]@{ name = "Bug" }
                    summary        = $sum
                    fixVersions    = @([PSCustomObject]@{ name = $rel.name })
                    versions       = $affectedVers
                    created        = $created.ToString("yyyy-MM-ddTHH:mm:ss.000+0100")
                    resolutiondate = $resolved.ToString("yyyy-MM-ddTHH:mm:ss.000+0100")
                    priority       = [PSCustomObject]@{ name = $prio }
                    status         = [PSCustomObject]@{ name = "Done"; statusCategory = [PSCustomObject]@{ key = "done" } }
                    updated        = $resolved.ToString("yyyy-MM-ddTHH:mm:ss.000+0100")
                    team           = [PSCustomObject]@{ name = $team }
                }
            }
        }
    }
}

@{ issues = $issues } | ConvertTo-Json -Depth 10 | Out-File -FilePath "$scriptDir\issues.json" -Encoding utf8

Write-Host "Klaar! $($releases.Count) versies en $($issues.Count) issues zijn aangemaakt in versies.json en issues.json." -ForegroundColor Green
