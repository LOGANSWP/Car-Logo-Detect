import UIKit
import SwiftUI

/// A custom `UICollectionViewReusableView` subclass used to display a
/// view that indicates the currently selected cell. You can subclass
/// this type if you need further customization; just override the
/// `indicatorClass` property in `PagingViewController`.
@available(iOS 14.0, *)
final class PagingHostingIndicatorView: PagingIndicatorView {
    private let hostingController: UIHostingController<PagingIndicator>

    override init(frame: CGRect) {
        let configuration = PagingIndicatorConfiguration(backgroundColor: .clear)
        let rootView = PagingIndicator(configuration: configuration)
        self.hostingController = UIHostingController(rootView: rootView)

        super.init(frame: frame)

        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.view.backgroundColor = .clear
        hostingController.view.clipsToBounds = false
        clipsToBounds = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window == nil {
            hostingController.willMove(toParent: nil)
            hostingController.removeFromParent()
            hostingController.didMove(toParent: nil)
        } else if let parent = parentViewController() {
            hostingController.willMove(toParent: parent)
            parent.addChild(hostingController)
            addSubview(hostingController.view)
            hostingController.didMove(toParent: parent)
        }
    }

    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? PagingIndicatorLayoutAttributes {
            let configuration = PagingIndicatorConfiguration(
                backgroundColor: Color(attributes.backgroundColor ?? .clear)
            )
            hostingController.rootView = PagingIndicator(configuration: configuration)
            hostingController.view.frame = bounds
        }
    }

    private func parentViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}
