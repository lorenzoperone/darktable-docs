# Censorize

Il modulo **censorize** è uno strumento progettato per degradare parti dell'immagine in modo esteticamente gradevole, con lo scopo principale di anonimizzare persone o oggetti, oppure di nascondere parti del corpo per rispettare le linee guida dei social media.[^censorize-manual]

Questo modulo opera nello spazio colore RGB lineare per applicare una sfocatura gaussiana fisicamente accurata e un rumore gaussiano di luminanza.[^censorize-manual]

!!! warning "Avvertenza sulla sicurezza forense"
    I metodi di anonimizzazione forniti da questo modulo **non sono forensicamente sicuri**. Tecniche forensi avanzate, in particolare l'intelligenza artificiale e il machine learning, potrebbero essere in grado di ricostruire il contenuto censurato basandosi sulla sua struttura, specialmente per forme semplici o testi (es. targhe, numeri civici). Per un'anonimizzazione sicura a livello forense, l'unico metodo efficace è coprire le superfici con un colore solido. Il team di darktable non si assume responsabilità per immagini anonimizzate in modo inadeguato che portino all'identificazione di individui o proprietà.[^censorize-manual][^release-36]

## Panoramica

Censorize si basa su una pipeline a tre stadi operante in RGB lineare:

1.  **Sfocatura iniziale**: Applica un primo passaggio di sfocatura gaussiana.
2.  **Pixellazione**: Crea "grandi pixel" sulla base dell'immagine sfocata.
3.  **Sfocatura finale e Rumore**: Applica una seconda sfocatura e aggiunge rumore di luminanza per mascherare i dettagli e rendere più difficile il riconoscimento da parte di algoritmi automatici.[^censorize-manual]

Oltre all'uso per la privacy, il modulo è versatile per scopi creativi, come la creazione di effetti "bloom" (effetto Orton) o l'aggiunta di grana artificiale, sfruttando la sua natura scene-referred e l'uso di blend modes.[^censorize-manual]

## Flusso di lavoro consigliato

L'approccio consigliato per l'anonimizzazione prevede di lavorare prima sulle maschere e poi sui parametri:[^censorize-manual]

1.  Lascia i controlli del modulo ai loro valori predefiniti.
2.  Disegna le maschere (drawn masks, shapes, ecc.) sulle aree dell'immagine che desideri censurare.
3.  Una volta mascherata l'area, regola i parametri di sfocatura e pixellazione per ottenere il livello di anonimizzazione desiderato.

Lasciare i parametri ai valori predefiniti durante la fase di mascheramento è fondamentale per poter visualizzare chiaramente i dettagli dell'immagine che stai selezionando.[^censorize-manual]

## Parametri principali

Il modulo offre quattro controlli principali per manipolare l'immagine. Poiché il manuale non fornisce range numerici specifici, i parametri vengono descritti qualitativamente.

| Parametro | Descrizione |
|-----------|-------------|
| **input blur radius** | Controlla la forza (intensità) del primo passaggio di sfocatura gaussiana applicato all'immagine originale.[^censorize-manual] |
| **pixellation radius** | Definisce la dimensione dei "grandi pixel" creati dopo il primo passaggio di sfocatura. Questo determina il livello di grossolanità della pixellazione.[^censorize-manual] |
| **output blur radius** | Controlla la forza del secondo passaggio di sfocatura gaussiana, applicato *dopo* la pixellazione. Serve ad ammorbidire i bordi dei pixel generati.[^censorize-manual] |
| **noise level** | Definisce la forza (deviazione standard) del rumore gaussiano di luminanza applicato dopo il secondo passaggio di sfocatura. L'aggiunta di rumore serve a simulare dettagli falsi nelle regioni sfocate e a rendere più difficile il rilevamento del contenuto da parte di algoritmi di intelligenza artificiale.[^censorize-manual] |

## Consigli e utilizzi creativi

Oltre alla censura classica, **censorize** può essere utilizzato in combinazione con le modalità di fusione (blend modes) per ottenere effetti creativi avanzati:[^censorize-manual]

### Effetto Bloom (Orton Effect)
Per creare un bagliore soffuso e dreamy:
1.  Applica una sfocatura con **censorize**.
2.  Imposta la modalità di fusione del modulo su **multiply** (moltiplica).
3.  Regola l'opacità per bilanciare l'effetto.[^censorize-manual]

### Unsharp Mask (Maschera di contrasto)
Per sharpening selettivo in spazio RGB scene-referred:
1.  Applica una sfocatura semplice.
2.  Imposta la modalità di fusione su **subtract** (sottrai).
3.  Usa un'opacità bassa.
Questo funziona in modo simile al modulo **sharpen**, ma operando nello spazio lineare.[^censorize-manual]

### Fusione con il resto dell'immagine
Se sfochi solo una parte dell'immagine, quella regione potrebbe risultare innaturalmente pulita rispetto al resto della fotografia (che contiene sempre un minimo di rumore). È buona norma aggiungere un po' di rumore sopra la parte sfocata per fonderla meglio con il resto. Questo può essere fatto usando direttamente il parametro **noise level** di **censorize** oppure il modulo **grain**.[^blurs-manual][^censorize-manual]

## Fonti

[^censorize-manual]: darktable user manual - censorize. URL: https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/censorize/#
[^blurs-manual]: darktable user manual - blurs. URL: https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/blurs/#
