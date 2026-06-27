# Bianco e Nero — Conversione da foto infrarosso

> **Fonte:** [Develop infrared photos with darktable](https://www.youtube.com/watch?v=PKK2QTPKsjY) — A Dabble in Photography

Questo caso studio mostra come trasformare un RAW infrarosso (filtro 720nm) in un'immagine monocromatica con viraggio cromatico creativo. La stessa tecnica si applica a qualsiasi foto che richiede una conversione B&W controllata.

*Figura 1 — Immagine infrarosso prima della conversione in bianco e nero.*

## Contesto

Le foto infrarosse presentano una dominante rossa/magenta estrema e richiedono uno scambio dei canali RGB prima di qualsiasi altra correzione. Il filtro Hoya 720nm agisce come un ND da ~6 stop: tempi di esposizione lunghi e treppiede obbligatorio.

!!! warning "Filtro IR e qualità"
    Il filtro Hoya 720nm è fortemente consigliato rispetto a marchi economici (es. URTH), che possono introdurre troppa luce rossa rendendo la correzione estremamente difficile in post-produzione[^ir-video].

## Passo 1 — Analisi del RAW e configurazione pipeline

L'immagine RAW appare completamente rossa/magenta. Prima di tutto si verifica che il workflow sia impostato su **scene-referred** con profilo di ingresso **Rec2020 RGB linear**.

| Parametro | Valore |
|-----------|--------|
| Workflow | scene-referred (Filmic RGB) |
| Profilo ingresso | Rec2020 RGB linear |
| Profilo uscita | Filmic RGB |

!!! tip "Bilanciamento del bianco su vegetazione"
    Per le foto IR, impostare il WB su foglie o erba: la vegetazione riflette l'infrarosso e appare molto chiara/neutra, fornendo un punto di riferimento affidabile per il bilanciamento[^monochrome-guide].

## Passo 2 — Scambio canali RGB con Color Calibration

Il passo fondamentale è scambiare i canali rosso e blu usando **Color Calibration** come mixer di canali. Questo trasforma la dominante rossa in toni più gestibili.

| Parametro | Valore | Note |
|-----------|--------|------|
| Preset | Scambio canali (channel swap) | |
| Coeff. canale Rosso | ~0.0 | Ridotto drasticamente |
| Coeff. canale Verde | ~1.0 | Mantenuto |
| Coeff. canale Blu | ~1.0 | Aumentato (era basso nel RAW) |
| Normalizza | **Attivo** | Evita alterazioni di luminosità |

!!! important "Somma dei coefficienti = 1"
    Quando si modificano i coefficienti del mixer di canali, assicurarsi che la somma sia 1 oppure attivare l'opzione **Normalizza** per evitare alterazioni indesiderate della luminosità[^color-calibration-ref].

*Figura 2 — Configurazione del Color Calibration per lo scambio dei canali rosso e blu.*

## Passo 3 — Conversione in Bianco e Nero

Si aggiunge un'istanza di **Color Calibration** con il preset **black and white**. L'ordine nella pipeline è cruciale: questo modulo va posizionato **dopo** le correzioni cromatiche, subito prima di Filmic RGB.

| Parametro | Valore |
|-----------|--------|
| Preset | black and white |
| Mode | monochrome |

!!! warning "Ordine della pipeline"
    Posizionare l'istanza *bianco e nero* di Color Calibration **dopo** i moduli di correzione cromatica (es. subito prima di Filmic RGB) per evitare che neutralizzi le regolazioni di colore e brillantezza applicate in precedenza[^monochrome-guide].

## Passo 4 — Regolazione esposizione e Filmic RGB

Dopo lo scambio canali, l'immagine può risultare sottoesposta o sovraesposta. Si interviene con:

**Esposizione:**
| Parametro | Valore |
|-----------|--------|
| Exposure | Variabile (controllare con bordo bianco `Cmd+B`) |
| Black level correction | Regolare per scurire i neri |

**Filmic RGB:**
| Parametro | Valore | Note |
|-----------|--------|------|
| White relative exposure | ~4.94 EV | Punto bianco |
| Black relative exposure | ~-7.42 EV | Punto nero |
| Dynamic range scaling | +0.00% | Di default |

!!! tip "Bordo bianco per valutare l'esposizione"
    Premere `Cmd+B` per visualizzare il bordo bianco attorno all'immagine: indica quando le alte luci stanno per clippare. Usarlo come riferimento per Exposure e Filmic RGB[^process-ref].

## Passo 5 — Viraggio cromatico con Color Balance RGB

Per un B&W non neutro ma con carattere, si usa **Color Balance RGB** in modalita' **4 ways**:

| Parametro | Valore | Note |
|-----------|--------|------|
| Master mode | 4 ways | Controllo separato per zone |
| Shadows hue | ~76.08 | Giallo-verde (poi ruotabile di 180) |
| Highlights luminance | +82.14% | Schiarire le luci |
| White fulcrum | +0.00 EV | Evita scurimento aree luminose |
| Contrast gray fulcrum | 18.45% | Grigio medio di riferimento |

!!! tip "Rotazione tonalità complementare"
    In Color Balance RGB, ruotare la tonalità delle ombre di 180 rispetto al colore dominante (es. giallo-verde a 76 → blu a 256) aggiunge il complementare e neutralizza la dominante senza toccare la luminanza[^color-balance-ref].

## Passo 6 — Maschere parametriche basate su crominanza

Nelle foto IR i colori sono molto simili tra loro, quindi le maschere parametriche basate sulla **tonalità** (hue) non funzionano bene. Usare invece la **crominanza**:

| Parametro | Valore |
|-----------|--------|
| Input maschera | Cz (crominanza in JzCzHz) |
| Feathering radius | Variabile (testare 100–250 px) |
| Feathering guide | input after blur |

!!! info "Perché la crominanza"
    Nelle foto IR, creare maschere basate sulla crominanza anziché sulla tonalità, perché le informazioni cromatiche sono scarse e i colori sono molto simili tra loro[^monochrome-guide].

## Passo 7 — Equalizzatore tonale per contrasto locale

Per dare profondità all'immagine senza appiattire i dettagli:

| Parametro | Valore | Maschera |
|-----------|--------|----------|
| Shadow exposure | Leggermente negativo | Rastamask globale |
| Mask exposure compensation | -1.93 EV | exposure + tree global |
| Mask contrast compensation | +0.00 EV | — |
| Curve smoothing | +0.00 | — |

*Figura 3 — Regolazione dell'equalizzatore tonale per aumentare la profondità dell'immagine.*

## Passo 8 — Finitura con Diffuse or Sharpen

Per recuperare texture e rimuovere eventuali aloni:

| Parametro | Valore |
|-----------|--------|
| Iterations | Variabile |
| Central radius | 0 px |
| 1st order speed | Valori negativi per de-haze |
| 3rd order speed | Valori negativi per de-haze |
| 1st/3rd order anisotropy | +200% per direzionalità |

*Figura 4 — Applicazione di Diffuse or Sharpen per recuperare texture e rimuovere aloni.*

## Creare uno stile per il batch editing

Una volta trovata la ricetta giusta, salvarla come **stile** per applicarla rapidamente ad altre foto IR dello stesso set:

1. Selezionare tutti i moduli modificati nello stack storico
2. Cliccare destro → **Crea stile**
3. Assegnare un nome descrittivo (es. "IR B&W base")
4. Applicare alle foto successive con un clic

!!! tip "Stile come punto di partenza"
    Lo stile automatizza lo scambio dei canali e il bilanciamento del bianco. Da lì, regolare esposizione e maschere per ogni singola immagine[^ir-video].

## Risultato finale

*Figura 5 — Immagine finale dopo tutte le regolazioni: scambio canali, conversione B&W, viraggio cromatico, contrasto locale e sharpening.*

## Riepilogo impostazioni

| Modulo | Parametri chiave | Scopo |
|--------|-----------------|-------|
| **Color Calibration** (istanza 1) | Scambio canali R/B, Normalizza attivo | Trasformare dominante rossa |
| **Color Calibration** (istanza 2) | Preset black and white, mode monochrome | Conversione B&W |
| **Esposizione** | Valore variabile, black level correction | Correzione luminosità base |
| **Filmic RGB** | White ~4.94 EV, Black ~-7.42 EV | Tone mapping |
| **Color Balance RGB** | 4 ways, shadows hue, highlights luminance | Viraggio cromatico |
| **Tone Equalizer** | Maschera raster, mask exposure -1.93 EV | Contrasto locale |
| **Diffuse or Sharpen** | De-haze speeds negative, anisotropia +200% | Recupero dettagli |
| **Maschere parametriche** | Input Cz, feathering alto | Selezione zone omogenee |

### Esempio: Bilanciamento del bianco con AI edge detection  
*Da [Developing monochrome images](https://docs.darktable.org/usermanual/development/en/guides-tutorials/monochrome/) (sezione CAT tab)*  
1. Aprire **Color Calibration**, attivare la scheda **CAT**  
2. Selezionare `_(AI) detect from image edges_` nel menu *illuminant*  
3. Verificare che `adaptation` sia impostato su **CAT16 (2016)** (default)  
4. Osservare il valore **CCT** calcolato: se segnalato come `_(invalid)_`, confermare che il colore nel *color patch* corrisponda all’illuminante reale dell’immagine IR  
5. Attivare **Normalizza** nell’istanza successiva di **Color Calibration** usata per la conversione B&W[^monochrome-guide].

### Esempio: Recupero di alteluci con guided laplacians  
*Da [Highlight reconstruction](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/highlight-reconstruction/) (sezione “guided laplacians” mode)*  
1. Inserire **Highlight Reconstruction** subito dopo **Demosaic**, prima di **Input Color Profile**  
2. Impostare `method = guided laplacians`  
3. Regolare `clipping threshold` fino a evidenziare solo le aree realmente sovraesposte (usare la maschera di clipping con icona accanto allo slider)  
4. Impostare `iterations = 3`, `diameter of the reconstruction = 256`, `noise level = 0.02`  
5. Abilitare `inpaint a flat color` solo se persistono residui magenta in aree grandi (>500 px di diametro)[^highlight-recon-ref].

## Domande frequenti

### Problema: Immagine B&W con artefatti neri o “pixel neri” dopo l’uso di *monochrome*  
Questo comportamento è documentato per immagini con sorgenti blu altamente saturo (es. cielo chiaro in condizioni IR). La soluzione è disabilitare il modulo *monochrome* e usare invece **Color Calibration → black and white** in modalità *monochrome*, che opera in modo più robusto sulle immagini lineari scene-referred[^monochrome-ref].

### Problema: Clipping nei canali dopo lo scambio RGB, non risolvibile con *Filmic RGB*  
Il clipping precoce è causato da un **white point errato** nel modulo *raw black/white point*. Verificare che il valore *white point* corrisponda al modello specifico della fotocamera (non modificare manualmente: i valori predefiniti sono ottimizzati per ogni sensore)[^raw-bw-ref].

### Problema: Maschere parametriche che non selezionano correttamente le foglie IR  
Le maschere basate su *Hue* falliscono perché la tonalità di vegetazione in IR è compressa in un intervallo ristretto (~0–15°). Usare invece **input = Cz** (crominanza in JzCzHz) con `feathering radius = 180 px` e `feathering guide = input after blur`[^monochrome-guide].

## Risorse

- [darktable User Manual — Developing Monochrome Images](https://docs.darktable.org/usermanual/development/en/guides-tutorials/monochrome/)  
- [darktable User Manual — Color Calibration Module](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-calibration/)  
- [darktable User Manual — Highlight Reconstruction](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/highlight-reconstruction/)  
- [darktable User Manual — RAW Black/White Point](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/raw-black-white-point/)  
- [darktable User Manual — Process Workflow](https://docs.darktable.org/usermanual/development/en/overview/workflow/process/)  

## Fonti

[^ir-video]: *[Develop infrared photos with darktable](https://www.youtube.com/watch?v=PKK2QTPKsjY)* — A Dabble in Photography
[^monochrome-guide]: *[Developing monochrome images](https://docs.darktable.org/usermanual/development/en/guides-tutorials/monochrome/)*, darktable user manual
[^color-calibration-ref]: *[Color calibration](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-calibration/)*, darktable user manual
[^process-ref]: *[Process](https://docs.darktable.org/usermanual/development/en/overview/workflow/process/)*, darktable user manual
[^color-balance-ref]: *[Color balance](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-balance/)*, darktable user manual
[^highlight-recon-ref]: *[Highlight reconstruction](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/highlight-reconstruction/)*, darktable user manual
[^raw-bw-ref]: *[Raw black/white point](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/raw-black-white-point/)*, darktable user manual
[^monochrome-ref]: *[Monochrome module](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/monochrome/)*, darktable user manual
