
import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var pushToken: String?
    
    lazy var userService: UserService = {
        var us = UserService()
        us.userLoginDelegate = self
        return us
        }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        self.registerRemoteNotification()
        self.doAutoLogin()
        
        UINavigationBar.appearance().barStyle = .BlackTranslucent
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        UIToolbar.appearance().barStyle = .BlackTranslucent
        UITabBar.appearance().barStyle = .Black
        UITabBar.appearance().translucent = true
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        
        UIButton.appearance().tintColor = UIColor.whiteColor()
        
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
        self.pushToken = token.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
            .stringByReplacingOccurrencesOfString("<", withString: "", options: nil, range: nil)
            .stringByReplacingOccurrencesOfString(">", withString: "", options: nil, range: nil)
        println("\(self.pushToken!)")
        
        
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Registration failed: \(error)")
    }
}

extension AppDelegate : UserLoginDelegate {
    func loginSuccessful(user: User) {
        let tabBarViewController: UIViewController? = self.window?.rootViewController as UIViewController?
        if(tabBarViewController? != nil) {
            
            let meetingViewController = tabBarViewController!.childViewControllers[0].childViewControllers[0] as DataViewController
            let todoViewController = tabBarViewController!.childViewControllers[1].childViewControllers[0] as DataViewController
            meetingViewController.apiReady = true
            todoViewController.apiReady = true
            meetingViewController.reloadData()
            todoViewController.reloadData()
        }
        
        if(self.pushToken != nil) {
            println("Eigener Pushtoken: " + self.pushToken!)
            if(user.pushToken == "" || user.pushToken != self.pushToken!) {
               println("update")
                userService.updatePushToken(self.pushToken!)
            }
        }
    }
}

extension AppDelegate : NetworkDelegate {
    func authenticationError() {
        let tabBarViewController: UIViewController? = self.window?.rootViewController as UIViewController?
        if(tabBarViewController? != nil) {
            let meetingViewController = tabBarViewController!.childViewControllers[0].childViewControllers[0] as DataViewController
            let todoViewController = tabBarViewController!.childViewControllers[1].childViewControllers[0] as DataViewController
            meetingViewController.apiReady = true
            todoViewController.apiReady = true
            meetingViewController.authenticationError()
            todoViewController.authenticationError()
        }
    }
    func networkError() {
        let tabBarViewController: UIViewController? = self.window?.rootViewController as UIViewController?
        if(tabBarViewController? != nil) {
            let meetingViewController = tabBarViewController!.childViewControllers[0].childViewControllers[0] as DataViewController
            let todoViewController = tabBarViewController!.childViewControllers[1].childViewControllers[0] as DataViewController
            meetingViewController.apiReady = true
            todoViewController.apiReady = true
            meetingViewController.networkError()
            todoViewController.networkError()
        }
    }
}


