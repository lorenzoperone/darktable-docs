-- Lezione «Lezione interattiva: il flusso base in 5 passi» per dt_tutor.lua — generato da i6_render_steps.py
-- Gli XMP di soluzione stanno nella stessa cartella di questo file.
local here = debug.getinfo(1, "S").source:sub(2):match("(.*/)") or "./"
return {
  slug = "flusso-base",
  title = "Lezione interattiva: il flusso base in 5 passi",
  raw = "DSC08237.ARW",
  xmp_dir = here,
  steps = {
    { title = "Apertura", xmp = "passo-0.xmp", text = "Il RAW come lo apre darktable con il flusso scene-referred: bilanciamento del bianco con adattamento cromatico in calibrazione colore, esposizione di partenza +0,7 EV e tone mapper AgX con il suo preset di default (qui è attiva anche la correzione obiettivo). L'immagine è corretta ma scura: i faretti sono già al limite, le ombre sono chiuse." },
    { title = "Esposizione", xmp = "passo-1.xmp", text = "Modulo esposizione: da +0,7 a +1,6 EV. Si imposta la luminosità dei toni medi (i rilievi) senza preoccuparsi delle luci: in scene-referred è il tone mapper (AgX) a comprimerle verso il bianco del monitor.", checks = { { path = "iop/exposure/exposure", element = "value", scale = { -3, 4 }, min = 1.2, max = 2.2, what = "esposizione (EV)" } } },
    { title = "Ombre e luci", xmp = "passo-2.xmp", text = "Equalizzatore tonale, preset nativo «compress shadows/highlights | EIGF | medium»: alza le ombre e abbassa le alte luci per zone, con una maschera guidata che preserva il contrasto locale. È l'equivalente ragionato di Ombre/Luci di Lightroom.", checks = { { module = "toneequal", what = "equalizzatore toni" } } },
    { title = "Contrasto locale", xmp = "passo-3.xmp", text = "Contrasto locale, preset nativo «clarity»: aumenta il dettaglio a media scala, qui la tridimensionalità degli intagli. Corrisponde a Chiarezza/Texture di Lightroom.", checks = { { module = "bilat", what = "contrasto locale" } } },
    { title = "Colore", xmp = "passo-4.xmp", text = "Bilanciamento colore RGB, preset nativo «basic colorfulness | vibrant colors»: aumenta vividezza, croma e saturazione lavorando in uno spazio percettivo, con un effetto più marcato sui colori poco saturi. È l'equivalente di Vividezza/Saturazione di Lightroom.", checks = { { module = "colorbalancergb", what = "bilanciamento colore RGB" } } },
  },
}
