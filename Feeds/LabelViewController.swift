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

class AdjustmentViewController: UIViewController {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 44
        stackView.axis = .Vertical
        stackView.distribution = .FillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteColor()

        // 1.4
        let defaultMass = NSUserDefaults.standardUserDefaults().floatForKey("Mass")
        let massSliderView = SliderView(value: defaultMass, minimum: 1, maximum: 50, labelText: "Mass")
        massSliderView.slider.addTarget(self, action: #selector(massChanged(_:)), forControlEvents: .PrimaryActionTriggered)

        // 917
        // 500
        let defaultStiffness = NSUserDefaults.standardUserDefaults().floatForKey("Stiffness")
        let stiffnessSliderView = SliderView(value: defaultStiffness, minimum: 400, maximum: 600, labelText: "Stiffness")
        stiffnessSliderView.slider.addTarget(self, action: #selector(stiffnessChanged(_:)), forControlEvents: .PrimaryActionTriggered)

        // 63
        // 34
        let defaultDamping = NSUserDefaults.standardUserDefaults().floatForKey("Damping")
        let dampingSliderView = SliderView(value: defaultDamping, minimum: 20, maximum: 60, labelText: "Damping")
        dampingSliderView.slider.addTarget(self, action: #selector(dampingChanged(_:)), forControlEvents: .PrimaryActionTriggered)

        let defaultInitialVelocity = NSUserDefaults.standardUserDefaults().floatForKey("InitialVelocity")
        let initialVelocitySliderView = SliderView(value: defaultInitialVelocity, minimum: 0, maximum: 1000, labelText: "Initial Velocity (points/second)")
        initialVelocitySliderView.slider.addTarget(self, action: #selector(initialVelocityChanged(_:)), forControlEvents: .PrimaryActionTriggered)

//        stackView.addArrangedSubview(massSliderView)
        stackView.addArrangedSubview(stiffnessSliderView)
        stackView.addArrangedSubview(dampingSliderView)
//        stackView.addArrangedSubview(initialVelocitySliderView)

        view.addSubview(stackView)

        NSLayoutConstraint.activateConstraints([
            stackView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        ])
    }

    @objc func massChanged(slider: UISlider) {
        NSUserDefaults.standardUserDefaults().setFloat(slider.value, forKey: "Mass")
    }

    @objc func stiffnessChanged(slider: UISlider) {
        NSUserDefaults.standardUserDefaults().setFloat(slider.value, forKey: "Stiffness")
    }

    @objc func dampingChanged(slider: UISlider) {
        NSUserDefaults.standardUserDefaults().setFloat(slider.value, forKey: "Damping")
    }

    @objc func initialVelocityChanged(slider: UISlider) {
        NSUserDefaults.standardUserDefaults().setFloat(slider.value, forKey: "InitialVelocity")
    }
}

class SliderView: UIView {
    let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.distribution = .FillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let labelText: String

    init(value: Float, minimum: Float, maximum: Float, labelText: String) {
        self.labelText = labelText

        super.init(frame: .zero)

        slider.minimumValue = minimum
        slider.maximumValue = maximum
        slider.value = value
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), forControlEvents: .PrimaryActionTriggered)

        updateLabelText(withSliderValue: slider.value)

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(slider)

        addSubview(stackView)

        NSLayoutConstraint.activateConstraints([
            stackView.topAnchor.constraintEqualToAnchor(topAnchor),
            stackView.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
            stackView.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
            stackView.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func sliderValueChanged(slider: UISlider) {
        updateLabelText(withSliderValue: slider.value)
    }

    func updateLabelText(withSliderValue sliderValue: Float) {
        label.text = "\(labelText): \(sliderValue)"
    }
}
