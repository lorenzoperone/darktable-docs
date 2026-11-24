-- Lezione «Soluzione: l'installazione al buio» per dt_tutor.lua — generato da i6_render_steps.py
-- Gli XMP di soluzione stanno nella stessa cartella di questo file.
local here = debug.getinfo(1, "S").source:sub(2):match("(.*/)") or "./"
return {
  slug = "esercizio-installazione",
  title = "Soluzione: l'installazione al buio",
  raw = "DSC08239.ARW",
  xmp_dir = here,
  steps = {
    { title = "Apertura", xmp = "passo-0.xmp", text = "Il RAW con i default scene-referred. Calibrazione colore stima un illuminante intermedio (corpo nero a circa 4150 K) tra la luce calda della sala e quella fredda dei proiettori: nessuna delle due è davvero neutra. La sala è buia e l'installazione occupa una piccola parte dell'inquadratura." },
    { title = "Bilanciamento", xmp = "passo-1.xmp", text = "Calibrazione colore, scheda CAT: illuminante a 3400 K, cioè riferimento sulla luce calda della sala. Legno e casse tornano quasi neutri, le superfici illuminate dai proiettori virano leggermente al freddo. Il contrasto caldo/freddo diventa uno strumento: separa l'installazione dall'ambiente. Prova anche la scelta opposta (riferimento sui proiettori, circa 5500 K) e confronta." },
    { title = "Esposizione", xmp = "passo-2.xmp", text = "Esposizione da +0,7 a +1,3 EV, giudicando l'installazione e non le proiezioni, che AgX comprime verso il bianco. La sala si schiarisce insieme al resto: la si riporterà indietro nel passo successivo.", checks = { { path = "iop/exposure/exposure", element = "value", scale = { -3, 4 }, min = 1.0, max = 1.8, what = "esposizione (EV)" } } },
    { title = "Guidare lo sguardo", xmp = "passo-3.xmp", text = "Equalizzatore toni, preset nativo «compress shadows/highlights | EIGF | medium»: contiene le proiezioni più luminose e solleva le casse in ombra. Per abbassare la sala rispetto all'installazione si possono poi aggiungere nodi negativi sulle ombre profonde, o una vignettatura leggera.", checks = { { module = "toneequal", what = "equalizzatore toni" } } },
    { title = "Rumore", xmp = "passo-4.xmp", text = "Riduzione rumore (profilato), preset nativo «wavelets: chroma only»: a ISO 3200 le ombre mostrano macchie di colore; questo preset agisce solo sul rumore cromatico e lascia intatta la grana di luminanza, quindi non impasta le texture delle casse. Valuta il risultato al 100%.", checks = { { module = "denoiseprofile", what = "riduzione rumore" } } },
  },
}
