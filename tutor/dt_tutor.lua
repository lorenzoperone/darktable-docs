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
local du = require "lib/dtutils"

du.check_min_api_version("9.0.0", "dt_tutor")

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

-- legge un controllo; nil se il percorso non esiste in questa versione
local function read(path, element)
  local v
  local okr = pcall(function() v = dt.gui.action(path, 0, element or "", "", 0) end)
  if okr and type(v) == "number" then return v end
  return nil
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
  local msgs, all = {}, true
  for _, c in ipairs(s.checks) do
    local v = read(c.path, c.element)
    local pass
    if v == nil then
      pass = false
      table.insert(msgs, "✗ " .. (c.what or c.path) .. ": non leggibile")
    else
      local lo, hi = c.min, c.max
      if lo == nil and hi == nil then pass = v > 0
      else pass = (lo == nil or v >= lo) and (hi == nil or v <= hi) end
      table.insert(msgs, string.format("%s %s = %.2f", pass and "✓" or "✗",
                                       c.what or c.path, v))
    end
    all = all and pass
  end
  w_result.label = (all and "Passo riuscito. " or "Non ancora. ") .. table.concat(msgs, " · ")
end

local function show_me()
  local s = lesson.steps[current]
  local img = dt.gui.views.darkroom.display_image()
  if not img or not s.xmp then return end
  local path = (lesson.xmp_dir or here) .. "/" .. s.xmp
  local oka, err = pcall(function() img:apply_sidecar(path) end)
  if oka then
    dt.gui.views.darkroom.display_image(img) -- ricarica la pipeline
    w_result.label = "Applicata la soluzione del passo " .. current
  else
    w_result.label = "Errore: " .. tostring(err)
  end
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

dt.register_lib(MODULE, "tutor", true, false,
  { [dt.gui.views.darkroom] = { "DT_UI_CONTAINER_PANEL_LEFT_CENTER", 100 } },
  panel, nil, nil)

show_step()
