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
            let image = UIGraphicsImageRenderer(size: bounds.size).image { _ in
                text.draw(in: bounds, withAttributes: textAttributes)
            }
            let maskLayer = CALayer()
            maskLayer.backgroundColor = UIColor.clear.cgColor
            maskLayer.frame = bounds.offsetBy(dx: bounds.size.width, dy: 0)
            maskLayer.contents = image.cgImage
            gradientLayer.mask = maskLayer
        }
    }
    
    let textAttributes: [NSAttributedString.Key: Any] = {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        return [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 28.0)!, NSAttributedString.Key.paragraphStyle: style]
    }()
    
    override func layoutSubviews() {
        gradientLayer.frame = CGRect(x: -bounds.size.width,
        y: bounds.origin.y, width: 3 * bounds.size.width, height: bounds.size.height)
        layer.borderColor = UIColor.green.cgColor
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.addSublayer(gradientLayer)
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.0, 0.25]
        gradientAnimation.toValue = [0.75, 1.0, 1.0]
        gradientAnimation.duration = 3.0
        gradientAnimation.repeatCount = Float.infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
    }
}
