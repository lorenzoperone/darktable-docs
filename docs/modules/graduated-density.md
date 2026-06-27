# Graduated Density

Il modulo **Graduated Density** simula un filtro a densità neutra graduata (ND Grad), permettendo di correggere l'esposizione e il colore in modo progressivo su una porzione dell'immagine. È l'equivalente diretto del "Graduated Filter" di Lightroom, ma implementato come un modulo distinto nella pipeline di elaborazione.[^manual-gd]

Una linea interattiva viene mostrata sullo schermo, permettendo di modificare la posizione e la rotazione del gradiente direttamente con il mouse.[^manual-gd]

!!! warning "Artefatti di Banding"
    Questo modulo è noto per provocare artefatti di banding (sfasature o bande di colore) sotto certe condizioni, specialmente in aree uniformi come i cieli. Si consiglia vivamente di attivare il modulo **dither or posterize** per alleviare questi problemi.[^manual-gd]

## Panoramica

**Graduated Density** agisce applicando una transizione lineare tra un'area modificata e una non modificata. È particolarmente utile per:

1.  **Bilanciare l'esposizione**: Scurendo un cielo sovraesposto (simulando un filtro ND fisico).
2.  **Correzioni coloristiche**: Applicare viraggi selettivi (es. scaldare il cielo).
3.  **Controllo locale**: Modificare contrasto o saturazione in una zona specifica se combinato con altri moduli o maschere (anche se questo modulo opera principalmente sulla densità e colore base).[^manual-gd]

A differenza di Lightroom, dove lo strumento è una pennellata, qui l'interazione avviene tramite una linea guida che definisce la direzione e la durezza della transizione.

## Flusso di lavoro consigliato

L'uso tipico del modulo prevede i seguenti passaggi:[^manual-gd]

1.  **Attivazione e posizionamento**: Attiva il modulo. Vedrai apparire una linea centrale sull'immagine. Clicca e trascina il centro della linea per spostare l'area di intervento.
2.  **Definizione della transizione**:
    *   Usa il cursore **hardness** per decidere quanto deve essere netta la transizione tra l'area trattata e quella non trattata.
    *   Trascina le estremità della linea visibile sullo schermo per ruotare il filtro (alternativamente, usa lo slider **rotation**). Nota che valori negativi ruotano in senso orario.[^manual-gd]
3.  **Regolazione Intensità**: Modifica il parametro **density** per aumentare o diminuire l'effetto di scurimento (in EV).
4.  **Controllo Banding**: Se applichi una correzione forte su sfondi uniformi (es. cielo azzurro), controlla a zoom 100%. Se vedi bande, attiva il modulo **dither or posterize** più in basso nella pipeline.[^manual-gd]

## Parametri principali

Il modulo offre un set limitato ma efficace di controlli per gestire l'intensità e l'estetica del gradiente.[^manual-gd]

| Parametro | Range/Descrizione | Default | Dettagli |
|-----------|-------------------|---------|----------|
| **density** | Non specificato (EV) | N/A | Imposta la densità del filtro. Un valore basso sottoespone leggermente l'area, mentre un valore alto crea un filtro forte e scuro.[^manual-gd] |
| **hardness** | Non specificato | N/A | Controlla la progressività del gradiente. Un valore basso crea una transizione morbida e sfumata, mentre un valore alto rende la transizione più brusca e definita.[^manual-gd] |
| **rotation** | Non specificato (gradi) | N/A | Angolo di rotazione del filtro. I valori negativi ruotano in senso orario. Può essere impostato anche trascinando l'estremità della linea con il mouse.[^manual-gd] |
| **hue** | Spettro colori | N/A | Sceglie una tonalità per aggiungere una dominante cromatica al gradiente (utile per effetti creativi o correzioni colore).[^manual-gd] |
| **saturation** | Non specificato (%) | 0 | La saturazione della dominante cromatica. Il valore predefinito è 0, che corrisponde a un filtro neutro (senza colore). Aumentalo per applicare il colore selezionato in *hue*.[^manual-gd] |

## Consigli

!!! tip "Rotazione interattiva"
    Per un posizionamento preciso, usa il mouse per trascinare le "maniglie" alle estremità della linea sul canvas invece di affidarti solo allo slider numerico della rotazione. Questo permette di allineare il gradiente perfettamente all'orizzonte o ad altre linee guida nell'immagine.[^manual-gd]

!!! warning "Limiti dei valori numerici"
    La documentazione fornita non specifica range numerici esatti (es. -100 a +100) per tutti i parametri. Fai affidamento sull'anteprima visiva e sul feedback dell'istogramma per valutare l'intensità di **density** e **hardness**.[^manual-gd]

## Risorse

Per approfondire l'uso e l'integrazione nella pipeline, consulta la documentazione ufficiale di darktable.

## Fonti

[^manual-gd]: darktable user manual - graduated density. URL: https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/graduated-density/
