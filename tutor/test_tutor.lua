-- Test automatico del tutor (I.10). Lancio:
--   darktable --configdir <tmp> --library :memory: --luacmd 'dofile("<repo>/tutor/test_tutor.lua")' <RAW>
-- Scrive l'esito in $DT_TUTOR_LOG (default /tmp/dt_tutor_test.log) e chiude darktable.
local dt = require "darktable"
local LOG = os.getenv("DT_TUTOR_LOG") or "/tmp/dt_tutor_test.log"
local function log(m)
  local f = io.open(LOG, "a"); if f then f:write(os.date("%H:%M:%S ") .. m .. "\n"); f:close() end
end
local function read(path, el)
  local v; pcall(function() v = dt.gui.action(path, 0, el or "", "", 0) end); return v
end

log("avvio test — vista: " .. tostring(dt.gui.current_view().id))
dt.control.sleep(4000)
-- a interfaccia avviata (in lighttable) installa il pannello se non è già fatto
-- percorso reale: il pannello si installa al primo cambio di vista
log("pannello installato all'avvio: " .. tostring(dt_tutor_api and dt_tutor_api.installed()))
dt.gui.current_view(dt.gui.views.lighttable); dt.control.sleep(2500)
log("pannello installato dopo cambio vista: " .. tostring(dt_tutor_api and dt_tutor_api.installed()))
-- porta la prima immagine della libreria in camera oscura
local img = dt.database[1]
if not img then log("ERRORE: nessuna immagine nella libreria"); log("FINE"); return end
dt.gui.selection({ img })
local tries = 0
repeat  -- stessa sequenza dei runner g5: il cambio vista può richiedere più tentativi
  dt.gui.current_view(dt.gui.views.darkroom)
  dt.control.sleep(1500)
  tries = tries + 1
until dt.gui.current_view().id == dt.gui.views.darkroom.id or tries >= 8
dt.gui.views.darkroom.display_image(img)
dt.control.sleep(4000)
log("vista dopo attesa: " .. tostring(dt.gui.current_view().id) .. " — immagine: " .. img.filename)
local api = dt_tutor_api
if not api then log("ERRORE: dt_tutor_api assente (tutor non caricato)"); log("FINE"); return end
log("pannello: " .. api.title())

-- passo 2 (esposizione): prima della modifica deve fallire
api.goto_step(2); api.verify(); log("passo 2 prima: " .. api.result())
pcall(dt.gui.action, "iop/exposure/exposure", 0, "value", "set", 1.6)
dt.control.sleep(1500)
api.verify(); log("passo 2 dopo set 1.6: " .. api.result())

-- passo 3 (equalizzatore toni): verifica, poi «mostrami», poi verifica
log("cronologia prima: " .. api.history())
api.goto_step(3); api.verify(); log("passo 3 prima: " .. api.result())
api.show_me(); dt.control.sleep(7000)
log("mostrami: " .. api.result())
log("cronologia dopo: " .. api.history())
api.verify(); log("passo 3 dopo mostrami: " .. api.result())
api.goto_step(2); api.verify(); log("passo 2 dopo mostrami (atteso ✓, la soluzione 3 include esposizione 1.6): " .. api.result())

-- segnale per lo screenshot esterno, poi attesa e chiusura
log("PRONTO-SCREENSHOT"); dt.control.sleep(5000)
log("FINE")
dt.control.quit()
