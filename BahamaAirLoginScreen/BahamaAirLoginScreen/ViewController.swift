import UIKit

// A delay function
func delay(_ seconds: Double, completion: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
    let animation = CABasicAnimation(keyPath: "backgroundColor")
    animation.fromValue = layer.backgroundColor
    animation.toValue = toColor.cgColor
    animation.duration = 1
    layer.add(animation, forKey: nil)
    layer.backgroundColor = toColor.cgColor
}

func roundCorners(layer: CALayer, toRadius: CGFloat) {
    let animation = CABasicAnimation(keyPath: "cornerRadius")
    animation.fromValue = layer.cornerRadius
    animation.toValue = toRadius
    animation.duration = 0.33
    layer.add(animation, forKey: nil)
    layer.cornerRadius = toRadius
}

class ViewController: UIViewController {
    
    // MARK: IB outlets
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var heading: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var cloud1: UIImageView!
    @IBOutlet var cloud2: UIImageView!
    @IBOutlet var cloud3: UIImageView!
    @IBOutlet var cloud4: UIImageView!
    
    // MARK: further UI
    
    let info = UILabel()
    let spinner = UIActivityIndicatorView(style: .whiteLarge)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
    
    var statusPosition = CGPoint.zero
    
    // MARK: view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the UI
        loginButton.layer.cornerRadius = 8.0
        loginButton.layer.masksToBounds = true
        
        spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
        spinner.startAnimating()
        spinner.alpha = 0.0
        loginButton.addSubview(spinner)
        
        status.isHidden = true
        status.center = loginButton.center
        view.addSubview(status)
        
        label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
        label.textAlignment = .center
        status.addSubview(label)
        
        statusPosition = status.center
        
        info.frame = CGRect(x: 0.0, y: loginButton.center.y + 60.0, width: view.frame.size.width, height: 30)
        info.backgroundColor = .clear
        info.font = UIFont(name: "HelveticaNeue", size: 12.0)
        info.textAlignment = .center
        info.textColor = .white
        info.text = "Tap on a field and enter username and password"
        view.insertSubview(info, belowSubview: loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0
        fadeIn.toValue = 1
        fadeIn.duration = 0.5
        fadeIn.fillMode = .backwards
        fadeIn.beginTime = CACurrentMediaTime() + 0.5
        cloud1.layer.add(fadeIn, forKey: nil)
        
        fadeIn.beginTime = CACurrentMediaTime() + 0.7
        cloud2.layer.add(fadeIn, forKey: nil)
        
        fadeIn.beginTime = CACurrentMediaTime() + 0.9
        cloud3.layer.add(fadeIn, forKey: nil)
        
        fadeIn.beginTime = CACurrentMediaTime() + 1.1
        cloud4.layer.add(fadeIn, forKey: nil)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.beginTime = CACurrentMediaTime() + 0.5
        groupAnimation.duration = 0.5
        groupAnimation.fillMode = .backwards
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0.25
        fadeInAnimation.toValue = 1
        
        let positionAnimation = CABasicAnimation(keyPath: "position.x")
        positionAnimation.fromValue = -view.bounds.size.width/2
        positionAnimation.toValue = view.bounds.size.width/2
        
        groupAnimation.animations = [fadeInAnimation, positionAnimation]
        groupAnimation.delegate = self
        heading.layer.add(groupAnimation, forKey: nil)
        groupAnimation.setValue("form", forKey: "name")
        groupAnimation.setValue(username.layer, forKey: "layer")
        groupAnimation.beginTime = CACurrentMediaTime() + 0.3
        username.layer.add(groupAnimation, forKey: nil)
        groupAnimation.setValue(password.layer, forKey: "layer")
        groupAnimation.beginTime = CACurrentMediaTime() + 0.4
        password.layer.add(groupAnimation, forKey: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let groupAnimation = CAAnimationGroup()
        groupAnimation.beginTime = CACurrentMediaTime() + 0.5
        groupAnimation.duration = 0.5
        groupAnimation.fillMode = .backwards
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 3.5
        scaleDown.toValue = 1.0
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = .pi / 4.0
        rotate.toValue = 0.0
        
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.0
        fade.toValue = 1.0
        
        groupAnimation.animations = [scaleDown, rotate, fade]
        loginButton.layer.add(groupAnimation, forKey: nil)
        
        let flyLeft = CABasicAnimation(keyPath: "position.x")
        flyLeft.fromValue = info.layer.position.x + view.frame.size.width
        flyLeft.toValue = -info.layer.position.x
        flyLeft.duration = 5.0
        flyLeft.repeatCount = .infinity
        info.layer.add(flyLeft, forKey: "infoappear")
        
        let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
        fadeLabelIn.fromValue = 0.2
        fadeLabelIn.toValue = 1.0
        fadeLabelIn.duration = 4.5
        info.layer.add(fadeLabelIn, forKey: "fadein")
        username.delegate = self
        password.delegate = self
        
        animateCloud(layer: cloud1.layer)
        animateCloud(layer: cloud2.layer)
        animateCloud(layer: cloud3.layer)
        animateCloud(layer: cloud4.layer)
    }
    
    // MARK: further methods
    
    func animateCloud(layer: CALayer) {
        //1
        let cloudSpeed = 30 / Double(view.layer.frame.size.width)
        let duration: TimeInterval = Double(view.layer.frame.size.width - layer.frame.origin.x) * cloudSpeed
        //2
        let cloudMove = CABasicAnimation(keyPath: "position.x")
        cloudMove.duration = duration
        cloudMove.fromValue = -layer.bounds.width
        cloudMove.toValue = self.view.bounds.width + layer.bounds.width
//        cloudMove.repeatCount = .infinity
        cloudMove.delegate = self
        cloudMove.setValue("cloud", forKey: "name")
        cloudMove.setValue(layer, forKey: "layer")
        cloudMove.delegate = self
        layer.add(cloudMove, forKey: nil)
    }
    
    @IBAction func login() {
        view.endEditing(true)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.bounds.size.width += 80
        }, completion: { _ in
            self.showMessage(index: 0)
        })
        UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.loginButton.center.y += 60
            self.spinner.center = CGPoint( x: 40.0, y: self.loginButton.frame.size.height/2 )
            self.spinner.alpha = 1.0
        }, completion: nil)
        let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
        tintBackgroundColor(layer: loginButton.layer, toColor: tintColor)
        roundCorners(layer: loginButton.layer, toRadius: 25.0)
        
        let balloon = CALayer()
        balloon.contents = UIImage(named: "balloon")!.cgImage
        balloon.frame = CGRect(x: -50.0, y: 0.0, width: 50.0, height: 65.0)
        view.layer.insertSublayer(balloon, below: username.layer)
        
        let flight = CAKeyframeAnimation(keyPath: "position")
        flight.duration = 12.0
        flight.values = [
        CGPoint(x: -50.0, y: 0.0),
        CGPoint(x: view.frame.width + 50.0, y: 160.0),
        CGPoint(x: -50.0, y: loginButton.center.y)
        ].map { NSValue(cgPoint: $0) }
        flight.keyTimes = [0.0, 0.5, 1.0]
        balloon.add(flight, forKey: nil)
        balloon.position = CGPoint(x: -50.0, y: loginButton.center.y)
    }
    
    func showMessage(index: Int) {
        label.text = messages[index]
        UIView.transition(with: status, duration: 0.5, options: [.curveEaseOut, .transitionFlipFromBottom], animations: {
            self.status.isHidden = false
        }, completion: {_ in
            delay(2.0) {
                if index < self.messages.count-1 {
                    self.removeMessage(index: index) }
                else {
                    self.resetForm()
                }
            }
        })
    }
    
    func removeMessage(index: Int) {
        UIView.animate(withDuration: 0.33, delay: 0.0, options: [], animations: {
            self.status.center.x += self.view.frame.size.width
        }, completion: { _ in
            self.status.isHidden = true
            self.status.center = self.statusPosition
            self.showMessage(index: index+1)
        })
        
    }
    
    func resetForm() {
        UIView.transition(with: status, duration: 0.2, options: [.curveEaseIn, .transitionFlipFromTop], animations: {
            self.status.removeFromSuperview()
        }) { completed in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                self.loginButton.center.y -= 60
                self.loginButton.bounds.size.width -= 80
                self.spinner.center = CGPoint(x: -20.0, y: 16.0)
                self.spinner.alpha = 0
            }) { _ in
                let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
                tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)
                roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
            }
        }
        let wobble = CAKeyframeAnimation(keyPath: "transform.rotation")
        wobble.duration = 0.25
        wobble.repeatCount = 4
        wobble.values = [0.0, -.pi/4.0, 0.0, .pi/4.0, 0.0]
        wobble.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        heading.layer.add(wobble, forKey: nil)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = (textField === username) ? password : username
        nextField?.becomeFirstResponder()
        return true
    }
    
}
extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: "name") as? String else {
            return
        }
        if name == "form" {
            let layer = anim.value(forKey: "layer") as? CALayer
            anim.setValue(nil, forKey: "layer")
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.damping = 7.5
            pulse.fromValue = 1.25
            pulse.toValue = 1.0
            pulse.duration = pulse.settlingDuration
            layer?.add(pulse, forKey: nil)
        }
        
        if name == "cloud" {
            guard let layer = anim.value(forKey: "layer") as? CALayer else {
                return
            }
            layer.position.x = -layer.bounds.width/2
            delay(1) {
                self.animateCloud(layer: layer)
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        info.layer.removeAnimation(forKey: "infoappear")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count < 5 {
            let jump = CASpringAnimation(keyPath: "position.y")
            jump.initialVelocity = 100
            jump.stiffness = 1500.0
            jump.damping = 50.0
            jump.mass = 10
            jump.fromValue = textField.layer.position.y + 1.0
            jump.toValue = textField.layer.position.y
            jump.duration = jump.settlingDuration
            textField.layer.add(jump, forKey: nil)
            textField.layer.borderWidth = 3.0
            textField.layer.borderColor = UIColor.clear.cgColor
            let flash = CASpringAnimation(keyPath: "borderColor")
            flash.damping = 7.0
            flash.stiffness = 200.0
            flash.fromValue = UIColor(red: 1.0, green: 0.27, blue: 0.0, alpha: 1.0).cgColor
            flash.toValue = UIColor.white.cgColor
            flash.duration = flash.settlingDuration
            textField.layer.add(flash, forKey: nil)
        }
    }
}
