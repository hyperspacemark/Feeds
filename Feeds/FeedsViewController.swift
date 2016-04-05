import UIKit

public final class FeedsViewController: UIViewController {
    public var viewControllers: [UIViewController] = [] {
        didSet {
            guard let firstViewController = viewControllers.first else {
                return
            }

            _navigationController.viewControllers = [firstViewController]
        }
    }

    private var currentViewController: UIViewController? {
        return _navigationController.viewControllers.first
    }

    private lazy var _navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.delegate = self
        return navigationController
    }()

    private lazy var titleViewButton: DropDownButton = {
        let button = DropDownButton()
        button.tintColor = self.view.tintColor
        button.addTarget(self, action: #selector(didTapTitleViewButton), forControlEvents: .PrimaryActionTriggered)
        return button
    }()

    @objc private func didTapTitleViewButton() {
        guard let currentViewController = currentViewController, selectedIndex = viewControllers.indexOf(currentViewController) else {
            return
        }

        let feedListViewController = FeedListViewController(viewControllers: viewControllers, selectedIndex: selectedIndex)
        feedListViewController.delegate = self
        feedListViewController.modalPresentationStyle = .Custom

        showViewController(feedListViewController, sender: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController(_navigationController)
        view.addSubview(_navigationController.view)
        _navigationController.didMoveToParentViewController(self)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _navigationController.view.frame = view.bounds
    }
}

extension FeedsViewController: FeedListViewControllerDelegate {
    public func feedListViewController(feedListViewController: FeedListViewController, didSelectViewController viewController: UIViewController) {
        _navigationController.viewControllers = [viewController]
        feedListViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    public func feedListViewControllerDidCancel(feedListViewController: FeedListViewController) {
        feedListViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension FeedsViewController: UINavigationControllerDelegate {
    public func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        guard let rootViewController = navigationController.viewControllers.first where rootViewController == viewController else {
            return
        }

        titleViewButton.title = rootViewController.title
        viewController.navigationItem.titleView = titleViewButton
    }

    @objc private func compose() {
        
    }
}
