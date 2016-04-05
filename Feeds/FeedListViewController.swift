import UIKit

protocol FeedListViewControllerDelegate: class {
    func feedListViewController(feedListViewController: FeedListViewController, didSelectViewController viewController: UIViewController)
    func feedListViewControllerDidCancel(feedListViewController: FeedListViewController)
}


final class FeedListViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: FeedListViewControllerDelegate?


    // MARK: - Initialization

    init(viewControllers: [UIViewController], selectedIndex: Int? = nil) {
        self.viewControllers = viewControllers
        self.selectedIndex = selectedIndex

        super.init(nibName: nil, bundle: nil)

        title = "Select Feed"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancel))
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        installTableView()
        updatePreferredContentSize()
    }


    // MARK: - UIContentContainer

    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        updatePreferredContentSize()
    }


    // MARK: - Private

    private let viewControllers: [UIViewController]
    private let selectedIndex: Int?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.scrollEnabled = false
        tableView.separatorStyle = .None
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.registerClass(FeedListCell.self, forCellReuseIdentifier: "\(FeedListCell.self)")
        return tableView
    }()

    @objc private func cancel() {
        delegate?.feedListViewControllerDidCancel(self)
    }

    private func installTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activateConstraints([
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        ])
    }

    private func updatePreferredContentSize() {
        preferredContentSize = tableView.contentSize
    }
}


extension FeedListViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("\(FeedListCell.self)", forIndexPath: indexPath)

        let viewController = viewControllers[indexPath.row]
        cell.textLabel?.text = viewController.title
        cell.imageView?.image = viewController.tabBarItem.image
        cell.accessoryType = accessoryTypeForIndexPath(indexPath)

        return cell
    }


    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = viewControllers[indexPath.row]
        delegate?.feedListViewController(self, didSelectViewController: viewController)
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? FeedListCell else {
            return
        }

        cell.showsSeparator = !indexPath.representsLastRowInSection(inTableView: tableView)
    }


    // MARK: - Private

    private func accessoryTypeForIndexPath(indexPath: NSIndexPath) -> UITableViewCellAccessoryType {
        if indexPath.row == selectedIndex {
            return .Checkmark
        } else {
            return .None
        }
    }
}


extension NSIndexPath {
    private func representsLastRowInSection(inTableView tableView: UITableView) -> Bool {
        return row == tableView.numberOfRowsInSection(section) - 1
    }
}

private final class FeedListCell: UITableViewCell {
    static let defaultSeparatorColor: UIColor = UIColor(white: 0.698, alpha: 1)

    var separatorColor: UIColor = FeedListCell.defaultSeparatorColor {
        didSet {
            separatorView.backgroundColor = separatorColor
        }
    }

    var showsSeparator: Bool = true {
        didSet {
            separatorView.hidden = !showsSeparator
        }
    }

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = self.separatorColor
        return view
    }()

    private override var separatorInset: UIEdgeInsets {
        didSet {
            setNeedsLayout()
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        addSubview(separatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private override func layoutSubviews() {
        super.layoutSubviews()
        var scale = traitCollection.displayScale

        if scale == 0 {
            scale = UIScreen.mainScreen().scale
        }

        let height = 1 / scale

        var frame = CGRect.zero
        frame.origin.x = separatorInset.left
        frame.size.height = height
        frame.origin.y = bounds.height - height
        frame.size.width = bounds.width - separatorInset.left - separatorInset.right
        separatorView.frame = frame
    }
}


extension FeedListViewController: UIViewControllerTransitioningDelegate {

    // MARK: - UIViewControllerTransitioningDelegate

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return FeedListPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationAnimationController()
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissalAnimationController()
    }
}
