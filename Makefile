.PHONY: install run backend frontend

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
