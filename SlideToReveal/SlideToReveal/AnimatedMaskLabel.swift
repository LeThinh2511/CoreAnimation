import UIKit
import QuartzCore

@IBDesignable
class AnimatedMaskLabel: UIView {
    
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let colors = [UIColor.black.cgColor,
                      UIColor.white.cgColor,
                      UIColor.black.cgColor]
        gradientLayer.colors = colors
        let locations: [NSNumber] = [0.25, 0.5, 0.75]
        gradientLayer.locations = locations
        return gradientLayer
    }()
    
    @IBInspectable var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = bounds
        layer.borderColor = UIColor.green.cgColor
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.addSublayer(gradientLayer)
    }
}
