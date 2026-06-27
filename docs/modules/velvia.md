# Velvia

Il modulo **Velvia** è un filtro di post-produzione progettato per aumentare la saturazione dell'immagine in modo ponderato, dando maggiore enfasi ai neri, ai bianchi e ai pixel meno saturi.[^manual-velvia] Il nome è un omaggio alla famosa pellicola dia positiva Fujifilm Velvia, nota per i colori estremamente vivaci e ad alto contrasto, spesso utilizzata in fotografia paesaggistica.

!!! warning "Avvertenza importante"
    Il manuale utente di darktable segnala che questo modulo provoca **shift di tonalità (hue) e luminosità** che possono risultare difficili da gestire e prevedere. Per le modifiche del colore, si consiglia vivamente di utilizzare il modulo **color balance rgb** invece di Velvia.[^manual-velvia]

## Panoramica

Velvia agisce come un booster di saturazione selettivo. A differenza di un semplice controllo di saturazione globale, l'algoritmo tenta di proteggere le aree già molto saturate concentrandosi su quelle che hanno meno "peso" cromatico (come le ombre o i toni spenti), oltre a spingere i neri e i bianchi.[^manual-velvia]

Tuttavia, a causa della sua natura non lineare e dei side-effect sulla luminosità, è considerato un modulo "legacy" nei flussi di lavoro moderni scene-referred. L'evoluzione di darktable verso pipeline RGB lineari ha reso strumenti come `color balance rgb` o `color zones` molto più precisi e controllabili per ottenere effetti simili senza alterare la percezione della luminanza.[^manual-velvia][^pixls-lab]

## Flusso di lavoro

Data la natura distruttiva e poco prevedibile di questo modulo, il suo utilizzo è sconsigliato nei flussi di lavoro moderni che puntano alla fedeltà cromatica.

1.  **Posizionamento nella pipeline**: Se decidi di utilizzarlo, posizionalo verso la fine della pipeline, **dopo** i moduli di mappatura dei toni (come AGX o Filmic RGB) e **dopo** il bilanciamento del colore.
2.  **Alternativa moderna**: Invece di Velvia, prova a utilizzare il modulo **color balance rgb**. Agendo sui canali di brillantezza (brilliance) e saturazione, puoi ottenere un "pop" cromatico simile ma con un controllo molto maggiore sulla luminosità e senza shift di tonalità indesiderati.[^manual-velvia]

## Parametri

Il modulo dispone di due controlli principali per regolare l'intensità dell'effetto e la sua incidenza sulle carnagioni.


| Parametro | Descrizione |
|-----------|-------------|
| **strength** | Controlla l'intensità dell'effetto di saturazione. Aumentando questo valore, l'immagine diventa più vivace, ma aumenta anche il rischio di shift di tonalità e perdita di dettaglio nelle alte luci.[^manual-velvia] |
| **mid-tones bias** | Riduce l'effetto sui toni medi per evitare colori innaturali sulla pelle. Ridurre questo parametro diminuisce la protezione dei toni medi e rende l'effetto Velvia più forte e visibile su tutto l'immagine (incluso il viso dei soggetti). Aumentarlo protegge le carnagioni ma rende l'effetto meno evidente nel resto della foto.[^manual-velvia] |

!!! tip "Protezione della pelle"
    Se usi Velvia su ritratti, mantieni il parametro **mid-tones bias** su valori elevati per evitare che la pelle diventi arancione o innaturale. Tuttavia, per ritratti seri, è meglio evitare completamente questo modulo.[^manual-velvia]

## Consigli e Prestazioni

Nonostante sia un modulo semplice, ci sono alcune considerazioni tecniche da tenere a mente:

*   **Prestazioni OpenCL**: Il modulo Velvia beneficia enormemente dell'accelerazione hardware. Con OpenCL attivo, il tempo di elaborazione di questo modulo passa da "misurabile" a "quasi istantaneo" (qualche millisecondo per immagini da 36 Mpix). Se trovi la lentezza insopportabile, assicurati che OpenCL sia abilitato nelle preferenze.[^opencl-article]
*   **Ottimizzazioni recenti**: Nella versione 4.4.0 di darktable, il codice specifico SSE2 del modulo Velvia è stato rimosso in favore di codice parallelo ottimizzato dal compilatore, portando a miglioramenti di velocità generali nella pipeline.[^dt44-release]
*   **Evitare su HDR**: Poiché Velvia lavora in spazi colorimetrici derivati (storicamente legati a Lab o manipolazioni RGB non lineari), può produrre artefatti visivi fastidiosi su immagini ad alta gamma dinamica se non gestito con cura dopo un corretto tone mapping.[^pixls-lab]

## Risorse aggiuntive

Sebbene il modulo sia semplice, la comprensione dello spazio colore Lab (spesso associato a vecchi moduli come questo) può aiutare a capire perché shift di tonalità avvengono.

*   **Articolo su RGB vs Lab**: Per capire perché i moduli moderni preferiscono lavorare in RGB lineare rispetto a spazi come Lab (dove Velvia e simili operavano storicamente), consulta l'articolo di Aurélien Pierre su darktable.fr.[^pixls-lab]

## Fonti

[^manual-velvia]: https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/velvia/
[^pixls-lab]: https://darktable.fr/posts/2020/01/darktable-3-rgb-ou-lab-quels-modules-au-secours/
[^dt44-release]: https://darktable.fr/posts/2023/06/notes-version-4.4/#
[^opencl-article]: https://darktable.fr/posts/2018/10/darktable-et-opencl-jachete-une-carte-graphique-ou-pas/
