import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var penguin: UIImageView!
    @IBOutlet var slideButton: UIButton!
    
    var isLookingRight: Bool = true
    var penguinY: CGFloat = 0.0
    
    var walkSize: CGSize = CGSize.zero
    var slideSize: CGSize = CGSize.zero
    
    let animationDuration = 1.0
    
    var walkFrames = [
        UIImage(named: "walk01.png")!,
        UIImage(named: "walk02.png")!,
        UIImage(named: "walk03.png")!,
        UIImage(named: "walk04.png")!
    ]
    
    var slideFrames = [
        UIImage(named: "slide01.png")!,
        UIImage(named: "slide02.png")!,
        UIImage(named: "slide01.png")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //grab the sizes of the different sequences
        walkSize = walkFrames[0].size
        print(walkSize)
        slideSize = slideFrames[0].size
        
        //setup the animation
        penguinY = penguin.frame.origin.y
        
    }
    
    func loadWalkAnimation() {
        
    }
    
    func loadSlideAnimation() {
        
    }
    
    @IBAction func actionLeft(_ sender: AnyObject) {
        
    }
    
    @IBAction func actionRight(_ sender: AnyObject) {
        
    }
    
    @IBAction func actionSlide(_ sender: AnyObject) {
        
    }
}

