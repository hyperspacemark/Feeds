import UIKit

public final class DismissalAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - UIViewControllerAnimatedTransitioning

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) else {
            return
        }

        let initialFrame = transitionContext.initialFrameForViewController(fromViewController)
        let finalFrame = initialFrame.offsetBy(dx: 0, dy: -initialFrame.height)

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: [], animations: {
            fromViewController.view.frame = finalFrame
        }) { (completed) in
            let transitionDidComplete = !transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(transitionDidComplete)
        }
    }
}























final class FeedListTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    enum Style {
        case Presentation
        case Dismissal
    }

    var presenting: Bool {
        return style == .Presentation
    }

    let style: Style

    init(style: Style) {
        self.style = style
        super.init()
    }


    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDuration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let
            presentedView = presentedView(inContext: transitionContext, presenting: presenting),
            containerView = transitionContext.containerView()
        else {
            return
        }

        if presenting {
            containerView.addSubview(presentedView)
        }

        presentedView.frame = initialPresentedViewFrame(inContext: transitionContext, presenting: presenting)

        UIView.animateWithDuration(transitionDuration, animations: {
//            presentedView.frame = finalPresentedViewFrame(inContext: transitionContext, presenting: presenting)
        }, completion: animationCompletion(transitionContext))
    }

    private var transitionDuration: NSTimeInterval {
        return 0.3
    }
}

extension UIViewControllerAnimatedTransitioning {
    private func presentedView(inContext context: UIViewControllerContextTransitioning, presenting: Bool) -> UIView? {
        let key = presenting ? UITransitionContextToViewKey : UITransitionContextFromViewKey
        return context.viewForKey(key)
    }

    private func presentedViewController(inContext context: UIViewControllerContextTransitioning, presenting: Bool) -> UIViewController? {
        let key = presenting ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey
        return context.viewControllerForKey(key)
    }

    private func initialPresentedViewFrame(inContext context: UIViewControllerContextTransitioning, presenting: Bool) -> CGRect {
        let finalFrame = finalPresentedViewFrame(inContext: context, presenting: presenting)

        if presenting {
            return finalFrame.offsetBy(dx: 0, dy: -finalFrame.height)
        } else {
            return finalFrame
        }
    }

    private func finalPresentedViewFrame(inContext context: UIViewControllerContextTransitioning, presenting: Bool) -> CGRect {
        guard let viewController = presentedViewController(inContext: context, presenting: presenting) else {
            return .zero
        }

        let finalFrame = context.finalFrameForViewController(viewController)

        if presenting {
            return finalFrame
        } else {
            return finalFrame.offsetBy(dx: 0, dy: -finalFrame.height)
        }
    }

    private func animationCompletion(context: UIViewControllerContextTransitioning) -> Bool -> Void {
        return { animationCompleted in
            let transitionDidComplete = !context.transitionWasCancelled()
            context.completeTransition(transitionDidComplete)
        }
    }
}
