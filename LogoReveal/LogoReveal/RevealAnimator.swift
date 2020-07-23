//
//  RevealAnimator.swift
//  LogoReveal
//
//  Created by Thinh Le on 7/23/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit

class RevealAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration = 2.0
    var operation: UINavigationController.Operation = .push

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    }
}
