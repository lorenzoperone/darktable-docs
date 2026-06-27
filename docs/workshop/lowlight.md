# Scarsa illuminazione — Concerto e foto notturne

> **Fonti:** [Lowlight photos in darktable](https://www.youtube.com/watch?v=O7wXgmQZqiU) — A Dabble in Photography | [darktable Night Sky Full Edit](https://www.youtube.com/watch?v=5P0Yj_vqy5w) — A Dabble in Photography

*Figura 1 — Immagine lowlight: luci sceniche viola, ISO 2000, esposizione da recuperare.*

Due scenari di scarsa illuminazione: un concerto con luci sceniche colorate (ISO 2000) e un paesaggio notturno al crepuscolo.

---

## Parte A — Foto di un concerto

### Contesto

Fujifilm X-T2, 50mm, f/2.8, 1/250s, **ISO 2000**. Scena con illuminazione scenica viola e bianca. La sfida principale: recuperare dettagli dai volti dei musicisti senza distruggere l'atmosfera della scena.

### Passo 1 — Configurazione rapida dell'esposizione

Configurare una scorciatoia da tastiera per l'esposizione: premere `E` per attivare il modulo e usare la rotella del mouse per regolare rapidamente.

**Exposure:**
| Parametro | Valore |
|-----------|--------|
| Exposure | +1.000 EV (poi aumentare ulteriormente) |
| Black level correction | -0.0002 |

!!! tip "Scorciatoia E + rotella"
    Assegnare il modulo Exposure alla scorciatoia `E` e usare la rotella del mouse per regolazioni rapide. Fondamentale quando si lavora su molte immagini in sessione.

*Figura 2 — Regolazione rapida dell'esposizione con scorciatoia E + rotella.*

### Passo 2 — Pipeline con AGX

Per le foto a luci miste, **AGX+** è preferibile per evitare tonalità magenta indesiderate:

| Parametro | Valore |
|-----------|--------|
| Output color profile | **AgX+** scene-referred default |
| Input color profile | scene-referred default |

!!! info "Perché AGX+ per il lowlight"
    AGX+ gestisce meglio i colori saturi (come le luci viola di un palco) senza generare blocchi di colore innaturali. Il profilo AgX+ è specificamente ottimizzato per scene con colori dominanti forti[^agx-plus-optimization].

### Passo 3 — AGX avanzato: controllo tonale

**AGX (impostazioni principali):**
| Parametro | Valore |
|-----------|--------|
| White relative exposure | 6.50 EV |
| Black relative exposure | -10.00 EV |
| Dynamic range scaling | +10.00% |
| Pivot relative exposure | +0.00 EV |
| Pivot target output | 18.00% |
| Contrast | 2.80 |
| Shoulder power | 1.55 |
| Toe power | 1.55 |

!!! warning "Preservare i volti"
    Non aumentare eccessivamente il contrasto per preservare i dettagli facciali. Usare **shoulder power** e **toe power** invece del cursore contrasto generico per un controllo più preciso su luci e ombre[^agx-shoulder-toe].

*Figura 3 — Configurazione AGX+ per luci sceniche viola: shoulder/toe al posto del contrasto generico.*

**AGX (parametri avanzati della curva):**
| Parametro | Valore | Note |
|-----------|--------|------|
| Shoulder start | 17.54% | Anticipa il contrasto nelle medie-luci |
| Toe power | 2.37 | Approfondisce le ombre |
| Curve gamma | 2.20 | Default |

### Passo 4 — Calibrazione colore: Primaries

Per recuperare vivacità cromatica dopo AGX:

**Color Calibration (tab Primaries):**
| Parametro | Valore |
|-----------|--------|
| Red attenuation | 10.00% |
| Red rotation | +2.0 |
| Green attenuation | 10.00% |
| Green rotation | -1.0 |
| Blue attenuation | 15.00% |
| Blue rotation | -3.0 |
| Master purity boost | 0.00% |
| Red purity boost | 10.00% |
| Green purity boost | 10.00% |

!!! tip "Evitare il look troppo neutro"
    L'attenuazione del rosso al 10% evita un rendering troppo neutro o tendente al bianco e nero. Ogni colore primario richiede una regolazione diversa in base alla scena[^primaries-attenuation].

### Passo 5 — Color Equalizer per contrasto e brillanza

**Color Equalizer:**
| Parametro | Valore | Scopo |
|-----------|--------|-------|
| Shadows | -8.16% | Scurire ombre per contrasto |
| Mid-tones | -5.74% | Recuperare dettagli volti |
| Highlights | +12.39% | Controllare luci del palco |

!!! info "Strategia ombre-luci"
    Ridurre ombre e toni medi aumenta il contrasto percepito e recupera dettagli sui volti. Aumentare le luci controlla la saturazione delle luci sceniche senza slavare i colori[^color-equalizer-lowlight].

*Figura 4 — Color Equalizer: ombre/toni medi scuriti per contrasto, luci aumentate per controllare saturazione.*

### Passo 6 — Color Balance RGB per raffinamento

**Color Balance RGB:**
| Parametro | Valore |
|-----------|--------|
| Mode | Standard o Custom |
| Perceptual brilliance | Variabile per zone |

Usare per controllare lo spill cromatico (colore che "sborda" da aree molto saturate) e recuperare dettagli nelle zone sovraesposte dalle luci sceniche.

*Figura 5 — Color Balance RGB: controllo spill cromatico e recupero dettagli luci sceniche.*

---

## Parte B — Paesaggio notturno al crepuscolo

### Contesto

*Figura 6 — Paesaggio notturno: edificio illuminato, cielo interessante ma immagine piatta.*

Sony ILCE-7RM3, 24mm, f/4.0, ISO 800. Scena al crepuscolo con edificio illuminato internamente. Il cielo ha colori interessanti ma l'immagine è piatta e il primo piano è troppo scuro.

### Passo 1 — Valutazione del file RAW

Verificare la presenza di dati nelle alte luci **prima** di aumentare l'esposizione:

| Parametro | Valore |
|-----------|--------|
| Output color profile | Filmic RGB, scene-referred default |
| Input color profile | scene-referred default |
| Denoise | Profiled |
| Highlight reconstruction | Disabled |
| White balance | As shot |

!!! tip "Controllare i dati RAW"
    Prima di aumentare l'esposizione, verificare che i canali RGB non siano clipped. Un canale già al limite non recupererà dettagli aumentando l'esposizione[^raw-data-check].

### Passo 2 — Esposizione aggressiva e compressione tonale

**Exposure:**
| Parametro | Valore |
|-----------|--------|
| Exposure | **+2.802 EV** |
| Black level correction | 0.0002 |

**Filmic RGB:**
| Parametro | Valore | Note |
|-----------|--------|------|
| White relative exposure | 4.88 EV | Ricco di colore negli highlight |
| Black relative exposure | -13.34 EV | Illuminare le ombre |

*Figura 8 — Filmic RGB: compressione tonale per recuperare dettagli dal RAW notturno.*

!!! info "Look only per la curva"
    La modalità *look only* nella curva Filmic RGB mostra l'effetto senza modifiche permanenti — utile per sperimentare prima di applicare[^filmic-look-only].

### Passo 3 — Strategia cielo / primo piano separati

Creare due istanze di **Exposure** con maschere inverse:

*Figura 7 — Maschera Exposure: cielo e primo piano separati con maschera disegnata + Jz parametrica.*

**Exposure (istanza "sky"):**
| Parametro | Valore |
|-----------|--------|
| Drawn mask | Tracciato a mano sul cielo |
| Parametric mask | Jz (luminanza) |
| Combine masks | Exclusive |

**Exposure (istanza "ground"):**
| Parametro | Valore |
|-----------|--------|
| Maschera | Inversa dell'istanza sky |
| Target | Primo piano |

### Passo 4 — Correzione ottica

**Lens Correction:**
| Parametro | Valore |
|-----------|--------|
| Lens data read | Sì (auto) |
| Vignetting | Corretto |

!!! tip "Lens correction prima delle maschere"
    Poiché la correzione dell'obiettivo viene applicata prima del modulo sky, la maschera si aggiorna automaticamente (remasked) per adattarsi alla nuova geometria dell'immagine[^lens-correction-remasking].

### Passo 5 — Regolazione avanzata del cielo

**Color Calibration (istanza "sky"):**
| Parametro | Valore |
|-----------|--------|
| Adaptation | CAT16 (CIECAM16) |
| Illuminant | Custom |
| Hue | 275.0 (magenta-ciano) |
| Chroma | 19.1% |
| Gamut compression | 1.00 |
| Clip negative RGB | True |

**Color Equalizer** per affinare la tonalità del cielo.

*Figura 9 — Tone Equalizer: scultura della luce tra cielo e primo piano.*

### Passo 6 — Ritaglio cinematografico e filtro graduato

Applicare un ritaglio in proporzione cinematografica (es. 2.35:1) per enfatizzare la scena. Poi un **filtro graduato** (drawn mask gradient) per:

- Scurire ulteriormente il cielo nella parte superiore
- Schiarire il primo piano nella parte inferiore

### Passo 7 — Ritocco elementi di disturbo e nitidezza

Rimuovere elementi distraenti con lo strumento di clonazione/repair. Poi:

- Nitidezza finale leggera
- Eventuale effetto bagliore (glow) per le luci interne

---

## Riepilogo impostazioni — Concerto

| Modulo | Parametri chiave | Scopo |
|--------|-----------------|-------|
| **Exposure** | +1.000 EV (poi aumentare) | Luminosità base |
| **AGX+** | White 6.5 EV, Black -10 EV, Contrast 2.80 | Tone mapping, no magenta |
| **AGX (avanzati)** | Shoulder start 17.54%, Toe 2.37 | Contrasto controllato |
| **Color Calibration** (Primaries) | Attenuazione R 10%, G 10%, B 15% | Vivacità cromatica |
| **Color Equalizer** | Shadows -8%, Mids -6%, Highlights +12% | Contrasto e dettagli volti |
| **Color Balance RGB** | Brilliance per zone | Controllo spill |

## Riepilogo impostazioni — Notturno

| Modulo | Parametri chiave | Scopo |
|--------|-----------------|-------|
| **Exposure** | +2.802 EV | Recuperare ombre |
| **Filmic RGB** | White 4.88 EV, Black -13.34 EV | Compressione tonale |
| **Exposure** (sky) | Maschera disegnata + Jz | Regolazione cielo |
| **Exposure** (ground) | Maschera inversa | Regolazione primo piano |
| **Lens Correction** | Auto | Rimuovere vignettatura |
| **Color Calibration** (sky) | Hue 275, Chroma 19.1% | Colore cielo |
| **Contrast Equalizer** | Mix variabile | Contrasto locale finale |

## Principi chiave per il lowlight

1. **AGX+ per colori dominanti forti** — evita i blocchi di colore innaturali  
2. **Shoulder/Toe al posto del contrasto** — controllo separato di luci e ombre  
3. **Maschere inverse** — cielo e primo piano gestiti separatamente  
4. **Snapshot ad ogni passo** — fondamentale per non perdere dettagli sui volti  
5. **Primaries prima del tone mapping** — attenuare i colori saturi PRIMA della compressione tonale  

---

## Modulo `lowlight vision`: simulazione della visione notturna umana

Il modulo **lowlight vision** non è un denoisser, ma uno strumento di *simulazione percettiva*: calcola una versione scotopica (a bassa luminosità) dell’immagine basata sulla risposta dei bastoncelli retinici, quindi la mescola con la versione fotopica (a colori) per emulare la transizione giorno-notte o la visione in condizioni estreme di scarsa illuminazione[^lowlight-vision-scotopic].

Questo modulo è particolarmente utile per:
- Creare effetti artistici “notturni” su immagini diurne (day-to-night conversion)
- Simulare il *Purkinje effect*, dove i toni blu/viola appaiono più luminosi nelle ombre
- Preparare bozze per composizioni astronomiche o visualizzazioni scientifiche

### Parametri principali

| Parametro | Range | Default | Descrizione |
|-----------|-------|---------|-------------|
| `curve` | 0–100% (asse orizzontale: luminosità; verticale: visione notturna → diurna) | Curva lineare | Definisce quanto la visione scotopica contribuisce a ogni livello di luminosità. Una curva inclinata verso l’alto nelle ombre accentua il Purkinje effect. |
| `blue` | −100% a +100% | 0% | Aggiunge una tinta blu alle ombre per simulare la maggiore sensibilità dei bastoncelli al blu. Valori tipici: +15%–+40% per effetti naturali[^lowlight-blue-purkinje]. |

!!! warning "Non usare per il denoising"
    Questo modulo **non riduce il rumore**: agisce esclusivamente sulle curve di luminosità e crominanza. Se applicato su un’immagine rumorosa, può amplificare la percezione del rumore cromatico nelle ombre[^lowlight-vision-no-denoise].

### Flusso di lavoro consigliato

1. Applicare `lowlight vision` **dopo** i moduli di denoising (`denoise (profiled)` o `astrophoto denoise`) e prima di `color calibration`.
2. Usare una maschera disegnata se si desidera applicare l’effetto solo a parti specifiche (es. cielo stellato, non al primo piano).
3. Abilitare `look only` per confrontare in tempo reale l’effetto prima di renderlo permanente.
4. Combinare con `exposure` e `filmic rgb` per bilanciare la luminosità globale dopo la trasformazione scotopica.

---

## Modulo `raw denoise`: denoising pre-demosaic

Il modulo **raw denoise** opera direttamente sui dati RAW *prima* del demosaic, sfruttando l’architettura a canale singolo (monocromatico) del sensore. È ideale per eliminare il rumore granulare fine e il rumore a bassa frequenza prima che venga amplificato dalla ricostruzione del colore[^raw-denoise-pre-demosaic].

### Parametri principali

| Parametro | Range | Default | Note |
|-----------|-------|---------|------|
| `noise threshold` | 0.00 – 1.00 | 0.150 | Valore più alto = rimozione più aggressiva, ma rischio di perdita di dettagli fini. Per ISO ≥2000, valori tipici: 0.25–0.45. |
| `coarse/fine curves` | 0–100% per ogni punto della curva (3 punti: coarse/mid/fine) | Curva piatta | La curva sinistra agisce sul rumore grossolano (es. pattern di calore), quella destra sul rumore fine (grana). Per lowlight: alzare il punto centrale (mid) a ~60%, abbassare il punto destro (fine) a ~20% per preservare texture[^raw-denoise-curves]. |

### Quando usarlo

- Su immagini RAW con ISO ≥1600 e tempi di esposizione lunghi (>1/30s)
- Quando si nota rumore strutturale (striping, banding) nei canali R/G/B isolati
- Come primo step di denoising, prima di `denoise (profiled)` o `astrophoto denoise`

### Workflow integrato (concerto ISO 2000)

1. Attivare `raw denoise` subito dopo `demosaic` (in posizione 3–4 nella pipeline).
2. Impostare `noise threshold = 0.320`.
3. Regolare la curva:  
   - Coarse point: 75%  
   - Mid point: 62%  
   - Fine point: 18%  
4. Applicare una maschera parametrica su `Jz` per limitare l’effetto alle ombre (dove il rumore è più evidente).

!!! tip "Controllo visivo dei canali"
    Per valutare l’efficacia, usare temporaneamente `color calibration` in modalità `gray` e visualizzare i canali R, G, B separatamente. Il rumore spesso colpisce in modo asimmetrico: su sensori Fujifilm X-Trans, il canale verde è tipicamente il più rumoroso[^raw-denoise-channel-asymmetry].

---

## Modulo `denoise (profiled)`: denoising intelligente basato su profilo

Questo è il modulo principale per la riduzione del rumore in condizioni lowlight. Utilizza profili statistici pre-calibrati per oltre 300 modelli di fotocamere, correlando rumore, ISO, luminosità e canale RGB[^denoise-profiled-stats].

### Algoritmi disponibili

| Algoritmo | Tipo | Carico CPU | Uso consigliato |
|-----------|------|------------|-----------------|
| `wavelets` (default) | Dominio wavelet (Y0U0V0) | Basso | Ottimo per ISO 800–3200, equilibrio qualità/velocità. Usa `Y0` per rumore luminoso, `U0V0` per rumore cromatico. |
| `non-local means` | Spaziale (patch matching) | Alto | Ideale per ISO ≥6400 o immagini astrofotografiche. Richiede `patch size = 2–4`, `search radius = 5–12`[^denoise-nlm-patch-size]. |

### Parametri chiave per lowlight

| Parametro | Valore tipico (ISO 2000) | Note |
|-----------|--------------------------|------|
| `mode` | `wavelets` → `Y0U0V0 color mode` | Preferito per performance e precisione. |
| `strength` | 0.85–1.25 | Valore >1.00 aumenta la rimozione di rumore fine, ma può smussare i bordi. |
| `preserve shadows` | 0.90–1.05 | Valore <1.00 denoisa più aggressivamente le ombre (dove il rumore è più intenso). |
| `bias correction` | −0.15 a +0.15 | Corregge cast verdi/purpurei nelle ombre. Per Fujifilm X-T2: +0.07. |
| `opacity` | 75–90% | Usare opacità <100% per preservare grana naturale e microdettagli[^denoise-opacity].

### Esempio: workflow concerti (Fujifilm X-T2, ISO 2000)

*Da [ENG] Darktable First steps EP06](https://www.youtube.com/watch?v=iPjlgyrKqBY) (timestamp 03:00–07:00)*  
1. Attivare `denoise (profiled)` in posizione 5–6 della pipeline, dopo `exposure` e prima di `color calibration`.  
2. Selezionare `mode = wavelets` → `Y0U0V0 color mode`.  
3. Regolare le curve:  
   - `Y0` (luminanza): punto sinistro (coarse) a 85%, centro (mid) a 70%, destro (fine) a 35%.  
   - `U0V0` (crominanza): punto sinistro a 95%, centro a 88%, destro a 75% (più aggressivo sul rumore cromatico).  
4. Impostare `strength = 1.05`, `preserve shadows = 0.93`, `opacity = 82%`.  
5. Abilitare `whitebalance-adaptive transform` per compensare l’amplificazione differenziale dei canali da parte del white balance[^denoise-wb-adapt].

### Esempio: workflow paesaggi notturni (Sony A7R III, ISO 800)

*Da [ENG] darktable: organising the darkroom](https://www.youtube.com/watch?v=CtVJKLyMMYA) (timestamp 02:30–04:15)*  
1. Usare `mode = non-local means`, `patch size = 2`, `search radius = 9`.  
2. Impostare `scattering = 0.25` per ridurre il rumore cromatico senza appiattire i dettagli del cielo.  
3. `central pixel weight = 0.15`: privilegia la rimozione di rumore cromatico rispetto a quello luminoso.  
4. `strength = 0.95`, `preserve shadows = 1.00`, `opacity = 87%`.

---

## Modulo `astrophoto denoise`: denoising per alta sensibilità e lunga esposizione

Progettato per astrofotografia, questo modulo è efficace anche su immagini lowlight con ISO ≥3200 o esposizioni >5s. Opera tramite media pesata di pixel simili in un intorno definito da una *patch*, con peso determinato dalla similarità locale[^astrophoto-denoise-patch-similarity].

### Parametri chiave

| Parametro | Range | Valore tipico (ISO 6400, esposizione 8s) | Note |
|-----------|-------|------------------------------------------|------|
| `patch size` | 1–8 | 3 | Dimensione del quadrato di confronto (in pixel). Valori alti migliorano la coerenza strutturale ma aumentano i tempi di calcolo. |
| `strength` | 0.00–1.00 | 0.72 | Valore >0.65 è efficace per rumore coarse-grain; oltre 0.85 rischia di omogeneizzare le stelle. |
| `luma` | 0.00–1.00 | 0.55 | Conserva dettagli strutturali (es. contorni di edifici, venature di foglie). |
| `chroma` | 0.00–1.00 | 0.92 | Può essere molto aggressivo: il rumore cromatico è meno strutturale e più facile da rimuovere[^astrophoto-chroma-aggressive]. |

### Quando usarlo

- Su immagini con ISO ≥6400 e/o esposizioni ≥4s  
- Quando `denoise (profiled)` lascia residui di rumore cromatico persistente  
- Su immagini con cielo stellato: permette di preservare le stelle come punti luminosi senza “smussarle”

!!! warning "Ordine critico nella pipeline"
    `astrophoto denoise` deve essere inserito **dopo** `exposure`, `filmic rgb` e `color calibration`, ma **prima** di `sharpen`, `local contrast` e `bloom`. Se posizionato troppo presto, interferisce con la compressione tonale; troppo tardi, amplifica artefatti[^astrophoto-pipeline-order].

---

## Domande frequenti

### Problema: Rumore cromatico residuo dopo `denoise (profiled)`
Il rumore cromatico persiste soprattutto nelle ombre, nonostante `U0V0` sia impostato a 90%.  
La soluzione è applicare un secondo modulo `denoise (profiled)` in modalità `RGB color mode`, con maschera parametrica su `Jz < 15%`, e regolare solo la curva `R` (perché il canale rosso è spesso il più rumoroso nei sensori Sony e Canon a ISO elevati)[^denoise-rgb-residual].

### Problema: Immagine “plastificata” dopo `astrophoto denoise`
L’uso di `strength = 0.85` e `patch size = 4` ha omogeneizzato eccessivamente le texture (es. pelle, tessuti).  
Ridurre `strength` a 0.62 e `patch size` a 2; aumentare `opacity` a 92% e applicare una maschera disegnata per escludere volti e superfici organiche[^astrophoto-over-smooth].

### Problema: `raw denoise` non riconosce il mio obiettivo
Il modulo `raw denoise` non dipende da profili di obiettivo: funziona su tutti i RAW. Se non appare, verificare che il file sia davvero in formato RAW (non JPEG o TIFF) e che il modulo non sia disabilitato nelle preferenze sotto *Processing > Disable modules*[^raw-denoise-raw-only].

---

## Risorse

- [darktable user manual — full module reference](https://docs.darktable.org/usermanual/development/en/module-reference/)  
- [darktable noise profiling guide](https://pixls.us/articles/how-to-create-camera-noise-profiles-for-darktable/)  
- [Official darktable camera support list](https://github.com/darktable-org/darktable/wiki/Camera-support)  
- [Darktable community forum — lowlight workflows](https://discuss.pixls.us/c/darktable)  
- [AGX+ color science documentation](https://github.com/darktable-org/agx)  

## Fonti

[^agx-plus-optimization]: *AGX+ is optimized for high chroma scenes and avoids hue shifts in saturated regions*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/agx/)
[^agx-shoulder-toe]: *Shoulder and toe parameters allow independent control of highlight and shadow contrast without affecting midtones*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/agx/)
[^primaries-attenuation]: *Attenuation reduces channel saturation before tone mapping to prevent clipping and preserve hue fidelity*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-calibration/)
[^color-equalizer-lowlight]: *Color Equalizer allows targeted brightness adjustments per tonal zone while preserving global color balance*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-equalizer/)
[^raw-data-check]: *Always verify raw channel headroom before exposure boosting to avoid irreversible clipping*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/exposure/)
[^filmic-look-only]: *The “look only” toggle previews Filmic RGB without committing changes to the pipeline*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/filmic-rgb/)
[^lens-correction-remasking]: *Lens correction modifies geometry; masks are automatically remapped to match corrected coordinates*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/lens-correction/)
[^lowlight-vision-scotopic]: *lowlight vision computes scotopic luminance using CIE 1951 photopic/scotopic luminosity functions*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/lowlight-vision/)
[^lowlight-blue-purkinje]: *Blue parameter applies a CIE 1951 scotopic spectral weighting to shadows, simulating Purkinje shift*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/lowlight-vision/)
[^lowlight-vision-no-denoise]: *This module does not perform noise reduction; it is purely perceptual simulation*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/lowlight-vision/)
[^raw-denoise-pre-demosaic]: *raw denoise operates on linear Bayer data prior to demosaic, avoiding interpolation artifacts*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/raw-denoise/)
[^raw-denoise-curves]: *Fine-grain noise is best addressed by lowering the rightmost curve point to preserve texture*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/raw-denoise/)
[^raw-denoise-channel-asymmetry]: *Channel-specific noise requires isolated analysis: green dominates in X-Trans, red in older CMOS*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/raw-denoise/)
[^denoise-profiled-stats]: *Noise profiles correlate variance across ISO, luminance, and channel using statistical modeling of sensor response*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/denoise-profiled/)
[^denoise-nlm-patch-size]: *Patch size of 2–4 balances detail preservation and noise removal for high-ISO images*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/denoise-profiled/)
[^denoise-opacity]: *Opacity <100% retains natural grain and prevents over-smoothing of fine textures*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/denoise-profiled/)
[^denoise-wb-adapt]: *Whitebalance-adaptive transform compensates for differential channel amplification during WB adjustment*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/denoise-profiled/)
[^astrophoto-denoise-patch-similarity]: *Pixel similarity is computed via SSD (sum of squared differences) over the patch neighborhood*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/astrophoto-denoise/)
[^astrophoto-chroma-aggressive]: *Chroma denoising can be set higher than luma because color noise lacks structural meaning*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/astrophoto-denoise/)
[^astrophoto-pipeline-order]: *astrophoto denoise must follow tone mapping to avoid distorting compressed tonal relationships*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/astrophoto-denoise/)
[^denoise-rgb-residual]: *RGB mode allows per-channel denoising when U0V0 leaves residual chroma noise*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/denoise-profiled/)
[^astrophoto-over-smooth]: *Reducing patch size and strength restores texture fidelity while retaining noise suppression*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/astrophoto-denoise/)
[^raw-denoise-raw-only]: *raw denoise is only available for true RAW files; JPEG/TIFF bypass this stage entirely*, [darktable-usermanual-en](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/raw-denoise/)
