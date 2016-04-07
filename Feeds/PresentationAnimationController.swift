import UIKit

public final class PresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - UIViewControllerAnimatedTransitioning

    lazy var springAnimation: CASpringAnimation = {
        let springAnimation = CASpringAnimation(keyPath: "position.y")
        springAnimation.mass = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("Mass"))
        springAnimation.damping = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("Damping"))
        springAnimation.stiffness = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("Stiffness"))
        springAnimation.initialVelocity = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("InitialVelocity"))
        springAnimation.duration = springAnimation.settlingDuration
        return springAnimation
    }()
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return springAnimation.settlingDuration
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)

        transitionContext.containerView()?.addSubview(toView)

        springAnimation.fromValue = finalFrame.midY - finalFrame.maxY

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let transitionDidComplete = !transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(transitionDidComplete)
        }

        toView.layer.position.y = finalFrame.midY
        toView.layer.addAnimation(springAnimation, forKey: nil)
        CATransaction.commit()
    }
}
