# Defringe

Il modulo **defringe** è uno strumento legacy progettato per rimuovere il color fringing, spesso causato dalle Aberrazioni Cromatiche Longitudinali (LCA), note anche come Aberrazioni Cromatiche Assiali.[^manual-defringe]

!!! warning "Modulo deprecato dalla versione 3.6"
    Questo modulo è deprecato (**deprecated**) da darktable 3.6 e non dovrebbe essere utilizzato per nuove modifiche. Si consiglia vivamente di utilizzare il modulo **chromatic aberrations** per ottenere risultati superiori e una gestione migliore delle aberrazioni.[^manual-defringe]

## Panoramica

Il modulo agisce tramite un algoritmo di *edge-detection* (rilevamento dei bordi). Quando vengono rilevati pixel identificati come frange, il modulo ricostruisce il colore utilizzando pixel vicini meno saturi.[^manual-defringe]

Sebbene efficace in passato, il suo approccio basato sulla desaturazione locale è stato superato da metodi più sofisticati disponibili nel modulo *chromatic aberrations*, che gestisce meglio sia le aberrazioni trasversali (TCA) che longitudinali (LCA).

## Flusso di lavoro

Poiché il modulo è deprecato, non esiste un flusso di lavoro raccomandato per i nuovi utenti.

!!! tip "Migrazione per utenti Lightroom"
    In Lightroom, la correzione delle aberrazioni cromatiche è spesso automatizzata nel pannello "Lens Corrections". Il modulo equivalente e moderno è **chromatic aberrations**. Se stai leggendo documentazione o vecchi tutorial che citano *defringe*, ignoralo e applica la correzione direttamente nel modulo *chromatic aberrations*.

Se devi manutenere vecchi file `.xmp` creati con versioni precedenti a darktable 3.6 che utilizzano questo modulo, è preferibile:
1.  Disattivare *defringe*.
2.  Attivare *chromatic aberrations*.
3.  Regolare i parametri del nuovo modulo per replicare visivamente la correzione.

## Parametri principali

Poiché il modulo è deprecato, i parametri sono mantenuti principalmente per compatibilità con le versioni precedenti. Le fonti non forniscono range numerici specifici (es. 0-100), ma descrivono il comportamento qualitativo degli slider.[^manual-defringe]

| Parametro | Descrizione | Comportamento |
|-----------|-------------|---------------|
| **operation mode** | Metodo di calcolo per il rilevamento e la correzione | **global average**: Solitamente il più veloce, ma potrebbe mostrare anteprime imprecise ad alto ingrandimento o proteggere regioni di colore errate.<br>**local average**: Più lento perché calcola riferimenti di colore locali per ogni pixel. Offre una migliore protezione del colore e ricostruzione dove necessario.<br>**static threshold**: Non usa un riferimento di colore, ma usa direttamente la soglia impostata dall'utente.[^manual-defringe] |
| **edge detection radius** | Estensione spaziale del blur gaussiano usato per rilevare i bordi | Aumenta questo valore se vuoi un rilevamento più forte delle frange o se lo spessore dei bordi delle frange è troppo elevato.[^manual-defringe] |
| **threshold** | Soglia sopra la quale un pixel viene contato come "fringe" | Prova ad **abbassare** questo valore se non vengono rilevate abbastanza frange. **Aumenta** il valore se troppi pixel vengono desaturati (perdita di colore nelle zone corrette).[^manual-defringe] |

## Consigli

!!! info "Quando usare il modulo (o il suo successore)"
    Utilizza strumenti di correzione delle aberrazioni cromatiche (preferibilmente il modulo *chromatic aberrations*) subito dopo il modulo *lens correction* e prima di qualsiasi operazione di sharpening o nitidezza. Correggere le frange prima di aumentare il contrasto locale previene l'amplificazione degli artefatti cromatici.[^manual-defringe]

## Risorse

Per la documentazione aggiornata e i metodi moderni di correzione, consultare la sezione relativa al modulo **chromatic aberrations** nel manuale utente di darktable.

## Fonti

[^manual-defringe]: darktable user manual - (deprecated) defringe. URL: https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/defringe/
