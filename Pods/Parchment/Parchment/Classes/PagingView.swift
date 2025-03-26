import UIKit

/// A custom `UIView` subclass used by `PagingViewController`,
/// responsible for setting up the view hierarchy and its layout
/// constraints.
///
/// If you need additional customization, like changing the
/// constraints, you can subclass `PagingView` and override
/// `loadView:` in `PagingViewController` to use your subclass.
open class PagingView: UIView {
    // MARK: Public Properties

    public let collectionView: UICollectionView
    public let pageView: UIView
    public var options: PagingOptions {
        didSet {
            heightConstraint?.constant = options.menuHeight
            collectionView.backgroundColor = options.menuBackgroundColor
        }
    }

    // MARK: Private Properties

    private var heightConstraint: NSLayoutConstraint?

    // MARK: Initializers

    /// Creates an instance of `PagingView`.
    ///
    /// - Parameter options: The `PagingOptions` passed into the
    /// `PagingViewController`.
    public init(options: PagingOptions, collectionView: UICollectionView, pageView: UIView) {
        self.options = options
        self.collectionView = collectionView
        self.pageView = pageView
        super.init(frame: .zero)
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public Methods
    /// Configures the view hierarchy, sets up the layout constraints
    /// and does any other customization based on the `PagingOptions`.
    /// Override this if you need any custom behavior.
    open func configure() {
        collectionView.backgroundColor = options.menuBackgroundColor
        addSubview(pageView)
        addSubview(collectionView)
        setupConstraints()
    }

    /// Sets up all the layout constraints. Override this if you need to
    /// make changes to how the views are layed out.
    open func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageView.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: options.menuHeight)
        heightConstraint.isActive = true
        heightConstraint.priority = .defaultHigh
        self.heightConstraint = heightConstraint

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        switch options.menuPosition {
        case .top:
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                pageView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
                pageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                pageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                pageView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
}
