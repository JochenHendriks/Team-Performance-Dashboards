==============================================================================
                    DORA & PERFORMANCE DASHBOARD V12
                         GEBRUIKERSHANDLEIDING & MANIFEST
==============================================================================

Inhoudsopgave:
1. Overzicht & Doel
2. Randvoorwaarden & Vereisten
3. Data Ophalen uit Jira (PowerShell & REST API)
4. Stap-voor-Stap Handleiding voor het Dashboard
5. Hoe moet je de Data en Metrics interpreteren?
6. De Grafieken Lezen (DORA Sparklines & Multi-Tab Trendgrafiek)
7. Troubleshooting & Veelgestelde Vragen
8. Versiebeheer & Git Protocol

==============================================================================
1. OVERZICHT & DOEL
==============================================================================
Het DORA & Performance Dashboard V12 is een self-contained, offline HTML5 
dashboard ontworpen voor softwareteams, Agile Coaches, Product Owners, Scrum Masters 
en Management.

Het dashboard biedt diepgaand inzicht in:
- De 4 officiële DORA Metrics (Deployment Frequency, Lead Time for Changes, 
  Change Failure Rate, Mean Time to Restore) inclusief DORA Maturity Badges (Elite, 
  High, Medium, Low) en maandelijkse Sparkline trendlijnen.
- Cycle Time (actieve ontwikkeltijd van In Progress tot Done) en Lead Time for Changes.
- Kwaliteits- en capaciteitsindicatoren (Defect Escape Rate, MTTD, Investment Mix).
- Vergelijkings- en trendanalyse t.o.v. de vorige periode of hetzelfde tijdvak vorig jaar.
- De impact van specifieke releases, hotfixes en post-release bugs per team.

Het dashboard draait volledig lokaal in je browser (via het file:// protocol). Er is 
geen externe webserver, Node.js runtime of database vereist. Alle grafieken en tabellen 
worden vloeibaar in-place bijgewerkt zonder herladen.

==============================================================================
2. RANDVOORWAARDEN & VEREISTEN
==============================================================================
Om het dashboard optimaal te laten functioneren, moet aan de volgende 
randvoorwaarden worden voldaan:

A. Browser Vereisten:
   - Een moderne webbrowser met JavaScript ondersteuning (Google Chrome, 
     Microsoft Edge, Mozilla Firefox of Safari).
   - Werkt direct als lokaal HTML-bestand via 'file://'.

B. Jira Data Randvoorwaarden (Jira Velden):
   Het Jira project moet de volgende velden beschikbaar stellen in de REST API 
   of JSON-export:
   - issuetype      : Type ticket (Story, Task, Bug, Incident, Defect, etc.)
   - summary        : Korte omschrijving van het ticket
   - fixVersions    : De release/versie waarin het ticket is opgeleverd (Fix Version)
   - versions       : De release(s) waarin een fout is ontdekt (Affects Version)
   - created        : Aanmaakdatum van het ticket (ISO formaat)
   - resolutiondate : Oplosdatum van het ticket (ISO formaat)
   - priority       : Prioriteit van het ticket (Highest, High, Medium, Low, etc.)
   - status         : Status van het ticket (Done, Closed, Resolved, In Progress)
   - updated        : Datum van laatste wijziging
   - Team veld      : Jira veldnaam voor het team (standaard 'team', of een 
                      CustomField ID zoals 'customfield_10011').
   - changelog      : (Optioneel) Statusovergangen, alleen nodig voor de berekening 
                      van de exacte Cycle Time (In Progress transitie).

C. Jira Versiebeheer Conventies:
   - Releases (Versies) worden in Jira aangemaakt onder 'Project Settings > Versions'.
   - Opleveringen (Stories/Tasks) worden gekoppeld aan de betreffende 'Fix Version'.
   - Wanneer een bug in productie ontstaat, wordt bij voorkeur de release waarin 
     de fout is ontstaan gekoppeld in het veld 'Affects Version'.
   - Indien een versie geen expliciete releasedatum heeft, hanteert het dashboard 
     een slimme pre-indexed fallback op basis van het nieuwst opgeloste ticket.

==============================================================================
3. DATA OPHALEN UIT JIRA (POWERSHELL & REST API)
==============================================================================
Er zijn twee manieren om de benodigde data uit Jira te exporteren:

--- MANIER 1: AUTOMATISCH VIA POWERSHELL (Aanbevolen) ---
In de hoofdmap staan twee hulpscripts:
- update-data.ps1 : Het PowerShell script dat de Jira REST API aanroept.
- run-update.bat  : Een dubbelklik-bestand dat het PowerShell script start.

Stappen:
1. Open 'update-data.ps1' in een tekstverwerker (bijv. Notepad++ of VS Code).
2. Vul de volgende variabelen bovenaan het script in:
   - $JiraUrl           = "https://jira.jouwbedrijf.nl"
   - $ProjectKey        = "JOUW_PROJECT_KEY" (bijv. WEB of PROJ)
   - $TeamField         = "team" (of jouw customfield ID)
   - $PatToken          = "JOUW_PERSONAL_ACCESS_TOKEN" (PAT token uit Jira)
3. Optionele instellingen in 'update-data.ps1':
   - $IncludeChangelog  = $false (Zet op $true als je Cycle Time met In Progress 
                          statustransities wilt berekenen. $false maakt de export 
                          aanzienlijk kleiner en sneller).
   - $TeamName          = "Team Alpha" (Leeg laten voor alle teams)
   - $VersionFilterMode = "released"   ("released", "unreleased", of "all")
   - $StartDate         = "2026-01-01" (Optioneel)
   - $EndDate           = "2026-12-31" (Optioneel)
4. Dubbelklik op 'run-update.bat'.
   Het script haalt automatisch paginerend alle data op en slaat deze lokaal op als:
   - versies.json
   - issues.json

--- MANIER 2: HANDMATIG VIA DE URL-GENERATOR IN HET DASHBOARD ---
Als je geen PowerShell kunt of mag uitvoeren:
1. Open 'Dashboard V12.html' in je browser.
2. Vul in Stap 1 jouw Jira Base URL en Project Key in.
3. Configureer eventuele opties (zoals het vinkje voor changelog).
4. Klik bij Link 1 (Versies) op 'Openen ↗' om de API direct in een nieuw tabblad 
   te openen (of gebruik 'Kopieer URL'). Sla de JSON op als 'versies.json'.
5. Klik bij Link 2 (Issues op maat) op 'Openen ↗' en sla de JSON op als 'issues.json'.

==============================================================================
4. STAP-VOOR-STAP HANDLEIDING VOOR HET DASHBOARD
==============================================================================
Stap 1: Data Inladen & Berekenen
--------------------------------
1. Open 'Dashboard V12.html' in de browser.
2. Ga naar "Stap 2: Upload en Bereken".
3. Selecteer het bestand 'versies.json' bij "Upload versies.json".
4. Selecteer het bestand 'issues.json' bij "Upload issues.json" (meerdere bestanden 
   tegelijk uploaden is ondersteund; tickets worden automatisch ontdubbeld).
5. Klik op de knop "Bereken Metrics".
   Er verschijnt kort een moderne laad-overlay met spinner. Na verwerking verbergt 
   het dashboard de importsectie automatisch voor een rustig overzicht (deze kan 
   altijd weer worden geopend via de knop '⚙️ Toon Import & API Instellingen').

Stap 2: Dynamische Filters & Personalisatie
-------------------------------------------
Alle filters worden direct in het geheugen en in localStorage bewaard, zodat jouw 
selecties behouden blijven bij een verversing van de pagina:

1. Periode Filter & Snelfilters:
   - Kies een snelfilter ("Deze Maand", "Vorige Maand", "YTD", "Laatste 3 Mnd", 
     "Laatste 6 Mnd", "Laatste 12 Mnd", "Gehele Dataset") of voer zelf een "Van" 
     en/of "Tot" datum in.

2. Trend / Vergelijkingsperiode:
   - Kies in het dropdownmenu of je de huidige periode wilt vergelijken met:
     * Geen vergelijking
     * Vorige Periode (gelijke lengte direct voorafgaand)
     * Zelfde Periode Vorig Jaar
     * Aangepaste Periode (kies zelf een referentie datumreeks)
   - Op alle KPI-kaarten verschijnen direct trendbadges met procentuele en 
     absolute afwijkingen (met passende groen/rood indicaties).

3. Releasenaam Filter & Zoekveld:
   - Zoek direct op een trefwoord (bijv. "12." of "Hotfix").
   - Voeg filter-chips toe om specifieke versies in of uit te sluiten (bijv. '!rc').
   - Een tellerbadge toont exact hoeveel versies binnen de selectie vallen.

4. Release Status Filter:
   - Vink 'Released', 'Unreleased' of 'Archived' aan om te bepalen welke type 
     versies in de calculaties worden meegenomen.

5. LTC Eindpunt Selectie:
   - Kies tussen "Ticket Aanmaak ➔ Releasedatum (DORA E2E)" of 
     "Ticket Aanmaak ➔ Ticket Afgerond (Done)".

6. Issue Types Selectie:
   - Definieer flexibel welke typen gelden als Changes/Features en welke als Bugs.

7. CFR Prioriteiten Filter:
   - Vink aan welke prioriteiten een release mogen laten falen (standaard Highest, 
     High, Critical, Major).

8. Team Filter:
   - Schakel tussen individuele teams of selecteer meerdere teams tegelijk.

9. Kwaliteit & Bug Severity Filter (Interactieve Pills):
   - Klik op een prioriteit-pill (bijv. 'Highest') om MTTR, MTTD en Defect Escape 
     Rate specifiek voor die ernstgraad te analyseren.

10. Vriendelijke Lege Status:
    - Mocht een filtercombinatie 0 resultaten opleveren, dan toont het dashboard 
      een duidelijke en vriendelijke lege status box met hersteltips in plaats 
      van een foutmelding.

==============================================================================
5. HOE MOET JE DE DATA EN METRICS INTERPRETEREN?
==============================================================================

--- DE 4 OFFICIËLE DORA METRICS ---

1. Deployment Frequency (DF) - [Snelheid van Opleveren]
   - Betekenis: Het gemiddeld aantal productiereleases per maand.
   - Formule  : (Aantal Actieve Releases) / (Aantal Maanden in Periode)
   - DORA Benchmark Badges:
     * Elite  : Dagelijks / Meerdere keren per dag (> 30/mnd)
     * High   : Wekelijks tot maandelijks (1 tot 4/mnd)
     * Medium : Eens per maand tot 6 maanden
     * Low    : Minder dan eens per 6 maanden

2. Lead Time for Changes (LTC) - [Doorlooptijd van Wijzigingen]
   - Betekenis: De gemiddelde tijd van ticketcreatie tot productie (of status Done).
   - Formule  : Gemiddelde van (Releasedatum - Aanmaakdatum ticket) voor alle Changes.
   - DORA Benchmark Badges:
     * Elite  : < 1 dag
     * High   : 1 dag tot 1 week (< 7 dagen)
     * Medium : 1 week tot 1 maand (< 30 dagen)
     * Low    : > 1 maand

3. Change Failure Rate (CFR) - [Percentage Gefaalde Releases]
   - Betekenis: Het percentage releases dat tot storingen of herstelacties heeft geleid.
   - Formule  : (Aantal Gefaalde Releases / Totaal Aantal Releases) * 100
   - DORA Trechterlogica (Wanneer faalt een release?):
     a) HOTFIX: Release bevat 0 features en minimaal één aangevinkte bug.
     b) AFFECTS VERSION: Een bug met geselecteerde prioriteit heeft deze release 
        expliciet als oorzaak gekoppeld.
     c) POST-RELEASE FALLBACK: Als 'Affects Version' leeg is, faalt de release als 
        een kritieke bug is gemeld óp of ná de releasedatum.
   - DORA Benchmark Badges:
     * Elite  : 0% - 5%
     * High   : 5% - 15%
     * Medium : 15% - 30%
     * Low    : > 30%

4. Mean Time to Restore (MTTR) - [Hersteltijd bij Incidenten]
   - Betekenis: De gemiddelde tijd tussen aanmaak en afronding van productieverstoringen.
   - Formule  : Gemiddelde van (Resolutiondate - Created) van opgeloste bugs.
   - DORA Benchmark Badges:
     * Elite  : < 1 uur
     * High   : < 1 dag (< 24 uur)
     * Medium : < 1 week (< 7 dagen)
     * Low    : > 1 week

--- KWALITEIT & CAPACITEIT INZICHT ---

5. Cycle Time [Actieve Ontwikkeltijd]
   - Betekenis: De tijd vanaf start ontwikkeling ('In Progress') tot 'Done'.
   - Onderscheid met LTC: Waar LTC de gehele wachttijd (backlog, refinement, 
     release-planning) meeneemt, toont Cycle Time zuiver de engineering-snelheid.

6. Defect Escape Rate [% Bugs in Productie]
   - Formule: (Aantal Post-release Bugs / Totaal Aantal Bugs) * 100
   - Geeft aan hoeveel procent van de fouten niet vooraf tijdens sprints/testen 
     werd ontdekt.

7. Time to Detect (MTTD) [Livegang tot Ontdekking]
   - Formule: Gemiddelde van (Aanmaakdatum Bug - Releasedatum).
   - Meet de effectiviteit van telemetrie, monitoring en alertingsystemen.

8. Investment Mix [Features % / Bugs %]
   - Verhouding tussen het aantal opgeleverde Changes vs. Bugs.
   - Geeft direct inzicht in de balans tussen innovatie en 'technical debt'/onderhoud.

==============================================================================
6. DE GRAFIEKEN LEZEN (DORA SPARKLINES & MULTI-TAB TRENDGRAFIEK)
==============================================================================
Het dashboard combineert compacte KPI-sparklines met een diepgaande interactieve 
trendgrafiek:

A. Maandelijkse DORA Sparklines:
   - Bovenaan elke DORA KPI-tegel (DF, LTC, CFR, MTTR) bevindt zich een minimalistische 
     sparkline.
   - Geeft in één oogopslag de ontwikkeling van de betreffende metriek over de 
     maanden weer, inclusief micro-animatie bij datawisselingen.

B. Multi-Tab Hoofdtrendgrafiek:
   Boven de grote grafiek kan gewisseld worden tussen 3 gerichte tabbladen:

   1. Tab "CFR & Release Impact":
      - Groene gestapelde balken : Aantal succesvolle releases per maand.
      - Rode gestapelde balken   : Aantal gefaalde releases per maand.
      - Blauwe lijn (Rechter Y-as): Change Failure Rate per maand (in %).
      - Oranje stippellijn       : 3-maands rollend gemiddelde (trendlijn).

   2. Tab "Lead Time for Changes (LTC)":
      - Blauwe balken (Linker Y-as): Totaal aantal opgeleverde Changes per maand.
      - Blauwe lijn (Rechter Y-as)  : Gemiddelde LTC in dagen.
      - Oranje stippellijn          : 3-maands trend van de doorlooptijd.

   3. Tab "Mean Time to Restore (MTTR)":
      - Rode balken (Linker Y-as)  : Aantal opgeloste bugs per maand.
      - Oranje lijn (Rechter Y-as) : Gemiddelde hersteltijd (MTTR) in uren.
      - Grijze stippellijn         : 3-maands trend van de hersteltijd.

C. In-Place Updates:
   - Bij het wisselen van teams, datums of prioriteiten blijven de grafiek-instanties 
     behouden. Gegevens worden vloeiend bijgewerkt via 'chart.update()', zonder 
     schermflikkeringen of geheugenverlies.

==============================================================================
7. TROUBLESHOOTING & VEELGESTELDE VRAGEN
==============================================================================
V: Het teamfilter toont alle tickets als 'Onbekend'.
A: Controleer in Jira wat de exacte veldnaam is voor het team. Vul in Stap 1 van 
   het dashboard of in 'update-data.ps1' het CustomField ID in (bijv. customfield_10011).

V: Een versie heeft geen releasedatum in Jira.
A: Geen probleem. Het dashboard gebruikt een intelligente O(I) pre-indexed fallback: 
   de releasedatum wordt automatisch afgeleid van het nieuwst opgeloste ticket in die versie.

V: Kan ik data van meerdere projecten combineren?
A: Ja! Je kunt in Stap 2 meerdere 'issues.json' bestanden tegelijk selecteren. 
   Het dashboard ontdubbelt automatisch dubbele tickets op basis van Issue Key.

V: Het ophalen van issues via PowerShell duurt lang of het bestand is erg groot.
A: Zet in 'update-data.ps1' de variabele $IncludeChangelog op $false (of vink in Stap 1 
   de optie '&expand=changelog' uit). Dit scheelt tot wel 80% van de bestandsgrootte.

V: Mijn filters worden gereset als ik de browser sluit.
A: Vanaf versie 12.5.0 worden alle filters automatisch opgeslagen in localStorage 
   van je browser. Zorg dat je browser niet in 'Incognito' of 'Private browsing' 
   staat als je wilt dat instellingen permanent behouden blijven.

V: Mijn export bevat meer dan 1.000 tickets, maar Jira exporteert er maximaal 1.000 per keer.
A: Vanaf versie 12.7.0 detecteert het dashboard automatisch bij het uploaden of een 
   bestand onvolledig is (bijv. 1.000 van 1.336 tickets). Het dashboard toont direct 
   een waarschuwing met kant-en-klare 'Openen ↗'-knoppen voor Deel 2, Deel 3 etc. 
   Upload simpelweg alle delen tegelijk in Stap 2; het dashboard voegt ze automatisch samen!
   Als alternatief kan 'update-data.ps1' gebruikt worden, dat automatisch alle pagina's 
   in één bestand bundelt.

==============================================================================
8. VERSIEBEHEER & GIT PROTOCOL
==============================================================================
Het project volgt een strikt versiebeheer- en releaseprotocol (vastgelegd in AGENTS.md):

1. Versienummering in Dashboard V12.html:
   Bij elke aanpassing of release wordt het versienummer (v12.X.Y) en de datum 
   in drie verplichte componenten synchroon geüpdatet:
   - Header Badge : #versionBadge
   - Javascript   : const DASHBOARD_VERSION
   - Footer       : <footer>

2. Git Commit Conventie:
   Formaat: release(v12.X.Y): <korte beschrijving van de wijzigingen>

3. Git Tagging & Push:
   - Annotated Tag: git tag -a v12.X.Y -m "Release v12.X.Y: <beschrijving>"
   - Push command : git push origin main --tags

Huidige stabiele versie: v12.7.1 (23-10-2026)
==============================================================================
