.PHONY: install run backend frontend deploy undeploy

# Unterdrueckt stoerende Python-Warnungen (wie z.B. Experimental Features)
export PYTHONWARNINGS=ignore

# ---------------------------------------------------------
# Installiert alle noetigen Abhaengigkeiten (Python & Node)
# ---------------------------------------------------------
install:
	@echo "--- Installiere Python Backend-Abhaengigkeiten via uv..."
	uv sync --link-mode=copy
	@echo "--- Installiere React Frontend-Abhaengigkeiten via npm..."
	cd frontend && npm install
	@echo "--- Installation komplett! Du kannst nun 'make run' nutzen."

# ---------------------------------------------------------
# Startet die Server
# ---------------------------------------------------------
run:
	@echo ""
	@echo "**********************************************************"
	@echo "*                                                        *"
	@echo "*     EMAIL ASSISTANT STARTET JETZT...                   *"
	@echo "*                                                        *"
	@echo "*     HINWEIS: Bitte ignoriere die Adresse 127.0.0.1!    *"
	@echo "*                                                        *"
	@echo "*  -> OEFFNE DEINEN BROWSER HIER: http://localhost:5173  *"
	@echo "*                                                        *"
	@echo "**********************************************************"
	@echo ""
	@uv run python -c "input('>>> Druecke ENTER, um die Server zu starten... ')"
	@make -j 2 backend frontend

backend:
	@echo "--- Starte ADK API Server..."
	uv run --link-mode=copy adk api_server app --no-reload

frontend:
	@echo "--- Starte Vite Development Server..."
	cd frontend && npm run dev

# ---------------------------------------------------------
# Deployment in die Google Cloud
# ---------------------------------------------------------
deploy:
	@echo ""
	@echo "========================================================="
	@echo "   VORAUSSETZUNGEN FUER DAS GOOGLE CLOUD DEPLOYMENT"
	@echo "========================================================="
	@echo " 1. CLI: Die 'Google Cloud CLI' (gcloud) muss installiert sein."
	@echo " 2. LOGIN: Du musst eingeloggt sein -> 'gcloud auth login'"
	@echo " 3. PROJEKT: Ein aktives Projekt muss gesetzt sein -> 'gcloud config set project DEIN_PROJEKT_ID'"
	@echo " 4. APIs: Folgende APIs muessen im Cloud-Projekt aktiviert sein:"
	@echo "    - Cloud Build API    (cloudbuild.googleapis.com)"
	@echo "    - Cloud Run API      (run.googleapis.com)"
	@echo "    - Secret Manager API (secretmanager.googleapis.com)"
	@echo " 5. BILLING: Fuer das Projekt muss ein Rechnungskonto hinterlegt sein."
	@echo "========================================================="
	@echo ""
	@uv run python -c "input('>>> Wenn alles erfuellt ist, druecke ENTER fuer das Deployment... ')"
	@echo "--- Starte automatischen Cloud-Build und Deployment..."
	@uv run python -c "import subprocess, sys; p = subprocess.check_output('gcloud config get-value project', shell=True, text=True).strip(); sys.exit(subprocess.call(f'uvx google-agents-cli deploy --no-confirm-project --project {p}', shell=True))"

# ---------------------------------------------------------
# Entfernt den Service aus der Cloud
# ---------------------------------------------------------
undeploy:
	@echo ""
	@echo "========================================================="
	@echo "   LOESCHE SERVICE AUS DER GOOGLE CLOUD"
	@echo "========================================================="
	@uv run python -c "input('>>> ACHTUNG: Der Service wird geloescht. Druecke ENTER zum Bestaetigen oder STRG+C zum Abbrechen... ')"
	@echo "--- Entferne Cloud Run Service 'email-assistant'..."
	gcloud run services delete email-assistant --region=us-central1 --quiet
	@echo "--- Service erfolgreich geloescht!"
