import SwiftUI

@resultBuilder
public struct CustomListBuilder {
    public static func buildBlock(_ components: CustomList.Section...) -> [CustomList.Section] {
        components
    }
}

@resultBuilder
public struct CustomListItemBuilder {
    public static func buildBlock(_ components: CustomList.Item...) -> [CustomList.Item] {
        components
    }
}

//public struct CustomListSectionModifier: ViewModifier {
//    @Environment(\.colorScheme) private var colorScheme
//    @Environment(ThemeProvider.self) private var themeProvider
//    var theme: ThemeScheme { themeProvider.scheme }
//
//    var background: Color {
//        switch theme {
//        case .newYear_2024:
//            return theme.accentColor.opacity(0.05)
//        case .light, .system:
//            return .white.opacity(0.3)
//        case .dark:
//            return Color(UIColor.secondarySystemBackground)
//        }
//    }
//
//    public func body(content: Content) -> some View {
//        content
//            .background(background)
//            .clipShape(.rect(cornerRadius: 12))
//    }
//}

public struct CustomList: View {
    var sections: [Section]
    var showingItemID: (String, String)?

    @Environment(\.colorScheme) private var colorScheme
//    @Environment(ThemeProvider.self) private var themeProvider
//    var theme: ThemeScheme { themeProvider.scheme }

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
                    .font(.title2.bold())
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
//            .modifier(CustomListSectionModifier())

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
                Image(systemName: "applelogo")
                    .font(.body.bold())
                    .padding(.trailing, 8)
                
                item.title

                Spacer()

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
                case nil:
                    EmptyView()
                }
            }
            .padding([.horizontal, .top])
            .padding(.bottom, (!isLast && !showingSeparators) ? 0 : nil)

            if showingSeparators {
                Divider()
                    .padding(.leading)
                    .padding(.leading)
                    .padding(.leading)
            }
        }
        .contentShape(Rectangle())
    
    }
}

extension CustomList {
    public struct Item: Identifiable {
        public struct PickerItem: Identifiable {
            public var id: String
            var title: Text

            public init(id: String, title: Text) {
                self.id = id
                self.title = title
            }
        }

        public enum Action {
            case tap(() -> Void)
            case toggle(Binding<Bool>)
            case picker(Binding<String>, [PickerItem])
        }

        public var id: String
        var title: Text
        var icon: String?
        var action: Action?

        public init(id: String = UUID().uuidString, title: String, icon: String = "about", tap: (() -> Void)? = nil) {
            self.id = id
            self.title = Text(title)
            self.icon = icon

            if let tap {
                self.action = .tap(tap)
            }
        }

        public init(id: String = UUID().uuidString, _ titleText: Text, icon: String? = nil, tap: (() -> Void)? = nil) {
            self.id = id
            self.title = titleText
            self.icon = icon

            if let tap {
                self.action = .tap(tap)
            }
        }

        public init(id: String = UUID().uuidString, _ titleText: Text, icon: String = "about", action: Action? = nil) {
            self.id = id
            self.title = titleText
            self.icon = icon
            self.action = action
        }

        public init(id: String = UUID().uuidString, title: String, icon: String = "about", action: Action? = nil) {
            self.id = id
            self.title = Text(title)
            self.icon = icon
            self.action = action
        }
    }

    public struct Section: Identifiable {
        public var id: String
        var items: [Item]
        var header: Text?
        var footer: Text?
        var showingSeparators: Bool

        public init(id: String = UUID().uuidString, header: Text? = nil, footer: Text? = nil, @CustomListItemBuilder items: () -> [Item],  showingSeparators: Bool = true) {
            self.id = id
            self.items = items()
            self.header = header
            self.footer = footer
            self.showingSeparators = showingSeparators
        }
    }
}

#if DEBUG
    #Preview {
        CustomList {
            CustomList.Section(footer: Text("footer")) {
                CustomList.Item(title: "hahha") {}
                CustomList.Item(title: "hahha3", action: nil)
            }
            
            CustomList.Section {
                CustomList.Item(title: "hahha") {}
                CustomList.Item(title: "hahha3", action: nil)
            }
            
            CustomList.Section {
                CustomList.Item(title: "hahha2", action: nil)
                CustomList.Item(title: "toggle", action: .toggle(.constant(true)))
                CustomList.Item(title: "picker", action: .picker(.constant("1"), [
                    .init(id: "1", title: Text("1")),
                    .init(id: "2", title: Text("2")),
                ]))
            }
        }
    }
#endif
