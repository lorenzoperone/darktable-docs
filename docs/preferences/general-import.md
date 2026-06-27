# Preferenze: generali e importazione

Le preferenze di **darktable** sono divise in schede per controllare diversi aspetti dell'ambiente di lavoro. Le schede **General** e **Import** sono fondamentali per configurare l'interfaccia utente e definire come le immagini entrano nel catalogo (Library), un passaggio cruciale per chi migra da Lightroom e deve adattarsi al sistema di gestione file non distruttivo di darktable.[^manual-prefs]

!!! info "Differenza rispetto a Lightroom"
    A differenza di Lightroom, che importa sempre le immagini in un catalogo unificato, darktable offre la flessibilità di "Aggiungere alla libreria" (referenziando i file in-place) o "Copiare e importare" (spostando i file). Questa distinzione è configurata nelle preferenze di importazione.[^manual-import-review]

## Panoramica

Le impostazioni coperte da questa documentazione riguardano due aree distinte:

1.  **General**: Controlla l'aspetto visivo dell'interfaccia, inclusi temi, caratteri e DPI. Queste impostazioni influenzano la percezione del colore e la comodità d'uso.[^manual-general]
2.  **Import**: Definisce le regole predefinite per la denominazione dei file, la struttura delle directory e i metadati iniziali quando si importano nuove immagini. Queste impostazioni sono strettamente legate al modulo *Import* nella vista Lighttable.[^manual-import]

Configurare correttamente queste preferenze prima di iniziare un nuovo progetto garantisce un flusso di lavoro ordinato e una valutazione del colore accurata.

## Flusso di lavoro consigliato

Il setup iniziale di darktable per un nuovo utente dovrebbe seguire questo ordine logico:[^manual-general][^manual-import]

```
1. Configurazione Interfaccia (Scheda General)
   |
2. Configurazione Regole di Importazione (Scheda Import)
   |
3. Importazione Immagini (Modulo Import)
   |
4. Cernita (Rating)
```

### Passo 1: Configurazione dell'interfaccia

Prima di editare, è cruciale impostare l'ambiente visivo corretto:

1.  Apri **Preferences > general**.
2.  Imposta il **theme** su uno dei temi "grey" (es. `darktable-elegant-grey`). Questo assicura che lo sfondo sia un grigio medio, riducendo illusioni ottiche durante la modifica del colore.[^manual-general]
3.  Regola **font size** e **GUI controls and text DPI** se necessario per adattarsi al tuo monitor (Default DPI: 96).[^manual-general]

### Passo 2: Definire le regole di denominazione

Per mantenere l'archivio ordinato, configura le variabili di denominazione in **Preferences > import**:[^manual-import]

1.  Definisci il **base filmroll’s directory** (es. `$(PICTURES_FOLDER)/Darktable`).
2.  Imposta il **filmroll name** per organizzare le sessioni (es. `$(YEAR)$(MONTH)$(DAY)_$(JOBCODE)`).
3.  Imposta il **file naming pattern** per i singoli file (es. `$(YEAR)$(MONTH)$(DAY)_$(SEQUENCE).$(FILE_EXTENSION)`).

### Passo 3: Importazione e Cernita

Utilizza il modulo **Import** nella vista Lighttable:

1.  Scegli tra **add to library** (se i file sono già nel posto giusto) o **copy & import** (per copiare da una scheda SD).[^manual-import-review]
2.  Applica il rating iniziale definito nelle preferenze (default 1 stella).
3.  Esegui la cernita: premi `1`-`5` per promuovere le immagini o `R` per rifiutarle. Darktable assegna automaticamente 1 stella alle nuove importazioni, facilitando il filtraggio iniziale.[^manual-import-review]

## Parametri principali (General)

La scheda **General** controlla l'esperienza utente e la resa cromatica dell'interfaccia.[^manual-general]

| Parametro | Range/Opzioni | Default | Descrizione |
|-----------|---------------|---------|-------------|
| **interface language** | Lista lingue sistema | System default | Imposta la lingua dell'interfaccia. Richiede riavvio. |
| **theme** | Lista temi CSS | darktable-elegant-grey | Controlla l'aspetto dell'interfaccia. I temi "grey" sono raccomandati per la valutazione del colore (middle gray). |
| **use system font size** | Checkbox | Checked | Se attivo, usa la dimensione del font definita dal sistema operativo. |
| **font size in points** | Numerico | Variabile | Dimensione del font personalizzata se "use system font size" è disattivato. |
| **GUI controls and text DPI** | Numerico | 96 DPI | Ridimensiona l'interfaccia globale. Aumenta per ingrandire i controlli, diminuisci per adattare più contenuti. `-1` usa le impostazioni di sistema. Richiede riavvio. |

!!! warning "Attenzione alla percezione del colore"
    L'uso di interfacce troppo scure o troppo chiare può ingannare la percezione visiva, portando a eccessivi interventi di contrasto e saturazione. È "altamente raccomandato" utilizzare temi grigi per il lavoro di fotoritocco.[^manual-general]

## Parametri principali (Import)

La scheda **Import** e il modulo omonimo gestiscono come i file vengono catalogati e nominati. Molti di questi parametri possono essere preimpostati nelle preferenze per evitare di reinserirli ogni volta.[^manual-import]

| Parametro | Range/Opzioni | Default | Descrizione |
|-----------|---------------|---------|-------------|
| **ignore exif rating** | Checkbox | Off | Se attivo, ignora il rating presente nei metadati Exif del file. |
| **initial rating** | 0 - 5 stelle | 1 stella | Imposta il rating assegnato automaticamente alle immagini appena importate.[^manual-import] |
| **apply metadata** | Checkbox | Off | Se attivo, applica automaticamente campi metadati e tag definiti dall'utente durante l'importazione. |
| **base filmroll’s directory** | Stringa con variabili | `$(PICTURES_FOLDER)/Darktable` | Directory base dove vengono salvati i rullini filmati. Supporta variabili come `$(HOME)` o `$(PICTURES_FOLDER)`. |
| **filmroll name** | Stringa con variabili | `$(YEAR)$(MONTH)$(DAY)_$(JOBCODE)` | Nome della sottodirectory per il rullino. La variabile `$(JOBCODE)` è definita nel modulo *Session*. |
| **file naming pattern** | Stringa con variabili | `$(YEAR)$(MONTH)$(DAY)_$(SEQUENCE).$(FILE_EXTENSION)` | Pattern di rinomina dei file. Utilizza variabili data/ora e sequenza. |
| **keep original filename** | Checkbox | Off | Se attivo, mantiene il nome del file originale invece di usare il pattern di rinomina. |

!!! tip "Variabili utili per l'importazione"
    Le variabili come `$(YEAR)`, `$(MONTH)`, `$(DAY)`, `$(HOUR)`, `$(SEQUENCE)` e `$(JOBCODE)` permettono di creare strutture di cartelle dinamiche. Ad esempio, `$(YEAR)$(MONTH)$(DAY)_$(JOBCODE)` creerà automaticamente cartelle basate sulla data e un codice sessione definito al momento dello scatto o dell'importazione.[^manual-import][^manual-session]

## Consigli

-   **Usa il tema grigio**: Per una valutazione del colore accurata, evita temi con colori saturi o contrasti eccessivi nell'interfaccia. Il tema predefinito `darktable-elegant-grey` è calibrato sul grigio medio (18%).[^manual-general]
-   **Sfrutta il Jobcode**: Se scatti in tethering o vuoi organizzare gli scatti per "sessioni", usa la variabile `$(JOBCODE)` nel pattern di importazione. Questo ti permette di raggruppare gli scatti per progetto o evento automaticamente.[^manual-session]
-   **Cernita rapida**: Sfrutta il rating iniziale (1 stella) per filtrare rapidamente le nuove importazioni. Imposta la vista Lighttable per mostrare solo le immagini con 1 stella e promuovi solo le migliori con i tasti `2`-`5`.[^manual-import-review]
-   **Non usare "Recursive directory" per importazioni massive**: Se importi da una struttura complessa, evita di spuntare "recursive directory" su cartelle contenenti migliaia di immagini, poiché questo rallenterà la generazione delle anteprime e riempirà la cache inutilizzatamente.[^manual-import]

## Risorse aggiuntive

-   [darktable user manual - import & review](https://docs.darktable.org/usermanual/development/en/overview/workflow/import-review/) — Guida ufficiale al flusso di importazione e cernita.
-   [darktable user manual - Preferences > General](https://docs.darktable.org/usermanual/development/en/preferences-settings/general/) — Dettagli sui temi e impostazioni interfaccia.
-   [darktable user manual - Preferences > Import](https://docs.darktable.org/usermanual/development/en/preferences-settings/import/) — Variabili e regole di denominazione file.
-   [darktable user manual - Import Module](https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/lighttable/import/) — Controlli del modulo di importazione nella vista Lighttable.

## Fonti

[^manual-prefs]: darktable user manual - Preferences & Settings. https://docs.darktable.org/usermanual/development/en/preferences-settings/#
[^manual-general]: darktable user manual - general. https://docs.darktable.org/usermanual/development/en/preferences-settings/general/
[^manual-import]: darktable user manual - import. https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/lighttable/import/
[^manual-import-review]: darktable user manual - import & review. https://docs.darktable.org/usermanual/development/en/overview/workflow/import-review/#
[^manual-session]: darktable user manual - session. https://docs.darktable.org/usermanual/development/en/module-reference/utility-modules/tethering/session/#
