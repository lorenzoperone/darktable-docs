# Soften

Il modulo **soften** (ammorbidisci) è uno strumento creativo che permette di creare un'immagine digitalmente ammorbidita utilizzando l'effetto Orton. Questa tecnica prende il nome dal fotografo Michael Orton, che originariamente otteneva questo risultato su pellicola diapositiva combinando due esposizioni della stessa scena: una ben esposta e una sovraesposta. In camera oscura, le due immagini venivano sovrapposte, con quella sovraesposta che risultava sfocata.[^manual-soften]

Il modulo `soften` riproduce fedelmente questo processo nel dominio digitale, fondendo un'immagine nitida con una versione sovraesposta e sfocata della stessa fotografia per ottenere un look "sognante" e delicato.[^manual-soften]

## Panoramica

Il funzionamento del modulo si basa sulla simulazione della tecnica analogica:

1.  **Sovraesposizione**: Viene generata una copia dell'immagine con luminosità aumentata.
2.  **Sfocatura**: Questa copia viene sfocata per ridurre i dettagli.
3.  **Miscelazione**: L'immagine originale (nitida) e la versione modificata (sfocata e luminosa) vengono combinate per creare l'effetto finale.[^manual-soften]

A differenza di semplici filtri di sfocatura, l'effetto Orton preserva parzialmente la struttura dell'immagine originale grazie al parametro di miscelazione, aggiungendo al contempo una luminosità eterea tipica delle scene oniriche o dei ritratti artistici.[^manual-soften]

## Flusso di lavoro consigliato

Il modulo `soften` è un modulo di effetto e solitamente dovrebbe essere applicato verso la fine della pipeline di elaborazione, dopo aver corretto l'esposizione, il colore e aver eseguito il tone mapping.

1.  **Correzioni di base**: Completa prima il tuo lavoro standard (esposizione, profilo colore, eventuali ritagli).
2.  **Applica Soften**: Attiva il modulo `soften`.
3.  **Regolazione sequenziale**:
    *   Inizia impostando il livello di sfocatura (**size**).
    *   Regola la luminosità (**brightness**) per determinare quanto l'effetto "bagliore" deve influenzare l'immagine.
    *   Usa il controllo **mix** per bilanciare l'intensità dell'effetto rispetto all'immagine originale.

!!! tip "Valutazione a schermo intero"
    Poiché questo è un effetto globale, valuta sempre il risultato a schermo intero o a una riduzione significativa (zoom out). Lavorare costantemente al 100% può ingannare sulla reale percezione della morbidezza dell'immagine.

## Parametri principali

Il modulo offre quattro controlli principali per manipolare l'effetto.[^manual-soften]

| Parametro | Range tipico | Default | Descrizione |
|-----------|-------------|---------|-------------|
| **size** | Non specificato | Non specificato | La dimensione della sfocatura applicata all'immagine sovraesposta. Più grande è il valore, più morbido sarà il risultato.[^manual-soften] |
| **saturation** | Non specificato | Non specificato | La saturazione dell'immagine sovraesposta. Può essere usato per rendere i colori dell'effetto più vividi o più tenui.[^manual-soften] |
| **brightness** | Non specificato | Non specificato | La luminosità (espressa in EV) dell'immagine sovraesposta. Controlla l'intensità del bagliore aggiunto all'immagine.[^manual-soften] |
| **mix** | Non specificato | Non specificato | Definisce come le due immagini vengono miscelate. Un valore del 50% rappresenta un mix equo tra l'immagine ben esposta e quella sovraesposta.[^manual-soften] |

## Consigli

!!! tip "Utilizzo per ritratti"
    L'effetto Orton è storicamente popolare nei ritratti e nelle foto di natura per creare un'atmosfera romantica. Per i ritratti, mantieni il **size** moderato per evitare che i tratti del viso perdano ogni definizione.

!!! warning "Attenzione alla nitidezza"
    Aumentare eccessivamente il parametro **size** può rendere l'immagine completamente fuori fuoco, perdendo il punto focale. Usa il parametro **mix** per ritirare sempre un po' di nitidezza dall'immagine di base.

## Risorse

- **Manuale Utente darktable**: Sezione dedicata al modulo [soften](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/soften/).

## Fonti

[^manual-soften]: darktable user manual - soften. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/soften/
