# Paesaggio -- Tramonto con albero e maschere avanzate

> **Fonte:** [Darktable landscape edit with AI](https://www.youtube.com/watch?v=OERXOFz9lEo) — A Dabble in Photography

Un paesaggio autunnale con un albero centrale e un cielo piatto: l'obiettivo è enfatizzare i colori caldi dell'albero, recuperare dettagli nel cielo e creare un effetto atmosfera solare.

## Contesto

Immagine scattata con Fujifilm X-Pro3, 35mm, f/1.8, 1/4000s, ISO 160. Il RAW appare spento e privo di contrasto. Il cielo è uniformemente grigio e i colori autunnali dell'albero non hanno pop.

## Passo 1 -- Correzioni di base

**Orientation:**
| Parametro | Valore |
|-----------|--------|
| Auto | yes |

Allineare l'orizzonte come primo passo, prima di qualsiasi altra correzione.

**Sigmoid** (tone mapper scelto per questo paesaggio):
| Parametro | Valore |
|-----------|--------|
| Contrast | 1.500 |
| Skew | +0.00 |
| Color processing | per channel |
| Preserve hue | 100.00% |
| Target black | 0.0152% |
| Target white | 100.00% |

!!! warning "Preserve hue e tramonti"
    Per i tramonti, valutare di **ridurre** il parametro *preserve hue* in Sigmoid/AgX per prevenire la generazione di falsi colori nelle alte luci saturate. In questo caso si mantiene al 100% per la fase iniziale.

## Passo 2 -- Strategia di mascheramento: maschera "Tree Highlights"

L'approccio chiave: creare una maschera combinata (disegnata + parametrica) in un modulo fittizio di **Esposizione** per isolare i colori caldi dell'albero.

### 2a -- Creare il modulo contenitore

1. Aggiungere un modulo **Esposizione**
2. Rinominarlo: "tree highlights"
3. Lasciare i parametri a zero — serve solo come contenitore per la maschera

**Exposure (contenitore maschera):**
| Parametro | Valore |
|-----------|--------|
| Mode | manual |
| Compensate camera exposure | -1.0 EV |
| Exposure | +0.000 EV |
| Black level correction | +0.000 |

### 2b -- Maschera disegnata

Disegnare una forma a mano libera intorno alla chioma dell'albero:
- Non includere il tronco per mantenere realismo
- Non includere i cespugli alla base
- Usare 1 shape con feathering iniziale di 4 px

### 2c -- Maschera parametrica

Affinare la selezione con parametri cromatici:

| Parametro | Valore |
|-----------|--------|
| Input | g, R, B (canali colore) |
| Combine masks | **Exclusive** |
| Input g | 0.12 |
| Input R | 0.25 |
| Input G | 1.0 |
| Input B | 1.0 |

!!! info "Maschera esclusiva"
    La combinazione **exclusive** tra maschera disegnata e parametrica rimuove dalla selezione le aree che soddisfano entrambi i criteri — utile per escludere il cielo che potrebbe essere catturato dalla maschera disegnata.

## Passo 3 -- Applicare la maschera al Color Equalizer

Invece di ricreare la maschera, riutilizzarla come **raster mask** nel **Color Equalizer**:

| Parametro | Valore | Maschera |
|-----------|--------|----------|
| Raster mask | exposure + tree highlights | -- |
| Mask exposure compensation | -- | -- |
| Mask contrast compensation | -- | -- |

Questo è il vantaggio del workflow a basso livello: la maschera creata in un modulo diventa disponibile per tutti i moduli successivi.

## Passo 4 -- Maschera globale per l'albero

Creare un secondo gruppo di maschere per l'albero completo:

**Exposure (nuova istanza: "tree global"):**
| Parametro | Valore |
|-----------|--------|
| Drawn mask | 2 shapes (path + gradient) |
| Combine | Intersezione |
| Gradient | Diagonale, feathering verso il basso |

La maschera combinata copre tutta la chioma con un gradiente che si attenua verso il basso, lasciando scura la parte bassa dell'albero per un effetto più naturale.

**Parametric mask per affinare:**
| Parametro | Valore |
|-----------|--------|
| Input | Jz (spazio JzCzHz) |
| Valori | 155, 170, 251, 277 |
| Feathering radius | 170.1 px |
| Feathering guide | input after blur |
| Mask opacity | -27% |
| Mask contrast | -21% |

!!! tip "Feathering elevato per transizioni morbide"
    Un raggio di sfumatura di 170+ px è necessario per transizioni invisibili tra area mascherata e non mascherata, specialmente su soggetti organici come alberi e vegetazione.

## Passo 5 -- Tone Equalizer con maschera raster

Applicare il **Tone Equalizer** usando la maschera raster globale:

| Parametro | Valore |
|-----------|--------|
| Raster mask | exposure + tree global |
| Mask exposure compensation | -1.93 EV |
| Mask contrast compensation | +0.00 EV |
| Curve smoothing | +0.00 |

Sollevare le ombre dell'albero senza alterare il resto dell'immagine.

## Passo 6 -- Maschera per il cielo

Creare una nuova istanza di **Esposizione** chiamata "sky":

| Parametro | Valore |
|-----------|--------|
| Parametric mask input | g (luminanza) |
| Feathering radius | Da affinare (iniziare da 50 px) |
| Boost factor | Variabile |

!!! tip "Duplicare per separare maschera e regolazioni"
    Duplicare il modulo sky: una istanza contiene solo la maschera raffinata, l'altra contiene le regolazioni di esposizione/colore. Questo permette di affinare la maschera senza alterare i parametri.

## Passo 7 -- Effetto sole e atmosfera

Per creare un effetto di luce solare che filtra:

1. Usare **Color Balance RGB** con maschera sul cielo
2. Aggiungere calore (toni arancio/giallo) nella zona del sole
3. Usare **Diffuse or Sharpen** per effetto di diffusione/foschia

**Color Balance RGB (effetto sole):**
| Parametro | Valore |
|-----------|--------|
| Master mode | 4 ways |
| Highlights hue | Tono caldo (arancio-giallo) |
| Highlights chroma | Moderato |
| White fulcrum | +0.00 EV |

## Passo 8 -- Gestione della foschia

Per ridurre la foschia e aumentare la percepita profondità:

**Diffuse or Sharpen (de-haze):**
| Parametro | Valore |
|-----------|--------|
| Iterations | 21 |
| 1st order speed | -20.00% |
| 3rd order speed | -20.00% |
| 2nd/4th order speed | +10.00% |
| 1st/3rd order anisotropy | +200.00% |

!!! warning "De-haze: dosare con attenzione"
    Valori troppo aggressivi nel de-haze creano un aspetto innaturale. Iniziare con iterazioni basse e aumentare gradualmente.

## Passo 9 -- Nitidezza finale

Applicare la nitidezza come ultimo passo, solo se necessario:

- Nitidezza globale: leggera, solo per compensare il downsampling
- Nitidezza locale: solo sul soggetto principale (albero) tramite maschera

## Riepilogo impostazioni

| Modulo | Parametri chiave | Scopo |
|--------|-----------------|-------|
| **Orientation** | Auto | Allineare orizzonte |
| **Sigmoid** | Contrast 1.5, Preserve hue 100% | Tone mapping |
| **Exposure** (tree highlights) | Contenitore maschera, exposure 0 | Maschera combinata albero |
| **Exposure** (tree global) | 2 shapes, gradiente diagonale | Maschera globale albero |
| **Color Equalizer** | Raster mask da tree highlights | Saturazione selettiva |
| **Tone Equalizer** | Mask exposure -1.93 EV | Contrasto locale albero |
| **Exposure** (sky) | Maschera parametrica luminanza | Selezione cielo |
| **Color Balance RGB** | 4 ways, highlights caldo | Effetto sole |
| **Diffuse or Sharpen** | De-haze, anisotropia +200% | Rimuovere foschia |
| **Parametric mask** | Input Jz, feathering 170 px | Affinamento bordi |

## Principi chiave di questo caso

1. **Maschere come asset riutilizzabili** — la maschera creata in Exposure viene riusata in Color Equalizer e Tone Equalizer  
2. **Maschere combinate** — disegnata + parametrica + gradiente per selezioni precise  
3. **Feathering generoso** — 170+ px per transizioni invisibili su soggetti organici  
4. **Duplicazione moduli** — separare maschera e regolazioni in istanze diverse  
5. **Ordine logico** — correzioni globali prima, maschere locali dopo, nitidezza alla fine  

## Esempio: Mascheratura cielo con JzCzHz per paesaggi nuvolosi  
*Da [Darktable Tutorial: Landscape Photography Workflow](https://www.youtube.com/watch?v=3MDYhWt5kGc) (timestamp 07:00–10:00)*  
1. Creare un nuovo modulo **Esposizione**, rinominarlo `"sky JzCzHz"`  
2. Attivare una **maschera parametrica**, selezionare `input = Jz`  
3. Impostare i valori: `Jz min = 160`, `Jz max = 280`, `Cz min = 0`, `Cz max = 120`  
4. Attivare `combine masks = exclusive` e aggiungere una maschera disegnata per escludere il sole e le nubi più dense  
5. Applicare `exposure = +0.312 EV`, `contrast = +21.7%`, `opacity = 78%`  
6. Riutilizzare la stessa maschera come **raster mask** in **Color Balance RGB**, con `highlights hue = 32° (giallo chiaro)` e `chroma = +18%`[^video-3mdy]  

## Esempio: Recupero dettagli nuvole con Filmic RGB  
*Da [darktable Night Sky Full Edit](https://www.youtube.com/watch?v=5P0Yj_vqy5w) (timestamp 01:50–04:10)*  
1. Attivare **Filmic RGB**, andare alla tab `scene`  
2. Impostare `white relative exposure = +4.72 EV` per espandere i dettagli nelle alte luci nuvolose  
3. Impostare `black relative exposure = -13.34 EV` per illuminare le ombre senza perdere struttura  
4. Nella tab `look`, impostare `contrast = 1.22`, `latitude = 92%`, `shadows ↔ highlights balance = +0.15`  
5. Attivare `highlight reconstruction = guided filter`, `strength = 0.45`, `iterations = 2`  
6. Usare una **maschera raster** derivata da un modulo Exposure con `input = Jz/Cz/hz` per limitare l’effetto alle sole zone nuvolose[^video-5p0y-filmic]  

## Domande frequenti  

### Problema: Maschera cielo troppo rigida, bordi netti visibili  
Quando si usa `input = g` (luminanza) per selezionare il cielo, i bordi possono risultare troppo definiti, soprattutto su nubi sottili. La soluzione è sostituire `g` con `Jz` nello spazio CIE JzCzHz, che offre una separazione più precisa tra cielo e primo piano grazie alla sua maggiore linearità nella gamma luminosa alta. Si consiglia un `feathering radius ≥ 120 px` e l’uso di `input after blur` come guida per lo sfumatura[^manual-jzczhz]  

### Problema: Colore del cielo diventa artificiale dopo applicazione di Color Balance RGB  
Ciò accade quando il `white fulcrum` è impostato troppo alto (> +0.15 EV), causando una sovrapposizione indesiderata tra toni freddi e caldi. Ridurre il `white fulcrum` a `+0.00 EV` e usare `master mode = 4 ways` con `midtones hue = 220° (blu cobalto)` e `highlights hue = 30° (giallo tenue)` produce transizioni più naturali. Verificare sempre con la visualizzazione `mask preview` attiva[^video-3mdy]  

### Problema: Maschera raster non appare nei moduli successivi  
Le maschere raster sono disponibili **solo nei moduli successivi al punto di creazione** nel pipeline. Se una maschera creata in un modulo Exposure non è visibile in Color Equalizer, significa che Color Equalizer è posizionato *prima* di Exposure nell’ordine dei moduli. Correggere l’ordine con il pulsante `↑↓` nel pannello dei moduli o abilitare `show all modules` in `preferences > darkroom > module ordering`[^manual-raster-mask]  

## Risorse  

- [Darktable User Manual — Filmic RGB](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/filmic-rgb/)  
- [Darktable User Manual — Developing Monochrome Images](https://docs.darktable.org/usermanual/development/en/guides-tutorials/monochrome/)  
- [PIXLS.US — Basic Landscape Exposure Blending with GIMP and G'MIC](https://pixls.us/articles/basic-landscape-exposure-blending-with-gimp-and-g-mic/)  
- [Style Antique Landscape — darktable FR](https://darktable.fr/posts/2016/05/style-antique-landscape/)  

## Fonti  

[^video-3mdy]: *[Darktable Tutorial: Landscape Photography Workflow](https://www.youtube.com/watch?v=3MDYhWt5kGc)* — Fotografare per Stupire, timestamp 07:00–10:00
[^video-5p0y-filmic]: *[darktable Night Sky Full Edit](https://www.youtube.com/watch?v=5P0Yj_vqy5w)* — A Dabble in Photography, timestamp 01:50–04:10
[^manual-jzczhz]: *darktable user manual — masking & blending (§ JzCzHz space)*, [JzCzHz space documentation](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/parametric-masks/#jzczhz-space)
[^manual-raster-mask]: *darktable user manual — masking & blending (§ raster mask availability)*, [raster mask availability](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/raster-masks/#availability)
