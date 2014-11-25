
import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

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
            
            Alamofire.request(.GET,"http://localhost:9000/api/user/login?username=" + username + "&password=" + password)
                .responseJSON{ (request, response, object, error) in
                    if(response != nil) {
                        if(response!.statusCode == 200) {
                            println("GET Login Successfully")
                            let json = JSON(object!)
                            let user = json["user"]
                            var pushToken = user["pushToken"].string
                            
                            // Push-Token PUT falls anders als jetziger
                        } else if(response!.statusCode == 401) {
                            println("Wrong User Credentials")
                            defaults.setObject([], forKey: "ActualUser")
                            defaults.setBool(false, forKey: "IsLoggedIn")
                            defaults.synchronize()
                        } else {
                            println("Response: " + response!.description)
                            println("Object: " + object!.description)
                            println("Error: " + error!.description)
                            defaults.setObject([], forKey: "ActualUser")
                            defaults.setBool(false, forKey: "IsLoggedIn")
                            defaults.synchronize()
                        }
                    } else {
                        defaults.setObject([], forKey: "ActualUser")
                        defaults.setBool(false, forKey: "IsLoggedIn")
                        defaults.synchronize()
                        println("No Connection!")
                    }
                    
            }
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

