import SwiftUI

struct DropdownMenu<T: Hashable>: View {
    let name: String
    let options: [T]
    @Binding var selected: T
    let displayName: (T) -> String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(name).font(Font.custom("Clash Grotesk", size: 12))
                Menu {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selected = option
                        }) {
                            Text(displayName(option)).font(
                                Font.custom("Clash Grotesk", size: 12))
                            .foregroundColor(Color(NSColor.textColor))

                        }
                    }
                } label: {
                    HStack {
                        Text(displayName(selected)).font(
                            Font.custom("Clash Grotesk", size: 12))
                        .foregroundColor(Color(NSColor.textColor))

                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
}

struct ToggleMenu: View {
    let label: String
    @Binding var isOn: Bool
    let onChange: (() -> Void)?

    init(label: String, isOn: Binding<Bool>, onChange: (() -> Void)? = nil) {
        self.label = label
        self._isOn = isOn
        self.onChange = onChange
    }

    var body: some View {
        Toggle(
            isOn: Binding(
                get: { isOn },
                set: { newValue in
                    isOn = newValue
                    onChange?()
                }
            )
        ) {
            Text(label).font(Font.custom("Clash Grotesk", size: 12))
                .foregroundColor(Color(NSColor.textColor))

        }
        .toggleStyle(.switch)
    }
}

struct TextInputField: View {
    let label: String
    @Binding var userText: String

    var body: some View {
        TextField(label, text: $userText).font(
            Font.custom("Clash Grotesk", size: 12))
        .foregroundColor(Color(NSColor.textColor))

    }
}
