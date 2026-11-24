# Guida al Post-Processing con darktable

Guida operativa in italiano al flusso di lavoro scene-referred in **darktable**
(version-agnostic, verificata su darktable 5.6), pubblicata via GitHub Pages.
Due anime: un **percorso didattico** (livelli, esercizi con RAW, lezioni interattive)
e un **manuale di riferimento** (moduli, colore, maschere, pipeline).

🔗 **Guida online**: https://lorenzoperone.github.io/darktable-docs/

---

## Struttura del progetto

```
darktable-docs/
├── docs/                  # Sorgente MkDocs (Markdown, ~100 pagine)
│   ├── index.md, percorso.md        # home e percorso a 3 livelli
│   ├── esercizi/          # 3 esercizi con RAW scaricabili, soluzioni passo-passo, kit tutor (zip)
│   ├── workflow/          # Flusso di lavoro (include la lezione interattiva)
│   ├── lighttable/        # Libreria: modalità, organizzazione, metadati, stili
│   ├── pipeline/          # Pixelpipe, ordine dei moduli, cronologia, preset
│   ├── modules/           # Moduli darktable (un titolo "italiano (inglese)" per pagina)
│   ├── color/  masking/  export/  preferences/
│   ├── workshop/          # Casi pratici di editing
│   ├── appendix/          # Glossario, nomi dei moduli IT/EN, scorciatoie, FAQ, risorse
│   ├── images/            # Screenshot dei moduli; images/lezioni/ = render e XMP delle lezioni
│   └── assets/            # CSS + javascripts/lesson.js (widget interattivi)
├── snippets/              # Frammenti inclusi nelle pagine (esploratori di parametro)
├── tutor/                 # Pannello Lua "tutor" per darktable (vedi tutor/README.md)
├── hooks/                 # Hook MkDocs (date di contenuto)
├── mkdocs.yml             # Config MkDocs + Material theme
├── requirements.txt
└── .github/workflows/
    ├── publish.yml        # Build + deploy → GitHub Pages (push su main)
    └── check.yml          # mkdocs build --strict su PR e rami non-main
```

Gli strumenti di lavoro descritti più sotto (scraper, linter, generazione contenuti, fact-check,
generatore delle lezioni) sono locali e non sono versionati in questo repository.

---

## Contenuti interattivi

- **Lezione interattiva e soluzioni degli esercizi**: ogni passo aggiunge un modulo alla
  cronologia (*history stack*) di una foto; le immagini sono rese **senza interfaccia grafica**
  con `darktable-cli`, troncando la cronologia XMP (`darktable:history_end`). Quindi sono
  riproducibili a ogni nuova versione e non sono screenshot. Ogni passo ha il suo XMP scaricabile
  (solo il blocco darktable, senza metadati personali) e un widget di confronto prima/dopo.
- **Esploratori di parametro**: cursori su render precalcolati (AgX contrast, esposizione,
  temperatura dell'illuminante) nelle pagine dei moduli, inclusi con `snippets/`.
- **Tutor in darktable**: per ogni lezione uno zip (`docs/esercizi/kit/`) con un pannello Lua che
  mostra le istruzioni, verifica il passo e, su richiesta, applica la soluzione. Provato su
  darktable 5.6.2; installazione nel `LEGGIMI.txt` dello zip e in `tutor/README.md`.
- **Qualità dei valori**: i default e gli intervalli citati nelle pagine si verificano contro i
  sorgenti di darktable alla versione installata e contro i preset nativi, non da memoria.

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
| `darktable-usermanual-en` | https://docs.darktable.org/usermanual/development/en/ | HTML |
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
