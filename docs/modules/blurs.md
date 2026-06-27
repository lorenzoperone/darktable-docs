# Blurs

Il modulo **blurs** simula sfocature fisicamente accurate nello spazio RGB scene-referred. A differenza dei semplici filtri di sfocatura, questo modulo utilizza una rappresentazione grafica della *Point Spread Function* (PSF) per mostrare come ogni punto luminoso della scena verrà trasformato in una macchia di luce dall'operatore di sfocatura selezionato.[^manual-blurs]

Il modulo offre tre distinti tipi di sfocatura, ciascuno con caratteristiche e controlli specifici, adatti sia per la correzione che per effetti creativi.[^manual-blurs]

!!! info "Introduzione del modulo"
    Il modulo unifica e potenzia le capacità di sfocatura precedentemente disponibili o sparse in altri moduli.[^video-blurs]

## Panoramica

Il modulo **blurs** gestisce tre diverse tipologie di sfocatura: [^manual-blurs]

1.  **Lens Blur**: Simula un diaframma ottico con un numero configurabile di lamelle e curvatura, creando un effetto bokeh sintetico realistico o stilizzato.
2.  **Motion Blur**: Simula il movimento della fotocamera lungo un percorso configurabile (direzione e curvatura).
3.  **Gaussian Blur**: Una sfocatura gaussiana standard, non propriamente ottica, utile per riduzione del rumore o effetti creativi con le modalità di fusione.

Un diagramma posizionato nella parte superiore del modulo visualizza la forma geometrica che verrà applicata a ogni punto dell'immagine (la PSF), permettendo di prevedere il risultato finale prima di applicare l'effetto pesante.[^manual-blurs]

## Flusso di lavoro consigliato

L'utilizzo del modulo dipende dall'obiettivo (correzione o creatività):

1.  **Selettività**: Se desideri sfocare solo una parte dell'immagine (es. lo sfondo), disegna prima una maschera disegnata (drawn mask) o utilizza una maschera parametrica per limitare l'area d'azione.[^video-blurs]
2.  **Scelta del tipo**: Seleziona il `blur type` appropriato (lens, motion o gaussian) nel pannello generale.[^manual-blurs]
3.  **Regolazione Raggio**: Aumenta il `blur radius` per definire l'intensità della sfocatura. Tieni presente che valori elevati aumenteranno drasticamente i tempi di calcolo.[^manual-blurs]
4.  **Refining**: Per i bokeh artistici, regola le lamelle e la curvatura. Per il motion blur, definisci la direzione del movimento.
5.  **Finishing**: Poiché la sfocatura rimuove il rumore rendendo l'area "troppo pulita", è spesso consigliabile aggiungere un po' di rumore sopra l'area sfocata utilizzando i moduli **grain** o **censorize** per fondere armoniosamente l'effetto con il resto dell'immagine.[^manual-blurs]

!!! warning "Limiti della profondità di campo"
    Questo modulo sfoca l'intera immagine come un oggetto piatto e non tiene conto della profondità della scena (depth map). Non è adatto per creare una profondità di campo realistica (fake DoF) dove lo sfondo sfuma gradualmente; le maschere possono aiutare, ma il soggetto rischia di "sfumare" nello sfondo in modo innaturale.[^manual-blurs]

## Parametri principali

### Controlli Generali

| Parametro | Descrizione |
|-----------|-------------|
| **blur radius** | La dimensione di diffusione della sfocatura (spessore della macchia).[^manual-blurs] |
| **blur type** | Seleziona la variante di sfocatura tra *lens*, *motion* o *gaussian*.[^manual-blurs] |


### Controlli specifici per Lens Blur

Questi parametri simulano la meccanica di un obiettivo fotografico: [^manual-blurs]

| Parametro | Descrizione e Range |
|-----------|---------------------|
| **diaphragm blades** | Il numero di lamelle del diaframma. Obiettivi vecchi usano tipicamente 5 o 7, quelli nuovi 9 o 11. Qualsiasi numero dispari è realistico. Numeri maggiori di 11 producono un disco quasi perfetto. |
| **concavity** | Modifica la forma delle lamelle. <br> - **1**: Poligono convesso regolare (triangolo, pentagono, ecc.). <br> - **> 1 ma < (lamelle - 1)**: Trasforma la forma in una stella. <br> - **> (lamelle - 1) ma < lamelle**: Trasforma la forma in un asterisco (riducendo la linearità sotto 1). <br> - **>= lamelle**: Degrada la forma in un "burst pattern" (pattern a scoppio). |
| **linearity** | Modifica i bordi della forma. <br> - **0**: Crea un disco, indipendentemente dalle lamelle o concavità. <br> - **1**: Rende tutti i bordi esterni dritti. <br> - **0 - 1**: Rende i bordi più o meno curvi. |
| **rotation** | Ruota la forma rispetto al suo centro. Utile con poche lamelle quando serve un'orientamento specifico. |


### Controlli specifici per Motion Blur

Questi parametri definiscono il percorso del movimento simulato: [^manual-blurs]

| Parametro | Descrizione e Range |
|-----------|---------------------|
| **direction** | L'orientamento del percorso del movimento in gradi angolari. **0°** corrisponde a un movimento orizzontale. |
| **curvature** | La curvatura del movimento. <br> - **0**: Linea retta. <br> - **Valore negativo**: Curvatura concava. <br> - **Valore positivo**: Curvatura convessa. |
| **offset** | Sposta il punto di inizio/fine lungo il percorso curvo. Utile per selezionare una porzione simmetrica del percorso che produce una forma a "coma" (es. direzione -45°, curvatura +2, offset +0.5). |

## Avvertenze Tecniche e Performance

!!! warning "Performance del modulo"
    Il modulo è implementato utilizzando una convoluzione "naive", un algoritmo lento. Approcci più veloci (come FFT) non sono ancora stati implementati. L'implementazione GPU tramite OpenCL aiuta a mitigare il problema, ma il tempo di esecuzione aumenterà con il **quadrato** del raggio di sfocatura (`blur radius`).[^manual-blurs]

!!! tip "Gestione del rumore"
    Tutte le immagini hanno un minimo di rumore. Se sfocchi solo una parte dell'immagine, quella regione sembrerà sospettosamente pulita rispetto al resto. È buona norma aggiungere rumore sopra la parte sfocata per fondere l'effetto, usando i moduli **grain** o **censorize**.[^manual-blurs]

## Risorse

Per approfondire le differenze tra i tipi di sfocatura e vedere esempi visivi delle forme del diaframma, consulta la documentazione ufficiale.[^manual-blurs]

## Fonti

[^manual-blurs]: darktable user manual - blurs. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/blurs/
[^video-blurs]: [ENG] darktable Blurs module (video-tutorials). https://www.youtube.com/watch?v=HI05rl53iA0
