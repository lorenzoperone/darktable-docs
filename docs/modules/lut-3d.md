# LUT 3D

Il modulo **LUT 3D** (Look-Up Table) permette di trasformare i valori RGB di un'immagine utilizzando una tabella tridimensionale pre-calcolata. Questo strumento è comunemente utilizzato per la simulazione di pellicole cinematografiche (film look) e per il color grading creativo.[^lut3d-manual]

!!! info "Formati file supportati"
    Il modulo accetta file `.cube`, `.3dl`, `.png` (formato haldclut) e `.gmz` (richiede l'installazione di GMIC). I file `.gmz` sono compressi e possono contenere intere librerie di LUT; a differenza degli altri formati, i dati delle LUT `.gmz` possono essere salvati nel database e nei file XMP.[^lut3d-manual]

## Panoramica

Una LUT 3D agisce come una mappatura diretta: per ogni tripletta di valori RGB in ingresso, la tabella restituisce una nuova tripletta RGB in uscita. Questo permette di applicare look complessi e non lineari in modo efficiente.

È fondamentale notare che il modulo **taglia (clip) tutti i valori al di fuori del range [0,1]**. Pertanto, se l'immagine contiene dati fuori gamma (ad esempio luci bruciate o ombre bloccate in uno spazio lineare), questi verranno persi o distorti. È spesso necessario ridurre il range dinamico dell'input prima di applicare la LUT.[^lut3d-manual]

!!! warning "Gestione dei file e portabilità"
    I dati non compressi delle LUT (formati `.cube`, `.3dl`, `.png`) **non** vengono salvati nel database di darktable o nel file XMP associato all'immagine. Viene salvato solo il percorso del file. Se si condivide un'immagine elaborata con altri (tramite XMP), i destinatari devono possedere lo stesso file LUT nella stessa cartella "LUT 3D root folder" per visualizzare il risultato corretto. È fondamentale eseguire regolarmente il backup della cartella delle LUT.[^lut3d-manual]

## Flusso di lavoro consigliato

Il posizionamento del modulo LUT 3D nella pipeline dipende dall'uso specifico che se ne intende fare:

### 1. Color Grading e Film Look (Standard)

In questo scenario, la LUT viene applicata per dare un carattere artistico all'immagine.

1.  Posizionare il modulo dopo il modulo **filmic rgb** (o AGX nelle versioni più recenti).
2.  Applicare la LUT a un'immagine già corretta e neutra (senza modifiche stilistiche pesanti precedenti).
3.  Assicurarsi che la LUT sia compatibile con lo spazio colore di lavoro scelto (vedere parametri).[^lut3d-manual]

### 2. Conversione Log (Camera Log LUTs)

Questo caso d'uso riguarda file video o foto scattate in log (es. F-log, S-Log3) per convertire i dati grezzi in uno spazio visibile o lineare.

1.  Spostare manualmente il modulo **LUT 3D** tra i moduli **demosaic** e **input color profile**.
2.  In questa configurazione, l'opzione "application color space" non sarà disponibile.
3.  Il profilo di input del modulo **input color profile** deve essere allineato con l'output della LUT applicata.[^lut3d-manual]

!!! warning "Funzionalità sperimentale"
    L'uso di LUT 3D per la conversione di Log camera tra *demosaic* e *input color profile* non è stato ancora testato completamente e potrebbe presentare problemi di compatibilità o accuratezza.[^lut3d-manual]

## Parametri principali

| Parametro | Opzioni / Descrizione | Note |
|-----------|----------------------|------|
| **file selection** | Menu a tendina per scegliere il file | Disattivato se la "LUT 3D root folder" non è definita nelle preferenze.[^lut3d-manual][^processing-prefs] |
| **application color space** | Spazio colore per cui la LUT è stata creata | I file `.cube` sono solitamente correlati a **Rec. 709**, mentre la maggior parte degli altri formati è correlata a **sRGB**.[^lut3d-manual] |
| **interpolation** | Metodo di calcolo per i colori intermedi | Opzioni: **tetrahedral** (default), **trilinear**, **pyramid**. Le differenze sono solitamente visibili solo con LUT di piccole dimensioni.[^lut3d-manual] |

## Consigli

!!! tip "Configurazione iniziale"
    Prima di utilizzare il modulo, vai in **Preferenze > Elaborazione (Processing)** e imposta il percorso della "LUT 3D root folder". Senza questo passaggio, darktable non saprà dove cercare i file.[^processing-prefs]

!!! warning "Attenzione alla compatibilità"
    Non tutte le LUT scaricate da internet sono compatibili con darktable. Le LUT incompatibili non produrranno il look pubblicizzato. Per ridurre il rischio, verifica che la LUT sia stata creata per funzionare con uno degli "application color space" disponibili in darktable, sia per l'input che per l'output del modulo.[^lut3d-manual]

## Risorse aggiuntive

- [Manuale Utente darktable - LUT 3D](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/lut-3d/#)
- [Preferenze di darktable - Elaborazione](https://docs.darktable.org/usermanual/development/en/preferences-settings/processing/)

## Fonti

[^lut3d-manual]: darktable user manual - LUT 3D. URL: https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/lut-3d/#
[^processing-prefs]: darktable user manual - processing. URL: https://docs.darktable.org/usermanual/development/en/preferences-settings/processing/
