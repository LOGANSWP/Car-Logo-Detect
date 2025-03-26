import Foundation

@available(iOS 14.0, *)
struct PageItem: PagingItem, Hashable, Comparable {
    let identifier: Int
    let index: Int
    let page: Page

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(index)
    }

    static func == (lhs: PageItem, rhs: PageItem) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.index == rhs.index
    }

    static func < (lhs: PageItem, rhs: PageItem) -> Bool {
        return lhs.index < rhs.index
    }
}
