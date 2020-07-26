//
//  RevealAnimator.swift
//  LogoReveal
//
//  Created by Thinh Le on 7/23/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit

class RevealAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    let animationDuration = 2.0
    var operation: UINavigationController.Operation = .push
    var interactive = false
    private var pausedTime: CFTimeInterval = 0
    weak var storedContext: UIViewControllerContextTransitioning?

    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: recognizer.view!.superview!)
        var progress: CGFloat = abs(translation.x / 200.0)
        progress = min(max(progress, 0.01), 0.99)
        switch recognizer.state {
        case .changed:
            update(progress)
        case .cancelled, .ended:
            if progress < 0.5 {
                cancel()
            } else {
                finish()
            }
            interactive = false
        default:
            break
        }
    }
    
    override func update(_ percentComplete: CGFloat) {
        super.update(percentComplete)
        let animationProgress = TimeInterval(animationDuration) * TimeInterval(percentComplete)
        storedContext?.containerView.layer.timeOffset = pausedTime + animationProgress
    }
    
    override func cancel() {
        restart(forFinishing: false)
        super.cancel()
    }
    override func finish() {
        restart(forFinishing: true)
        super.finish()
        
    }
    
    private func restart(forFinishing: Bool) {
        let transitionLayer = storedContext?.containerView.layer
        transitionLayer?.beginTime = CACurrentMediaTime()
        transitionLayer?.speed = forFinishing ? 1 : -1
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if interactive {
            let transitionLayer = transitionContext.containerView.layer
            pausedTime = transitionLayer.convertTime(CACurrentMediaTime(), from:
                nil)
            transitionLayer.speed = 0
            transitionLayer.timeOffset = pausedTime
        }
        storedContext = transitionContext
        if operation == .push {
            let fromVC = transitionContext.viewController(forKey: .from) as! MasterViewController
            let toVC = transitionContext.viewController(forKey: .to) as! DetailViewController
            transitionContext.containerView.addSubview(toVC.view)
            toVC.view.frame = transitionContext.finalFrame(for: toVC)
            
            let animation = CABasicAnimation(keyPath: "transform")
            animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
            animation.toValue =
              NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(0.0, -10.0, 0.0), CATransform3DMakeScale(150.0, 150.0, 1.0)))
            animation.duration = animationDuration
            animation.delegate = self
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
            
            let maskLayer: CAShapeLayer = RWLogoLayer.logoLayer()
            maskLayer.position = fromVC.logo.position
            toVC.view.layer.mask = maskLayer
            
            let fadeIn = CABasicAnimation(keyPath: "opacity")
            fadeIn.fromValue = 0
            fadeIn.toValue = 1
            fadeIn.duration = animationDuration
            
            toVC.view.layer.add(fadeIn, forKey: nil)
            maskLayer.add(animation, forKey: nil)
            fromVC.logo.add(animation, forKey: nil)
        } else {
            let fromView = transitionContext.view(forKey: .from)!
            let toView = transitionContext.view(forKey: .to)!
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            let scale = CABasicAnimation(keyPath: "transform")
            scale.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1))
            scale.duration = animationDuration
            scale.delegate = self
            fromView.layer.add(scale, forKey: nil)
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let context = storedContext {
            context.completeTransition(!context.transitionWasCancelled)
            if operation == .push {
                let fromVC = context.viewController(forKey: .from) as! MasterViewController
                fromVC.logo.removeAllAnimations()
                let toVC = context.viewController(forKey: .to) as! DetailViewController
                toVC.view.layer.mask = nil
            }
        }
        storedContext = nil
    }
}
