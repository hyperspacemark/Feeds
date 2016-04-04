import Foundation
import UIKit

public class LabelViewController: UIViewController {
    public init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        let label = UILabel()
        label.backgroundColor = .whiteColor()
        label.textColor = .blackColor()
        label.textAlignment = .Center
        label.text = title
        view = label
    }
}
