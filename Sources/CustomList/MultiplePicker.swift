//
//  MultiplePicker.swift
//  CustomList
//
//  Created by Kai Shao on 2024/11/4.
//

import SwiftUI

struct MultiplePicker: View {
    @Binding var selection: [String]
    var items: [CustomList.Item.PickerItem]

    @State private var isPresented = false

    // make a popover with a list of items
    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            HStack {
                if selection.isEmpty {
                    Text("Select")
                        .foregroundColor(.secondary)
                } else {
                    Text(selection.joined(separator: ", "))
                        .foregroundColor(.secondary)
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .padding(8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .popover(isPresented: $isPresented) {
            NavigationStack {
                List {
                    ForEach(items) { item in
                        Button {
                            if selection.contains(item.id) {
                                selection.removeAll(where: { $0 == item.id })
                            } else {
                                selection.append(item.id)
                            }
                        } label: {
                            HStack {
                                item.title
                                Spacer()
                                if selection.contains(item.id) {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            isPresented.toggle()
                        }
                        .bold()
                    }
                }
            }
            .presentationDetents(
                [.custom(BarDetent.self)]
            )
        }
    }
}

private struct BarDetent: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        max(200, context.maxDetentValue * 0.4)
    }
}