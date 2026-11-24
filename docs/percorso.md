# Percorso di apprendimento

La guida ha due anime: un **percorso** da seguire in ordine e un **manuale di riferimento** da consultare quando serve. Questa pagina è il percorso: tre livelli, ciascuno con un obiettivo concreto e le pagine da leggere nell'ordine indicato. I tempi sono indicativi e comprendono la prova pratica su una tua foto.

!!! tip "Come usarlo"
    Non serve leggere tutto il livello prima di aprire darktable: leggi una pagina, prova subito su un tuo RAW, poi passa alla successiva. Le pagine dei moduli non elencate qui sono riferimento: aprile quando ti servono.

## Livello 1 — Primi passi

**Obiettivo:** importare, sviluppare ed esportare una foto con il flusso scene-referred, senza maschere.
**Prerequisiti:** nessuno. **Tempo indicativo:** 3–4 ore.

| # | Pagina | Cosa impari |
|---|---|---|
| 1 | [Flusso scene-referred](color/scene-referred.md) | Perché darktable lavora sulla luce della scena e non sull'immagine a schermo |
| 2 | [Flusso di lavoro](workflow/index.md) | La sequenza dei passaggi e i moduli che contano davvero |
| 3 | [Lezione interattiva](workflow/lezione-interattiva.md) | Il flusso base applicato a una foto reale, passo per passo |
| 4 | [Importazione](workflow/import.md) | Portare le foto in darktable senza sorprese |
| 5 | [La lighttable](lighttable/index.md) | Libreria, selezione e valutazioni |
| 6 | [Esposizione](workflow/exposure.md) | Fissare la luminosità dei toni medi |
| 7 | [Tone mapping](workflow/tone.md) | Comprimere la gamma dinamica con AgX, Sigmoid o Filmic |
| 8 | [Cronologia](pipeline/history-stack.md) | Tornare indietro, confrontare, ripartire |
| 9 | [Esportazione](workflow/export.md) | JPEG per il web e file per la stampa |

**Pratica:** [Migrazione da Lightroom](workshop/from-lightroom.md), se arrivi da Lightroom.

**Esercizio:** [Esercizio 1 — Rilievi sotto i faretti](esercizi/index.md#esercizio-1-rilievi-sotto-i-faretti) (RAW scaricabile, con soluzione).

## Livello 2 — Controllo del colore e delle zone

**Obiettivo:** correggere colore e contrasto in modo mirato, lavorare su zone dell'immagine, organizzare l'archivio.
**Prerequisiti:** Livello 1. **Tempo indicativo:** 6–8 ore.

| # | Pagina | Cosa impari |
|---|---|---|
| 1 | [Il pixelpipe](pipeline/index.md) e [ordine dei moduli](pipeline/module-order.md) | Perché l'ordine di elaborazione è fisso e cosa implica |
| 2 | [Color calibration](modules/color-calibration.md) | Bilanciamento del bianco moderno (adattamento cromatico) |
| 3 | [Color grading](workflow/color.md) e [color balance rgb](modules/color-balance-rgb.md) | Saturazione, vividezza e intonazione cromatica |
| 4 | [Tone equalizer](modules/tone-equalizer.md) | Ombre e luci per zone, senza aloni |
| 5 | [Local contrast](modules/local-contrast.md) | Dettaglio e tridimensionalità |
| 6 | [Denoise](modules/denoise.md) e [lens correction](modules/lens-correction.md) | Le correzioni tecniche di base |
| 7 | [Maschere](masking/index.md): [parametriche](masking/parametric.md), [disegnate](masking/drawn.md), [combinate](masking/combining.md) | Applicare un modulo solo dove serve |
| 8 | [Preset e istanze multiple](pipeline/preset-istanze.md) | Usare lo stesso modulo più volte, salvare le proprie regolazioni |
| 9 | [Organizzazione](lighttable/organizzazione.md), [metadati e tag](lighttable/metadati-tag.md), [stili](lighttable/styles-cronologia.md) | Gestire l'archivio e riusare le elaborazioni |

**Pratica:** [Paesaggio](workshop/landscape.md), [Ritratto](workshop/portrait.md), [Street](workshop/street.md).

**Esercizio:** [Esercizio 2 — Il corridoio delle statue](esercizi/index.md#esercizio-2-il-corridoio-delle-statue) (RAW scaricabile).

## Livello 3 — Tecniche avanzate

**Obiettivo:** affrontare casi difficili (alta gamma dinamica, luce scarsa, bianco e nero, grading creativo) e capire la gestione del colore.
**Prerequisiti:** Livello 2. **Tempo indicativo:** 8–12 ore.

| # | Pagina | Cosa impari |
|---|---|---|
| 1 | [Gestione del colore](color/index.md), [profili ICC](color/icc-profiles.md), [gamut](color/gamut.md) | Spazi colore, profili, colori fuori gamut |
| 2 | [AgX](modules/agx.md), [Sigmoid](modules/sigmoid.md), [Filmic RGB](modules/filmic-rgb.md) | Scegliere e regolare a fondo il tone mapper |
| 3 | [Diffuse or sharpen](modules/diffuse-sharpen.md) | Nitidezza, dehaze ed effetti basati sulla diffusione |
| 4 | [Color equalizer](modules/color-equalizer.md) e [RGB primaries](modules/rgb-primaries.md) | Interventi selettivi su tinta, saturazione e luminosità |
| 5 | [Retouch](modules/retouch.md) | Ritocco per frequenze, rimozione di difetti |
| 6 | [Maschere AI](masking/ai-masks.md) e [raster](masking/raster.md) | Selezioni automatiche e riuso delle maschere |
| 7 | [Anatomia di un modulo](pipeline/anatomia-modulo.md) | Blending, opacità, modalità di fusione |
| 8 | [Preferenze di elaborazione](preferences/processing.md) | OpenCL/GPU e prestazioni |

**Pratica:** [HDR](workshop/hdr.md), [Scarsa illuminazione](workshop/lowlight.md), [Color grading avanzato](workshop/color-grading.md), [Bianco e nero](workshop/black-white.md), [Macro](workshop/macro.md), [Effetti creativi](workshop/creative-effects.md).

**Esercizio:** [Esercizio 3 — L'installazione al buio](esercizi/index.md#esercizio-3-linstallazione-al-buio) (RAW scaricabile).

## Riferimento

Tutto il resto è consultazione: l'elenco completo dei [moduli](modules/index.md), il [glossario](appendix/glossary.md), le [scorciatoie](appendix/shortcuts.md), le [FAQ](appendix/faq.md) e le [risorse esterne](appendix/resources.md).
