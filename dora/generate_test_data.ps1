$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$releases = @()
$startDate = [DateTime]"2026-01-05"
$teams = @("Team Alpha", "Team Beta", "Team Gamma", "Team Delta")
$priorities = @("Highest", "High", "Critical", "Major", "Medium", "Low", "Minor")

# Gedefinieerde release suites voor verschillende teams en applicaties:
$releaseDefs = @(
    # Conventie Team User: WEB | applicatienaam en dan versie
    @{ name = "WEB | Zoekdienst 1.0.0"; dateOffset = 0; team = "Team Alpha" },
    @{ name = "WEB | Inlogportaal 1.0.0"; dateOffset = 4; team = "Team Beta" },
    @{ name = "CORE-2026.01"; dateOffset = 8; team = "Team Gamma" },
    @{ name = "WEB | Zoekdienst 1.1.0"; dateOffset = 14; team = "Team Alpha" },
    @{ name = "API | Gateway v1.0.0"; dateOffset = 18; team = "Team Delta" },
    @{ name = "WEB | Klantdossier 1.0.0"; dateOffset = 22; team = "Team Alpha" },
    @{ name = "WEB | Zoekdienst 1.2.0-hotfix"; dateOffset = 28; team = "Team Alpha"; hotfix = $true },
    @{ name = "WEB | Inlogportaal 1.1.0"; dateOffset = 33; team = "Team Beta" },
    @{ name = "v1.0.0"; dateOffset = 38; team = "Team Gamma" },
    @{ name = "CORE-2026.02"; dateOffset = 44; team = "Team Gamma" },
    @{ name = "WEB | Zoekdienst 2.0.0"; dateOffset = 50; team = "Team Alpha" },
    @{ name = "WEB | Klantdossier 1.1.0"; dateOffset = 56; team = "Team Alpha" },
    @{ name = "API | Gateway v1.1.0"; dateOffset = 62; team = "Team Delta" },
    @{ name = "WEB | Inlogportaal 1.2.0-hotfix"; dateOffset = 68; team = "Team Beta"; hotfix = $true },
    @{ name = "WEB | Zoekdienst 2.1.0"; dateOffset = 74; team = "Team Alpha" },
    @{ name = "v1.1.0"; dateOffset = 80; team = "Team Gamma" },
    @{ name = "CORE-2026.03"; dateOffset = 86; team = "Team Gamma" },
    @{ name = "WEB | Inlogportaal 1.3.0"; dateOffset = 92; team = "Team Beta" },
    @{ name = "WEB | Zoekdienst 2.2.0"; dateOffset = 98; team = "Team Alpha" },
    @{ name = "WEB | Klantdossier 2.0.0"; dateOffset = 104; team = "Team Alpha" },
    @{ name = "API | Gateway v1.2.0-hotfix"; dateOffset = 110; team = "Team Delta"; hotfix = $true },
    @{ name = "CORE-2026.04-hotfix"; dateOffset = 116; team = "Team Gamma"; hotfix = $true },
    @{ name = "WEB | Zoekdienst 2.3.0"; dateOffset = 122; team = "Team Alpha" },
    @{ name = "WEB | Inlogportaal 2.0.0"; dateOffset = 128; team = "Team Beta" },
    @{ name = "v1.2.0"; dateOffset = 134; team = "Team Gamma" },
    @{ name = "WEB | Zoekdienst 2.4.0"; dateOffset = 140; team = "Team Alpha" },
    @{ name = "WEB | Klantdossier 2.1.0"; dateOffset = 146; team = "Team Alpha" },
    @{ name = "API | Gateway v2.0.0"; dateOffset = 152; team = "Team Delta" },
    @{ name = "CORE-2026.05"; dateOffset = 158; team = "Team Gamma" },
    @{ name = "WEB | Zoekdienst 2.4.1-hotfix"; dateOffset = 164; team = "Team Alpha"; hotfix = $true },
    @{ name = "WEB | Inlogportaal 2.1.0"; dateOffset = 170; team = "Team Beta" },
    @{ name = "v2.0.0"; dateOffset = 176; team = "Team Gamma" },
    @{ name = "WEB | Zoekdienst 2.5.0"; dateOffset = 182; team = "Team Alpha" },
    @{ name = "WEB | Klantdossier 2.2.0"; dateOffset = 188; team = "Team Alpha" },
    @{ name = "API | Gateway v2.1.0"; dateOffset = 194; team = "Team Delta" },
    @{ name = "CORE-2026.06"; dateOffset = 200; team = "Team Gamma" },
    @{ name = "WEB | Inlogportaal 2.2.0"; dateOffset = 206; team = "Team Beta" },
    @{ name = "WEB | Zoekdienst 3.0.0"; dateOffset = 214; team = "Team Alpha" },
    @{ name = "v2.1.0-hotfix"; dateOffset = 220; team = "Team Gamma"; hotfix = $true },
    @{ name = "WEB | Klantdossier 3.0.0"; dateOffset = 226; team = "Team Alpha" },
    @{ name = "API | Gateway v2.2.0"; dateOffset = 232; team = "Team Delta" },
    @{ name = "CORE-2026.07"; dateOffset = 238; team = "Team Gamma" },
    @{ name = "WEB | Zoekdienst 3.1.0"; dateOffset = 244; team = "Team Alpha" },
    @{ name = "WEB | Inlogportaal 2.3.0"; dateOffset = 250; team = "Team Beta" },
    @{ name = "WEB | Klantdossier 3.1.0-hotfix"; dateOffset = 256; team = "Team Alpha"; hotfix = $true },
    @{ name = "v2.2.0"; dateOffset = 262; team = "Team Gamma" },
    @{ name = "API | Gateway v2.3.0"; dateOffset = 268; team = "Team Delta" },
    @{ name = "WEB | Zoekdienst 3.2.0"; dateOffset = 274; team = "Team Alpha" },
    @{ name = "CORE-2026.08"; dateOffset = 280; team = "Team Gamma" },
    @{ name = "WEB | Inlogportaal 2.4.0"; dateOffset = 286; team = "Team Beta" }
)

for ($i = 0; $i -lt $releaseDefs.Count; $i++) {
    $def = $releaseDefs[$i]
    $rDate = $startDate.AddDays($def.dateOffset)
    
    $releases += [PSCustomObject]@{
        id          = (10001 + $i).ToString()
        name        = $def.name
        released    = $true
        releaseDate = $rDate.ToString("yyyy-MM-dd")
        team        = $def.team
        isHotfix    = [bool]($def.hotfix -eq $true)
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
    $team = if ($rel.team) { $rel.team } else { $teams[$rIdx % $teams.Count] }
    $isHotfixRelease = [bool]($rel.isHotfix -eq $true)
    
    if (-not $isHotfixRelease) {
        $numFeatures = ($rIdx % 3) + 1
        for ($f = 0; $f -lt $numFeatures; $f++) {
            $key = "WEB-$issueKeyCounter"
            $issueKeyCounter++
            $created = $rDate.AddDays(- (10 + ($f * 2)))
            $inProgress = $rDate.AddDays(- (4 + $f))
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
                changelog = [PSCustomObject]@{
                    histories = @(
                        [PSCustomObject]@{
                            created = $inProgress.ToString("yyyy-MM-ddTHH:mm:ss.000+0100")
                            items = @(
                                [PSCustomObject]@{
                                    field = "status"
                                    fieldtype = "jira"
                                    fromString = "To Do"
                                    toString = "In Progress"
                                }
                            )
                        },
                        [PSCustomObject]@{
                            created = $resolved.ToString("yyyy-MM-ddTHH:mm:ss.000+0100")
                            items = @(
                                [PSCustomObject]@{
                                    field = "status"
                                    fieldtype = "jira"
                                    fromString = "In Progress"
                                    toString = "Done"
                                }
                            )
                        }
                    )
                }
            }
        }
    }
    
    if ($rIdx % 2 -eq 0 -or $isHotfixRelease) {
        $numBugs = if ($isHotfixRelease) { 2 } else { 1 }
        for ($b = 0; $b -lt $numBugs; $b++) {
            $key = "WEB-$issueKeyCounter"
            $issueKeyCounter++
            
            $isPost = ($b % 2 -eq 0) -or $isHotfixRelease
            if ($isPost) {
                $created = $rDate.AddDays(1 + ($b * 2))
                $inProgress = $created.AddHours(2)
                $resolved = $created.AddHours(12 + ($b * 8))
            } else {
                $created = $rDate.AddDays(-5)
                $inProgress = $rDate.AddDays(-3)
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
                changelog = [PSCustomObject]@{
                    histories = @(
                        [PSCustomObject]@{
                            created = $inProgress.ToString("yyyy-MM-ddTHH:mm:ss.000+0100")
                            items = @(
                                [PSCustomObject]@{
                                    field = "status"
                                    fieldtype = "jira"
                                    fromString = "To Do"
                                    toString = "In Progress"
                                }
                            )
                        },
                        [PSCustomObject]@{
                            created = $resolved.ToString("yyyy-MM-ddTHH:mm:ss.000+0100")
                            items = @(
                                [PSCustomObject]@{
                                    field = "status"
                                    fieldtype = "jira"
                                    fromString = "In Progress"
                                    toString = "Done"
                                }
                            )
                        }
                    )
                }
            }
        }
    }
}

@{ issues = $issues } | ConvertTo-Json -Depth 10 | Out-File -FilePath "$scriptDir\issues.json" -Encoding utf8

Write-Host "Klaar! $($releases.Count) versies en $($issues.Count) issues zijn aangemaakt in versies.json en issues.json." -ForegroundColor Green
