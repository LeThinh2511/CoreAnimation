import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var meterLabel: UILabel!
    @IBOutlet weak var speakButton: UIButton!
    
    let monitor = MicMonitor()
    let assistant = Assistant()
    let replicator = CAReplicatorLayer()
    let dot = CALayer()
    let dotLength: CGFloat = 6.0
    let dotOffset: CGFloat = 8.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replicator.frame = view.bounds
        view.layer.addSublayer(replicator)
        
        dot.frame = CGRect(x: replicator.frame.size.width - dotLength, y: replicator.position.y, width: dotLength, height: dotLength)
        dot.backgroundColor = UIColor.lightGray.cgColor
        dot.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        dot.borderWidth = 0.5
        dot.cornerRadius = 1.5
        replicator.addSublayer(dot)
        replicator.instanceCount = Int(view.frame.size.width / dotOffset)
        replicator.instanceTransform = CATransform3DMakeTranslation(-dotOffset, 0.0, 0.0)
    }
    
    @IBAction func actionStartMonitoring(_ sender: AnyObject) {
        
    }
    
    @IBAction func actionEndMonitoring(_ sender: AnyObject) {
        
        //speak after 1 second
        delay(seconds: 1.0) {
            self.startSpeaking()
        }
    }
    
    func startSpeaking() {
        print("speak back")
        
        
    }
    
    func endSpeaking() {
        
    }
}
