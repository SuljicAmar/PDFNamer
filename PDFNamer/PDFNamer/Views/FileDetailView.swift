import SwiftUI

struct FileDetailView: View {
    @Binding var file: PDFFile?

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if let file = file {
                Group {
                    SectionHeader(title: "Metadata Results")
                    KeyValueRow(
                        key: "Author",
                        value: file.results.resultsFromMetaData.processedAuthor)
                    KeyValueRow(
                        key: "Subject",
                        value: file.results.resultsFromMetaData.processedSubject
                    )
                    KeyValueRow(
                        key: "Created Date",
                        value: file.results.resultsFromMetaData
                            .processedCreatedDate)
                }

                Divider()

                if file.status == "AI Results Ready" {
                    SectionHeader(title: "AI Results")
                    KeyValueRow(
                        key: "Title",
                        value: file.results.resultsFromAI.processedTitle)
                    KeyValueRow(
                        key: "Author",
                        value: file.results.resultsFromAI.processedAuthor)
                    KeyValueRow(
                        key: "Subject",
                        value: file.results.resultsFromAI.processedSubject)
                    KeyValueRow(
                        key: "Created Date",
                        value: file.results.resultsFromAI.processedCreatedDate)
                } else {
                    Text("AI Results are not yet available.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical, 5)
                }

            } else {
                Text("No file selected")
                    .font(.subheadline)
                    .foregroundColor(Color(NSColor.textColor))
                    .font(Font.custom("Clash Grotesk", size: 14))
            }
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
    }
}

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(Font.custom("Clash Grotesk", size: 14))
            .padding(.vertical, 3)
            .foregroundColor(Color(NSColor.systemBlue))
    }
}

struct KeyValueRow: View {
    let key: String
    let value: String

    var body: some View {
        HStack {
            Text("\(key):")
                .font(Font.custom("Clash Grotesk", size: 12))
                .foregroundColor(Color(NSColor.textColor))
                .bold()
            Spacer()
            Text(value)
                .font(Font.custom("Clash Grotesk", size: 12))
                .foregroundColor(Color(NSColor.textColor))
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 3)
    }
}
