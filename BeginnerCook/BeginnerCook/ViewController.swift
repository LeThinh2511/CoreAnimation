import UIKit

let herbs = HerbModel.all()

class ViewController: UIViewController {
    
    @IBOutlet var listView: UIScrollView!
    @IBOutlet var bgImage: UIImageView!
    var selectedImage: UIImageView?
    
    let transition = PopAnimator()
    
    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if listView.subviews.count < herbs.count {
            while let view = listView.viewWithTag(0) {
                view.tag = 1000
            }
            setupList()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: View setup
    
    //add all images to the list
    func setupList() {
        for i in herbs.indices {
            let imageView  = UIImageView(image: UIImage(named: herbs[i].image))
            imageView.tag = i
            imageView.contentMode = .scaleAspectFill
            imageView.isUserInteractionEnabled = true
            imageView.layer.cornerRadius = 20.0
            imageView.layer.masksToBounds = true
            listView.addSubview(imageView)
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))
        }
        
        listView.backgroundColor = UIColor.clear
        positionListItems()
    }
    
    //position all images inside the list
    func positionListItems() {
        let listHeight = listView.frame.height
        let itemHeight: CGFloat = listHeight * 1.33
        let aspectRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        let itemWidth: CGFloat = itemHeight / aspectRatio
        
        let horizontalPadding: CGFloat = 10.0
        
        for i in herbs.indices {
            let imageView = listView.viewWithTag(i) as! UIImageView
            imageView.frame = CGRect(x: CGFloat(i) * itemWidth + CGFloat(i+1) * horizontalPadding, y: 0.0, width: itemWidth, height: itemHeight)
        }
        
        listView.contentSize = CGSize( width: CGFloat(herbs.count) * (itemWidth + horizontalPadding) + horizontalPadding, height:  0)
    }
    
    //MARK: Actions
    @objc func didTapImageView(_ tap: UITapGestureRecognizer) {
        selectedImage = tap.view as? UIImageView
        let index = tap.view!.tag
        let selectedHerb = herbs[index]
        let herbDetails = storyboard!.instantiateViewController(withIdentifier: "HerbDetailsViewController") as! HerbDetailsViewController
        herbDetails.herb = selectedHerb
        herbDetails.transitioningDelegate = self
        present(herbDetails, animated: true, completion: nil)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = selectedImage!.superview!.convert(selectedImage!.frame, to: nil)
        transition.presenting = true
        selectedImage!.isHidden = true
      return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return nil
    }
}
