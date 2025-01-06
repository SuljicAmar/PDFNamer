import Foundation

struct PDFFile: Identifiable {
    let id = UUID()
    var name: String
    var suggestedName: String?
    var url: URL
    var isSelected: Bool = true
    var incrID: Int = 1

    var content: String = ""
    var results: Results = Results()
    var settings: FromSettings = FromSettings()

    var status: String = "Pending"
}

struct Results {
    var resultsFromMetaData: FromDocument = FromDocument()
    var resultsFromAI: FromDocument = FromDocument()
}

struct FromDocument {
    var rawTitle: String = ""
    var rawAuthor: String = ""
    var rawSubject: String = ""
    var rawCreatedDate: String = ""

    var processedTitle: String = ""
    var processedAuthor: String = ""
    var processedSubject: String = ""
    var processedCreatedDate: String = ""
}

struct FromSettings {
    var delimiter: String = ""
    var prefix: String = ""
    var suffix: String = ""
}

struct AIResponse: Codable {
    let title: String
    let author: String
    let subject: String
    let dateCreated: String
}
