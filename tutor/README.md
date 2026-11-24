# dt_tutor — tutor delle lezioni dentro darktable (prototipo, Ondata I.10)

Pannello "tutor" nella camera oscura di darktable per le lezioni interattive della guida: mostra l'istruzione del passo, **verifica** se lo studente l'ha eseguito e, su richiesta, **mostra** la soluzione applicando la cronologia XMP del passo.

- `dt_tutor.lua` — il pannello
- i dati di ogni lezione (`tutor_data.lua` + XMP dei passi) sono generati da `i6_render_steps.py` e pubblicati come zip in `docs/esercizi/kit/<lezione>.zip`, pronti da installare (vedi `LEGGIMI.txt` nello zip)
- `test_tutor.lua` — test automatico generico: per ogni passo con verifiche controlla ✗ prima e ✓ dopo «mostrami»

Lezioni disponibili: `flusso-base` (DSC08237), `esercizio-corridoio` (DSC08210), `esercizio-installazione` (DSC08239); foto in `docs/esercizi/raw/`.

## Installazione

1. Estrai lo zip della lezione in `~/.config/darktable/lua/` (crea `tutor-<lezione>/`).
2. In `~/.config/darktable/luarc` aggiungi: `require "tutor-<lezione>/dt_tutor"` (una riga per lezione).
3. Avvia darktable, apri la foto: il pannello **tutor** compare a sinistra nella camera oscura dopo il primo cambio di vista.

> **Attenzione:** "mostrami" sostituisce la cronologia dell'immagine: usalo sulla foto dell'esercizio, non sulle tue elaborazioni.

## Stato: provato su darktable 5.6.2 (macOS), 2026-11-24

Test automatico superato su tutte e tre le lezioni, installate dallo zip: installazione del pannello al primo cambio di vista, verifica cursore (esposizione ✗ a +0,70 EV, ✓ a +1,60 EV), verifica modulo (equalizzatore toni ✗ → ✓), "mostrami" applica la soluzione del passo.

Cose scoperte nel test (valgono per chi scrive altre lezioni):

| Problema | Soluzione adottata |
|---|---|
| `dt.register_lib` chiamato durante l'avvio (da `luarc`) manda in crash GTK | il pannello si registra al primo evento `view-changed` dopo l'avvio |
| `dt.gui.action(path, 0, "value", "", 0)` restituisce la **posizione normalizzata** 0..1 del cursore, non il valore | la lezione indica l'intervallo del cursore (`scale = { -3, 4 }` per l'esposizione) |
| La stessa lettura su un toggle (`element = "enable"`) **commuta** il modulo | lo stato dei moduli si legge dalla cronologia: stile temporaneo con `image:create_style()`, letto e cancellato |
| Nello stile i moduli hanno il **nome interno** (`toneequal`, `bilat`, `colorbalancergb`) | i check di modulo usano il nome interno |
| `image:apply_sidecar()` sull'immagine aperta in camera oscura si blocca | "mostrami" passa in lighttable, applica, torna in camera oscura (in un thread `dt.control.dispatch`) |

Limiti noti: il check di modulo verifica la presenza in cronologia, non che il modulo sia attivo o con quali parametri; l'intervallo `scale` dei cursori va ricavato a mano per ogni cursore.

## Test automatico

```sh
darktable --configdir <cartella-config-di-prova> --library :memory: \
  --luacmd 'dofile("<repo>/tutor/test_tutor.lua")' <repo>/docs/esercizi/raw/DSC08237.ARW
```

Con `DT_DOCS_REPO` e `DT_TUTOR_LOG` impostati. Conviene una cartella di configurazione minima (solo `data.db` e un `darktablerc` con `plugins/darkroom/workflow=scene-referred (AgX)`): con una configurazione completa partono anche gli script lua-scripts inclusi nel pacchetto, che rallentano o bloccano l'avvio. Cancella il sidecar `DSC08237.ARW.xmp` tra una prova e l'altra.
