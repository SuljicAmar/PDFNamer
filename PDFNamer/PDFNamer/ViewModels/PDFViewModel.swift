import Foundation
import PDFKit
import SwiftUI
import UniformTypeIdentifiers

class PDFViewModel: ObservableObject {
    @Published var pdfFiles: [PDFFile] = []
    private var incrIDCounter: Int = 0
    @Published var settings: Settings = Settings()

    @Published var uploadMessage: String? = nil
    @Published var isLoading: Bool = false

    func fetchAndApplyAIResults(for pdfFile: PDFFile, at index: Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/parse_content/")
        else { return }

        DispatchQueue.main.async {
            self.pdfFiles[index].status = "Fetching AI Results..."
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["content": pdfFile.content]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body)
        else { return }
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(
                    "Error fetching AI results: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.pdfFiles[index].status = "AI Fetch Failed"
                }
                return
            }

            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    self.pdfFiles[index].status = "No AI Results"
                }
                return
            }

            do {
                let aiResponse = try JSONDecoder().decode(
                    AIResponse.self, from: data)

                DispatchQueue.main.async {
                    func sanitize(_ text: String?) -> String {
                        text?
                            .replacingOccurrences(of: ",", with: "")
                            .replacingOccurrences(of: "/", with: "-")
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            ?? ""
                    }

                    self.pdfFiles[index].results.resultsFromAI.rawTitle =
                        sanitize(aiResponse.title)
                    self.pdfFiles[index].results.resultsFromAI.rawAuthor =
                        sanitize(aiResponse.author)
                    self.pdfFiles[index].results.resultsFromAI.rawSubject =
                        sanitize(aiResponse.subject)
                    self.pdfFiles[index].results.resultsFromAI.rawCreatedDate =
                        sanitize(aiResponse.dateCreated)

                    self.applyDelimiter(to: &self.pdfFiles[index])

                    self.pdfFiles[index].status = "AI Results Ready"

                    if self.pdfFiles.allSatisfy({
                        $0.status == "AI Results Ready"
                    }) {
                        self.isLoading = false
                    }
                }
            } catch {
                print(
                    "Error parsing API response: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.pdfFiles[index].status = "AI Parsing Failed"
                }
            }
        }.resume()
    }

    func overwriteExistingFiles() {
        for index in pdfFiles.indices where pdfFiles[index].isSelected {
            guard let newName = pdfFiles[index].suggestedName, !newName.isEmpty
            else {
                pdfFiles[index].status = "Skipped (No New Name)"
                continue
            }

            let newFileName =
                newName.hasSuffix(".pdf") ? newName : "\(newName).pdf"
            let newURL = pdfFiles[index].url.deletingLastPathComponent()
                .appendingPathComponent(newFileName)

            let folderURL = pdfFiles[index].url.deletingLastPathComponent()
            let folderAccessGranted =
                folderURL.startAccessingSecurityScopedResource()

            if folderAccessGranted {
                do {
                    try FileManager.default.moveItem(
                        at: pdfFiles[index].url, to: newURL)
                    pdfFiles[index].status = "Overwritten"
                    pdfFiles[index].name = String(newFileName.dropLast(4))
                    pdfFiles[index].url = newURL
                } catch {
                    pdfFiles[index].status = "Failed (Rename Error)"
                    print("Error renaming file: \(error.localizedDescription)")
                }

                folderURL.stopAccessingSecurityScopedResource()
            } else {
                pdfFiles[index].status = "Failed (Permission Denied)"
                print("Permission to access folder not granted")
            }
        }
    }

    func saveFilesToFolder() {
        DispatchQueue.main.async {
            let panel = NSOpenPanel()
            panel.canChooseFiles = false
            panel.canChooseDirectories = true
            panel.allowsMultipleSelection = false
            panel.title = "Select Destination Folder"

            panel.begin { response in
                if response == .OK, let folderURL = panel.url {
                    DispatchQueue.global(qos: .userInitiated).async {
                        for index in self.pdfFiles.indices
                        where self.pdfFiles[index].isSelected {
                            guard
                                let newName = self.pdfFiles[index]
                                    .suggestedName, !newName.isEmpty
                            else {
                                DispatchQueue.main.async {
                                    self.pdfFiles[index].status =
                                        "Skipped (No New Name)"
                                }
                                continue
                            }

                            let newFileName =
                                newName.hasSuffix(".pdf")
                                ? newName : "\(newName).pdf"
                            let destinationURL =
                                folderURL.appendingPathComponent(newFileName)

                            do {
                                try FileManager.default.copyItem(
                                    at: self.pdfFiles[index].url,
                                    to: destinationURL)
                                DispatchQueue.main.async {
                                    self.pdfFiles[index].status =
                                        "Saved to Folder"
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    self.pdfFiles[index].status =
                                        "Failed (Copy Error)"
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func updateSuggestedNames() {
        let delimiter = settings.userSettings.delimiter.value

        for index in pdfFiles.indices {
            if !pdfFiles[index].isSelected { continue }

            applyDelimiter(to: &pdfFiles[index])

            var components: [String] = []

            if !settings.userSettings.prefix.isEmpty {
                components.append(settings.userSettings.prefix)
            }

            let aiSettings = settings.aiSettings
            let aiResults = pdfFiles[index].results.resultsFromAI

            if aiSettings.title, !aiResults.processedTitle.isEmpty {
                components.append(aiResults.processedTitle)
            }
            if aiSettings.author, !aiResults.processedAuthor.isEmpty {
                components.append(aiResults.processedAuthor)
            }
            if aiSettings.subject, !aiResults.processedSubject.isEmpty {
                components.append(aiResults.processedSubject)
            }
            if aiSettings.dateCreated, !aiResults.processedCreatedDate.isEmpty {
                components.append(aiResults.processedCreatedDate)
            }

            let metaSettings = settings.metaDataSettings
            let metaResults = pdfFiles[index].results.resultsFromMetaData

            if metaSettings.title, !metaResults.processedTitle.isEmpty {
                components.append(metaResults.processedTitle)
            }
            if metaSettings.author, !metaResults.processedAuthor.isEmpty {
                components.append(metaResults.processedAuthor)
            }
            if metaSettings.subject, !metaResults.processedSubject.isEmpty {
                components.append(metaResults.processedSubject)
            }
            if metaSettings.dateCreated,
                !metaResults.processedCreatedDate.isEmpty
            {
                components.append(metaResults.processedCreatedDate)
            }

            if settings.userSettings.incrID {
                components.append(String(pdfFiles[index].incrID))
            }

            if !settings.userSettings.suffix.isEmpty {
                components.append(settings.userSettings.suffix)
            }

            pdfFiles[index].suggestedName = components.joined(
                separator: delimiter)
        }
    }

    func uploadFiles(urls: [URL]) {
        var newPDFs: [PDFFile] = []
        var duplicates: [String] = []

        for url in urls {
            if url.hasDirectoryPath {
                let pdfs = findPDFs(in: url)
                if !pdfs.isEmpty {
                    for pdfURL in pdfs {
                        let displayName = removePDFExtension(
                            from: pdfURL.lastPathComponent)
                        if !pdfFiles.contains(where: { $0.url == pdfURL }) {
                            var pdfFile = PDFFile(
                                name: displayName, url: pdfURL,
                                incrID: getNextIncrID())
                            populateMetadata(for: &pdfFile, with: pdfURL)
                            newPDFs.append(pdfFile)
                        } else {
                            duplicates.append(displayName)
                        }
                    }
                }
            } else if url.pathExtension.lowercased() == "pdf" {
                let displayName = removePDFExtension(
                    from: url.lastPathComponent)
                if !pdfFiles.contains(where: { $0.url == url }) {
                    var pdfFile = PDFFile(
                        name: displayName, url: url, incrID: getNextIncrID())
                    populateMetadata(for: &pdfFile, with: url)
                    newPDFs.append(pdfFile)
                } else {
                    duplicates.append(displayName)
                }
            }
        }

        DispatchQueue.main.async {
            let startIndex = self.pdfFiles.count
            self.pdfFiles.append(contentsOf: newPDFs)

            for (offset, pdfFile) in newPDFs.enumerated() {
                self.fetchAndApplyAIResults(
                    for: pdfFile, at: startIndex + offset)
            }
        }
    }

    private func findPDFs(in folder: URL) -> [URL] {
        let fileManager = FileManager.default
        var results: [URL] = []

        if let enumerator = fileManager.enumerator(
            at: folder, includingPropertiesForKeys: nil)
        {
            for case let fileURL as URL in enumerator {
                if fileURL.pathExtension.lowercased() == "pdf" {
                    results.append(fileURL)
                }
            }
        }
        return results
    }

    private func removePDFExtension(from fileName: String) -> String {
        return fileName.hasSuffix(".pdf")
            ? String(fileName.dropLast(4)) : fileName
    }

    func openFileDialog() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowedContentTypes = [UTType.pdf]
        panel.title = "Select PDF Files or a Folder"

        panel.begin { response in
            if response == .OK {
                DispatchQueue.main.async {
                    self.isLoading = true
                }

                DispatchQueue.global(qos: .userInitiated).async {
                    self.uploadFiles(urls: panel.urls)

                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            }
        }
    }

    private func getNextIncrID() -> Int {
        let nextID = (pdfFiles.map { $0.incrID }.max() ?? 0) + 1
        return nextID
    }

    private func populateMetadata(for pdfFile: inout PDFFile, with url: URL) {
        guard let document = PDFDocument(url: url) else { return }

        if let attributes = document.documentAttributes {
            func sanitize(_ text: String?) -> String {
                text?
                    .replacingOccurrences(of: ",", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    ?? ""
            }

            pdfFile.results.resultsFromMetaData.rawTitle = sanitize(
                attributes[PDFDocumentAttribute.titleAttribute] as? String)
            pdfFile.results.resultsFromMetaData.rawAuthor = sanitize(
                attributes[PDFDocumentAttribute.authorAttribute] as? String)
            pdfFile.results.resultsFromMetaData.rawSubject = sanitize(
                attributes[PDFDocumentAttribute.subjectAttribute] as? String)

            if let creationDate = attributes[
                PDFDocumentAttribute.creationDateAttribute] as? Date
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                let formattedDate = formatter.string(from: creationDate)
                pdfFile.results.resultsFromMetaData.rawCreatedDate = sanitize(
                    formattedDate)
            }
        }

        pdfFile.content = extractContent(from: document)
        applyDelimiter(to: &pdfFile)
    }

    private func applyDelimiter(to pdfFile: inout PDFFile) {
        let delimiter = settings.userSettings.delimiter.value

        pdfFile.results.resultsFromMetaData.processedTitle = pdfFile.results
            .resultsFromMetaData.rawTitle
            .replacingOccurrences(of: " ", with: delimiter)
        pdfFile.results.resultsFromMetaData.processedAuthor = pdfFile.results
            .resultsFromMetaData.rawAuthor
            .replacingOccurrences(of: " ", with: delimiter)
        pdfFile.results.resultsFromMetaData.processedSubject = pdfFile.results
            .resultsFromMetaData.rawSubject
            .replacingOccurrences(of: " ", with: delimiter)
        pdfFile.results.resultsFromMetaData.processedCreatedDate = pdfFile
            .results.resultsFromMetaData.rawCreatedDate
            .replacingOccurrences(of: " ", with: delimiter)

        pdfFile.results.resultsFromAI.processedTitle = pdfFile.results
            .resultsFromAI.rawTitle
            .replacingOccurrences(of: " ", with: delimiter)
        pdfFile.results.resultsFromAI.processedAuthor = pdfFile.results
            .resultsFromAI.rawAuthor
            .replacingOccurrences(of: " ", with: delimiter)
        pdfFile.results.resultsFromAI.processedSubject = pdfFile.results
            .resultsFromAI.rawSubject
            .replacingOccurrences(of: " ", with: delimiter)
        pdfFile.results.resultsFromAI.processedCreatedDate = pdfFile.results
            .resultsFromAI.rawCreatedDate
            .replacingOccurrences(of: " ", with: delimiter)
    }

    private func extractContent(from document: PDFDocument) -> String {
        var content = ""
        let pageCount = document.pageCount
        let pagesToExtract = min(3, pageCount)

        for i in 0..<pagesToExtract {
            if let page = document.page(at: i) {
                content += page.string ?? ""
                content += "\n--- End of Page \(i + 1) ---\n"
            }
        }
        return content
    }
}
