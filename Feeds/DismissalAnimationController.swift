import UIKit

public final class DismissalAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let
            fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewKey),
            initialFrame = transitionContext.initialFrameForViewController(fromViewController)
        else {
            return
        }
        
        let finalFrame = initialFrame.offsetBy(dx: 0, dy: -initialFrame.height)

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: [], animations: {
            fromViewController.view.frame = finalFrame
        }) { (completed) in
            let transitionDidComplete = !transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(transitionDidComplete)
        }
    }
}
