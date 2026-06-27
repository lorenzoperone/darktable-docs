# Tone Mapping

Il passaggio dai dati lineari infiniti alla gamma dinamica limitata del monitor e' gestito dai moduli di tone mapping. darktable offre tre percorsi principali. **Usa solo uno dei tre alla volta**: non sovrapporre Filmic, Sigmoid e AgX.

## AgX: la scelta consigliata per darktable 5.4+

AgX e' il tone mapper piu' recente ed e' progettato per gestire il viraggio dei colori saturi verso tonalita' sgradevoli quando si avvicinano al clipping -- il fenomeno dei **«Notorious 6»**.[^manual-agx]  
L’algoritmo è basato su modelli fisici della risposta cromatica della pellicola analogica e include una gestione esplicita della *chromaticity compression* per evitare la perdita di purezza cromatica nelle alte luci[^dt54]. Il modulo è attivo di default nelle nuove installazioni di darktable 5.4+ quando è selezionato il profilo *scene-referred (agx)* nelle preferenze globali[^dt54].

### Procedura operativa

1. Assicurati che AgX sia attivo (default con *scene-referred (agx)* nelle preferenze)
2. I parametri predefiniti funzionano gia' bene nella maggior parte dei casi
3. Se l'immagine sembra piatta, aumenta leggermente il **contrasto**
4. Usa **Preserve Hue** per la fedelta' cromatica nelle alte luci
5. Il **pivot** controlla il punto di contrasto massimo

!!! tip "Usare la pipetta sul pivot"
    Usare la pipetta (eyedropper) su **'pivot exposure'** per definire la zona di massimo contrasto. La pipetta su **'output target'** modifica entrambi i parametri simultaneamente.[^agx-guide]

### Parametri avanzati

| Parametro | Funzione | Valore tipico | Consiglio |
|-----------|----------|----------------|-----------|
| **Contrast** | Contrasto globale | `2.00–3.20` (default `2.80`) | Partire dal valore di default; valori >3.50 introducono artefatti in ombre/alti toni[^agx-guide] |
| **Pivot exposure** | Punto di contrasto massimo | `-2.00 EV` a `+2.00 EV` (default `0.00 EV`) | Usare la pipetta sul soggetto; valori positivi spostano il massimo contrasto verso le luci[^agx-guide] |
| **Shoulder power** | Compressione alte luci | `1.20–2.00` (default `1.55`) | Aumentare per controllare picchi di luminanza senza desaturazione (es. cielo estivo)[^agx-guide] |
| **Toe power** | Compressione ombre | `1.20–2.00` (default `1.55`) | Ridurre per preservare dettagli nelle ombre profonde (es. interni notturni)[^agx-guide] |
| **Preserve Hue** | Fedelta' cromatica | `0–100%` (default `100%`) | Disabilitare per i tramonti[^agx-guide]; mantenere >80% per ritratti pelle[^lowlight] |
| **Primaries** | Gestione gamut | Attivabile solo se `Preserve Hue < 100%` | Solo per mitigare problemi di clipping cromatico[^dt54] |

!!! warning "Cursori da evitare"
    - **Dynamic range scaling**: aumenta il rischio di clipping senza beneficio reale[^agx-guide]  
    - **White/black target**: creano un effetto sbiadito (simulazione pellicola) — generalmente non modificare[^agx-guide]  
    - **Parametri avanzati della curva**: non modificare se shoulder/toe power gia' sufficienti[^agx-guide]  

!!! info "La porzione arancione della curva"
    NON e' un errore — indica la perdita della curva a S. Se shoulder/toe power smettono di rispondere, modificare il parametro **'curve gamma'** per ripristinare il controllo.[^agx-guide]

### Preparazione con AgX

!!! important "Impostare i punti nero e bianco"
    Sempre all'inizio del workflow AgX, impostare i punti nero e bianco usando la selezione area o i metadati della fotocamera.[^dt54]  
    Il valore tipico di **black relative exposure** è compreso tra `-9.00 EV` e `-11.00 EV`, mentre **white relative exposure** varia da `+4.00 EV` a `+7.50 EV`, a seconda della scena.[^dt54]

!!! tip "Colori molto saturi"
    Attenuare i colori molto saturi (blu intensi) nel tab **Primaries** PRIMA della compressione tonale per prevenire il clipping cromatico e i blocchi di colore su schermi SDR.[^dt54]  
    Per immagini con forti dominanti blu (es. cieli estivi o luci LED), applicare un’attenuazione blu fino a `71.48%` e una rotazione negativa di `-3.0°` per spostare i toni verso il ciano-verde.[^dt54]

> La documentazione ufficiale del modulo AgX descrive in dettaglio la gestione della saturazione che segue il comportamento della pellicola analogica, risolvendo il problema dei Notorious 6.[^manual-agx]

### Casi d'uso specifici

=== "Tramonti"
    Disabilitare **'preserve hue'** per migliorare la resa (effetto Bezold-Brucke). La saturazione nella sezione Look agisce solo sui toni medi.[^agx-guide]  
    Inoltre, ridurre **'preserve hue'** a `0–30%` permette una maggiore espressione cromatica nei rossi/arancioni, evitando il viraggio verso il rosa/magenta tipico di altri tone mapper.[^landscape]

=== "Lowlight"
    Usare **'shoulder power'** e **'toe power'** invece del cursore contrasto generico per un controllo preciso luci/ombre. Non aumentare eccessivamente il contrasto per preservare i dettagli facciali.[^lowlight]  
    Per scene con illuminazione artificiale (es. interni notturni), impostare `toe power = 1.20` e `contrast = 2.20` per evitare il “grigiore” tipico delle ombre digitali.[^lowlight]

=== "Paesaggi"
    Ridurre il parametro **'preserve hue'** in Sigmoid/AgX quando si editano tramonti per prevenire la generazione di falsi colori.[^landscape]  
    Combinare con un’attenuazione blu del `16.75%` e rotazione di `-3.0°` per portare i toni fuori dal gamut non riproducibile.[^dt54]

## Sigmoid: l'alternativa rapida

Sigmoid offre una transizione fluida delle alte luci verso il bianco, con pochissimi parametri. Ideale per chi vuole un risultato «pronto all'uso».[^manual-sigmoid]  
A differenza di AgX, Sigmoid opera in modo *display-referred*, quindi non richiede un setup preliminare dei punti nero/bianco. È particolarmente efficace su immagini già ben esposte, dove il recupero di dettagli è minimo ma la coerenza cromatica è prioritaria.[^manual-sigmoid]

**Quando preferire Sigmoid ad AgX:**

- Ritratti con toni pelle delicati  
- Foto in condizioni di luce uniforme  
- Editing batch dove vuoi consistenza con il minimo sforzo  

> Sigmoid tende a produrre toni pelle piu' naturali «out of the box» rispetto ad AgX e Filmic.[^manual-sigmoid]

### Parametri chiave di Sigmoid

| Parametro | Range | Default | Note |
|-----------|--------|---------|------|
| **Contrast** | `0.50–3.00` | `1.50` | Valori >2.00 possono introdurre artefatti nei mezzi toni pelle[^sigmoid-tutorial] |
| **Skew** | `-1.00` a `+1.00` | `0.00` | Sposta il punto di massimo contrasto: valori negativi privilegiano le ombre[^sigmoid-tutorial] |
| **Target black / white** | `0.001%` – `100.00%` | `0.0152%` / `100.00%` | Modifica la profondità del nero e la brillantezza del bianco senza alterare la gamma dinamica[^sigmoid-tutorial] |
| **Preserve Hue** | `0–100%` | `100%` | Mantiene la tinta originale nelle alte luci; disattivarla migliora la resa dei tramonti[^sigmoid-tutorial] |

## Filmic RGB: il controllo totale

Filmic RGB e' stato lo standard del flusso scene-referred per anni. Mappa la gamma dinamica attraverso tre pannelli.[^manual-filmic]  
Il modulo supporta versioni multiple (v5, v6, v7): la **v5 (2021)** è ancora raccomandata per immagini con forti tonalità calde (tramonti, luci incandescenti), poiché preserva meglio i gialli e gli arancioni rispetto alle versioni successive.[^filmic-v5]  
La versione v7 introduce un *highlight saturation mix* più aggressivo, utile per immagini con luci fredde (es. neve al mattino), ma meno adatta ai paesaggi con sole basso.[^filmic-v5]

### Procedura operativa

1. **Pannello Scene**: regola punto nero e bianco relativi usando il selettore automatico (pipetta)
2. **Pannello Look**: curva S per il contrasto artistico; latitudine per l'ampiezza dei toni medi
3. **Pannello Display**: luminanza target del bianco e del nero per l'uscita finale
4. **Preservazione crominanza**: imposta su «No» o «Max RGB» per evitare colori slavati

!!! danger "Curva sotto lo 0%"
    La curva non deve mai scendere sotto lo 0% (l'avviso arancione indica negativita'). Causa artefatti nei toni scuri.[^firststeps]

### Parametri fondamentali di Filmic RGB

| Parametro | Range | Default | Note |
|-----------|--------|---------|------|
| **White relative exposure** | `-2.00` a `+8.00 EV` | `+4.56 EV` | Impostare con la pipetta sulle luci più brillanti ma non bruciate[^filmic-v5] |
| **Black relative exposure** | `-12.00` a `-4.00 EV` | `-7.65 EV` | Impostare con la pipetta sulle ombre più dense ma con dettaglio[^filmic-v5] |
| **Latitude** | `0.10–1.00` | `0.50` | Valori <0.40 aumentano la desaturazione verso i neri; >0.60 mantengono più saturazione in ombre[^filmic-v5] |
| **Contrast** | `0.10–2.00` | `1.00` | Valori >1.30 possono causare artefatti su texture fini (capelli, tessuti)[^filmic-v5] |
| **Auto tune levels** | On/Off | Off | Attivarlo dopo aver impostato i punti nero/bianco per ottimizzare la curva automaticamente[^filmic-v5] |

> Per un confronto approfondito tra i tre tone mapper, la community pixls.us offre analisi dettagliate nei thread *Compare and contrast: Filmic RGB vs AgX* e *Filmic vs Sigmoid vs AgX: some thoughts*.[^pixls-filmic-vs]

## Tone Equalizer: il dodging & burning intelligente

Il modulo **tone equalizer**, introdotto in darktable 4.8, sostituisce i vecchi moduli *shadows and highlights*, *tone curve*, *zone system* e *base curve* quando usato insieme a *filmic rgb* o *agx*.[^manual-tone-eq] Opera in spazio RGB lineare e utilizza una **maschera guidata** (guided mask) per applicare correzioni locali senza compromettere il contrasto locale.[^manual-tone-eq]

### Flusso di lavoro

1. **Creare la maschera**: il modulo genera automaticamente una maschera monocromatica basata sulla luminosità dell’immagine  
2. **Affinare la maschera**: usare la scheda *masking* per regolare diffusione, sfumatura e quantizzazione  
3. **Applicare l’equalizzazione**: regolare i livelli di esposizione per zone specifiche (da –8 EV a 0 EV)  

Il principio è semplice: ogni pixel viene corretto in base al valore di luminosità della maschera in quel punto — non in base al suo valore RGB originale. Questo garantisce che aree con simile luminosità ricevano la stessa correzione, preservando i bordi e il micro-contrast.[^manual-tone-eq]

### Parametri chiave

| Sezione | Parametro | Range | Default | Note |
|----------|-----------|--------|---------|------|
| **Simple** | `-8 EV` … `0 EV` sliders | `-2.00` a `+2.00 EV` | `0.00 EV` | Ogni slider controlla una banda di 1 EV; usare la pipetta per selezionare la zona da correggere[^manual-tone-eq] |
| **Advanced** | Curve smoothing | `0.00–1.00` | `0.30` | Valori >0.60 possono introdurre oscillazioni nella curva[^manual-tone-eq] |
| **Masking** | Smoothing diameter | `0.5–25%` | `5%` | Per *eigf* (default), usare `1–10%`; per *guided filter*, fino a `25%`[^manual-tone-eq] |
| **Masking** | Edges refinement/feathering | `0–10000` | `100` | Valori alti (>500) seguono meglio i bordi; valori bassi (<100) producono transizioni più morbide[^manual-tone-eq] |

!!! tip "Uso avanzato: maschera + cursori"
    Con il modulo attivo, muovi il mouse sull’anteprima e usa la rotellina per regolare istantaneamente l’esposizione della zona sotto il cursore. L’indicatore mostra in tempo reale l’EV della maschera e l’entità della correzione applicata.[^manual-tone-eq]

## Consigli operativi per migranti da Lightroom/Photoshop

- ✅ **Non cercare equivalenze 1:1**: i tone mapper di darktable sono *scene-referred*, quindi non replicano i preset “VSCO” o “Kodak Portra” in modo diretto.  
- ✅ **Usa sempre i metadati RAW**: i valori di *black/white relative exposure* derivano direttamente dalle informazioni del sensore — non dai valori di Lightroom.  
- ✅ **Evita il double-processing**: non applicare *exposure* prima di *filmic* o *agx*: quest’ultimo gestisce già la mappatura globale.  
- ❌ **Non usare “fill light” o “recovery”**: questi concetti non esistono in darktable; il recupero luci avviene tramite *highlight reconstruction*, *sigmoid*, o *agx shoulder*.  
- ❌ **Non usare “clarity” come in LR**: in darktable, *local contrast* o *diffuse or sharpen* sono strumenti distinti, non sostituti di un tone mapper.

### Esempio: Regolazione fine del pivot con la pipetta
*Da [A guide to AGX in darktable](https://www.youtube.com/watch?v=iaZ2-QvOHyA) (timestamp 02:15)*  
1. Attiva il modulo AgX e vai alla scheda *input exposure range*  
2. Clicca sull’icona della pipetta accanto a **pivot exposure**  
3. Clicca su una zona di media luminosità del soggetto principale (es. pelle, foglia verde, parete grigia)  
4. Il valore di *pivot exposure* si aggiorna automaticamente (es. `+0.27 EV`)  
5. Verifica che la curva tonale mostri un punto di flesso coerente con l’area selezionata — se la curva appare appiattita, aumenta leggermente il *contrast* a `2.95`[^agx-guide]

### Esempio: Ottimizzazione automatica dei punti bianco/nero
*Da [darktable 5.4 NEW UPDATE!](https://www.youtube.com/watch?v=yiTqUgoWg6Q) (timestamp 03:42)*  
1. Apri un’immagine RAW con forte contrasto (es. siluetta in controluce)  
2. Nel modulo AgX, clicca su **auto tune levels**  
3. Il sistema calcola automaticamente `white relative exposure = +6.50 EV` e `black relative exposure = -10.00 EV`  
4. Controlla visivamente che le zone di massima luminanza (es. riflessi su vetro) e minima (es. ombre sotto un tavolo) conservino dettagli  
5. Se il cielo appare troppo compresso, aumenta *shoulder power* da `1.55` a `1.75`[^dt54]

### Esempio: Correzione di clipping cromatico con Primaries
*Da [darktable 5.4 NEW UPDATE!](https://www.youtube.com/watch?v=yiTqUgoWg6Q) (timestamp 06:28)*  
1. Apri un’immagine con forti luci blu (es. palco con LED blu)  
2. Vai alla scheda *primaries* del modulo AgX  
3. Imposta **blue attenuation = 71.48%**, **blue rotation = -3.0°**, **recover purity = 15.00%**  
4. Verifica che le aree blu non presentino blocchi di colore uniforme  
5. Se i toni rimangono artificiali, riduci ulteriormente *blue attenuation* a `65.00%`[^dt54]

## Domande frequenti

### Problema: La curva tonale mostra una porzione arancione anche con parametri moderati
Questo indica che la curva sta entrando in una regione non invertibile (overshoot). Riduci *latitude* o aumenta *shoulder power* per ristabilire la forma a S. Se persiste, modifica *curve gamma* a `0.95` per riequilibrare la transizione.[^agx-guide]

### Problema: Dopo aver attivato AgX, l’immagine appare troppo "piatta" nonostante il contrasto a 2.80
Verifica che il modulo *exposure* sia stato usato per posizionare correttamente il grigio medio prima di AgX. Un valore errato di *exposure* (es. `-0.80 EV`) può annullare l’effetto del contrasto. Riporta *exposure* a `0.00 EV` e regola nuovamente con la pipetta su una zona neutra.[^dt54]

### Problema: Il modulo Sigmoid produce artefatti sui capelli o sulle texture fini
Riduci il parametro *skew* a `-0.25` e imposta *preserve hue* a `95%`. Evita valori di *contrast* superiori a `1.80` su immagini con ISO >1600, dove il rumore amplifica gli artefatti.[^sigmoid-tutorial]

## Risorse pratiche

- 📺 [A guide to AGX in darktable](https://www.youtube.com/watch?v=iaZ2-QvOHyA) — focus su *primaries* e *preserve hue*  
- 📺 [Darktable Filmic v5](https://www.youtube.com/watch?v=K7ALyEU9fHY) — Analisi tecnica della curva, opzione *Safe*, e confronto tra v5/v6/v7  
- 📺 [How to get accurate colours in darktable](https://www.youtube.com/watch?v=TMlF85TFIUo) — Effetto Bezold-Brücke, workflow per tramonti, uso di maschere parametriche  
- 📘 [darktable User Manual — Tone Equalizer](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/tone-equalizer/) — Documentazione ufficiale completa, con diagrammi di flusso  

## Fonti

[^manual-agx]: *darktable User Manual -- AgX*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/agx/)
[^manual-sigmoid]: *darktable User Manual -- Sigmoid*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/sigmoid/) | Copia locale: `processed/darktable-usermanual-en/usermanual-48-en-module-reference-processing-modules-sigmoid.md`
[^manual-filmic]: *darktable User Manual -- Filmic RGB*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/filmic-rgb/) | Copia locale: `processed/darktable-usermanual-en/usermanual-48-en-module-reference-processing-modules-filmic-rgb.md`
[^manual-tone-eq]: *darktable User Manual -- Tone Equalizer*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/tone-equalizer/)
[^agx-guide]: *[A guide to AGX in darktable](https://www.youtube.com/watch?v=iaZ2-QvOHyA)* -- A Dabble in Photography
[^firststeps]: *[darktable first steps ep01](https://www.youtube.com/watch?v=P4cL61ZHqFw)* -- A Dabble in Photography
[^dt54]: *[darktable 5.4 NEW UPDATE](https://www.youtube.com/watch?v=yiTqUgoWg6Q)* -- A Dabble in Photography
[^lowlight]: *[Lowlight photos in darktable](https://www.youtube.com/watch?v=O7wXgmQZqiU)* -- A Dabble in Photography
[^landscape]: *[Darktable landscape edit with AI](https://www.youtube.com/watch?v=OERXOFz9lEo)* -- A Dabble in Photography
[^pixls-filmic-vs]: *discuss.pixls.us -- Compare and contrast: Filmic RGB vs AgX* | Copia locale: `processed/discuss-pixls/`
[^sigmoid-tutorial]: *[Utilisation du module Sigmoid](https://darktable.fr/posts/2023/01/utilisation-du-module-sigmoid/)* -- darktable.fr (tutoriel francese)
[^filmic-v5]: *[Darktable Filmic v5](https://www.youtube.com/watch?v=K7ALyEU9fHY)* -- A Dabble in Photography
