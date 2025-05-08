# PDFNamer

PDFNamer is a macOS application built using SwiftUI that allows users to batch process PDF files, rename them based on metadata and AI-generated suggestions, and save them. Backend is powered by FastAPI and Ollama. 

---



https://github.com/user-attachments/assets/504609ce-6fda-4b19-b017-c8a22e6f801a



## Features

- **Batch PDF Processing**: Upload multiple PDF files at once and handle them seamlessly. Supports uploading entire folders. 
- **AI Integration**: Uses a FastAPI server and Ollama to extract meaningful metadata like title, author, subject, and creation date.
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
  - Choose between AI and metadata as the source for renaming.
  - Configure naming conventions in the settings sidebar.
- Process Files:
  - Use the Overwrite Existing button to rename files in place.
  - Use the Save to Folder button to save processed files to a selected folder.
- Review Results: Peek at detailed AI or metadata results in the table.
