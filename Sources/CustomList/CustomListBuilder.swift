import SwiftUI

@resultBuilder
public struct CustomListBuilder {
    public static func buildBlock(_ components: CustomList.Section...) -> [CustomList.Section] {
        components
    }
    
    public static func buildBlock(_ components: [CustomList.Section]) -> [CustomList.Section] {
        components
    }
}

@resultBuilder
public struct CustomListItemBuilder {
    public static func buildBlock(_ components: [CustomList.Item]) -> [CustomList.Item] {
        components
    }
    
    public static func buildBlock(_ components: [CustomList.Item]...) -> [CustomList.Item] {
        components.flatMap { $0 }
    }
    
    public static func buildBlock(_ components: CustomList.Item...) -> [CustomList.Item] {
        components
    }
}

//supports if else
public extension CustomListBuilder {
    static func buildIf(_ component: [CustomList.Section]?) -> [CustomList.Section] {
        component ?? []
    }
    
    static func buildOptional(_ component: [CustomList.Section]?) -> [CustomList.Section] {
        component ?? []
    }
}

// supports switch
public extension CustomListBuilder {
    static func buildEither(first component: [CustomList.Section]) -> [CustomList.Section] {
        component
    }

    static func buildEither(second component: [CustomList.Section]) -> [CustomList.Section] {
        component
    }
}

public extension CustomListItemBuilder {
    static func buildIf(_ component: [CustomList.Item]?) -> [CustomList.Item] {
        component ?? []
    }
    
    static func buildOptional(_ component: [CustomList.Item]?) -> [CustomList.Item] {
        component ?? []
    }
    
    static func buildArray(_ components: [[CustomList.Item]]) -> [CustomList.Item] {
        components.flatMap { $0 }
    }
    
    static func buildExpression(_ expression: CustomList.Item) -> [CustomList.Item] {
        [expression]
    }
    
    static func buildExpression(_ expression: [CustomList.Item]) -> [CustomList.Item] {
        expression
    }
}

public extension CustomListItemBuilder {
    static func buildEither(first component: [CustomList.Item]) -> [CustomList.Item] {
        component
    }

    static func buildEither(second component: [CustomList.Item]) -> [CustomList.Item] {
        component
    }
}
