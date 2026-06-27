# Stili e Automazione

Preset e stili sono gli strumenti che trasformano un flusso manuale in uno veloce e consistente.[^manual-presets][^manual-styles]

## Preset vs. Stili

| | Preset | Stile |
|---|--------|-------|
| **Ambito** | Singolo modulo | Multi-modulo |
| **Auto-applicazione** | Si' (basata su EXIF) | No (manuale o batch) |
| **Formato file** | Interno al database | `.dtstyle` (esportabile) |
| **Uso tipico** | Lens correction per obiettivo, denoise per ISO | Look completo (AgX + TE + CB) |

## Creare un preset

1. Configura il modulo
2. Icona hamburger > **«Salva nuovo preset»**
3. Nome descrittivo
4. Condizioni EXIF per auto-applicazione (opzionale)

!!! tip "Organizzazione (dt 5.2+)"
    Creare sottomenu con il carattere pipe nel nome: `Paesaggio|Tramonto`, `Ritratto|Studio`.[^dt52]

### Preset auto-applicati consigliati

| Modulo | Condizione | Esempio | Valore tipico |
|--------|-----------|---------|-------------|
| **Lens correction** | Modello obiettivo | Auto per ogni lente | `lens_model = "XF16-55mmF2.8 R LM WR"` |
| **Denoise (profiled)** | ISO range | Leggero < 800, medio 800-3200, forte > 3200 | `iso_min = 100`, `iso_max = 3200`, `denoise_level = 0.35` (non-local means) |
| **Color calibration** | Corpo macchina | Profilo specifico per fotocamera | `camera_model = "FUJIFILM X-H2S"` |
| **Demosaic** | Sempre | Capture sharpening attivato[^dt54] | `sharpen = TRUE`, `sharpen_radius = 1.0`, `sharpen_amount = 0.4` |

### Parametri avanzati dei preset

Ogni preset può includere condizioni di applicazione basate su metadati EXIF. I parametri supportati includono:

| Campo EXIF | Esempio valore | Note |
|------------|----------------|------|
| `camera_model` | `"FUJIFILM X-H2S"` | Case-sensitive, deve corrispondere esattamente ai metadati RAW |
| `lens_model` | `"XF16-55mmF2.8 R LM WR"` | Richiede la versione più recente del database Lensfun |
| `iso_min` / `iso_max` | `800`, `3200` | Intervallo ISO intero (non float) |
| `exposure_time_min` | `0.002` | Espresso in secondi (1/500s = 0.002) |
| `focal_length_min` | `16` | In mm, intero |
| `aperture_min` | `2.8` | Con un solo decimale |

I preset vengono salvati nel database SQLite di darktable (`library.db`) nella tabella `presets`. Non è possibile modificarne i valori tramite editor esterni senza rischiare danni al database[^manual-presets].

## Creare uno stile

1. Edita un'immagine fino al look desiderato
2. Lighttable > modulo **Stili** > **«Crea»**
3. Seleziona solo i moduli da includere *(vedi tabella sotto)*
4. Nome significativo (es. `Paesaggio drammatico -- AgX + TE + CB warm`)

!!! danger "Sovrascrittura"
    Quando applichi uno stile in modalita' **sovrascrittura**, perdi tutta la history stack precedente. Usa sempre **«appendi»** se hai gia' regolazioni.[^manual-styles]

### Moduli raccomandati per gli stili (darktable 5.4+)

Per garantire compatibilità e risultati prevedibili, includi *solo* i moduli elencati di seguito nello stile. Altri moduli possono causare conflitti o comportamenti imprevisti.

| Modulo | Default attivo? | Perché includerlo | Range tipico |
|--------|------------------|---------------------|--------------|
| `exposure` | Sì | Base fondamentale per scene-referred | `-1.5` a `+1.5` EV |
| `color calibration` (CAT tab) | Sì | Adattamento cromatico percettivo | `temperature = 5500–7500 K`, `tint = -15–+15` |
| `filmic rgb` | No (ma fortemente raccomandato) | Tone mapping moderno | `white exposure = +2.0–+3.5 EV`, `black exposure = -2.5–-9.0 EV` |
| `tone equalizer` | No (ma utile per look artistici) | Controllo fine delle bande tonali | `lift = -0.15`, `gamma = +0.05`, `gain = +0.10` |
| `color balance rgb` | No | Bilanciamento creativo dopo CAT | `shadows = [0.95, 1.0, 1.05]`, `midtones = [1.0, 0.97, 1.03]` |
| `sharpen` | No | Sharpening finale non distruttivo | `sharpen_radius = 1.0`, `sharpen_amount = 0.3–0.6` |

> !!! info "Stili e flusso scene-referred"
> Gli stili devono essere costruiti *esclusivamente* in un flusso scene-referred (`scene-referred (agx)` o `scene-referred (sigmoid)`). L'applicazione di uno stile creato in modalità display-referred su un'immagine scene-referred produce artefatti cromatici irreversibili[^manuale-flusso-lavoro].

## Batch editing

### Copia/incolla history stack

1. Edita un'immagine master
2. ++ctrl+c++ > seleziona moduli da copiare *(vedi tabella sotto)*
3. Seleziona immagini di destinazione
4. ++ctrl+v++ > scegli **«Appendi»**[^manual-batch]

#### Moduli sicuri per il copia-incolla batch

Non tutti i moduli sono idonei per il copia-incolla. Quelli con parametri dipendenti dal contenuto dell’immagine (es. maschere, curve personalizzate) possono causare errori.

| Modulo | Sicuro per batch? | Note |
|--------|-------------------|------|
| `exposure` | ✅ Sì | Valore assoluto, indipendente dall’immagine |
| `color calibration` (CAT) | ✅ Sì | Basato su illuminante globale |
| `filmic rgb` | ✅ Sì | Funziona bene in batch se il DR della scena è simile |
| `tone equalizer` | ⚠️ Cautela | Le bande tonali devono corrispondere alla distribuzione luminosa media |
| `sharpen` | ✅ Sì | Ma regolare `sharpen_radius` in base alla risoluzione |
| `local contrast` | ❌ No | Dipende dalla struttura locale dell’immagine |
| `color zones` | ❌ No | Curve personalizzate non trasferibili tra immagini diverse |
| `retouch` | ❌ No | Maschere e cloni sono immagine-specifici |

### Metodo primary + secondary

Per serie con luce variabile:[^manual-batch]

1. **Primary grading**: Calibrazione Colore per neutralizzare ogni setup di luce  
   → Usa `color calibration` con metodo `(AI) detect from image surfaces` o `as shot in camera`
2. **Secondary grading**: Look creativo copiato su tutta la serie (solo moduli artistici)  
   → Applica in appendi uno stile con `filmic rgb`, `tone equalizer`, `color balance rgb`

> !!! tip "Workflow focus stacking"
> Per sequenze di focus stacking (es. macro), applica prima lo stile *primary grading* su tutte le immagini della serie, quindi esporta in TIFF a 16 bit senza compressione. Questo garantisce che ogni frame abbia lo stesso spazio colore e bilanciamento prima dello stacking esterno[^focus-stacking].

## Gestione prestazioni e ottimizzazione

L’efficienza del batch editing dipende fortemente dalle impostazioni di sistema. Le fonti video confermano che una configurazione ottimizzata riduce drasticamente i tempi di elaborazione.

### Impostazioni chiave per il lighttable (da Preferenze > Generale)

| Parametro | Valore consigliato | Effetto | Fonte |
|-----------|---------------------|---------|-------|
| `high quality processing from size` | `720p` | Garantisce anteprime ad alta qualità per zoom 100% | [Mac Mini M4 Pro benchmark](https://www.youtube.com/watch?v=Aqu3ULnYugw&t=270) |
| `enable disk backend for full preview cache` | `True` | Riduce il carico sulla RAM, accelera il caricamento | [iMac Intel test](https://www.youtube.com/watch?v=Aqu3ULnYugw&t=145) |
| `enable smooth scrolling for lighttable thumbnails` | `True` | Scorrimento fluido anche su cataloghi > 1000 immagini | [iMac Intel test](https://www.youtube.com/watch?v=Aqu3ULnYugw&t=145) |
| `generate thumbnails in background` | `True` | Caricamento asincrono delle miniature durante la navigazione | [iMac Intel test](https://www.youtube.com/watch?v=Aqu3ULnYugw&t=145) |

### Prestazioni del modulo Diffuse & Sharpen

Il modulo `diffuse and sharpen` (introdotto in dt 5.2) è particolarmente sensibile alle impostazioni GPU. Su macOS con chip Apple Silicon:

- Con OpenCL abilitato: velocità di elaborazione **3.2× superiore** rispetto alla CPU sola  
- Con OpenCL disabilitato: rallentamento fino al **78%** su immagini 4K[^mac-mini-m4-pro]

> !!! warning "GPU e maschere"
> Il modulo `diffuse and sharpen` non supporta maschere quando OpenCL è attivo su macOS. Per usare maschere, disabilitare OpenCL temporaneamente nelle Preferenze > Elaborazione[^mac-mini-m4-pro].

## Consigli operativi avanzati

### 1. Stili per fotografia professionale

Gli stili non devono essere “universali”: devono riflettere il tuo stile personale e il tipo di committenza.

| Tipo di lavoro | Stile consigliato | Moduli inclusi | Nota |
|----------------|--------------------|----------------|------|
| Fotografia di matrimonio | `Matrimonio – Warm Skin Tone` | `exposure`, `color calibration`, `filmic rgb`, `color balance rgb` | Priorizza accuratezza cromatica della pelle |
| Street photography | `Street – High Contrast B&W` | `exposure`, `color calibration`, `tone equalizer`, `sharpen` | Nessun `filmic rgb`: uso diretto di `tone equalizer` per controllo granulare |
| Paesaggio HDR | `Paesaggio – Extended DR` | `exposure`, `color calibration`, `filmic rgb`, `local contrast` | Solo se `local contrast` è regolato a ≤ 0.25 per evitare artefatti |

### 2. Debug degli stili non applicati

Se uno stile non si applica:

- ✅ Verifica che l’immagine sia in modalità **scene-referred** (Preferenze > Elaborazione > Flusso predefinito)  
- ✅ Controlla che i moduli inclusi nello stile siano **attivi** (icona accensione accesa)  
- ✅ Assicurati che non ci siano **moduli bloccati** (icona lucchetto chiusa) nella history stack  
- ❌ Non usare stili con `demosaic` o `highlight reconstruction`: questi moduli devono essere regolati caso per caso[^manuale-flusso-lavoro]

### 3. Backup e condivisione degli stili

Gli stili vengono salvati come file `.dtstyle` in formato XML. Per condividerli:

1. Lighttable > modulo **Stili** > clic destro sullo stile > **«Esporta»**  
2. Il file generato contiene solo i moduli selezionati e i loro parametri (nessun dato immagine)  
3. Per importare: Lighttable > modulo **Stili** > **«Importa»** > seleziona il file `.dtstyle`

> !!! info "Compatibilità cross-platform"
> I file `.dtstyle` sono pienamente compatibili tra Linux, macOS e Windows. Tuttavia, alcuni moduli (es. `diffuse and sharpen`) potrebbero mostrare leggere differenze di rendering a causa delle ottimizzazioni GPU[^mac-mini-m4-pro].

## Risorse

- [darktable User Manual — Presets](https://docs.darktable.org/usermanual/development/en/darkroom/processing-modules/presets/)  
- [darktable User Manual — Styles](https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/lighttable/styles/)  
- [darktable User Manual — Batch-editing](https://docs.darktable.org/usermanual/development/en/guides-tutorials/batch-editing/)  
- [darktable.info — Scene-Referred Workflow (2026)](https://darktable.info/en/darktable-first-steps/understand/scene-referred-workflow/)  
- [PIXLS.US — A Q&A with Photographer Riley Brandt](https://pixls.us/articles/a-q-a-with-photographer-riley-brandt/) — *Capitolo 2.21: Presets and Styles*  
- [darktable.fr — Creazione di stili](https://darktable.fr/posts/2016/03/creation-de-styles-pour-darktable/) — *Guida comunitaria in francese*  
- [t3mujinpack — Pack di stili per Fujifilm e Kodak](https://darktable.fr/categories/styles/) — *15+ stili filmici gratuiti*  

## Fonti

[^manual-presets]: *darktable User Manual -- Presets*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/darkroom/processing-modules/presets/)
[^manual-styles]: *darktable User Manual -- Styles*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/lighttable/styles/) | `processed/darktable-usermanual-en/usermanual-48-en-module-reference-utility-modules-lighttable-styles.md`
[^manual-batch]: *darktable User Manual -- Batch-editing*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/guides-tutorials/batch-editing/)
[^dt54]: *[darktable 5.4 UPDATE](https://www.youtube.com/watch?v=yiTqUgoWg6Q)* -- A Dabble in Photography
[^dt52]: *[darktable 5.2 Release](https://www.youtube.com/watch?v=YcLJMaDbfRA)* -- A Dabble in Photography
[^mac-mini-m4-pro]: *[darktable with the new Mac mini m4 pro](https://www.youtube.com/watch?v=Aqu3ULnYugw)* -- A Dabble in Photography, [05:05–07:30]
[^focus-stacking]: *[Focus stacking from darktable](https://www.youtube.com/watch?v=0rFk_k12ebE)* -- A Dabble in Photography, [01:50–04:50]
[^manuale-flusso-lavoro]: *Manuale del Flusso di Lavoro*, Aprile 2026, darktable+, Capitolo 3 — Ancoraggio Fotometrico, esposizione e calibrazione del colore
