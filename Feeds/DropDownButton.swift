import UIKit

final class DropDownButton: UIButton {
    var title: String? {
        didSet {
            setTitle(title, forState: .Normal)
            sizeToFit()
        }
    }

    init() {
        super.init(frame: .zero)
        titleLabel?.font = UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        setTitleColor(tintColor, forState: .Normal)
    }

    override var highlighted: Bool {
        didSet {
            let duration: NSTimeInterval = highlighted ? 0 : 0.3
            let alpha: CGFloat = highlighted ? 0.4 : 1

            UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseInOut, .AllowUserInteraction, .BeginFromCurrentState], animations: {
                self.titleLabel?.alpha = alpha
            }, completion: nil)
        }
    }
}
