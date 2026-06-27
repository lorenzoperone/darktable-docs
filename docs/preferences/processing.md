# Preferenze: elaborazione e OpenCL/GPU

La configurazione delle preferenze di elaborazione e dell'accelerazione hardware in darktable è fondamentale per garantire un flusso di lavoro fluido e sfruttare appieno la potenza del proprio sistema. Questa sezione copre la gestione della pipeline (scene-referred vs display-referred), l'allocazione delle risorse (CPU/RAM), l'accelerazione OpenCL per i moduli classici e l'accelerazione GPU dedicata per le funzionalità di Intelligenza Artificiale (AI).[^mem-perf][^pixelpipe]

!!! info "Dove trovare queste impostazioni"
    Tutte le impostazioni descritte si trovano nel menu principale sotto **Preferences** (Preferenze), principalmente nelle sezioni **Processing** (Elaborazione) e **AI**.

## Panoramica

Le preferenze di elaborazione in darktable controllano tre strati distinti di performance e logica:

1.  **Logica della Pipeline**: Definisce se l'immagine viene elaborata mantenendo i dati lineari (scene-referred) o compressi (display-referred). Questo controlla l'ordine dei moduli e le impostazioni predefinite.[^pixelpipe]
2.  **Gestione Risorse (CPU/Memoria)**: Decide quanta RAM e quanta memoria della GPU sono allocate a darktable. Un'allocazione insufficiente costringe il software a usare il "tiling" (elaborazione a tile), che è più lento.[^mem-perf]
3.  **Accelerazione Hardware**:
    *   **OpenCL**: Accelerazione generale per i moduli di elaborazione standard (es. denoise, diffuse, sharpen).[^activate-opencl]
    *   **AI (ONNX Runtime)**: Accelerazione specifica per moduli neurali come *Neural Restore* (denoise, upscale), richiedente librerie aggiuntive.[^gpu-accel]

## Flusso di lavoro consigliato

Per configurare correttamente darktable, segui questo ordine logico:

```
1. Imposta il flusso di lavoro (Scene-referred)
   |
2. Configura le risorse di sistema (RAM/GPU)
   |
3. Attiva e verifica OpenCL
   |
4. (Opzionale) Configura l'accelerazione AI
```

### Passo 1: Impostare il flusso predefinito

In **Preferences > processing > auto-apply pixel workflow defaults**, assicurati di selezionare **scene-referred** (o scene-referred con AGX a seconda della versione). Questo è il metodo raccomandato e predefinito dalle versioni recenti, che garantisce un'elaborazione fisicamente corretta e riduce gli artefatti.[^pixelpipe]

### Passo 2: Configurare le risorse (CPU / Memory)

Vai in **Preferences > processing > CPU / memory**. Qui trovi il menu a tendina **darktable resources**. Le opzioni controllano quattro parametri interni definiti nel file `darktablerc` come `resource_level=a b c d`:[^mem-perf]

| Livello Risorse | Descrizione | Impatto su Sistema (es. 16GB RAM) |
|-----------------|-------------|------------------------------------|
| **default** | Bilanciato. | Usa ~8GB RAM di sistema e ~3.5GB VRAM su GPU da 6GB.[^mem-perf] |
| **large** | Per workstation potenti. | Alloca più memoria, riducendo il tiling. |
| **small** | Per sistemi con risorse limitate. | Forza il tiling per risparmiare RAM. |

!!! tip "Tuning manuale (Avanzato)"
    Puoi modificare manualmente i parametri nel file di configurazione `darktablerc`. Ad esempio, aumentando l'ultimo valore (frazione memoria GPU) puoi allocare più VRAM, ma attenzione al crash se superi i limiti fisici. Il sistema include automaticamente un headroom di 600MB per evitare overflow.[^mem-perf]

### Passo 3: Attivare OpenCL

In **Preferences > processing > OpenCL**, assicurati che l'opzione **activate OpenCL** sia spuntata. darktable cercherà automaticamente la libreria `libOpenCL.so` (o equivalente Windows) e una GPU con almeno 1GB di memoria.[^activate-opencl]

Se l'opzione è grigia, significa che l'inizializzazione è fallita (vedi sezione Risoluzione problemi).

### Passo 4: Scegliere il profilo di scheduling

Sempre in **Preferences > processing > OpenCL > OpenCL scheduling profile**, seleziona come distribuire il carico tra CPU e GPU:[^scheduling-profile]

| Profilo | Quando usarlo | Comportamento |
|---------|---------------|---------------|
| **default** | CPU veloce + GPU discreta moderata. | GPU per la vista centrale, CPU per anteprime/navigazione. |
| **very fast GPU** | GPU molto potente (es. RTX serie 40, Radeon RX 7xxx). | GPU gestisce tutto sequenzialmente (vista + anteprime). |
| **multiple GPUs** | Sistema con più GPU simili. | Distribuisce il carico su tutte le GPU disponibili, escludendo la CPU. |

## Parametri principali

### Preferenze di Elaborazione (Processing)

| Parametro | Opzioni | Default | Descrizione |
|-----------|---------|---------|-------------|
| **auto-apply pixel workflow defaults** | scene-referred, display-referred | scene-referred | Definisce l'ordine dei moduli e l'attivazione automatica di Exposure/Filmic/AGX.[^pixelpipe] |
| **darktable resources** | default, large, small, etc. | default | Controlla la memoria massima per modulo, buffer tiling, cache thumbnail e memoria GPU.[^mem-perf] |

### Preferenze AI (AI Acceleration)

Per utilizzare moduli come *Neural Restore*, devi puntare darktable a una libreria **ONNX Runtime** compatibile con la tua GPU. Questo non è OpenCL, ma un backend separato.[^gpu-accel]

| Parametro | Valori Tipici | Descrizione |
|-----------|---------------|-------------|
| **ONNX Runtime library** | Percorso file (es. `onnxruntime.dll`) | Il percorso della libreria scaricata. Usa il pulsante **detect** per trovarla automaticamente.[^gpu-accel] |
| **AI acceleration** | auto, CUDA, DirectML, CoreML, ROCm, OpenVINO | Seleziona il provider di esecuzione (Execution Provider) basato sulla tua GPU (NVIDIA, AMD, Intel).[^gpu-accel] |

## Risoluzione problemi e Tuning Avanzato

### Tiling e Performance

Se la memoria (RAM o VRAM) insufficiente, darktable usa il **tiling**: l'immagine viene divisa in parti piccole, elaborate e poi ricomposte.[^mem-perf]

*   **Vantaggio**: Permette di elaborare foto grandi anche con poca RAM.
*   **Svantaggio**: È significativamente più lento (fino a 10 volte per alcuni moduli) e non supportato da tutti gli algoritmi.[^mem-perf]

Se noti elaborazioni lente durante l'esportazione ma fluide nell'interfaccia, è probabile che il tiling si attivi solo a piena risoluzione. Aumenta il livello di risorse a "large" se possibile.

### Debug OpenCL

Se OpenCL non funziona o darktable crasha:

1.  Avvia darktable da terminale con: `darktable -d opencl -d perf`[^activate-opencl][^problems]
2.  Cerca errori come `[opencl_init] FINALLY ...` o messaggi di contesto non creato.
3.  Se il driver è incompatibile o instabile, avvia con `darktable --disable-opencl`. La CPU è altamente ottimizzata e funzionerà comunque correttamente.[^problems][^still-doesnt-work]

!!! warning "Problemi comuni"
    *   **Driver Mismatch**: Assicurati che il modulo kernel del driver corrisponda alla versione di `libOpenCL.so`. Riavvia dopo un aggiornamento driver.[^problems]
    *   **Più driver OpenCL**: Avere installati contemporaneamente driver Intel, AMD e NVIDIA (es. su Windows con OpenCL Compatibility Pack) può causare conflitti. Disabilita quelli non necessari.[^problems]

### Tuning Avanzato (darktablerc)

Per utenti esperti, è possibile modificare il comportamento OpenCL per dispositivo nel file `darktablerc`. La chiave ha il formato `cldevice_VERSION_NOME=a b c d e f g`:[^mem-perf]

| Parametro (a-g) | Default | Funzione |
|-----------------|---------|----------|
| **micro nap** (a) | 250 | Pausa in microsecondi per permettere alla GPU di aggiornare lo schermo. Aumenta se l'interfaccia scatta. A 0 se la GPU non gestisce il display.[^mem-perf] |
| **pinned memory** (b) | 0 | Se 1, forza trasferimenti memoria "pinned" (più veloci su alcune GPU vecchie, raramente utile oggi).[^mem-perf] |
| **asynchronous mode** (d) | 0 | Se 1, esegue la pipeline in modo asincrono per minor latenza. Se hai artefatti o crash, lascialo a 0.[^mem-perf] |
| **advantage hint** (f) | 0.000 | Fattore di preferenza GPU vs CPU. Se la GPU è molto lenta rispetto alla CPU, alza questo valore per forzare l'uso della CPU.[^mem-perf] |

## Risorse aggiuntive

*   [darktable User Manual — GPU acceleration (AI)](https://docs.darktable.org/usermanual/development/en/special-topics/ai/gpu-acceleration/)
*   [darktable User Manual — Activating OpenCL](https://docs.darktable.org/usermanual/development/en/special-topics/opencl/activate-opencl/)
*   [darktable User Manual — Memory & Performance Tuning](https://docs.darktable.org/usermanual/development/en/special-topics/mem-performance/)
*   [darktable User Manual — The Pixelpipe & Module Order](https://docs.darktable.org/usermanual/development/en/darkroom/pixelpipe/the-pixelpipe-and-module-order/)
*   [darktable User Manual — Scheduling Profile](https://docs.darktable.org/usermanual/development/en/special-topics/opencl/scheduling-profile/)

## Fonti

[^mem-perf]: [darktable user manual - memory & performance tuning](https://docs.darktable.org/usermanual/development/en/special-topics/mem-performance/)
[^pixelpipe]: [darktable user manual - the pixelpipe & module order](https://docs.darktable.org/usermanual/development/en/darkroom/pixelpipe/the-pixelpipe-and-module-order/)
[^activate-opencl]: [darktable user manual - activating OpenCL in darktable](https://docs.darktable.org/usermanual/development/en/special-topics/opencl/activate-opencl/)
[^gpu-accel]: [darktable user manual - GPU acceleration](https://docs.darktable.org/usermanual/development/en/special-topics/ai/gpu-acceleration/)
[^scheduling-profile]: [darktable user manual - scheduling profile](https://docs.darktable.org/usermanual/development/en/special-topics/opencl/scheduling-profile/)
[^problems]: [darktable user manual - possible problems & solutions](https://docs.darktable.org/usermanual/development/en/special-topics/opencl/problems-solutions/)
[^still-doesnt-work]: [darktable user manual - OpenCL still does not run for me](https://docs.darktable.org/usermanual/development/en/special-topics/opencl/still-doesnt-work/)
