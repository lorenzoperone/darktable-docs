# Preferenze

Le **preferenze** di darktable si aprono dall'icona a ingranaggio in alto a destra. Sono molte e quasi tutte hanno default sensati: questa sezione si concentra sulle **poche che contano davvero** per la qualità, le prestazioni e il flusso di lavoro — il resto puoi lasciarlo com'è finché non hai un motivo preciso per cambiarlo.

!!! tip "Le 4 cose da controllare appena installato"
    1. **[Elaborazione → OpenCL](processing.md)**: attiva la GPU se disponibile — è il singolo fattore che più incide sulla reattività in darkroom.
    2. **[Generali/Importazione](general-import.md)**: assicurati che il *workflow* sia **scene-referred** (auto-apply), così ogni nuova foto parte con la pipeline moderna.
    3. **[Funzionalità AI](ai.md)**: se vuoi *neural restore* o le maschere AI, qui abiliti il master switch e scarichi i modelli.
    4. **[Scorciatoie](shortcuts.md)**: opzionale, ma personalizzarle ripaga in velocità.

## Le pagine di questa sezione

- **[Elaborazione e OpenCL/GPU](processing.md)** — accelerazione GPU, qualità di rendering, default del pixelpipe e gestione della memoria.
- **[Funzionalità AI e modelli](ai.md)** — abilitare le AI features, scegliere l'acceleratore (es. Apple CoreML), gestire i modelli ONNX usati da *neural restore* e dalle maschere AI.
- **[Generali e importazione](general-import.md)** — lingua e interfaccia, e i default applicati a ogni importazione (incluso il *workflow* scene-referred).
- **[Scorciatoie da tastiera](shortcuts.md)** — personalizzare e salvare i propri set di scorciatoie.

!!! note "Dove vivono le impostazioni"
    Le preferenze sono salvate in `darktablerc` nella cartella di configurazione di darktable (su macOS `~/.config/darktable/`), separata dalla libreria e dai file collaterali `.xmp` delle foto. Fare un backup di questa cartella mette al sicuro preferenze, scorciatoie e preset.
