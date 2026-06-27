# Maschere Disegnate

Le maschere disegnate permettono di tracciare forme direttamente sull'immagine: pennello, cerchio, ellisse, percorso (path) e gradiente.[^manual]

## Strumenti disponibili

| Strumento | Uso | Scorciatoia | Note tecniche |
|-----------|-----|-------------|----------------|
| **Brush** | Dipingere a mano libera con controllo pressione (tablet) | — | Supporta pen pressure: regola *width*, *hardness* o *opacity* in base alla pressione [^maskmanager]. Valori predefiniti modificabili in *preferences > darkroom > pen pressure control for brush masks*. |
| **Circle** | Selezione circolare | — | Dimensione regolabile con rotella del mouse; *feathering radius* regolabile con `Shift+scroll` sul bordo. Il centro è sempre allineato al punto di click iniziale [^drawn]. |
| **Ellipse** | Selezione ellittica | — | Quattro nodi di controllo per regolare eccentricità; rotazione con `Ctrl+click+drag` o `Shift+Ctrl+scroll`. Modalità *equidistant* vs *proportional* attivabile con `Shift+click` all’interno della forma [^drawn]. |
| **Path** | Percorso con punti di controllo | — | Minimo 3 nodi; chiusura con `right-click`. Nodi *smooth* (curvi) o *sharp* (angolari): `Ctrl+click` su nodo esistente per alternare. Inserimento nodo su segmento con `Ctrl+click` sul segmento [^drawn]. |
| **Gradient** | Transizione lineare graduata | — | Linea definita da due nodi ancorati; curvatura regolabile con `scroll` vicino al centro della linea per compensare distorsioni da *lens correction* [^drawn]. Estensione fino ai bordi dell’immagine. |

## Esempio: schiarire il soggetto

1. Apri il modulo Esposizione (o crea una seconda istanza)
2. In fondo al modulo, clicca l'icona maschera > **«Drawn mask»**
3. Scegli lo strumento pennello e dipingi sul soggetto
4. Regola il **feathering radius** per ammorbidire i bordi
5. Regola l'esposizione: solo il soggetto verra' schiarito

!!! tip "Visualizzazione overlay"
    L'overlay giallo mostra esattamente dove il modulo agisce. Attiva/disattiva con il pulsante maschera nel modulo o con ++m++.[^manual]

## Flusso di lavoro completo

### 1. Creazione e posizionamento
- Seleziona lo strumento desiderato (es. `circle`) → clicca sull’immagine per creare la forma.
- Durante la creazione:  
  - `Scroll` → modifica dimensione (diametro per circle/ellipse, lunghezza per gradient, numero di nodi per path).  
  - `Shift+scroll` → regola `feathering radius` (default: **0–200 px**, valore tipico per ritratti: **30–80 px**) [^drawn].  
  - `Ctrl+scroll` → regola `mask opacity` globale (range: **−100% a +100%**, default: **0%**) [^drawn].  
- Per disegnare più forme dello stesso tipo consecutivamente: `Ctrl+click` sull’icona → dopo ogni forma, premi `right-click` per uscire dalla modalità continua [^drawn].

### 2. Modifica interattiva
- Clicca sull’icona **«show and edit mask elements»** (occhio con tratteggio) per entrare in *edit mode*.  
- `Ctrl+click` su tale icona → **restricted edit mode**: impedisce spostamento/ridimensionamento dell’intera forma, utile per modificare singoli nodi senza rischio di errore [^drawn].  
- Trascina la forma per spostarla; clicca su un nodo per selezionarlo e modificarne la posizione o la curvatura (maniglie appaiono su nodi smooth).  
- Su `brush`: ogni tratto è convertito in una sequenza di nodi; `smoothing` in *preferences > darkroom > smoothing of brush strokes* controlla densità dei nodi (valore tipico: **30–60%**) [^maskmanager].

### 3. Combinazione avanzata con il Gestore Maschere
- Le forme possono essere raggruppate e combinate con operatori insiemistici nel modulo **mask manager** [^maskmanager]:  
  - **Union** (default per circle/ellipse/path/gradient): unisce le aree selezionate (`A ∪ B`).  
  - **Intersection**: mantiene solo l’area comune (`A ∩ B`). Utile per affinare una maschera (es. applicare un `gradient` *solo dentro* un `path`) [^maskmanager].  
  - **Difference**: “taglia” l’area della seconda forma dalla prima (`A − B`).  
  - **Exclusion**: area esclusiva di A o B, ma non entrambe (`A ⊕ B`).  
  - **Sum** (default per brush): somma opacità pixel per pixel (ideale per dodge/burn multi-strato) [^maskmanager].  

### 4. Affinamento post-creazione
Dopo aver creato la forma, accedi ai parametri di raffinamento nella sezione **mask refinement** (appare automaticamente quando una maschera è attiva):

| Parametro | Range | Default | Uso tipico | Fonte |
|-----------|--------|---------|------------|-------|
| `details threshold` | **−100% a +100%** | **0%** | Valori positivi → maschera applicata solo su aree ricche di dettagli (es. per nitidezza localizzata); negativi → su zone lisce (es. cielo) [^refinement] | [^refinement] |
| `feathering radius` | **0–200 px** | **0 px** | Valore ≥50 px consente all’algoritmo di allinearsi ai bordi reali dell’oggetto (es. 75 px per un ritratto su sfondo sfocato) [^refinement] | [^refinement] |
| `blurring radius` | **0–200 px** | **0 px** | Applica blur gaussiano *dopo* il feathering; utile per eliminare artefatti (es. 3–8 px per transizioni morbide) [^refinement] | [^refinement] |
| `mask opacity` | **−100% a +100%** | **0%** | Compensa la perdita di opacità causata da `feathering` o `blurring`. Valori positivi rafforzano le zone già opache; valori negativi enfatizzano le transizioni [^refinement] | [^refinement] |
| `mask contrast` | **−100% a +100%** | **0%** | Aumenta il contrasto della maschera stessa: +50% rende i bordi più netti, −30% li rende più graduali [^refinement] | [^refinement] |

!!! info "Feathering guide: input vs output"
    Il parametro `feathering guide` determina quale immagine guida l’allineamento del bordo della maschera:  
    - `input before blur`: usa l’immagine *prima* del blur del modulo → migliore per maschere su soggetti ben definiti.  
    - `output after blur`: usa l’immagine *dopo* il blur → utile per maschere su aree già sfocate (es. bokeh).  
    La scelta influisce significativamente sulla precisione del bordo, specialmente con moduli come *sharpen* o *denoise* [^refinement].

### 5. Gestione delle distorsioni
Le maschere sono disegnate sul file RAW originale e trasformate lungo la pipeline (es. da *lens correction* o *rotate and perspective*). Ciò può causare:  
- Cerchi visualizzati come ellissi.  
- Gradienti lineari visualizzati come curve.  
Per minimizzare questo effetto:  
- Usa `path` invece di `circle`/`ellipse` per maggiore controllo (più nodi = minor distorsione visibile) [^drawn].  
- Per i gradienti: correggi la curvatura con `scroll` vicino alla linea centrale *dopo* aver applicato *lens correction* [^drawn].  
- Evita di applicare correzioni geometriche *dopo* aver disegnato la maschera: ritaglio, rotazione o prospettiva devono essere eseguiti *prima*, altrimenti si verificano errori di allineamento [^dragan].

## Parametri tecnici dettagliati

### Feathering radius
- **Funzione**: controlla la larghezza della transizione tra opaco e trasparente.  
- **Valore tipico**:  
  - Ritratti: **40–90 px** (per isolare volto da sfondo sfocato).  
  - Paesaggi: **120–200 px** (per transizioni cielo/terreno naturali).  
- **Nota critica**: valori >150 px possono causare *overshoot*, ovvero la maschera invade aree non intese. Verifica sempre con `display mask` attivo [^refinement].

### Mask opacity e mask contrast
- `mask opacity` non è equivalente all’opacità del modulo: regola la *forza relativa* della maschera stessa.  
  - Valore **+30%**: aumenta l’effetto sui pixel già >50% opachi, lasciando invariati quelli <10% [^refinement].  
- `mask contrast` agisce come una curva tonale *sulla maschera*:  
  - **+60%**: trasforma una transizione lineare 0→100% in una curva “S”, migliorando la definizione del bordo.  
  - **−40%**: produce una transizione più graduale, utile per vignette o effetti atmosferici [^refinement].

### Set operators nel mask manager
Ogni forma in un gruppo ha un operatore logico associato (visibile come icona a sinistra del nome). L’ordine di elencazione è fondamentale:  
- Le operazioni sono applicate **dal basso verso l’alto** nella lista.  
- Esempio: un gruppo con `gradient #1` (union), poi `path #2` (intersection) → il risultato è l’intersezione tra il gradiente e il path [^maskmanager].  
- Per invertire la polarità di una singola forma: `right-click` sul nome → `use inverted shape` [^maskmanager].

## Consigli operativi

!!! tip "Feathering progressivo"
    Quando si schiariscono aree (dodging), iniziare con un valore **alto** di feathering e poi ridurlo progressivamente per un migliore controllo dei bordi.[^nightsky]

!!! tip "Vignettatura con maschera"
    Per creare una vignettatura con il modulo Exposure, **invertire** la maschera generata per scurire i bordi invece del centro.[^dragan]

!!! info "Gradienti nel Gestore Maschere"
    Usare l'intersezione del gradiente nel Gestore Maschere per transizioni piu' naturali e graduali.[^landscape]

!!! warning "Composite e ritaglio"
    Non ritagliare prima di usare il modulo Composite per evitare problemi di allineamento.[^dragan]

!!! tip "Workflow ibrido: AI + vettoriale"
    Per soggetti complessi (es. capelli, foglie), genera una maschera AI (darktable 5.6+) tramite `mask manager`, quindi convertila in vettoriale con `right-click > vectorize` e affinala con `path` o `brush`. Questo combina precisione AI e flessibilità manuale [^ai-masks].

!!! tip "Prevenzione artefatti su gradienti"
    I gradienti possono causare *banding* su cieli omogenei. Attiva sempre il modulo **dither or posterize** con metodo `Floyd-Steinberg auto` quando usi gradienti disegnati [^dither].

!!! warning "Prestazioni con maschere complesse"
    Una maschera `brush` con >500 nodi può consumare significative risorse CPU. Per ottimizzare:  
    - Riduci `smoothing` in *preferences* (valore ≥50% riduce i nodi del 60%).  
    - Sostituisci con `path` per contorni regolari.  
    - Usa `feathering radius` ≥100 px invece di molti piccoli stroke [^drawn].

## Esempi pratici avanzati

### Esempio 1: Isolamento scogliera con combinazione multi-maschera  
*(Basato su [ENG] darktable masking episode 5)*  
1. Crea un `gradient` dall’alto verso il centro per selezionare il cielo.  
2. Crea un `path` per contornare la scogliera.  
3. Nel `mask manager`, imposta il `gradient` in **union**, il `path` in **intersection**: il risultato è *solo la parte superiore della scogliera contro il cielo*.  
4. Applica `tone equalizer` con `details threshold = +40%` per preservare texture solo nelle zone rocciose [^episode5].

### Esempio 2: Vignettatura artistica con ellisse distorta  
1. Crea un `ellipse` centrato sull’immagine.  
2. Ruota l’ellisse di **−15°** con `Ctrl+click+drag` su un nodo.  
3. Imposta `feathering radius = 180 px` e `mask contrast = +50%`.  
4. Nel modulo `exposure`, clicca `+/-` per invertire la maschera → l’effetto colpirà i bordi, non il centro.  
5. Aggiungi `dither or posterize` per evitare banding [^episode1].

### Esempio 3: Nitidezza selettiva su insetto  
1. Crea un `path` preciso attorno all’insetto (usa `restricted edit mode`).  
2. Nel modulo `sharpen`, imposta `feathering guide = input before blur` e `feathering radius = 65 px`.  
3. Regola `mask opacity = +25%` per enfatizzare i bordi interni dell’insetto.  
4. Usa `details threshold = +70%` per escludere eventuali zone mosse [^episode2].

## Risorse

- **[Maschere disegnate – Manuale ufficiale darktable](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/masks/drawn/)**  
- **[Gestore maschere – Manuale ufficiale darktable](https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/darkroom/mask-manager/)**  
- **[Rifinimento maschere – Manuale ufficiale darktable](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/masks/refinement-controls/)**  
- **[Video tutorial: Maschere avanzate (Ep. 5)](https://www.youtube.com/watch?v=eTSRnz-ZMzU)**  
- **[Video tutorial: AI masking in darktable 5.6](https://www.youtube.com/watch?v=7yd5riDmUjk)**  

## Fonti

[^manual]: *darktable User Manual -- Drawn Masks*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/masks/drawn/) | `processed/darktable-usermanual-en/usermanual-48-en-darkroom-masking-and-blending-masks-drawn.md`
[^nightsky]: *[Night Sky Full Edit](https://www.youtube.com/watch?v=5P0Yj_vqy5w)* -- A Dabble in Photography
[^dragan]: *[The Dragan effect](https://www.youtube.com/watch?v=EuvG0lh8OB8)* -- A Dabble in Photography
[^landscape]: *[Landscape edit with AI](https://www.youtube.com/watch?v=OERXOFz9lEo)* -- A Dabble in Photography
[^drawn]: *darktable user manual - drawn masks*, [docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/masks/drawn/](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/masks/drawn/)
[^maskmanager]: *darktable user manual - mask manager*, [docs.darktable.org/usermanual/development/en/module-reference/utility-modules/darkroom/mask-manager/](https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/darkroom/mask-manager/)
[^refinement]: *darktable user manual - mask refinement & additional controls*, [docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/masks/refinement-controls/](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/masks/refinement-controls/)
[^dither]: *darktable user manual - dither or posterize*, [docs.darktable.org/usermanual/development/en/module-reference/processing-modules/dither-or-posterize/](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/dither-or-posterize/)
[^episode1]: *[ENG] darktable masking Episode 1*, [https://www.youtube.com/watch?v=807sNff1TMk](https://www.youtube.com/watch?v=807sNff1TMk)
[^episode2]: *[ENG] darktable masking Episode 2*, [https://www.youtube.com/watch?v=P1W1tmk8HLk](https://www.youtube.com/watch?v=P1W1tmk8HLk)
[^episode5]: *[ENG] darktable masking episode 5*, [https://www.youtube.com/watch?v=eTSRnz-ZMzU](https://www.youtube.com/watch?v=eTSRnz-ZMzU)
[^ai-masks]: *[ENG] AI masks in darktable*, [https://www.youtube.com/watch?v=7yd5riDmUjk](https://www.youtube.com/watch?v=7yd5riDmUjk)
