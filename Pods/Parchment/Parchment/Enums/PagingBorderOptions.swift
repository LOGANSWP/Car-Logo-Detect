import UIKit

public enum PagingBorderOptions {
    case hidden
    case visible(
        height: CGFloat,
        zIndex: Int = 0,
        insets: UIEdgeInsets = .zero
    )
}
