//
//  Item.swift
//  CustomList
//
//  Created by Kai Shao on 2024/11/4.
//

import SwiftUI

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
            case multiplePicker(Binding<[String]>, [PickerItem])
        }
        
        public enum Icon {
            case name(String), symbol(String)
        }

        public var id: String
        var title: Text
        var icon: Icon?
        var action: Action?
        var trailingText: Text?
        
        public init(id: String = UUID().uuidString, _ titleText: Text, icon: Icon? = nil, trailingText: Text? = nil, tap: (() -> Void)? = nil) {
            self.id = id
            self.title = titleText
            self.icon = icon
            self.trailingText = trailingText

            if let tap {
                self.action = .tap(tap)
            }
        }

        public init(id: String = UUID().uuidString, _ titleText: Text, icon: Icon? = nil, trailingText: Text? = nil, action: Action? = nil) {
            self.id = id
            self.title = titleText
            self.icon = icon
            self.action = action
            self.trailingText = trailingText
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
