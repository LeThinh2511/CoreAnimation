import UIKit
import QuartzCore

class ViewController: UIViewController {
    
    let images = [
        ImageViewCard(imageNamed: "Hurricane_Katia.jpg", title: "Hurricane Katia"),
        ImageViewCard(imageNamed: "Hurricane_Douglas.jpg", title: "Hurricane Douglas"),
        ImageViewCard(imageNamed: "Hurricane_Norbert.jpg", title: "Hurricane Norbert"),
        ImageViewCard(imageNamed: "Hurricane_Irene.jpg", title: "Hurricane Irene")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "info", style: .done, target: self, action: #selector(info))
    }
    
    @objc func info() {
        let alertController = UIAlertController(title: "Info", message: "Public Domain images by NASA", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for image in images {
            image.layer.anchorPoint.y = 0.0
            image.frame = view.bounds
            view.addSubview(image)
        }
        navigationItem.title = images.last?.title
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0/250.0
        view.layer.sublayerTransform = perspective
    }
    
    @IBAction func toggleGallery(_ sender: AnyObject) {
        
        
    }
    
}
