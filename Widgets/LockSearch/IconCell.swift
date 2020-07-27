import UIKit

class IconCell: UICollectionViewCell {
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var icon: UIImageView!
  
  private var animator: UIViewPropertyAnimator?
  
  func iconJiggle() {
    if let animator = animator, animator.isRunning {
      return
    } else {
      animator = AnimatorFactory.jiggle(view: icon)
    }
  }
}
