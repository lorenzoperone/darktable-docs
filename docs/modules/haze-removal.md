# Haze Removal

Il modulo **haze removal** è progettato per ridurre automaticamente gli effetti della polvere e della nebbia atmosferica nelle immagini. Oltre alla dehazing, questo modulo può essere impiegato per dare una spinta cromatica (color boost) specificamente nelle regioni dell'immagine a basso contrasto.[^manual-haze]

Il funzionamento si basa su una stima locale della quantità di nebbia presente. Il modulo rimuove la luce diffusa di fondo in base alla sua forza locale e recupera la luce originale degli oggetti nella scena.[^manual-haze]

!!! info "Non è un sostituto del contrasto"
    Sebbene questo modulo aumenti il contrasto, non è destinato a questo scopo e potrebbe fallire o produrre risultati innaturali su immagini che non contengono nebbia reale. Per aumentare il contrasto su immagini non nebbiose, si consiglia di utilizzare i moduli **local contrast**, **diffuse or sharpen** o la tab **4-ways** nel modulo **color balance rgb**.[^manual-haze]

## Panoramica

Il modulo agisce analizzando l'immagine regione per regione per stimare la componente di nebbia. Una volta stimata, procede rimuovendo la luce diffusa atmosferica e recuperando i dettagli e i colori originali degli oggetti che erano stati oscurati o desaturati dalla foschia.[^manual-haze]

Questo approccio è particolarmente utile per i paesaggi con distanze significative, dove la nebbia tende a desaturare e schiarire i dettagli in profondità, o per recuperare vivacità in scene con contrasto intrinsecamente basso.[^manual-haze]

## Flusso di lavoro consigliato

L'utilizzo di **haze removal** dovrebbe essere mirato a situazioni specifiche, evitando il suo impiego come strumento generico di contrasto.[^manual-haze]

1.  **Valutazione della scena**: Identifica se l'immagine soffre di nebbia atmosferica, polvere o mancanza di contrasto locale dovuta alla distanza.
2.  **Applicazione modulo**: Attiva il modulo e regola i parametri partendo da valori conservativi.
3.  **Alternativa per contrasto**: Se l'obiettivo è semplicemente aumentare la "punch" o il contrasto in una immagine pulita, disattiva questo modulo e utilizza **local contrast** o **color balance rgb**.[^manual-haze]

### Passo 1: Regolazione della Forza

Il primo parametro da regolare è **strength**.

*   Aumentalo gradualmente finché non vedi una riduzione della nebbia.
*   Evita di portarlo al massimo (unity) a meno che non sia strettamente necessario, poiché massimizzare la rimozione della nebbia aumenta la probabilità di artefatti.[^manual-haze]
*   Valori tipici efficaci si trovano "sotto unity" (below unity), ovvero non al massimo della potenza disponibile.[^manual-haze]

### Passo 2: Gestione della Distanza

Il parametro **distance** permette di controllare la profondità dell'effetto.

*   Usa valori bassi se vuoi limitare la rimozione della nebbia solo al primo piano (foreground), lasciando lo sfondo naturale o atmosferico.
*   Aumenta il valore se desideri rimuovere la nebbia dall'intera immagine (il valore "unity" applica l'effetto ovunque).[^manual-haze]

!!! warning "Interazione con valori negativi"
    Se imposti il parametro **strength** su un valore negativo (per aumentare artificialmente la nebbia), il controllo **distance** non avrà alcun effetto.[^manual-haze]

## Parametri principali

| Parametro | Range / Valori | Descrizione |
|-----------|----------------|-------------|
| **strength** | Valori negativi a Unity | Controlla la quantità di rimozione della nebbia. Al valore "unity", il modulo rimuove il 100% della nebbia rilevata. Valori negativi aumentano la nebbia nell'immagine.[^manual-haze] |
| **distance** | Valori bassi a Unity | Limita la distanza fino a cui la nebbia viene rimossa. Valori piccoli limitano l'effetto al primo piano. Il valore "unity" applica la rimozione a tutta l'immagine. Non ha effetto se la strength è negativa.[^manual-haze] |

## Consigli

*   **Evita il massimo**: Impostare entrambi i controlli (**strength** e **distance**) al valore "unity" massimizza la rimozione della nebbia, ma è molto probabile che produca artefatti visivi nell'immagine.[^manual-haze]
*   **Sottigliezza**: I valori ottimali sono tipicamente inferiori all'unità (below unity) e dipendono dall'immagine specifica, oltre che dalle preferenze estetiche personali. Una rimozione eccessiva può rendere l'immagine piatta e innaturale.[^manual-haze]
*   **Non usarlo per il contrasto**: Se la tua immagine non ha nebbia, non usare questo modulo per "tirare su" i colori. Rischi di introdurre alonature o colori falsi. Usa invece **local contrast** per la definizione o **color balance rgb** per la saturazione e il contrasto tonale.[^manual-haze]

## Risorse aggiuntive

Per un approfondimento sul flusso di lavoro scene-referred e sui moduli consigliati per la gestione del contrasto e del colore (alternativi a haze removal), consulta la documentazione ufficiale sul processo di sviluppo.[^manual-process]

## Fonti

[^manual-haze]: darktable user manual - haze removal. URL: https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/haze-removal/
[^manual-process]: darktable user manual - process. URL: https://docs.darktable.org/usermanual/development/en/overview/workflow/process/#
