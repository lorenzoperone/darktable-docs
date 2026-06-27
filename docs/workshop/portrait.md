# Ritratto -- Effetto Dragan e ritratto chiaroscuro

> **Fonti:** [The Dragan effect in darktable](https://www.youtube.com/watch?v=EuvG0lh8OB8) -- A Dabble in Photography | [An Open Source Portrait (Mairi)](https://pixls.us/articles/an-open-source-portrait-mairi/) -- Pat David

Due approcci al ritratto: l'effetto **Dragan** (alto contrasto, look drammatico) e il workflow **chiaroscuro** classico (toni pelle naturali, morbidezza controllata).

---

## Parte A -- Effetto Dragan (ritratto ad alto contrasto)

### Contesto

L'effetto Dragan -- dal fotografo Andrzej Dragan -- produce ritratti con contrasto estremo, texture della pelle enfatizzata e colori desaturati. In darktable si ottiene componendo l'immagine su se stessa con modalita' di fusione.

### Passo 1 -- Correzioni preliminari

Partire dalle correzioni di base prima di qualsiasi effetto creativo:

**Tone Curve (o AgX):**
| Parametro | Valore |
|-----------|--------|
| Black relative exposure | -10.00 EV |
| Dynamic range scaling | +10.00% |
| Contrast | 2.80 |
| Toe power | 1.55 |
| Shoulder power | 1.55 |

**Lens Correction:**
| Parametro | Valore |
|-----------|--------|
| Distortion | 1.000 (auto) |
| Vignetting | 1.000 (auto) |
| TCA red | 1.000 (auto) |
| TCA blue | 1.000 (auto) |

!!! tip "Correzioni ottiche prima delle maschere"
    Applicare Lens Correction prima di creare maschere: se la correzione modifica la geometria dell'immagine, le maschere si aggiornano automaticamente.

### Passo 2 -- Creare il duplicato per il Composite

La tecnica Dragan si basa sulla composizione dell'immagine su se stessa:

1. Duplicare l'immagine (Ctrl+D)
2. Sul duplicato, applicare il modulo **Composite**
3. Impostare l'immagine di base come sorgente

**Composite:**
| Parametro | Valore |
|-----------|--------|
| Blend mode | **Overlay** oppure **Hard Light** |
| Opacity | 100.00% (poi ridurre se troppo intenso) |
| Mode | RGB (scene) |

!!! warning "Modalita' di fusione e clipping"
    **Multiply** clippa le alte luci -- preferire **Overlay** o **Hard Light** per l'effetto Dragan. Monitorare sempre l'istogramma dopo l'applicazione.

### Passo 3 -- Sharpening selettivo

Per enfatizzare la texture senza creare artefatti:

**Highpass:**
| Parametro | Valore |
|-----------|--------|
| Sharpness | ~52.57% |
| Contrast boost | ~25.68% |

**Oppure Diffuse or Sharpen:**
| Parametro | Valore |
|-----------|--------|
| Central radius | 0 px |
| Radius span | 512 px |
| 1st order speed | -20.00% |
| 3rd order speed | -20.00% |
| 2nd/4th order speed | +10.00% |
| 1st/3rd order anisotropy | +200.00% |
| Edge sensitivity | 1.86 |
| Edge threshold | +0.25 |

!!! info "De-haze come effetto drammatico"
    Il modulo Diffuse or Sharpen puo' essere usato per un effetto de-haze aggressivo: aumentare i valori fino a 15-20 per un contrasto drammatico. Attenzione: senza maschera produce artefatti scuri ai bordi.

### Passo 4 -- Desaturazione selettiva dei toni pelle

**Color Equalizer (tab Saturation):**
| Parametro | Valore |
|-----------|--------|
| Nodo su rossi/toni pelle | Ridurre saturazione localmente |
| White level | +1.00 EV |
| Hue analysis radius | 1.5 px |
| Saturation threshold | 10.0% |
| Use guided filter | True |

!!! tip "Maschera di fusione per controllare l'intensita'"
    Se la desaturazione e' troppo aggressiva, ridurre l'opacita' della maschera di fusione (es. 47%) invece di modificare i parametri del modulo.

### Passo 5 -- Vignettatura creativa e contrasto finale

**Vignettatura:** applicata per attirare l'attenzione sul volto.

**Contrast Equalizer (Luma):**
| Parametro | Valore |
|-----------|--------|
| Mix | +1.00 (poi ridurre a gusto) |
| Luma contrast | Aumentare con cautela |

!!! warning "Contrasto locale: dosare con delicatezza"
    Il Contrast Equalizer puo' produrre effetti eccessivi se non dosato con estrema delicatezza. Iniziare con valori bassi e aumentare gradualmente.

### Passo 6 -- Confronto con snapshot

Usare il sistema **Snapshot** per confrontare prima/dopo ad ogni passaggio chiave:

1. Creare uno snapshot dopo le correzioni di base
2. Creare un secondo snapshot dopo il Composite
3. Creare un terzo snapshot dopo il color grading
4. Usare il confronto laterale per valutare l'impatto di ogni passo

---

## Parte B -- Ritratto chiaroscuro (workflow classico)

> Basato su [An Open Source Portrait (Mairi)](https://pixls.us/articles/an-open-source-portrait-mairi/) di Pat David, adattato per darktable.

### Passo 1 -- Esposizione

Nel workflow chiaroscuro, l'esposizione e' tutto. Spingere l'esposizione fino a quando un canale RGB sfiora il lato destro dell'istogramma:

| Parametro | Valore |
|-----------|--------|
| Exposure Compensation | ~2.30 EV (variabile) |
| Black point | ~150 (controllare dettaglio ombre) |

!!! tip "Indicatori di clipping"
    Attivare gli indicatori di clipping per alte luci e ombre: le alte luci sul volto del soggetto sono priorita' assoluta da preservare.

### Passo 2 -- Bilanciamento del bianco

Usare **Spot WB** su un'area che dovrebbe essere neutra:

- Una parete grigia sullo sfondo
- Un bordo bianco noto
- Un cartoncino grigio 18% scattato durante il set

| Parametro | Valore |
|-----------|--------|
| Temperature | ~7300 K (dipende dalla fonte) |
| Tint | ~0.545 |

### Passo 3 -- Riduzione rumore

Per ritratti a ISO elevati, bilanciare riduzione rumore e conservazione del dettaglio:

| Modulo | Parametro | Valore | Note |
|--------|-----------|--------|------|
| Denoise (profiled) | -- | Auto | Primo passo |
| Impulse NR | Threshold | 55-70 | Sale e pepe |
| Luminance NR | Amount | 6 | Non esagerare |
| Chrominance NR | Amount | 6 | Controllare l'iride |

!!! warning "Crominanza e dettaglio dell'iride"
    Spingere troppo la Chrominance NR fa perdere i colori bellissimi dell'iride. Controllare sempre a zoom 200% sull'occhio del soggetto.

### Passo 4 -- Contrasto locale e Color Balance

**Local Contrast:**
| Parametro | Valore |
|-----------|--------|
| Radius | 17 (per ritratti ravvicinati) |
| Contrast | 0.5 |
| Detail | 0.3 |
| Sharpen | 0.0 |

**Color Balance RGB:**
- Preset: **standard** oppure **vibrant colors**
- Basic colourfulness: aumentare moderatamente
- Desaturare leggermente i toni della pelle tramite Color Equalizer

---

## Riepilogo impostazioni -- Effetto Dragan

| Modulo | Parametri chiave | Scopo |
|--------|-----------------|-------|
| **Tone Curve / AgX** | Black -10 EV, Contrast 2.80 | Base tonale |
| **Lens Correction** | Auto (distortion, vignetting, TCA) | Correzioni ottiche |
| **Composite** | Blend mode: Overlay/Hard Light | Effetto Dragan |
| **Highpass** | Sharpness ~53%, Contrast boost ~26% | Nitidezza bordi |
| **Diffuse or Sharpen** | De-haze speeds, anisotropy +200% | Texture drammatica |
| **Color Equalizer** | Desaturazione toni pelle | Look desaturato |
| **Contrast Equalizer** | Mix +1.00, Luma contrast | Contrasto finale |

## Riepilogo impostazioni -- Ritratto chiaroscuro

| Modulo | Parametri chiave | Scopo |
|--------|-----------------|-------|
| **Esposizione** | Exposure ~2.30 EV, Black ~150 | Esposizione corretta |
| **White Balance** | Spot WB su area neutra | Colori naturali |
| **Denoise** | Profiled auto + Luminance/Chrominance 6 | Rumore controllato |
| **Local Contrast** | Radius 17, Contrast 0.5 | Profondita' |
| **Color Balance RGB** | Standard/vibrant, colourfulness | Colori ritratto |
| **Color Equalizer** | Desaturazione selettiva pelle | Toni pelle naturali |

---

## Modulo `portrait skin tone retouch`: guida operativa

Il modulo `portrait skin tone retouch` **non esiste come modulo nativo in darktable 5.4+**. Questa denominazione è un errore comune derivante da confusione con strumenti di altri software (es. Capture One, Adobe Camera Raw), oppure da vecchi tutorial pre-3.0 che facevano riferimento a workflow personalizzati basati su combinazioni di moduli. darktable non include un modulo monolitico dedicato al “ritocco pelle”, ma offre una pipeline flessibile e precisa per ottenere lo stesso risultato attraverso tre moduli fondamentali: **`tone equalizer`**, **`color equalizer`**, e **`retouch`**, spesso usati in sinergia con maschere parametriche e wavelet decomposition.

Questo approccio consente un controllo granulare sui diversi aspetti della pelle — luminosità locale, saturazione cromatica, texture fine, imperfezioni — senza compromettere la linearità della pipeline scene-referred[^dt-manual-tone-equalizer].

### Flusso di lavoro consigliato per il ritocco pelle

Il workflow moderno per il ritocco pelle in darktable segue un ordine fisso per massimizzare la precisione e prevenire artefatti:

1. **Preparazione della maschera guidata** con `tone equalizer`  
2. **Controllo tonale locale** (dodging/burning) con `tone equalizer`  
3. **Controllo cromatico selettivo** con `color equalizer`  
4. **Ritocco microscopico** con `retouch` (wavelet decomposition)  

Ogni fase opera su una scala differente: la prima gestisce l’intera zona della pelle come blocco luminoso; la seconda regola la saturazione solo nei toni specifici della pelle; la terza interviene a livello di pori, capillari e texture superficiale.

### Parametri chiave per il ritocco pelle

#### `tone equalizer` — Maschera guidata e controllo tonale

Il `tone equalizer` è il cuore del ritocco pelle, poiché permette di isolare la pelle tramite una **guided mask** calibrata sulla sua luminosità media (tipicamente tra **–2.5 EV e –0.5 EV**, a seconda della carnagione e dell’illuminazione). La qualità della maschera determina il successo dell’intero processo.

| Parametro | Valore tipico | Range utile | Note |
|-----------|-------------|-------------|------|
| `luminance estimator` | `RGB euclidean norm` | `RGB euclidean norm`, `Jz Cz hz` | Per pelle, `RGB euclidean norm` dà maggiore coerenza tonale rispetto a `Jz Cz hz`[^dt-manual-tone-equalizer] |
| `preserve details` | `eigf` | `eigf`, `guided filter`, `no` | `eigf` è il default e garantisce uniformità tra luci e ombre della pelle[^dt-manual-tone-equalizer] |
| `smoothing diameter` | `3.5 %` | `1–10 %` | Valori >5% possono causare “halo” ai bordi del viso; <2% rendono la maschera troppo granulare[^dt-manual-tone-equalizer] |
| `mask exposure compensation` | `+0.25 EV` | `−1.0 → +1.0 EV` | Compensa l’esposizione globale: se la pelle appare troppo scura nell’istogramma della maschera, spostare verso destra[^dt-manual-tone-equalizer] |
| `mask contrast compensation` | `+15 %` | `−50 → +100 %` | Espande l’istogramma della maschera per migliorare la separazione tra pelle e sfondo (es. capelli, vestiti)[^dt-manual-tone-equalizer] |

!!! tip "Verifica della maschera"
    Premere `display exposure mask` nella tab *masking*: la pelle deve apparire come una regione continua e omogenea (grigio medio), senza buchi o frastagliature. Se la maschera “salta” sul naso o sulle guance, aumentare `mask contrast compensation` e/o ridurre `smoothing diameter`.

#### `color equalizer` — Controllo cromatico selettivo

Una volta isolata la pelle, `color equalizer` permette di agire su **saturazione**, **luminosità** e **tinta** solo nei toni pelle, evitando di alterare occhi, labbra o abbigliamento.

| Parametro | Valore tipico | Range utile | Note |
|-----------|-------------|-------------|------|
| `hue analysis radius` | `2.0 px` | `0.5 → 5.0 px` | Maggiore valore = maggiore tolleranza all’eterogeneità cromatica della pelle (es. lentiggini, rossori)[^dt-manual-color-equalizer] |
| `saturation threshold` | `12.0 %` | `5 → 25 %` | Filtra il rumore cromatico: valori <10% possono includere artefatti, >20% escludono zone di pelle con pigmentazione atipica[^dt-manual-color-equalizer] |
| `white level` | `+0.50 EV` | `−1.0 → +2.0 EV` | Alza il limite superiore della selezione per includere anche le aree più illuminate del viso (fronte, zigomi)[^dt-manual-color-equalizer] |
| `use guided filter` | `True` | `True`, `False` | Abilita il filtro guidato per evitare bordi netti; obbligatorio per transizioni naturali[^dt-manual-color-equalizer] |

!!! warning "Sovrapposizione con `color calibration`"
    Non usare contemporaneamente `color equalizer` e `color calibration` (tab *colorfulness*) per il controllo della pelle: generano conflitti di pipeline e artefatti cromatici. Preferire `color equalizer` per correzioni locali e `color calibration` solo per bilanciamento globale[^dt-manual-color-calibration].

#### `retouch` — Ritocco microscopico con wavelet

Per rimuovere imperfezioni senza appiattire la texture, il modulo `retouch` in modalità **wavelet decomposition** è insostituibile. Si lavora esclusivamente sulle scale più coarse (livelli 1–3 su 6), dove compaiono macchie, pori dilatati e irregolarità di tono, lasciando intatta la scala fine (capelli, peluria, rughe sottili).

| Parametro | Valore tipico | Range utile | Note |
|-----------|-------------|-------------|------|
| `scales` | `6` | `4 → 8` | Immagini ad alta risoluzione (≥24 MP) beneficiano di 7–8 scale[^dt-manual-retouch] |
| `current` | `2` | `1 → 4` | Scala 2 contiene le strutture più rilevanti per la pelle (pori, lentiggini, rossori)[^dt-manual-retouch] |
| `merge from` | `2` | `0 → max scale` | Impostato a `2` applica ogni correzione solo alla scala corrente; `0` disabilita la fusione[^dt-manual-retouch] |
| `algorithm` | `heal` | `clone`, `heal`, `blur`, `fill` | `heal` è preferibile a `clone`: bilancia automaticamente luminosità e crominanza con il contesto circostante[^dt-manual-retouch] |

!!! info "Heal vs Clone"
    Il tool `heal` utilizza un algoritmo di blending basato su patch matching e media mobile, mentre `clone` copia pixel identici. Per la pelle, `heal` previene il “look plastico” tipico del clone e mantiene la naturalezza della texture[^dt-manual-retouch].

### Consigli avanzati

- **Maschere combinate**: per isolare la pelle con maggiore precisione, combinare una maschera parametrica di luminanza (`tone equalizer`) con una maschera disegnata (ellisse attorno al volto) usando la modalità **exclusive** nel gestore maschere[^dt-video-masking-ep5].  
- **Controllo della luminosità relativa**: prima di usare `tone equalizer`, verificare che il modulo `exposure` abbia posizionato correttamente il grigio medio della scena (≈18.45%); un’esposizione errata compromette la qualità della maschera guidata[^dt-manual-process].  
- **Preservazione della tridimensionalità**: evitare di applicare `retouch` su scale >4: si perdono i dettagli di profondità (ombre sotto gli zigomi, illuminazione del naso) e l’immagine diventa bidimensionale[^dt-video-diffuse-sharpen].  
- **Workflow per carnagioni scure**: aumentare `mask exposure compensation` a `+0.75 EV` e ridurre `mask contrast compensation` a `+5 %` per evitare che la maschera includa zone troppo scure (collo, orecchie) o troppo luminose (riflessi frontali)[^dt-video-bw-photography].

### Esempio: ritocco pelle con toni naturali (da video tutorial)

*Da [ENG] Full b&w edits in darktable for street photography](https://www.youtube.com/watch?v=f9szYMJ9wYo) (timestamp 05:30–08:15)*  
1. Attivare `tone equalizer`, tab *masking*, impostare `smoothing diameter = 3.5 %`, `mask exposure compensation = +0.25 EV`, `mask contrast compensation = +15 %`.  
2. Premere `display exposure mask`: la pelle deve apparire come un’unica area grigia omogenea.  
3. Passare alla tab *advanced*, spostare il punto di controllo a **–1.5 EV** verso l’alto di `+0.30 EV` per lieve *dodging* sulle guance.  
4. Attivare `color equalizer`, tab *saturation*, impostare `hue analysis radius = 2.0 px`, `saturation threshold = 12.0 %`, `white level = +0.50 EV`.  
5. Ridurre la saturazione del nodo rosso di `−15 %` per attenuare rossori, mantenendo inalterata la saturazione dei blu (occhi) e verdi (sfondo).  
6. Attivare `retouch`, impostare `scales = 6`, `current = 2`, `algorithm = heal`, disegnare cerchi piccoli (diametro ≈ 10 px) su lentiggini e macchie.

### Esempio: ritocco pelle per effetto Dragan (da video tutorial)

*Da [ENG] The diffuse and sharpen module](https://www.youtube.com/watch?v=jHlPh7gt3Y0) (timestamp 07:22–10:45)*  
1. Attivare `diffuse or sharpen`, impostare `central radius = 0 px`, `radius span = 128 px`, `1st order speed = −35.0 %`, `3rd order speed = −35.0 %`, `1st/3rd order anisotropy = +250.0 %`.  
2. Applicare una maschera parametrica di luminanza su `tone equalizer` (valore `–1.0 EV`) per limitare l’effetto alla pelle.  
3. Nella tab *masking*, impostare `edges refinement/feathering = 3.0` per evitare halo ai bordi del viso.  
4. Usare `retouch` in modalità `blur` (tipo `bilateral`) su scala 1 per sfumare delicatamente i pori, mantenendo i bordi degli occhi e delle labbra netti.

---

## Domande frequenti

### Problema: la maschera di `tone equalizer` include capelli o occhi
La maschera guidata è troppo ampia perché l’istogramma della pelle non è ben separato dal resto dell’immagine. Soluzione: ridurre `smoothing diameter` a `2.0 %`, aumentare `mask contrast compensation` a `+25 %`, quindi usare una maschera disegnata (ellisse) in modalità **exclusive** per escludere manualmente le zone indesiderate[^dt-video-masking-ep5].

### Problema: il ritocco con `retouch` crea artefatti “a blocchi”
Questo accade quando si usa `merge from > 0` su immagini con alta frequenza di dettaglio (es. barba, capelli ricci). Soluzione: impostare `merge from = 0`, lavorare solo sulla scala corrente, e usare `algorithm = heal` invece di `clone`[^dt-manual-retouch].

### Problema: la pelle appare “troppo verde” dopo `color equalizer`
È causato da un’eccessiva correzione della tinta (hue) in presenza di illuminazione fluorescente o LED. Soluzione: disattivare la correzione hue in `color equalizer` e usare invece `color calibration` (tab *CAT*) con `illuminant = custom` e `hue` regolato su `120°` (verde) per compensare l’illuminante dominante[^dt-manual-color-calibration].

---

## Risorse

- [darktable Manual — Tone Equalizer](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/tone-equalizer/) — *Documentazione completa del modulo*
- [darktable Manual — Color Equalizer](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-equalizer/) — *Parametri e comportamento della maschera cromatica*
- [darktable Manual — Retouch](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/retouch/) — *Guida alla wavelet decomposition e al tool heal*
- [A Dabble in Photography — Masking Episode 5](https://www.youtube.com/watch?v=eTSRnz-ZMzU) — *Workflow pratico per maschere combinate*
- [A Dabble in Photography — Diffuse and Sharpen](https://www.youtube.com/watch?v=jHlPh7gt3Y0) — *Applicazione avanzata per texture pelle*

---

## Fonti

[^dt-manual-tone-equalizer]: *darktable user manual - tone equalizer*, [https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/tone-equalizer/](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/tone-equalizer/)
[^dt-manual-color-equalizer]: *darktable user manual - color equalizer*, [https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-equalizer/](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-equalizer/)
[^dt-manual-color-calibration]: *darktable user manual - color calibration*, [https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-calibration/](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-calibration/)
[^dt-manual-retouch]: *darktable user manual - retouch*, [https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/retouch/](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/retouch/)
[^dt-manual-process]: *darktable user manual - process*, [https://docs.darktable.org/usermanual/development/en/overview/workflow/process/](https://docs.darktable.org/usermanual/development/en/overview/workflow/process/)
[^dt-video-masking-ep5]: *[ENG] darktable masking episode 5*, [https://www.youtube.com/watch?v=eTSRnz-ZMzU](https://www.youtube.com/watch?v=eTSRnz-ZMzU)
[^dt-video-diffuse-sharpen]: *[ENG] The diffuse and sharpen module*, [https://www.youtube.com/watch?v=jHlPh7gt3Y0](https://www.youtube.com/watch?v=jHlPh7gt3Y0)
[^dt-video-bw-photography]: *[ENG] darktable Black&White photography*, [https://www.youtube.com/watch?v=efWVSR93m5k](https://www.youtube.com/watch?v=efWVSR93m5k)
