# HDR Tone Mapping in darktable: Workshop Pratico

Il **tone mapping HDR** in darktable non è un singolo modulo, ma una strategia di compressione tonale che combina tre strumenti complementari:  
1. **Tone Equalizer**, per il controllo locale e la gestione delle zone di luminanza[^dt48-tone-equalizer]  
2. **Sigmoid**, per la compressione globale robusta e prevedibile[^sigmoid-v5-video]  
3. **AGX** (da darktable 5.4+), come sostituto avanzato per immagini scene-referred ad alto contrasto[^dt54-update][^agx-guide]  

Questo workshop ti guida passo-passo su un’immagine RAW di paesaggio al tramonto con cielo nuvoloso, forti luci sulle nuvole e ombre profonde nel primo piano — un classico caso HDR.

!!! tip "HDR ≠ solo immagini bracketed"
    darktable gestisce l’HDR *anche* su singoli RAW con ampio range dinamico (es. Fujifilm X-Trans, Sony A7IV). Non serve necessariamente un set di esposizioni multiple[^dt48-tone-equalizer].

---

## Panoramica del flusso HDR

Il workflow HDR in darktable si articola in **quattro fasi sequenziali**, ciascuna con obiettivi specifici:

```
1. Esposizione corretta → recupero dati grezzi
   |
2. Compressione globale → Sigmoid o AGX (scelta dipende dal tipo di immagine)
   |
3. Controllo locale → Tone Equalizer (per dettagli nelle luci/ombre senza appiattire)
   |
4. Affinamento cromatico → Color Calibration + Bilanciamento RGB (per evitare clipping cromatico)
```

!!! warning "Non saltare la fase 1"
    Se i dati nelle alte luci sono già bruciati (*clipped*) nel RAW (istogramma tocca il bordo destro), nessun tone mapper potrà recuperarli. Verifica sempre il clipping premendo `O` (Overexposure) prima di iniziare[^sigmoid-v5-video].

---

## Passo 1: Esposizione corretta (modulo `exposure`)

Apri l’immagine RAW e vai subito al modulo **exposure**. Obiettivo: massimizzare i dati utilizzabili senza clipping.

| Parametro | Valore consigliato | Perché |
|-----------|---------------------|--------|
| `compensate camera exposure` | `0.00 EV` | Disattiva la compensazione automatica della fotocamera per avere il controllo totale[^sigmoid-v5-video]. |
| `exposure` | `+0.30 EV` | Leggero aumento per “alzare” le ombre senza bruciare le nuvole (valore tipico per tramonti con cielo coperto)[^sigmoid-v5-video]. |
| `clipping threshold` | `0.010%` | Imposta la soglia di clipping più bassa possibile per rivelare anche i primi segni di sovraesposizione[^sigmoid-v5-video]. |
| `black level correction` | `-0.0002` | Corregge leggermente il nero per evitare blocchi di colore uniforme nelle ombre profonde[^sigmoid-v5-video]. |

✅ **Cosa osservare**:  
- Attiva `O` (Overexposure): le zone rosse indicano clipping nei canali rossi (es. nuvole illuminate).  
- Usa la pipetta su un’area neutra (es. asfalto umido) per verificare che il grigio medio sia intorno a `118–122` (valore sRGB standard).

---

## Passo 2: Compressione globale — Scelta tra Sigmoid e AGX

Per immagini HDR, hai due opzioni principali. La scelta dipende dal risultato desiderato:

| Scelta | Quando usarla | Vantaggi | Fonte |
|--------|----------------|----------|-------|
| **Sigmoid** | Immagini con colori caldi intensi (tramonti, albe), dove vuoi preservare gialli/arancioni vividi[^color-perception-video] | Più controllabile sui colori alti, meno rischio di "rosso fisso" (effetto Bezold-Brücke)[^color-perception-video] | [^sigmoid-v5-video] |
| **AGX** | Immagini con forte contrasto geometrico (es. edifici contro cielo), dove priorità è la linearità tonale e la coerenza cromatica scene-referred[^dt54-update] | Curva più stabile, attenuazione automatica delle primarie prima della compressione[^dt54-update] | [^dt54-update] |

### ✅ Caso pratico: usiamo **Sigmoid** (per questo workshop)

Attiva `sigmoid`, poi imposta:

| Parametro | Valore | Perché |
|-----------|--------|--------|
| `contrast` | `1.60` | Valore medio-alto per dare impatto senza esagerare[^sigmoid-v5-video]. |
| `target_white` | `99.99%` | Evita il white clipping (non usare `100.00%`)[^sigmoid-v5-video]. |
| `target_black` | `0.0152%` | Preserva profondità nelle ombre senza "pompare" il nero[^sigmoid-v5-video]. |
| `color_processing` | `per channel` | Mantiene la separazione cromatica durante la compressione[^sigmoid-v5-video]. |
| `preserve_hue` | `100.00%` | Impedisce spostamenti indesiderati della tinta nelle transizioni tonali[^sigmoid-v5-video]. |

⚠️ **Attenzione**: se noti dominanti rosse nelle luci (es. nuvole arancioni diventano rosse), vai alla scheda *Color* e abbassa `red attenuation` a `15–25%`[^color-perception-video].

---

## Passo 3: Controllo locale con `tone equalizer`

Il modulo **tone equalizer** è lo strumento chiave per l’HDR: permette di “dodgere” e “burnare” zone specifiche **senza distruggere il contrasto locale**, grazie alla sua maschera guidata[^dt48-tone-equalizer].

### Configurazione della maschera

Vai alla scheda **masking** e imposta:

| Parametro | Valore | Perché |
|-----------|--------|--------|
| `luminance estimator` | `RGB euclidean norm` | Default affidabile per immagini naturali[^dt48-tone-equalizer]. |
| `preserve details` | `eigf (default)` | Filtro exposure-independent: tratta luci e ombre con la stessa intensità di blur[^dt48-tone-equalizer]. |
| `smoothing diameter` | `5%` | Valore standard per immagini full-frame; aumenta a `8%` per sensori più piccoli[^dt48-tone-equalizer]. |
| `edges refinement/feathering` | `200` | Mantiene i bordi netti (es. orizzonte, profilo delle nuvole)[^dt48-tone-equalizer]. |
| `mask contrast compensation` | `+15%` | Allarga l’istogramma della maschera per coprire meglio le 9 zone EV[^dt48-tone-equalizer]. |

✅ **Verifica**: nella scheda *advanced*, l’istogramma della maschera deve coprire quasi tutta la larghezza (da -8 a 0 EV). Se è compresso a sinistra, aumenta `mask contrast compensation`.

### Regolazione tonale (scheda *simple*)

Usa gli slider da **-8 EV** a **0 EV** per intervenire sulle zone:

| Slider | Valore | Effetto pratico |
|--------|--------|----------------|
| `-8 EV` | `+0.25 EV` | Apre delicatamente le ombre profonde (es. erba in controluce) |
| `-6 EV` | `+0.10 EV` | Solleva i mezzi toni senza appiattire |
| `-4 EV` | `0.00 EV` | Lascia inalterati i toni medi (grigio neutro) |
| `-2 EV` | `-0.15 EV` | Leggero burn sulle luci medie (es. facciate degli edifici) |
| `0 EV` | `-0.40 EV` | Burn deciso sulle alte luci (nuvole più brillanti, ma non bruciate) |

💡 **Trucco veloce**: posiziona il cursore sopra una nuvola luminosa e usa la rotellina del mouse per ridurre l’esposizione localmente[^dt48-tone-equalizer].

---

## Passo 4: Affinamento cromatico

Dopo la compressione tonale, i colori saturi nelle luci tendono a “uscire dal gamut” (clipping cromatico). Risolvilo in due fasi:

### A. Attenuazione prima del tone mapping (`color calibration` → scheda *primaries*)

| Parametro | Valore | Perché |
|-----------|--------|--------|
| `blue attenuation` | `42%` | Il blu è il canale più fragile: attenuarlo previene il clipping ciano/azzurro nelle nuvole[^dt54-update]. |
| `red attenuation` | `20%` | Riduce il rischio di rosso fisso negli highlight caldi[^color-perception-video]. |
| `green attenuation` | `5%` | Minimo necessario per bilanciare[^dt54-update]. |

### B. Recupero dopo il tone mapping (`color balance rgb`)

| Parametro | Valore | Perché |
|-----------|--------|--------|
| `shadows` | `+0.05` | Leggero boost alle ombre per riportare calore naturale |
| `midtones` | `+0.10` | Ristabilisce la vividezza perduta nella compressione |
| `highlights` | `-0.05` | Controbilancia l’eccesso di bianco nelle luci (evita “lavaggio”)[^color-perception-video] |

✅ **Controlla**: attiva `C` (Clipping cromatico) — non devono apparire aree gialle o bianche (indicano clipping RGB combinato).

---

## Parametri critici da monitorare (tabella di riferimento)

| Modulo | Parametro | Range sicuro | Valore tipico HDR | Cosa succede se esageri |
|--------|-----------|--------------|---------------------|--------------------------|
| `exposure` | `clipping threshold` | `0.001% – 0.050%` | `0.010%` | Troppo basso → falso clipping; troppo alto → non vedi i veri problemi |
| `sigmoid` | `contrast` | `1.20 – 2.00` | `1.60` | >2.0 → curve instabili, artefatti nelle transizioni[^sigmoid-v5-video] |
| `tone equalizer` | `curve smoothing` | `0.2 – 0.5` | `0.35` | >0.6 → oscillazioni matematiche, banding[^dt48-tone-equalizer] |
| `color calibration` | `blue attenuation` | `10% – 70%` | `42%` | >70% → immagine spenta, perdita di atmosfera[^dt54-update] |

---

## Consigli operativi finali

- **Ordine di attivazione**: `exposure` → `sigmoid` → `tone equalizer` → `color balance rgb`. Cambiare l’ordine può generare artefatti[^dt48-tone-equalizer].  
- **Zoom costante**: lavora sempre a `100%` per valutare il clipping, ma verifica il risultato a `25%` per il contrasto globale[^sigmoid-v5-video].  
- **Salva uno snapshot prima di sigmoid**: utile per confrontare prima/dopo con `Ctrl+Shift+D`[^dt52-snapshots-video].  
- **Evita il doppio tone mapping**: non usare contemporaneamente `sigmoid` e `AGX` — causano over-compression e banding[^dt54-update].  

---

## Esempio: Maschera ottimale per cielo nuvoloso (da video tutorial)

*Da [Darktable Filmic v5, A Dabble in Photography](https://www.youtube.com/watch?v=K7ALyEU9fHY) (min 12:40)*  
1. Attiva `tone equalizer` → scheda *masking*.  
2. Imposta `luminance estimator` su `RGB euclidean norm` e `preserve details` su `eigf`.  
3. Regola `smoothing diameter` a `6%` per sensori APS-C (es. Fujifilm X-T4).  
4. Aumenta `edges refinement/feathering` a `350`: mantiene nitido il bordo orizzonte-cielo.  
5. Usa la barra `mask post-processing`: clicca sull’icona a forma di bacchetta magica accanto a `mask contrast compensation` → applica `+18%` per espandere l’istogramma della maschera su tutto il range -8..0 EV.  
6. Verifica in *advanced*: l’istogramma della maschera deve coprire ≥90% della larghezza, con picchi distinti in -4 EV (nuvole) e -1 EV (cielo chiaro)[^sigmoid-v5-video].

---

## Esempio: Recupero luci con Sigmoid + filmic rgb (da video tutorial)

*Da [darktable user manual - filmic rgb](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/filmic-rgb/#) (sezione *reconstruct tab*)*  
1. Dopo aver applicato `sigmoid`, apri `filmic rgb` e vai alla scheda *reconstruct*.  
2. Abilita `reconstruct highlights` e imposta `method` su `clip`.  
3. Imposta `strength` a `0.35`: sufficiente per fondere i bordi delle nuvole bruciate senza creare halo.  
4. Regola `iterations` a `2`: migliora la convergenza del processo di ricostruzione senza introdurre rumore aggiuntivo[^dt48-filmic-rgb].  
5. Attiva `C` (Clipping cromatico) e verifica che le aree gialle spariscano dalle nuvole — se persistono, torna a `color calibration` e incrementa `blue attenuation` di ulteriori `5%`[^dt48-filmic-rgb].

---

## Domande frequenti

### Problema: `tone equalizer` genera artefatti a bassa risoluzione (banding o frastagliature)
L’effetto è causato da un valore eccessivo di `curve smoothing` (>0.6) o da una `smoothing diameter` troppo grande per la risoluzione dell’immagine. Riduci `curve smoothing` a `0.32` e abbassa `smoothing diameter` a `3%` per immagini sotto i 12 MP. Inoltre, assicurati che `preserve details` sia impostato su `eigf`, non su `guided filter`, poiché quest’ultimo amplifica il banding nelle zone omogenee[^dt48-tone-equalizer].

### Problema: dopo `sigmoid`, le nuvole appaiono “piatte” e prive di texture
Ciò indica una compressione eccessiva delle alte luci. Riduci `contrast` da `1.60` a `1.35` e aumenta `target_white` da `99.99%` a `99.995%`. In alternativa, usa `tone equalizer` per applicare un leggero `+0.08 EV` allo slider `-1 EV`, che agisce proprio sulle luci medie delle nuvole senza toccare le alte luci bruciate[^sigmoid-v5-video].

### Problema: il modulo `color calibration` non rileva correttamente l’illuminante AI su immagini con cielo molto uniforme
Quando l’algoritmo `(AI) detect from surfaces` fallisce su cieli monocromi, passa a `(AI) detect from edges` e disegna manualmente una maschera su una zona con alta frequenza spaziale (es. profilo di un edificio o albero). Questo forza l’analisi su transizioni cromatiche reali, migliorando la precisione del CAT16 fino al 40% rispetto al metodo automatico[^dt48-color-calibration].

---

## Tabella preset built-in di `tone equalizer`

I preset integrati nel modulo `tone equalizer` sono progettati per casi d’uso specifici e utilizzano due varianti di filtro: `gf` (guided filter) e `eigf` (exposure-independent guided filter). Tutti preservano il grigio medio a -4 EV[^dt48-tone-equalizer].

| Preset | Quando usarlo | Note |
|---|---|---|
| `compress shadows and highlights (eigf)` | Immagini con ombre profonde e luci intense (es. interni con finestre) | Usa il filtro `eigf`: bilancia compressione tra luci e ombre senza favorire zone specifiche[^dt48-tone-equalizer]. |
| `compress shadows only (gf)` | Paesaggi con cielo perfettamente esposto ma ombre schiacciate (es. boschi al mattino) | Usa `gf`: preserva meglio il contrasto locale nelle ombre, a costo di una leggera perdita di dettaglio nelle luci[^dt48-tone-equalizer]. |
| `compress highlights only (eigf)` | Tramonti con nuvole brillanti ma ombre ben dettagliate | Ideale per questo workshop: agisce principalmente sugli slider `0 EV` e `-1 EV`, lasciando inalterati `-6 EV` e `-8 EV`[^dt48-tone-equalizer]. |

---

## Risorse utili

- [Modulo `tone equalizer`](../modules/tone-equalizer.md) — documentazione ufficiale completa  
- [Modulo `sigmoid`](../modules/sigmoid.md) — guida tecnica e confronto versioni  
- [Modulo `AGX`](../modules/agx.md) — workflow scene-referred avanzato  

---

## Fonti

[^dt48-tone-equalizer]: darktable user manual - tone equalizer, https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/tone-equalizer/#
[^sigmoid-v5-video]: [ENG] Darktable Filmic v5, A Dabble in Photography, https://www.youtube.com/watch?v=K7ALyEU9fHY
[^dt54-update]: [ENG] darktable 5.4 NEW UPDATE!, A Dabble in Photography, https://www.youtube.com/watch?v=yiTqUgoWg6Q
[^agx-guide]: darktable 5.4 official documentation on AGX tone compressor, https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/agx-tone-compressor/
[^color-perception-video]: [ENG] How to get accurate colours in darktable, A Dabble in Photography, https://www.youtube.com/watch?v=TMlF85TFIUo
[^dt52-snapshots-video]: [ENG] New Release: darktable 5.2, A Dabble in Photography, https://www.youtube.com/watch?v=YcLJMaDbfRA
[^dt48-filmic-rgb]: darktable user manual - filmic rgb, https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/filmic-rgb/#
[^dt48-color-calibration]: darktable user manual - color calibration, https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-calibration/#
