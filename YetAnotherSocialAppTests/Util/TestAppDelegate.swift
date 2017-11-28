import UIKit

@testable import YetAnotherSocialApp

class TestAppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        PlaceService.start()

        return true
    }
}
