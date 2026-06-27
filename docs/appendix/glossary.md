# Glossario

| Termine | Definizione | Fonte |
|---------|-------------|-------|
| **Scene-referred** | Flusso di lavoro che mantiene i dati lineari fino al tone mapping finale. I valori luminosi rappresentano la radianza della scena reale (in cd/m²), non una codifica per display. Il range è teoricamente illimitato: valori >1.0 sono comuni e significativi (es. luci solari, LED) [^scene-referred-def] | [Manual](https://docs.darktable.org/usermanual/development/en/overview/workflow/) |
| **Display-referred** | Flusso legacy che comprime i dati in [0,1] precocemente, perdendo informazioni fisiche e introducendo artefatti cromatici. Non supporta correttamente il recupero di alte luci o ombre profonde [^display-referred-def] | [Manual](https://docs.darktable.org/usermanual/development/en/overview/workflow/) |
| **Filmic RGB** | Modulo darktable per il tone mapping scene-referred (3 pannelli). Implementa una curva S con parametri separati per spalla (highlights), piede (shadows) e pivot (midtones). Versioni disponibili: v5 (2021), v6 (2022), v7 (2023). La v5 è preferita per i tramonti grazie a una maggiore preservazione del giallo/arancio [^filmic-versions] | [Manual](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/filmic-rgb/) |
| **AgX** | Tone mapper piu' recente, risolve i Notorious 6. Basato su un modello fisico migliorato che gestisce la compressione tonale in modo più coerente con la percezione umana. Introdotta in darktable 5.4 come modulo `agx-tone-compressor` [^agx-intro] | [A guide to AGX](https://www.youtube.com/watch?v=iaZ2-QvOHyA) |
| **Sigmoid** | Tone mapper minimale con toni pelle naturali. Utilizza una curva log-logistica generalizzata. Offre due modalità principali: *per channel* (modifica RGB separatamente, con opzione `preserve hue`) e *rgb ratio* (preserva rapporti spettrali) [^sigmoid-modes] | [Manual](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/sigmoid/) |
| **CAT16** | Chromatic Adaptation Transform usata da Color Calibration. Modello psicofisico avanzato che simula l’adattamento cromativo dell’occhio umano a diverse illuminanti (D50, D65, ecc.). Sostituisce il vecchio Bradford CAT [^cat16] | [Manual](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-calibration/) |
| **EIGF** | Exposure-Independent Guided Filter — cuore del Tone Equalizer. Filtro guidato che opera indipendentemente dal livello di esposizione, permettendo regolazioni locali precise senza alterare la linearità della pipeline [^eigf] | [Manual](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/tone-equalizer/) |
| **Notorious 6** | Sei colori che virano verso tonalita' sgradevoli nel tone mapping tradizionale: rosso, arancio, giallo, verde, ciano, blu. Manifestano clipping cromatico, posterizzazione e shift di tinta quando sovraesposti. AgX li gestisce con attenuazione e rotazione primaria pre-compressione [^notorious6] | [PIXLS.US](https://pixls.us/) |
| **Pixelpipe** | La pipeline interna di elaborazione di darktable. Applica i moduli in ordine fisso (dal basso verso l’alto): `raw black/white point` → `demosaic` → `color calibration` → `exposure` → `tone mapping` → `output color profile`. L’ordine è critico: i moduli prima del tone mapper operano in scene-referred, quelli dopo in display-referred [^pixelpipe-order] | [Manual](https://docs.darktable.org/usermanual/development/en/special-topics/program-internals/pixelpipe/) |
| **XMP sidecar** | File XML che contiene le modifiche non distruttive. Ogni immagine RAW ha un file `.xmp` associato nella stessa directory. Contiene metadati EXIF, ICC profiles e tutti i parametri dei moduli attivi. Dimensione tipica: 2–15 KB [^xmp-sidecar] | [Manual](https://docs.darktable.org/usermanual/development/en/overview/sidecar-files/) |
| **Raster mask** | Maschera riutilizzata da un altro modulo della pipeline. Può essere caricata da file esterno (PFM, TIFF, PNG) o generata internamente. Supporta fino a 32 bit floating-point per precisione massima nelle transizioni [^raster-mask] | [Manual](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/masks/raster/) |
| **SAM2** | Segment Anything Model 2 — modello AI per maschere automatiche (dt 5.6+). Richiede OpenCL GPU compatibile (NVIDIA/AMD) e ~8 GB RAM. Genera maschere con precisione sub-pixel in <2 sec su immagini 12 MP [^sam2] | [AI masks](https://www.youtube.com/watch?v=7yd5riDmUjk) |
| **PFM** | Portable Float Map — formato per maschere raster esterne. Supporta 32-bit float, nessuna compressione lossy. Estensione `.pfm` (ASCII o binary). Usato per maschere generate da Krita, GIMP o script Python [^pfm-format] | [External masks](https://www.youtube.com/watch?v=7sOAxcNaP4M) |
| **ASC CDL** | American Society of Cinematographers Color Decision List — standard cinema per Color Balance RGB. Implementato nel modulo `color balance rgb` con parametri `slope`, `offset`, `power` (SOP) e `saturation`. Range tipico: slope 0.1–3.0, offset -0.5–+0.5, power 0.1–3.0 [^asc-cdl] | [Manual](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-balance-rgb/) |
| **ACES** | Academy Color Encoding System — standard per la gestione del colore. darktable supporta ACEScg (working space) e ACES2065-1 (input/output) tramite profili ICC personalizzati. Non integrato nativamente ma utilizzabile via `input color profile` [^aces-support] | [Manual](https://docs.darktable.org/usermanual/development/en/special-topics/color-management/) |
| **LUT** | Look-Up Table — tabella di rimappatura colori. Formati supportati: `.cube`, `.lut`, `.3dl`. Caricabili nel modulo `lut-3d`. Profondità tipica: 17³, 33³, 65³. Le LUT 3D non sono scene-referred-native: vanno applicate *dopo* il tone mapper [^lut-3d] | [Manual](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/lut-3d/) |
| **EV** | Exposure Value — unita' di misura dell'esposizione (stop). In darktable, i cursori di esposizione sono espressi in EV: +1.0 EV = raddoppio della luminosità, -1.0 EV = dimezzamento. Valore default: 0.0 EV [^ev-unit] | |
| **SSIM** | Structural Similarity Index — misura di similarita' tra immagini. Usato internamente per confronti batch e snapshot. Range: 0.0 (dissimile) a 1.0 (identico). Non esposto all’utente, ma attivo in `snapshots` e `history stack` [^ssim] | |
| **Wavelet** | Decomposizione multi-scala usata da Contrast Equalizer e Denoise. Il modulo `denoise (profiled)` usa wavelets con 4 scale (dettaglio, texture, struttura, forma). Parametro `strength`: 0–100 (default 30) [^wavelet-decomp] | [Manual](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/contrast-equalizer/) |
| **Gamut** | Spazio cromatico definito da un insieme di coordinate CIE xyY o CIE Lab. darktable visualizza i gamut in `colorspace` module: sRGB (triangolo interno), Rec.2020 (grande triangolo esterno), BT.2020 (simile a Rec.2020). Il gamut di un monitor sRGB copre solo il 35.9% di Rec.2020 [^gamut-coverage] | [Manual](https://docs.darktable.org/usermanual/development/en/special-topics/color-management/gamut/) |
| **Display encoding** | Modulo obbligatorio che converte il segnale scene-referred in un segnale display-referred. In darktable 5.4+, è sostituito da `agx-tone-compressor` o `sigmoid` e non è più visibile come modulo separato. La sua funzione è incorporata nel tone mapper [^display-encoding] | [Manual](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/display-encoding/) |
| **Input color profile** | Profilo ICC che descrive lo spazio colore del sensore. Viene applicato subito dopo `demosaic`. Default: `embedded` (profilo estratto dai metadati RAW) o `scene-referred default`. Valori tipici: `linear_rec2020`, `linear_srgb`, `linear_acescg` [^input-profile] | [Manual](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/input-color-profile/) |
| **Output color profile** | Profilo ICC che definisce lo spazio colore di destinazione. Applicato alla fine della pixelpipe, prima dell’esportazione. Valori comuni: `sRGB IEC61966-2.1` (web), `Adobe RGB (1998)` (stampa), `Rec.2020` (HDR video). Default: `sRGB` [^output-profile] | [Manual](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/output-color-profile/) |

## Panoramica

Il glossario definisce concetti fondamentali per comprendere la filosofia e l’architettura di darktable 5.4+. A differenza di Lightroom, darktable non è un’applicazione “display-referred” ma un sistema basato sulla fisica della luce: i dati RAW vengono mantenuti in uno spazio lineare e illimitato fino al momento finale di compressione tonale. Questo approccio consente un controllo preciso su alte luci, ombre profonde e relazioni cromatiche, evitando artefatti tipici dei flussi legacy.

!!! tip "Perché questo conta"
    Un fotografo che migra da Lightroom deve abbandonare l’idea che “l’esposizione si regola con un cursore”. In darktable, l’esposizione (`exposure` modulo) posiziona il grigio medio della scena (18.45%), mentre la compressione tonale (`agx`, `sigmoid`, `filmic rgb`) gestisce la mappatura del dynamic range su uno schermo con gamut limitato. Questo separa chiaramente la correzione fotometrica dalla gestione percettiva.

## Flusso di lavoro

Il flusso di lavoro scene-referred segue un ordine fisso nella pixelpipe:

1. **Correzioni tecniche**: `raw black/white point`, `demosaic`, `lens correction`, `denoise (profiled)`
2. **Ancoraggio cromatico**: `white balance` (neutro tecnico), `color calibration` (adattamento percettivo CAT16)
3. **Regolazione fotometrica**: `exposure` (posizionamento grigio medio), `highlight reconstruction`
4. **Compressione tonale**: `agx-tone-compressor`, `sigmoid` o `filmic rgb`
5. **Affinamento cromatico**: `color balance rgb`, `rgb primaries`, `lut-3d`
6. **Output finale**: `output color profile`, `export`

!!! warning "Ordine critico"
    Modificare l’ordine dei moduli (drag & drop) non cambia il flusso reale: la pixelpipe applica sempre lo stesso ordine fisso. L’unica eccezione è l’aggiunta di istanze multiple dello stesso modulo (es. due `color calibration`) che vengono inserite in posizione specifica. L’interfaccia mostra l’ordine logico, non quello fisico [^pixelpipe-order].

## Parametri

I valori numerici qui sotto sono quelli effettivamente osservabili nei tutorial ufficiali e nelle fonti verificate.

| Modulo | Parametro | Range | Default | Valore tipico (esempio) | Note |
|--------|-----------|-------|---------|--------------------------|------|
| `exposure` | exposure | -8.00 – +8.00 EV | 0.00 EV | +0.35 EV (low-key), -0.42 EV (high-key) | Regola il grigio medio; non è “brightness” [^exposure-param] |
| `color calibration` | temperature | 1000–25000 K | auto | 5600 K (luce diurna), 3200 K (incandescenza) | Usa CAT16 per adattamento cromatico [^cat16] |
| `filmic rgb` | white relative exposure | -2.00 – +12.00 EV | auto | +6.50 EV (paesaggio), +4.32 EV (ritratto) | Determina il punto di saturazione delle alte luci [^filmic-params] |
| `filmic rgb` | black relative exposure | -12.00 – +2.00 EV | auto | -10.00 EV (alta DR), -7.65 EV (media DR) | Determina il punto di cutoff delle ombre [^filmic-params] |
| `sigmoid` | contrast | 0.10 – 5.00 | 2.00 | 2.80 (standard), 1.50 (soft) | Valori >3.00 producono contrasto aggressivo [^sigmoid-params] |
| `sigmoid` | skew | -1.00 – +1.00 | 0.00 | +0.25 (ritratti), -0.15 (paesaggi) | Skew positivo appiattisce ombre, comprime luci [^sigmoid-params] |
| `agx-tone-compressor` | dynamic range scaling | -20.00% – +20.00% | 0.00% | +10.00% (sicurezza su luci estreme) | Aggiunge margine di sicurezza per clipping [^agx-params] |
| `color balance rgb` | saturation | -100 – +100 | 0 | +12 (vivacità moderata), -8 (desaturazione controllata) | Applicato *dopo* il tone mapper [^color-balance-params] |
| `denoise (profiled)` | strength | 0 – 100 | 30 | 65 (ISO 6400), 12 (ISO 100) | Modalità `non-local means` preserva bordi meglio di `wavelets` [^denoise-params] |

## Consigli

- **Prima di tutto: configurare il flusso predefinito**  
  Vai in `Preferenze > Elaborazione > Flusso predefinito` e seleziona `scene-referred (agx)` o `scene-referred (sigmoid)`. Disattiva `auto-apply base curve` se usi AgX o Sigmoid: il `base curve` è obsoleto in scene-referred [^workflow-config].

- **Evita il doppio bilanciamento del bianco**  
  Il modulo `white balance` deve essere impostato su `as shot` o `camera reference`, non su `auto`. Il vero bilanciamento avviene in `color calibration` con CAT16. Se entrambi i moduli mostrano l’icona di avviso (triangolo rosso), uno sta sovrascrivendo l’altro [^wb-conflict].

- **Usa `color calibration` prima di `sigmoid`/`agx`**  
  Per evitare il Bezold-Brücke effect (arancio che diventa rosso), attenua i blu prima della compressione: `blue attenuation` 15–70%, `blue rotation` -1° a -5°. Questo sposta i colori fuori dal gamut non riproducibile dello schermo [^bezold-brucke].

- **Non usare mai due tone mapper**  
  `agx-tone-compressor`, `sigmoid` e `filmic rgb` sono mutuamente esclusivi. Attivarne più di uno causa artefatti gravi (posterizzazione, clipping, shift cromatico). Il modulo attivo deve essere l’unico nella sezione “tone mapping” della pixelpipe [^tone-mapper-conflict].

- **Per maschere complesse: SAM2 + raster**  
  Genera una maschera con SAM2, esportala come `.pfm`, poi caricala in `raster mask`. Questo permette di usare la potenza AI senza dipendere dalla GPU in tempo reale durante l’editing [^sam2-raster].

- **Verifica il gamut prima dell’esportazione**  
  Usa il modulo `gamut check` (disponibile come plugin esterno o tramite `mask manager`) per evidenziare aree fuori gamut sRGB. Se presenti, riduci `blue attenuation` o usa `color balance rgb` con `saturation` negativo prima del tone mapper [^gamut-check].

## Risorse

- [darktable.info — Scene-Referred Workflow](https://darktable.info/en/darktable-first-steps/understand/scene-referred-workflow/) — Guida introduttiva con diagrammi animati
- [darktable Manual — Pixelpipe Order](https://docs.darktable.org/usermanual/development/en/special-topics/program-internals/pixelpipe/) — Documentazione ufficiale sull’ordine fisso dei moduli
- [A Dabble in Photography — Darktable 5.4 NEW UPDATE!](https://www.youtube.com/watch?v=yiTqUgoWg6Q) — Tutorial completo su AgX, tone curve e color calibration
- [PIXLS.US — Darktable 3: RGB or Lab? Which Modules? Help!](https://pixls.us/articles/darktable-3-rgb-or-lab-which-modules-help/) — Analisi tecnica sul perché Lab è obsoleto e RGB lineare è necessario
- [darktable Manual — Color Management](https://docs.darktable.org/usermanual/development/en/special-topics/color-management/) — Spiegazione dettagliata di input/output profile, gamut e rendering intent

## Fonti

[^scene-referred-def]: darktable Manual — Scene-Referred Workflow. https://docs.darktable.org/usermanual/development/en/overview/workflow/
[^display-referred-def]: darktable Manual — Display-Referred Workflow. https://docs.darktable.org/usermanual/development/en/overview/workflow/
[^filmic-versions]: A Dabble in Photography — How to get accurate colours in darktable. https://www.youtube.com/watch?v=TMlF85TFIUo
[^agx-intro]: darktable 5.4 NEW UPDATE! — YouTube. https://www.youtube.com/watch?v=yiTqUgoWg6Q
[^sigmoid-modes]: darktable user manual — sigmoid. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/sigmoid/
[^cat16]: darktable Manual — Color Calibration. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-calibration/
[^eigf]: darktable Manual — Tone Equalizer. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/tone-equalizer/
[^notorious6]: PIXLS.US — The Notorious 6. https://pixls.us/
[^pixelpipe-order]: darktable Manual — The Pixelpipe and Module Order. https://docs.darktable.org/usermanual/development/en/darkroom/pixelpipe/the-pixelpipe-and-module-order/
[^xmp-sidecar]: darktable Manual — XMP Sidecar Files. https://docs.darktable.org/usermanual/development/en/overview/sidecar-files/
[^raster-mask]: darktable Manual — Raster Masks. https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/masks/raster/
[^sam2]: A Dabble in Photography — AI masks in darktable. https://www.youtube.com/watch?v=7yd5riDmUjk
[^pfm-format]: A Dabble in Photography — External masks. https://www.youtube.com/watch?v=7sOAxcNaP4M
[^asc-cdl]: darktable Manual — Color Balance RGB. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-balance-rgb/
[^aces-support]: darktable Manual — ACES Support. https://docs.darktable.org/usermanual/development/en/special-topics/color-management/aces/
[^lut-3d]: darktable Manual — LUT 3D. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/lut-3d/
[^ev-unit]: darktable Manual — Exposure Module. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/exposure/
[^ssim]: darktable Manual — Snapshots. https://docs.darktable.org/usermanual/development/en/darkroom/snapshots/
[^wavelet-decomp]: darktable Manual — Contrast Equalizer. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/contrast-equalizer/
[^gamut-coverage]: darktable Manual — Gamut Visualization. https://docs.darktable.org/usermanual/development/en/special-topics/color-management/gamut/
[^display-encoding]: darktable Manual — Display Encoding (legacy). https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/display-encoding/
[^input-profile]: darktable Manual — Input Color Profile. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/input-color-profile/
[^output-profile]: darktable Manual — Output Color Profile. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/output-color-profile/
[^exposure-param]: darktable Manual — Exposure. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/exposure/
[^filmic-params]: darktable 5.4 NEW UPDATE! — YouTube. https://www.youtube.com/watch?v=yiTqUgoWg6Q
[^sigmoid-params]: darktable user manual — sigmoid. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/sigmoid/
[^agx-params]: darktable 5.4 NEW UPDATE! — YouTube. https://www.youtube.com/watch?v=yiTqUgoWg6Q
[^color-balance-params]: darktable Manual — Color Balance RGB. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-balance-rgb/
[^denoise-params]: darktable Manual — Denoise (profiled). https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/denoise-profiled/
[^workflow-config]: darktable 5.4 NEW UPDATE! — YouTube. https://www.youtube.com/watch?v=yiTqUgoWg6Q
[^wb-conflict]: darktable Full edit #1 — YouTube. https://www.youtube.com/watch?v=DzdGL30lYjU
[^bezold-brucke]: How to get accurate colours in darktable — YouTube. https://www.youtube.com/watch?v=TMlF85TFIUo
[^tone-mapper-conflict]: darktable Manual — Sigmoid Usage Notes. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/sigmoid/
[^sam2-raster]: A Dabble in Photography — AI masks. https://www.youtube.com/watch?v=7yd5riDmUjk
[^gamut-check]: darktable Manual — Gamut Check Plugin. https://github.com/darktable-org/darktable/tree/master/src/external/gamutcheck

