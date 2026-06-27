# Guida al Post-Processing con darktable

Documentazione aggregata e guida operativa al flusso di lavoro scene-referred  
in **darktable 5.4+**, pubblicata via GitHub Pages.

🔗 **Guida online**: https://lorenzoperone.github.io/darktable-docs/

---

## Struttura del progetto

```
darktable-docs/
├── docs/               # Sorgente MkDocs (Markdown)
│   ├── index.md
│   ├── images/         # Screenshot (207 immagini, aggiornati via refresh_screenshots.py)
│   ├── workflow/       # Flusso di lavoro completo
│   ├── modules/        # Moduli darktable (Exposure, Filmic, ecc.)
│   ├── color/          # Teoria del colore
│   ├── masking/        # Maschere e selezioni
│   ├── export/         # Esportazione
│   └── appendix/       # Glossario, shortcut, risorse
├── scraper/            # Script di scaricamento incrementale
│   ├── config.yaml     # Sorgenti configurate
│   ├── db.py           # Database SQLite (tracking pagine)
│   ├── downloader.py   # Crawling HTTP + html2text
│   ├── exporter.py     # Esportazione Markdown da DB
│   └── cli.py          # CLI: fetch / status / export / search
├── sources/            # Database SQLite (gitignored per dati pesanti)
├── processed/          # Markdown esportati dal DB + video-tutorials/
├── refresh_screenshots.py   # Aggiorna docs/images/ in-place (approccio A)
├── copy_screenshots_smart.py # Copia con nuovi nomi tracciabili (approccio B)
├── migrate_refs.py     # Aggiorna riferimenti .md dopo renaming (approccio B)
├── analyze_index.py    # Analisi indice globale scraper
├── generate_page.py    # Genera pagine doc via LLM
├── serve.sh            # Preview locale
├── mkdocs.yml          # Config MkDocs + Material theme
└── .github/workflows/
    ├── publish.yml     # Build + deploy → GitHub Pages
    └── scrape.yml      # Aggiornamento manuale banca dati
```

---

## Installazione

```bash
git clone https://github.com/lorenzoperone/darktable-docs.git
cd darktable-docs
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
```

---

## Uso dello scraper

```bash
# Prima esecuzione — scarica tutte le sorgenti
dt-scrape fetch

# Solo una sorgente
dt-scrape fetch --site darktable-usermanual-en

# Forza re-download anche se non modificato
dt-scrape fetch --site pixls-articles

# Vedi stato database
dt-scrape status

# Esporta Markdown da DB a processed/
dt-scrape export

# Cerca nel contenuto scaricato
dt-scrape search "filmic rgb"
dt-scrape search "white balance" --site darktable-usermanual-en
```

### Sorgenti configurate

| Nome | URL | Tipo |
|------|-----|------|
| `darktable-usermanual-en` | https://docs.darktable.org/usermanual/stable/en/ | HTML |
| `pixls-articles` | https://pixls.us/articles/ | HTML |
| `discuss-pixls` | https://discuss.pixls.us/c/software/darktable | HTML |
| `darktable-fr` | https://darktable.fr/ | HTML |
| `manualize-output` | `file:///…/manualize/output/` | Markdown locale |

---

## Anteprima locale della guida

```bash
mkdocs serve
# poi apri http://127.0.0.1:8000
```

---

## Pubblicazione (GitHub Pages)

Il workflow `.github/workflows/publish.yml` si occupa automaticamente  
del build e deploy su `gh-pages` a ogni push su `main`.

**Configurazione iniziale** (fare una volta):

1. Su GitHub: **Settings › Pages › Source** → seleziona `gh-pages` branch
2. Opzionale: aggiungi dominio personalizzato

---

## Aggiornamento banca dati via GitHub Actions

Dal tab **Actions** su GitHub → seleziona **"Aggiorna banca dati scraper"** → **Run workflow**.  
Puoi specificare la sorgente singola e il delay tra richieste.

---

## Fonti dati aggiuntive

Le analisi video vengono importate da [manualize](https://github.com/lorenzoperone/manualize),  
uno strumento autonomo che trascrive tutorial YouTube con mlx-whisper e analizza i frame con Qwen VL.

### Aggiornamento screenshot da manualize

Ogni video processato da manualize produce in `data/videos/<video-id>/`:
- `analysis.json` — screenshot con `validation.is_useful` e `utility_score`
- `screenshots/` — frame estratti dal video

#### Approccio A — Aggiornamento in-place (consigliato)

Sostituisce i file in `docs/images/` mantenendo i nomi esistenti.  
Nessuna modifica ai file `.md` necessaria.

```bash
# Anteprima
python3 refresh_screenshots.py \
  --manualize /path/to/manualize \
  --docs . \
  --dry-run --verbose

# Esecuzione reale
python3 refresh_screenshots.py \
  --manualize /path/to/manualize \
  --docs .
```

#### Approccio B — Nuovi nomi tracciabili (opzionale)

Genera file con nomi come `iaZ2-QvOHyA_agx_45s_001.jpg` e aggiorna i riferimenti `.md`.  
Richiede `requirements.json` con mappatura `{video_id: [{module, desc}]}`.

```bash
python3 copy_screenshots_smart.py \
  --manualize /path/to/manualize \
  --docs . \
  --requirements requirements.json \
  --output-report report.json

# Poi aggiorna i riferimenti (adattare report.json con mapping vecchio→nuovo)
python3 migrate_refs.py --docs . --report report.json --dry-run
```

---

*Progetto personale — Lorenzo Perone — Licenza CC BY-SA 4.0*
