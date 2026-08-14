# ==============================================================================
# Jira Data Fetcher voor DORA CFR Dashboard (V9)
# ==============================================================================
# Gebruik: Vul hieronder jouw Jira URL, Project Key, Veldnaam voor Team en PAT-token in.
# Dubbelklik daarna op 'run-update.bat' om 'versies.json' en 'issues.json' automatisch op te halen.
# ==============================================================================

$JiraUrl    = "https://jira.jouwbedrijf.nl" # Pas aan naar jouw Jira Base URL
$ProjectKey = "WEB"                         # Pas aan naar jouw Jira Project Key
$TeamField  = "team"                        # Jira veldnaam of customfield_ID voor Team
$PatToken   = "JOUW_PERSONAL_ACCESS_TOKEN"  # Plak hier je Personal Access Token (PAT)

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
    $jql = "project=`"$ProjectKey`" AND fixVersion in releasedVersions()"
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

    Write-Host "`nSucces! Je kunt nu Dashboard V9 openen en de bijgewerkte JSON-bestanden inladen.`n" -ForegroundColor Yellow

} catch {
    Write-Host "`n[FOUT] Er is een fout ingetreden bij het ophalen van data uit Jira:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "Controleer je JiraUrl, ProjectKey en PatToken in update-data.ps1.`n" -ForegroundColor Red
}
