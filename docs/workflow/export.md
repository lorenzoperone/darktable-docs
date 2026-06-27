# Esportazione

L'ultimo atto del flusso di lavoro e' la trasformazione del master in un file distribuibile. Le scelte tecniche in questa fase hanno impatto diretto sulla qualita' percepita.[^manual-export]

## Esportazione per il web

| Parametro | Valore consigliato | Note |
|-----------|-------------------|------|
| **Formato** | JPEG | Universalmente supportato; compressione lossy ottimizzata per visualizzazione su schermo[^manual-export] |
| **Qualita'** | 85-90 | Valori superiori non producono benefici visibili[^firststeps]; valori inferiori a 75 introducono artefatti visibili in aree omogenee (cielo, pelle)[^manual-export] |
| **Profilo colore** | sRGB | Obbligatorio per la corretta visualizzazione nei browser; AdobeRGB non è interpretato correttamente da Chrome/Firefox/Safari[^output-profile] |
| **Dimensione** | 2048px lato lungo | 1080px lato corto per Instagram; per Twitter/X: 1200×675px (16:9); per Facebook: 1200×630px[^manual-export] |
| **Ricampionamento** | Lanczos3 | Migliore qualita'; `Bicubic` accettabile per esportazioni veloci; `Nearest Neighbor` solo per pixel-art[^manual-export] |
| **Dithering** | Abilitato | Necessario per prevenire banding in cieli e ombre graduali quando si esporta in 8-bit[^dither-or-posterize] |

!!! tip "Multi-preset (dt 5.2+)"
    Nel modulo Esporta, le selezioni multi-preset restano in memoria tra le foto, permettendo esportazioni sequenziali senza tornare al Lighttable.[^dt52]

!!! warning "Verifica sovrascrittura"
    Verificare l'opzione di sovrascrittura prima di esportare per non perdere file precedenti.[^firststeps]

### Esempio pratico: Web gallery responsive
Per generare una galleria web con tre versioni (thumbnail, medium, full), crea tre preset:
- `web/thumbnail`: JPEG, qualità 80, dimensione massima 400px, `store_masks=no`, `high_quality_resampling=yes`
- `web/medium`: JPEG, qualità 85, dimensione massima 1200px, `profile=sRGB`, `intent=perceptual`
- `web/full`: JPEG, qualità 90, dimensione massima 2048px, `dpi=72`, `allow_upscaling=no`

Usa il modulo **Stili** per applicare un watermark testuale (`$(FILE.NAME) | $(YEAR)`), attivato *solo* nel preset `web/thumbnail` tramite opzione `style` nel modulo Esporta[^manual-export].

## Esportazione per la stampa

| Parametro | Valore consigliato | Note |
|-----------|-------------------|------|
| **Formato** | TIFF 16-bit | Massima qualita'; JPEG alta qualita' se richiesto; EXR per archiviazione HDR[^manual-export] |
| **Profilo colore** | AdobeRGB | Stampa offset; profilo ICC stampante se disponibile (da caricare in `$HOME/.config/darktable/color/out/`)[^output-profile] |
| **Risoluzione** | 300 DPI min | 600 DPI per grande formato o archiviazione; impostabile direttamente in cm/inches[^manual-export] |
| **Sharpening** | Dose extra | La carta assorbe l'inchiostro ammorbidendo l'immagine; applica sharpening *dopo* il ricampionamento[^manual-export] |
| **Compressione** | LZW o ZIP | Compressione senza perdite; `deflate with predictor` per TIFF 16-bit[^darktable-cli] |
| **Dithering** | Disabilitato | Non necessario in 16-bit; può introdurre rumore indesiderato[^dither-or-posterize] |

darktable permette di specificare le dimensioni in cm o pollici, calcolando automaticamente i pixel.  
Esempio: per una stampa 30×45 cm a 300 DPI → `max size = 30 cm × 45 cm`, `dpi = 300` → output di **3543 × 5315 px**.

## Archivio master

Per l'archivio a lungo termine:

- **Formato**: TIFF 16-bit o EXR  
- **Profilo**: ProPhoto RGB  
- **Risoluzione**: Originale del sensore  
- **Compressione**: Senza perdite (LZW per TIFF, PIZ per EXR)[^darktable-cli]  
- **Metadati**: `exif data`, `metadata`, `develop history`, `geo tags` abilitati[^manual-export]  
- **Masks**: `store_masks=yes` per TIFF/EXR/XCF[^manual-export]  

Questo file master sara' il punto di partenza per qualsiasi futura ri-esportazione.  
⚠️ **Attenzione**: L’embedding della storia di sviluppo (`develop history`) funziona solo con formati che supportano XMP (JPEG, TIFF, JPEG2000, JXL). Non è supportato da PNG o WebP[^manual-export].

## Esportazione batch

Nel tavolo luminoso, seleziona tutte le immagini, configura il modulo Esportazione e premi **«Esporta»**. darktable elabora tutte le immagini in coda, usando tutti i core della CPU.[^manual-export]

!!! info "Performance"
    L'esportazione di 100 foto a piena risoluzione con tutti i moduli attivi puo' richiedere 15-30 minuti su un MacBook Pro M3. OpenCL accelera significativamente il processo.

### Ottimizzazione avanzata per batch
- Abilita `high_quality_resampling=yes` solo se ridimensioni *verso il basso* (evita doppio ricampionamento)[^manual-export]  
- Imposta `allow_upscaling=no` per prevenire interpolazioni indesiderate  
- Usa `on conflict = overwrite if changed` per aggiornare solo i file modificati dopo l’ultima esportazione[^manual-export]  
- Per batch > 500 immagini, disattiva `store_masks` e `develop history` per ridurre tempo e spazio su disco  

## Preset, Stili e Automazione

### Preset: singolo modulo

Un preset e' un insieme salvato di impostazioni per un singolo modulo:[^manual-presets]

1. Configura il modulo come desideri  
2. Clicca sull'icona hamburger a destra del nome del modulo  
3. Seleziona **«Salva nuovo preset»**  
4. Configura l'applicazione automatica basata su EXIF (obiettivo, ISO range)  

!!! tip "Organizzazione (dt 5.2+)"
    Creare sottomenu personalizzati per i preset usando il carattere pipe (`|`) nel nome (es. `Paesaggio|Tramonto morbido`).[^dt52]

### Stili: ricetta completa

Uno stile e' una raccolta di impostazioni multi-modulo:[^manual-styles]

1. Edita un'immagine fino al look desiderato  
2. Nel tavolo luminoso, modulo **«Stili»** > **«Crea»**  
3. Seleziona solo i moduli da includere  
4. Nome significativo (es. «Paesaggio drammatico -- AgX + TE + CB warm»)  

!!! danger "Modalita' sovrascrittura"
    Quando applichi uno stile in modalita' «sovrascrittura» perdi tutta la history stack precedente. Usa **sempre «appendi»** se hai gia' fatto regolazioni.

### Batch editing a due fasi

Per serie con condizioni di luce variabili:[^manual-batch]

**Fase 1 -- Primary color grading (neutralizzazione)**

1. Color checker o superficie grigia per ogni setup di luce  
2. Calibrazione Colore per estrarre un profilo  
3. Copia e incolla su tutte le foto dello stesso setup  

**Fase 2 -- Secondary color grading (look artistico)**

1. Look creativo su un'immagine di riferimento  
2. Copia solo i moduli artistici (NON la calibrazione colore)  
3. Incolla in modalita' **Appendi** su tutta la serie  

!!! tip "Fine-tuning"
    Barra spaziatrice per navigare tra le foto nella camera oscura, micro-aggiustamenti foto per foto dopo il batch paste. E' il metodo piu' efficiente.[^manual-batch]

## Parametri dettagliati del modulo Export

Il modulo **Export** dispone di 4 sezioni principali, ciascuna con parametri critici:

### 📁 Storage options
| Parametro | Range/Valori | Default | Note |
|-----------|------------|---------|------|
| `target storage` | `file on disk`, `LaTeX book`, `web album`, `email` | `file on disk` | I plugin Lua possono aggiungere nuovi backend (es. `scp_export`)[^exporting-images-lua] |
| `filename template` | Variabili dinamiche (vedi tabella sotto) | `${FILE_FOLDER}/darktable_exported/${FILE_NAME}` | Supporta 50+ variabili come `$(YEAR)`, `$(TAGS)`, `$(WIDTH.EXPORT)`[^variables] |
| `on conflict` | `create unique filename`, `overwrite`, `overwrite if changed`, `skip` | `create unique filename` | `overwrite if changed` confronta timestamp XMP vs filesystem[^manual-export] |

### 📄 Format options
| Parametro | Range/Valori | Default | Note |
|-----------|------------|---------|------|
| `file format` | `JPEG`, `TIFF`, `PNG`, `WebP`, `JXL`, `EXR`, `PDF`, `XCF`, `PPM`, `PFM`, `copy` | `JPEG` | JXL offre compressione lossless con rapporto 2:1 rispetto a TIFF 16-bit[^darktable-cli] |
| `quality` | JPEG/WebP/JXL: `5–100`; J2K: `5–100`; PDF: n/a | `95` | Per JPEG: `85` per web, `95` per stampa, `100` solo per archivio temporaneo[^manual-export] |
| `bit depth` | `8`, `16`, `32` (dipende dal formato) | `8` (JPEG), `16` (TIFF) | `32` disponibile solo per EXR e XCF[^darktable-cli] |
| `compression` | `none`, `LZW`, `ZIP`, `deflate`, `PIZ`, `DWAA`, ecc. | dipende dal formato | `PIZ` è ottimale per EXR con dati HDR[^darktable-cli] |

### 🌐 Global options
| Parametro | Range/Valori | Default | Note |
|-----------|------------|---------|------|
| `set size` | `in pixels`, `in cm`, `in inch`, `by scale` | `in pixels` | `in cm` e `in inch` calcolano automaticamente i pixel in base al `dpi`[^manual-export] |
| `dpi` | `1–5000` | `300` (se usato `in cm/inch`) | Memorizzato in Exif e utilizzato dai software di stampa[^manual-export] |
| `max size` | `0–∞` px/cm/inch | `0 × 0` | `0` = nessun limite; `max size = 0 × 0` = esporta originale[^manual-export] |
| `allow upscaling` | `yes`/`no` | `no` | Mai abilitare per fotografia reale: introduce artefatti irreversibili[^manual-export] |
| `high quality resampling` | `yes`/`no` | `no` | Abilitare solo per downscale; rallenta del 20–40% ma migliora nitidezza[^manual-export] |
| `store masks` | `yes`/`no` | `no` | Solo per TIFF/EXR/XCF; utile per ritocchi successivi in GIMP/Krita[^manual-export] |
| `profile` | `image settings`, `sRGB`, `AdobeRGB`, `ProPhoto RGB`, `XYZ`, `linear RGB` | `image settings` | `image settings` rispetta il modulo `output color profile`[^output-profile] |
| `intent` | `perceptual`, `relative colorimetric`, `saturation`, `absolute colorimetric` | `perceptual` | `relative colorimetric` preferito per stampa professionale[^output-profile] |
| `style` | Nome di uno stile salvato | `(none)` | Applica lo stile *temporaneamente* all’export[^manual-export] |
| `mode` | `replace history`, `append` | `replace history` | `append` mantiene la history originale[^manual-export] |

### 🏷️ Metadata preferences
Accessibile tramite pulsante **«preferences…»**, gestisce l’embedding dei metadati:
- **Gruppi esportati**: `exif data`, `metadata`, `geo tags`, `tags`, `hierarchical tags`, `develop history`  
- **Controllo fine**: per ogni campo Exif/IPTC/XMP, definisci una formula (es. `$(EXIF.YEAR)-$(EXIF.MONTH)` per `Iptc.Application2.DateCreated`)[^manual-export]  
- **Attenzione**: `develop history` può fallire silenziosamente su file grandi (>100 MB) — non affidarsi per backup[^manual-export]  

### Tabella variabili per `filename template`
| Categoria | Esempi | Uso tipico |
|----------|--------|-------------|
| **File system** | `$(FILE.FOLDER)`, `$(FILE.NAME)`, `$(FILE.EXTENSION)` | Organizzazione cartelle (`${FILE.FOLDER}/web/${FILE.NAME}.jpg`) |
| **Data/ora** | `$(YEAR)`, `$(MONTH)`, `$(DAY)`, `$(HOUR)` | Archiviazione cronologica (`${YEAR}/${MONTH}/${FILE.NAME}`) |
| **Esposizione** | `$(EXIF.ISO)`, `$(EXIF.APERTURE)`, `$(EXIF.EXPOSURE)` | Naming tecnico (`${FILE.NAME}_ISO$(EXIF.ISO)_f$(EXIF.APERTURE).jpg`) |
| **Geolocalizzazione** | `$(LATITUDE)`, `$(LONGITUDE)`, `$(GPS.LOCATION)` | Catalogazione geografica (`${GPS.LOCATION}/${FILE.NAME}`) |
| **Tagging** | `$(TAGS)`, `$(CATEGORY0(places))`, `$(CATEGORY1(places))` | Strutture gerarchiche (`${CATEGORY0(places)}/${CATEGORY1(places)}/${FILE.NAME}`)[^variables] |

## Consigli operativi avanzati

### ✅ Workflow sicuro per esportazioni ripetute
1. Crea un preset `backup/master` con: `format=TIFF`, `bit depth=16`, `profile=ProPhoto RGB`, `store_masks=yes`, `develop history=yes`  
2. Usa `on conflict = skip` per evitare sovrascritture accidentali  
3. Attiva `metadata > exif data` e `metadata > metadata` per conservare informazioni critiche  
4. Salva sempre il preset con nome descrittivo e data (es. `backup/master_2024-04`)  

### ⚙️ Automazione CLI per server/stampa batch
Per esportazioni non interattive (es. script di backup notturno):
```bash
darktable-cli \
  /home/user/raw/ \
  /home/user/export/ \
  --width 3543 \
  --height 5315 \
  --hq true \
  --out-ext tif \
  --core --conf plugins/imageio/format/tiff/compress=2 \
  --core --conf plugins/imageio/format/tiff/bpp=16
```
Questo comando esporta tutte le immagini RAW in TIFF 16-bit 30×45 cm (300 DPI), con compressione ZIP e ricampionamento ad alta qualità[^darktable-cli].

### 🛑 Risoluzione problemi comuni
- **Errore “ICC profile not found”**: verifica che il profilo sia in `$HOME/.config/darktable/color/out/` e riavvia darktable[^output-profile]  
- **Esportazione lenta con OpenCL abilitato**: disattiva `high_quality_resampling` o usa `--core --disable-opencl`[^manual-export]  
- **File esportati troppo piccoli**: controlla `max size` — se entrambi i valori sono `0`, darktable esporta a risoluzione nativa *dopo il crop*, non prima[^manual-export]  
- **Tag gerarchici non esportati**: assicurati che `hierarchical tags` sia abilitato *e* che `tags` abbia la casella `omit hierarchy` deselezionata[^manual-export]  

## Walkthrough da video tutorial

### Esempio: Esportazione rapida da Camera Oscura
*Da [darktable first steps ep01](https://www.youtube.com/watch?v=P4cL61ZHqFw) (00:04:12)*  
1. Apri un’immagine in **Camera Oscura**, applica correzioni base (es. bilanciamento bianco, esposizione +0.3 EV, contrasto +12)  
2. Premi `Ctrl+E` per aprire il modulo **Export** senza lasciare la Camera Oscura  
3. Imposta `file format = JPEG`, `quality = 85`, `profile = sRGB`, `max size = 1920 × 1080`  
4. Inserisci nel `filename template`: `${FILE.FOLDER}/web/${FILE.NAME}_web.jpg`  
5. Clicca **«Export»**: il file viene salvato immediatamente, senza passare dal Lighttable[^firststeps]

### Esempio: Stampa 30×40 cm con profilo ICC personalizzato
*Da [New Release: darktable 5.2](https://www.youtube.com/watch?v=YcLJMaDbfRA) (00:11:28)*  
1. Scarica il profilo ICC della tua stampante (es. `CanonPRO-1000-PhotoPaperPro-2023.icc`)  
2. Copialo in `$HOME/.config/darktable/color/out/` e riavvia darktable  
3. Nel modulo **Export**, imposta `set size = in cm`, `width = 30.0`, `height = 40.0`, `dpi = 300`  
4. Imposta `profile = CanonPRO-1000-PhotoPaperPro-2023.icc`, `intent = relative colorimetric`  
5. Seleziona `file format = TIFF`, `bit depth = 16`, `compression = ZIP`  
6. Clicca **«Export»**: l’output sarà perfettamente calibrato per quella carta e stampante[^dt52]

## Domande frequenti

### Problema: Esportazione con `store_masks=yes` fallisce su TIFF senza errore visibile
Quando `store_masks` è abilitato per TIFF, darktable tenta di scrivere i layer maschera come canali aggiuntivi. Se il file TIFF supera i 4 GB (limite del formato TIFF 32-bit), l’esportazione fallisce in silenzio senza messaggio. Soluzione: usare `EXR` o `XCF` per file > 2 GB, oppure disattivare `store_masks` e salvare le maschere separatamente in XMP[^manual-export].

### Problema: Il watermark non appare nell’esportazione anche se configurato nello stile
Lo stile contiene il modulo **Watermark**, ma l’opzione `show watermark` è disattivata nel modulo **Watermark** stesso. Perché venga esportato, `show watermark` deve essere attivato *nello stile* (non solo nel modulo attivo). Verifica che lo stile includa anche questo flag: `watermark.show_watermark=1`[^manual-export].

### Problema: `$(CATEGORY0(places))` restituisce stringa vuota nonostante il tag esista
La variabile `$(CATEGORY0(places))` funziona solo se il tag `places` è stato definito come **categoria** (non semplice tag) e se almeno un’immagine selezionata ha un tag figlio (es. `places|Italia`). Se `places` è un nodo libero o non ha figli, la variabile rimane vuota. Usa `$(TAGS)` per ottenere tutti i tag associati[^variables].

## Risorse

- [darktable User Manual — Export](https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/lighttable/export/)  
- [darktable User Manual — Variables](https://docs.darktable.org/usermanual/development/en/special-topics/variables/)  
- [darktable CLI Reference](https://docs.darktable.org/usermanual/development/en/special-topics/program-invocation/darktable-cli/)  
- [darktable Lua Scripting Guide](https://docs.darktable.org/usermanual/development/en/lua/exporting-images/)  

## Fonti

[^manual-export]: *darktable User Manual -- Export*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/lighttable/export/) | Copia locale: `processed/darktable-usermanual-en/usermanual-48-en-module-reference-utility-modules-lighttable-export.md`
[^manual-presets]: *darktable User Manual -- Presets*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/darkroom/processing-modules/presets/)
[^manual-styles]: *darktable User Manual -- Styles*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/lighttable/styles/) | Copia locale: `processed/darktable-usermanual-en/usermanual-48-en-module-reference-utility-modules-lighttable-styles.md`
[^manual-batch]: *darktable User Manual -- Batch-editing images*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/guides-tutorials/batch-editing/)
[^firststeps]: *[darktable first steps ep01](https://www.youtube.com/watch?v=P4cL61ZHqFw)* -- A Dabble in Photography
[^dt52]: *[New Release: darktable 5.2](https://www.youtube.com/watch?v=YcLJMaDbfRA)* -- A Dabble in Photography
[^exporting-images-lua]: *darktable User Manual — Exporting images with lua*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/lua/exporting-images/)
[^variables]: *darktable User Manual — Variables*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/special-topics/variables/)
[^darktable-cli]: *darktable User Manual — darktable-cli*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/special-topics/program-invocation/darktable-cli/)
[^output-profile]: *darktable User Manual — Output color profile*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/output-color-profile/)
[^dither-or-posterize]: *darktable User Manual — Dither or posterize*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/dither-or-posterize/)
