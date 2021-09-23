import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    /**
     For hot code reloading. When you shake the device, it reloads the app's main view controller, using updated class/method definitions. Requires InjectionIII to be installed. If not installed, fails silently.
     */
//    #if DEBUG
//    Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
//    //for tvOS:
//    Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/tvOSInjection.bundle")?.load()
//    //Or for macOS:
//    Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle")?.load()
//    #endif
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    window?.rootViewController = MainUITabBarController()
    
    window?.makeKeyAndVisible()
    
    return true
  }
}
