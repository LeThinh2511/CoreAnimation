//
//  AnimatorFactory.swift
//  Widgets
//
//  Created by Thinh Le on 7/26/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Foundation
import UIKit

class AnimatorFactory {
  static func scaleUp(view: UIView) -> UIViewPropertyAnimator {
    let scale = UIViewPropertyAnimator(duration: 0.33, curve: .easeIn)
    scale.addAnimations {
      view.alpha = 1.0
    }
    scale.addAnimations({
      view.transform = CGAffineTransform.identity
    }, delayFactor: 0.33)
    scale.addCompletion {_ in
      print("ready")
    }
    return scale
  }
}
