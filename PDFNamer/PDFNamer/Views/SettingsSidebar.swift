import SwiftUI

struct SettingsSidebar: View {
    @ObservedObject var viewModel: PDFViewModel
    @Binding var isVisible: Bool

    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    Form {
                        Section(
                            header: Text("Source")
                                .font(Font.custom("Clash Grotesk", size: 14))
                                .foregroundColor(Color(NSColor.textColor))
                        ) {
                            DropdownMenu(
                                name: "",
                                options: [
                                    SettingOptions(label: "AI", value: "ai"),
                                    SettingOptions(
                                        label: "Meta Data", value: "metadata"),
                                ],
                                selected: $viewModel.settings.infoSource,
                                displayName: { $0.label }
                            )
                            .onChange(of: viewModel.settings.infoSource) { _ in
                                viewModel.updateSuggestedNames()
                            }
                        }

                        if viewModel.settings.infoSource.value == "ai" {
                            AISettingsView(
                                aiSettings: $viewModel.settings.aiSettings,
                                onSettingsChange: viewModel.updateSuggestedNames
                            )
                        } else {
                            MetaDataSettingsView(
                                metaDataSettings: $viewModel.settings
                                    .metaDataSettings,
                                onSettingsChange: viewModel.updateSuggestedNames
                            )
                        }

                        UserSettingsView(
                            userSettings: $viewModel.settings.userSettings
                        )
                        .onChange(of: viewModel.settings.userSettings) { _ in
                            viewModel.updateSuggestedNames()
                        }
                    }
                    .formStyle(.grouped)
                }
                .frame(maxWidth: geo.size.width)
                .frame(maxHeight: .infinity)
                .clipped()
            }
            .background(
                Color(NSColor.windowBackgroundColor)
            )
        }
    }
}
