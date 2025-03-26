import UIKit
import SwiftUI

@available(iOS 14.0, *)
struct PageContentConfiguration<Content: View>: UIContentConfiguration {
    let content: Content
    var margins: NSDirectionalEdgeInsets

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.margins = .zero
    }

    func makeContentView() -> UIView & UIContentView {
        return PageContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> PageContentConfiguration<Content> {
        return self
    }

    func margins(_ edges: SwiftUI.Edge.Set = .all, _ length: CGFloat) -> PageContentConfiguration<Content> {
        var configuration = self
        configuration.margins = NSDirectionalEdgeInsets(
            top: edges.contains(.top) ? length : margins.top,
            leading: edges.contains(.leading) ? length : margins.leading,
            bottom: edges.contains(.bottom) ? length : margins.bottom,
            trailing: edges.contains(.trailing) ? length : margins.trailing
        )
        return configuration
    }
}

@available(iOS 14.0, *)
final class PageContentView<Content: View>: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            if let configuration = configuration as? PageContentConfiguration<Content> {
                margins = configuration.margins
                hostingController.rootView = configuration.content
                directionalLayoutMargins = configuration.margins
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        return sizeThatFits(UIView.layoutFittingCompressedSize)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = hostingController.sizeThatFits(in: size)
        return CGSize(
            width: size.width + margins.leading + margins.trailing,
            height: size.height + margins.top + margins.bottom
        )
    }

    private var margins: NSDirectionalEdgeInsets
    private let hostingController: UIHostingController<Content>

    init(configuration: PageContentConfiguration<Content>) {
        self.configuration = configuration
        self.hostingController = UIHostingController(rootView: configuration.content)
        self.margins = configuration.margins
        super.init(frame: .zero)
        configure()
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
            hostingController.didMove(toParent: parent)
        }
    }

    private func configure() {
        hostingController.view.backgroundColor = .clear
        addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
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
