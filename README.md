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
Starte danach beide Server (Frontend & Backend) ganz einfach mit einem Befehl:
```bash
make run
```

*Optional:* Falls du die Server lieber getrennt in **zwei Terminals** starten moechtest:
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

## Cloud Deployment (Produktion)

Sobald der Email Assistant lokal perfekt laeuft, kannst du ihn mit einem einzigen Befehl als Serverless-App auf **Google Cloud Run** hochladen. 

Wir nutzen dafuer eine hochoptimierte "Single Container"-Architektur:
- Ein Multi-Stage Dockerfile baut das React-Frontend (`npm run build`).
- Der Python/FastAPI Server liefert anschliessend nicht nur die KI-API aus, sondern auch die fertigen React-HTML-Dateien. Frontend und Backend laufen so unter einer einzigen URL und demselben Port!

### Voraussetzungen fuer das Deployment

Bevor du deployen kannst, muessen folgende Punkte auf deinem Rechner und in der Google Cloud erfuellt sein:

1. **Google Cloud CLI (`gcloud`)** muss auf deinem Rechner [installiert](https://cloud.google.com/sdk/docs/install) sein.
2. Du musst **eingeloggt** sein. Oeffne dein Terminal und tippe:
   ```bash
   gcloud auth login
   ```
3. Du benoetigst ein aktives **Google Cloud Projekt**, das du in deinem Terminal auswaehlst:
   ```bash
   gcloud config set project DEINE_PROJEKT_ID
   ```
4. Folgende **APIs** muessen in deinem Cloud-Projekt aktiviert sein (Tipp: Suche in der Google Cloud Console nach "APIs & Services"):
   - Cloud Build API (`cloudbuild.googleapis.com`)
   - Cloud Run API (`run.googleapis.com`)
   - Secret Manager API (`secretmanager.googleapis.com`)
5. Fuer dein Projekt muss in der Google Cloud Console ein **Rechnungskonto (Billing)** aktiviert sein.

### Das Deployment starten

Wenn alle Voraussetzungen erfuellt sind, tippe in deinem Terminal einfach:
```bash
make deploy
```
Das Skript erinnert dich noch einmal an die Voraussetzungen, baut den Container dann automatisch in der Cloud und spuckt dir am Ende die fertige, weltweite HTTPS-URL aus!

### Fehler "403 Forbidden" beheben (Oeffentlicher Zugriff)
Standardmaessig ist dein neuer Cloud Run Service aus Sicherheitsgruenden **privat**. Ein normales Google-Login im Browser reicht nicht aus, um die Seite zu sehen (es erfordert ein API-Token). 
Um deine App als oeffentlichen Prototypen fuer jeden freizugeben, tippe diesen Befehl in dein Terminal:

```bash
gcloud run services add-iam-policy-binding email-assistant --region=us-central1 --member=allUsers --role=roles/run.invoker
```

### Den Service wieder entfernen (Undeploy)

Wenn du das Projekt nicht mehr benoetigst und Kosten sparen moechtest, kannst du den Cloud Run Service jederzeit wieder loeschen. Ein einzelner Befehl reicht:

```bash
make undeploy
```

Dadurch wird der aktive `email-assistant` Service in der Region `us-central1` unwiderruflich aus deinem Google Cloud Projekt entfernt.

---

## Tests & Evaluation

Dieses Projekt verfuegt ueber eine automatisierte Qualitaetssicherung. Um die Test-Szenarien (Prompt-Injection-Abwehr, Halluzinationstests) auszufuehren, nutze:

```bash
uvx google-agents-cli eval run --dataset tests/eval/datasets/email-dataset.json --config tests/eval/eval_config.yaml
```
Die Ergebnisse werden als HTML-Report im Ordner `artifacts/grade_results/` abgelegt.

## Architektur-Spezifikation
Alle Details zur Agenten-Logik, den UI-Anforderungen und dem genauen Master-Prompt findest du in der [SPEC.md](SPEC.md).
