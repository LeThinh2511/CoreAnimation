import UIKit
import QuartzCore

@IBDesignable
class AnimatedMaskLabel: UIView {
  
  let gradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    
    // Configure the gradient here
    
    return gradientLayer
  }()
  
  @IBInspectable var text: String! {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override func layoutSubviews() {
    layer.borderColor = UIColor.green.cgColor
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    
  }
  
}
