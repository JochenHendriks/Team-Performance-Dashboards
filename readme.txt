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
6. De Grafiek lezen (DORA Trend & Release Impact Chart)
7. Troubleshooting & Veelgestelde Vragen
8. Versiebeheer & Git Protocol

==============================================================================
1. OVERZICHT & DOEL
==============================================================================
Het DORA & Performance Dashboard V12 is een self-contained, offline HTML5 
dashboard ontworpen voor softwareteams, Agile Coaches, Scrum Masters en Management.

Het dashboard biedt diepgaand inzicht in:
- De 4 officiële DORA Metrics (Deployment Frequency, Lead Time for Changes, 
  Change Failure Rate, Mean Time to Restore).
- Kwaliteits- en capaciteitsindicatoren (Defect Escape Rate, MTTD, Investment Mix).
- De impact van specifieke releases, hotfixes en post-release bugs per team.

Het dashboard draait volledig lokaal in je browser. Er is geen externe webserver 
of database vereist.

==============================================================================
2. RANDVOORWAARDEN & VEREISTEN
==============================================================================
Om het dashboard optimaal te laten functioneren, moet aan de volgende 
randvoorwaarden worden voldaan:

A. Browser Vereisten:
   - Een moderne webbrowser met JavaScript ondersteuning (Google Chrome, 
     Microsoft Edge, Mozilla Firefox of Safari).

B. Jira Data Randvoorwaarden (Verplichte Jira Velden):
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

C. Jira Versiebeheer Conventies:
   - Releases (Versies) worden in Jira aangemaakt onder 'Project Settings > Versions'.
   - Opleveringen (Stories/Tasks) worden gekoppeld aan de betreffende 'Fix Version'.
   - Wanneer een bug in productie ontstaat, wordt bij voorkeur de release waarin 
     de fout is ontstaan gekoppeld in het veld 'Affects Version'.

==============================================================================
3. DATA OPHALEN UIT JIRA (POWERSHELL & REST API)
==============================================================================
Er zijn twee manieren om de benodigde data uit Jira te halen:

--- MANIER 1: AUTOMATISCH VIA POWERSHELL (Aanbevolen) ---
In de map 'Capgemini/Klanten/Politie/DPC/Loki/' staan twee hulpscripts:
- update-data.ps1 : Het PowerShell script dat de Jira REST API aanroept.
- run-update.bat  : Een dubbelklik-bestand dat het PowerShell script start.

Stappen:
1. Open 'update-data.ps1' in een tekstverwerker (bijv. Notepad++ of VS Code).
2. Vul de volgende variabelen bovenaan het script in:
   - $JiraUrl    = "https://jira.jouwbedrijf.nl"
   - $ProjectKey = "JOUW_PROJECT_KEY" (bijv. WEB of LOKI)
   - $TeamField  = "team" (of jouw customfield ID)
   - $PatToken   = "JOUW_PERSONAL_ACCESS_TOKEN" (PAT token uit Jira)
3. Optionele filters instellen in 'update-data.ps1':
   - $TeamName          = "Team Alpha" (Leeg laten voor alle teams)
   - $VersionFilterMode = "released"   ("released", "unreleased", of "all")
   - $StartDate         = "2026-01-01" (Optioneel)
   - $EndDate           = "2026-12-31" (Optioneel)
4. Dubbelklik op 'run-update.bat'.
   Het script haalt automatisch paginerend alle data op en maakt twee bestanden aan:
   - versies.json
   - issues.json

--- MANIER 2: HANDMATIG VIA DE URL-GENERATOR IN HET DASHBOARD ---
Als je geen PowerShell kunt/wilt gebruiken:
1. Open 'Dashboard V12.html' in je browser.
2. Vul in Stap 1 jouw Jira Base URL en Project Key in.
3. Stel de gewenste filters in (Versies filter, Team filter, Datum range).
4. Kopieer Link 1 (Versies) en geef deze in een ingelogde browser in. Sla de 
   JSON-respons op als 'versies.json'.
5. Kopieer Link 2 (Issues op maat) en sla de JSON-respons op als 'issues.json'.

==============================================================================
4. STAP-VOOR-STAP HANDLEIDING VOOR HET DASHBOARD
==============================================================================
Stap 1: Data Inladen
--------------------
1. Open 'Dashboard V12.html' in de browser.
2. Ga naar "Stap 2: Upload en Bereken".
3. Selecteer het bestand 'versies.json' bij "Upload versies.json".
4. Selecteer het bestand 'issues.json' bij "Upload issues.json" (je kunt hier 
   eventueel meerdere JSON-bestanden tegelijk selecteren).
5. Klik op de blauwe knop "Bereken Metrics".

Stap 2: Filters & Instellingen Aanpassen in het Dashboard
---------------------------------------------------------
Zodra de data is geladen, verschijnen er bovenaan het dashboard diverse interactieve 
filters:

1. Periode Filter:
   - Snelfilters: "Alles in Data", "Laatste 3 Maanden", "Laatste 6 Maanden", "Dit Jaar".
   - Of vul handmatig een "Van" en "Tot" datum in. Alle statistieken en grafieken 
     passen zich direct aan.

2. Release Status Filter:
   - Released   : Vink aan om officieel vrijgegeven versies mee te nemen.
   - Unreleased : Vink aan om concept/lopende versies mee te nemen.
   - Archived   : Vink aan om gearchiveerde versies mee te nemen.

3. LTC Eindpunt (Doorlooptijd Definitie):
   - Ticket Aanmaak ➔ Releasedatum (DORA E2E) : Tijd vanaf aanmaken ticket tot livegang.
   - Ticket Aanmaak ➔ Ticket Afgerond (Done) : Tijd vanaf aanmaken tot status Done.

4. Issue Types Selectie:
   - Changes / Features : Vink aan welke issue types als nieuw werk tellen (bijv. Story, Task, Feature).
   - Bugs / Defects     : Vink aan welke issue types als fouten tellen (bijv. Bug, Incident, Defect).

5. CFR Prioriteiten Filter:
   - Vink aan welke bugprioriteiten krachtig genoeg zijn om een release te laten falen 
     (bijv. Highest, High, Critical, Major). Cosmetische bugs (Minor/Low) kun je uitvinken.

6. Team Filter:
   - Vink specifieke teams aan of uit om de prestaties van één team of een vergelijking 
     tussen teams te bekijken.

7. Bug Severity Filter (Klikbare tegels):
   - Klik op een specifieke prioriteit-tegel om MTTR, MTTD en Defect Escape Rate 
     dynamisch te filteren op enkel die prioriteit.

==============================================================================
5. HOE MOET JE DE DATA EN METRICS INTERPRETEREN?
==============================================================================

--- DE 4 OFFICIËLE DORA METRICS ---

1. Deployment Frequency (DF) - [Snelheid van Opleveren]
   - Betekenis: Het gemiddeld aantal uitgebrachte releases per maand.
   - Formule  : (Totaal Aantal Actieve Releases in Periode) / (Aantal Maanden in Periode)
   - Interpretatie:
     * Hoog (> 2-4 per maand): Het team levert in kleine, frequente iteraties op. 
       Dit verlaagt het risico per oplevering.
     * Laag (< 0.5 per maand): Grote 'big bang' releases. Dit verhoogt het risico 
       op fouten bij livegang.

2. Lead Time for Changes (LTC) - [Aanmaak tot Livegang]
   - Betekenis: De gemiddelde doorlooptijd van idee/verzoek tot productie.
   - Formule  : Gemiddelde van (Releasedatum - Aanmaakdatum ticket) voor alle Changes.
   - Interpretatie:
     * Kort (< 7-14 dagen): Hoge wendbaarheid. Verzoeken zijn snel live.
     * Lang (> 30-60 dagen): Mogelijke bottlenecks in refinement, testing of releaseprocedures.

3. Change Failure Rate (CFR) - [Gefaalde Releases %]
   - Betekenis: Het percentage releases dat heeft geleid tot een storing of een 
     kritieke herstelactie.
   - Formule  : (Aantal Gefaalde Releases / Totaal Aantal Releases) * 100
   - Hoe bepaalt de tool of een release FAALT? (Trechterlogica):
     Een release faalt als:
     a) Het een HOTFIX is (release bevat 0 features en minimaal 1 aangevinkte bug).
     b) AFFECTS VERSION: Een bug met aangevinkte prioriteit heeft deze release 
        expliciet in het veld 'Affects Version' staan.
     c) POST-RELEASE FALLBACK: Als 'Affects Version' leeg is, faalt de release als 
        er een kritieke bug is gemeld óp of ná de releasedatum.
   - Kleurcodering & Normen:
     * Groen (< 15%)  : Uitstekende kwaliteitscontrole.
     * Oranje (15-30%): Aandacht vereist; regelmatig storingen na livegang.
     * Rood (> 30%)   : Kritiek; releases veroorzaken te vaak instabiliteit.

4. Mean Time to Restore (MTTR) - [Aanpak tot Herstel]
   - Betekenis: De gemiddelde hersteltijd van gemelde bugs (van aanmaak tot afronding).
   - Formule  : Gemiddelde van (Resolutiondate - Created) van verwerkte bugs.
   - Interpretatie:
     * Snelle MTTR (< 24-48 uur): Hoge reactiesnelheid bij incidenten.
     * Trage MTTR (> 7-14 dagen): Herstel duurt lang; mogelijke impact op eindgebruikers.

--- KWALITEIT & CAPACITEIT INZICHT ---

5. Cycle Time [Doorlooptijd Ontwikkeling]
   - Betekenis: De gemiddelde actieve ontwikkeltijd van het moment dat aan een 
     ticket wordt gewerkt tot aan de afronding (Done status).
   - Formule  : Gemiddelde van (Resolutiondate - In Progress datum) voor Changes.
   - Databron : Wordt bepaald via de Jira changelog (statusovergang naar 'In Progress', 
     'In behandeling' of 'In ontwikkeling') of een startdatum-veld. Bij afwezigheid 
     van de changelog valt dit terug op de aanmaakdatum.
   - Interpretatie:
     * Onderscheid met LTC: Waar Lead Time for Changes (LTC) de gehele keten meet 
       (aanmaak t/m officiële release), meet Cycle Time zuiver de ontwikkeltijd van het team.

6. Defect Escape Rate [% Bugs Ontdekt in Productie]
   - Formule  : (Aantal Post-release Bugs / Totaal Aantal Bugs) * 100
   - Interpretatie: Geeft aan hoeveel procent van de bugs door het testproces 
     is 'ontsnapt' naar productie. Een hoog percentage duidt op onvoldoende 
     pre-release testing.

7. Time to Detect (MTTD) [Livegang tot Bugmelding]
   - Formule  : Gemiddelde van (Created Bug - Releasedatum Release).
   - Interpretatie: Hoe snel worden fouten na livegang ontdekt? Snelle detectie 
     (< 3 dagen) wijst op goede monitoring/telemetrie.

8. Investment Mix [Features % / Bugs %]
   - Formule  : Verhouding tussen het aantal verwerkte Changes vs. Bugs.
   - Interpretatie: 
     * Bijv. 80% / 20%: Team besteedt 80% capaciteit aan nieuwe waarde en 20% aan onderhoud.
     * Bijv. 40% / 60%: Team heeft een hoge 'technical debt' en is voornamelijk 
       bezig met brandjes blussen.

==============================================================================
6. DE GRAFIEK LEZEN (DORA TREND & RELEASE IMPACT CHART)
==============================================================================
Onderaan het dashboard bevindt zich een gecombineerde trendgrafiek:

Balken (Linker Y-as):
- Blauwe Balken : Aantal Changes / Features opgeleverd in de release.
- Rode Balken   : Aantal Bugs gekoppeld aan de release.

Achtergrond / Arceringsbalken van Releases:
- Groene achtergrondbalk : Succesvolle release (0 kritieke bugs / geen hotfix).
- Rode achtergrondbalk   : Gefaalde release (bevat een hotfix of veroorzaakte een kritieke bug).

Lijnen (Rechter Y-as):
- Oranje/Rode Lijn : Change Failure Rate (CFR %) cumulatief/trend over de tijd.
- Blauwe Lijn      : MTTR Trend over de tijd.

Hoe te gebruiken bij retrospective / teamanalyse:
- Kijk naar opeenvolgende rode releases: Welke onderwerpen of specifieke versies 
  zorgden voor uitval?
- Vergelijk de verhouding blauwe/rode balken per release om de stabiliteit per 
  oplevering te beoordelen.

==============================================================================
7. TROUBLESHOOTING & VEELGESTELDE VRAGEN
==============================================================================
V: Het teamfilter toont alle tickets als 'Onbekend'.
A: Controleer in Jira wat de exacte veldnaam is voor het team. Vul in Stap 1 van 
   het dashboard of in 'update-data.ps1' het CustomField ID in (bijv. customfield_10011).

V: Een versie heeft geen releasedatum in Jira.
A: Geen probleem. Het dashboard gebruikt een intelligente fallback: de releasedatum 
   wordt automatisch geschat op basis van het nieuwst opgeloste ticket in die versie.

V: Kan ik data van meerdere projecten combineren?
A: Ja! Je kunt in Stap 2 meerdere 'issues.json' bestanden tegelijk selecteren. 
   Het dashboard ontdubbelt automatisch dubbele tickets op basis van Issue Key.

