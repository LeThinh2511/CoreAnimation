import UIKit
import QuartzCore

class DetailViewController: UITableViewController, UINavigationControllerDelegate {
    
    var animator = RevealAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pack List"
        tableView.rowHeight = 54.0
        navigationController?.delegate = self
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandler(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Table View methods
    let packItems = ["Ice cream money", "Great weather", "Beach ball", "Swimsuit for him", "Swimsuit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops"]
    
    @objc func panHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            animator.interactive = true
            navigationController?.popViewController(animated: true)
        default:
            animator.handlePan(gestureRecognizer)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.operation = operation
        return animator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if !animator.interactive {
            return nil
        } else {
            return animator
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.accessoryType = .none
        cell.textLabel?.text = packItems[(indexPath as NSIndexPath).row]
        cell.imageView?.image = UIImage(named: "summericons_100px_0\((indexPath as NSIndexPath).row).png")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
