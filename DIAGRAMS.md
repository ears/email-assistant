# Email Assistant: Diagramme

Diese Diagramme visualisieren die essenziellen Konzepte des Projekts extrem spartanisch und auf das absolute Minimum reduziert.

## 1. Architektur & Design (Single Container)
Zeigt, wie das React-Frontend und der KI-Agent in einem einzigen Container zusammenarbeiten.

```mermaid
graph TD
  Client["Browser (React UI)"] -->|HTTPS| CloudRun["Google Cloud Run"]
  
  subgraph Container ["Single Container (Port 8080)"]
    Router{"FastAPI (Routing)"}
    Static["React HTML/CSS"]
    Agent["ADK Python Agent"]
    Tools["Tools (FAQ, Drafts)"]
    
    Router -->|Nicht-API Aufrufe| Static
    Router -->|/api/* Aufrufe| Agent
    Agent --> Tools
  end
  
  Agent -->|LLM Prompt| Gemini["Gemini API"]
```

## 2. End-User Workflow (Human-in-the-Loop)
Zeigt, wie der menschliche Nutzer und die KI bei der E-Mail-Bearbeitung interagieren.

```mermaid
sequenceDiagram
    actor User as Mensch
    participant UI as Web-UI
    participant Agent as KI-Agent
    
    User->>UI: Klickt "Triage"
    UI->>Agent: Starte Verarbeitung
    Agent-->>UI: Liefert Kategorien & Antwort-Entwürfe
    UI->>User: Zeigt fertige Entwürfe an
    User->>UI: Liest, korrigiert & gibt frei (Human-in-the-Loop)
    User->>UI: Klickt "Senden"
    UI-->>User: E-Mail verschickt!
```

## 3. Vibe Coding Workflow
Der Entwicklungs-Zyklus, mit dem dieses Projekt komplett durch natürliche Sprache gesteuert wurde.

```mermaid
graph LR
    Spec["1. SPEC.md definieren"] --> KI["2. KI generiert Code"]
    KI --> Test["3. Testen (make run)"]
    Test -->|Feedback| Spec
    Test -->|Perfekt| Deploy["4. make deploy"]
```
