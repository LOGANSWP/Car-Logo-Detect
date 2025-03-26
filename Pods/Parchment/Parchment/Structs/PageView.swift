import SwiftUI
import UIKit

/// The `PageView` type is a SwiftUI view that allows the user to page
/// between views while displaying a menu that moves with the
/// content. It is a wrapper around the `PagingViewController` class
/// in `Parchment`. To use the `PageView` type, create a new instance
/// with a closure that returns an array of `Page` instances. Each
/// `Page` instance contains a menu item view and a closure that
/// returns the body of the page, which can be any SwiftUI view.
///
/// Usage:
/// ```
/// PageView {
///     Page("Title 0") {
///         Text("Page 0")
///     }
///
///     Page("Title 1") {
///         Text("Page 1")
///     }
/// }
/// ```
@available(iOS 14.0, *)
public struct PageView: View {
    private let items: [PagingItem]
    private var content: ((PagingItem) -> UIViewController)?
    private var options: PagingOptions
    private var onWillScroll: ((PagingItem) -> Void)?
    private var onDidScroll: ((PagingItem) -> Void)?
    private var onDidSelect: ((PagingItem) -> Void)?

    @Binding private var selectedIndex: Int

    static func defaultOptions() -> PagingOptions {
        var options = PagingOptions()
        options.menuItemSize = .selfSizing(estimatedWidth: 50, height: 50)
        options.menuInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        options.indicatorOptions = .visible(height: 4, zIndex: .max, spacing: .zero, insets: .zero)
        options.pagingContentBackgroundColor = .clear
        options.menuBackgroundColor = .clear
        options.backgroundColor = .clear
        options.selectedBackgroundColor = .clear
        options.selectedTextColor = .systemBlue
        options.borderColor = .separator
        options.indicatorColor = .systemBlue
        options.textColor = .label
        return options
    }

    /// Initializes a new `PageView` with the specified content.
    ///
    /// - Parameters:
    ///   - selectedIndex: A binding to an integer value that
    ///     represents the index of the currently selected
    ///     page. Defaults to a constant binding with a value of
    ///     `Int.max`, indicating no page is currently selected.
    ///   - content: A closure that returns an array of `Page`
    ///     instances. The `Page` type is a struct that represents the
    ///     content of a single page in the `PageView`. The closure
    ///     must return an array of `Page` instances, which will be
    ///     used to construct the `PageView`.
    ///
    /// - Returns: A new instance of `PageView`, initialized with the
    ///   selected index, and content.
    public init(
        selectedIndex: Binding<Int> = .constant(Int.max),
        @PageBuilder content: () -> [Page]
    ) {
        _selectedIndex = selectedIndex
        self.options = PageView.defaultOptions()
        self.items = content()
            .enumerated()
            .map { (index, page) in
                PageItem(
                    identifier: page.pageIdentifier?.hashValue ?? index,
                    index: index,
                    page: page
                )
            }
    }

    /// Initializes a new `PageView` based on the specified data.
    ///
    /// - Parameters:
    ///   - data: The identified data that the `PageView` instance
    ///     uses to create pages dynamically.
    ///   - selectedIndex: A binding to an integer value that
    ///     represents the index of the currently selected
    ///     page. Defaults to a constant binding with a value of
    ///     `Int.max`, indicating no page is currently selected.
    ///   - content: A page builder that creates pages
    ///     dynamically. The `Page` type is a struct that represents
    ///     the content of a single page in the `PageView`.
    ///
    /// - Returns: A new instance of `PageView`, initialized with the
    ///   selected index, and content.
    public init<Data: RandomAccessCollection>(
        _ data: Data,
        selectedIndex: Binding<Int> = .constant(Int.max),
        content: (Data.Element) -> Page
    ) where Data.Element: Identifiable {
        _selectedIndex = selectedIndex
        self.options = PageView.defaultOptions()
        self.items = data
            .enumerated()
            .map { (index, item) in
                PageItem(
                    identifier: item.id.hashValue,
                    index: index,
                    page: content(item)
                )
            }
    }

    /// Initializes a new `PageView` based on the specified data.
    ///
    /// - Parameters:
    ///   - data: The identified data that the `PageView` instance
    ///     uses to create pages dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - selectedIndex: A binding to an integer value that
    ///     represents the index of the currently selected
    ///     page. Defaults to a constant binding with a value of
    ///     `Int.max`, indicating no page is currently selected.
    ///   - content: A page builder that creates pages
    ///     dynamically. The `Page` type is a struct that represents
    ///     the content of a single page in the `PageView`.
    ///
    /// - Returns: A new instance of `PageView`, initialized with the
    ///   selected index, and content.
    public init<Data: RandomAccessCollection, ID: Hashable>(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        selectedIndex: Binding<Int> = .constant(Int.max),
        content: (Data.Element) -> Page
    ) {
        _selectedIndex = selectedIndex
        self.options = PageView.defaultOptions()
        self.items = data
            .enumerated()
            .map { (index, item) in
                PageItem(
                    identifier: item[keyPath: id].hashValue,
                    index: index,
                    page: content(item)
                )
            }
    }

    /// Initialize a new `PageView`.
    ///
    /// - Parameters:
    ///   - options: The configuration parameters we want to customize.
    ///   - items: The array of `PagingItem`s to display in the menu.
    ///   - selectedIndex: The index of the currently selected page.
    ///   Updating this index will transition to the new index.
    ///   - content: A callback that returns the `View` for each item.
    @available(*, deprecated, message: "This method is no longer recommended. Use the new Page initializers instead.")
    public init<Item: PagingItem, Page: View>(
        options: PagingOptions = PagingOptions(),
        items: [Item],
        selectedIndex: Binding<Int> = .constant(Int.max),
        content: @escaping (Item) -> Page
    ) {
        _selectedIndex = selectedIndex
        self.options = options
        self.items = items
        self.content = { item in
            let content = content(item as! Item)
            return UIHostingController(rootView: content)
        }
    }

    public var body: some View {
        PagingControllerRepresentableView(
            items: items,
            content: content,
            options: options,
            onWillScroll: onWillScroll,
            onDidScroll: onDidScroll,
            onDidSelect: onDidSelect,
            selectedIndex: $selectedIndex
        )
    }
}

@available(iOS 14.0, *)
extension PageView {
    /// Called when the user finished scrolling to a new view.
    ///
    /// - Parameter action: A closure that is called with the
    /// paging item that was scrolled to.
    /// - Returns: An instance of self
    public func didScroll(_ action: @escaping (PagingItem) -> Void) -> Self {
        var view = self
        if let onDidScroll = view.onDidScroll {
            view.onDidScroll = { item in
                onDidScroll(item)
                action(item)
            }
        } else {
            view.onDidScroll = action
        }
        return view
    }

    /// Called when the user is about to start scrolling to a new view.
    ///
    /// - Parameter action: A closure that is called with the
    /// paging item that is being scrolled to.
    /// - Returns: An instance of self
    public func willScroll(_ action: @escaping (PagingItem) -> Void) -> Self {
        var view = self
        if let onWillScroll = view.onWillScroll {
            view.onWillScroll = { item in
                onWillScroll(item)
                action(item)
            }
        } else {
            view.onWillScroll = action
        }
        return view
    }

    /// Called when an item was selected in the menu.
    ///
    /// - Parameter action: A closure that is called with the
    /// selected paging item.
    /// - Returns: An instance of self
    public func didSelect(_ action: @escaping (PagingItem) -> Void) -> Self {
        var view = self
        if let onDidSelect = view.onDidSelect {
            view.onDidSelect = { item in
                onDidSelect(item)
                action(item)
            }
        } else {
            view.onDidSelect = action
        }
        return view
    }

    /// The size for each of the menu items.
    ///
    /// Default:
    /// ```
    /// .selfSizing(estimatedWidth: 50, height: 50)
    /// ```
    public func menuItemSize(_ size: PagingMenuItemSize) -> Self {
        var view = self
        view.options.menuItemSize = size
        return view
    }

    /// Determine the spacing between the menu items.
    public func menuItemSpacing(_ spacing: CGFloat) -> Self {
        var view = self
        view.options.menuItemSpacing = spacing
        return view
    }

    /// Determine the horizontal spacing around the title label. This
    /// only applies when using the default string initializer.
    public func menuItemLabelSpacing(_ spacing: CGFloat) -> Self {
        var view = self
        view.options.menuItemLabelSpacing = spacing
        return view
    }

    /// Determine the insets at around all the menu items,
    public func menuInsets(_ insets: EdgeInsets) -> Self {
        var view = self
        view.options.menuInsets = UIEdgeInsets(
            top: insets.top,
            left: insets.leading,
            bottom: insets.bottom,
            right: insets.trailing
        )
        return view
    }

    /// Determine the insets at around all the menu items.
    public func menuInsets(_ edges: SwiftUI.Edge.Set, _ length: CGFloat) -> Self {
        var view = self
        if edges.contains(.all) {
            view.options.menuInsets.top = length
            view.options.menuInsets.bottom = length
            view.options.menuInsets.left = length
            view.options.menuInsets.right = length
        }
        if edges.contains(.vertical) {
            view.options.menuInsets.top = length
            view.options.menuInsets.bottom = length
        }
        if edges.contains(.horizontal) {
            view.options.menuInsets.left = length
            view.options.menuInsets.right = length
        }
        if edges.contains(.top) {
            view.options.menuInsets.top = length
        }
        if edges.contains(.bottom) {
            view.options.menuInsets.bottom = length
        }
        if edges.contains(.leading) {
            view.options.menuInsets.left = length
        }
        if edges.contains(.trailing) {
            view.options.menuInsets.right = length
        }
        return view
    }

    /// Determine the insets at around all the menu items.
    public func menuInsets(_ length: CGFloat) -> Self {
        var view = self
        view.options.menuInsets = UIEdgeInsets(
            top: length,
            left: length,
            bottom: length,
            right: length
        )
        return view
    }

    /// Determine whether the menu items should be centered when all
    /// the items can fit within the bounds of the view.
    public func menuHorizontalAlignment(_ alignment: PagingMenuHorizontalAlignment) -> Self {
        var view = self
        view.options.menuHorizontalAlignment = alignment
        return view
    }

    /// Determine the position of the menu relative to the content.
    public func menuPosition(_ position: PagingMenuPosition) -> Self {
        var view = self
        view.options.menuPosition = position
        return view
    }

    /// Determine the transition behavior of menu items while
    /// scrolling the content.
    public func menuTransition(_ transition: PagingMenuTransition) -> Self {
        var view = self
        view.options.menuTransition = transition
        return view
    }

    /// Determine how users can interact with the menu items.
    public func menuInteraction(_ interaction: PagingMenuInteraction) -> Self {
        var view = self
        view.options.menuInteraction = interaction
        return view
    }

    /// Determine how users can interact with the page view
    /// controller.
    public func contentInteraction(_ interaction: PagingContentInteraction) -> Self {
        var view = self
        view.options.contentInteraction = interaction
        return view
    }

    /// Determine how the selected menu item should be aligned when it
    /// is selected. Effectively the same as the
    /// `UICollectionViewScrollPosition`.
    public func selectedScrollPosition(_ position: PagingSelectedScrollPosition) -> Self {
        var view = self
        view.options.selectedScrollPosition = position
        return view
    }

    /// Add an indicator view to the selected menu item. The indicator
    /// width will be equal to the selected menu items width. Insets
    /// only apply horizontally.
    public func indicatorOptions(_ options: PagingIndicatorOptions) -> Self {
        var view = self
        view.options.indicatorOptions = options
        return view
    }

    /// Add a border at the bottom of the menu items. The border will
    /// be as wide as the menu items. Insets only apply horizontally.
    public func borderOptions(_ options: PagingBorderOptions) -> Self {
        var view = self
        view.options.borderOptions = options
        return view
    }

    /// The scroll navigation orientation of the content in the page
    /// view controller.
    public func contentNavigationOrientation(_ orientation: PagingNavigationOrientation) -> Self {
        var view = self
        view.options.contentNavigationOrientation = orientation
        return view
    }
}

@available(iOS 14.0, *)
extension PageView {
    /// Determine the color of the indicator view.
    public func indicatorColor(_ color: Color) -> Self {
        var view = self
        view.options.indicatorColor = UIColor(color)
        return view
    }

    /// Determine the color of the border view.
    public func borderColor(_ color: Color) -> Self {
        var view = self
        view.options.borderColor = UIColor(color)
        return view
    }

    /// The color of the menu items when selected.
    public func selectedColor(_ color: Color) -> Self {
        var view = self
        view.options.selectedTextColor = UIColor(color)
        return view
    }

    /// The foreground color of the menu items when not selected.
    public func foregroundColor(_ color: Color) -> Self {
        var view = self
        view.options.textColor = UIColor(color)
        return view
    }
    
    /// The background color for the menu items.
    public func backgroundColor(_ color: Color) -> Self {
        var view = self
        view.options.backgroundColor = UIColor(color)
        return view
    }

    /// The background color for the selected menu item.
    public func selectedBackgroundColor(_ color: Color) -> Self {
        var view = self
        view.options.selectedBackgroundColor = UIColor(color)
        return view
    }

    /// The background color for the view behind the menu items.
    public func menuBackgroundColor(_ color: Color) -> Self {
        var view = self
        view.options.menuBackgroundColor = UIColor(color)
        return view
    }

    // The background color for the paging contents.
    public func contentBackgroundColor(_ color: Color) -> Self {
        var view = self
        view.options.pagingContentBackgroundColor = UIColor(color)
        return view
    }
}
