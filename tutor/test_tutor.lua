-- Test automatico del tutor (I.10), generico per qualunque lezione installata.
-- Per ogni passo con verifiche: verifica (atteso ✗ sulla foto appena aperta),
-- «mostrami», verifica (atteso ✓). Esito in $DT_TUTOR_LOG; chiude darktable.
-- Lancio: darktable --configdir <tmp> --library :memory: --luacmd 'dofile("<repo>/tutor/test_tutor.lua")' <RAW>
local dt = require "darktable"
local LOG = os.getenv("DT_TUTOR_LOG") or "/tmp/dt_tutor_test.log"
local function log(m)
  local f = io.open(LOG, "a"); if f then f:write(os.date("%H:%M:%S ") .. m .. "\n"); f:close() end
end

log("avvio test — vista: " .. tostring(dt.gui.current_view().id))
dt.control.sleep(4000)
local api = dt_tutor_api
if not api then log("ERRORE: dt_tutor_api assente (tutor non caricato)"); log("FINE"); return end
log("lezione: " .. tostring(api.lesson.title) .. " — installato all'avvio: " .. tostring(api.installed()))
dt.gui.current_view(dt.gui.views.lighttable); dt.control.sleep(2500)
log("installato dopo cambio vista: " .. tostring(api.installed()))

local orig = dt.database[1]
-- protezione: sull'ORIGINALE «mostrami» deve rifiutarsi e non toccare la cronologia
dt.gui.selection({ orig })
local tries0 = 0
repeat
  dt.gui.current_view(dt.gui.views.darkroom); dt.control.sleep(1500); tries0 = tries0 + 1
until dt.gui.current_view().id == dt.gui.views.darkroom.id or tries0 >= 8
dt.gui.views.darkroom.display_image(orig); dt.control.sleep(3000)
api.goto_step(#api.lesson.steps); api.show_me(); dt.control.sleep(1500)
local guard_ok = api.result():find("duplica") ~= nil
log("protezione sull'originale: " .. (guard_ok and "OK (rifiutato)" or ("KO: " .. api.result())))
-- da qui si lavora su un duplicato, come farebbe lo studente
dt.gui.current_view(dt.gui.views.lighttable); dt.control.sleep(2000)
local img = orig:duplicate(); dt.control.sleep(1500)
log("duplicato creato: versione " .. tostring(img.duplicate_index))
dt.gui.selection({ img })
local tries = 0
repeat
  dt.gui.current_view(dt.gui.views.darkroom); dt.control.sleep(1500); tries = tries + 1
until dt.gui.current_view().id == dt.gui.views.darkroom.id or tries >= 8
dt.gui.views.darkroom.display_image(img); dt.control.sleep(4000)
log("in camera oscura: " .. img.filename)

local ok_all = true
for n, st in ipairs(api.lesson.steps) do
  if st.checks then
    api.goto_step(n); api.verify()
    local before = api.result()
    api.show_me(); dt.control.sleep(7000)
    api.goto_step(n); api.verify()
    local after = api.result()
    local good = after:find("^Passo riuscito") ~= nil
    ok_all = ok_all and good
    log(string.format("passo %d %s | prima: %s | dopo mostrami: %s | %s",
        n, st.title, before, after, good and "OK" or "KO"))
  end
end
ok_all = ok_all and guard_ok
log("ESITO: " .. (ok_all and "TUTTO OK" or "CI SONO KO"))
log("FINE")
dt.control.quit()
