# Shortcut da tastiera

## Panoramica

darktable 5.4+ offre un sistema di **acceleratori** (keyboard shortcuts) altamente flessibile e personalizzabile, progettato per supportare flussi di lavoro professionali e ad alta produttività. A differenza di Lightroom, dove le scorciatoie sono fisse o parzialmente modificabili, darktable permette di assegnare combinazioni chiave a *qualsiasi azione* dell’interfaccia — dai moduli di elaborazione alle funzioni globali, passando per maschere, snapshot, esportazione e persino controlli MIDI[^manual-48-shortcuts]. Il sistema è strutturato in tre livelli:  
- **Scorciatoie semplici** (simple shortcuts): combinazioni di tasti (es. `Ctrl+Shift+E`) senza movimento del mouse;  
- **Scorciatoie estese** (extended shortcuts): combinazioni che includono rotella del mouse o movimento del cursore (es. `Ctrl+X` + scroll per regolare un slider);  
- **Mapping visuale** (visual shortcut mapping): modalità interattiva per assegnare scorciatoie con un clic diretto sui widget UI[^manual-48-shortcuts].

Tutte le scorciatoie sono contestuali: una stessa combinazione può attivare azioni diverse tra *Lighttable* e *Darkroom*, o tra moduli diversi. Inoltre, darktable supporta **istanze multiple di moduli**, e le scorciatoie possono essere configurate per agire sull’istanza *focalizzata*, *espansa*, *abilitata* o *non mascherata*, secondo regole prioritarie definite in `preferences > miscellaneous > shortcuts with multiple instances`[^manual-48-miscellaneous].

!!! tip "Modalità Aiuto rapida"
    Premi `H` in qualsiasi vista per visualizzare l’elenco completo delle scorciatoie attive *in quel momento*. L’elenco è dinamico e cambia in base alla vista corrente, ai moduli aperti e allo stato dei widget.

## Flusso di lavoro

Il flusso ottimale per integrare le scorciatoie nel tuo workflow prevede tre fasi sequenziali:

1. **Fase 1 – Esplorazione e verifica**  
   Usa `H` per identificare le scorciatoie già disponibili nella vista corrente. Verifica anche la finestra `Preferences > Shortcuts`: qui puoi filtrare per vista (`lighttable`, `darkroom`, `global`) e per tipo di azione (`buttons`, `toggles`, `sliders`). Le scorciatoie predefinite coprono ~90% delle operazioni quotidiane[^video-shortcuts-7usDvgrjvb4].

2. **Fase 2 – Personalizzazione mirata**  
   Attiva la **modalità mapping visuale**: clicca sull’icona dedicata nella top panel o usa `Ctrl+Shift+T` (macOS: `Cmd+Shift+T`). Il cursore cambia forma:
   - ✅ **Icona tastiera + “+”**: widget aggiungibile al [Quick Access Panel](https://docs.darktable.org/usermanual/development/en/darkroom/organization/quick-access-panel/) (Ctrl+click);
   - ⚠️ **Icona tastiera senza segno**: widget mappabile ma non aggiungibile al Quick Access;
   - 🚫 **Cerchio rosso con barra**: area non mappabile (es. spazio vuoto, istogramma, aree non-widget).

3. **Fase 3 – Affinamento avanzato**  
   Per scorciatoie complesse (es. regolazione fine di un parametro con `Ctrl+scroll`, o controllo MIDI), usa la finestra completa `Shortcuts Mapping Screen`. Qui puoi definire:
   - `element`: quale parte del widget controllare (es. `value`, `button`, `preset`);
   - `effect`: tipo di azione (es. `increase`, `decrease`, `reset`, `activate`);
   - `speed`: velocità di variazione (da `0.01` a `10.0`, default `1.0`);
   - `instance`: regola di selezione per moduli multi-istanza (es. `prefer focused instance`)[^manual-48-shortcuts].

!!! warning "Attenzione al conflitto con i gesti del sistema"
    Su macOS e Linux con touchpad abilitato, i gesti multi-finger (es. pinch-to-zoom) possono interferire con le scorciatoie estese. Disattiva temporaneamente *“Disable touchpad while typing”* nelle impostazioni del sistema se noti comportamenti imprevisti durante lo scroll con `Ctrl`[^manual-48-shortcuts].

## Navigazione generale

| Shortcut | Azione | Dettagli tecnici | Fonte |
|----------|--------|------------------|-------|
| ++l++ | Passa alla Lighttable | Attiva la vista `lighttable`; carica la collezione corrente. Non richiede conferma. | [Manual](https://docs.darktable.org/usermanual/development/en/preferences-settings/shortcuts/) |
| ++d++ | Passa alla Darkroom | Attiva la vista `darkroom`; carica l’immagine selezionata in Lighttable. Se nessuna immagine è selezionata, apre l’ultima elaborata. | [Manual](https://docs.darktable.org/usermanual/development/en/preferences-settings/shortcuts/) |
| ++tab++ | Mostra/nascondi pannelli laterali | Toggla visibilità di *entrambi* i pannelli (sinistro e destro). Effetto immediato, senza animazione. | [Manual](https://docs.darktable.org/usermanual/development/en/preferences-settings/shortcuts/) |
| ++f11++ | Schermo intero | Attiva/disattiva la modalità fullscreen. In modalità fullscreen, la top panel e la bottom bar vengono nascoste. | [Manual](https://docs.darktable.org/usermanual/development/en/preferences-settings/shortcuts/) |
| ++x++ | Vista culling (confronto) | Attiva la vista affiancata (side-by-side) con due immagini. Richiede almeno due immagini selezionate in Lighttable. | [Manual](https://docs.darktable.org/usermanual/development/en/lighttable/culling/) |
| ++r++ | Scarta immagine (Reject) | Imposta `rating = -1` sull’immagine selezionata. Se più immagini sono selezionate, applica a tutte. | [Manual](https://docs.darktable.org/usermanual/development/en/lighttable/overview/) |
| ++1++ – ++5++ | Assegna stelle | Imposta `rating = 1` a `5`. `0` rimuove il rating. Valori validi: `-1` (reject), `0–5` (stelle). Default: `0`. | [Manual](https://docs.darktable.org/usermanual/development/en/lighttable/overview/) |
| ++f1++ – ++f5++ | Etichette colore | Assegna etichette colore: `F1`=rosso, `F2`=giallo, `F3`=verde, `F4`=blu, `F5`=viola. Ogni pressione *togglia* l’etichetta su tutte le immagini selezionate[^manual-48-overview]. | [Manual](https://docs.darktable.org/usermanual/development/en/lighttable/overview/) |
| ++0++ | Rimuove tutti i rating | Imposta `rating = 0` su tutte le immagini selezionate. Utile per ripulire metadati prima di un nuovo batch. | [Manual](https://docs.darktable.org/usermanual/development/en/lighttable/overview/) |
| ++ctrl+d++ | Duplica immagine(i) | Crea una copia RAW con storia vuota. La copia eredita solo i metadati EXIF/IPTC, non le modifiche. | [Manual](https://docs.darktable.org/usermanual/development/en/lighttable/overview/) |
| ++w++ | Zoom temporaneo massimo | Mentre il tasto è premuto, ingrandisce al 100% l’immagine nella vista Lighttable. Rilasciando torna alla scala precedente. | [Manual](https://docs.darktable.org/usermanual/development/en/lighttable/overview/) |
| ++ctrl+w++ | Zoom con focus | Come `W`, ma evidenzia le aree in fuoco con un overlay verde (richiede che `focus detection` sia abilitato in `preferences > lighttable > image preview`). | [Manual](https://docs.darktable.org/usermanual/development/en/lighttable/overview/) |

## Darkroom

| Shortcut | Azione | Dettagli tecnici | Fonte |
|----------|--------|------------------|-------|
| ++e++ | Regolazione rapida esposizione + rotella | Scorciatoia estesa: `E` + scroll della rotella regola `exposure` con step di `0.05 EV`. Range: `-4.0` a `+4.0 EV`. Default: `0.0`. | [Lowlight photos](https://www.youtube.com/watch?v=O7wXgmQZqiU)[^lowlight] |
| ++cmd+b++ / ++ctrl+b++ | Bordo bianco valutazione colore | Attiva la funzione *color assessment*: mostra un bordo bianco intorno all’immagine per valutare il bilanciamento del bianco. Funziona solo in `darkroom`. | [First steps](https://www.youtube.com/watch?v=P4cL61ZHqFw)[^firststeps] |
| ++ctrl+z++ | Annulla ultima modifica | Annulla l’ultima azione nell’history stack. Profondità massima: 100 azioni (configurabile in `preferences > darkroom > history stack size`). | [Manual](https://docs.darktable.org/usermanual/development/en/darkroom/history-stack/) |
| ++ctrl+y++ | Ripristina modifica annullata | Ripristina l’ultima azione annullata. Non è un semplice “redo”: è il complemento esatto di `Ctrl+Z`. | [Manual](https://docs.darktable.org/usermanual/development/en/darkroom/history-stack/) |
| ++ctrl+e++ | Esporta immagine | Apre la finestra `export selected`. Supporta formati: JPEG, PNG, TIFF, WEBP, AVIF, HEIF. Default: JPEG quality `95%`, sRGB. | [Manual](https://docs.darktable.org/usermanual/development/en/export/) |
| ++o++ | Indicatore sovraesposizione | Attiva l’overlay “blink” sulle zone con valori RGB > `0.999` (255/255). Si disattiva automaticamente al cambio modulo. | [Manual](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/) |
| ++shift+o++ | Indicatore sottoesposizione | Attiva l’overlay “blink” sulle zone con valori RGB < `0.001` (1/255). Complementare a `O`. | [Manual](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/) |
| ++ctrl+shift+a++ | Auto esposizione | Applica l’algoritmo automatico di bilanciamento esposizione. Basato su analisi dell’istogramma globale. Non modifica `white balance`. | [Manual](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/exposure/) |
| ++space++ | Avanza all’immagine successiva | Nella vista `darkroom`, passa alla prossima immagine nella collezione corrente. Se sei all’ultima, torna alla prima. | [Video](https://www.youtube.com/watch?v=7usDvgrjvb4)[^video-shortcuts-7usDvgrjvb4] |
| ++shift+space++ | Indietreggia all’immagine precedente | Come `space`, ma in direzione inversa. | [Video](https://www.youtube.com/watch?v=7usDvgrjvb4)[^video-shortcuts-7usDvgrjvb4] |
| ++g++ | Attiva/disattiva guide di composizione | Mostra/nasconde linee di griglia (terzi, diagonali, golden ratio). Configurabili in `preferences > darkroom > composition guides`. | [Video](https://www.youtube.com/watch?v=7usDvgrjvb4)[^video-shortcuts-7usDvgrjvb4] |
| ++ctrl+shift+l++ / ++ctrl+shift+r++ | Mostra/nascondi pannelli in vista affiancata | In vista side-by-side (`X`), mostra/nasconde il pannello sinistro (`L`) o destro (`R`). Utile per confronti puliti. | [dt 5.2](https://www.youtube.com/watch?v=YcLJMaDbfRA)[^dt52] |
| ++a++ + rotella | Zoom/pan in vista affiancata | In vista side-by-side, `A` + scroll zooma sincronamente entrambe le immagini. `A` + drag sposta entrambe. | [dt 5.2](https://www.youtube.com/watch?v=YcLJMaDbfRA)[^dt52] |

## Maschere

| Shortcut | Azione | Dettagli tecnici | Fonte |
|----------|--------|------------------|-------|
| ++m++ | Mostra/nascondi overlay maschera | Toggla la visualizzazione dell’overlay rosa (default) sulle aree mascherate. Non influisce sulla maschera reale, solo sulla sua rappresentazione. | [Manual](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/) |
| ++c++ | Mostra canale in scala di grigi | Visualizza la maschera come immagine in scala di grigi (0–255). Utile per verificare la precisione del tracciato. | [Manual](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/masks/parametric/) |
| ++a++ | Zoom senza modificare maschera (AI masks) | Abilita il pan/zoom *senza uscire dalla modalità di editing maschera*. Fondamentale per lavorare su dettagli piccoli. | [AI masks](https://www.youtube.com/watch?v=7yd5riDmUjk)[^aimasks] |
| ++shift+click++ | Rimuovi punto di controllo (AI masks) | Clicca su un punto di controllo (handle) di una maschera AI per eliminarlo. Funziona solo quando la maschera è attiva e selezionata. | [AI masks](https://www.youtube.com/watch?v=7yd5riDmUjk)[^aimasks] |
| ++shift+wheel++ | Regola feathering (AI masks) | `Shift` + scroll regola il parametro `feathering` della maschera attiva. Range: `0.0` (nessun blur) a `100.0` (massimo sfumatura). Default: `20.0`. | [AI masks](https://www.youtube.com/watch?v=7yd5riDmUjk)[^aimasks] |
| ++ctrl+click++ | Aggiungi punto di controllo (AI masks) | Clicca su un’area dell’immagine per aggiungere un nuovo punto di controllo alla maschera AI. | [Manual](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/masks/ai/) |
| ++alt+click++ | Inverti maschera | Inverte la maschera attiva (bianco ↔ nero). Equivalente a cliccare sul pulsante `invert` nel modulo maschera. | [Manual](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/masks/parametric/) |

## Snapshot e confronto (dt 5.2+)

| Shortcut | Azione | Dettagli tecnici | Fonte |
|----------|--------|------------------|-------|
| ++ctrl+shift+l++ / ++ctrl+shift+r++ | Mostra/nascondi pannelli in vista affiancata | Come sopra, ma in vista `X`: `Ctrl+Shift+L` mostra/nasconde il pannello *sinistro*, `Ctrl+Shift+R` quello *destro*. | [dt 5.2](https://www.youtube.com/watch?v=YcLJMaDbfRA)[^dt52] |
| ++a++ + rotella | Zoom/pan in vista affiancata | `A` + scroll zooma entrambe le immagini simultaneamente. `A` + drag sposta entrambe. Mantenendo `Ctrl`, lo zoom è più lento (`×0.1`); con `Shift`, più veloce (`×10`). | [dt 5.2](https://www.youtube.com/watch?v=YcLJMaDbfRA)[^dt52] |
| ++ctrl+shift++ + regolazione vignettatura | Ruota/allunga mantenendo il soggetto | In `vignetting`, `Ctrl+Shift` + scroll regola `rotation` (range: `-180°` a `+180°`, step `1°`). Con `Shift` invece regola `strength` (range: `0–100%`). | [Lowlight](https://www.youtube.com/watch?v=O7wXgmQZqiU)[^lowlight] |
| ++ctrl+1++ – ++ctrl+9++ | Salva snapshot numerato | Crea uno snapshot con nome automatico (`snapshot 1`, `snapshot 2`, ecc.). Massimo 9 snapshot per immagine. | [Manual](https://docs.darktable.org/usermanual/development/en/darkroom/snapshots/) |
| ++1++ – ++9++ | Carica snapshot numerato | Carica lo snapshot salvato con quel numero. Se non esiste, non fa nulla. | [Manual](https://docs.darktable.org/usermanual/development/en/darkroom/snapshots/) |
| ++ctrl+shift+s++ | Salva snapshot con nome personalizzato | Apre la finestra di dialogo per inserire un nome descrittivo (es. `"before filmic"`, `"final export"`). | [Manual](https://docs.darktable.org/usermanual/development/en/darkroom/snapshots/) |

## Parametri

I parametri delle scorciatoie non sono solo “combinazioni di tasti”, ma configurazioni complete che definiscono *come* e *quanto* un’azione viene eseguita. I valori fondamentali sono:

| Parametro | Descrizione | Range | Default | Nota |
|-----------|-------------|-------|---------|------|
| **Speed** | Velocità di variazione per slider e rotelle | `0.01` – `10.0` | `1.0` | Valori < `1.0` rallentano (es. `0.1` = 10× più lento); > `1.0` accelerano. Configurabile per ogni slider in modalità mapping visuale[^manual-48-shortcuts]. |
| **Instance selection** | Regola di priorità per moduli multi-istanza | `focused`, `expanded`, `enabled`, `unmasked`, `last` | `last instance` | Impostata in `preferences > miscellaneous > shortcuts with multiple instances`. Determina quale istanza di `exposure`, `color calibration`, ecc., riceve la scorciatoia[^manual-48-miscellaneous]. |
| **Effect** | Tipo di azione applicata | `activate`, `increase`, `decrease`, `reset`, `toggle` | dipende dal widget | Per un pulsante: `activate`; per uno slider: `increase`; per un toggle: `toggle`[^manual-48-shortcuts]. |
| **Element** | Parte del widget controllata | `value`, `button`, `presets`, `show`, `enable` | `value` (slider), `button` (pulsante) | Essenziale per moduli con più funzioni (es. `show` espande, `enable` attiva/disattiva)[^manual-48-shortcuts]. |

## Consigli

- **Non sovraccaricare le combinazioni Ctrl/Cmd**: darktable riserva `Ctrl+lettera` per azioni globali critiche (es. `Ctrl+E` = export, `Ctrl+Z` = undo). Evita di sovrascriverle con azioni secondarie. Preferisci `Alt+lettera` o `Ctrl+Alt+lettera` per funzioni personalizzate[^manual-48-shortcuts].

- **Usa i modifier per “modi contestuali”**: crea una scorciatoia `Alt+E` per attivare *solo* il modulo `exposure`, e `Alt+Shift+E` per attivarlo *e* focalizzarlo. Questo ti permette di costruire “macro” senza script[^video-shortcuts-7usDvgrjvb4].

- **MIDI è production-ready**: controller come Loupedeck+, Behringer X-Touch Mini o Arturia BeatStep sono pienamente supportati. Per il BeatStep, usa la stringa di configurazione `BeatStep:63:16` in `preferences > miscellaneous > order or exclude midi devices` per abilitare l’encoding relativo e 16 encoder[^manual-48-midi].

- **Resetta le scorciatoie con cautela**: `Restore > defaults` riporta *tutti* i tasti ai valori originali, cancellando le personalizzazioni. Usa invece `Restore > session start` per un rollback sicuro[^manual-48-shortcuts].

- **Le scorciatoie non funzionano nei popup**: finestre come `export`, `preferences`, `history stack` bloccano l’input da tastiera. Chiudi i popup prima di usare scorciatoie globali[^manual-48-shortcuts].

!!! info "Scorciatoie Lua: automazione avanzata"
    Puoi creare scorciatoie che eseguono script Lua. Esempio: una scorciatoia che aumenta il rating di tutte le immagini selezionate di +1, con protezione da overflow (max 5 stelle):
    ```lua
    darktable.register_event("increase rating","shortcut",
      function(event,shortcut)
        local images = darktable.gui.action_images
        for _,v in pairs(images) do
          if v.rating < 5 then v.rating = v.rating + 1 end
        end
      end,"Increase rating (max 5)")
    ```
    Configurabile in `Preferences > Shortcuts > Lua`[^manual-48-lua].

## Risorse

- **[Guida ufficiale darktable 5.4 — Keyboard Shortcuts](https://docs.darktable.org/usermanual/development/en/overview/user-interface/keyboard-shortcuts/)**  
  Documentazione completa, aggiornata alla versione corrente, con elenchi per vista e categoria.

- **[Video tutorial: “Shortcuts in darktable” (A Dabble in Photography)](https://www.youtube.com/watch?v=7usDvgrjvb4)**  
  Guida pratica passo-passo per la creazione, verifica e ottimizzazione delle scorciatoie, con focus su workflow reali.

- **[darktable.fr — Sezione “Tutoriels”](https://darktable.fr/tags/tutoriel/)**  
  Raccolta di tutorial in francese, inclusi approfondimenti su scorciatoie per street photography, B/N e correzione colore.

- **[darktable-cmstest](https://docs.darktable.org/usermanual/development/en/special-topics/program-invocation/darktable-cmstest/)**  
  Strumento CLI per diagnosticare problemi di input da tastiera/MIDI (avvia con `-d input` per log dettagliati)[^manual-48-midi].

## Fonti

[^manual-48-shortcuts]: *[darktable user manual - keyboard shortcuts](https://docs.darktable.org/usermanual/development/en/overview/user-interface/keyboard-shortcuts/)* — Official documentation, verified 2026-04-10.
[^manual-48-miscellaneous]: *[darktable user manual - miscellaneous](https://docs.darktable.org/usermanual/development/en/preferences-settings/miscellaneous/)* — Official documentation, verified 2026-04-10.
[^manual-48-midi]: *[darktable user manual - midi device support](https://docs.darktable.org/usermanual/development/en/special-topics/midi-device-support/)* — Official documentation, verified 2026-04-10.
[^manual-48-lua]: *[darktable user manual - adding a simple shortcut](https://docs.darktable.org/usermanual/development/en/lua/simple-shortcut/)* — Official documentation, verified 2026-04-10.
[^manual-48-overview]: *[darktable user manual - lighttable overview](https://docs.darktable.org/usermanual/development/en/lighttable/overview/)* — Official documentation, verified 2026-04-10.
[^video-shortcuts-7usDvgrjvb4]: *[ENG] Shortcuts in darktable (A Dabble in Photography, 2026)* — Video tutorial, verified 2026-04-12.
[^firststeps]: *[darktable first steps ep01](https://www.youtube.com/watch?v=P4cL61ZHqFw)* — A Dabble in Photography.
[^lowlight]: *[Lowlight photos](https://www.youtube.com/watch?v=O7wXgmQZqiU)* — A Dabble in Photography.
[^aimasks]: *[AI masks in darktable](https://www.youtube.com/watch?v=7yd5riDmUjk)* — A Dabble in Photography.
[^dt52]: *[darktable 5.2 Release](https://www.youtube.com/watch?v=YcLJMaDbfRA)* — A Dabble in Photography.
