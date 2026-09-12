# Alternative ad Adobe — presentazione (2 ore)

Deck da 25 slide su darktable, digiKam, Affinity e Synology Photos come alternative a
Lightroom, Photoshop, InDesign e ai servizi di hosting a canone.

**Titolo:** Uscire da Adobe senza perdere l'archivio
**Sottotitolo:** darktable, digiKam, Affinity e Synology Photos: cosa sostituisce davvero cosa, e cosa si perde per strada

## Struttura

| Blocco | Durata | Slide |
|---|---|---|
| Perché alternative | 10 min | 03 |
| darktable vs Lightroom | 20 min | 04–07 |
| digiKam | 15 min | 08–09 |
| Migrare un archivio reale | 25 min | 10–14 |
| Affinity vs Photoshop/Illustrator/InDesign | 20 min | 15–18 |
| Synology Photos vs SmugMug | 20 min | 19–22 |
| Checklist + Q&A | 20 min | 23–25 |

## Fonti dei dati

- **darktable:** `docs/workshop/from-lightroom.md` di questo repo (mapping moduli, ordine pipeline, trappole).
- **Migrazione archivio:** repo `keywords-fix` (fusione di 4 cataloghi, normalizzazione keyword, scritture protette sul DB digiKam).
- **Synology/SmugMug:** repo `smugmug2synology-photo`, `Synology_API`, `SynologyPhotosAPI`, `smugmug-backup` (migrazione reale: 386 album, 38.067 immagini).
- **Affinity:** repo `AffinityDocs` (667 pagine di documentazione ufficiale, ripartizione per area).

Le affermazioni non verificabili nei materiali del progetto (licenza Affinity, mappatura
Photoshop→Affinity Photo, funzionalità dei servizi) sono marcate come conoscenza generale
nelle slide stesse.

⚠️ Il conteggio `~204.000` è il numero di **record immagine** nel catalogo digiKam, **non
deduplicato**: la cartella SmugMug contiene in gran parte copie di scatti già presenti.
Se serve il numero di scatti unici, va ricavato dopo la fase di deduplica.

## Come rigenerare il PDF

I file `.dc.html` sono artboard di Claude Design (canvas pubblicato come Artifact).
Per produrre il PDF a 16:9 senza passare dall'editor:

```bash
cd presentations/alternative-ad-adobe
node build-pdf.mjs   # genera print.html (25 slide in iframe, una per pagina)
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless --disable-gpu --no-pdf-header-footer --virtual-time-budget=20000 \
  --print-to-pdf="$HOME/Desktop/Alternative-ad-Adobe.pdf" "file://$PWD/print.html"
```

Risultato: 25 pagine, 960×540 pt, font Google incorporati (l'export PDF dell'editor usa
invece i font di sistema di ripiego).

`canvas.json` definisce l'ordine delle slide e il layout sul canvas (griglia 5×5).
