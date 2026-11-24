-- Lezione "flusso base in 5 passi" per dt_tutor.lua (generata a mano per il PoC I.10).
-- Foto: DSC08237.ARW (gipsoteca). XMP di soluzione: docs/images/lezioni/flusso-base/
-- default: questa cartella sta in <repo>/tutor/ → XMP in <repo>/docs/images/lezioni/...
local here = debug.getinfo(1, "S").source:sub(2):match("(.*/)") or "./"
local repo = os.getenv("DT_DOCS_REPO") or (here .. "..")
return {
  title = "Flusso base in 5 passi",
  xmp_dir = repo .. "/docs/images/lezioni/flusso-base",
  steps = {
    { title = "Apertura", xmp = "passo-0.xmp",
      text = "Osserva la foto con i default scene-referred: è corretta ma scura. Nessuna azione: premi ▶." },
    { title = "Esposizione", xmp = "passo-1.xmp",
      text = "Modulo esposizione: porta il cursore esposizione tra +1,2 e +2,2 EV, guardando i rilievi (toni medi), non i faretti.",
      checks = { { path = "iop/exposure/exposure", min = 1.2, max = 2.2, what = "esposizione (EV)" } } },
    { title = "Ombre e luci", xmp = "passo-2.xmp",
      text = "Equalizzatore tonale: applica il preset «compress shadows/highlights | EIGF | medium».",
      checks = { { path = "iop/toneequal", element = "enable", what = "equalizzatore tonale attivo" } } },
    { title = "Contrasto locale", xmp = "passo-3.xmp",
      text = "Contrasto locale: applica il preset «clarity».",
      checks = { { path = "iop/bilat", element = "enable", what = "contrasto locale attivo" } } },
    { title = "Colore", xmp = "passo-4.xmp",
      text = "Bilanciamento colore RGB: applica il preset «basic colorfulness | vibrant colors».",
      checks = { { path = "iop/colorbalancergb", element = "enable", what = "bilanciamento colore RGB attivo" } } },
  },
}
