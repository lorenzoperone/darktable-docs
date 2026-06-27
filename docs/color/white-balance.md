# Bilanciamento del Bianco

In darktable, il bilanciamento del bianco segue un **approccio a due stadi** che è più preciso del metodo tradizionale[^manual-wb][^manual-colorcal].

## Due stadi

### Stadio 1: White Balance (tecnico)

Il modulo **White Balance** va lasciato su **Camera Reference**. Il suo unico compito è rendere i dati neutri per la demosaicizzazione — corregge la dominante verde del sensore Bayer[^pipeline].

!!! warning "Non usare per la correzione creativa"
    Il white balance tradizionale con temperatura/tinta è un metodo legacy. Per la correzione creativa, usa la Color Calibration[^manual-colorcal].

### Stadio 2: Color Calibration (percettivo)

Il modulo **Color Calibration** (tab CAT) esegue l'adattamento cromatico percettivo reale usando il modello **CAT16**. Offre:[^manual-colorcal]

- Rilevamento automatico dell'illuminante (AI)
- Adattamento cromatico fisicamente accurato
- Prevenzione dei color shift nelle alte luci
- Supporto per illuminazione mista con istanze multiple

> *Color calibration provides a more accurate white balance than the legacy white balance module using the CAT16 chromatic adaptation transform from the CIE.*[^manual-colorcal]

### Perché due stadi?

| Aspetto | WB tradizionale | WB + Color Cal |
|---------|----------------|----------------|
| **Precisione** | Bassa (lineare) | Alta (percettiva, CAT16) |
| **Alte luci** | Color shift | Preservate |
| **Illuminazione mista** | Non gestibile | Istanze + maschere |
| **Automatismo** | Solo EXIF | AI detection + EXIF |

## Flusso di lavoro completo

Il flusso ottimale per un bilanciamento del bianco accurato in darktable 5.4+ richiede una sequenza rigorosa e una corretta configurazione delle preferenze:

1. **Impostare il workflow moderno**:  
   `Preferences > Processing > Auto-apply chromatic adaptation defaults` → selezionare **"modern"**. Questo abilita l’uso automatico di `CAT16` e forza `White Balance` su `Camera Reference`[^manual-colorcal-48].  

2. **Verificare il profilo colore d’ingresso**:  
   Il modulo **Input Color Profile** deve usare la matrice standard (`Linear Rec.2020`, `sRGB`, o `Adobe RGB`) — le matrici personalizzate sono sconsigliate poiché interferiscono con la precisione di CAT16[^manual-colorcal-48]. Se si utilizza un profilo calibrato con color checker, assicurarsi che sia stato estratto tramite `Color Calibration > Extract settings using a color checker`[^batch-editing].

3. **Applicare la correzione globale**:  
   - Attivare **White Balance** → impostare su `Camera Reference`.  
   - Attivare **Color Calibration**, tab **CAT**, e selezionare un metodo di rilevamento illuminante (vedi [Parametri](#parametri)).  
   - Evitare di modificare manualmente i coefficienti RGB nel modulo `White Balance`: qualsiasi deviazione compromette la coerenza della catena CAT16[^manual-colorcal-48].

4. **Gestire illuminazioni miste**:  
   Creare **istanze multiple** di `Color Calibration`:  
   - Prima istanza: maschera parametrica (es. `JzCzhz → hue: 120–180°`, `chroma: 30–70%`) per isolare lo sfondo verde; impostare `illuminant = custom`, `hue = 142°`, `chroma = 48%`.  
   - Seconda istanza: maschera invertita (raster mask), per il soggetto principale; impostare `illuminant = (AI) detect from surfaces`.  
   Questo approccio è dimostrato in [Some Color calibration ideas](https://www.youtube.com/watch?v=MJJR8DJ3rr8) per una foto di coccinella su finocchio[^dabble-mjjr].

5. **Verifica finale con strumenti diagnostici**:  
   - Usare il **vettorscopio** (abilitato da `Color Picker > display samples on image/vectorscope`) per controllare la distribuzione cromatica: un bilanciamento corretto mostra i punti concentrati attorno al centro (grigio neutro)[^dabble-channel-mixer].  
   - Abilitare `Spot Color Mapping` per misurare valori LCh di aree critiche (es. pelle, cielo, superfici neutre): `lightness` tra 40–60%, `chroma` < 50% per neutralità[^dabble-spot-color].

!!! tip "Workflow batch editing"
    Per serie fotografiche omogenee (stesso illuminante, stessa fotocamera), applicare prima la calibrazione primaria con un color checker, quindi copiare lo stack di sviluppo (`History Stack > Copy history`) e incollarlo in modalità **Append** per preservare la base neutra[^batch-editing]. Questo garantisce ripetibilità nella fase secondaria (color grading creativo).

## Parametri

### Tab CAT — Illuminant

| Parametro | Descrizione | Range / Valori | Default | Note |
|-----------|-------------|----------------|---------|------|
| `illuminant` | Tipo di illuminante ipotizzato per la scena | `same as pipeline (D50)`, `CIE standard illuminant`, `custom`, `(AI) detect from image surfaces`, `(AI) detect from image edges`, `as shot in camera` | `as shot in camera` | Per scene naturali con elementi neutri, preferire `(AI) detect from surfaces`; per scene artificiali o con rumore ISO alto, usare `(AI) detect from edges`[^manual-colorcal-48]. |
| `temperature` | Regolazione fine lungo il locus Planckiano | `-100` a `+100` (unità relative) | `0` | Disponibile solo se l’illuminante rilevato è vicino al locus Planckiano (CCT taggato come `(daylight)` o `(black body)`). Un valore positivo sposta l’illuminante verso il blu, rendendo l’immagine più calda dopo compensazione[^manual-colorcal-48]. |
| `hue` | Tonalità dell’illuminante in spazio LCh (CIE Luv) | `0°` a `360°` | `0°` | Disponibile solo in modalità `custom`. Valori tipici: `100°–120°` per illuminazione fluorescente, `200°–240°` per LED freddi, `300°–330°` per LED caldi[^manual-colorcal-48]. |
| `chroma` | Purezza cromatica dell’illuminante | `0%` a `100%` | `35%` | Valori oltre il 50% indicano illuminanti altamente saturi (es. luci sceniche); valori sotto il 20% suggeriscono illuminazione diffusa o nebbia[^manual-colorcal-48]. |

### Tab CAT — Adaptation

| Parametro | Descrizione | Opzioni | Default | Note |
|-----------|-------------|---------|---------|------|
| `adaptation` | Algoritmo di trasformazione cromatica | `Linear Bradford (1985)`, `CAT16 (2016)`, `Non-linear Bradford (1985)`, `XYZ`, `none (disable)` | `CAT16 (2016)` | CAT16 è il default e il più robusto: evita colori immaginari anche con illuminanti estremi (es. CCT < 3000K o > 10000K)[^manual-colorcal-48]. `Linear Bradford` è obsoleto e produce out-of-gamut con illuminanti non daylight[^manual-colorcal-48]. |

### Tab Spot Color Mapping

Introdotta in darktable 4.0, questa funzionalità permette di misurare e correggere puntualmente aree specifiche[^dabble-spot-color].

| Parametro | Descrizione | Range / Valori | Default | Note |
|-----------|-------------|----------------|---------|------|
| `spot mode` | Modalità operativa | `measure`, `correction` | `measure` | In `measure`, il color picker registra LCh dell’area selezionata. In `correction`, applica una trasformazione per allineare quel punto a un target[^dabble-spot-color]. |
| `lightness`, `hue_target`, `chroma_target` | Valori LCh del target di riferimento | `lightness`: `0%–100%`, `hue_target`: `0°–360°`, `chroma_target`: `0–100` | `N/A` | Per una correzione precisa, misurare un’area neutra (es. carta grigia 18%) e impostare `lightness_target = 50%`, `chroma_target < 5%`[^dabble-spot-color]. |
| `take channel mixing into account` | Abilita l’integrazione con il canale mixer | `on/off` | `on` | Se attivo, la correzione tiene conto delle trasformazioni precedenti nei moduli `Channel Mixer` o `Color Balance RGB`[^dabble-spot-color]. |

### Tab Channel Mixer

Utilizzato per correzioni cromatiche globali avanzate (es. viraggio del cielo da blu a ciano)[^dabble-channel-mixer].

| Parametro | Descrizione | Range / Valori | Default | Note |
|-----------|-------------|----------------|---------|------|
| `input R/G/B` | Peso dei canali di ingresso nella combinazione | `-100` a `+200` | `100.000`, `100.000`, `100.000` | Per virare un cielo blu (`R=86,G=100,B=159`) verso il ciano, aumentare `input G` a `120` e ridurre `input B` a `85` — questo aggiunge verde senza alterare eccessivamente i verdi della vegetazione[^dabble-channel-mixer]. |
| `CAT R/G/B` | Coefficienti di adattamento cromatico post-CAT | `-100` a `+200` | `0.000`, `0.000`, `0.000` | Utilizzato raramente; serve per correzioni molto aggressive (es. simulazione pellicola)[^dabble-channel-mixer]. |

## Consigli operativi

### ✅ Best practice per la precisione

- **Usare sempre `Camera Reference` in White Balance**: Qualsiasi altro valore (es. `As shot`, `Auto`) introduce errori sistematici nella catena CAT16[^manual-colorcal-48].  
- **Evitare la temperatura manuale**: Il valore CCT visualizzato è spesso `invalid` per illuminanti non Planckiani (es. LED, fluorescenza). Preferire `custom` + `hue/chroma` o metodi AI[^manual-colorcal-48].  
- **Controllare il gamut prima di esportare**: Abilitare `Gamut check` in `Output Color Profile` per evidenziare aree fuori gamut (rosse). Ridurre `chroma` nel `Color Calibration` o usare `gamut compression = 1.20` per compressione morbida[^dabble-lowlight].  

### ⚠️ Errori comuni da evitare

- **Mascherare direttamente `Color Calibration` per correzioni locali**: Questo causa squilibri cromatici innaturali (es. bordi cromatici). Usare invece maschere parametriche basate su `JzCzhz` o `Lab` per isolare aree per tonalità e cromia[^dabble-channel-mixer].  
- **Applicare `Color Calibration` prima di `Filmic RGB`**: La sequenza corretta è `White Balance` → `Input Color Profile` → `Color Calibration` → `Filmic RGB`. Invertire l’ordine genera clipping prematuro e perdita di dettagli nelle alte luci[^dabble-filmic].  
- **Usare `Temperature/Tint` in `White Balance` per correzioni creative**: Questo compromette la linearità della pipeline. Tutte le correzioni artistiche vanno fatte in `Color Balance RGB` o `Channel Mixer`[^manual-colorcal-48].  

### 🎯 Esempi pratici

#### Caso 1: Paesaggio al tramonto con dominante arancione eccessiva  
- Problema: Versioni recenti di `Filmic RGB` (v6+) desaturano troppo i rossi/orange, rendendoli "rossi" invece che "arancioni" (effetto Bezold-Brücke)[^dabble-bezold].  
- Soluzione:  
  1. In `Color Calibration`, tab CAT: selezionare `illuminant = custom`, `hue = 30°`, `chroma = 65%` (per illuminante solare basso).  
  2. Nella tab `Channel Mixer`: impostare `input R = 110`, `input G = 95`, `input B = 90` per rinforzare il giallo-arancio.  
  3. In `Filmic RGB`, versione `v5 (2021)` per preservare la saturazione nei highlight[^dabble-bezold].  

#### Caso 2: Foto in studio con illuminazione LED fredda  
- Problema: CCT rilevato `5200 K (invalid)` → l’illuminante non è Planckiano.  
- Soluzione:  
  1. Usare `(AI) detect from surfaces` → genera `hue = 225°`, `chroma = 42%`.  
  2. Impostare `gamut compression = 1.10` per prevenire clipping nei blu.  
  3. Verificare con vettorscopio: i punti devono essere concentrati attorno a `L* ≈ 50`, `a* ≈ 0`, `b* ≈ 0`[^dabble-channel-mixer].  

#### Caso 3: Batch editing con color checker X-Rite 24  
- Workflow:  
  1. Scattare una foto del color checker sotto le stesse condizioni di illuminazione.  
  2. In `Color Calibration`: cliccare `Extract settings using a color checker`.  
  3. Copiare lo stack (`History Stack > Copy history`) e incollare in modalità **Append** su tutte le immagini della serie[^batch-editing].  
  4. Applicare `Spot Color Mapping` su un’area neutra (es. patch grigio 18%) per allineare `lightness = 50.0%`, `chroma = 3.2%`[^dabble-spot-color].

## Risorse

- [darktable User Manual — Color Calibration (v5.4)](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-calibration/)  
- [Video tutorial: “Some Color calibration ideas” — A Dabble in Photography](https://www.youtube.com/watch?v=MJJR8DJ3rr8)  
- [Video tutorial: “How to get accurate colours in darktable” — A Dabble in Photography](https://www.youtube.com/watch?v=TMlF85TFIUo)  
- [darktable User Manual — Batch Editing](https://docs.darktable.org/usermanual/development/en/guides-tutorials/batch-editing/)  

## Fonti

[^manual-wb]: *darktable User Manual -- White Balance*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/white-balance/) | `processed/darktable-usermanual-en/usermanual-48-en-module-reference-processing-modules-white-balance.md`
[^manual-colorcal]: *darktable User Manual -- Color Calibration*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-calibration/) | `processed/darktable-usermanual-en/usermanual-48-en-module-reference-processing-modules-color-calibration.md`
[^pipeline]: *[The darktable pipeline for beginners](https://www.youtube.com/watch?v=1nPW6WPhhTo)* — A Dabble in Photography
[^manual-colorcal-48]: *darktable user manual — Color Calibration*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-calibration/#) | `processed/darktable-usermanual-en/usermanual-48-en-module-reference-processing-modules-color-calibration.md`
[^batch-editing]: *darktable user manual — Batch-editing images*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/guides-tutorials/batch-editing/#) | `processed/darktable-usermanual-en/usermanual-48-en-guides-tutorials-batch-editing.md`
[^dabble-spot-color]: *A Dabble in Photography — What is new in darktable 4.0?*, [YouTube](https://www.youtube.com/watch?v=_EOGBmksHDw) | `screenshots/frame_00067_519.jpg`, `frame_00112_920.jpg`
[^dabble-channel-mixer]: *A Dabble in Photography — Channel Mixer Part 2*, [YouTube](https://www.youtube.com/watch?v=QX_HItCqDtE) | `screenshots/frame_00480_000.jpg`, `frame_00944_539.jpg`
[^dabble-bezold]: *A Dabble in Photography — How to get accurate colours in darktable*, [YouTube](https://www.youtube.com/watch?v=TMlF85TFIUo) | `screenshots/frame_00360_000.jpg`
[^dabble-lowlight]: *A Dabble in Photography — Lowlight photos in darktable*, [YouTube](https://www.youtube.com/watch?v=O7wXgmQZqiU) | `screenshots/frame_00150_000.jpg`
[^dabble-mjjr]: *A Dabble in Photography — Some Color calibration ideas*, [YouTube](https://www.youtube.com/watch?v=MJJR8DJ3rr8) | `screenshots/frame_00420_000.jpg`, `frame_00510_000.jpg`
[^dabble-filmic]: *A Dabble in Photography — Filmic & Sigmoid Part 4*, [YouTube](https://www.youtube.com/watch?v=4KV9Ic-mPj0) | `screenshots/frame_00137_259.jpg`, `frame_00192_819.jpg`
