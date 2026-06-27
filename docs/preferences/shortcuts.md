# Preferenze: scorciatoie da tastiera

Il pannello **Keyboard Shortcuts Preferences** (accessibile tramite *preferences > shortcuts*) è il centro di controllo per personalizzare l'interazione con darktable. Permette di mappare tasti, movimenti del mouse, dispositivi MIDI e controller di gioco alle funzioni dell'interfaccia utente, sostituendo o integrando l'uso del puntatore.[^shortcuts-manual]

A differenza di molti altri software, darktable distingue tra **azioni discrete** (es. premere un pulsante) e **azioni direzionali** (es. muovere uno slider), permettendo un sistema di mapping estremamente flessibile e potente.[^shortcuts-manual]

!!! tip "Visual Shortcut Mapping"
    Il metodo consigliato per assegnare le scorciatoie è la **Visual Shortcut Mapping**. Clicca sull'icona dedicata nel pannello superiore, passa il mouse sopra l'elemento che vuoi controllare e premi il tasto desiderato. È molto più veloce della ricerca nell'elenco delle azioni.[^shortcuts-manual]

## Panoramica

Il sistema di scorciatoie di darktable gestisce due tipi principali di input:

1.  **Discrete Shortcuts**: Composti da sole pressioni di tasti e clic del mouse. Sono utilizzati per azioni singole come attivare un modulo, resettare uno slider o cambiare vista.[^shortcuts-manual]
2.  **Directional Shortcuts**: Richiedono una direzione (e spesso una magnitudo). Incorporano movimenti del mouse (pan, scroll) o di joystick. Sono necessari per regolare valori, scorrere liste o controllare slider.[^shortcuts-manual]

Il sistema supporta anche dispositivi esterni come controller MIDI (es. Behringer, Loupedeck) e gamepad, permettendo di mappare manopole e fader direttamente ai parametri di sviluppo.[^shortcuts-manual][^midi-support]

## Flusso di lavoro consigliato

Per configurare le tue scorciatoie in modo efficiente, segui questo approccio basato sulla modalità visuale:

### Passo 1: Attiva la Visual Shortcut Mapping
Clicca sull'icona di **visual mapping** nel pannello superiore. Il cursore del mouse cambierà forma per indicare se l'elemento sotto il mouse è mappabile.[^shortcuts-manual]

### Passo 2: Assegna azioni discrete (Pulsanti, Moduli)
Passa il mouse sopra un pulsante o l'intestazione di un modulo.
- Premi una combinazione di tasti (es. `e`, `Ctrl+e`).
- L'azione predefinita per quel widget (es. attivare/disattivare) verrà assegnata alla scorciatoia.[^shortcuts-manual]

### Passo 3: Assegna azioni direzionali (Slider)
Passa il mouse sopra uno slider.
- Premi e tieni premuto un tasto (es. `e`).
- Muovi il mouse orizzontalmente, verticalmente o usa la rotella del mouse per definire il movimento associato a quella scorciatoia.[^shortcuts-manual]

!!! info "Modificare la velocità dello slider"
    Quando sei in modalità di mapping visuale, puoi scorrere con la rotella del mouse sopra uno slider (senza premere tasti) per aumentare o diminuire la velocità di risposta di quello slider specifico quando controllato via scorciatoia.[^shortcuts-manual]

### Passo 4: Gestione conflitti e visualizzazione
Se tenti di assegnare una scorciatoia già in uso, darktable ti avviserà del conflitto e chiederà se sostituire l'assegnazione esistente. Per vedere o modificare tutte le scorciatoie di uno specifico widget, clicca con il tasto sinistro su di esso mentre sei in modalità mapping per aprire la schermata dettagliata.[^shortcuts-manual]

## Parametri e Anatomia delle Scorciatoie

Comprendere la struttura delle scorciatoie è fondamentale per sfruttare al massimo le capacità di personalizzazione.

### Anatomia di una scorciatoia
Una scorciatoia in darktable può essere composta da una sequenza complessa di input:

| Componente | Descrizione | Limite Massimo |
|------------|-------------|----------------|
| **Pressioni tasto** | Ripetizioni dello stesso tasto (es. `e`, `e double-press`, `e triple-press`) | 3 ripetizioni[^shortcuts-manual] |
| **Click mouse** | Click di tasti diversi (sinistro, centrale, destro) | Fino a 3 click di tasti diversi[^shortcuts-manual] |
| **Ripetizione click** | Ripetizione dell'ultimo click dell'input | Fino a 2 ripetizioni aggiuntive (triple-click del tasto mouse) |
| **Totale** | Somma di tasti e click | **8 input** massimi (es. `e double-press + left click + middle click + right triple-click`)[^shortcuts-manual] |

!!! tip "Long Press"
    L'ultima pressione di un tasto o click in una sequenza può essere una **long press** (tenuto premuto più a lungo del doppio-click ma meno del doppio del doppio-click). Questo crea una scorciatoia distinta che viene attivata al rilascio. Nota: le scorciatoie che finiscono con long press non possono essere usate per azioni direzionali.[^shortcuts-manual]

### Movimenti per azioni direzionali
Quando definisci una scorciatoia per uno slider o una lista, puoi specificare il tipo di movimento:[^shortcuts-manual]

- **Mouse scroll wheel**: Rotazione della rotella.
- **Mouse movement**: Movimento orizzontale, verticale o diagonale del cursore.
- **Knob/joystick**: Rotazione o movimento su controller esterni (MIDI/Gamepad).

### Modificatori (Modifiers)
I modificatori standard sono `shift`, `ctrl` e `alt` (su macOS `cmd` e `option`). È possibile assegnare tasti personalizzati di dispositivi esterni per agire come modificatori globali tramite l'azione "global/modifier".[^shortcuts-manual]

## Impostazioni avanzate

### Shortcut Mapping Screen
Accessibile cliccando con il tasto destro sul pulsante di visual mapping o tramite *Preferences > shortcuts*, questa schermata offre il controllo completo:[^shortcuts-manual]

- **Pannello superiore**: Elenco delle azioni/widget disponibili. È ricercabile.
- **Pannello inferiore**: Scorciatoie attualmente assegnate.
- **Fallbacks**: Opzione per attivare i "fallback". Se abilitato, ad esempio, tenendo premuto `Ctrl` mentre si usa un encoder MIDI, la velocità di modifica viene ridotta di un fattore 10, mentre `Shift` la aumenta.[^midi-support]

### Supporto MIDI e Dispositivi Esterni
darktable supporta nativamente dispositivi MIDI. Per configurarli correttamente:[^midi-support]

1.  Collega il dispositivo e assicurati che darktable lo riconosca (apparirà un messaggio "not assigned" quando premi un tasto).
2.  Usa la **Visual Shortcut Mapping**: entra in modalità mapping, passa sopra un controllo darktable e muovi una manopola o premi un tasto sul dispositivo MIDI.
3.  Configura i "global/modifier" se vuoi usare pulsanti fisici come tasti `Shift`/`Ctrl` del dispositivo.

!!! warning "Ordine dei dispositivi MIDI"
    Se hai più dispositivi MIDI, l'ordine di caricamento può cambiare tra i riavii. È consigliabile fissare l'ordine e gli ID dei dispositivi nel parametro `preferences > miscellaneous > interface > order or exclude midi devices` per evitare configurazioni errate.[^midi-support]

## Consigli

- **Aiuto contestuale**: In qualsiasi vista, premi il tasto `H` per vedere un elenco di tutte le scorciatoie applicabili a quella vista specifica.[^shortcuts-overview]
- **Trigger multipli**: Puoi attivare più controlli contemporaneamente. Ad esempio, se assegni `e + scroll` a uno slider e `f + scroll` a un altro, tenendo premuti sia `e` che `f` e muovendo la rotella, muoverai entrambi gli slider insieme.[^shortcuts-manual]
- **Scorciatoie specifiche per vista**: Una stessa scorciatoia può eseguire azioni diverse nella vista *Lighttable* rispetto alla vista *Darkroom*. Non è necessario che siano univoche globalmente, ma solo all'interno della stessa vista.[^shortcuts-manual]
- **Scripting Lua**: Per esigenze molto specifiche, è possibile registrare nuove scorciatoie tramite script Lua che compaiono nella sezione `lua` delle preferenze di scorciatoie.[^lua-shortcut]

## Risorse

Per approfondire le funzionalità avanzate e la risoluzione dei problemi MIDI, consulta la documentazione ufficiale:

- [Manuale darktable: Keyboard shortcuts](https://docs.darktable.org/usermanual/development/en/overview/user-interface/keyboard-shortcuts/)
- [Manuale darktable: Shortcuts (Preferences)](https://docs.darktable.org/usermanual/development/en/preferences-settings/shortcuts/)
- [Manuale darktable: MIDI device support](https://docs.darktable.org/usermanual/development/en/special-topics/midi-device-support/)
- [Manuale darktable: Adding a simple shortcut (Lua)](https://docs.darktable.org/usermanual/development/en/lua/simple-shortcut/)

## Fonti

[^shortcuts-overview]: darktable user manual - keyboard shortcuts. URL: https://docs.darktable.org/usermanual/development/en/overview/user-interface/keyboard-shortcuts/
[^shortcuts-manual]: darktable user manual - shortcuts. URL: https://docs.darktable.org/usermanual/development/en/preferences-settings/shortcuts/
[^midi-support]: darktable user manual - midi device support. URL: https://docs.darktable.org/usermanual/development/en/special-topics/midi-device-support/
[^lua-shortcut]: darktable user manual - adding a simple shortcut. URL: https://docs.darktable.org/usermanual/development/en/lua/simple-shortcut/
