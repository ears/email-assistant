import { useState } from 'react';
import './index.css';

// Mock data simulating the ADK backend response
const DUMMY_RESPONSE = {
  urgent: [
    { 
      id: 2, 
      sender: "boss@company.com", 
      subject: "Re: URGENT: Server is down",
      draft: "Hallo Chef,\n\nich habe die E-Mail zur Server-Downtime gesehen. Das IT-Notfallteam ist bereits informiert und analysiert die Logs. Ich halte dich stündlich auf dem Laufenden.\n\nViele Grüße."
    }
  ],
  newsletters: [
    { id: 1, sender: "newsletter@spam.com", subject: "Buy our shoes!" }
  ],
  inquiries: [
    { 
      id: 3, 
      sender: "customer@gmail.com", 
      subject: "Re: Opening hours?", 
      draft: "Sehr geehrte/r Kunde/Kundin,\n\nvielen Dank für Ihre Anfrage. Wir haben samstags von 10:00 bis 16:00 Uhr geöffnet. Wir freuen uns auf Ihren Besuch!\n\nMit freundlichen Grüßen,\nIhr Team."
    }
  ]
};

function App() {
  const [query, setQuery] = useState("Lies meine Mails und sag mir was anliegt.");
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [result, setResult] = useState(null);
  const [drafts, setDrafts] = useState({});
  const [sentEmails, setSentEmails] = useState({});

  const startAnalysis = () => {
    setIsAnalyzing(true);
    setResult(null);
    setSentEmails({});
    
    // Simulate API call to the ADK backend
    setTimeout(() => {
      setResult(DUMMY_RESPONSE);
      // Initialize drafts state from both inquiries and urgent emails
      const initialDrafts = {};
      DUMMY_RESPONSE.inquiries.forEach(inq => {
        initialDrafts[inq.id] = inq.draft;
      });
      DUMMY_RESPONSE.urgent.forEach(urg => {
        initialDrafts[urg.id] = urg.draft;
      });
      setDrafts(initialDrafts);
      setIsAnalyzing(false);
    }, 2500);
  };

  const handleDraftChange = (id, newText) => {
    setDrafts(prev => ({ ...prev, [id]: newText }));
  };

  const handleSend = (id) => {
    setSentEmails(prev => ({ ...prev, [id]: true }));
    // Here we would call the /send endpoint on the backend for this specific ID
  };

  return (
    <div className="dashboard">
      <header>
        <h1>Smart Inbox Triage</h1>
        {result && (
          <button onClick={startAnalysis}>🔄 Neu Analysieren</button>
        )}
      </header>

      {!result && !isAnalyzing && (
        <div style={{ animation: 'fadeIn 0.5s' }}>
          <p style={{ marginBottom: '1rem', color: 'var(--text-secondary)' }}>
            Geben Sie Ihre Anweisung an den Agenten ein:
          </p>
          <input 
            type="text" 
            className="query-input"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
          />
          <button onClick={startAnalysis} style={{ width: '100%' }}>Agent Starten</button>
        </div>
      )}

      {isAnalyzing && (
        <div className="loader">
          <div className="spinner"></div>
          <span>Agent liest und kategorisiert E-Mails...</span>
        </div>
      )}

      {result && (
        <div className="results-container">
          
          {/* URGENT */}
          <div className="category" style={{ animationDelay: '0.1s' }}>
            <h2><span className="badge urgent">URGENT</span> Dringende E-Mails ({result.urgent.length})</h2>
            <p style={{ color: 'var(--text-secondary)', marginBottom: '1rem', fontSize: '0.9rem' }}>
              Achtung: Sofortige Aktion erforderlich! Der Agent hat eine Eskalationsantwort vorbereitet.
            </p>
            {result.urgent.map(email => (
              <div key={email.id} className="email-card" style={{ borderColor: 'rgba(220, 38, 38, 0.3)' }}>
                <div className="email-header">
                  <span>An: {email.sender}</span>
                </div>
                <div className="email-subject">{email.subject}</div>
                {sentEmails[email.id] ? (
                  <div style={{ padding: '1rem', background: 'rgba(5, 150, 105, 0.1)', color: 'var(--inquiry)', borderRadius: '8px', marginTop: '1rem', fontWeight: '600' }}>
                    ✅ Eskalation erfolgreich versendet
                  </div>
                ) : (
                  <>
                    <textarea 
                      className="draft-editor urgent-editor"
                      value={drafts[email.id] || ''}
                      onChange={(e) => handleDraftChange(email.id, e.target.value)}
                    />
                    <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: '1rem' }}>
                      <button className="btn-success" onClick={() => handleSend(email.id)}>Versenden</button>
                    </div>
                  </>
                )}
              </div>
            ))}
          </div>

          {/* NEWSLETTERS */}
          <div className="category" style={{ animationDelay: '0.2s' }}>
            <h2><span className="badge newsletter">NEWSLETTER</span> Irrelevant ({result.newsletters.length})</h2>
            {result.newsletters.map(email => (
              <div key={email.id} className="email-card">
                <div className="email-header">
                  <span>Von: {email.sender}</span>
                </div>
                <div className="email-subject">{email.subject}</div>
              </div>
            ))}
          </div>

          {/* INQUIRIES */}
          <div className="category" style={{ animationDelay: '0.3s' }}>
            <h2><span className="badge inquiry">CUSTOMER INQUIRY</span> Kundenanfragen ({result.inquiries.length})</h2>
            <p style={{ color: 'var(--text-secondary)', marginBottom: '1rem', fontSize: '0.9rem' }}>
              Der Agent hat anhand der FAQs folgende Antworten vorbereitet. Bitte prüfe und bearbeite sie vor dem Versand.
            </p>
            {result.inquiries.map(email => (
              <div key={email.id} className="email-card" style={{ borderColor: 'rgba(5, 150, 105, 0.3)' }}>
                <div className="email-header">
                  <span>An: {email.sender}</span>
                </div>
                <div className="email-subject">{email.subject}</div>
                {sentEmails[email.id] ? (
                  <div style={{ padding: '1rem', background: 'rgba(5, 150, 105, 0.1)', color: 'var(--inquiry)', borderRadius: '8px', marginTop: '1rem', fontWeight: '600' }}>
                    ✅ Antwort erfolgreich versendet
                  </div>
                ) : (
                  <>
                    <textarea 
                      className="draft-editor"
                      value={drafts[email.id] || ''}
                      onChange={(e) => handleDraftChange(email.id, e.target.value)}
                    />
                    <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: '1rem' }}>
                      <button className="btn-success" onClick={() => handleSend(email.id)}>Versenden</button>
                    </div>
                  </>
                )}
              </div>
            ))}
          </div>

        </div>
      )}
    </div>
  );
}

export default App;
