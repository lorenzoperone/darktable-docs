# Il pixelpipe e l'ordine dei moduli

Il **pixelpipe** è il cuore concettuale di darktable: rappresenta la sequenza ordinata dei moduli di elaborazione che agiscono su un file di input per generare l'immagine finale. A differenza di Photoshop, dove l'ordine dei livelli è flessibile, in darktable l'ordine dei moduli nel pixelpipe è strettamente legato alla qualità dell'output e al modello colore utilizzato.[^pixelpipe-order]

!!! info "Ordine di esecuzione"
    L'ordine in cui i moduli vengono eseguiti corrisponde esattamente all'ordine visivo nell'interfaccia utente: dal basso verso l'alto. Modificare l'ordine visivo cambia il modo in cui l'immagine viene processata.[^pixelpipe-order]

## Panoramica

Il pixelpipe gestisce il flusso dei dati dai valori grezzi del sensore fino all'immagine visualizzabile. La comprensione di questo flusso è fondamentale per i migranti da Lightroom, poiché darktable adotta un approccio diverso, basato sulla distinzione tra dati **scene-referred** (riferiti alla scena) e **display-referred** (riferiti al monitor).[^pixelpipe-order]

Per chi viene da Photoshop, un modulo di elaborazione in darktable è analogo a un *adjustment layer*: riceve un input, applica un'operazione e produce un output che viene passato al modulo successivo.[^anatomy]

Esistono diverse tipologie di pixelpipe ottimizzate per scopi diversi:
*   **Pixelpipe di esportazione:** Processa l'intera immagine a qualità massima. È il più lento ma fornisce la massima qualità possibile.[^pixelpipe-order]
*   **Pixelpipe standard (Darkroom):** Cerca un equilibrio tra accuratezza e reattività, processando solo i pixel visibili a schermo ("Region of Interest" o ROI). Questo può causare differenze visive rispetto all'export, specialmente con moduli che dipendono dai pixel vicini (es. *diffuse or sharpen*, *denoise (profiled)*).[^pixelpipe-order]
*   **Pixelpipe ridotto:** Utilizzato durante l'interazione con moduli di overlay (es. *retouch*, *crop*, *liquify*). Esclude moduli lenti per mantenere l'interfaccia fluida, rendendo temporaneamente l'immagine meno elaborata.[^pixelpipe-order]

## Flusso di lavoro e Workflows

La scelta del flusso di lavoro determina l'ordine predefinito dei moduli e lo spazio colore in cui avviene l'elaborazione.

### Scene-referred Workflow (Consigliato)

Introdotto nella versione 3.0 e diventato predefinito (v5.0 RAW), questo flusso esegue la maggior parte delle operazioni in uno spazio RGB **lineare**, comprimendo i toni solo alla fine della pipeline tramite un tone mapper non lineare (come *filmic rgb* o *AGX*).[^pixelpipe-order]

1.  **Dati Scene-referred:** I valori dei pixel sono proporzionali alla luce raccolta dalla scena (gamma dinamica ampia).
2.  **Tone Mapping:** Compressione non lineare per adattare la gamma dinamica al supporto di output (monitor o stampa).
3.  **Dati Display-referred:** Moduli finali per l'output creativo in spazio non lineare.[^pixelpipe-order]

Questo approccio è fisicamente realistico e produce meno artefatti rispetto al vecchio metodo.[^pixelpipe-order]

### Display-referred Workflow (Legacy)

Modalità precedente alla versione 3.0. Il tone mapping (*base curve* o *filmic rgb*) avviene presto nella pipeline, e la maggior parte dei moduli opera su dati compressi non lineari. Questo è mantenuto per compatibilità con vecchi edit, ma non è raccomandato per nuovi progetti a causa della tendenza a generare artefatti.[^pixelpipe-order]

## Gestione dell'ordine dei moduli

L'ordine dei moduli è stato scelto con cura per garantire la massima qualità. Sebbene sia possibile modificarlo, è fortemente sconsigliato farlo senza una motivazione tecnica specifica.[^pixelpipe-order]

### Preset dell'ordine

Il modulo **module order** permette di selezionare i preset predefiniti per l'elaborazione:[^module-order]

| Preset | Descrizione |
|--------|-------------|
| **v5.0 RAW** | Ordine predefinito per lo sviluppo RAW in modalità scene-referred (darktable 5.0+). |
| **v5.0 JPEG** | Ordine predefinito per lo sviluppo JPEG (darktable 5.0+). |
| **v3.0 RAW** | Ordine predefinito scene-referred per darktable 3.0 - 4.8. |
| **v3.0 JPEG** | Ordine predefinito JPEG per darktable 3.0 - 4.8. |
| **legacy** | Ordine per il workflow display-referred (pre-3.0). |
| **custom** | L'utente ha modificato manualmente l'ordine. |

### Modifica manuale

È possibile spostare i moduli trascinandoli, ma con limitazioni:
*   **Metodo:** Tieni premuto `Ctrl+Shift` e trascina il modulo desiderato nella nuova posizione.[^pixelpipe-order]
*   **Moduli bloccati:** Alcuni moduli non possono essere spostati perché il loro funzionamento dipende strettamente dalla posizione. Ad esempio, *highlight reconstruction* deve avvenire sui dati RAW prima di *demosaic*, che a sua volta deve precedere *input color profile*.[^pixelpipe-order]
*   **Spazi colore:** La maggior parte dei moduli è progettata per funzionare in uno spazio colore specifico; spostarli potrebbe richiedere algoritmi paralleli diversi o introdurre errori.[^pixelpipe-order]

## Consigli

!!! warning "Non cambiare ordine a caso"
    Modificare la sequenza dei moduli peggiora spesso il risultato invece di migliorarlo. I moduli sono calibrati per lavorare su dati con specifiche caratteristiche di gamma dinamica e linearità.[^pixelpipe-order]

!!! tip "High Quality Processing Mode"
    Se noti differenze marcate tra la vista Darkroom e l'export finale (es. nitidezza eccessiva a schermo), puoi abilitare la modalità **High Quality Processing**. Questa forza l'uso del pixelpipe di esportazione per la visualizzazione, garantendo che ciò che vedi sia ciò che esporti, a scapito della reattività del sistema. Usala solo a fine editing.[^pixelpipe-order]

!!! info "Migrazione da Lightroom"
    In Lightroom, l'ordine delle operazioni è spesso gestito internamente e nascosto all'utente (es. la correzione lente avviene sempre prima delle modifiche locali). In darktable, l'ordine è esplicito. Ricorda che nel workflow scene-referred, le operazioni di "grading" creativo (come *color balance rgb*) dovrebbero avvenire *dopo* il tone mapping, mentre le operazioni tecniche (es. *denoise*, *lens correction*) avvengono *prima* nello spazio lineare.[^pixelpipe-order]

## Risorse aggiuntive

Per approfondire la struttura interna dei moduli e la gestione delle maschere (che avviene all'interno di ogni singolo step del pixelpipe), consultare la documentazione sull'anatomia di un modulo.[^anatomy]

## Fonti

[^pixelpipe-order]: darktable user manual - the pixelpipe & module order. URL: https://docs.darktable.org/usermanual/development/en/darkroom/pixelpipe/the-pixelpipe-and-module-order/
[^module-order]: darktable user manual - module order. URL: https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/darkroom/module-order/
[^anatomy]: darktable user manual - the anatomy of a processing module. URL: https://docs.darktable.org/usermanual/development/en/darkroom/pixelpipe/the-anatomy-of-a-module/
