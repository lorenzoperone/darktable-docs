# Troubleshooting FAQ: darktable

Il modulo **Troubleshooting FAQ** non esiste come componente attivo nella pipeline di elaborazione di darktable. Si tratta invece di una **sezione concettuale e operativa** — integrata nel manuale ufficiale, nei forum della comunità e nelle risorse didattiche — dedicata alla diagnosi e risoluzione sistematica dei problemi più comuni durante l’uso del software[^manual-48-troubleshooting]. Questa pagina di riferimento sintetizza le procedure verificate, i comandi terminali essenziali e le strategie diagnostiche raccomandate per utenti avanzati e migranti da Lightroom/Photoshop, con particolare attenzione a compatibilità hardware, flussi di lavoro scene-referred e gestione degli errori critici.

!!! tip "Troubleshooting ≠ modulo, ma workflow"
    In darktable non esiste un modulo chiamato *Troubleshooting*. Il termine indica un **processo strutturato** basato su test sequenziali, log di sistema e verifica delle dipendenze (gphoto2, OpenCL, lensfun). La sua applicazione è obbligatoria prima di segnalare bug o richiedere supporto[^manual-48-troubleshooting].

## Panoramica

La procedura di troubleshooting in darktable si articola in quattro livelli gerarchici:

1. **Rilevamento hardware** — verifica che la fotocamera sia riconosciuta dal sistema e da `gphoto2`  
2. **Abilità driver** — controllo che il driver supporti *capture choices* e *configuration*  
3. **Acquisizione remota** — test funzionale di scatto e download  
4. **Acquisizione tethered** — test avanzato con eventi in tempo reale (richiesto per il tethering completo)[^manual-48-troubleshooting]

Questo approccio è stato progettato per isolare rapidamente se il problema risiede:
- nel firmware della fotocamera,
- nel driver `libgphoto2`,
- nella configurazione di darktable (`~/.config/darktable/`),
- o nell’interfaccia grafica (OpenCL, GPU, DPI scaling).

Il troubleshooting non copre invece:
- errori di licenza o installazione di terze parti (es. LUT personali),
- corruzione di database SQLite (richiede backup manuale),
- problemi di performance legati a SSD lenti o RAM insufficiente (<16 GB consigliati per RAW 50MP)[^darktable-fr-faq].

## Flusso di lavoro consigliato

Il flusso standard per diagnosi hardware (es. tethering) segue questa sequenza rigorosa:

```bash
# 1. Verifica rilevamento base
env LANG=C gphoto2 --auto-detect

# 2. Verifica abilità driver (output deve contenere "capture choices: Image" e "configuration: yes")
env LANG=C gphoto2 --port usb: --abilities

# 3. Test acquisizione remota (scatto + download)
env LANG=C gphoto2 --port usb: --capture-image-and-download

# 4. Test tethered (richiede trigger manuale sulla fotocamera)
env LANG=C gphoto2 --port usb: --capture-tethered
```

!!! warning "Non saltare alcun passo"
    Ogni comando dipende dal successo del precedente. Se il passo 2 fallisce, i passi 3–4 sono destinati al fallimento indipendentemente dalle impostazioni di darktable[^manual-48-troubleshooting].

### Passo 1: Rilevamento fotocamera

Il comando `gphoto2 --auto-detect` restituisce una lista simile a:

```
Model                          Port
----------------------------------------------------------
Canon EOS 5D Mark IV           usb:001,012
Nikon D850                     usb:002,007
```

Se la fotocamera **non appare**, controllare:
- Che sia in modalità *PC Connection* (non MTP o PTP solo per trasferimento),
- Che non sia collegata tramite hub USB non alimentato,
- Che il kernel Linux abbia caricato il modulo `usbserial` (verificabile con `lsmod | grep usbserial`)[^manual-48-troubleshooting].

### Passo 2: Abilità driver

L’output di `--abilities` deve contenere esplicitamente:

```
capture choices: Image
configuration: yes
```

Se manca una delle due voci, darktable **non mostrerà mai il pulsante “Tethered shoot”**, anche se la fotocamera è rilevata[^manual-48-troubleshooting]. Questo è un limite del driver `gphoto2`, non di darktable.

### Passo 3 & 4: Acquisizione remota vs. tethered

| Tipo | Comando | Cosa verifica | Esito atteso |
|------|---------|----------------|--------------|
| **Remota** | `--capture-image-and-download` | Capacità di scatto + trasferimento file | Salva un file `.CR2`/`.NEF` nella cartella corrente |
| **Tethered** | `--capture-tethered` | Supporto agli *eventi in tempo reale* (trigger da fotocamera) | Mostra `"Waiting for events..."`, poi scarica l’immagine al pressione del pulsante di scatto |

!!! tip "Perché tethered fallisce anche se remote funziona?"
    Il tethering richiede che il driver supporti il protocollo *PTP Events*, non disponibile su molti modelli entry-level (es. Canon EOS Rebel serie, Nikon D3x00). È un vincolo hardware, non configurativo[^manual-48-troubleshooting].

## Parametri critici di sistema

I parametri di sistema che influenzano direttamente la stabilità di darktable sono gestiti fuori dalla GUI, tramite file di configurazione o variabili d’ambiente.

| Parametro | Posizione | Valore tipico | Descrizione |
|-----------|-----------|----------------|-------------|
| **OpenCL device** | `~/.config/darktable/darktablerc` → `[opencl]` → `enabled = TRUE` | `TRUE` / `FALSE` | Disabilitare se si verificano crash su GPU AMD o Intel HD Graphics 600+[^darktable-fr-faq-opencl] |
| **Lensfun database path** | `~/.config/darktable/darktablerc` → `[lens]` → `database = ...` | `/usr/share/lensfun/version_2` | Percorso della base dati per correzione obiettivi. Aggiornare con `lensfun-update-data` se mancano profili[^darktable-fr-faq-lensfun] |
| **Cache size** | `~/.config/darktable/darktablerc` → `[cache]` → `size = ...` | `2048` MB | Dimensione cache in MB. Valori >4096 MB possono causare OOM su sistemi con <32 GB RAM[^darktable-fr-faq] |
| **Thumbnail quality** | `~/.config/darktable/darktablerc` → `[ui]` → `thumbnail_quality = ...` | `90` | Qualità JPEG delle miniature (0–100). Valori <70 causano artefatti visibili nei preview[^darktable-fr-faq] |

## Problemi comuni e soluzioni

### ❌ “Tête de mort” (testa di morto) nella lighttable

Appare quando un file RAW viene spostato, rinominato o cancellato **fuori da darktable**, rompendo il link tra database e filesystem.

- **Causa**: Operazioni manuali su terminale o file manager  
- **Soluzione**:  
  1. Clic destro sull’immagine → *“Locate missing file…”*  
  2. Se il file è irreperibile: clic destro → *“Remove from collection”*  
  3. Per prevenire: usare sempre *“Move to folder…”* o *“Rename…”* dal menu contestuale di darktable[^darktable-fr-faq-dead-heads]

### ❌ “Clipping cromatico nei rossi saturi”

Si manifesta come perdita di dettaglio nei rossi brillanti (es. luci al tramonto, fiori) dopo AGX o Filmic RGB.

- **Causa**: Saturazione oltre i limiti del gamut di output  
- **Soluzione**:  
  - Attivare **Red attenuation** in AGX *prima* del tone mapping (valore tipico: `15–30%`)  
  - Usare **Recover purity** dopo il tone mapping (`20–40%`)  
  - Alternativa: inserire un modulo *Color calibration* prima di AGX con *Input R* ridotto a `-0.100`[^darktable-fr-faq-gamut]

### ❌ “Vignette non riflette l’immagine trattata”

Le miniature nella lighttable non aggiornano i cambiamenti applicati nel darkroom.

- **Causa**: Cache delle miniature non invalidata  
- **Soluzione**:  
  - Premere `Ctrl+R` per rigenerare la cache  
  - Oppure: `Menu → Preferences → Interface → Clear thumbnail cache`  
  - Per evitare: abilitare *“Update thumbnails after processing”* nelle preferenze[^darktable-fr-faq-thumbnails]

### ❌ “Errore OpenCL: clBuildProgram failed”

Comune su macOS con GPU Apple Silicon e su Linux con driver NVIDIA vecchi.

- **Causa**: Incompatibilità tra versione OpenCL e driver GPU  
- **Soluzione**:  
  - Disabilitare OpenCL: `darktable --disable-opencl`  
  - Oppure modificare `darktablerc`:  
    ```ini
    [opencl]
    enabled = FALSE
    ```
  - Su macOS: usare sempre la build `.dmg` ufficiale (non AppImage)[^darktable-fr-faq-opencl]

## Consigli avanzati per migranti LR/PS

- **Sincronizzazione cataloghi**: darktable non ha un “catalogo centrale” come Lightroom. Il database `library.db` è SQLite e **non va modificato manualmente**. Usare `darktable-cli --import` per importazioni batch[^manual-48-troubleshooting].  
- **Stili vs. Preset**: Gli stili di darktable (`.dtstyle`) sono equivalenti ai preset Lightroom, ma **non includono metadati** (parole chiave, valutazioni). Questi ultimi vanno gestiti separatamente via XMP[^darktable-fr-faq].  
- **Export RAW + XMP**: Per mantenere editabilità esterna, esportare sempre insieme:  
  - File RAW originale (integro),  
  - File `.xmp` sidecar generato automaticamente da darktable[^darktable-fr-faq-xmp].  
- **GPU acceleration**: Non è necessaria per editing base. Abilitarla solo per denoise avanzato (`denoiseprofile`), local contrast e `diffuse or sharpen`[^darktable-fr-faq-opencl].

!!! info "Come recuperare lo storico da un file JPEG esportato"
    Se hai un JPEG esportato da darktable *e* il relativo file RAW originale, puoi ripristinare l’intera cronologia di editing usando:  
    ```bash
    darktable-cli --import /path/to/raw.ARW --apply-style /path/to/style.dtstyle --export /path/to/output.tiff
    ```  
    Lo stile contiene tutti i parametri dell’history stack[^darktable-fr-faq-xmp].

## Risorse aggiuntive

- 📘 **Manuale ufficiale (4.8)** — Sezione *Tethering → Troubleshooting*:  
  [https://docs.darktable.org/usermanual/development/en/tethering/troubleshooting/](https://docs.darktable.org/usermanual/development/en/tethering/troubleshooting/)  
- 📺 **Video tutorial (A Dabble in Photography)** — Diagnosi tethering passo-passo:  
  [https://www.youtube.com/watch?v=DzdGL30lYjU&t=120](https://www.youtube.com/watch?v=DzdGL30lYjU&t=120)  
- 🌐 **Forum francese darktable.fr** — Archivio domande frequenti con risposte tecniche:  
  [https://darktable.fr/faq/](https://darktable.fr/faq/)  
- 🐞 **Segnalazione bug** — Istruzioni per log completi (obbligatorio per issue su GitHub):  
  ```bash
  darktable -d camctl 2>&1 >camctl.log
  env LANG=C gphoto2 --debug --debug-file gphoto2_debug.log --port usb: --capture-tethered
  ```

## Fonti

[^manual-48-troubleshooting]: darktable user manual - troubleshooting, [https://docs.darktable.org/usermanual/development/en/tethering/troubleshooting/](https://docs.darktable.org/usermanual/development/en/tethering/troubleshooting/)
[^darktable-fr-faq]: FAQs - darktable FR, [https://darktable.fr/faq/](https://darktable.fr/faq/)
[^darktable-fr-faq-opencl]: OpenCl e alcune risposte su schede grafiche, [https://forums.darktable.fr/showthread.php?tid=2292](https://forums.darktable.fr/showthread.php?tid=2292)
[^darktable-fr-faq-lensfun]: Aggiornamento della base di dati lensfun, [https://forums.darktable.fr/showthread.php?tid=4212](https://forums.darktable.fr/showthread.php?tid=4212)
[^darktable-fr-faq-dead-heads]: Têtes de mort et compagnie, [https://forums.darktable.fr/showthread.php?tid=2258](https://forums.darktable.fr/showthread.php?tid=2258)
[^darktable-fr-faq-gamut]: Correction d’un débordement de gamut, [https://forums.darktable.fr/showthread.php?tid=2128](https://forums.darktable.fr/showthread.php?tid=2128)
[^darktable-fr-faq-thumbnails]: Vignette ne reflète pas la photo traitée, [https://forums.darktable.fr/showthread.php?tid=2255](https://forums.darktable.fr/showthread.php?tid=2255)
[^darktable-fr-faq-xmp]: Récupérer le traitement (.xmp) dans une photo exportée, [https://forums.darktable.fr/showthread.php?tid=2532](https://forums.darktable.fr/showthread.php?tid=2532)
