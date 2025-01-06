import SwiftUI

struct UserSettingsView: View {
    @Binding var userSettings: UserSettings

    var body: some View {
        Section(
            header: Text("General Settings").font(
                Font.custom("Clash Grotesk", size: 14))
            .foregroundColor(Color(NSColor.textColor))

        ) {
            DropdownMenu(
                name: "Delimiter",
                options: [
                    SettingOptions(label: "Hyphen (-)", value: "-"),
                    SettingOptions(label: "Underscore (_)", value: "_"),
                    SettingOptions(label: "Space", value: " "),
                    SettingOptions(label: "None", value: ""),
                ],
                selected: $userSettings.delimiter,
                displayName: { $0.label }
            )

            TextInputField(label: "Prefix", userText: $userSettings.prefix)
            TextInputField(label: "Suffix", userText: $userSettings.suffix)
            ToggleMenu(
                label: "Incremental ID",
                isOn: $userSettings.incrID
            )
        }
    }
}
