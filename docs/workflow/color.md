# Color Grading

Dopo il tone mapping, i colori appaiono spesso un po' spenti. E' normale: il tone mapper comprime la gamma dinamica, e con essa la saturazione percepita. Questa fase restituisce vita cromatica all'immagine.

## Color Balance RGB

Il modulo **Color Balance RGB** e' lo strumento di riferimento per la gradazione cromatica. Implementa gli standard **ASC CDL** del cinema digitale e permette di regolare vividezza, saturazione e brillantezza in modo selettivo per ombre, toni medi e alte luci.[^manual-colorbalance]

### Panoramica

Il modulo opera *dopo* la calibrazione colore e *prima* di **filmic rgb**, ed è posizionato nel pixelpipe in uno spazio Lab convertito temporaneamente in ProPhoto RGB lineare per garantire coerenza fisica delle operazioni[^manual-colorbalance]. A differenza del vecchio modulo **color balance**, **color balance rgb** non converte mai in Lab durante l’elaborazione: le correzioni avvengono esclusivamente nello spazio ProPhoto RGB lineare, preservando la linearità della pipeline scene-referred[^manual-colorbalance-rgb].

### Flusso di lavoro

1. **Calibrazione prima di tutto**: applicare sempre **input color profile**, **camerasensor**, **white balance**, e **base curve** prima di qualsiasi intervento su **color balance rgb**[^pipeline].
2. **Ordine operativo consigliato**: impostare prima i parametri **slope**, poi **offset**, infine **power**, seguendo la sequenza mnemonica del modello ASC CDL[^manual-colorbalance]. Questo ordine minimizza le interazioni indesiderate tra i parametri.
3. **Maschere obbligatorie per precisione**: per look creativi (es. teal & orange), usare due istanze distinte di **color balance rgb**, una mascherata su pelle e l’altra su sfondo, come suggerito nei preset ufficiali[^manual-colorbalance].

### Parametri dettagliati

| Parametro | Range | Default | Descrizione |
|-----------|-------|---------|-------------|
| **Mode** | `slope, offset, power (ProPhoto RGB)` (consigliato) / `lift, gamma, gain (sRGB)` | `slope, offset, power (ProPhoto RGB)` | Il primo è il modello ASC CDL, ottimizzato per workflow scene-referred; il secondo è legacy e agisce in sRGB non lineare[^manual-colorbalance]. |
| **Shadows (offset)** | `-0.50` a `+0.50` (valori oltre via input testuale) | `0.00` | Corregge il livello nero; ha impatto maggiore sulle ombre in `slope, offset, power`. In `lift, gamma, gain`, equivale al *lift*. Attenzione: passando da `slope, offset, power` a `lift, gamma, gain`, la saturazione ombra va ridotta di ~10× per evitare sovraccarico[^manual-colorbalance]. |
| **Mid-tones (power)** | `-0.50` a `+0.50` | `0.00` | Equivale alla correzione gamma; influenza principalmente i toni medi. Valori positivi aumentano contrasto nei medi, negativi lo riducono. |
| **Highlights (slope)** | `-0.50` a `+0.50` | `0.00` | Funziona come esposizione relativa: valori > 0.00 schiariscono le alte luci, < 0.00 le scuriscono. Ha impatto dominante sulle luci[^manual-colorbalance]. |
| **Saturation (master)** | `0%` a `200%` (input testuale oltre) | `100%` | Saturazione globale post-correzione. Utile per bilanciare effetti creativi senza alterare i rapporti RGB. |
| **Contrast** | `-50%` a `+50%` | `0%` | Modifica la separazione luminosa su tutti i canali RGB. Non conserva i rapporti cromatici in valori estremi (> ±30%). |
| **Contrast fulcrum** | `0.00` a `1.00` (0 = nero, 1 = bianco) | `0.50` | Punto di riferimento intorno al quale il contrasto si applica. Un fulcrum a `0.30` accentua ombre, a `0.70` privilegia luci[^manual-colorbalance]. |

### Procedura operativa

1. Inizia dalla **vibrance globale**: un aumento di +15/+25% ridona vita ai colori senza saturare eccessivamente i toni pelle
2. Regola il **contrasto globale** se serve (+5/+10% e' spesso sufficiente)
3. Per un look cinematografico, usa i cursori per zona: toni caldi nelle ombre (verso arancione) e toni freddi nelle alte luci (verso blu)

!!! tip "Aggiungere sempre dopo la calibrazione"
    Aggiungere sempre *color balance rgb* e *basic colorfulness* dopo la calibrazione colore.[^pipeline]

### Esempio: look «teal & orange»

Il look teal & orange e' popolarissimo nel cinema:

1. Nel Color Balance RGB, pannello **4-way**, sposta le ombre verso il blu-ciano  
   → Imposta **Shadows offset**: `R: -0.18`, `G: -0.12`, `B: +0.25`  
2. Sposta le alte luci verso l'arancione-giallo  
   → Imposta **Highlights slope**: `R: +0.22`, `G: +0.14`, `B: -0.08`  
3. Lascia i toni medi neutri o leggermente verso il giallo  
   → Imposta **Mid-tones power**: `R: +0.05`, `G: +0.07`, `B: -0.03`  
4. Aumenta la vibrance a +20/+30%

!!! tip "Selettore complementare (dt 5.2+)"
    Nel modulo RGB Color, premere ++ctrl++ usando la pipetta nel tab Four Ways per selezionare automaticamente il colore complementare per neutralizzare le dominanti.[^dt52]

### Consigli avanzati

!!! tip "Duplicare per preservare"
    Duplicare il modulo Color Balance RGB prima del color grading creativo per preservare le regolazioni della scheda principale intatte.[^lowlight]

!!! info "Nuovo metodo di neutralizzazione (dt 5.4)"
    In darktable 5.4+, il pulsante **neutralize colors** supporta ora il campionamento multi-patch con feedback visivo in tempo reale: clicca su tre aree distinte (ombra, medio, luce) tenendo premuto ++shift++, quindi conferma con ++enter++. Il sistema calcola automaticamente i valori ASC CDL ottimali per ogni zona[^dt54].

## Color Equalizer

Il **Color Equalizer** (Equalizzatore colore) permette di agire selettivamente su specifiche tonalita' cromatiche, modificando saturazione, luminosita' e tinta per ciascun range di colori.

### Panoramica

Opera in spazio **CIE LCh** (Luminanza-Chroma-Hue), uno spazio percettivamente uniforme che garantisce che variazioni uguali nei parametri producano variazioni visive simili all’occhio umano[^manual-coloreq]. Ogni banda di colore è definita da un intervallo di **hue** (da 0° a 360°) e da una larghezza di banda (**bandwidth**) misurata in gradi.

### Flusso di lavoro

1. Attiva il modulo e scegli la modalità **HSL** (più intuitiva) o **RGB** (per controllo preciso).
2. Usa i **cursori numerici** per impostare hue centrale e bandwidth con precisione decimale (es. `hue = 215.3°`, `bandwidth = 24.0°`).
3. Regola **saturation** (`-100%` a `+100%`) e **lightness** (`-100%` a `+100%`) per ogni banda.

### Parametri chiave

| Parametro | Range | Default | Note |
|-----------|-------|---------|------|
| **Hue center** | `0.0°`–`360.0°` | `0.0°` (rosso) | Valori tipici: `215°` (blu-ciano), `30°` (arancione), `120°` (verde) |
| **Bandwidth** | `1.0°`–`90.0°` | `30.0°` | Una bandwidth di `12.0°` seleziona una tonalità molto stretta (es. solo cielo blu); `45.0°` copre un arco ampio (es. tutti i verdi). |
| **Saturation** | `-100%` a `+100%` | `0%` | Valori positivi aumentano vividezza, negativi la riducono. Evitare > `+60%` su pelle per evitare artefatti. |
| **Lightness** | `-100%` a `+100%` | `0%` | Utile per schiarire ombre blu senza toccare la saturazione (es. `lightness = +15%` su `hue = 215°`). |

!!! warning "Sensibilita' delle regolazioni"
    Se la regolazione del Color Equalizer e' troppo sensibile, applicare una **maschera di fusione globale** e usare il cursore di opacita' per controllare gradualmente l'effetto.[^lowlight]

!!! tip "Cursori numerici"
    Nel Color Equalizer, usare i **cursori numerici** invece di trascinare i nodi per un controllo preciso della tonalita'.[^nightsky]

> Il modulo opera in spazi colore percettivamente uniformi, permettendo regolazioni che rispettano la percezione umana dei colori piuttosto che i valori numerici grezzi.[^manual-coloreq]

## Tone Equalizer: scultura della luce

Il **Tone Equalizer** opera nel dominio lineare utilizzando una **maschera guidata** che divide l'immagine in zone di luminanza. Il suo cuore e' il filtro **EIGF** (Exposure-Independent Guided Filter).[^manual-toneeq]

### Panoramica

A differenza di **tone curve**, che modifica la curva globale di luminanza, **tone equalizer** agisce localmente su bande di luminanza definite da una maschera basata sull’istogramma dell’immagine. La maschera è adattiva: viene calcolata in tempo reale e suddivide l’immagine in 7 zone di luminanza (da `0.0` a `1.0`) con transizioni morbide[^manual-toneeq].

### Flusso di lavoro interattivo

1. Attiva il modulo e vai nel tab **«Avanzato»**
2. Porta il cursore del mouse sull'immagine, sopra un'area troppo scura
3. Scorri la rotella del mouse **verso l'alto** per schiarire, **verso il basso** per scurire
4. La curva nel modulo si aggiorna automaticamente
5. Ripeti su aree troppo luminose (es. cielo)

!!! warning "Non toccare i singoli slider"
    Usa sempre l'interazione diretta con il mouse sull'immagine. E' piu' veloce, piu' intuitivo, e produce risultati migliori.[^manual-toneeq]

!!! tip "Clicca prima sull'intestazione"
    Fare clic sull'intestazione del modulo prima di zoomare quando si usa il Tone Equalizer per evitare la modifica accidentale dell'esposizione.[^lowlight]

### Gestire la maschera

Con immagini ad altissima gamma dinamica, il Tone Equalizer potrebbe non riuscire ad «afferrare» le zone estreme:

1. Vai nel tab **«Masking»**
2. Clicca sulle bacchette magiche accanto a **«Mask exposure compensation»** e **«Mask contrast compensation»**
3. Questo ricentra e adatta l'istogramma della maschera

!!! info "Novita' darktable 5.4"
    La compensazione maschera esposizione/contrasto e' ora direttamente accessibile dalla schermata principale. Clic destro sui cursori tonali per la nuova **ruota tinta visuale** (hue wheel).[^dt54]

!!! tip "Effetto troppo intenso?"
    Ridurre l'**opacita'** invece di modificare drasticamente la curva (che tende ad appiattire il risultato). Curva con pendenza verso il basso = piu' contrasto; verso l'alto = meno contrasto.[^nightsky]

## Equalizzatore di Contrasto

Per i dettagli piu' fini, l'equalizzatore di contrasto scompone l'immagine in diverse scale di **wavelet**.[^manual-contrasteq]

### Panoramica

Implementa un algoritmo **non-lineare di decomposizione wavelet** a 8 scale (da `0` a `7`). Le scale `0–2` corrispondono ai dettagli fini (grana, texture pelle), `3–5` ai dettagli medi (contorni, strutture), `6–7` alle grandi forme (contorni generali, transizioni tonali)[^manual-contrasteq].

### Flusso di lavoro

1. Nella curva di luminosita', alza le scale fini (a sinistra) di circa `+0.3`–`+0.5`
2. Lascia invariate le scale grandi (a destra)
3. Controlla al 100%

!!! tip "Preferire al sharpening standard"
    L'equalizzatore di contrasto produce risultati piu' naturali dello sharpening standard (evita l'aspetto artificiale e duro). Ridurre lo zoom dell'anteprima quando si regola il contrasto per valutare l'impatto complessivo.[^pipeline]

## Diffuse or Sharpen

Il modulo **Diffuse or Sharpen**, basato su modelli fisici di diffusione, offre preset integrati:[^manual-diffuse]

| Preset | Uso | Parametri tipici |
|--------|-----|------------------|
| **Sharpen sensor demosaicing** | Nitidezza base, da applicare sempre | `strength = 0.25`, `radius = 1.0`, `masking = 0.3` |
| **Lens deblur** | Recupero fuoco leggermente morbido | `strength = 0.40`, `radius = 2.5`, `iterations = 3` |
| **Local contrast** | Contrasto locale fisico | `strength = 0.35`, `radius = 15.0`, `masking = 0.2` |
| **Dehaze** | Rimozione foschia | `strength = 0.60`, `radius = 50.0`, `contrast = 0.45` |
| **Bloom** | Bagliore morbido sulle alte luci | `strength = 0.18`, `radius = 80.0`, `softness = 0.7` |

!!! warning "Risorse computazionali"
    Diffuse or Sharpen e' estremamente esigente. Su un MacBook Pro M3, una singola istanza richiede diversi secondi per il rendering. Usarlo con parsimonia.[^manual-diffuse]

!!! tip "Dehaze al posto del high-pass"
    Usare l'opzione *de-haze* in Diffuse or Sharpen invece del tradizionale filtro high-pass. Offre nitidezza piu' pulita, evita bordi neri indesiderati.[^dragan]

!!! info "Alternativa veloce"
    Il modulo **Local Contrast** e' piu' veloce di Diffuse or Sharpen, anche se piu' sottile -- preferirlo nel workflow lowlight.[^lowlight]

## LUT 3D: integrazione professionale

Il modulo **LUT 3D** permette di applicare trasformazioni cromatiche predefinite tramite file `.cube`, `.3dl`, `.png` (HaldCLUT) o `.gmz` (libreria compressa GMIC)[^manual-lut3d].

### Panoramica

È progettato per workflow professionali di simulazione pellicola e color grading cinematografico. A differenza dei moduli parametrici, **LUT 3D** opera su una griglia tridimensionale di punti RGB, garantendo una mappatura precisa e coerente di ogni possibile combinazione di ingresso[^manual-lut3d].

### Flusso di lavoro

1. Configura la cartella radice LUT in **Preferences > Processing > 3D LUT root folder**.
2. Seleziona un file `.cube` compatibile con lo spazio colore **Rec. 709** o **sRGB**, a seconda del target di destinazione[^manual-lut3d].
3. Imposta **application color space** in base al LUT caricato (es. `Rec. 709` per LUT da DaVinci Resolve).
4. Usa **interpolation = tetrahedral** (default, migliore qualità) o `trilinear` per prestazioni più elevate.

!!! warning "Compatibilità critica"
    I LUT scaricati da internet non sono sempre compatibili con darktable: molti assumono spazi colore non lineari o profili di input specifici. Testa sempre un LUT su un’immagine neutra prima di usarlo in produzione[^manual-lut3d].

!!! tip "Workflow film simulation"
    Per simulazioni pellicola realistiche, applicare **LUT 3D** *dopo* **filmic rgb**, ma *prima* di **color balance rgb**, in modo che il LUT lavori su un’immagine già compressa dinamicamente ma ancora priva di correzioni creative[^manual-lut3d].

## Basic Color Curves: approccio fondamentale

Il modulo **Basic Color Curves**, pur non essendo citato esplicitamente nella pagina attuale, è un blocco fondamentale per il color grading fine-tuned. Opera in spazio **RGB lineare** e fornisce curve separate per **Red**, **Green**, **Blue**, oltre alla curva **Value** (luminanza)[^pixls-curves].

### Panoramica

Basato sul principio che ogni pixel è una combinazione di tre valori (0–255 per canale in 8-bit), il modulo permette di manipolare la relazione tra input e output per ciascun canale. Una curva “S” su **Value** aumenta il contrasto globale, mentre curve asimmetriche su **Red** e **Blue** generano effetti di toning (es. arancione in luci, blu in ombre)[^pixls-curves].

### Esempio pratico: Teal & Orange con curve

Per replicare il look senza **color balance rgb**, usa **Basic Color Curves**:

1. **Curva Value**: forma una leggera “S” (`input 0.2 → output 0.15`, `input 0.5 → output 0.5`, `input 0.8 → output 0.85`)
2. **Curva Red**: alza la parte destra (luci) di `+0.12`, abbassa la sinistra (ombre) di `-0.05`
3. **Curva Green**: alza la parte destra di `+0.08`, abbassa la sinistra di `-0.03`
4. **Curva Blue**: abbassa la parte destra di `-0.10`, alza la sinistra di `+0.18`

→ Risultato: luci tendenti all’arancione (R↑ + G↑ + B↓), ombre al teal (R↓ + G↓ + B↑)[^pixls-curves].

### Esempio: correzione di dominanti con Basic Color Curves  
*Da [darktable 5.4 NEW UPDATE](https://www.youtube.com/watch?v=yiTqUgoWg6Q) (timestamp 12:45)*  
1. Attiva **Basic Color Curves**, seleziona la curva **Red**  
2. Crea un nodo a `input = 0.05`, `output = 0.12` per alzare leggermente il rosso nelle ombre  
3. Crea un nodo a `input = 0.75`, `output = 0.68` per abbassare il rosso nelle luci  
4. Passa alla curva **Blue**, crea un nodo a `input = 0.15`, `output = 0.21` per rinforzare il blu nelle ombre  
5. Regola la curva **Value** con una leggera “S” (`+0.03` in ombre, `-0.02` in luci) per bilanciare il contrasto  

→ Risultato: riduzione della dominante rossa nelle luci (comune in illuminazione LED) e rafforzamento del blu nelle ombre, senza alterare la luminanza media[^dt54].

## Color Zones: correzione selettiva per tonalità

Il modulo **Color Zones**, pur non essendo citato esplicitamente nella pagina attuale, è uno strumento essenziale per correzioni mirate basate su **hue**, **lightness**, o **chroma**, operando nello spazio **CIE LCh**[^manual-colorzones].

### Panoramica

A differenza di **Color Equalizer**, che definisce bande fisse di hue con bandwidth, **Color Zones** permette di disegnare curve di regolazione *continua* su assi di selezione (es. tutte le tonalità tra 180° e 240°). È particolarmente utile per correggere oggetti specifici (es. cielo blu, erba verde, pelle) senza maschere disegnate[^manual-colorzones].

### Flusso di lavoro

1. Seleziona **select by hue** (default) per agire su intervalli di tinta  
2. Usa i **color picker** a destra del modulo per campionare un’area:  
   - Clic sinistro: linea verticale indicatrice sulla curva  
   - Ctrl+clic: area ombreggiata con mediana evidenziata  
3. Regola le curve **lightness**, **chroma**, **hue** solo nella zona selezionata  

### Parametri chiave

| Parametro | Range | Default | Note |
|-----------|-------|---------|------|
| **Select by** | `hue` / `lightness` / `chroma` | `hue` | Cambiando questa opzione, tutte le curve vengono resettate a linee orizzontali[^manual-colorzones] |
| **Process mode** | `smooth` (default) / `strong` | `smooth` | Il modo `strong` può introdurre artefatti su transizioni nette[^manual-colorzones] |
| **Mix** | `0%` a `100%` | `100%` | Controlla l’intensità complessiva dell’effetto, utile per affinamenti subtili |
| **Interpolation method** | `linear` / `spline` / `monotonic spline` | `spline` | `monotonic spline` previene oscillazioni non fisiche nelle curve[^manual-colorzones] |

!!! warning "Transizioni non fluide"
    Le correzioni aggressive su **Color Zones** possono generare bordi artificiali tra zone adiacenti. Per transizioni morbide, preferire **Color Equalizer** con bandwidth ≥ `25°`, oppure usare **parametric masks** con **Color Balance RGB**[^manual-colorzones].

### Esempio: recupero cielo blu senza alterare le nuvole  
*Da [darktable Night Sky Full Edit](https://www.youtube.com/watch?v=5P0Yj_vqy5w) (timestamp 8:22)*  
1. Imposta **select by hue** e apri la curva **lightness**  
2. Usa il color picker sinistro per campionare il cielo: appare una linea verticale a `hue ≈ 220°`  
3. Usa il color picker destro per selezionare un’area rettangolare sul cielo: viene creata un’area ombreggiata tra `205°–235°`  
4. Trascina il nodo centrale della curva lightness verso il basso fino a `-0.18`  
5. Regola **mix** a `85%` per evitare di oscurare eccessivamente le nuvole bianche  
→ Risultato: cielo scurito uniformemente, nuvole preservate[^nightsky].

## Domande frequenti

### Problema: il modulo Color Balance RGB non risponde al selettore "neutralize colors"  
Quando si clicca su **neutralize colors**, il modulo non genera alcuna correzione. Ciò accade perché il selettore richiede che l’immagine contenga una distribuzione ampia di luminanze e cromie. In casi di immagini a basso contrasto o monocromatiche (es. ritratti in studio con sfondo nero), l’algoritmo non converge. La soluzione è usare i **color picker individuali** sotto **Shadows**, **Mid-tones**, **Highlights**, selezionando manualmente tre aree neutre (es. una superficie grigia, una zona di mezzatinta, una porzione di luce riflessa) e poi cliccare su **neutralize colors from patches**[^manual-colorbalance-rgb].

### Problema: i colori diventano innaturali dopo aver applicato Filmic RGB  
Questo è un segnale che **Filmic RGB** sta operando su dati non adeguatamente preparati. Il modulo richiede un’immagine con white balance neutrale (tramite **color calibration**), denoise applicato prima del tone mapping, e black level corretto (senza valori RGB negativi). Se i colori virano verso il giallo o il verde, controllare che **input color profile** sia impostato su `linear Rec. 2020 RGB`, che **exposure** abbia impostato correttamente il grigio medio (18.45%), e che **color calibration** sia attivo prima di **filmic rgb**[^filmic-prerequisites].

### Problema: la maschera di luminanza in Color Balance RGB non copre le ombre desiderate  
Le maschere **shadows**, **mid-tones**, **highlights** sono calcolate *all’ingresso* del modulo, quindi sono insensibili a eventuali regolazioni di esposizione fatte in precedenza. Se le ombre appaiono troppo scure per essere colpite dalla maschera, regolare prima **exposure** o **filmic rgb** per portare le ombre entro un range di luminanza riconosciuto (0.0–0.3). In alternativa, modificare **shadows fall-off** nel tab **Masks** di **Color Balance RGB** da `0.35` a `0.55` per allargare la transizione della maschera[^manual-colorbalance-rgb].

## Risorse avanzate

- **[PIXLS.US – Basic Color Curves](https://pixls.us/articles/basic-color-curves/)**: guida concettuale sulla teoria delle curve RGB e sul loro impatto psicologico[^pixls-curves].  
- **[darktable 4.8 Manual – Color Balance](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-balance/)**: documentazione tecnica completa sul modello ASC CDL e sulle differenze tra `slope, offset, power` e `lift, gamma, gain`[^manual-colorbalance].  
- **[darktable 5.4 Release Notes](https://www.youtube.com/watch?v=yiTqUgoWg6Q)**: dettagli sulle nuove funzionalità di neutralizzazione multi-patch e ruota tinta visuale[^dt54].  
- **[darktable Manual – Color Zones](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-zones/)**: guida ufficiale all’uso avanzato di selezione per hue/lightness/chroma[^manual-colorzones].

## Fonti

[^manual-colorbalance]: *darktable User Manual -- Color Balance RGB*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-balance-rgb/) | Copia locale: `processed/darktable-usermanual-en/usermanual-48-en-module-reference-processing-modules-color-balance-rgb.md`  
[^manual-coloreq]: *darktable User Manual -- Color Equalizer*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-equalizer/)
[^manual-toneeq]: *darktable User Manual -- Tone Equalizer*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/tone-equalizer/) | Copia locale: `processed/darktable-usermanual-en/usermanual-48-en-module-reference-processing-modules-tone-equalizer.md`
[^manual-contrasteq]: *darktable User Manual -- Contrast Equalizer*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/contrast-equalizer/) | Copia locale: `processed/darktable-usermanual-en/usermanual-48-en-module-reference-processing-modules-contrast-equalizer.md`
[^manual-diffuse]: *darktable User Manual -- Diffuse or Sharpen*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/diffuse/) | Copia locale: `processed/darktable-usermanual-en/usermanual-48-en-module-reference-processing-modules-diffuse.md`
[^manual-lut3d]: *darktable User Manual -- LUT 3D*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/lut-3d/)
[^pipeline]: *[The darktable pipeline for beginners](https://www.youtube.com/watch?v=1nPW6WPhhTo)* -- A Dabble in Photography
[^dt54]: *[darktable 5.4 NEW UPDATE](https://www.youtube.com/watch?v=yiTqUgoWg6Q)* -- A Dabble in Photography
[^dt52]: *[New Release: darktable 5.2](https://www.youtube.com/watch?v=YcLJMaDbfRA)* -- A Dabble in Photography
[^lowlight]: *[Lowlight photos in darktable](https://www.youtube.com/watch?v=O7wXgmQZqiU)* -- A Dabble in Photography
[^nightsky]: *[darktable Night Sky Full Edit](https://www.youtube.com/watch?v=5P0Yj_vqy5w)* -- A Dabble in Photography
[^dragan]: *[The Dragan effect in darktable](https://www.youtube.com/watch?v=EuvG0lh8OB8)* -- A Dabble in Photography
[^pixls-curves]: *[PIXLS.US – Basic Color Curves](https://pixls.us/articles/basic-color-curves/)*, 2026-04-10
[^manual-colorbalance-rgb]: *darktable User Manual – Color Balance RGB*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-balance-rgb/)
[^manual-colorzones]: *darktable User Manual – Color Zones*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-zones/)
[^filmic-prerequisites]: *darktable user manual – filmic rgb — prerequisites*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/filmic-rgb/#prerequisites)
