import UIKit

class LockScreenViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var dateTopConstraint: NSLayoutConstraint!
  
  let blurView = UIVisualEffectView(effect: nil)
  
  var settingsController: SettingsViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.bringSubviewToFront(searchBar)
    blurView.effect = UIBlurEffect(style: .dark)
    blurView.alpha = 0
    blurView.isUserInteractionEnabled = false
    view.insertSubview(blurView, belowSubview: searchBar)
    
    tableView.estimatedRowHeight = 130.0
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.transform = CGAffineTransform(scaleX: 0.67, y: 0.67)
    tableView.alpha = 0
  }
  
  override func viewDidAppear(_ animated: Bool) {
    AnimatorFactory.scaleUp(view: tableView).startAnimation()
  }
  
  override func viewWillLayoutSubviews() {
    blurView.frame = view.bounds
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  func toggleBlur(_ blurred: Bool) {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
      self.blurView.alpha = blurred ? 1 : 0
    }, completion: nil)
  }
  
  @IBAction func presentSettings(_ sender: Any? = nil) {
    //present the view controller
    settingsController = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
    present(settingsController, animated: true, completion: nil)
  }
  
}

extension LockScreenViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    toggleBlur(true)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    toggleBlur(false)
  }
  
  func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      searchBar.resignFirstResponder()
    }
  }
}

extension LockScreenViewController: WidgetsOwnerProtocol { }

extension LockScreenViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Footer") as! FooterCell
      cell.didPressEdit = {[unowned self] in
        self.presentSettings()
      }
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! WidgetCell
      cell.tableView = tableView
      cell.owner = self
      return cell
    }
  }
}
