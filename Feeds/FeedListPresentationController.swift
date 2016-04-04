import UIKit

public final class FeedListPresentationController: UIPresentationController {
    private var navigationBar: UIView {
        return navigationBarController.view
    }

    private lazy var navigationBarController: NavigationBarController = {
        let controller = NavigationBarController(navigationItem: self.presentedViewController.navigationItem)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()

    private let dimmingView: UIView = {
        let view = UIView()
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        return view
    }()

    override public init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }

    public override func preferredContentSizeDidChangeForChildContentContainer(container: UIContentContainer) {
        super.preferredContentSizeDidChangeForChildContentContainer(container)

        if let container = container as? UIViewController where container == presentedViewController {
            containerView?.setNeedsLayout()
        }
    }

    public override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if let container = container as? UIViewController where container == presentedViewController {
            return presentedViewController.preferredContentSize
        } else {
            return super.sizeForChildContentContainer(container, withParentContainerSize: parentSize)
        }
    }

    public override func frameOfPresentedViewInContainerView() -> CGRect {
        guard let containerView = containerView else {
            return .zero
        }

        let presentedViewContentSize = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerView.bounds.size)

        var presentedViewFrame = containerView.bounds
        presentedViewFrame.size.height = presentedViewContentSize.height

        return presentedViewFrame
    }

    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        if let containerView = containerView {
            presentedView()?.frame = frameOfPresentedViewInContainerView()
            dimmingView.frame = containerView.bounds
        }
    }

    override public func presentationTransitionWillBegin() {
        guard let containerView = containerView, parentContainerView = containerView.superview else {
            return
        }

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true

        parentContainerView.insertSubview(navigationBar, aboveSubview: containerView)

        containerView.addSubview(dimmingView)

        NSLayoutConstraint.activateConstraints([
            navigationBar.topAnchor.constraintEqualToAnchor(parentContainerView.topAnchor),
            navigationBar.leadingAnchor.constraintEqualToAnchor(parentContainerView.leadingAnchor),
            navigationBar.trailingAnchor.constraintEqualToAnchor(parentContainerView.trailingAnchor),
            navigationBar.bottomAnchor.constraintEqualToAnchor(containerView.topAnchor),
            containerView.leadingAnchor.constraintEqualToAnchor(parentContainerView.leadingAnchor),
            containerView.trailingAnchor.constraintEqualToAnchor(parentContainerView.trailingAnchor),
            containerView.bottomAnchor.constraintEqualToAnchor(parentContainerView.bottomAnchor),
        ])

        navigationBar.alpha = 0
        dimmingView.alpha = 0

        let transitionCoordinator = presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({ context in
            self.navigationBar.alpha = 1
            self.dimmingView.alpha = 1
        }, completion: nil)
    }

    override public func dismissalTransitionWillBegin() {
        presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ (context) in
            self.dimmingView.alpha = 0
            self.navigationBar.alpha = 0
        }, completion: { (context) in
            if context.isCancelled() == false {
                self.dimmingView.removeFromSuperview()
                self.navigationBar.removeFromSuperview()
            }
        })
    }

    override public func dismissalTransitionDidEnd(completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
            navigationBar.removeFromSuperview()
        }
    }
}

final class NavigationBarController: UIViewController, UINavigationBarDelegate {
    private lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.delegate = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar

    }()

    init(navigationItem: UINavigationItem) {
        super.init(nibName: nil, bundle: nil)
        navigationBar.pushNavigationItem(navigationItem, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navigationBar)

        NSLayoutConstraint.activateConstraints([
            navigationBar.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            navigationBar.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            navigationBar.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            navigationBar.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        ])
    }

    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize = navigationBar.bounds.size
    }
}
