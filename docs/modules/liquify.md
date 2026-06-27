# Liquify

Il modulo **liquify** permette di spostare i pixel dell'immagine applicando distorsioni in stile libero a parti specifiche della foto. Utilizza un sistema basato su nodi (punti, linee e curve) per definire percorsi e aree di influenza, offrendo un controllo granulare simile agli strumenti di deformazione di Photoshop, ma integrato nella pipeline non distruttiva di darktable.[^liquify-manual]

A differenza di altri moduli, liquify consuma una quantità significativa di risorse di sistema, specialmente con molti nodi attivi.[^liquify-manual] Dalla versione 4.6, il modulo mostra sempre l'immagine completa non ritagliata (con il rettangolo di crop sovrapposto), permettendo di prelevare pixel da aree esterne al taglio corrente.[^v4.6-notes]

## Panoramica

Il funzionamento di liquify si basa su tre concetti fondamentali:[^liquify-manual]

1.  **Nodi**: Ogni strumento (punto, linea, curva) è composto da nodi.
2.  **Raggio (Radius)**: Definisce l'area circolare attorno al nodo in cui avviene la distorsione.
3.  **Vettore di forza (Strength vector)**: Indica la direzione e l'intensità dello spostamento dei pixel.

È importante notare che ogni istanza del modulo è limitata a un massimo di **100 nodi**. Se si necessita di più nodi, è necessario aggiungere un'altra istanza del modulo alla pipeline.[^liquify-manual]

!!! warning "Impatto sulle prestazioni"
    Il modulo liquify è computazionalmente pesante. In darktable 5.4, le trasformazioni del modulo liquify vengono ignorate durante lo zoom e il pan nella vista centrale per migliorare la reattività dell'interfaccia.[^v5.4-notes] Se riscontri rallentamenti, riduci il numero di nodi o il raggio di azione.

## Flusso di lavoro consigliato

L'utilizzo tipico di liquify segue questi passaggi:[^liquify-manual]

```
1. Attiva il modulo liquify
   |
2. Seleziona lo strumento (Punto, Linea o Curva)
   |
3. Crea i nodi sull'immagine
   |
4. Regola raggio, forza e piumatura
   |
5. Usa lo strumento "Node" per modifiche fini
```

### Passo 1: Creazione della forma

Seleziona l'icona dello strumento desiderato nella barra degli strumenti del modulo:
*   **Point**: Clicca sull'immagine per posizionare un singolo nodo. Tieni premuto `Ctrl` cliccando l'icona per aggiungere più punti senza dover selezionare di nuovo lo strumento.
*   **Line / Curve**: Clicca una serie di punti per definire il percorso. Clicca con il tasto destro per terminare il disegno.

### Passo 2: Modifica della distorsione

Dopo aver posizionato i nodi, puoi manipolarli direttamente sull'immagine:[^liquify-manual]
*   Trascina il **nodo centrale** per spostare l'intero punto.
*   Trascina la **maniglia sulla circonferenza** per modificare il **raggio** (l'area di effetto).
*   Trascina la **punta del vettore di forza** (la freccia) per definire direzione e intensità della distorsione.

### Passo 3: Piumatura (Feathering)

Per rendere la transizione della distorsione più naturale:
1.  Clicca al centro del cerchio del nodo per attivare la modalità **feathered** (piumata).
2.  Verranno visualizzati due cerchi concentrici.
3.  Trascina i cerchi per regolare indipendentemente la zona di transizione (fallo) della distorsione.[^liquify-manual]

## Parametri principali

### Modalità del punto (Point Modes)

Il vettore di forza di un punto può operare in tre diverse modalità. Per cambiarle, tieni premuto `Ctrl` e clicca sulla punta del vettore di forza.[^liquify-manual]

| Modalità | Descrizione | Comportamento |
|----------|-------------|---------------|
| **Linear** | Modalità predefinita. | Distorsione lineare all'interno del cerchio, partendo dal lato opposto al vettore e seguendo la sua direzione. |
| **Radial growing** | Espansione radiale. | L'effetto è radiale, partendo con una forza del 0% al centro e aumentando verso l'esterno. Indicata da un cerchio aggiuntivo con freccia rivolta verso l'esterno. |
| **Radial shrinking** | Contrazione radiale. | L'effetto è radiale, partendo con una forza del 100% al centro e diminuendo verso l'esterno. Indicata da un cerchio aggiuntivo con freccia rivolta verso l'interno. |

### Modalità di collegamento (Link Modes)

Disponibili per le curve e le linee, queste modalità controllano come i punti sono collegati tra loro, influenzando la pendenza della curva di Bézier tramite le maniglie di controllo. Tieni premuto `Ctrl` e clicca sul centro di un nodo per cambiare modalità.[^liquify-manual]

| Modalità | Simbolo | Descrizione |
|----------|---------|-------------|
| **Autosmooth** | Nessuno | Modalità predefinita. Le maniglie non sono mostrate; i controlli sono calcolati automaticamente per garantire una curva liscia. |
| **Cusp** | Triangolo | Le maniglie di controllo possono essere spostate indipendentemente, creando angoli acuti o punti di rottura nella curva. |
| **Smooth** | Diamante | Le maniglie garantiscono sempre una curva liscia, ma permettono di modificare la pendenza in modo differenziato sui due lati. |
| **Symmetrical** | Quadrato | Le maniglie vengono spostate sempre insieme, mantenendo simmetrica la curva rispetto al nodo. |

### Gestione dei nodi

| Azione | Combinazione/Tasto |
|--------|-------------------|
| **Rimuovere un punto** | Tasto destro sul centro del nodo. |
| **Aggiungere punto a linea/curva** | `Ctrl` + clic su un segmento. |
| **Rimuovere punto da linea/curva** | `Ctrl` + tasto destro sul centro del nodo. |
| **Cambiare segmento (Linea/Curva)** | `Ctrl` + `Alt` + clic sul segmento. |
| **Visualizza/Nascondi nodi** | Clicca sull'icona "Node tool" o tasto destro sull'immagine. |

### Impostazioni globali

| Parametro | Descrizione |
|-----------|-------------|
| **Warps and nodes count** | Campo informativo che mostra il numero di oggetti di distorsione (warps) e nodi attualmente in uso. |
| **Show guides** | Se attivato, mostra le guide compositive quando il modulo è attivo. Clicca l'icona a destra per configurare le guide (es. griglia, regola dei terzi).[^guides-manual] |

## Consigli

!!! tip "Usa istanze multiple per nodi complessi"
    Poiché il limite è di 100 nodi per istanza, per ritocchi complessi (es. body reshaping completo) è meglio dividere il lavoro in più istanze del modulo liquify (es. una per il viso, una per il corpo) piuttosto che sovraccaricare una singola istanza.[^liquify-manual]

!!! tip "Interpolazione dei pixel"
    La qualità della distorsione dipende dall'impostazione "pixel interpolator (warp)" nelle preferenze di elaborazione. Le opzioni disponibili sono *bilinear*, *bicubic* e *lanczos2*. In generale, *bicubic* è l'opzione più sicura per la maggior parte dei casi ed è il valore predefinito.[^processing-manual]

!!! info "Lavorare con il crop attivo"
    Grazie alle modifiche introdotte nella versione 4.6, non è necessario disabilitare il modulo *crop* per usare liquify su pixel che sono stati tagliati fuori. L'intera immagine originale è visibile con un rettangolo di crop sovrapposto, permettendoti di spostare pixel da aree nascoste verso quelle visibili.[^v4.6-notes]

## Risorse

*   **Manuale Utente darktable - Liquify**: https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/liquify/#
*   **Preferenze di darktable - Processing**: https://docs.darktable.org/usermanual/development/en/preferences-settings/processing/
*   **Guide & Overlays**: https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/darkroom/guides-overlays/#

## Fonti

[^liquify-manual]: darktable user manual - liquify (https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/liquify/#)
[^processing-manual]: darktable user manual - processing (https://docs.darktable.org/usermanual/development/en/preferences-settings/processing/)
[^v4.6-notes]: Version 4.6.0 - darktable FR (https://darktable.fr/posts/2023/12/notes-version-4.6/)
[^v5.4-notes]: Version 5.4.0 - darktable FR (https://darktable.fr/posts/2025/12/notes-version-5.4.0/#)
[^guides-manual]: darktable user manual - guides & overlays (https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/darkroom/guides-overlays/#)
