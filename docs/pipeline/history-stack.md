# Cronologia (history stack)

Il modulo **history stack** (o coda di sviluppo) è il cuore del sistema non-distruttivo di darktable. Memorizza l'intera cronologia delle modifiche apportate a un'immagine, nell'ordine in cui sono state effettuate, e la salva sia nel database della libreria che nei file sidecar XMP.[^manual-history-stack][^manual-sidecar]

A differenza di Photoshop, dove la cronologia viene solitamente persa alla chiusura del file (salvando solo il risultato finale), in darktable lo history stack persiste tra le sessioni, permettendo di modificare qualsiasi passaggio in qualsiasi momento.[^manual-history-stack]

!!! info "Differenza tra Cronologia ed Esecuzione"
    È importante notare che lo history stack rappresenta l'ordine in cui i moduli sono stati **modificati** (amended), non l'ordine in cui vengono **eseguiti**. L'ordine di esecuzione è determinato dalla posizione dei moduli nel pannello di destra (pixel pipe).[[^manual-history-stack]

## Panoramica

Il modulo **history stack** si presenta in due forme distinte a seconda della vista in cui ti trovi:

1.  **In Lighttable:** Serve per manipolare lo history stack di una o più immagini selezionate (copia, incolla, sincronizzazione). È l'equivalente delle funzioni "Copy Settings" e "Paste Settings" di Lightroom.[^manual-lt-history]
2.  **In Darkroom:** Serve per visualizzare e navigare la cronologia dell'immagine attualmente aperta. È l'equivalente del pannello "Cronologia" di Photoshop, ma con funzionalità di gestione stile avanzate.[^manual-dr-history]

## Flusso di lavoro consigliato

### Sincronizzare modifiche tra immagini (da Lighttable)

Per applicare lo stesso sviluppo a più scatti (es. un bracketing o una sessione di studio):

1.  Seleziona l'immagine di riferimento (quella già modificata).
2.  Apri il modulo **history stack** nel pannello destro.
3.  Clicca su **selective copy...** per aprire la finestra di dialogo.
4.  Seleziona i moduli specifici da copiare (es. `exposure`, `filmic rgb`) o usa **copy** per copiare tutto (con alcune eccezioni, vedi Parametri).[^manual-lt-history]
5.  Seleziona le immagini target.
6.  Clicca su **selective paste...**. Scegli la modalità:
    *   **append**: Aggiunge o sostituisce i moduli nella destinazione mantenendo gli altri edit esistenti.
    *   **overwrite**: Sostituisce l'intera cronologia delle immagini target con quella copiata (cancella tutto il lavoro precedente sulle target).[^manual-lt-history]

!!! tip "Scorciatoia rapida"
    Nella finestra `selective copy`, un doppio clic su un elemento della cronologia copia solo quell'elemento e chiude immediatamente la finestra.[^manual-lt-history]

### Creare uno Stile (da Darkroom)

Per salvare un look riutilizzabile:

1.  Apri l'immagine con il sviluppo desiderato in Darkroom.
2.  Nel modulo **history stack**, clicca sul pulsante per creare un nuovo stile (icona solitamente a destra di "compress history stack").
3.  Nomina lo stile e seleziona quali parti dello stack includere.[^manual-dr-history]
4.  Lo stile sarà disponibile nel modulo **styles** in Lighttable per essere applicato ad altre immagini.[^manual-styles]

### Navigare nella cronologia (da Darkroom)

*   Clicca su un punto nello stack per tornare a quello stato dell'immagine.
*   **Shift + Clic** su un elemento: espande il modulo corrispondente nel pannello di destra senza cambiare l'immagine visualizzata (utile per controllare i parametri di un passo precedente).[^manual-dr-history]
*   Passa il mouse sopra un elemento per vedere un tooltip con i dettagli delle modifiche apportate rispetto allo stato precedente.[^manual-dr-history]

!!! warning "Perdita di modifiche"
    Se selezioni un modulo nello history stack e poi apporti ulteriori modifiche all'immagine, tutte le modifiche **sopra** il passo selezionato verranno scartate. Usa `Ctrl+Z` per annullare se succede accidentalmente.[^manual-dr-history]

## Parametri principali (Vista Lighttable)

Il modulo in Lighttable offre controlli per la gestione batch dello stack.[^manual-lt-history]

| Parametro | Descrizione | Note |
|-----------|-------------|------|
| **selective copy...** | Apre una finestra per scegliere quali elementi della cronologia copiare dall'immagine selezionata. Permette anche di resettare i parametri di un modulo includendolo. | Se selezionate più immagini, la fonte è la prima selezionata. |
| **copy** | Copia l'intero history stack. | Esclude automaticamente alcuni moduli "non sicuri" (vedi box Avvertenze). |
| **selective paste...** | Incolla parti dello stack copiato sulle immagini selezionate. | Permette di scegliere tra modalità "append" o "overwrite". |
| **paste** | Incolla tutti gli elementi dello stack copiato. | Equivale alla modalità "append" di selective paste. |
| **compress history** | Comprime lo stack: se un modulo appare più volte, le unisce in un unico passo. | Azione **non reversibile**. |
| **discard history** | Elimina fisicamente lo stack delle immagini selezionate. | Azione **non reversibile**. Riporta l'immagine allo stato originale. |
| **load sidecar file** | Sostituisce la cronologia attuale con quella contenuta in un file XMP selezionato. | Utile per recuperare edit persi o importare lavori esterni. |
| **write sidecar files** | Scrive forzatamente i file XMP per le immagini selezionate. | Di solito automatico, utile se la scrittura automatica è disabilitata. |

!!! warning "Moduli esclusi dalla 'Copy'"
    Utilizzando il pulsante `copy`, i seguenti moduli vengono **esclusi** perché legati alle proprietà fisiche del file o considerati non sicuri per la copia automatica:[^manual-lt-history]

    *   `orientation`
    *   `lens correction`
    *   `raw black/white point`
    *   `rotate pixels`
    *   `scale pixels`
    *   `white balance`
    *   Moduli deprecati

    Puoi sovrascrivere queste esclusioni usando `selective paste...` e scegliendo manualmente i moduli da incollare.

## Parametri principali (Vista Darkroom)

Il modulo in Darkroom è focalizzato sulla visualizzazione e manutenzione dello stack dell'immagine corrente.[^manual-dr-history]

| Parametro | Descrizione | Note |
|-----------|-------------|------|
| **Lista History** | Elenco cronologico dei cambiamenti di stato (attiva/disattiva/sposta/modifica parametri). | Clicca per ripristinare lo stato. |
| **compress history stack** | Genera lo stack più corto possibile che riproduce l'immagine attuale. Unisce i moduli duplicati. | Scarta gli edit sopra il passo selezionato. |
| **Truncate (Ctrl + click)** | Tenendo premuto `Ctrl` e cliccando "compress history stack", tronca la storia senza comprimere (elimina i moduli sopra, mantiene il resto). | |
| **create style from history** | Crea un nuovo stile basato sullo stack corrente. | Apre una finestra per nominare lo stile e selezionare i moduli da includere. |
| **reset parameters** (nel header) | Scarta l'intera cronologia e riattiva i moduli predefiniti. | Equivale a selezionare "original image" e comprimere. |

!!! tip "Comprimere per pulizia"
    Usa `compress history stack` occasionalmente per ripulire il flusso di lavoro, specialmente se hai fatto molte prove e errori con istanze multiple dello stesso modulo. Ricorda che è irreversibile.[^manual-dr-history]

## Gestione Sidecar e Backup

Lo history stack viene salvato automaticamente in file sidecar `.xmp` accanto ai file immagine originali.[^manual-sidecar]

*   **Backup:** Quando esegui il backup delle tue foto, assicurati di includere anche i file XMP, poiché contengono tutto il tuo lavoro di post-produzione.[^manual-sidecar]
*   **Database vs XMP:** Una volta importata, l'immagine in darktable legge i dati dal database. Se modifichi un file XMP esternamente (con un altro software), darktable potrebbe sovrascrivere tali modifiche alla successiva sincronizzazione, a meno che tu non abbia configurato preferenze specifiche per rilevare gli aggiornamenti all'avvio.[^manual-sidecar]
*   **Recovery:** Se perdi il database o il file XMP, puoi recuperare la cronologia importando un file esportato da darktable (che contiene i metadati XMP completi) tramite la funzione `load sidecar file`.[^manual-lt-history]

## Fonti

[^manual-history-stack]: darktable user manual - the history stack, https://docs.darktable.org/usermanual/development/en/darkroom/pixelpipe/history-stack/
[^manual-lt-history]: darktable user manual - history stack (Lighttable), https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/lighttable/history-stack/
[^manual-dr-history]: darktable user manual - history stack (Darkroom), https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/darkroom/history-stack/
[^manual-sidecar]: darktable user manual - sidecar files, https://docs.darktable.org/usermanual/development/en/overview/sidecar-files/sidecar/
[^manual-styles]: darktable user manual - styles, https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/lighttable/styles/
