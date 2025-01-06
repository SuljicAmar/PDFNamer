import SwiftUI

struct MetaDataSettingsView: View {
    @Binding var metaDataSettings: MetaDataSettings
    let onSettingsChange: () -> Void

    var body: some View {
        Section(header: Text("Meta Data Settings").font(.headline)) {
            ToggleMenu(
                label: "Title",
                isOn: $metaDataSettings.title,
                onChange: onSettingsChange
            )

            ToggleMenu(
                label: "Author",
                isOn: $metaDataSettings.author,
                onChange: onSettingsChange
            )

            ToggleMenu(
                label: "Subject",
                isOn: $metaDataSettings.subject,
                onChange: onSettingsChange
            )

            ToggleMenu(
                label: "Date Created",
                isOn: $metaDataSettings.dateCreated,
                onChange: onSettingsChange
            )
        }
    }
}
