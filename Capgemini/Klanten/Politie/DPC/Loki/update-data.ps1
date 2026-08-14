# ==============================================================================
# Jira Data Fetcher voor DORA CFR Dashboard (V10)
# ==============================================================================
# Gebruik: Vul hieronder jouw Jira URL, Project Key, Veldnaam voor Team en PAT-token in.
# Optioneel kun je $TeamName invullen om het resultaat te beperken tot één team,
# en $IncludeUnreleased op $true zetten om ook on-gereleasede versies op te halen.
# Dubbelklik daarna op 'run-update.bat' om 'versies.json' en 'issues.json' automatisch op te halen.
# ==============================================================================

param (
    [string]$JiraUrl           = "https://jira.jouwbedrijf.nl",
    [string]$ProjectKey        = "WEB",
    [string]$TeamField         = "team",
    [string]$TeamName          = "",                  # Optioneel: vul teamnaam in (bijv. "Team Alpha")
    [string]$VersionFilterMode = "released",          # "released", "unreleased" (is not empty), of "all" (geen fixVersion beperking)
    [string]$StartDate         = "",                  # Optioneel: YYYY-MM-DD
    [string]$EndDate           = "",                  # Optioneel: YYYY-MM-DD
    [string]$DateField         = "resolutiondate",    # "resolutiondate", "updated", of "created"
    [string]$PatToken          = "JOUW_PERSONAL_ACCESS_TOKEN"
)

if ($JiraUrl -eq "https://jira.jouwbedrijf.nl" -or $PatToken -eq "JOUW_PERSONAL_ACCESS_TOKEN") {
    Write-Host "[WAARSCHUWING] Vul eerst je JiraUrl en PatToken in dit script (update-data.ps1) in!" -ForegroundColor Yellow
}

$Headers = @{
    "Authorization" = "Bearer $PatToken"
    "Accept"        = "application/json"
}

# Huidige werkmap instellen op de scriptmap
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -Path $ScriptDir

try {
    Write-Host "1. Versies ophalen..." -ForegroundColor Cyan
    $cleanBaseUrl = $JiraUrl.TrimEnd('/')
    $versionsUrl = "$cleanBaseUrl/rest/api/2/project/$ProjectKey/versions"
    
    $versions = Invoke-RestMethod -Uri $versionsUrl -Headers $Headers -Method Get
    $versions | ConvertTo-Json -Depth 5 | Out-File -FilePath "$ScriptDir\versies.json" -Encoding utf8
    Write-Host "   [OK] versies.json opgeslagen ($($versions.Count) versies)." -ForegroundColor Green

    Write-Host "2. Issues ophalen (inclusief paginering)..." -ForegroundColor Cyan

    $jqlClauses = @("project=`"$ProjectKey`"")

    if (-not [string]::IsNullOrWhiteSpace($TeamName)) {
        $jqlClauses += "`"$TeamField`"=`"$TeamName`""
    }
    if (-not [string]::IsNullOrWhiteSpace($StartDate)) {
        $jqlClauses += "$DateField >= `"$StartDate`""
    }
    if (-not [string]::IsNullOrWhiteSpace($EndDate)) {
        $jqlClauses += "$DateField <= `"$EndDate`""
    }
    if ($VersionFilterMode -eq "released") {
        $jqlClauses += "fixVersion in releasedVersions()"
    } elseif ($VersionFilterMode -eq "unreleased") {
        $jqlClauses += "fixVersion is not EMPTY"
    }

    $jql = $jqlClauses -join " AND "

    Write-Host "   -> JQL Query: $jql" -ForegroundColor Gray
    $fields = "issuetype,summary,fixVersions,versions,created,resolutiondate,priority,status,updated,$TeamField"

    $allIssues = @()
    $startAt = 0
    $maxResults = 1000
    $moreRecords = $true

    while ($moreRecords) {
        $searchUrl = "$cleanBaseUrl/rest/api/2/search?jql=$([Uri]::EscapeDataString($jql))&startAt=$startAt&maxResults=$maxResults&fields=$fields"
        $response = Invoke-RestMethod -Uri $searchUrl -Headers $Headers -Method Get
        
        if ($response.issues) {
            $allIssues += $response.issues
        }
        Write-Host "   -> $($allIssues.Count) van $($response.total) issues opgehaald..." -ForegroundColor Gray
        
        if (($startAt + $maxResults) -ge $response.total -or $response.issues.Count -eq 0) {
            $moreRecords = $false
        } else {
            $startAt += $maxResults
        }
    }

    @{ issues = $allIssues } | ConvertTo-Json -Depth 10 | Out-File -FilePath "$ScriptDir\issues.json" -Encoding utf8
    Write-Host "   [OK] issues.json opgeslagen met $($allIssues.Count) tickets!" -ForegroundColor Green

    Write-Host "`nSucces! Je kunt nu Dashboard V10 openen en de bijgewerkte JSON-bestanden inladen.`n" -ForegroundColor Yellow

} catch {
    Write-Host "`n[FOUT] Er is een fout ingetreden bij het ophalen van data uit Jira:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "Controleer je JiraUrl, ProjectKey en PatToken in update-data.ps1.`n" -ForegroundColor Red
}
