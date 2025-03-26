import Foundation

/// Represents the current state of a page. This will be passed into
/// the `Page` struct while scrolling, and can be used to update the
/// appearance of the corresponding menu item to reflect the current
/// progress and selection state.
public struct PageState {
    public let progress: CGFloat
    public let isSelected: Bool
}
