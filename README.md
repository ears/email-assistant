# Smart Inbox Triage & Draft Agent

Dies ist ein Uebungsprojekt, das vollstaendig im Rahmen eines **Vibe Coding**-Workflows mithilfe des Google Agent Development Kits (ADK) erstellt wurde.

## Sinn des Projekts
Das Ziel dieses Projekts ist es, die Konzepte des Vibe Codings und der Agenten-Architektur praktisch zu erlernen. Der **Email Assistant** demonstriert:
1. **Agentic Workflow:** Ein LLM-Agent nutzt Tools, um Dummy-Mails zu lesen, Kategorien zu bilden (URGENT, NEWSLETTERS, CUSTOMER INQUIRY) und automatisch Antworten (z.B. aus FAQ-Daten) zu entwerfen.
2. **Human-in-the-Loop:** Eine moderne React-Web-UI ermoeglicht es dem Nutzer, die Entwuerfe des Agenten zu pruefen, zu bearbeiten und jede E-Mail einzeln zum Versand freizugeben.
3. **Spec-Driven Coding:** Das Projekt wird zentral ueber die `SPEC.md` gesteuert.
4. **Evaluations:** Integrierte LLM-as-a-Judge Tests, um Halluzinationen zu vermeiden und Safety-Guardrails abzusichern.

## Technologien
- **Backend:** Python, Google ADK (Agent Development Kit), FastAPI
- **Frontend:** React, Vite, Vanilla CSS (Glassmorphism Lite-Mode)
- **Tooling:** `uv` (Python Package Manager), `npm` (Node Package Manager)

## Voraussetzungen (Prerequisites)
Bevor du startest, stelle sicher, dass folgende Werkzeuge auf deinem System (Windows, macOS oder Linux) installiert sind:
1. **[Python (3.10+)](https://www.python.org/downloads/)**
2. **[Node.js & npm](https://nodejs.org/)** (fuer das React-Frontend)
3. **[uv](https://docs.astral.sh/uv/)** (Der rasend schnelle Python Package Manager)
4. **Make** (Optional, aber empfohlen fuer den Schnellstart. Unter Linux/macOS meist vorinstalliert, unter Windows z.B. via `choco install make` oder MSYS2/Git Bash installierbar).

---

## Installation & Ausfuehrung

Es gibt zwei Wege, das Projekt zu starten: den bequemen Weg ueber die `Makefile` oder den manuellen Weg.

### Option A: Der Schnellstart (mit Make)
Oeffne ein Terminal im Projektordner und installiere alle Abhaengigkeiten (Frontend & Backend):
```bash
make install
```
Oeffne danach **zwei Terminals**, um die Server zu starten:
```bash
# Terminal 1
make backend

# Terminal 2
make frontend
```

### Option B: Der manuelle Weg
Falls du `make` nicht installiert hast, kannst du die Server auch manuell starten:

**1. Backend (Terminal 1):**
```bash
# Abhaengigkeiten installieren
uv sync
# Server starten (Windows-Nutzer koennen bei Zeichensatzproblemen vorher $env:PYTHONUTF8=1 setzen)
uv run adk api_server app
```

**2. Frontend (Terminal 2):**
```bash
cd frontend
# Abhaengigkeiten installieren
npm install
# Server starten
npm run dev
```

Die Web-Oberflaeche ist nun unter [http://localhost:5173](http://localhost:5173) in deinem Browser erreichbar!

---

## Tests & Evaluation

Dieses Projekt verfuegt ueber eine automatisierte Qualitaetssicherung. Um die Test-Szenarien (Prompt-Injection-Abwehr, Halluzinationstests) auszufuehren, nutze:

```bash
uvx google-agents-cli eval run --dataset tests/eval/datasets/email-dataset.json --config tests/eval/eval_config.yaml
```
Die Ergebnisse werden als HTML-Report im Ordner `artifacts/grade_results/` abgelegt.

## Architektur-Spezifikation
Alle Details zur Agenten-Logik, den UI-Anforderungen und dem genauen Master-Prompt findest du in der [SPEC.md](SPEC.md).
