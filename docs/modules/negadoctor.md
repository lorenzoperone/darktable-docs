# Negadoctor

Il modulo **negadoctor** è lo strumento dedicato di darktable per l'elaborazione di negativi pellicola scansionati o fotografati digitalmente. A differenza di una semplice inversione, negadoctor gestisce la complessa scienza del colore delle emulsioni, rimuovendo la maschera arancione delle pellicole a colori e simulando le proprietà della carta di stampa fotochimica.[^manual-negadoctor]

!!! info "Sostituisce il vecchio modulo Invert"
    Negadoctor è il metodo moderno e raccomandato per convertire i negativi in positivi, offrendo un controllo molto superiore rispetto al vecchio modulo *invert* (ora deprecato) o alle curve manuali.[^manual-negadoctor]

## Panoramica

Il modulo opera attraverso tre schede principali che guidano l'utente dalla correzione tecnica all'interpretazione creativa:[^manual-negadoctor]

1.  **Film Properties** (Proprietà pellicola) -- Definisce il punto di nero (base film), il punto di bianco e il range dinamico del negativo.
2.  **Corrections** (Correzioni) -- Corregge le dominanti cromatiche nelle ombre e nelle luci, utili per pellicole vecchie o sbilanciamenti della luce di scansione.
3.  **Print Properties** (Proprietà di stampa) -- Simula il comportamento della carta fotografica (grado, lucentezza) per definire il contrasto e l'aspetto finale dell'immagine.[^manual-negadoctor]

## Flusso di lavoro consigliato

L'elaborazione con negadoctor richiede un approccio rigoroso. Si consiglia vivamente di seguire l'ordine dei parametri come appaiono nell'interfaccia, dall'alto verso il basso.[^manual-negadoctor]

### Preparazione

Prima di attivare negadoctor, assicurati di:[^manual-negadoctor]

1.  **Esposizione:** Se fotografi il negativo, "esponi a destra" (ETTR) per sfruttare tutta la gamma dinamica del sensore senza clippare.
2.  **Bilanciamento del Bianco:** Usa un'immagine di profilo della sorgente luminosa (senza pellicola) per impostare il WB corretto nel modulo *white balance*. Applica questo WB a tutte le foto del rullino.
3.  **Profilo Input:** Nel modulo *input color profile*, imposta il *working profile* su **linear Rec. 2020 RGB** o su un profilo ICC specifico per l'emulsione della pellicola.
4.  **Disabilita Tone Mapper:** Si raccomanda di disabilitare moduli come *filmic rgb* o *base curve* poiché negadoctor gestisce la conversione tonale.

!!! warning "Attenzione al Tone Equalizer"
    Se intendi usare il modulo *tone equalizer*, devi spostarlo **dopo** negadoctor nella pixelpipe, poiché non è progettato per funzionare con i dati negativi grezzi.[^manual-negadoctor]

### Passo 1: Selezione Film Stock

Inizia selezionando il tipo di pellicola dal menu a tendina **film stock**:[^manual-negadoctor]

*   **Color**: Attiva i controlli specifici per i canali R, G, B (necessario per rimuovere la maschera arancione).
*   **Black and white**: Semplifica l'interfaccia nascondendo i controlli colore non necessari.

### Passo 2: Film Properties

Questa scheda allinea i punti tecnici del negativo.

1.  **Color of the film base**: Usa la pipetta per campionare un'area di pellicola **non esposta** (i bordi del frame). Questo calcolerà automaticamente i valori *D min*. Per il B&W puoi lasciare il valore predefinito (bianco).[^manual-negadoctor]
2.  **D min**: Rappresenta il valore minimo della base film. Per il colore, vedrai tre slider (R, G, B).
3.  **D max**: Definisce il range dinamico (punto di bianco). Usa la pipetta su un'area **esposta** (evitando la base non esposta) per calcolarlo automaticamente senza clipping.
4.  **Scan exposure bias**: Regola il punto nero. Usa la pipetta sulle zone più scure dell'immagine esposta (o sull'intera immagine, escludendo la base non esposta) per settare l'offset corretto.

### Passo 3: Corrections

Utilizza questa scheda solo se necessario, ad esempio per pellicole deteriorate o se la luce di scansione non corrisponde a quella originale.[^manual-negadoctor]

1.  **Shadows color cast**: Regola R, G, B nelle ombre. Usa la pipetta su un'area grigia neutra nelle ombre. *Fallo prima di toccare le luci.*
2.  **Highlights white balance**: Regola R, G, B nelle luci. Usa la pipetta su un'area grigia neutra nelle alte luci.

### Passo 4: Print Properties

Qui definisci il look finale, simile a una stamperia digitale.[^manual-negadoctor]

1.  **Paper black**: Seleziona la pipetta e disegna un rettangolo sull'area esposta (escludendo i bordi non esposti) per mappare il nero della carta al nero digitale.
2.  **Paper grade**: Controlla il contrasto (gamma). Il default è **4**. Come regola generale, il valore di *Paper grade* meno il valore di *D max* dovrebbe risultare tra **2 e 3**.
3.  **Paper gloss**: Comprime le alte luci. Spostalo a sinistra per ridurre il clipping e simulare stampe opache.
4.  **Print exposure adjustment**: Regolazione finale dell'esposizione. Puoi aumentarlo diminuendo contemporaneamente il *paper gloss* per schiarire i mezzi toni senza bruciare le luci.

## Parametri principali

| Parametro | Range/Note | Default | Descrizione |
|-----------|------------|---------|-------------|
| **Film stock** | Color / Black and white | - | Seleziona il tipo di pellicola.[^manual-negadoctor] |
| **Color of the film base** | Picker / Color swatch | White | Campiona la pellicola non esposta per rimuovere la dominante della base.[^manual-negadoctor] |
| **D min** | 1 slider (B&W) o 3 slider (RGB) | Variabile | Densità minima della base (punto di nero del negativo). Calcolata automaticamente dal picker precedente.[^manual-negadoctor] |
| **D max** | Slider | Variabile | Range dinamico della pellicola (punto di bianco). A sinistra = negativo più luminoso, a destra = più scuro.[^manual-negadoctor] |
| **Scan exposure bias** | Slider | Variabile | Imposta il punto nero tecnico. A sinistra = più luminoso, a destra = più scuro.[^manual-negadoctor] |
| **Paper grade** | Slider (Gamma) | 4 | Controllo del contrasto. Valori tipici risultanti (con D max sottratto): 2 - 3.[^manual-negadoctor] |
| **Paper black** | Picker / Slider | Variabile | Mappa il nero della carta al nero della pipeline digitale (offset).[^manual-negadoctor] |
| **Paper gloss** | Slider | Variabile | Compressione delle alte luci (speculari). A sinistra comprime, simulando carta opaca.[^manual-negadoctor] |
| **Print exposure adjustment** | Slider | Variabile | Esposizione finale della stampa. Aumenta per schiarire i mezzi toni.[^manual-negadoctor] |

## Consigli

!!! tip "L'ordine è fondamentale"
    Il manuale raccomanda vivamente di impostare i parametri nell'ordine esatto in cui appaiono nella GUI: *Film stock* -> *Film properties* -> *Corrections* -> *Print properties*. Lavorare dall'alto verso il basso in ogni scheda.[^manual-negadoctor]

!!! tip "Evita la polvere con i Picker"
    Quando usi gli strumenti di selezione (picker), fai attenzione a non includere polvere o graffi, poiché potrebbero alterare i dati campionati e falsare la calibrazione del colore o dell'esposizione.[^manual-negadoctor]

!!! tip "Gestione dei bordi"
    Per **D max** e **Print exposure**, non includere mai la pellicola non esposta (i bordi scuri o chiari del frame) nell'area di selezione del picker. Al contrario, per **Color of the film base**, devi selezionare *solo* la pellicola non esposta.[^manual-negadoctor]

!!! info "Profili ICC personalizzati"
    Per una massima fedeltà, puoi utilizzare profili ICC specifici per l'emulsione della tua pellicola nel modulo *input color profile* (impostando il *working profile* su quel profilo o su linear Rec. 2020).[^manual-negadoctor]

## Risorse

*   **Manuale Ufficiale:** [darktable user manual - negadoctor](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/negadoctor/)

## Fonti

[^manual-negadoctor]: https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/negadoctor/
