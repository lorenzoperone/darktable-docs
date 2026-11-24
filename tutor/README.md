# dt_tutor — prototipo (Ondata I.10)

Pannello "tutor" nella camera oscura di darktable per le lezioni interattive della guida.

- `dt_tutor.lua` — il pannello (verifica via `dt.gui.action` in sola lettura, "mostrami" via `image:apply_sidecar`)
- `tutor_data.lua` — la lezione "flusso base in 5 passi" (stessa foto e stessi XMP di `docs/workflow/lezione-interattiva.md`)

Foto dell'esercizio: `docs/esercizi/raw/DSC08237.ARW` (importala in darktable, aprila in camera oscura, poi usa il pannello).

Stato: **non ancora provato in darktable** (va lanciato con la GUI, da fare quando il Mac è libero).
Punti da verificare: percorso `element = "enable"` per lo stato del modulo; `apply_sidecar` + ricarica della camera oscura.
