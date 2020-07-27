import UIKit

class IconCell: UICollectionViewCell {
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var icon: UIImageView!
  
  func iconJiggle() {
    AnimatorFactory.jiggle(view: icon)
  }
}
