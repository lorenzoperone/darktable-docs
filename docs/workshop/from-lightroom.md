# Migrazione da Lightroom a darktable: workshop pratico

Questo workshop guida passo-passo un utente proveniente da Lightroom nell’elaborazione di una fotografia RAW in **darktable 5.4+**, replicando un flusso tipico di sviluppo *Lightroom-style* — ma rispettando l’architettura tecnica e la filosofia di darktable: **scene-referred, non-destructive, modulare e controllabile**[^darktable-not-lightroom]. Non si tratta di “fare come Lightroom”, ma di *tradurre il proprio linguaggio creativo* in un sistema più profondo, meno opaco e completamente aperto[^lightroom-darktable-express-01].

!!! info "darktable ≠ clone gratuito"
    darktable non è un “Lightroom open source”: è un sistema di elaborazione basato su modelli fisici della luce (RGB lineare, scene-referred), mentre Lightroom opera in spazio gamma-encodato e con curve predefinite indesiderabili[^darktable-not-lightroom]. Questa differenza fondamentale implica che *non esiste un mapping 1:1 tra i moduli*, ma solo equivalenze funzionali.

---

## Panoramica del workflow

Il flusso qui descritto è stato testato su una foto RAW Canon EOS R6 (CR3) e replica un classico sviluppo Lightroom:  
**Esposizione → Bilanciamento colore → Dettagli → Correzioni geometriche → Stile finale**.  
Ogni modulo è posizionato nella pipeline in ordine ottimale per preservare la qualità e il controllo[^suivre-tutoriels-lr].

```mermaid
flowchart TD
    A["1. Compensazione<br/>sovraesposizione RAW"]
    --> B["2. Esposizione"]
    --> C["3. Bilanciamento<br/>del bianco"]
    --> D["4. Calibrazione<br/>colore (primaries)"]
    --> E["5. Curva toni"]
    --> F["6. Riduzione rumore"]
    --> G["7. Nitidezza"]
    --> H["8. Correzione<br/>obiettivo"]
    --> I["9. Vignettatura"]
    --> J["10. Bilanciamento<br/>colore RGB"]
```

> ⚠️ **Attenzione**: In darktable, i moduli agiscono *in sequenza rigida*[^de-lightroom-a-darktable-02]: l'ordine del pixelpipe è fisso e non dipende dall'ordine in cui attivi i moduli. Ad esempio, `denoise (profiled)` è sempre applicato prima di `sharpen`.

---

## Passo 1: Apertura e prima valutazione

Apri l’immagine RAW in darktable:  
→ Seleziona la foto nella *lighttable*  
→ Premi `D` per entrare in *darkroom*  
→ Verifica che l’istogramma (modulo *scopes*, in alto a destra) sia visibile  

Osserva:
- L’istogramma mostra una distribuzione asimmetrica? (es. pila a sinistra = sottoesposta)  
- Il picco rosso/blu è fuori scala? → indica sbilanciamento cromatico o clipping  
- La preview mostra artefatti? (bande, frange cromatiche, macchie) → richiederà correzioni specifiche  

!!! tip "Prima regola: non toccare nulla subito"
    Con il flusso *scene-referred* (default) darktable applica già alcuni moduli di base: profilo colore di ingresso, bilanciamento del bianco, un'esposizione di partenza e il tone mapper scelto nelle preferenze (AgX, Sigmoid o Filmic) — **non** una curva base come in Lightroom. Valuta l'immagine così com'è prima di intervenire; se vuoi ripartire da zero, usa il modulo **cronologia** (*history stack*) e torna all'elemento *originale*. Vedi [Cronologia e history stack](../pipeline/history-stack.md).

---

## Passo 2: Esposizione globale (`exposure`)

In Lightroom: *Basic > Exposure*  
In darktable: modulo **`exposure`**, scheda *Exposure*  

| Parametro | Valore tipico | Perché |
|-----------|----------------|--------|
| **Exposure compensation** | +0.30 a +1.20 EV | Compensa sottoesposizione misurata dal sensore; usa la pipetta sul grigio neutro (18%) per calibrare[^de-lightroom-a-darktable-02] |
| **Black level** | -0.05 a -0.25 | Recupera dettagli nelle ombre profonde senza appiattirle; evita valori < -0.30 (rischio banding) |
| **White point** | 0.98–0.995 | Imposta il punto di bianco massimo senza clipping; verifica con `O` (overexposure overlay) |

✅ **Cosa osservare**:  
- Attiva `O`: le zone in rosso sono *clippate* (luminanza > 1.0).  
- Se il rosso appare su cieli o luci speculari, riduci `Exposure compensation`.  
- Se non appare mai, l’immagine è probabilmente sottoesposta.

---

## Passo 3: Bilanciamento del bianco (`white balance`)

In Lightroom: *Basic > Temp/Tint*  
In darktable: modulo **`white balance`**, scheda *White balance*  

| Parametro | Valore tipico | Perché |
|-----------|----------------|--------|
| **Temperature** | 4500–6500 K | Usa la pipetta su una zona neutra (pavimento, muro, carta grigia); evita superfici riflesse o illuminate da fonti miste[^de-lightroom-a-darktable-02] |
| **Tint** | -5 a +10 | Corregge dominanti verdi/magenta; valori estremi (> ±15) indicano problemi di illuminazione o profilo errato |

⚠️ **Attenzione**: `white balance` agisce *prima* di `color calibration`[^faire-comme-lightroom]. darktable non legge profili DCP: usa le matrici integrate o un profilo ICC in *input color profile*, e affina con *color calibration*.

---

## Passo 4: Gestione del colore (`color calibration`)

In Lightroom: *Basic > Vibrance/Saturation* + *HSL*  
In darktable: modulo **`color calibration`**, schede *colorfulness* e *CAT* (per la *gamut compression*)  

| Parametro | Valore tipico | Perché |
|-----------|----------------|--------|
| **Red/Green/Blue saturation** | +10% a +30% | Aumenta vividezza *senza* alterare l’equilibrio cromatico globale (meglio di `vibrance`)[^comment-changer-couleurs-lr] |
| **Red/Green/Blue hue shift** | -3° a +3° | Corregge sfumature imprecise (es. rossi troppo aranciati, blu troppo violacei) |
| **Gamut compression** | 85–95% | Previene il clipping cromatico nelle alte luci; valore 90% è sicuro per la maggior parte delle immagini[^de-lightroom-a-darktable-03] |

✅ **Cosa osservare**:  
- Abilita `gamut warning` (icona occhio): le aree gialle indicano colori fuori gamut sRGB.  
- Se compaiono molti gialli dopo `saturation`, abbassa `gamut compression`.

---

## Passo 5: Curva tonale (`tone curve`)

In Lightroom: *Tone Curve > Parametric* o *Point Curve*  
In darktable: modulo **`tone curve`**, scheda *Tone curve*  

Usa la modalità **point curve**, non parametric (più precisa e simile a Lightroom)[^suivre-tutoriels-lr]:  

| Punto | Coordinata (x,y) | Funzione |
|-------|------------------|----------|
| Nero | (0.00, 0.00) | Fissa il punto nero assoluto |
| Ombre | (0.15, 0.12) | Alza leggermente per aprire le ombre |
| Mezzitoni | (0.50, 0.48) | Leggera S-curve per contrasto naturale |
| Luci | (0.85, 0.82) | Controlla compressione luci senza desaturare |
| Bianco | (1.00, 1.00) | Fissa il punto bianco assoluto |

✅ **Cosa osservare**:  
- La curva deve essere sempre monotona crescente (nessun “gobbo”).  
- Se la curva scende, hai invertito i punti → premi `Reset curve`.

---

## Passo 6: Nitidezza e rumore (`sharpening` + `denoise (profiled)`)

In Lightroom: *Detail > Sharpening + Noise Reduction*  
In darktable: due moduli separati; nel pixelpipe `denoise (profiled)` è sempre applicato prima di `sharpen`:  

### `sharpening`  
| Parametro | Valore tipico | Perché |
|-----------|----------------|--------|
| **Amount** | 45–70 | Valore sufficiente per sensori moderni (R6, A7IV, Z6II) |
| **Radius** | 0.9–1.3 | Evita effetti “halo”; >1.5 genera artefatti sui bordi |
| **Threshold** | 15–25 | Ignora il rumore nelle zone omogenee (cielo, pelle) |

### `denoise (profiled)` (applicato nel pixelpipe prima di `sharpen`)  
| Parametro | Valore tipico | Perché |
|-----------|----------------|--------|
| **Strength** | 25–45 | Regola in base all’ISO: ISO 100 → 25, ISO 3200 → 45 |
| **Spatial detail** | 20–35 | Preserva texture fine (capelli, tessuti) |
| **Range detail** | 15–25 | Controlla rumore cromatico (macchie rosse/verdi) |

⚠️ **Attenzione**: `denoise (non-local means)` è più aggressivo e meno preciso — evitalo per lavori professionali[^de-lightroom-a-darktable-03].

---

## Passo 7: Correzioni geometriche (`lens correction` + `vignetting`)

In Lightroom: *Lens Corrections > Profile + Manual*  
In darktable:  

### `lens correction`  
- Abilita **Enable distortion correction**, **Enable chromatic aberration correction**, **Enable vignetting correction**  
- Seleziona il profilo corretto (es. `Canon RF 24-105mm f/4L IS USM`)  
- Se il profilo manca: usa `manual` → `Distortion` (-5 a +10), `Multiplier` (0.95–1.05)  

### `vignetting`  
La vignettatura ottica si corregge in *lens correction* (vedi sopra): il modulo `vignetting` serve solo come effetto creativo, per scurire o schiarire i bordi a gusto.

✅ **Cosa osservare**:  
- Attiva `preview grid` (icona griglia): ti aiuta a valutare distorsione e vignettatura[^de-lightroom-a-darktable-04].

---

## Passo 8: Stile finale (`color balance rgb`)

In Lightroom: *Split Toning* o *Calibration*  
In darktable: modulo **`color balance rgb`**, scheda *4 ways*  

| Parametro | Valore tipico | Perché |
|-----------|----------------|--------|
| **Shadows lift hue/chroma** | 210° / +15% | Aggiunge un tocco freddo alle ombre (blu-ciano) |
| **Global power hue/chroma** | 0° / +5% | Neutralità con leggera saturazione |
| **Highlights gain hue/chroma** | 30° / +10% | Tono caldo alle luci (giallo-ambra) |
| **Global saturation** | +5% a +12% | “Pop” finale senza artificiosità |

✅ **Consiglio avanzato**:  
Per un look “cinematografico”[^de-lightroom-a-darktable-05], lavora sulla `chroma` dei controlli 4 ways invece che sulla `saturation` globale, per un controllo più fisiologico del colore.

---

## Passo 9: Introduzione a `filmic rgb` (alternativa avanzata a `tone curve`)

In Lightroom: *Tone Curve + Highlights/Shadows* combinati  
In darktable: modulo **`filmic rgb`**, scheda *Scene* e *Look*  

Il modulo `filmic rgb` è il sostituto concettuale più potente del vecchio `base curve` e del `tone curve` per flussi *scene-referred*. È progettato per gestire dinamiche ampie, preservare i colori e offrire un controllo fisicamente coerente del tono[^filmic-rgb-intro].  

> ⚠️ **Attenzione**: nel pixelpipe `filmic rgb`[^filmic-rgb-order] viene **dopo** `demosaic`, `denoise`, `white balance`, `exposure`, `color calibration`, `sharpen` e `color balance rgb`, e **prima** di `vignetting`. La posizione è fissa.

### Esempio: configurazione base per scatto ETTR  
*Da [“filmic rgb: remap any dynamic range in darktable 3”](https://www.youtube.com/watch?v=zbPj_TqTF880) (timestamp 4:12)*  
1. Nella scheda *Scene*:  
   - `white relative exposure` = +3.2 EV (per immagine con esposizione a destra)  
   - `black relative exposure` = -6.8 EV  
   - `middle-gray luminance` = lasciato a default (non modificato)  
2. Nella scheda *Look*:  
   - `contrast` = 1.25  
   - `latitude` = 92%  
   - `shadows ↔ highlights balance` = -0.15  
3. Nella scheda *Options*:  
   - `preserve chrominance` = `RGB power norm` (default)  
   - `contrast in shadows` = `soft`  
   - `contrast in highlights` = `soft` (opzioni: `hard`, `soft`, `safe`)  

✅ **Cosa osservare**:  
- Attiva `look only` view (icona grafico): la curva centrale deve essere una S morbida, senza “gobbi” né tagli netti.  
- Se i punti bianchi/neri diventano rossi nel grafico, riduci `latitude` o ricalibra `white/black relative exposure`[^filmic-rgb-graphic-display].

---

## Passo 10: Correzioni tecniche avanzate (`demosaic` + `rotate perspective`)

In Lightroom: *Detail > Sharpening* + *Lens Corrections > Transform*  
In darktable:  

### `demosaic` (con capture sharpening)  
Disponibile da darktable 5.4+, questa funzione applica una nitidezza *durante* la demosaicizzazione, non dopo. È più efficace e meno rumorosa del `sharpening` tradizionale[^discuss-pixls-demosaic].  
- Abilita **Capture sharpening**  
- `radius` = 12 (valore calcolato automaticamente, ma regolabile tra 8–16)  
- `strength` = 0.85  
- `threshold` = 18  

✅ **Nota operativa**:  
Se compare l’errore *“cannot calculate reliable capture radius”*, disattiva temporaneamente `crop` e zooma a 1:1 prima di abilitare il modulo[^discuss-pixls-demosaic].

### `rotate perspective`  
Per correggere orizzonti inclinati o linee cadenti (es. architettura):  
- Abilita **Structure detection** → `Verticals`  
- `correction strength` = 0.65  
- `refinement` = 0.30  
- `rotation` = 0.0° (se la struttura è ben rilevata, non serve regolare manualmente)  

⚠️ **Attenzione**: non eccedere oltre `correction strength = 0.75`: genera artefatti di interpolazione e perdita di dettaglio nei bordi[^darktable-manual-rotate-perspective].

---

## Consigli operativi chiave

- **Non usare `base curve` nel flusso scene-referred**[^dt54-update]: non è deprecata, ma è pensata per il flusso display-referred. Usa sigmoid, filmic o AgX al suo posto.  
- **darktable non usa profili DCP**[^darktable-not-lightroom]: i colori di partenza derivano dalle matrici integrate per ogni fotocamera (o da un profilo ICC in *input color profile*). Usa `color calibration` per gli affinamenti.  
- **I preset Lightroom (.xmp) NON sono importabili**: darktable usa `.dtstyle`. Converti manualmente o usa strumenti esterni come [`lr2dt`](https://github.com/bradleybuda/lr2dt)[^de-lightroom-a-darktable-05].  
- **La gestione dei cataloghi è diversa**[^de-lightroom-a-darktable-01]: darktable usa un database (`library.db`) più file XMP *sidecar* accanto a ogni immagine, non metadati incorporati nel file.  
- **Per il tethering**[^tethering-avec-darktable]: la vista *tethering* (via gphoto2) supporta lo scatto da USB e, sulle fotocamere compatibili, anche il live view.  
- **`base curve` è compatibile solo con `display-referred`**: se abilitato in un flusso `scene-referred`, causa clipping e comportamenti imprevedibili[^base-curve-display-referred].  
- **Usa `color assessment mode` (Ctrl+B) per ogni regolazione tonale**: il bordo bianco su sfondo grigio al 18% elimina gli errori percettivi causati dal contesto cromatico[^process-color-assessment].  

---

## Domande frequenti

### Problema: “L’immagine sembra piatta dopo aver abilitato `filmic rgb`”  
Ciò accade perché `filmic rgb` rimuove la compressione tonale precoce del `base curve`. Il “piatto” è in realtà neutralità fisica: i dati sono ora lineari e pronti per il grading. Applica `color balance rgb` per reintrodurre vividezza e atmosfera, non `saturation` globale[^filmic-rgb-prerequisites].

### Problema: “Il modulo `color balance rgb` non reagisce ai cursori”  
Verifica che il modulo sia effettivamente attivo e che una maschera non ne limiti l'effetto. Nel pixelpipe `color balance rgb`[^color-balance-rgb-input] si trova sempre *prima* del tone mapper (`filmic rgb`/`sigmoid`/`AgX`): è la posizione corretta, non va spostato.

### Problema: “Il rumore aumenta dopo aver applicato `sharpening`”  
Questo è normale: `sharpening` amplifica il rumore esistente. Nel pixelpipe `denoise (profiled)`[^de-lightroom-a-darktable-02] è comunque applicato *prima* di `sharpen`: aumenta la riduzione del rumore o riduci `amount`/alza `threshold` in `sharpen`.

---

## Tabella preset built-in: `color balance rgb`

| Preset | Quando usarlo | Note |
|---|---|---|
| **basic colorfulness \| standard** | Come punto di partenza per saturazione globale | Aumento moderato di vibrance e saturazione[^color-balance-rgb-presets] |
| **basic colorfulness \| natural skin** | Ritratti | Variante più delicata sui toni della pelle |
| **basic colorfulness \| vibrant colors** | Paesaggi, colori accesi | Variante più marcata |
| **basic colorfulness \| legacy** | Compatibilità con modifiche vecchie | Versione originale del preset |

Non esistono preset integrati di teal/orange o di emulazione pellicola: questi look si costruiscono a mano nella scheda *4 ways*.

---

## Risorse utili

- 📹 [Video tutorial “De Lightroom à darktable” (OuiOuiPhoto, 5 parti)](https://www.ouiouiphoto.fr/Wp/2018/02/de-lightroom-a-darktable/) — workflow completo passo-passo[^de-lightroom-a-darktable-01][^de-lightroom-a-darktable-05]  
- 📹 [“Faire comme Lightroom mais avec darktable” (David LaCivita)](https://www.youtube.com/watch?v=...) — confronto diretto risultati[^faire-comme-lightroom]  
- 📚 [Guida ufficiale darktable 5.4 (inglese)](https://www.darktable.org/usermanual/) — riferimento tecnico completo[^manual-agx]  
- 🛠️ [darktable-fr.org](https://darktable.fr) — tutorial in francese con esempi pratici e traduzioni[^darktable-fr]  
- 📹 [“darktable 5.4 - A Introductory Beginner Workflow” (Pixls.us forum)](https://discuss.pixls.us/t/darktable-5-4-a-introductory-beginner-workflow-and-interactive-walkthrough/54755) — walkthrough interattivo con file CR3 scaricabile[^discuss-pixls-demosaic]  
- 📘 [darktable.info — Scene-Referred Workflow](https://darktable.info/en/darktable-first-steps/understand/scene-referred-workflow/) — spiegazione concettuale con diagrammi[^darktable-info-scene-referred]  

---

## Fonti

[^darktable-not-lightroom]: darktable.fr, ["darktable n'est pas le clone gratuit de Lightroom"](https://darktable.fr/posts/2020/01/darktable-nest-pas-le-clone-gratuit-de-lightroom/)
[^suivre-tutoriels-lr]: darktable.fr, ["Suivre les tutoriels Lightroom avec darktable"](https://darktable.fr/posts/2016/04/suivre-les-tutoriels-lightroom-avec-darktable/)
[^de-lightroom-a-darktable-01]: darktable.fr, ["De Lightroom à darktable 01 – Importation et tri"](https://darktable.fr/posts/2018/02/de-lightroom-a-darktable-01-importation-et-tri/)
[^de-lightroom-a-darktable-02]: darktable.fr, ["De Lightroom à darktable 02 – Développement lightroom"](https://darktable.fr/posts/2018/02/de-lightroom-a-darktable-02-developpement-lightroom/)
[^de-lightroom-a-darktable-03]: darktable.fr, ["De Lightroom à darktable 03 – Développement Photoshop"](https://darktable.fr/posts/2018/02/de-lightroom-a-darktable-03-developpement-photoshop/)
[^de-lightroom-a-darktable-04]: darktable.fr, ["De Lightroom à darktable 04 - Autres fonctions"](https://darktable.fr/posts/2018/02/de-lightroom-a-darktable-04-autres-fonctions/)
[^de-lightroom-a-darktable-05]: darktable.fr, ["De Lightroom à darktable 05 - Migration et conclusion"](https://darktable.fr/posts/2018/02/de-lightroom-a-darktable-05-migration-et-conclusion/)
[^comment-changer-couleurs-lr]: darktable.fr, ["Comment changer les couleurs... comme avec Lightroom"](https://darktable.fr/posts/2018/04/comment-changer-les-couleurs-de-vos-photos-avec-darktable-comme-avec-la-selection-de-couleurs-de-lightroom/)
[^faire-comme-lightroom]: darktable.fr, ["Faire comme Lightroom mais avec darktable"](https://darktable.fr/posts/2017/07/faire-comme-lightroom-mais-avec-darktable/)
[^tethering-avec-darktable]: darktable.fr, ["Tethering avec darktable"](https://darktable.fr/posts/2018/01/tethering-avec-darktable/)
[^dt54-update]: darktable.org, ["Release Notes darktable 5.4"](https://www.darktable.org/2024/03/darktable-5-4-released/)
[^manual-agx]: darktable.org, ["User Manual – AGX module"](https://www.darktable.org/usermanual/ch03s04s01.html)
[^darktable-fr]: darktable.fr, community francese di darktable, [https://darktable.fr](https://darktable.fr)
[^lightroom-darktable-express-01]: darktable.fr, serie "De Lightroom à darktable", [https://darktable.fr/posts/2018/02/de-lightroom-a-darktable-01-importation-et-tri/](https://darktable.fr/posts/2018/02/de-lightroom-a-darktable-01-importation-et-tri/)
[^filmic-rgb-intro]: darktable.org, ["filmic rgb: remap any dynamic range in darktable 3"](https://www.youtube.com/watch?v=zbPj_TqTF880)
[^filmic-rgb-order]: darktable.org, ["User Manual – filmic rgb"](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/filmic-rgb/#usage)
[^filmic-rgb-graphic-display]: darktable.org, ["User Manual – graphic display"](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/filmic-rgb/#graphic-display)
[^discuss-pixls-demosaic]: discuss.pixls.us, ["darktable 5.4 - A Introductory Beginner Workflow"](https://discuss.pixls.us/t/darktable-5-4-a-introductory-beginner-workflow-and-interactive-walkthrough/54755)
[^darktable-manual-rotate-perspective]: darktable.org, ["User Manual – rotate and perspective"](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/rotate-perspective/)
[^base-curve-display-referred]: darktable.org, ["User Manual – base curve"](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/base-curve/#)
[^process-color-assessment]: darktable.org, ["User Manual – process"](https://docs.darktable.org/usermanual/development/en/overview/workflow/process/#color-assessment-mode)
[^color-balance-rgb-input]: darktable.org, ["User Manual – color balance rgb"](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-balance-rgb/#)
[^color-balance-rgb-presets]: darktable.org, ["User Manual – color balance rgb presets"](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-balance-rgb/#presets)
[^darktable-info-scene-referred]: darktable.info, ["Scene-Referred Workflow"](https://darktable.info/en/darktable-first-steps/understand/scene-referred-workflow/)
