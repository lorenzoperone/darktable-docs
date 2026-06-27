# Maschere e selezioni

Le maschere sono lo strumento che trasforma darktable in un editor di precisione chirurgica. Ogni modulo puo' essere applicato non all'intera immagine ma solo a una porzione.[^manual]

## Tipi di maschere

- [Maschere disegnate](drawn.md) -- Forme tracciate direttamente sull'immagine
- [Maschere parametriche](parametric.md) -- Selezione automatica per luminosita'/colore
- [Combinare le maschere](combining.md) -- Drawn + Parametric + Raster + AI

## Principi generali

!!! tip "Dove creare le maschere"
    Creare le maschere nel modulo piu' basso della pipeline (es. Exposure) per riusarle come raster mask in tutti i moduli a valle. Questo massimizza la compatibilita'.[^dt54][^landscape]

!!! tip "Visualizzazione"
    Premere ++m++ per mostrare/nascondere l'overlay della maschera. Premere ++c++ sullo slider parametrico per vedere il canale in scala di grigi.[^manual]

!!! info "Non serve la perfezione"
    Il feathering graduale tra maschera e sfondo nasconde le imperfezioni dei bordi, rendendo la precisione pixel-perfect non necessaria.[^aimasks]

> La documentazione ufficiale copre in dettaglio tutti i tipi di maschera, i blend modes e le opzioni di raffinamento.[^manual]
>
> La serie di 7 video di Bruce Williams Photography e' la risorsa piu' completa sulle maschere in darktable.[^bruce-williams]
>
> Il tutorial PIXLS.US sulla *Luminosity Masking* offre un approccio pratico alla selezione per luminanza.[^pixls-luminosity]

## Fonti

[^manual]: *darktable User Manual -- Masking and Blending*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/darkroom/masking-and-blending/) | `processed/darktable-usermanual-en/usermanual-48-en-darkroom-masking-and-blending-*.md`
[^dt54]: *[darktable 5.4 UPDATE](https://www.youtube.com/watch?v=yiTqUgoWg6Q)* -- A Dabble in Photography
[^landscape]: *[Landscape edit with AI](https://www.youtube.com/watch?v=OERXOFz9lEo)* -- A Dabble in Photography
[^aimasks]: *[AI masks in darktable](https://www.youtube.com/watch?v=7yd5riDmUjk)* -- A Dabble in Photography
[^bruce-williams]: Bruce Williams Photography, *Masks Part 1-7* -- Serie completa YouTube
[^pixls-luminosity]: *PIXLS.US -- Luminosity Masking in Darktable*, [pixls.us](https://pixls.us/articles/luminosity-masking-in-darktable/) | `processed/pixls-articles/articles-luminosity-masking-in-darktable.md`
