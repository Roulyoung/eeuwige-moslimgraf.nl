# Implementation notes

## Wat is gedaan
- Nieuwe Vite multipagina-opzet (vanilla) met gedeeld header/footer, skip-link en mobiel menu.
- Design system opgeschoond in src/styles/design-system.css + herbruikbare componenten/grids in src/styles/main.css (calm groen/zand palet, serif/sans typografie, zachte randen/schaduw).
- Alle gescrapete teksten behouden; alleen herverpakt in consistente secties en kaarten.
- Routes conform scrape opgebouwd: home, over-ons, services/diensten, contact, NL-varianten en de Arabische slug.
- Assets hergebruikt uit de scrape (public/images/*). Geen nieuwe downloads toegevoegd.

## Structuurkeuzes
- Elke route heeft een eigen index.html voor eenvoud (ook in 
l/* en de Arabische slugmap); nav-links per locale aangepast.
- Vite configuratie (ite.config.js) zet expliciet alle HTML-entrypoints voor de build.
- JS blijft minimaal: nav-toggle en smooth scroll voor interne ankers.

## Contentbehoud
- Teksten overgenomen zoals in de scrape, inclusief bestaande typografische/encoding-artefacten (niet herschreven).
- RTL-snippets behouden waar ze in de scrape stonden; Arabische pagina bevat dezelfde inhoudstructuur omdat de scrape-tekst gecorrumpeerd was.

## Bekende punten / testen
- 
pm run dev werkt lokaal; 
pm run build geeft hier spawn EPERM (esbuild start op sommige Windows-configuraties). Probeer in een gewone cmd of met AV-uitzondering voor 
ode_modules/@esbuild/win32-x64/esbuild.exe.
- Geen automatische tests aanwezig; visueel gecontroleerd op geldige linkpaden tussen pagina's.

