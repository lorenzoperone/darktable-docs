--[[
  dt_tutor.lua — prototipo "tutor" per le lezioni interattive (Ondata I.10)

  Pannello laterale nella camera oscura che guida una lezione passo per passo:
    • mostra titolo e istruzione del passo corrente;
    • «verifica»: legge lo stato dei controlli con dt.gui.action(..., 0)
      (velocità 0 = sola lettura) e confronta con le condizioni del passo;
    • «mostrami»: applica all'immagine l'XMP di soluzione di quel passo
      (image:apply_sidecar) — SOSTITUISCE la cronologia dell'immagine,
      da usare sulla foto dell'esercizio, non sulle proprie elaborazioni.

  Installazione (prototipo):
    1. copia questa cartella in ~/.config/darktable/lua/tutor/
    2. in ~/.config/darktable/luarc aggiungi:  require "tutor/dt_tutor"
    3. imposta la lezione:  DT_TUTOR_LESSON=/percorso/lezione/tutor_data.lua
       (default: tutor_data.lua accanto a questo file)

  Formato lezione (tutor_data.lua):
    return { title = "...", xmp_dir = "/percorso/xmp",
             steps = { { title = "...", text = "...", xmp = "passo-1.xmp",
                         checks = { { path = "iop/exposure/exposure",
                                      min = 1.2, max = 2.2, what = "esposizione" } } } } }
    Un check senza min/max verifica che il valore sia > 0 (es. modulo attivo).
]]

local dt = require "darktable"

local MODULE = "dt_tutor"
local here = debug.getinfo(1, "S").source:sub(2):match("(.*/)") or "./"
local lesson_file = os.getenv("DT_TUTOR_LESSON") or (here .. "tutor_data.lua")

local ok, lesson = pcall(dofile, lesson_file)
if not ok or type(lesson) ~= "table" then
  dt.print_error("[tutor] lezione non caricata: " .. tostring(lesson))
  return
end

local current = 1

local w_title = dt.new_widget("label") { label = "", ellipsize = "end" }
local w_text = dt.new_widget("text_view") { text = "", editable = false }
local w_result = dt.new_widget("label") { label = "" }

-- Cursore: dt.gui.action(..., 0) restituisce la POSIZIONE normalizzata 0..1
-- del cursore (verificato su 5.6.2: exposure +0,7 EV → 0,529 su −3..+4 EV);
-- la lezione indica l'intervallo del cursore (`scale`) per riportarla al valore.
-- Attenzione: sui toggle (element "enable") la stessa chiamata COMMUTA il
-- modulo, quindi lo stato dei moduli si legge dalla cronologia (vedi sotto).
local function read_slider(path, element, scale)
  local v
  local okr = pcall(function() v = dt.gui.action(path, 0, element or "value", "", 0) end)
  if not okr or type(v) ~= "number" or v ~= v then return nil end
  if scale then v = scale[1] + v * (scale[2] - scale[1]) end
  return v
end

-- moduli presenti nella cronologia: stile temporaneo creato dall'immagine,
-- letto e cancellato (nessuna modifica all'immagine)
local function history_modules(img)
  local names = {}
  local st
  local okc = pcall(function() st = img:create_style("__dt_tutor_tmp", "") end)
  if not okc or not st then return nil end
  for _, item in ipairs(st) do names[#names + 1] = string.lower(item.name) end
  pcall(function() st:delete() end)
  return names
end

local function has_module(names, module)
  for _, n in ipairs(names) do
    if n:find(module, 1, true) then return true end
  end
  return false
end

local function show_step()
  local s = lesson.steps[current]
  w_title.label = string.format("%d/%d — %s", current, #lesson.steps, s.title)
  w_text.text = s.text or ""
  w_result.label = ""
end

local function verify()
  local s = lesson.steps[current]
  if not s.checks or #s.checks == 0 then
    w_result.label = "nessuna verifica per questo passo"
    return
  end
  local img = dt.gui.views.darkroom.display_image()
  local mods = img and history_modules(img)
  local msgs, all = {}, true
  for _, c in ipairs(s.checks) do
    local pass, shown
    if c.module then
      pass = mods ~= nil and has_module(mods, c.module)
      shown = pass and "nella cronologia" or "non ancora applicato"
    else
      local v = read_slider(c.path, c.element, c.scale)
      if v == nil then
        pass, shown = false, "non leggibile"
      else
        pass = (c.min == nil or v >= c.min) and (c.max == nil or v <= c.max)
        shown = string.format("%.2f", v)
      end
    end
    table.insert(msgs, string.format("%s %s: %s", pass and "✓" or "✗", c.what or c.module or c.path, shown))
    all = all and pass
  end
  w_result.label = (all and "Passo riuscito. " or "Non ancora. ") .. table.concat(msgs, " · ")
end

-- «mostrami»: apply_sidecar sull'immagine aperta in camera oscura si blocca
-- (verificato su 5.6.2) → si passa in lighttable, si applica, si torna indietro.
-- Gira in un thread Lua separato per poter attendere i cambi di vista.
local function show_me()
  local s = lesson.steps[current]
  local img = dt.gui.views.darkroom.display_image()
  if not img or not s.xmp then return end
  local path = (lesson.xmp_dir or here) .. "/" .. s.xmp
  local n = current
  w_result.label = "Applico la soluzione del passo " .. n .. "…"
  dt.control.dispatch(function()
    dt.gui.current_view(dt.gui.views.lighttable)
    dt.control.sleep(1500)
    local oka, err = pcall(function() img:apply_sidecar(path) end)
    dt.control.sleep(500)
    dt.gui.current_view(dt.gui.views.darkroom)
    dt.control.sleep(1500)
    dt.gui.views.darkroom.display_image(img)
    w_result.label = oka and ("Applicata la soluzione del passo " .. n)
                         or ("Errore: " .. tostring(err))
  end)
end

local function go(delta)
  current = math.max(1, math.min(#lesson.steps, current + delta))
  show_step()
end

local panel = dt.new_widget("box") {
  orientation = "vertical",
  dt.new_widget("label") { label = lesson.title or "lezione" },
  w_title,
  w_text,
  dt.new_widget("box") {
    orientation = "horizontal",
    dt.new_widget("button") { label = "◀", clicked_callback = function() go(-1) end },
    dt.new_widget("button") { label = "verifica", clicked_callback = verify },
    dt.new_widget("button") { label = "mostrami", clicked_callback = show_me },
    dt.new_widget("button") { label = "▶", clicked_callback = function() go(1) end },
  },
  w_result,
}

-- Registrare il pannello durante l'avvio di darktable (da luarc) manda in crash
-- GTK: register_lib provoca un cambio vista mentre l'interfaccia non è pronta
-- (verificato su 5.6.2). Come negli script ufficiali lua-scripts, il pannello
-- si installa al primo cambio di vista dopo l'avvio, a interfaccia pronta.
local installed = false
local function install()
  if installed then return end
  installed = true
  dt.register_lib(MODULE, "tutor", true, false,
    { [dt.gui.views.darkroom] = { "DT_UI_CONTAINER_PANEL_LEFT_CENTER", 100 } },
    panel, nil, nil)
end

dt.register_event(MODULE, "view-changed", function(_, old_view, new_view)
  if old_view ~= nil then install() end
end)

show_step()

-- interfaccia per i test automatici (tutor/test_tutor.lua)
dt_tutor_api = {
  go = go, verify = verify, show_me = show_me, install = install,
  installed = function() return installed end,
  history = function()
    local img = dt.gui.views.darkroom.display_image()
    local m = img and history_modules(img)
    return m and table.concat(m, ", ") or "nil"
  end,
  goto_step = function(n) current = n; show_step() end,
  result = function() return w_result.label end,
  title = function() return w_title.label end,
}
