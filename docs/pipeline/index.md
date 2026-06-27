# Il pixelpipe

In darktable non esistono "livelli" come in Photoshop né uno storico di azioni distruttive come in molti editor. Ogni modifica è un **modulo** che elabora i pixel in un ordine fisso e prevedibile: il **pixelpipe** (o *pixel pipeline*). Capire come funziona è il salto concettuale più importante per chi arriva da Lightroom — perché spiega *perché* le regolazioni vanno messe in un certo ordine e *perché* due moduli apparentemente simili danno risultati diversi a seconda di dove agiscono.

!!! info "L'idea in una riga"
    darktable non "applica filtri sull'immagine visualizzata": costruisce una **catena di elaborazione** che parte dai dati grezzi del sensore (scene-referred, lineari rispetto alla luce) e arriva all'immagine finale (display-referred). L'ordine dei moduli nella catena conta.

## Perché l'ordine conta

I moduli **non** vengono applicati nell'ordine in cui li attivi, ma in un **ordine interno fisso** (il *module order*), pensato perché ogni operazione lavori sui dati nello stato più adatto. Per esempio: la riduzione del rumore agisce presto, sui dati lineari del sensore; il tone mapping (*filmic rgb*, *sigmoid*, *agx*) comprime la gamma dinamica più a valle; il color grading creativo arriva ancora dopo.

Questo è anche il motivo per cui la guida raccomanda una [sequenza di lavoro](../workflow/index.md) precisa: non è una preferenza stilistica, ma l'allineamento col modo in cui il pixelpipe tratta i dati.

## Le pagine di questa sezione

- **[Il pixelpipe e l'ordine dei moduli](module-order.md)** — come è strutturata la catena, i preset di ordine versionati (*v5.0*, *v3.0*) e quando cambiarli.
- **[Anatomia di un modulo](anatomia-modulo.md)** — header, controlli, attivazione, e cosa significano le icone di ogni modulo.
- **[Cronologia (history stack)](history-stack.md)** — come darktable registra ogni modifica in modo non distruttivo, la compressione della cronologia e undo/redo.
- **[Preset e istanze multiple](preset-istanze.md)** — salvare configurazioni riutilizzabili e applicare lo stesso modulo più volte con maschere diverse.

!!! tip "Non distruttivo per design"
    Tutte le modifiche sono parametri salvati in un file collaterale `.xmp` accanto al RAW: l'originale non viene mai toccato. Puoi tornare indietro su qualsiasi passo in qualsiasi momento — vedi [cronologia](history-stack.md).
