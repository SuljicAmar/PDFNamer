import SwiftUI

struct CentralTableView: View {
    @ObservedObject var viewModel: PDFViewModel
    @State private var peakFile: PDFFile?
    
    var body: some View {
        VStack{
            Table(viewModel.pdfFiles) {
                TableColumn("") {
                    file in
                    Button(action: {
                        peakFile = file
                    }) {
                        Image(systemName: "eye")
                            .font(.system(size: 12))
                            .foregroundColor(Color(NSColor.systemBlue))
                            .padding(.vertical, 4)
                        
                        
                    }
                    .labelsHidden()
                    .buttonStyle(BorderlessButtonStyle())
                }
                .width(min: 20, ideal: 25, max: 50)
                
                TableColumn(
                    Text("Original Name").font(Font.custom("Clash Grotesk", size: 14))
                ) { file in
                    Text(file.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(3)
                        .font(Font.custom("Clash Grotesk", size: 12))
                        .foregroundColor(Color(NSColor.textColor))
                        .padding(.vertical, 4)
                }.width(min: 150, ideal: 250, max: 500)
                
                TableColumn(
                    Text("New Name").font(Font.custom("Clash Grotesk", size: 14))
                ) { file in
                    Text(file.suggestedName ?? "Not Generated")
                        .foregroundColor(
                            file.suggestedName != nil ? .primary : .gray
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(3)
                        .font(Font.custom("Clash Grotesk", size: 12))
                        .foregroundColor(Color(NSColor.textColor))
                    
                        .padding(.vertical, 4)
                    
                }.width(min: 150, ideal: 250, max: 500)
                
                TableColumn(
                    Text("Status").font(Font.custom("Clash Grotesk", size: 14))
                ) { file in
                    Text(file.status)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(file.status.contains("Failed") ? .red : Color(NSColor.textColor))
                        .font(Font.custom("Clash Grotesk", size: 12))
                        .padding(.vertical, 4)
                    
                }.width(min: 75, ideal: 125, max: 150)
                
                TableColumn("") {
                    file in
                    Toggle(
                        "",
                        isOn: Binding(
                            get: { file.isSelected },
                            set: { newValue in
                                if let index = viewModel.pdfFiles.firstIndex(
                                    where: { $0.id == file.id })
                                {
                                    viewModel.pdfFiles[index].isSelected =
                                    newValue
                                }
                            }
                        )
                    )
                    .labelsHidden()
                    .padding(.horizontal, 8)
                    
                }.width(min: 20, ideal: 25, max: 50)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .shadow(radius: 4)
            )
            .popover(item: $peakFile) { file in
                FileDetailView(file: $peakFile)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
        
    }
}
