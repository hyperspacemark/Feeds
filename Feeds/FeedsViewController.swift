import UIKit

final class FeedsViewController: UIViewController {

    // MARK: - Properties

    var viewControllers: [UIViewController] = [] {
        didSet {
            precondition(!viewControllers.containsNavigationOrTabBarControllers, "Provided view controllers should not contain UINavigationController or UITabBarController subclasses.")
            selectedViewController = viewControllers.first
        }
    }

    var selectedViewController: UIViewController? {
        didSet {
            if let selectedViewController = selectedViewController {
                precondition(viewControllers.contains(selectedViewController), "The provided selectedViewController must be a member of the viewControllers collection.")
//                _navigationController.viewControllers = [selectedViewController]
            }
        }
    }

    var selectedIndex: Int? {
        guard let selectedViewController = selectedViewController else {
            return nil
        }

        return viewControllers.indexOf(selectedViewController)
    }


    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        installNavigationController()
    }


    // MARK: - Private

    private lazy var _navigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: AdjustmentViewController())
        navigationController.delegate = self
        navigationController.view.translatesAutoresizingMaskIntoConstraints = false
        return navigationController
    }()

    private lazy var titleViewButton: DropDownButton = {
        let button = DropDownButton()
        button.tintColor = self.view.tintColor
        button.addTarget(self, action: #selector(didTapTitleViewButton), forControlEvents: .PrimaryActionTriggered)
        return button
    }()

    @objc private func didTapTitleViewButton() {
        let feedListViewController = FeedListViewController(viewControllers: viewControllers, selectedIndex: selectedIndex)
        feedListViewController.delegate = self
        showViewController(feedListViewController, sender: nil)
    }

    private func installNavigationController() {
        addChildViewController(_navigationController)
        view.addSubview(_navigationController.view)
        _navigationController.didMoveToParentViewController(self)

        NSLayoutConstraint.activateConstraints([
            _navigationController.view.topAnchor.constraintEqualToAnchor(view.topAnchor),
            _navigationController.view.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            _navigationController.view.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            _navigationController.view.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        ])
    }
}


extension FeedsViewController: FeedListViewControllerDelegate {
    func feedListViewController(feedListViewController: FeedListViewController, didSelectViewController viewController: UIViewController) {
//        selectedViewController = viewController
        feedListViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    func feedListViewControllerDidCancel(feedListViewController: FeedListViewController) {
        feedListViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}


extension FeedsViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        guard viewController == navigationController.viewControllers.first else {
            return
        }

        titleViewButton.title = "Animate"//viewController.title
        viewController.navigationItem.titleView = titleViewButton
    }
}


private extension SequenceType where Generator.Element: UIViewController {
    var containsNavigationOrTabBarControllers: Bool {
        for viewController in self {
            if viewController is UINavigationController || viewController is UITabBarController {
                return true
            }
        }

        return false
    }

}
