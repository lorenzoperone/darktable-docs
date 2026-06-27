# Color Mapping

Il modulo **Color Mapping** è uno strumento avanzato per trasferire il "look and feel" cromatica di un'immagine (sorgente) a un'altra (target). A differenza delle semplici curve o dei livelli di regolazione, questo modulo esegue un'analisi statistica delle caratteristiche del colore di entrambe le immagini, creando una mappatura basata su cluster di colori dominanti[^manual-color-mapping].

!!! info "Posizione nella pipeline"
    Questo modulo si trova nella prima parte della pixelpipe di elaborazione. Ciò significa che puoi sempre rifinire i colori in un secondo momento utilizzando moduli successivi nella pipeline[^manual-color-mapping].

## Panoramica

Il funzionamento di **Color Mapping** si basa sull'analisi e l'accoppiamento di gruppi di colori (cluster):

1.  **Analisi Sorgente**: Il modulo analizza l'immagine di riferimento e genera una serie di cluster cromatici, visualizzati come swatches che mostrano il valore medio del colore circondato da varianti che indicano la varianza all'interno di quel cluster. I cluster sono ordinati in base al loro peso (il numero di pixel che contribuiscono a ciascuno di essi)[^manual-color-mapping].
2.  **Analisi Target**: Viene eseguita la stessa analisi statistica sull'immagine che si desidera modificare[^manual-color-mapping].
3.  **Mappatura Automatica**: Una volta che entrambi i set di cluster sono acquisiti, il modulo applica automaticamente una mappatura dei colori dalla sorgente al target[^manual-color-mapping].

!!! warning "Effetto predefinito"
    Con le impostazioni predefinite, l'effetto applicato è spesso molto esagerato rispetto all'aspetto naturale dell'immagine sorgente[^manual-color-mapping].

## Flusso di lavoro consigliato

L'utilizzo di questo modulo richiede un passaggio tra due immagini diverse nella vista Darkroom. Il processo si articola in due fasi principali[^manual-color-mapping]:

### Passo 1: Acquisizione della Sorgente

1.  Apri l'immagine di riferimento (quella con i colori che vuoi copiare) nella vista **Darkroom**.
2.  Assicurati che il modulo **Color Mapping** sia attivo e ripristinato (reset).
3.  Clicca sul pulsante **acquire as source**.
4.  Attendi alcuni secondi: l'interfaccia grafica potrebbe non rispondere durante l'elaborazione statistica[^manual-color-mapping].
5.  I cluster generati appariranno nell'area *source clusters*.

### Passo 2: Acquisizione del Target e Regolazione

1.  Apri l'immagine su cui vuoi applicare il look.
2.  Se i cluster sorgente non sono più visibili, clicca il pulsante **reset** del modulo (i dati sorgente vengono mantenuti in memoria finché non vengono sovrascritti o resettati)[^manual-color-mapping].
3.  Clicca il pulsante **acquire as target**. Verrà generato l'insieme di cluster per l'immagine corrente e la mappatura verrà applicata istantaneamente[^manual-color-mapping].
4.  Regola l'intensità dell'effetto usando i parametri descritti sotto o le modalità di fusione.

## Parametri principali

| Parametro | Descrizione | Comportamento |
|-----------|-------------|---------------|
| **acquire as source** | Pulsante per analizzare l'immagine di riferimento | Genera i cluster sorgente. L'interfaccia potrebbe bloccarsi per alcuni secondi durante il calcolo[^manual-color-mapping]. |
| **acquire as target** | Pulsante per analizzare l'immagine da modificare | Genera i cluster target e applica la mappatura automatica[^manual-color-mapping]. |
| **number of clusters** | Numero di gruppi cromatici da calcolare | Dovrebbe corrispondere approssimativamente al numero di colori dominanti nell'immagine. La natura casuale del campionamento statistico può produrre risultati diversi a ogni acquisizione, specialmente con un numero elevato di cluster o palette complesse. Modificare questo valore resetta i cluster acquisiti[^manual-color-mapping]. |
| **color dominance** | Logica di associazione tra cluster sorgente e target | Al valore minimo, la mappatura si basa sulla **prossimità dei colori** (effetto sottile). Al valore massimo, si basa sul **peso relativo** dei cluster (i colori dominanti della sorgente mappano su quelli dominanti del target, effetto molto forte)[^manual-color-mapping]. |
| **histogram equalization** | Modifica del contrasto del target | Fa corrispondere l'istogramma dell'immagine target con quello della sorgente. Lo slider controlla l'estensione di questa equalizzazione[^manual-color-mapping]. |

## Consigli

!!! tip "Addolcire l'effetto"
    Poiché l'effetto di default è spesso troppo forte, puoi utilizzare la modalità di fusione **normal** in combinazione con lo slider **opacity** per attenuare l'impatto della mappatura cromatica[^manual-color-mapping].

!!! tip "Costanza dei risultati"
    A causa del campionamento casuale usato per generare i cluster, potresti ottenere risultati leggermente diversi se premi più volte "acquire as source" o "acquire as target", specialmente se hai impostato un alto numero di cluster[^manual-color-mapping].

## Risorse

- Documentazione ufficiale darktable: [color mapping](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-mapping/)

## Fonti

[^manual-color-mapping]: darktable user manual - color mapping. https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-mapping/
