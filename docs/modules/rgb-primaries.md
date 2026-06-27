# RGB Primaries

Il modulo **rgb primaries** è uno strumento avanzato per la manipolazione del colore che regola la tonalità (hue) e la purezza (purity) dei colori primari RGB (rosso, verde e blu). A differenza di molti altri strumenti di correzione colore, questo modulo lascia invariati i pixel incolori (grigi) e preserva le relazioni di opponenza tra i colori: ad esempio, se si aumenta la purezza del blu, l'intensità del colore opposto (giallo) aumenta per bilanciare la correzione.[^manual-rgb]

Sebbene i cursori siano denominati "red", "green" e "blue", tutte le regolazioni sono globali e influenzano la colorimetria complessiva dell'immagine, funzionando essenzialmente come un *channel mixer* (come nel modulo *color calibration*) ma con un'interfaccia diversa.[^manual-rgb]

## Panoramica

Il modulo agisce modificando le coordinate dei primari nello spazio colore, permettendo di cambiare "quale" rosso, verde o blu l'immagine rappresenta. Questo lo rende estremamente potente per correzioni colorimetriche precise o per effetti creativi.

Il comportamento del modulo cambia in base alla sua posizione nella pipeline di elaborazione (pixelpipe):[^manual-rgb]

1.  **Prima del Tone Mapping** (es. prima di *filmic rgb* o *sigmoid*): viene utilizzato per effettuare piccole regolazioni alla colorimetria dell'immagine.
2.  **Dopo il Tone Mapping**: viene utilizzato per applicare modifiche creative, come il tinting (colorazione selettiva) dell'immagine.

## Flusso di lavoro consigliato

L'utilizzo di questo modulo dipende strettamente dall'obiettivo creativo o correttivo:

### Correzione Colorimetrica (Scene-referred)

Posiziona il modulo **rgb primaries** prima dei moduli di tone mapping come *filmic rgb* o *sigmoid*.[^manual-rgb]

- Utilizzalo per correggere dominanti di colore complesse che il semplice *white balance* non riesce a risolvere.
- Essendo una correzione globale, è ideale per armonizzare la risposta cromatica del sensore.

### Tinting Creativo (Display-referred)

Posiziona il modulo **rgb primaries** dopo il tone mapping per effetti artistici.[^manual-rgb]

- Usa i controlli *tint hue* e *tint purity* per applicare una colorazione alle aree neutre (grigie) dell'immagine.
- Modifica le primarie per spostare i colori verso look specifici (es. spostare i rossi verso tonalità magenta o giallo per un look cinematografico).

!!! warning "Attenzione alle primarie di Sigmoid"
    Non confondere questo modulo con la sezione *primaries* presente all'interno del modulo **sigmoid**. Sebbene l'interfaccia sembri simile, lo scopo è diverso: le primarie in *sigmoid* servono a fornire un punto di partenza ragionevole e gestire il gamut, mentre il modulo *rgb primaries* è uno strumento di color grading vero e proprio. L'effetto delle regolazioni non è lo stesso.[^manual-sigmoid]

## Parametri principali

Il modulo offre controlli separati per ciascun canale primario e per il tinting globale.[^manual-rgb]

| Parametro | Descrizione |
|-----------|-------------|
| **red hue** | Sposta la tonalità del rosso. Valori positivi spostano il rosso verso il giallo, valori negativi verso il magenta.[^manual-rgb] |
| **red purity** | Controlla la purezza (saturazione) della primaria rossa. Aumentando il valore, il rosso diventa più vibrante; diminuendolo, tende al grigio.[^manual-rgb] |
| **green hue** | Sposta la tonalità del verde. Valori positivi spostano il verde verso il ciano, valori negativi verso il giallo.[^manual-rgb] |
| **green purity** | Controlla la purezza della primaria verde.[^manual-rgb] |
| **blue hue** | Sposta la tonalità del blu. Valori positivi spostano il blu verso il magenta, valori negativi verso il ciano.[^manual-rgb] |
| **blue purity** | Controlla la purezza della primaria blu.[^manual-rgb] |
| **tint hue** | Se applicato **dopo** il tone mapping, tinge le parti grigie (acromatiche) dell'immagine. Se applicato **prima** del tone mapping, agisce come un controllo del bilanciamento del bianco.[^manual-rgb] |
| **tint purity** | Controlla la purezza (intensità) della tinta applicata all'immagine.[^manual-rgb] |

## Consigli

!!! tip "Relazioni di Opponenza"
    Quando regoli questo modulo, ricorda che le relazioni di opponenza sono preservate. Se aumenti la purezza del blu, il modulo aumenterà automaticamente l'intensità del giallo per mantenere l'equilibrio dei grigi. Questo comportamento è diverso da una semplice curva di saturazione e spesso produce risultati più naturali nei cieli e nelle ombre.[^manual-rgb]

!!! info "Globalità delle modifiche"
    Anche se i cursori sembrano agire su canali singoli, le modifiche sono globali. Cambiare il "red hue" influenzerà tutti i pixel che contengono rosso, incluse le ombre, i mezzi toni e le alte luci, alterando l'intera bilancia cromatica dell'immagine come farebbe un *channel mixer*.[^manual-rgb]

## Risorse

- Manuale utente darktable: Sezione *rgb primaries*[^manual-rgb]
- Manuale utente darktable: Sezione *sigmoid* (per confronto con le primarie interne)[^manual-sigmoid]

## Fonti

[^manual-rgb]: darktable user manual - rgb primaries, https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/rgb-primaries/
[^manual-sigmoid]: darktable user manual - sigmoid, https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/sigmoid/
