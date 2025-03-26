import Foundation

/// The `PagingItem` protocol is used to generate menu items for all
/// the view controllers, without having to actually allocate them
/// before they are needed. You can store whatever you want in here
/// that makes sense for what you're displaying.
public protocol PagingItem {
    var identifier: Int { get }
    func isEqual(to item: PagingItem) -> Bool
    func isBefore(item: PagingItem) -> Bool
}

extension PagingItem where Self: Equatable {
    public func isEqual(to item: PagingItem) -> Bool {
        guard let item = item as? Self else { return false }
        return self == item
    }
}

extension PagingItem where Self: Comparable {
    public func isBefore(item: PagingItem) -> Bool {
        guard let item = item as? Self else { return false }
        return self < item
    }
}

extension PagingItem where Self: Hashable {
    public var identifier: Int {
        return hashValue
    }
}

/// The PagingIndexable protocol is used to compare items in your
/// menu. Conform to this protocol when you need to mix multiple
/// PagingItem types that all need to be compared.
//
/// The PagingIndexable protocol requires the conforming type to
/// provide an index property of type Int, which is used to compare
/// items in the menu.
///
/// For example, if you have a menu that contains both PagingIndexItem
/// and PagingImageItem types, you can conform both types to
/// PagingIndexable and Parchment will provide a default
/// implementation that will be used to animate between them.
public protocol PagingIndexable {
    var index: Int { get }
}

extension PagingItem where Self: PagingIndexable {
    public func isBefore(item: PagingItem) -> Bool {
        guard let item = item as? PagingIndexable else { return false }
        return index < item.index
    }
}
