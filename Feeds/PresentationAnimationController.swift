import UIKit

public final class PresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)

        transitionContext.containerView()?.addSubview(toViewController.view)
        toViewController.view.frame = finalFrame.offsetBy(dx: 0, dy: -finalFrame.height)

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: [], animations: {
            toViewController.view.frame = finalFrame
        }) { _ in
            let transitionDidComplete = !transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(transitionDidComplete)
        }
    }
}
