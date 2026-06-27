# Orton Effect & Dragan Effect in darktable

L’**Orton effect** e il **Dragan effect** sono due tecniche di post-produzione che creano un’atmosfera onirica, luminosa e drammatica rispettivamente:  
- **Orton**: glow morbido, etereo, con alta luminosità e leggera sfocatura — ideale per paesaggi, fiori e ritratti delicati[^orton-video].  
- **Dragan**: contrasto esploso, dettagli iper-definiti, ombre profonde e luci incandescenti — nato per ritratti drammatici e street photography[^dragon-video].  

Entrambi *non esistono come moduli nativi singoli* in darktable, ma si costruiscono combinando moduli esistenti nella pipeline scene-referred. Il modulo `soften` implementa l’Orton in modo semplificato, mentre il Dragan richiede un flusso avanzato con `composite`, `blur`, `sigmoid` e maschere locali[^orton-video][^dragon-video].

!!! tip "Perché non usare preset esterni?"
    I preset `.dtstyle` (es. *Red Max Payne*, *Lomo’s Effect*)[^maxpayne][^lomos] offrono scorciatoie stilistiche, ma **non replicano fedelmente Orton/ Dragán**, perché mancano del controllo fine sulla fusione dei livelli e sulla gestione della gamma dinamica. Usali solo come punto di partenza — non come soluzione definitiva[^orton-video].

---

## Panoramica del flusso di lavoro

Entrambi gli effetti richiedono una **duplicazione dell’immagine** per lavorare su livelli separati. Il posizionamento del modulo `composite` è critico: deve essere inserito *prima* di `tone curve`/`AGX`, ma *dopo* tutti i moduli di correzione base (esposizione, bilanciamento bianco, correzione ottica)[^dragon-video].

```
1. Correzioni base (exposure, white balance, lens correction)
   |
2. Duplicazione → creazione livello “sfocato” (Orton) o “inversione + fusione” (Dragan)
   |
3. Composite → fusione con modalità Multiply / Screen / Overlay
   |
4. AGX / Sigmoid → compressione tonale finale
   |
5. Affinamenti locali (local contrast, sharpen, color balance rgb)
```

!!! warning "Errore comune: ordine sbagliato di composite"
    Se `composite` è posizionato *dopo* `AGX`, la fusione avviene su dati già compressi → risultati piatti, senza profondità. Verifica sempre la posizione con il pulsante **Show module order** (icona a tre puntini in alto a destra del pannello moduli)[^dragon-video].

---

## Flusso pratico: Orton Effect con `soften`

Il metodo più rapido e controllabile per l’Orton è usare il modulo `soften`, progettato appositamente per replicare il processo analogico di Michael Orton[^soften-manual].

### Passo 1: Preparazione base
- Applica `exposure`: regola l’esposizione globale a **0.00 EV** (non sovraesporre prima di soften).
- Usa `white balance`: imposta un bilanciamento neutro (es. preset *Daylight* o pipetta su grigio neutro).
- Attiva `lens correction`: correggi distorsione e vignettatura (**distortion = 1.000**, **vignetting = 1.000**)[^dragon-video].

### Passo 2: Configurazione `soften`
Attiva il modulo `soften` e imposta:

| Parametro | Valore consigliato | Perché |
|-----------|---------------------|--------|
| **size** | `25–40%` | Controlla l’intensità della sfocatura. Valori >40% generano un glow eccessivo e perdita di dettaglio[^orton-video]. |
| **saturation** | `80–100%` | Aumenta la vividezza del livello sfocato, fondamentale per il glow cromatico[^orton-video]. |
| **brightness** | `+0.70–+1.20 EV` | Sovraesposizione del livello sfocato: +1.00 EV è il valore standard per Orton[^soften-manual]. |
| **mix** | `45–55%` | Bilancia tra immagine nitida (base) e sfocata (glow). 50% = fusione perfetta[^soften-manual]. |

### Passo 3: Affinamento finale
- Aggiungi `AGX`: usa **Contrast = 2.20–2.60** (non >3.00, altrimenti il glow diventa artificiale)[^orton-video].
- Usa `color balance rgb`: attenua leggermente il blu (**Blue attenuation = 20%**) prima di AGX per evitare clipping nei cieli[^dt54-update].
- Applica `vignetting`: bordo scuro sottile (**strength = -15%**, **radius = 70%**) per focalizzare l’attenzione sul centro[^lomos].

---

## Flusso pratico: Dragan Effect con `composite`

Il Dragan richiede 3 livelli: **originale**, **sfocato invertito**, **fuso in Multiply**. È un flusso avanzato ma preciso[^dragon-video].

### Passo 1: Creazione dei livelli
1. Clicca su **Duplicate** (icona copia nel pannello sinistro) → crea una copia.
2. Nella copia, applica:
   - `blur`: **blur_type = gaussian**, **blur_radius = 18–22 px** (valore dipende dalla risoluzione: 20 px per 6000px larghezza)[^dragon-video].
   - `invert`: attiva il modulo `invert` (non presente di default: abilitalo in *preferences > modules > invert*).
3. Torna all’immagine originale e attiva `composite`.

### Passo 2: Configurazione `composite`
Nel modulo `composite`, imposta:

| Parametro | Valore | Nota |
|-----------|--------|------|
| **blend mode** | `Multiply` | Fondamentale: intensifica le ombre e mantiene i dettagli nelle luci[^dragon-video]. |
| **opacity** | `85–95%` | Non al 100%: lascia trasparire un po’ di dettaglio dall’originale[^dragon-video]. |
| **mask** | `global` (nessuna maschera) | Il Dragan è un effetto globale. Evita maschere se non vuoi un look parziale. |

### Passo 3: Rafforzamento del contrasto
- Aggiungi `sigmoid`: attivalo *dopo* `composite`.
  - **contrast** = `1.80–2.20`  
  - **midtones** = `0.45–0.55`  
  - **black point** = `-0.10 EV`, **white point** = `+0.05 EV`  
  *(Questi valori evitano il clipping e preservano il dettaglio nei neri profondi)*[^dragon-video].

- Usa `local contrast`: applica una maschera sul volto/soggetto con **detail = 110–130%**, **highlights = 60%**, **shadows = 40%** per enfatizzare texture senza bruciare le luci[^dragon-video].

---

## Parametri chiave a confronto

| Effetto | Modulo chiave | Parametro | Valore tipico | Osservazione pratica |
|---------|----------------|------------|----------------|------------------------|
| **Orton** | `soften` | `size` | `34.55%` | Valori >45% rendono l’immagine “appannata”: controlla zoom 100% sui bordi[^orton-video]. |
| **Orton** | `soften` | `brightness` | `+1.00 EV` | Se l’immagine appare troppo lavata, riduci a `+0.70 EV` e aumenta `saturation`[^soften-manual]. |
| **Dragan** | `blur` | `blur_radius` | `20 px` | Su immagini <4000px, usa `12–15 px`. Troppo poco → nessun effetto; troppo → artefatti da aliasing[^dragon-video]. |
| **Dragan** | `composite` | `opacity` | `90%` | Valori <80% indeboliscono il dramma; >95% appiattiscono il volume tonale[^dragon-video]. |
| **Entrambi** | `AGX` | `Shoulder power` | `1.20–1.40` | Riduci rispetto al default (1.55) per preservare i dettagli nelle luci glow/drammatiche[^agx-guide]. |

---

## Walkthrough da video tutorial

### Esempio: Orton con blur + composite (metodo alternativo)
*Da [The Orton effect in darktable](https://www.youtube.com/watch?v=OF7ZcDPQfeM) (03:30–07:40)*  
1. Duplica l’immagine → nella copia applica `blur` con **blur_radius = 20 px**, **blur_type = gaussian**.  
2. Attiva `composite` sull’originale e imposta **blend mode = Multiply**, **opacity = 90%**, **mask = global**.  
3. Aggiungi `sigmoid` dopo `composite`: **contrast = 1.90**, **midtones = 0.50**, **black point = -0.08 EV**, **white point = +0.03 EV**[^orton-video].  
4. Usa `color balance rgb`: attiva **shadows lift** con **red = 1.05**, **green = 0.98**, **blue = 0.92**, per riscaldare le ombre senza alterare i toni medi[^orton-video].  

### Esempio: Dragan con doppia maschera locale
*Da [The Dragan effect in darktable](https://www.youtube.com/watch?v=EuvG0lh8OB8) (04:20–08:15)*  
1. Duplica l’immagine → nella copia applica `blur` (**radius = 21 px**) + `invert`.  
2. Attiva `composite`: **blend mode = Multiply**, **opacity = 88%**, **mask = global**.  
3. Nell’originale, aggiungi `local contrast`: **mode = local laplacian**, **detail = 125%**, **highlights = 50%**, **shadows = 45%**, **mid-tone range = 0.52**.  
4. Disegna una maschera a mano sul volto (forma irregolare), poi imposta **feathering radius = 8 px**, **blurring radius = 3 px**, **mask contrast = +0.25**, **mask opacity = +0.15**[^dragon-video].  
5. Infine, applica `color balance rgb`: **global vibrance = 110%**, **contrast = 2.05**, **contrast gray fulcrum = 18.5%**, **white fulcrum = +0.15 EV**[^dragon-video].

---

## Domande frequenti

### Problema: Il glow Orton appare "sporco" o con artefatti cromatici
Questo accade quando `soften` è applicato su un'immagine con bilanciamento bianco instabile o con saturazione eccessiva. Risolvi impostando prima `white balance` con la pipetta su un'area neutra (grigio chiaro), quindi limitando `saturation` in `soften` a ≤95% e verificando che `exposure` sia ≥ -0.20 EV prima del modulo[^soften-manual].  

### Problema: Il Dragan produce ombre "piatte" e prive di dettaglio
La causa è quasi sempre un `blur_radius` troppo elevato (>25 px su immagini 6000px) o un `opacity` in `composite` troppo vicino a 100%. Riduci `blur_radius` a 18–20 px e abbassa `opacity` a 85–88%; aggiungi poi `local contrast` con **shadows = 40–45%**, **detail = 115%**, applicato tramite maschera sulle zone d’ombra[^dragon-video].  

### Problema: L’effetto scompare dopo l’esportazione in JPEG
Questo indica che il `composite` è stato posizionato *dopo* `dither or posterize` o che `dither or posterize` è disattivato. Abilita `dither or posterize` subito *prima* dell’esportazione, con **method = Floyd-Steinberg auto**, per prevenire banding nei gradienti glow e Dragan[^dither-manual].  

---

## Consigli operativi

!!! tip "Workflow ottimale per entrambi"
    1. Lavora sempre su **copia duplicata**, mai sull’originale.  
    2. Usa **snapshot** per salvare stati intermedi (*Original*, *Orton base*, *Dragan full*).  
    3. Prima di esportare, verifica con `scopes` → `histogram`: il picco delle luci deve essere a **~95–98%**, mai al 100% (clipping)[^dragon-video].

!!! warning "Cosa evitare assolutamente"
    - **Usare `soften` dopo `AGX`**: il glow viene compresso prematuramente → risultato opaco[^orton-video].  
    - **Applicare `composite` in `Screen` per Dragan**: genera alone innaturali e perdita di controllo sulle ombre[^dragon-video].  
    - **Aumentare `saturation` oltre il 100% in `soften`**: introduce artefatti cromatici irreversibili[^soften-manual].

!!! info "Ottimizzazione per prestazioni"
    Su immagini ad alta risoluzione (>24 MP), riduci temporaneamente la preview con **zoom = 1:2** durante l’editing di `soften` o `composite`. Questo riduce il carico CPU/GPU senza compromettere la precisione dei parametri. Ripristina il 1:1 prima del controllo finale[^performance-tips].

---

## Risorse utili

- [Video tutorial Orton in darktable (inglese)](https://www.youtube.com/watch?v=OF7ZcDPQfeM) — metodo `soften`, `blur` + `composite`[^orton-video]  
- [Video tutorial Dragan in darktable (inglese)](https://www.youtube.com/watch?v=EuvG0lh8OB8) — flusso completo con `composite`, `invert`, `sigmoid`[^dragon-video]  
- [Manuale ufficiale `soften`](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/soften/) — documentazione tecnica completa[^soften-manual]  
- [Manuale ufficiale `composite`](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/composite/) — spiegazione approfondita delle modalità di fusione[^composite-manual]  
- [Manuale ufficiale `dither or posterize`](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/dither-or-posterize/) — guida alla prevenzione del banding[^dither-manual]  
- [Manuale ufficiale `color balance rgb`](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-balance-rgb/) — controllo avanzato della tonalità e cromia[^color-balance-rgb-manual]  

---

## Fonti

[^orton-video]: A Dabble in Photography, *The Orton effect in darktable*, YouTube, 2026. URL: https://www.youtube.com/watch?v=OF7ZcDPQfeM
[^dragon-video]: A Dabble in Photography, *The Dragan effect in darktable*, YouTube, 2026. URL: https://www.youtube.com/watch?v=EuvG0lh8OB8
[^soften-manual]: darktable User Manual v4.8, *soften module*, https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/soften/
[^composite-manual]: darktable User Manual v4.8, *composite module*, https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/composite/
[^maxpayne]: darktable.fr, *Style Red Max Payne Effect*, 2016. URL: https://darktable.fr/posts/2016/03/style-red-max-payne-effect/
[^lomos]: darktable.fr, *Style Lomo's Effect*, 2016. URL: https://darktable.fr/posts/2016/04/style-lomos-effect/
[^dt54-update]: darktable 5.4 Release Notes, *AGX as default tone mapper*, https://github.com/darktable-org/darktable/releases/tag/release-5.4.0
[^agx-guide]: darktable Documentation, *AGX Tone Mapping Guide*, https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/agx/
[^dither-manual]: darktable User Manual v4.8, *dither or posterize module*, https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/dither-or-posterize/
[^color-balance-rgb-manual]: darktable User Manual v4.8, *color balance rgb module*, https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-balance-rgb/
[^performance-tips]: darktable User Manual v4.8, *Performance tuning guide*, https://docs.darktable.org/usermanual/development/en/preferences-settings/performance/
