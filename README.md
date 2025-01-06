# PDFNamer

PDFNamer is a macOS application built using SwiftUI that allows users to batch process PDF files, rename them based on metadata or AI-generated suggestions, and save them to a specified folder. The application integrates a FastAPI backend for AI parsing, enabling advanced text extraction and analysis.

---

![01](https://github.com/user-attachments/assets/afca1118-dc0a-416f-8f85-f8a1ca966e1f)

## Features

- **Batch PDF Processing**: Upload multiple PDF files at once and handle them seamlessly.
- **AI Integration**: Uses a FastAPI server to extract meaningful metadata like title, author, subject, and creation date.
- **Metadata Parsing**: Extracts and processes metadata directly from PDF files.
- **Custom Naming Rules**: Apply prefixes, suffixes, and delimiters to create customized file names.
- **Dynamic Table View**: Displays the original and suggested names alongside the status of each file.
- **macOS Native Look**: Dynamic colors and styles adapt to light and dark modes.
- **File Management**: Save renamed files to a folder or overwrite the existing ones.

---

## Usage
- Start the FastAPI Server: Ensure the backend is running at http://127.0.0.1:8000 before using the app.
- Upload Files: Use the Upload button to select PDF files or folders.
- Customize Settings:
  - Choose between AI or metadata as the source for renaming.
  - Configure naming conventions in the settings sidebar.
- Process Files:
  - Use the Overwrite Existing button to rename files in place.
    - Use the Save to Folder button to save processed files to a selected folder.
- Review Results: Peek at detailed AI or metadata results in the table.
