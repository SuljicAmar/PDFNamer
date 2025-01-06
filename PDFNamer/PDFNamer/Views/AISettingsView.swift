import SwiftUI

struct AISettingsView: View {
    @Binding var aiSettings: AISettings
    let onSettingsChange: () -> Void

    var body: some View {
        Section(
            header: Text("AI Settings")
                .font(Font.custom("Clash Grotesk", size: 14))
                .foregroundColor(Color(NSColor.textColor))

        ) {
            ToggleMenu(
                label: "Title",
                isOn: $aiSettings.title,
                onChange: onSettingsChange
            )

            ToggleMenu(
                label: "Author",
                isOn: $aiSettings.author,
                onChange: onSettingsChange
            )

            ToggleMenu(
                label: "Subject",
                isOn: $aiSettings.subject,
                onChange: onSettingsChange
            )

            ToggleMenu(
                label: "Date Created",
                isOn: $aiSettings.dateCreated,
                onChange: onSettingsChange
            )
        }
    }
}
