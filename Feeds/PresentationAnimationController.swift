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
        springAnimation.delegate = self
        return springAnimation
    }()
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return springAnimation.settlingDuration
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)

        toViewController.view.frame = finalFrame
        transitionContext.containerView()?.addSubview(toViewController.view)

        springAnimation.fromValue = -finalFrame.midY
        print(springAnimation.settlingDuration)

        CATransaction.begin()
        toViewController.view.layer.position.y = finalFrame.midY
        toViewController.view.layer.addAnimation(springAnimation, forKey: "YPosition")

        UIView.animateWithDuration(springAnimation.settlingDuration, animations: {
            CATransaction.commit()
            print("View Start: \(CACurrentMediaTime())")
        }) { (_) in
            print("View Stop: \(CACurrentMediaTime())")
            let transitionDidComplete = !transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(transitionDidComplete)
        }


//        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: [], animations: {
//            toViewController.view.frame = finalFrame
//        }) { _ in
//            let transitionDidComplete = !transitionContext.transitionWasCancelled()
//            transitionContext.completeTransition(transitionDidComplete)
//        }
    }

    public override func animationDidStart(anim: CAAnimation) {
        print("CA Start: \(CACurrentMediaTime())")
    }

    public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        print("CA Stop: \(CACurrentMediaTime()) - Finished: \(flag)")
    }
}
