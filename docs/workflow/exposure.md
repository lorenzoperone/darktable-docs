# Esposizione e Calibrazione Colore

Dopo le correzioni tecniche automatiche (lente, denoise, demosaic), i primi due interventi manuali nel flusso scene-referred sono l'**ancoraggio dell'esposizione** e la **calibrazione cromatica**.

## Il modulo Esposizione

Nel flusso scene-referred, il modulo Exposure ha un compito preciso: posizionare correttamente il **grigio medio** della scena. In un sistema lineare, il grigio medio al 18.45% e' il fulcro attorno al quale ruota tutta l'elaborazione successiva.[^manual-exposure]

### Procedura operativa

1. Attiva la modalita' di valutazione colore (++cmd+b++) -- aggiunge un bordo bianco attorno all'immagine per un contesto cromatico corretto[^firststeps]
2. Regola il cursore esposizione finche' i toni medi del soggetto principale non appaiono naturali
3. Ignora temporaneamente le alte luci bruciate o le ombre profonde: verranno gestite dal tone mapper
4. Se non sei sicuro, usa il selettore automatico: disegna un rettangolo sul soggetto principale

!!! tip "Scorciatoia"
    Premi ++e++ per la regolazione rapida dell'esposizione + rotella del mouse.[^lowlight]

!!! important "L'esposizione e' una scelta artistica"
    Un'immagine high-key avra' il grigio medio piu' chiaro; un'immagine low-key piu' scuro. L'obiettivo non e' che l'istogramma sia «centrato», ma che il soggetto principale abbia la luminosita' percettivamente giusta.[^manual-exposure]

Il manuale ufficiale descrive le due modalita' di regolazione (*manual* e *automatic*) e il concetto di *area exposure mapping* per immagini con gamma dinamica ampia:

> In *automatic* mode, darktable selects an area from the image and adjusts the exposure to match a target lightness value. The area can be set using a drawn mask or a parametric mask.[^manual-exposure]

### Parametri dettagliati del modulo Exposure

Il modulo `exposure` in darktable 5.4+ dispone di **otto parametri fondamentali**, tutti operanti nello spazio scene-referred lineare prima di qualsiasi compressione tonale:

| Parametro | Tipo | Range | Default | Descrizione |
|-----------|------|-------|---------|-------------|
| `mode` | selezione | `manual`, `automatic` | `manual` | Determina se l’esposizione è impostata manualmente o calcolata automaticamente su un’area definita. |
| `compensate camera exposure` | slider | `-5.0` a `+5.0 EV` | `0.0 EV` | Corregge lo scostamento tra l’esposizione misurata dalla fotocamera e quella effettiva (es. per errori di misurazione o ISO non standard). Valori tipici: `-0.7 EV` per RAW Fujifilm X-H2S[^agx-guide]. |
| `exposure` | slider | `-8.0` a `+8.0 EV` | `0.0 EV` | Regolazione principale dell’esposizione globale. Incrementi di `±0.1 EV` sono sufficienti per affinamenti precisi; `±1.0 EV` equivale a un’intera stop. Valore tipico per recupero in bassa luce: `+1.000 EV`[^lowlight]. |
| `black level correction` | slider | `-0.01` a `+0.01` | `0.0000` | Compensa piccole deviazioni del livello nero hardware (es. offset del sensore). Non deve mai superare `±0.001` per evitare clipping negativo[^pipeline]. |
| `clipping threshold` | slider | `0.001%` a `10.0%` | `0.010%` | Soglia percentuale di pixel considerati “bruciati” o “schiacciati”. Usato da `auto tune levels` e dagli algoritmi di rilevamento area. Valore consigliato per precisione: `0.005%`[^agx-guide]. |
| `spot exposure mapping` | toggle | `off` / `on` | `off` | Abilita la nuova funzionalità introdotta in darktable 4.0 per trasferire l’esposizione misurata su un’area specifica (es. un fiore) ad altre immagini[^dt40-new]. |
| `drawn mask` | maschera | `no mask used`, `1 shape used`, ecc. | `no mask used` | Conteggio delle forme vettoriali applicate al modulo (cerchio, ellisse, gradiente, path). Richiede espansione della sezione “masks” per configurazione avanzata[^masking-ep1]. |
| `opacity` | slider | `0%` a `100%` | `100%` | Opacità globale dell’effetto esposizione. Utile per blending con altre istanze o per simulare filtri ND variabili[^b&w-street]. |

Ogni parametro agisce su un livello distinto della pipeline:
- `compensate camera exposure` opera *prima* della lettura del raw black/white point;
- `exposure` e `black level correction` operano nello spazio lineare *post-demosaic*, ma *pre-tonemapping*;
- `clipping threshold` influenza solo gli algoritmi automatici (`auto tune levels`, `spot exposure mapping`) e non modifica l’immagine direttamente[^pipeline].

### Flusso di lavoro avanzato con maschere

Il modulo `exposure` è uno dei più frequentemente usati in combinazione con **maschere disegnate** e **maschere parametriche**, soprattutto per:
- creazione di vignette artistiche (ellisse invertita);
- recupero locale di dettagli in ombre o luci;
- simulazione di filtri ND graduali (gradiente orizzontale);
- enfasi selettiva di elementi chiave (es. “tree highlights” in paesaggi[^landscape]).

Le maschere possono essere combinate tramite **operazioni logiche** (unione, intersezione, differenza, esclusione), definite nell’ordine di apparizione nel `mask manager`. L’ordine è critico: la prima maschera nella lista è il “base layer”, la seconda viene applicata come operatore logico rispetto alla prima[^masking-ep3].

Per esempio, per isolare *solo le foglie illuminate* di un albero:
1. Disegnare un `path` intorno alla chioma (maschera A);
2. Creare una maschera parametrica `hue & lightness` per i rossi/gialli brillanti (maschera B);
3. Impostare la combinazione come **intersezione** (A ∩ B), ottenendo solo i pixel che soddisfano entrambe le condizioni[^landscape].

!!! info "Maschere e performance"
    Le maschere disegnate (`circle`, `ellipse`, `gradient`, `path`) hanno impatto minimo sulle prestazioni. Le maschere parametriche richiedono invece elaborazione intensiva, specialmente se applicate su moduli post-`filmic rgb` o `tone curve`. Per ottimizzare: applicare maschere *prima* di `filmic rgb` quando possibile, e usare `details threshold` ≥ `5%` per ridurre il numero di pixel analizzati[^masking-ep2].

### Consigli operativi avanzati

#### 1. Uso strategico di `spot exposure mapping`
Introdotta in darktable 4.0, questa funzionalità permette di campionare l’esposizione su un’area precisa (con il contagocce) e applicarla a un’altra immagine — ideale per serie fotografiche sotto illuminazione costante.  
Funziona in due modalità:
- **`input`**: misura la luminosità relativa (L\* CIE Lab) dell’area selezionata e la converte in EV per l’output;
- **`correction`**: applica la stessa correzione EV a tutte le immagini della collezione selezionata[^dt40-new].

Valore tipico misurato su superficie neutra: `lightness = 52.9%` → `exposure = +0.858 EV`[^dt40-new].

#### 2. Vignettatura con maschera ellittica
Per creare una vignetta naturale:
- Attivare `exposure` → cliccare sull’icona “disegna maschera” → selezionare `ellipse`;
- Ridimensionare l’ellisse per coprire l’intera immagine;
- **Invertire la maschera** (toggle `invert mask`);
- Impostare `exposure = -0.60 EV`, `opacity = 100%`, `feathering radius = 120 px`;
- Regolare `mask contrast = +20%` per aumentare la transizione netta tra centro e bordi[^masking-ep1].

#### 3. Recupero di dettagli in ombre con maschera di luminanza
Quando si desidera schiarire *solo le ombre senza toccare i mezzi toni*:
- Creare una maschera parametrica `lightness` con `min = 0.0%`, `max = 25.0%`, `softness = 15%`;
- Applicarla a un’istanza `exposure` rinominata “shadow lift”;
- Impostare `exposure = +0.40 EV`, `black level correction = +0.0005`[^b&w-street].

#### 4. Workflow AGX integrato
Con il profilo colore `AgX - scene-referred default`, il modulo `exposure` diventa il primo passo di una catena tonale più sofisticata:
- `exposure`: ancoraggio del grigio medio (es. `+1.420 EV`);
- `tone curve` (AGX): definizione del range dinamico (`white relative exposure = +6.50 EV`, `black relative exposure = -10.00 EV`);
- `filmic rgb`: compressione finale e controllo del pivot[^agx-guide].

Questo approccio separa chiaramente l’ancoraggio (exposure) dalla mappatura (AGX/filmic), migliorando prevedibilità e riproducibilità[^agx-guide].

### Correzioni tecniche preliminari

Prima dell'esposizione manuale, e' fondamentale che alcuni moduli tecnici siano gia' configurati:

| Modulo | Azione | Note |
|--------|--------|------|
| **Raw black/white point** | Non toccare | Essenziale per la pipeline[^pipeline] |
| **White balance** | Lasciare su *Camera Reference* | Serve solo per la demosaicizzazione[^pipeline] |
| **Demosaic** | Attivare *Capture Sharpening* | Salvare come stile predefinito[^dt54] |
| **Lens correction** | Creare auto-preset per obiettivo | Applicare presto per non alterare le maschere[^nightsky] |
| **Denoise (profiled)** | Attivare prima dei selettori auto | Il rumore confonde gli algoritmi[^manual-denoise] |

!!! danger "NON modificare i moduli disabilitati"
    I moduli grigi (*raw black/white point*, *input/output color profile*) sono essenziali per il funzionamento della pipeline. Non modificarli.[^pipeline]

## Calibrazione del Colore

La gestione del colore in darktable segue un approccio a **due stadi**:[^manual-colorcal]

1. **White Balance**: lascia su *Camera Reference*. Corregge solo la dominante verde del sensore Bayer[^pipeline]
2. **Color Calibration** (tab CAT): adattamento cromatico percettivo con il modello **CAT16**

Questo approccio e' molto piu' preciso del tradizionale bilanciamento con temperatura/tinta, e previene i color shift nelle alte luci.

### Metodi di rilevamento illuminante

| Metodo | Quando usarlo |
|--------|--------------|
| **As shot in camera** | Punto di partenza consigliato |
| **Detect from image surfaces** | Scene con superfici neutre |
| **Detect from image edges** | Scene con bordi ad alto contrasto |
| **Istanze multiple + maschere** | Illuminazione mista (es. finestra + incandescenza) |

!!! warning "Cursore della tinta"
    Evitare il cursore della tinta nella calibrazione colore: e' troppo sensibile. Usare il selettore di area neutra o aggiungere magenta per correggere dominanti verdi.[^pipeline]

> *Color calibration provides a more accurate white balance than the legacy white balance module using the CAT16 chromatic adaptation transform from the CIE.*[^manual-colorcal]

### Casi particolari

!!! tip "Doppia calibrazione"
    Quando si applica la Calibrazione Colore due volte sulla stessa area, usare una **maschera invertita** sulla seconda istanza per prevenire doppia applicazione e artefatti cromatici.[^landscape]

!!! info "Profilo colore di input"
    Mantenere *linear rec 2020 RGB* come profilo colore di input per la compatibilita' scene-referred.[^pipeline]

### Esempio: workflow macro con flash (da video tutorial)
*Da [darktable 5.4 - A Introductory Beginner Workflow](https://discuss.pixls.us/t/darktable-5-4-a-introductory-beginner-workflow-and-interactive-walkthrough/54755) (timestamp 7.0–7.2)*  
1. Attivare `exposure` e cliccare sull’icona del contagocce;  
2. Disegnare un rettangolo sull’area principale del soggetto (es. corpo della farfalla);  
3. Il modulo calcola automaticamente `exposure = +0.700 EV` (valore predefinito per compensare la mancanza di curve in-camera)[^processing];  
4. Verificare che il waveform non mostri clipping ai bordi sinistro (ombra) o destro (luce);  
5. Regolare manualmente a `+0.850 EV` se il soggetto appare ancora troppo scuro nel contesto del bordo bianco della color assessment mode[^discuss-pixls].

## Domande frequenti

### Problema: Il modulo `exposure` non reagisce al clic del contagocce in modalità `automatic`
La causa più comune è che il modulo è impostato su `mode = manual`. Per usare il contagocce automatico, è necessario impostare prima `mode = automatic`, quindi cliccare sull’icona rossa accanto a `spot exposure mapping` per attivare la modalità `input`. Se il modulo è già in `automatic`, assicurarsi che `area exposure mapping` sia abilitato e che il `clipping threshold` non sia impostato a zero[^dt40-new].

### Problema: Dopo aver applicato `exposure +2.0 EV`, l’immagine rimane scura e l’istogramma non si sposta
Questo indica che il modulo `exposure` sta operando in uno spazio colore errato. Verificare che il profilo colore di input sia `linear rec 2020 RGB` e che il modulo `filmic rgb` (o `sigmoid`) sia attivo e configurato correttamente: un `filmic rgb` disattivato o con `white relative exposure` troppo basso non visualizzerà l’aumento di esposizione. Il problema è frequente quando si lavora con preset personalizzati che disabilitano i moduli di tonemapping[^pipeline].

### Problema: La maschera disegnata non appare traslucida sul modulo `exposure`
La maschera potrebbe essere invisibile perché `mask opacity` è impostata a `0%`, oppure perché `opacity` del modulo è `0%`. Entrambi i controlli sono indipendenti: `mask opacity` regola la trasparenza della sovrapposizione grafica della maschera (utile per la composizione visiva), mentre `opacity` regola l’intensità dell’effetto esposizione stesso. Per visualizzare la maschera, impostare `mask opacity = 50%` e `opacity = 100%`[^masking-ep1].

## Risorse pratiche

### Esempio completo: workflow street photography in B/N
Per una foto RAW Olympus E-M5 scattata in condizioni di scarsa luce:
1. `exposure`: `+1.000 EV`, `clipping threshold = 0.005%`[^lowlight];
2. `color calibration` (istanza 1): `CAT16`, `illuminant = daylight`, `detect from surfaces`;
3. `color calibration` (istanza 2, rinominata “BW”): `gray = on`, `normalize channels = on`, `input R/G/B = 0.000`[^b&w-street];
4. `exposure` (istanza 2, “vignette”): `ellipse`, `invert mask`, `exposure = -0.55 EV`, `feathering radius = 150 px`.

### Scorciatoie da tastiera per l’esposizione
- `E`: attiva/disattiva rapidamente il modulo `exposure`;
- `Ctrl+E`: duplica l’istanza corrente;
- `Shift+E`: apre il `mask manager` collegato al modulo attivo;
- `Mouse wheel`: regola `exposure` con incrementi di `0.05 EV` (premendo `Shift` durante lo scroll: `0.01 EV`)[^dt38-new].

### Debugging comuni

| Problema | Causa probabile | Soluzione |
|----------|------------------|-----------|
| Immagine rimane troppo scura dopo `exposure +2.0 EV` | Profilo colore di output errato (es. `sRGB` invece di `AgX`) | Verificare `output color profile` in `tone curve` o `filmic rgb`[^pipeline] |
| Maschera non visibile pur essendo attiva | `mask opacity = 0%` o `opacity = 0%` nel modulo | Controllare i due slider indipendenti: `opacity` (effetto globale) e `mask opacity` (opacità della maschera stessa)[^masking-ep1] |
| `spot exposure mapping` non reagisce al clic | Il modulo non è in modalità `automatic` o `spot mode` non è impostato su `input` | Impostare `mode = automatic`, quindi cliccare sull’icona rossa accanto a `spot exposure mapping`[^dt40-new] |

## Fonti

[^manual-exposure]: *darktable User Manual -- Exposure module*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/exposure/) | Copia locale: `processed/darktable-usermanual-en/usermanual-48-en-module-reference-processing-modules-exposure.md`
[^manual-colorcal]: *darktable User Manual -- Color Calibration*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-calibration/) | Copia locale: `processed/darktable-usermanual-en/usermanual-48-en-module-reference-processing-modules-color-calibration.md`
[^manual-denoise]: *darktable User Manual -- Denoise (profiled)*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/denoise-profiled/) | Copia locale: `processed/darktable-usermanual-en/usermanual-48-en-module-reference-processing-modules-denoise-profiled.md`
[^firststeps]: *[darktable first steps ep01](https://www.youtube.com/watch?v=P4cL61ZHqFw)* -- A Dabble in Photography
[^pipeline]: *[The darktable pipeline for beginners](https://www.youtube.com/watch?v=1nPW6WPhhTo)* -- A Dabble in Photography
[^dt54]: *[darktable 5.4 NEW UPDATE](https://www.youtube.com/watch?v=yiTqUgoWg6Q)* -- A Dabble in Photography
[^lowlight]: *[Lowlight photos in darktable](https://www.youtube.com/watch?v=O7wXgmQZqiU)* -- A Dabble in Photography
[^nightsky]: *[darktable Night Sky Full Edit](https://www.youtube.com/watch?v=5P0Yj_vqy5w)* -- A Dabble in Photography
[^landscape]: *[Darktable landscape edit with AI](https://www.youtube.com/watch?v=OERXOFz9lEo)* -- A Dabble in Photography
[^agx-guide]: *[A guide to AgX in darktable](https://www.youtube.com/watch?v=iaZ2-QvOHyA)* -- A Dabble in Photography
[^dt40-new]: *[What is new in darktable 4.0?](https://www.youtube.com/watch?v=_EOGBmksHDw)* -- A Dabble in Photography
[^masking-ep1]: *[darktable masking Episode 1](https://www.youtube.com/watch?v=807sNff1TMk)* -- A Dabble in Photography
[^masking-ep2]: *[darktable masking episode 2](https://www.youtube.com/watch?v=P1W1tmk8HLk)* -- A Dabble in Photography
[^masking-ep3]: *[darktable masking Episode 3](https://www.youtube.com/watch?v=wUrhoiU1bTM)* -- A Dabble in Photography
[^b&w-street]: *[Full b&w edits in darktable for street photography](https://www.youtube.com/watch?v=f9szYMJ9wYo)* -- A Dabble in Photography
[^dt38-new]: *[darktable 3.8 What is new?](https://www.youtube.com/watch?v=5smugZ5pXN0)* -- A Dabble in Photography
[^processing]: *darktable User Manual — Processing Preferences*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/preferences-settings/processing/) | Copia locale: `processed/darktable-usermanual-en/usermanual-48-en-preferences-settings-processing.md`
[^discuss-pixls]: *[darktable 5.4 - A Introductory Beginner Workflow](https://discuss.pixls.us/t/darktable-5-4-a-introductory-beginner-workflow-and-interactive-walkthrough/54755)* -- discuss.pixls.us
