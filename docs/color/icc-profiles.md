# Profili ICC

I profili ICC definiscono come i colori vengono interpretati e convertiti tra dispositivi (fotocamera, monitor, stampante) [^manual-icc]. Un profilo ICC è una mappa matematica che descrive la relazione tra i valori numerici dei pixel e i colori percepiti dall’occhio umano in un determinato contesto di illuminazione e dispositivo. In darktable, i profili non sono semplici “filtri cromatici”, ma componenti fondamentali della pipeline di elaborazione scene-referred: agiscono *prima* di qualsiasi correzione tonale o cromatica, stabilendo il punto di partenza fisico e misurabile per ogni operazione successiva [^pipeline].

## Profili in darktable

### Input Color Profile

| Profilo | Uso | Note tecniche |
|---------|-----|--------------|
| **Embedded matrix** | Default, usa i dati EXIF della fotocamera | Applica la matrice colore standard per il modello specifico (es. `Canon EOS R5`), basata su misure CIE 1931 XYZ. Valore predefinito: `embedded matrix` — non modificabile se l’immagine contiene dati EXIF validi [^input-profile-manual]. |
| **Linear Rec 2020 RGB** | Consigliato per il workflow scene-referred [^pipeline] | Spazio lineare con primari CIE 1931 x=0.708, y=0.292 (rosso), x=0.170, y=0.797 (verde), x=0.131, y=0.046 (blu); gamma = 1.0. Gamut più ampio di AdobeRGB (+33% area nel diagramma CIE xy), ideale per immagini HDR e per preservare dettagli nelle alte luci [^linear-rec2020-video]. |
| **Profilo fotocamera personalizzato** | Creato con color checker e darktable Chart [^pixls-profiling] | Richiede l’uso del modulo `color calibration` con opzione *calibrate with a color checker*. Il profilo viene salvato in `$HOME/.config/darktable/color/in/` e richiede l’attivazione di `unbreak input profile` per essere applicato correttamente [^input-profile-manual]. |

!!! info "Non modificare"
    Il modulo Input Color Profile e' generalmente da lasciare ai valori predefiniti nel workflow scene-referred [^pipeline]. Modifiche manuali (es. passare da `embedded matrix` a `Linear Rec 2020`) devono essere giustificate da test empirici: un cambio di spazio di ingresso altera direttamente i coefficienti RGB usati dai moduli successivi (`white balance`, `filmic rgb`, `color calibration`). Se si modifica l’input profile, è obbligatorio ricalibrare il white balance e verificare la coerenza del gamut con `soft proof` [^input-profile-manual].

### Output Color Profile

| Destinazione | Profilo consigliato | Parametri chiave |
|-------------|-------------------|------------------|
| **Web / social** | sRGB IEC61966-2.1 | Gamma = 2.2, primari CIE 1931 x=0.640, y=0.330 (R), x=0.300, y=0.600 (G), x=0.150, y=0.060 (B). Range: 0–100% luminanza. Rendering intent: *perceptual* (default) o *relative colorimetric* per massima fedeltà [^output-profile-manual]. |
| **Stampa offset** | AdobeRGB (1998) | Gamma = 2.2, primari più saturi rispetto a sRGB: x=0.640, y=0.330 (R), x=0.210, y=0.710 (G), x=0.150, y=0.060 (B). Gamut ~50% più ampio di sRGB, adatto a stampe su carta patinata [^linear-rec2020-video]. |
| **Stampante specifica** | Profilo ICC della stampante | Deve essere installato in `$HOME/.config/darktable/color/out/`. Per funzionare correttamente richiede un `soft proof` con lo stesso profilo e rendering intent *relative colorimetric* [^output-profile-manual]. |
| **Archivio master** | ProPhoto RGB | Gamma = 1.8, primari estremi: x=0.7347, y=0.2653 (R), x=0.1596, y=0.8404 (G), x=0.0366, y=0.0001 (B). Gamut teorico >90% dello spettro visibile — ma **non lineare**: introduce artefatti nei calcoli tonali se usato come spazio di lavoro [^pixls-lab]. Non usare come *working profile*: è valido solo come output per archiviazione lossless [^pixls-lab]. |

### Soft Proof

La funzione **Soft Proof** simula sullo schermo come apparirà l'immagine con un profilo di output specifico, permettendo di individuare colori fuori gamut prima dell'esportazione [^manual-icc].  
Per attivarla:  
- Abilitare il modulo `soft proof` nella pipeline  
- Selezionare il profilo target (es. `sRGB IEC61966-2.1`)  
- Impostare `rendering intent`:  
  - `perceptual` (default): comprime tutto il gamut in modo uniforme — migliore per immagini fotografiche [^output-profile-manual]  
  - `relative colorimetric`: mappa 1:1 i colori entro gamut, taglia quelli fuori — ideale per controllo tecnico [^output-profile-manual]  
- Attivare `gamut check` (icona occhio) per evidenziare in rosso le aree fuori gamut  

> Per la profilazione avanzata della fotocamera: *PIXLS.US -- Profiling a Camera with darktable Chart* [^pixls-profiling] con color checker e calibrazione.  
> La documentazione ufficiale sulla gestione del colore copre in dettaglio i flussi ICC, i rendering intent e la soft proof [^manual-colormgmt].

## Flusso di lavoro scene-referred con profili ICC

Un workflow ICC coerente in darktable segue una sequenza rigorosa di conversioni:

1. **Input → Working space**: `input color profile` converte i dati RAW (sensor-specific) nello spazio di lavoro lineare (`Linear Rec 2020 RGB` di default)  
2. **Elaborazione scene-referred**: tutti i moduli (`exposure`, `filmic rgb`, `color calibration`) operano in questo spazio lineare, dove i valori RGB sono proporzionali all’energia luminosa catturata [^pixls-lab]  
3. **Working → Output**: `output color profile` converte dallo spazio di lavoro allo spazio di destinazione (es. sRGB) usando il rendering intent scelto  
4. **Output → Display**: il sistema operativo applica il profilo del monitor (gestito esternamente) per la visualizzazione finale  

Questo flusso garantisce che:  
- Le correzioni tonali (es. `filmic rgb`) siano fisicamente corrette: la compressione delle alte luci avviene su valori proporzionali ai fotoni, non a valori percettivi distorti [^pixls-lab]  
- Le maschere parametriche (es. `JzCzhz`) mantengano coerenza cromatica: i canali `J`, `z`, `h` sono derivati da `Linear Rec 2020`, non da sRGB [^channel-mixer-video]  
- Il bilanciamento del bianco sia stabile: `color calibration` opera su dati lineari, evitando errori di propagazione presenti negli spazi non lineari [^color-calibration-manual]  

## Parametri dettagliati dei moduli ICC

### Input Color Profile — Controlli avanzati

| Controllo | Descrizione | Valori tipici | Fonte |
|-----------|-------------|---------------|--------|
| `input profile` | Profilo di ingresso applicato | `embedded matrix` (default), `Linear Rec 2020 RGB`, `Adobe RGB (compatible)`, `sRGB` | [^input-profile-manual] |
| `working profile` | Spazio di lavoro interno | `Linear Rec 2020 RGB` (default), `ProPhoto RGB`, `Adobe RGB (compatible)` | [^input-profile-manual] |
| `gamut clipping` | Meccanismo di limitazione del gamut | `off` (default), `sRGB`, `linear Rec. 709 RGB`, `Adobe RGB (compatible)`, `linear Rec. 2020 RGB` | [^input-profile-manual] |

- **Gamut clipping**: attivare solo se compaiono artefatti cromatici (es. pixel neri in luci blu intense). `linear Rec. 2020 RGB` offre il clipping più morbido, mentre `sRGB` è il più aggressivo [^input-profile-manual].  
- **Custom input profiles**: devono essere salvati in `$HOME/.config/darktable/color/in/` (cartella da creare manualmente) e richiedono l’attivazione del modulo `unbreak input profile` per essere riconosciuti [^input-profile-manual].

### Output Color Profile — Controlli avanzati

| Controllo | Descrizione | Valori tipici | Fonte |
|-----------|-------------|---------------|--------|
| `output profile` | Profilo di destinazione | `sRGB IEC61966-2.1`, `Adobe RGB (1998)`, `ProPhoto RGB`, `Filmic RGB (scene-referred default)` | [^output-profile-manual] |
| `intent` | Strategia di mappatura gamut | `perceptual` (default), `relative colorimetric`, `saturation`, `absolute colorimetric` | [^output-profile-manual] |
| `export profile` | Profilo incorporato nel file esportato | `same as output profile` (default), `custom ICC` | [^output-profile-manual] |

- **Rendering intent**:  
  - `perceptual`: riduce la saturazione globale per mantenere le relazioni cromatiche — ideale per web [^output-profile-manual]  
  - `relative colorimetric`: mappa i colori entro gamut 1:1, taglia quelli fuori — essenziale per stampa professionale [^output-profile-manual]  
- **Export profile**: se diverso da `output profile`, il file esportato contiene due profili: uno per la visualizzazione (`output profile`) e uno per l’archiviazione (`export profile`) [^output-profile-manual].

## Consigli operativi per utenti Lightroom/Photoshop

!!! tip "Transizione da Lightroom"
    Lightroom usa uno spazio di lavoro *display-referred* (ProPhoto RGB con gamma 1.8). In darktable, **non sostituire mai `Linear Rec 2020` con `ProPhoto RGB` come working profile**: ProPhoto non è lineare e rompe la fisica della pipeline scene-referred [^pixls-lab]. Usa `Linear Rec 2020` per editing e `ProPhoto RGB` *solo* come output per archiviazione [^pixls-lab].

!!! warning "Errori comuni"
    - **Applicare `sRGB` come input profile su RAW**: causa perdita di dinamica e artefatti nei verdi — `sRGB` è valido solo per JPEG importati [^input-profile-manual].  
    - **Usare `ProPhoto RGB` come working profile**: introduce errori di interpolazione nei moduli di mascheratura (`JzCzhz`, `LAB`) e distorsioni nella curva `filmic rgb` [^pixls-lab].  
    - **Disattivare `soft proof` prima dell’esportazione**: senza verifica, fino al 30% dei colori può risultare fuori gamut su schermi sRGB [^output-profile-manual].

### Workflow ottimizzato per immagini RAW

1. **Fase 1 — Neutralità iniziale**:  
   - Lasciare `input color profile` su `embedded matrix`  
   - Usare `white balance` → `camera reference` (non `as shot`)  
   - Regolare `exposure` per centrare l’istogramma sui mezzi toni (EV 0.0)  

2. **Fase 2 — Mappatura dinamica**:  
   - Impostare `filmic rgb` → scheda `scene`:  
     - `white relative exposure`: +3.00 a +6.00 EV (dipende dalla scena)  
     - `black relative exposure`: -5.00 a -8.00 EV  
     - `dynamic range scaling`: 0.00% (default)  
   - Scheda `look`: `latitude` 70–90%, `contrast` 1.2–1.5  

3. **Fase 3 — Correzione cromatica precisa**:  
   - Usare `color calibration` → scheda `CAT`:  
     - `illuminant`: `(AI) detect from image surfaces` (più robusto per scene artificiali)  
     - `adaptation`: `CAT16 (2016)` (default, più accurato di Bradford per gamut ampi)  
     - `gamut compression`: 1.00 (disattivato)  
   - Evitare `color balance rgb` prima di `color calibration`: i due moduli operano in spazi diversi e generano conflitti [^color-calibration-manual].

4. **Fase 4 — Output finale**:  
   - `output color profile`: scegliere in base alla destinazione (vedi tabella sopra)  
   - `soft proof` attivo con `gamut check`  
   - Esportare in TIFF 16-bit con `embed ICC profile` abilitato  

## Risorse pratiche

- **Creazione di profili custom**: Guida passo-passo con darktable Chart e X-Rite ColorChecker Passport [^pixls-profiling]  
- **Verifica monitor**: Strumento integrato `tools > preferences > color management > display calibration` per generare un profilo VCGT [^manual-colormgmt]  
- **Test gamut**: Immagini di riferimento con patch CIE Lab (disponibili su [pixls.us/test-images](https://pixls.us/test-images/))  
- **Presets preconfigurati**: Pacchetto `scene-referred-workflow.dtstyle` scaricabile da [darktable.org/styles](https://darktable.org/styles/)  

## Fonti

[^manual-icc]: *darktable User Manual -- Input/Output Color Profile*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/input-color-profile/)
[^manual-colormgmt]: *darktable User Manual -- Color Management*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/special-topics/color-management/) | `processed/darktable-usermanual-en/usermanual-48-en-special-topics-color-management-*.md`
[^pipeline]: *[The darktable pipeline for beginners](https://www.youtube.com/watch?v=1nPW6WPhhTo)* -- A Dabble in Photography
[^pixls-profiling]: *PIXLS.US -- Profiling a Camera with darktable Chart*, [pixls.us](https://pixls.us/articles/profiling-a-camera-with-darktable-chart/) | `processed/pixls-articles/articles-profiling-a-camera-with-darktable-chart.md`
[^input-profile-manual]: *darktable user manual - input color profile*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/input-color-profile/)
[^output-profile-manual]: *darktable user manual - output color profile*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/output-color-profile/)
[^linear-rec2020-video]: *[ENG] Linear Rec2020*, A Dabble in Photography, [youtube.com/watch?v=DsZYv_aRWjE](https://www.youtube.com/watch?v=DsZYv_aRWjE)
[^pixls-lab]: *PIXLS.US -- Darktable 3:RGB or Lab? Which Modules? Help!*, [pixls.us/articles/darktable-3-rgb-or-lab-which-modules-help/](https://pixls.us/articles/darktable-3-rgb-or-lab-which-modules-help/)
[^color-calibration-manual]: *darktable user manual - color calibration*, [docs.darktable.org](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/color-calibration/)
[^channel-mixer-video]: *[ENG] Channel Mixer Part 2*, A Dabble in Photography, [youtube.com/watch?v=QX_HItCqDtE](https://www.youtube.com/watch?v=QX_HItCqDtE)
