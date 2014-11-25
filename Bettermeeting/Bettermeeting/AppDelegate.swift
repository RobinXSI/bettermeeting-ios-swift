
import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var userService: UserService = {
        var us = UserService()
        us.userLoginDelegate = self
        return us
        }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        self.registerRemoteNotification()
        self.doAutoLogin()
        return true
    }
    
    func registerRemoteNotification() {
        let notificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func doAutoLogin() {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Bool = defaults.boolForKey("IsLoggedIn") as Bool
        if (isLoggedIn) {
            let actualUserDictionary = defaults.dictionaryForKey("ActualUser") as NSDictionary!
            let actualUser = User.createFromDictionary(actualUserDictionary)
            
            var username = actualUser.email
            var password = actualUser.password
            
            userService.loginUser(username, password: password)
        }
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let token = deviceToken.description
        let tokenWithoutWhitespace = token.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        println("\(tokenWithoutWhitespace)")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Registration failed: \(error)")
    }
}

extension AppDelegate : UserLoginDelegate {
    func loginSuccessful(user: User) {
        let tabBarViewController: UIViewController? = self.window?.rootViewController as UIViewController?
        if(tabBarViewController? != nil) {
            let todoViewController = tabBarViewController!.childViewControllers[0].childViewControllers[0] as TodoViewController
            let meetingViewController = tabBarViewController!.childViewControllers[1].childViewControllers[0] as MeetingViewController
            todoViewController.apiReady = true
            todoViewController.reloadData()
        }
        // Push Token
        
    }
    func authorizationError() {
    }
    func networkError() {
        let tabBarViewController: UIViewController? = self.window?.rootViewController as UIViewController?
        if(tabBarViewController? != nil) {
            let todoViewController = tabBarViewController!.childViewControllers[0].childViewControllers[0] as TodoViewController
            let meetingViewController = tabBarViewController!.childViewControllers[1].childViewControllers[0] as MeetingViewController
            todoViewController.networkError()
            todoViewController.hideActivityIndicator()
        }
    }
}


