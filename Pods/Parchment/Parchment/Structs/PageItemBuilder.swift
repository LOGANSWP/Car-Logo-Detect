import SwiftUI

@available(iOS 14.0, *)
@resultBuilder
public struct PageBuilder {
    public static func buildExpression(_ expression: Page) -> [Page] {
        return [expression]
    }

    public static func buildExpression(_ expression: Page?) -> [Page] {
        if let expression = expression {
            return [expression]
        }
        return []
    }

    public static func buildExpression(_ expression: [Page]) -> [Page] {
        return expression
    }

    public static func buildBlock(_ components: [Page]) -> [Page] {
        return components
    }

    public static func buildBlock(_ components: [Page]...) -> [Page] {
        return components.reduce([], +)
    }

    public static func buildArray(_ components: [[Page]]) -> [Page] {
        return components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [Page]?) -> [Page] {
        return component ?? []
    }

    public static func buildEither(first component: [Page]) -> [Page] {
        return component
    }

    public static func buildEither(second component: [Page]) -> [Page] {
        return component
    }

    public static func buildFor(_ component: [Page]) -> [Page] {
        return component
    }
}
