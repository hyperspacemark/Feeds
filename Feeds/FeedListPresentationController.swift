import UIKit

final class FeedListPresentationController: UIPresentationController {

    // MARK: - Properties

    private var navigationBar: UIView {
        return navigationBarController.view
    }

    private lazy var navigationBarController: NavigationBarController = {
        let controller = NavigationBarController(navigationItem: self.presentedViewController.navigationItem)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()

    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDimmingView))
        view.addGestureRecognizer(tapGesture)

        return view
    }()


    // MARK: - Initialization

    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }


    // MARK: - UIPresentationController

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, parentContainerView = containerView.superview else {
            return
        }

        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dimmingView)

        parentContainerView.insertSubview(navigationBar, aboveSubview: containerView)

        NSLayoutConstraint.activateConstraints([
            navigationBar.topAnchor.constraintEqualToAnchor(parentContainerView.topAnchor),
            navigationBar.leadingAnchor.constraintEqualToAnchor(parentContainerView.leadingAnchor),
            navigationBar.trailingAnchor.constraintEqualToAnchor(parentContainerView.trailingAnchor),
            containerView.topAnchor.constraintEqualToAnchor(navigationBar.bottomAnchor),
            containerView.leadingAnchor.constraintEqualToAnchor(parentContainerView.leadingAnchor),
            containerView.trailingAnchor.constraintEqualToAnchor(parentContainerView.trailingAnchor),
            containerView.bottomAnchor.constraintEqualToAnchor(parentContainerView.bottomAnchor)
        ])

        navigationBar.alpha = 0
        dimmingView.alpha = 0

        let transitionCoordinator = presentingViewController.transitionCoordinator()

        UIView.animateWithDuration(0.25, animations: {
            self.navigationBar.alpha = 1
            self.dimmingView.alpha = 1
        }, completion: nil)
    }

    override func presentationTransitionDidEnd(completed: Bool) {
        if !completed {
            navigationBar.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        presentingViewController.transitionCoordinator()?.animateAlongsideTransition({ (context) in
            self.dimmingView.alpha = 0
            self.navigationBar.alpha = 0
        }, completion: nil)
    }

    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            navigationBar.removeFromSuperview()
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView.frame = containerView?.bounds ?? .zero
        presentedView()?.frame = frameOfPresentedViewInContainerView()
    }

    override func frameOfPresentedViewInContainerView() -> CGRect {
        guard let containerView = containerView else {
            return .zero
        }

        let presentedViewContentSize = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerView.bounds.size)

        var presentedViewFrame = containerView.bounds
        presentedViewFrame.size.height = presentedViewContentSize.height

        return presentedViewFrame
    }

    
    // MARK: - UIContentContainer

    override func preferredContentSizeDidChangeForChildContentContainer(container: UIContentContainer) {
        super.preferredContentSizeDidChangeForChildContentContainer(container)

        if let container = container as? UIViewController where container == presentedViewController {
            containerView?.setNeedsLayout()
        }
    }

    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if let container = container as? UIViewController where container == presentedViewController {
            return presentedViewController.preferredContentSize
        } else {
            return super.sizeForChildContentContainer(container, withParentContainerSize: parentSize)
        }
    }


    // MARK: - Private

    @objc private func didTapDimmingView() {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}


final class NavigationBarController: UIViewController, UINavigationBarDelegate {

    // MARK: - Properties

    private lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.delegate = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()


    // MARK: - Initialization

    init(navigationItem: UINavigationItem) {
        super.init(nibName: nil, bundle: nil)
        navigationBar.pushNavigationItem(navigationItem, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteColor()
        view.addSubview(navigationBar)

        NSLayoutConstraint.activateConstraints([
            navigationBar.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            navigationBar.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            navigationBar.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            navigationBar.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize = navigationBar.bounds.size
    }


    // MARK: - UIBarPositioningDelegate

    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
