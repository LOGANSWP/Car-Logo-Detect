import UIKit

public enum PagingIndicatorOptions {
    case hidden
    case visible(
        height: CGFloat,
        zIndex: Int = 1,
        spacing: UIEdgeInsets = .zero,
        insets: UIEdgeInsets = .zero
    )
}
