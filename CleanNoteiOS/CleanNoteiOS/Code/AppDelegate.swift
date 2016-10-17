import UIKit
import CleanNoteCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

    prepareRootViewController()
    
    return true
  }
    
  private func prepareRootViewController() {
    let navController = window?.rootViewController as! UINavigationController
    let listViewController = navController.topViewController as! ListViewController
    let dummySegue = UIStoryboardSegue(identifier: "", source: navController, destination: listViewController)
    let coordinator = StoryboardSegueCoordinator(segue: dummySegue, sender: self)
        coordinator.prepare()
  }
    
}
