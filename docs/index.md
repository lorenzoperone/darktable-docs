# Guida al post-processing con darktable

Benvenuto nella guida operativa al flusso di lavoro **scene-referred** in darktable 5.4+.

!!! info "Obiettivo"
    Questa guida non e' un manuale del software. Non troverai qui la lista di ogni parametro.
    Il suo scopo e' accompagnarti dall'apertura del programma all'esportazione finale,
    con un ordine logico, esempi concreti e le ragioni dietro ogni scelta.

## Cosa trovi qui

<div class="grid cards" markdown>

- :material-camera-enhance: **Flusso di lavoro**

    Dall'importazione all'esportazione: ogni passo nel giusto ordine.

    [:octicons-arrow-right-24: Inizia dal flusso](workflow/index.md)

- :material-tune: **Moduli darktable**

    Exposure, Filmic RGB, Color Calibration, Tone Equalizer e gli altri moduli chiave.

    [:octicons-arrow-right-24: Esplora i moduli](modules/index.md)

- :material-palette: **Teoria del colore**

    Scene-referred, bilanciamento del bianco, profili ICC.

    [:octicons-arrow-right-24: Teoria del colore](color/index.md)

- :material-selection-ellipse: **Maschere**

    Disegnate, parametriche, raster, AI -- editing selettivo e di precisione.

    [:octicons-arrow-right-24: Maschere](masking/index.md)

- :material-export: **Esportazione**

    Formati, stili, preset e batch editing.

    [:octicons-arrow-right-24: Esportazione](export/index.md)

- :material-book-open-variant: **Appendice**

    Glossario, shortcut e risorse esterne.

    [:octicons-arrow-right-24: Appendice](appendix/resources.md)

</div>

## Paradigma scene-referred

La post-produzione moderna in darktable si basa sul paradigma **scene-referred**:
i dati del sensore vengono mantenuti su scala lineare per tutta la pipeline,
e la compressione tonale avviene solo a fine processo (Filmic RGB, AgX, Sigmoid).

## La pipeline di elaborazione

In darktable i dati attraversano una sequenza fissa di moduli chiamata **pixelpipe**.
L'ordine e' il seguente:

```
┌─────────────────── FASE LINEARE (scene-referred) ──────────────────────────────┐
│                                                                                │
│  Punto nero / punto bianco RAW                                                 │
│    → Bilanciamento del bianco  (camera reference)                              │
│    → Demosaicizzazione                                                         │
│    → Riduzione rumore (profilato)                                              │
│    → Correzione obiettivo                                                      │
│    → Esposizione  (ancoraggio del grigio medio)                                │
│    → Ricostruzione alte luci                                                   │
│    → Calibrazione colore  (CAT16)                                              │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────── COMPRESSIONE TONALE (tone mapping) ─────────────────────────────┐
│                                                                                │
│    AgX  ·  Filmic RGB  ·  Sigmoideo    ← scegline UNO solo                     │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────── FASE DISPLAY (display-referred) ────────────────────────────────┐
│                                                                                │
│    → Bilanciamento colore  (vibrazione, 4 vie, mappatura gamut)                │
│    → Equalizzatore colore  (tonalita' selettive)                               │
│    → Equalizzatore toni  (scultura della luce per zone)                        │
│    → Contrasto locale  /  Diffondi e nitidezza                                 │
│    → Grana, Vignettatura, Filigrana                                            │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘
                                    ↓
                            Esporta  (JPEG/TIFF)
```

!!! tip "Prima di tutto"
    Vai in **Preferenze > Elaborazione > Flusso predefinito** e seleziona `scene-referred (agx)`.
    Imposta il tema su `darktable-elegant-grey` per valutare correttamente l'esposizione.

## Sorgenti di questa guida

Questa documentazione aggrega e cita contenuti da quattro famiglie di fonti:

### Documentazione ufficiale

**277 pagine** dal [manuale utente darktable](https://docs.darktable.org/usermanual/development/en/) (versione 4.8), salvate in `processed/darktable-usermanual-en/`. Citate in ogni pagina come `[^manual-*]`.

### Community PIXLS.US

**36 articoli** da [pixls.us/articles](https://pixls.us/articles/) (tutorial fotografici) e **31 thread** da [discuss.pixls.us](https://discuss.pixls.us/c/software/darktable) (forum). Copie locali in `processed/pixls-articles/` e `processed/discuss-pixls/`.

### Community darktable.fr

**746 pagine** dalla community francese [darktable.fr](https://darktable.fr/), inclusi tutorial, guide per versione e FAQ. Copie locali in `processed/darktable-fr/`.

### Video tutorial (manualize)

**72 video analizzati** tramite il progetto [manualize](https://github.com/lorenzoperone/manualize): trascrizioni word-level, capitoli strutturati e consigli operativi estratti. I canali video inclusi sono:

- **A Dabble in Photography** (inglese, ~60 video) — la fonte principale: guide su AgX, Filmic RGB, Sigmoid, Color Balance RGB, maschere AI (SAM2), effetti Orton/Dragan, editing B&W, portrait, landscape, lowlight
- **Fotografare per Stupire** (italiano, 10 video) — tutorial in italiano: interfaccia e catalogazione, bilanciamento del bianco, controllo colore, maschere parametriche, rimozione imperfezioni, riduzione rumore, equalizzatore toni, workflow ritratto

Citati nelle pagine come `[^firststeps]`, `[^pipeline]`, `[^agx-guide]`, ecc.

---

*Guida aggiornata alle ultime funzionalità di darktable*

