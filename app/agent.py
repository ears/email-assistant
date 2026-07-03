# ruff: noqa
import os
import google.auth
from pydantic import BaseModel, Field
from typing import List

from google.adk.agents import Agent
from google.adk.apps import App
from google.adk.models import Gemini
from google.genai import types

_, project_id = google.auth.default()
os.environ["GOOGLE_CLOUD_PROJECT"] = project_id
os.environ["GOOGLE_CLOUD_LOCATION"] = "global"
os.environ["GOOGLE_GENAI_USE_VERTEXAI"] = "True"

# --- Tools ---
def fetch_unread_emails() -> str:
    """Fetch the latest unread emails from the user's inbox."""
    return '''
    [
        {"id": 1, "sender": "newsletter@spam.com", "subject": "Buy our shoes!", "body": "50% off all sneakers today only."},
        {"id": 2, "sender": "boss@company.com", "subject": "URGENT: Server is down", "body": "Please fix the production server immediately!"},
        {"id": 3, "sender": "customer@gmail.com", "subject": "Opening hours?", "body": "Hi, when does your store open on Saturdays?"}
    ]
    '''

def search_faq(query: str) -> str:
    """Search the company FAQ database for answers to customer questions."""
    faq_db = {
        "opening hours": "We are open Monday to Friday 9am-6pm, and Saturdays 10am-4pm. Closed on Sundays.",
        "returns": "Returns are accepted within 30 days of purchase with original receipt."
    }
    for key, answer in faq_db.items():
        if key in query.lower():
            return answer
    return "No matching FAQ found. Please escalate to a human agent."

class DraftEmail(BaseModel):
    recipient: str = Field(description="The email address of the recipient.")
    subject: str = Field(description="The subject line of the email.")
    body: str = Field(description="The body content of the email.")

def send_emails(drafts: list[DraftEmail]) -> str:
    """Send emails to the specified recipients."""
    for draft in drafts:
        print(f"--- SIMULATED SENDING TO {draft.recipient} ---")
        print(f"Subject: {draft.subject}")
        print(f"Body: {draft.body}")
    return f"Successfully sent {len(drafts)} emails."


# --- Agent ---
agent_instruction = """You are a Smart Inbox Triage & Draft Assistant.
Your task is to help the user manage their inbox.
When requested:
1. Use `fetch_unread_emails` to get the latest messages.
2. Analyze and categorize each email into: URGENT, NEWSLETTER, or CUSTOMER INQUIRY.
3. For CUSTOMER INQUIRY emails, use `search_faq` to find the answer and draft a polite email response.
4. DO NOT send the emails yet!
5. Present a clear summary to the user in the chat:
   - List the Urgent emails and Newsletters.
   - Show the drafted responses for Customer Inquiries.
6. Ask the user for explicit permission (e.g. "Darf ich diese Antworten abschicken?").
7. ONLY IF the user explicitly approves, use the `send_emails` tool to dispatch the drafts.
"""

root_agent = Agent(
    name="email_assistant",
    model=Gemini(
        model="gemini-flash-latest",
        retry_options=types.HttpRetryOptions(attempts=3),
    ),
    instruction=agent_instruction,
    tools=[fetch_unread_emails, search_faq, send_emails],
)

app = App(
    root_agent=root_agent,
    name="app",
)
