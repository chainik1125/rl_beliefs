#!/usr/bin/env python3
"""
Convert LaTeX project to Google Doc using Gemini API.

Usage:
    python latex_to_gdoc.py [--upload]

Requirements:
    pip install google-generativeai google-auth-oauthlib google-api-python-client

Environment:
    GOOGLE_API_KEY - Gemini API key
"""

import os
import re
import json
from pathlib import Path
from typing import Optional

import google.generativeai as genai

# Configure Gemini
genai.configure(api_key=os.environ["GOOGLE_API_KEY"])


def read_latex_project(main_tex: Path) -> str:
    """Read main tex and inline all subfiles recursively."""
    content = main_tex.read_text()
    base_dir = main_tex.parent

    # Read and inline subfiles
    subfile_pattern = r'\\subfile\{([^}]+)\}'

    def replace_subfile(match):
        subfile_rel = match.group(1)
        # Try with and without .tex extension
        for ext in ['', '.tex']:
            subfile_path = base_dir / f"{subfile_rel}{ext}"
            if subfile_path.exists():
                sub_content = subfile_path.read_text()
                # Strip subfiles-specific wrapper
                sub_content = re.sub(r'\\documentclass\[.*?\]\{subfiles\}', '', sub_content)
                sub_content = re.sub(r'\\begin\{document\}', '', sub_content)
                sub_content = re.sub(r'\\end\{document\}', '', sub_content)
                # Remove standalone bibliography (will use main one)
                sub_content = re.sub(r'\\makeatletter.*?\\makeatother', '', sub_content, flags=re.DOTALL)
                return sub_content.strip()
        print(f"Warning: Could not find subfile {subfile_rel}")
        return match.group(0)

    return re.sub(subfile_pattern, replace_subfile, content)


def read_bibtex(bib_path: Path) -> str:
    """Read bibliography file if it exists."""
    if bib_path.exists():
        return bib_path.read_text()
    return ""


def latex_to_gdoc_content(latex: str, bibtex: str = "") -> str:
    """Use Gemini to convert LaTeX to clean, formatted text for Google Docs."""

    prompt = """You are converting a LaTeX academic document to a format suitable for Google Docs.

TASK: Convert the following LaTeX to clean, well-formatted text that preserves the document's structure and meaning.

RULES:
1. **Structure**: Preserve all sections, subsections, and document hierarchy
2. **Math**: Convert to readable Unicode/plaintext:
   - Use Greek letters: η, α, β, etc.
   - Use symbols: ⊗ (tensor), ∈ (element of), → (arrow), etc.
   - For complex equations, write them readably: "η = v_c ⊗ v_a"
3. **Lists**: Preserve numbered and bulleted lists with proper indentation
4. **Citations**: Convert \\cite{key} to [Author Year] format using the BibTeX provided
5. **Environments**:
   - Theorems/Assumptions → Bold header + indented content
   - Enumerate → Numbered list
6. **Comments**: Remove LaTeX comments (lines starting with %)
7. **Formatting**: Use **bold** and *italic* markdown for emphasis

OUTPUT: Return ONLY the converted document text, no explanations.

---
BIBTEX REFERENCES:
""" + bibtex + """

---
LATEX DOCUMENT:
""" + latex

    model = genai.GenerativeModel('gemini-2.0-flash')
    response = model.generate_content(prompt)
    return response.text


def upload_to_drive(content: str, title: str, credentials_path: Optional[Path] = None):
    """Upload content as a Google Doc to Drive."""
    from google.oauth2.credentials import Credentials
    from google_auth_oauthlib.flow import InstalledAppFlow
    from google.auth.transport.requests import Request
    from googleapiclient.discovery import build
    from googleapiclient.http import MediaInMemoryUpload

    SCOPES = [
        'https://www.googleapis.com/auth/drive.file',
        'https://www.googleapis.com/auth/documents'
    ]

    token_path = Path(__file__).parent / 'token.json'
    creds = None

    # Load existing credentials
    if token_path.exists():
        creds = Credentials.from_authorized_user_file(str(token_path), SCOPES)

    # Refresh or get new credentials
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            # Look for OAuth client credentials
            client_secrets = credentials_path or Path(__file__).parent / 'client_secrets.json'
            if not client_secrets.exists():
                print("\n⚠️  To upload to Google Drive, you need OAuth credentials:")
                print("1. Go to https://console.cloud.google.com/apis/credentials")
                print("2. Create OAuth 2.0 Client ID (Desktop app)")
                print("3. Download JSON and save as 'client_secrets.json' in this folder")
                print(f"\nExpected path: {client_secrets}")
                print("\nFor now, saving output.html locally...")
                return None

            flow = InstalledAppFlow.from_client_secrets_file(str(client_secrets), SCOPES)
            creds = flow.run_local_server(port=0)

        # Save credentials for next run
        with open(token_path, 'w') as f:
            f.write(creds.to_json())

    # Create Google Doc
    drive_service = build('drive', 'v3', credentials=creds)

    # Upload as Google Doc (Drive will convert from text/html)
    # Wrap content in basic HTML for better formatting
    html_content = f"""<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>{title}</title></head>
<body style="font-family: serif; line-height: 1.6;">
<pre style="white-space: pre-wrap; font-family: serif;">{content}</pre>
</body>
</html>"""

    file_metadata = {
        'name': title,
        'mimeType': 'application/vnd.google-apps.document'
    }

    media = MediaInMemoryUpload(
        html_content.encode('utf-8'),
        mimetype='text/html',
        resumable=True
    )

    file = drive_service.files().create(
        body=file_metadata,
        media_body=media,
        fields='id, webViewLink'
    ).execute()

    print(f"\n✅ Created Google Doc: {file.get('webViewLink')}")
    return file.get('id')


def main():
    import argparse

    parser = argparse.ArgumentParser(description='Convert LaTeX to Google Doc')
    parser.add_argument('--upload', action='store_true', help='Upload to Google Drive')
    parser.add_argument('--tex', type=Path, default=Path(__file__).parent / 'ideas.tex',
                        help='Path to main .tex file')
    args = parser.parse_args()

    print("📄 Reading LaTeX project...")
    latex = read_latex_project(args.tex)

    # Read bibliography
    bib_path = args.tex.parent / 'refs.bib'
    bibtex = read_bibtex(bib_path)

    print("🤖 Converting via Gemini...")
    content = latex_to_gdoc_content(latex, bibtex)

    # Always save local copy
    output_path = args.tex.parent / 'output_gdoc.txt'
    output_path.write_text(content)
    print(f"💾 Saved to {output_path}")

    if args.upload:
        title = "Belief States in RL"
        upload_to_drive(content, title)
    else:
        print("\nRun with --upload to upload to Google Drive")
        print("Or copy the content from output_gdoc.txt into a Google Doc manually")


if __name__ == "__main__":
    main()
