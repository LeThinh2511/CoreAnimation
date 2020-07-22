//
//  PopAnimator.swift
//  BeginnerCook
//
//  Created by Thinh Le on 7/21/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 2.0
    var presenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (()->Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        
        guard let herbView = presenting ? transitionContext.view(forKey: .to) : transitionContext.view(forKey: .from),
            let herbViewController = (presenting ? transitionContext.viewController(forKey: .to) : transitionContext.viewController(forKey: .from)) as? HerbDetailsViewController else {
            return
        }
        
        let finalAlpha: CGFloat = presenting ? 1 : 0
        let initialAlpha: CGFloat = presenting ? 0 : 1
        let initialFrame = presenting ? originFrame : herbView.frame
        let finalFrame = presenting ? herbView.frame : originFrame
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ?
        initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        if presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            herbView.clipsToBounds = true
        }
        
        containerView.addSubview(herbView)
        containerView.bringSubviewToFront(herbView)
        herbViewController.containerView.alpha = initialAlpha
        UIView.animate(withDuration: duration, delay:0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, animations: {
            herbViewController.containerView.alpha = finalAlpha
            herbView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })
    }
}
