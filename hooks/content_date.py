"""
Hook MkDocs: sovrascrive la data mostrata nel footer ("Ultima modifica")
con la data dell'ultimo commit che ha cambiato il CONTENUTO della pagina,
saltando i commit di manutenzione strutturale (Mermaid, lint, formatting…).

Logica: scorre il git log del file dal più recente al più vecchio;
usa il primo commit il cui messaggio NON corrisponde a nessun pattern
di esclusione. Fallback al commit più recente se tutti vengono esclusi.
"""
import os
import re
import subprocess
from datetime import datetime

MONTHS_IT = [
    "", "gennaio", "febbraio", "marzo", "aprile", "maggio", "giugno",
    "luglio", "agosto", "settembre", "ottobre", "novembre", "dicembre",
]

# Messaggi di commit che NON indicano una modifica al contenuto testuale.
# Ordine: dal più specifico al più generico.
NON_CONTENT_RE = re.compile(
    r"mermaid"               # tutto ciò che riguarda diagrammi Mermaid
    r"|reformatt"            # riformattazione
    r"|ridisegna"            # ridisegno grafico
    r"|ascii[\s\-]?art"      # conversione ASCII art
    r"|converti.*diagramm"   # conversione diagrammi
    r"|\blinter?\b"          # passate linter
    r"|footnot"              # fix footnote (orfane, duplicate, auto-ref)
    r"|\bstylesh"            # stylesheet CSS
    r"|\bcss\b"              # file CSS
    r"|\bjavascript\b"       # file JS
    r"|\bplugin\b"           # plugin MkDocs
    r"|mkdocs"               # configurazione mkdocs.yml
    r"|\btypo\b"             # correzioni di battitura isolate
    r"|nav.*order"           # riordino navigazione
    r"|screenshot.*path"     # fix percorsi screenshot
    r"|link.*rott"           # fix link rotti
    r"|brand.*minusc"        # fix brand capitalizzazione
    r"|remove.*plugin"       # rimozione plugin
    r"|fix.*diagramm"        # fix layout diagrammi
    r"|pulsante.*segnala"    # UI pulsante segnala
    ,
    re.IGNORECASE,
)


def _format_date_it(date_str: str) -> str:
    """Converte 'YYYY-MM-DD' in 'D mese YYYY' (italiano)."""
    d = datetime.strptime(date_str, "%Y-%m-%d")
    return f"{d.day} {MONTHS_IT[d.month]} {d.year}"


def _get_content_date(abs_path: str, repo_root: str) -> str | None:
    """
    Restituisce la data (YYYY-MM-DD) del commit più recente che ha
    modificato il contenuto della pagina, o None se non trovato.
    """
    try:
        result = subprocess.run(
            [
                "git", "log", "--follow",
                "--format=%ad|||%s",
                "--date=short",
                "--", abs_path,
            ],
            capture_output=True,
            text=True,
            cwd=repo_root,
            timeout=5,
        )
    except Exception:
        return None

    fallback = None
    for line in result.stdout.splitlines():
        if "|||" not in line:
            continue
        date_str, message = line.split("|||", 1)
        date_str = date_str.strip()
        if not date_str:
            continue
        if fallback is None:
            fallback = date_str          # commit più recente, qualunque tipo
        if not NON_CONTENT_RE.search(message):
            return date_str              # primo commit di contenuto trovato

    return fallback                      # tutti esclusi → usa il più recente


def on_page_context(context, *, page, config, nav):
    docs_dir = os.path.normpath(config["docs_dir"])
    repo_root = os.path.dirname(docs_dir)
    abs_path = os.path.join(docs_dir, page.file.src_path)

    date_str = _get_content_date(abs_path, repo_root)
    if date_str:
        try:
            page.meta["git_revision_date_localized"] = _format_date_it(date_str)
        except Exception:
            pass

    return context
