import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var meterLabel: UILabel!
    @IBOutlet weak var speakButton: UIButton!
    
    let monitor = MicMonitor()
    let assistant = Assistant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
