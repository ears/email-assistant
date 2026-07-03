.PHONY: install run backend frontend

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
	@echo " Starte Backend und Frontend..."
	@echo " HINWEIS: Da Makefile-Hintergrundprozesse auf Windows und"
	@echo " Linux unterschiedlich reagieren, startest du am besten"
	@echo " einfach zwei Terminals fuer maximale Uebersicht:"
	@echo "   Terminal 1: make backend"
	@echo "   Terminal 2: make frontend"
	@echo "========================================================="
	@echo "--- Starte jetzt das Backend in DIESEM Terminal..."
	uv run adk api_server app

backend:
	@echo "--- Starte ADK API Server..."
	uv run adk api_server app

frontend:
	@echo "--- Starte Vite Development Server..."
	cd frontend && npm run dev
