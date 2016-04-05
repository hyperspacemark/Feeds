import UIKit

public protocol FeedListViewControllerDelegate: class {
    func feedListViewController(feedListViewController: FeedListViewController, didSelectViewController viewController: UIViewController)
    func feedListViewControllerDidCancel(feedListViewController: FeedListViewController)
}

public final class FeedListViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: FeedListViewControllerDelegate?

    private let viewControllers: [UIViewController]
    private let selectedIndex: Int

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.scrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()


    // MARK: - Initialization

    public init(viewControllers: [UIViewController], selectedIndex: Int = 0) {
        self.viewControllers = viewControllers
        self.selectedIndex = selectedIndex

        super.init(nibName: nil, bundle: nil)

        title = "Select Feed"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancel))
        transitioningDelegate = self
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)

        NSLayoutConstraint.activateConstraints([
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        ])

        updatePreferredContentSize()
    }

    public override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        updatePreferredContentSize()
    }

    private func updatePreferredContentSize() {
        preferredContentSize = tableView.contentSize
    }

    @objc private func cancel() {
        delegate?.feedListViewControllerDidCancel(self)
    }
}

extension FeedListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let viewController = viewControllers[indexPath.row]

        cell.textLabel?.text = viewController.title
        cell.imageView?.image = viewController.tabBarItem.image
        cell.accessoryType = accessoryTypeForIndexPath(indexPath)

        return cell
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = viewControllers[indexPath.row]
        delegate?.feedListViewController(self, didSelectViewController: viewController)
    }

    private func accessoryTypeForIndexPath(indexPath: NSIndexPath) -> UITableViewCellAccessoryType {
        if indexPath.row == selectedIndex {
            return .Checkmark
        } else {
            return .None
        }
    }
}

extension FeedListViewController: UIViewControllerTransitioningDelegate {
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return FeedListPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }

    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationAnimationController()
    }

    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissalAnimationController()
    }
}
