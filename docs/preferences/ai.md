# Preferenze: funzionalità AI e modelli

Il pannello **AI features preferences and models** è il centro di controllo per tutte le funzionalità di intelligenza artificiale in darktable. A differenza di Lightroom, dove le funzioni AI sono spesso integrate nascostamente nei singoli strumenti, darktable adotta un approccio modulare e trasparente: le funzionalità AI sono disattivate di default (opt-in) e richiedono una configurazione esplicita dei modelli e dell'hardware di accelerazione[^overview][^how-ai-works].

In darktable, l'AI è utilizzata per compiti specifici come mascheramento oggetti, riduzione rumore e upscaling, sfruttando un runtime locale basato su ONNX Runtime[^overview].

!!! info "Privacy e elaborazione locale"
    Tutte le funzionalità AI in darktable girano interamente in locale sulla tua macchina. Non viene inviato alcun dato al cloud, non c'è telemetria e non ci sono aggiornamenti automatici in background. Questo garantisce la massima privacy per i tuoi file RAW[^overview].

## Panoramica

Il sistema AI di darktable si basa su due concetti fondamentali: **Task** (compiti) e **Modelli**.

1.  **Task**: Sono gli "slot" funzionali richiesti dai moduli di darktable (es. *mask*, *denoise*, *rawdenoise*, *upscale*)[^overview].
2.  **Modelli**: Sono i file fisici (in formato `.dtmodel`) che contengono le reti neurali pre-addestrate per eseguire un determinato task[^how-ai-works].

Un singolo task può avere più modelli disponibili (ad esempio, diversi algoritmi di denoise), ma solo un modello può essere **attivo** per volta[^overview]. I moduli di darktable (come *Neural Restore* o le maschere disegnate) consumano semplicemente il risultato del modello attivo per quel task, permettendo di cambiare algoritmo senza dover riconfigurare l'intero flusso di lavoro[^overview].

## Flusso di lavoro di configurazione

Per utilizzare l'AI in darktable, è necessario completare tre passaggi fondamentali:

1.  **Attivazione**: Abilitare le funzionalità AI nel menu preferenze (master switch)[^neural-restore].
2.  **Selezione Hardware**: Scegliere il "Execution Provider" (il motore di calcolo: CPU, GPU, etc.)[^how-ai-works].
3.  **Gestione Modelli**: Scaricare e attivare i modelli specifici per i task che si intendono utilizzare[^neural-restore].

### Passo 1: Abilitare le AI features

Le funzionalità AI sono disattivate di default in una nuova installazione[^overview]. Per abilitarle:

1.  Vai in **Preferenze** > **AI** (o *Settings* > *AI*).
2.  Spunta l'opzione **Enable AI features**[^neural-restore].
3.  Riavvia darktable se richiesto dal sistema.

### Passo 2: Configurare l'accelerazione hardware (Execution Provider)

Il parametro **AI acceleration** (o *Execution provider*) determina come viene eseguito il calcolo: sulla CPU o sulla GPU[^how-ai-works].

!!! tip "Lascia su 'Auto' se sei insicuro"
    L'impostazione **auto** lascia che ONNX Runtime scelga il miglior provider disponibile, con la CPU come fallback finale. È la scelta raccomandata per la maggior parte degli utenti[^how-ai-works].

I provider disponibili dipendono dal sistema operativo e dall'hardware installato[^how-ai-works]:

| Provider | Descrizione | Note |
|----------|-------------|------|
| **auto** | Selezione automatica | Raccomandato. Fallback su CPU[^how-ai-works]. |
| **CPU** | Solo processore | Disponibile sempre. Lento per upscaling 4x[^how-ai-works]. |
| **NVIDIA CUDA** | GPU NVIDIA | Richiede libreria ONNX Runtime con CUDA e toolkit CUDA + cuDNN 9.x[^how-ai-works]. |
| **AMD MIGraphX** | GPU AMD (Linux) | Richiede ROCm 6.3+. **Attenzione**: la prima compilazione del modello può richiedere da **5 a 30 minuti**[^how-ai-works]. |
| **Intel OpenVINO** | GPU Intel (Linux/Windows) | Runtime incluso nel pacchetto. Basta il driver aggiornato[^how-ai-works]. |
| **Windows DirectML** | GPU DirectX 12 (Windows) | Buon fallback per GPU generiche su Windows[^how-ai-works]. |
| **Apple CoreML** | Apple Silicon / Mac Intel | Utilizza Neural Engine e GPU[^how-ai-works]. |

### Passo 3: Download e Attivazione dei Modelli

I modelli non sono inclusi nel binario di darktable e devono essere scaricati separatamente[^how-ai-works].

1.  Nella scheda **AI** delle preferenze, trovi l'elenco dei modelli disponibili[^how-ai-works].
2.  Usa il pulsante **Download default models** per ottenere il set standard dal repository ufficiale `darktable-ai`[^how-ai-works].
3.  Per ogni task (es. *mask*), assicurati che una riga abbia la casella **enabled** (attiva) spuntata[^neural-restore][^video].
    *   Puoi avere solo un modello attivo per task. Se ne attivi un secondo, il primo viene disattivato automaticamente[^overview].
4.  I modelli scaricabili sono pacchetti `.dtmodel`. È possibile installarne altri manualmente tramite il pulsante **install model**[^how-ai-works].

I modelli vengono salvati in:
*   Linux: `~/.local/share/darktable/models/`
*   macOS: `~/Library/Application Support/darktable/models/`
*   Windows: `%APPDATA%\darktable\models\`[^how-ai-works]

## Parametri principali

La schermata delle preferenze AI contiene i seguenti controlli chiave:

| Parametro | Funzione | Note |
|-----------|----------|------|
| **Enable AI features** | Interruttore master | Attiva/disattiva l'intero sistema AI. Off di default[^overview]. |
| **AI acceleration** (Execution provider) | Backend di calcolo | Scegli tra CPU, CUDA, DirectML, etc. Usa `auto` per default[^how-ai-works]. |
| **ONNX Runtime library** | Percorso libreria personalizzata | Opzionale. Permette di usare una build specifica di ONNX Runtime invece di quella in bundle[^how-ai-works]. |
| **Lista Modelli** | Gestione task e modelli | Tabella che mostra Nome, Task, Versione, Licenza, Stato (Downloaded/Enabled)[^how-ai-works]. |
| **Download default models** | Download automatico | Scarica il set raccomandato di modelli dal repository ufficiale[^how-ai-works]. |
| **Install model** | Installazione manuale | Permette di caricare file `.dtmodel` scaricati esternamente[^how-ai-works]. |

## Consigli

!!! warning "Attenzione ai tempi di compilazione (AMD)"
    Se usi **AMD MIGraphX** su Linux, sappi che la prima volta che esegui un modello, il sistema deve compilarlo per la tua specifica GPU. Questo processo può richiedere tra i **5 e i 30 minuti**. Non interrompere il processo; le esecuzioni successive saranno istantanee[^how-ai-works].

!!! tip "Gestione dello spazio su disco"
    I modelli AI occupano diverse centinaia di megabyte. Se usi un SSD piccolo per il sistema, verifica lo spazio disponibile nella cartella dei modelli prima di scaricare tutto il set[^how-ai-works].

!!! info "Disponibilità del pannello"
    Se stai usando una versione di darktable pacchettizzata da terze parti (es.某些 repository Linux non ufficiali), la scheda **AI** potrebbe mancare entirely se il supporto AI è stato disabilitato in fase di compilazione. In tal caso, usa una build ufficiale (AppImage, installer, dmg)[^overview].

## Risorse aggiuntive

Per approfondire le politiche di integrazione e ottenere nuovi modelli:

*   **AI Model Integration Policy**: Le regole che darktable segue per l'integrazione dell'AI (no generazione di contenuti, solo correzione tecnica)[^overview].
*   **Repository darktable-ai**: Fonte ufficiale per il download dei modelli `.dtmodel`[^how-ai-works].
*   **Documentazione ONNX Runtime**: Informazioni tecniche sul runtime utilizzato[^how-ai-works].

## Fonti

[^overview]: darktable user manual - overview (https://docs.darktable.org/usermanual/development/en/special-topics/ai/overview/)
[^how-ai-works]: darktable user manual - how AI features work (https://docs.darktable.org/usermanual/development/en/special-topics/ai/how-ai-works/)
[^neural-restore]: darktable user manual - neural restore (https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/shared/neural-restore/)
[^video]: [ENG] AI masks in darktable (video-tutorials) (https://www.youtube.com/watch?v=7yd5riDmUjk)
