import SwiftUI

public extension EnvironmentValues {
    @Entry var customListSectionBackground: Color = Color(UIColor.systemBackground)
    @Entry var customListSectionCornerRadius: CGFloat = 12
}

public struct CustomList: View {
    var sections: [Section]
    var showingItemID: (String, String)?

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.customListSectionBackground) private var customListSectionBackground
    @Environment(\.customListSectionCornerRadius) private var customListSectionCornerRadius

    public init(showingItemID: (String, String)? = nil, @CustomListBuilder sections: () -> [Section]) {
        self.sections = sections()
        self.showingItemID = showingItemID
    }

    public var body: some View {
        VStack(spacing: 16) {
            ForEach(sections) { section in
                let isLast = section.id == sections.last?.id
                let hasPaddingBottom = section.header != nil || isLast

                sectionView(section)
                    .padding(.bottom, hasPaddingBottom ? nil : 0)
            }
        }
        .padding()
    }

    func showingItem(itemID: String?, sectionID: String) -> Bool {
        if let showingItemID {
            if let itemID {
                return showingItemID.0 == sectionID && showingItemID.1 == itemID
            }

            return showingItemID.0 == sectionID
        }

        return true
    }

    func sectionView(_ section: Section) -> some View {
        VStack(alignment: .leading) {
            if let header = section.header {
                header
                    .font(.footnote)
                    .foregroundStyle(Color(UIColor.secondaryLabel))
                    .padding(.leading)
            }

            VStack(spacing: 0) {
                ForEach(section.items) { item in
                    let isLast = section.items.last?.id == item.id
                    let showingSeparators = section.showingSeparators && !isLast

                    if showingItem(itemID: item.id, sectionID: section.id) {
                        switch item.action {
                        case .tap(let action):
                            Button(action: action) {
                                itemView(item, isLast: isLast, showingSeparators: showingSeparators)
                            }
                            .buttonStyle(.plain)
                        default:
                            itemView(item, isLast: isLast, showingSeparators: showingSeparators)
                        }
                    }
                }
            }
            .background(customListSectionBackground)
            .clipShape(.rect(cornerRadius: customListSectionCornerRadius))

            if showingItem(itemID: nil, sectionID: section.id) {
                if let footer = section.footer {
                    footer
                        .font(.footnote)
                        .foregroundStyle(Color(UIColor.secondaryLabel))
                        .padding(.leading)
                }
            }
        }
    }

    func itemView(_ item: Item, isLast: Bool, showingSeparators: Bool) -> some View {
        ZStack(alignment: .bottom) {
            HStack {
                if let icon = item.icon {
                    switch icon {
                    case .name(let string):
                        Image(string)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    case .symbol(let string):
                        Image(systemName: string)
                            .bold()
                            .padding(.trailing, 8)
                    }
                }
                
                item.title

                Spacer()
                
                if let trailingText = item.trailingText {
                    trailingText
                }

                switch item.action {
                case .tap:
                    Image(systemName: "chevron.right")
                        .font(.caption)
                case .toggle(let isOn):
                    Toggle("", isOn: isOn)
                case .picker(let selection, let items):
                    Picker("", selection: selection) {
                        ForEach(items) { item in
                            item.title
                                .tag(item.id)
                        }
                    }
                case .multiplePicker(let selection, let items):
                    MultiplePicker(selection: selection, items: items)
                case nil:
                    EmptyView()
                }
            }
            .padding([.horizontal, .top])
            .padding(.bottom, (!isLast && !showingSeparators) ? 0 : nil)

            if showingSeparators {
                Divider()
                    .padding(.leading, item.icon == nil ? 0 : nil)
                    .padding(.leading, item.icon == nil ? 0 : nil)
                    .padding(.leading)
            }
        }
        .contentShape(Rectangle())
    
    }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
    @Previewable @State var multiplePickerItems: [String] = []
    
    CustomList {
        CustomList.Section(footer: Text("footer")) {
            CustomList.Item(Text("hahha"), icon: .symbol("applelogo")) {}
            CustomList.Item(Text("hahha3"), icon: .symbol("person"), action: nil)
        }
        
        CustomList.Section(header: Text("Header")) {
            CustomList.Item(Text("hahha"), icon: .symbol("star")) {}
            CustomList.Item(Text("hahha3"), action: nil)
        }
        
        CustomList.Section {
            CustomList.Item(Text("hahha2"), action: nil)
            
            CustomList.Item(Text("toggle"), action: .toggle(.constant(true)))
            
            CustomList.Item(Text("picker"), action: .picker(.constant("1"), [
                .init(id: "1", title: Text("1")),
                .init(id: "2", title: Text("2")),
            ]))
            
            CustomList.Item(
                Text("multiplePicker"),
                action: .multiplePicker(
                    $multiplePickerItems, [
                        .init(id: "1", title: Text("1")),
                        .init(id: "2", title: Text("2")),
                    ]
                )
            )
        }
    }
}
#endif
