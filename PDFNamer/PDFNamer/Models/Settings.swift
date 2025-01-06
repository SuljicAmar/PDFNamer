import Foundation

struct Settings {
    var aiSettings = AISettings()
    var metaDataSettings = MetaDataSettings()
    var userSettings = UserSettings()
    var infoSource: SettingOptions = SettingOptions(label: "AI", value: "ai")
    var overwriteExisting: Bool = true
    var pathToOutputFolder: String = ""

}

struct UserSettings: Equatable {
    var delimiter: SettingOptions = SettingOptions(
        label: "Hyphen (-)", value: "-")
    var incrID: Bool = false
    var prefix: String = ""
    var suffix: String = ""
}

struct AISettings {
    var title: Bool = false
    var author: Bool = false
    var subject: Bool = false
    var dateCreated: Bool = false

}

struct MetaDataSettings {
    var title: Bool = false
    var author: Bool = false
    var subject: Bool = false
    var dateCreated: Bool = false

}

struct SettingOptions: Hashable {
    let label: String
    let value: String
}
