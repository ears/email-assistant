.PHONY: install run backend frontend

# ---------------------------------------------------------
# Installiert alle nötigen Abhängigkeiten (Python & Node)
# ---------------------------------------------------------
install:
	@echo ">>> Installiere Python Backend-Abhängigkeiten via uv..."
	uv sync
	@echo ">>> Installiere React Frontend-Abhängigkeiten via npm..."
	cd frontend && npm install
	@echo ">>> Installation komplett! Du kannst nun 'make run' nutzen."

# ---------------------------------------------------------
# Startet die Server
# ---------------------------------------------------------
run:
	@echo "========================================================="
	@echo " Starte Backend und Frontend..."
	@echo " HINWEIS: Da Makefile-Hintergrundprozesse auf Windows und"
	@echo " Linux unterschiedlich reagieren, startest du am besten"
	@echo " einfach zwei Terminals für maximale Übersicht:"
	@echo "   Terminal 1: make backend"
	@echo "   Terminal 2: make frontend"
	@echo "========================================================="
	@echo ">>> Starte jetzt das Backend in DIESEM Terminal..."
	uv run adk api_server app

backend:
	@echo ">>> Starte ADK API Server..."
	uv run adk api_server app

frontend:
	@echo ">>> Starte Vite Development Server..."
	cd frontend && npm run dev
