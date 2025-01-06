import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PDFViewModel()

    var body: some View {

        ZStack {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        HStack(spacing: 10) {
                            Button(action: { viewModel.openFileDialog() }) {
                                Label("Upload", systemImage: "folder.fill.badge.plus")
                                    .symbolRenderingMode(.multicolor)
                                    .font(Font.custom("Clash Grotesk", size: 12))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(Color(NSColor.systemBlue))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(NSColor.systemBlue), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .help("Upload PDF files")

                            Button(action: { viewModel.overwriteExistingFiles() }) {
                                Text("Overwrite Existing")
                                    .font(Font.custom("Clash Grotesk", size: 12))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .foregroundColor(Color(NSColor.systemBlue))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(NSColor.systemBlue), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .help("Overwrite existing PDF files with new names")

                            Button(action: { viewModel.saveFilesToFolder() }) {
                                Text("Save to Folder")
                                    .font(Font.custom("Clash Grotesk", size: 12))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .foregroundColor(Color(NSColor.systemBlue))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(NSColor.systemBlue), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .help("Save renamed PDF files to a selected folder")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color(NSColor.controlBackgroundColor))
                        .frame(maxWidth: .infinity)


                        Divider()
                        
                        CentralTableView(viewModel: viewModel)

                    }
                    .frame(width: geometry.size.width * 0.75)

                    SettingsSidebar(
                        viewModel: viewModel, isVisible: .constant(true)
                    )
                    .frame(width: geometry.size.width * 0.25)
                    .background(Color(NSColor.windowBackgroundColor))
                }
            }
            .frame(minWidth: 700, minHeight: 500)

            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .transition(.opacity)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
