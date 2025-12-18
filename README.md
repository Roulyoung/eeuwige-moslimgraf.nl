# Eeuwige Islamitische Begraafplaats - Redesign

Statische, meerpagina-site op Vite (vanilla). Content uit de scrape is intact gehouden en in een rustige, herbruikbare layout gegoten.

## Installeren en draaien

```bash
npm install
npm run dev
npm run build
npm run preview
```

> Tip: draait als multipagina-build via `vite.config.js`. Als Windows een `spawn EPERM` melding geeft bij `npm run build`, probeer hetzelfde commando in een normale `cmd` of controleer of antivirus `esbuild` niet blokkeert.

## GitHub Pages

- Deploy gebeurt via `.github/workflows/deploy-pages.yml` (build → upload `dist` → deploy).
- URLs en assets in de HTML gebruiken `%BASE_URL%...` zodat het werkt op zowel project-pages (`/eeuwige-moslimgraf.nl/`) als een custom domain (`/`).

## Pagina's / routes

- `/` (home)
- `/over-ons/`
- `/services/`
- `/contact/`
- `/nl/home-nl/`, `/nl/overons-nl/`, `/nl/servicesnl/`, `/nl/contactnl/`
- `/%d8%a8%d8%b4%d8%b1%d9%8a-%d9%84%d9%85%d8%b3%d9%84%d9%85%d9%8a-%d9%87%d9%88%d9%84%d9%86%d8%af%d8%a7/`

## Structuur

- `index.html` + mapjes per route (boven) met eigen `index.html`.
- `src/styles/design-system.css` en `src/styles/main.css` - kleuren, typografie, spacing, componenten.
- `src/main.js` - eenvoudige navigatie-toggle en smooth scroll voor interne ankers.
- `public/images/` - lokale assets uit de scrape.
- `docs/` - aanvullende notities en audits.

## Toetsen / toegankelijkheid

- Semantische layout, focus states, skip-link.
- Responsief grid voor kaarten, galerijen en kolommen.

