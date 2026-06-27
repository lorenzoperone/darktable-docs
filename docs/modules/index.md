# Moduli darktable

I moduli chiave del flusso di lavoro scene-referred, con parametri e consigli operativi.

Ogni scheda modulo riporta: funzione, parametri principali, consigli dai video-tutorial analizzati e riferimenti al manuale ufficiale.

## Moduli principali

| Modulo | Funzione | Frequenza nei tutorial |
|--------|----------|----------------------|
| [Exposure](exposure.md) | Posizionamento grigio medio | 12/12 video |
| [AgX](agx.md) | Tone mapping (default dt 5.4+) | 8/12 video |
| [Filmic RGB / Sigmoid](filmic-rgb.md) | Tone mapping alternativo | 12/12 video |
| [Color Calibration](color-calibration.md) | Adattamento cromatico CAT16 | 11/12 video |
| [Channel Mixer](channel-mixer.md) | Mix canali RGB (B&W, infrarosso) | 3 video |
| [Tone Equalizer](tone-equalizer.md) | Scultura della luce per zone | 10/12 video |
| [Denoise (profiled)](denoise.md) | Riduzione rumore | 6/12 video |
| [Maschere e blending](masking.md) | Editing selettivo | 11/12 video |

## Moduli di supporto

| Modulo | Funzione |
|--------|----------|
| **Color Balance RGB** | Color grading (vibrance, contrasto, ruote colore) |
| **[Color Equalizer](color-equalizer.md)** | Regolazione selettiva HSL per tonalita' |
| **Contrast Equalizer** | Nitidezza per scale wavelet |
| **[Diffuse or Sharpen](diffuse-sharpen.md)** | Nitidezza fisica / dehaze / bloom |
| **Local Contrast** | Contrasto locale rapido |
| **Lens Correction** | Distorsione, vignettatura, TCA |
| **Crop / Rotate** | Ritaglio e raddrizzamento |
| **Composite** | Fusione di livelli duplicati |

> Per la documentazione completa di tutti i moduli: [darktable User Manual -- Module Reference](https://docs.darktable.org/usermanual/development/en/module-reference/processing-modules/) | Copie locali in `processed/darktable-usermanual-en/`

