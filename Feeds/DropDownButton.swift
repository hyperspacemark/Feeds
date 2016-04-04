import UIKit

public final class DropDownButton: UIButton {
    public var title: String? {
        didSet {
            setTitle(title, forState: .Normal)
            sizeToFit()
        }
    }

    public init() {
        super.init(frame: .zero)
        titleLabel?.font = UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        setTitleColor(tintColor, forState: .Normal)
    }
}
