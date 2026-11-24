-- Lezione «Soluzione: il corridoio delle statue» per dt_tutor.lua — generato da i6_render_steps.py
-- Gli XMP di soluzione stanno nella stessa cartella di questo file.
local here = debug.getinfo(1, "S").source:sub(2):match("(.*/)") or "./"
return {
  slug = "esercizio-corridoio",
  title = "Soluzione: il corridoio delle statue",
  raw = "DSC08210.ARW",
  xmp_dir = here,
  steps = {
    { title = "Apertura", xmp = "passo-0.xmp", text = "Il RAW con i default scene-referred. All'apertura calibrazione colore stima l'illuminante dai metadati di scatto: un corpo nero a circa 4150 K. Il risultato è ancora caldo: il gesso tende all'arancio e le pareti rosse sono sature." },
    { title = "Bilanciamento", xmp = "passo-1.xmp", text = "Calibrazione colore, scheda CAT: temperatura dell'illuminante portata a 3600 K. Dire a darktable che la luce era più calda di quanto stimato aumenta la correzione: il gesso torna quasi neutro, ma resta un filo di calore, che è la luce reale del luogo. Con 3200 K il gesso diventa del tutto neutro e la scena perde atmosfera." },
    { title = "Prospettiva", xmp = "passo-2.xmp", text = "Rotazione e prospettiva: spostamento verticale +0,12, con la focale (9 mm) e il fattore di crop (2,7) della fotocamera e un ritaglio dei margini per eliminare i bordi vuoti. Gli spigoli dei piedistalli e l'infisso della finestra tornano verticali. In darktable conviene usare la correzione automatica sulle linee verticali, poi rifinire a occhio.", checks = { { module = "ashift", what = "rotazione e prospettiva" } } },
    { title = "Finestra e corridoio", xmp = "passo-3.xmp", text = "Equalizzatore toni, preset nativo «compress shadows/highlights | EIGF | soft»: abbassa un poco la finestra in fondo e apre il primo piano. Il preset morbido è sufficiente perché AgX ha già compresso le alte luci; uno più forte appiattirebbe la profondità del corridoio.", checks = { { module = "toneequal", what = "equalizzatore toni" } } },
  },
}
