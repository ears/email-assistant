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
	@echo "========================================================="
	@echo " Starte Backend und Frontend parallel..."
	@echo ""
	@echo " Alternativ kannst du Backend und Frontend in zwei getrennten"
	@echo " Terminals starten (make backend / make frontend)."
	@echo " Damit hast du mehr Uebersicht ueber die Konsolenmeldungen."
	@echo "========================================================="
	@make -j 2 backend frontend

backend:
	@echo "--- Starte ADK API Server..."
	uv run --link-mode=copy adk api_server app

frontend:
	@echo "--- Starte Vite Development Server..."
	cd frontend && npm run dev
