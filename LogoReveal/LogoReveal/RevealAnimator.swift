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
    weak var storedContext: UIViewControllerContextTransitioning?

    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
