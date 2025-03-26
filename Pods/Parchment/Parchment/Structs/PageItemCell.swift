import UIKit
import Foundation

@available(iOS 14.0, *)
final class PageItemCell: PagingCell {
    private var page: Page!
    private var options: PagingOptions?
    private var itemSelected: Bool = false

    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        let item = pagingItem as! PageItem
        let state = PageState(progress: selected ? 1 : 0, isSelected: selected)

        self.page = item.page
        self.options = options
        self.itemSelected = selected

        contentConfiguration = page.header(options, state)
        backgroundColor = selected ? options.selectedBackgroundColor : options.backgroundColor
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PagingCellLayoutAttributes, let options = options {
            let state = PageState(progress: attributes.progress, isSelected: itemSelected)
            contentConfiguration = page.header(options, state)
            backgroundColor = UIColor.interpolate(
                from: options.backgroundColor,
                to: options.selectedBackgroundColor,
                with: attributes.progress
            )
        }
    }
}
