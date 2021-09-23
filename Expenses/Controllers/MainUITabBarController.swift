import UIKit

class MainUITabBarController: UITabBarController, UITabBarControllerDelegate {
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    viewControllers = [
      UINavigationController(rootViewController: ExpensesListViewController()),
      UINavigationController(rootViewController: ReportsViewController())
    ]
    
    if let item = tabBar.items?[0] {
      item.title = "Expenses"
      item.image = UIImage(systemName: "list.bullet.rectangle")
    }
    if let item = tabBar.items?[1] {
      item.title = "Reports"
      item.image = UIImage(systemName: "chart.bar.xaxis")
    }
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /**
   For hot code reloading. When you shake the device, it reloads the app's main view controller, using updated class/method definitions.
   */
//  #if DEBUG
//  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//    super.motionEnded(motion, with: event)
//    
//    (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = MainUITabBarController()
//  }
//  #endif
}
