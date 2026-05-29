"""
Example AI-assisted PR review script.

Usage: set OPENAI_API_KEY and GITHUB_TOKEN as env vars (optional). The script reads a diff
from stdin (git diff) and calls an OpenAI-compatible endpoint to generate a short review.
This is an example — do not store API keys in repo.
"""
import os
import sys
import json
import requests

OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY")
OPENAI_API_URL = os.environ.get("OPENAI_API_URL", "https://api.openai.com/v1/chat/completions")

def get_diff():
    return sys.stdin.read()

def call_openai(diff_text):
    if not OPENAI_API_KEY:
        print("OPENAI_API_KEY not set; skipping AI review")
        return
    headers = {
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "Content-Type": "application/json",
    }
    payload = {
        "model": "gpt-4o-mini",
        "messages": [
            {"role": "system", "content": "You are a helpful senior DevOps reviewer."},
            {"role": "user", "content": f"Review this diff for security, infrastructure, and best practices:\n\n{diff_text}"}
        ],
        "max_tokens": 500,
    }
    r = requests.post(OPENAI_API_URL, headers=headers, data=json.dumps(payload))
    if r.status_code == 200:
        resp = r.json()
        print(json.dumps(resp, indent=2))
    else:
        print("AI call failed:", r.status_code, r.text)

if __name__ == '__main__':
    diff = get_diff()
    call_openai(diff)
