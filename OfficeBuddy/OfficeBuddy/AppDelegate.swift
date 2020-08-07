import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let centerNav = storyboard.instantiateViewController(withIdentifier: "CenterNav") as! UINavigationController
        let menuVC = storyboard.instantiateViewController(withIdentifier: "SideMenu") as! SideMenuViewController
        menuVC.centerViewController = centerNav.viewControllers.first as? CenterViewController
        
        let containerVC = ContainerViewController(sideMenu: menuVC, center: centerNav)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = containerVC
        window?.backgroundColor = UIColor.black
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
