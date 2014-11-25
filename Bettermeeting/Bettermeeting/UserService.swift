
import UIKit
import Alamofire

protocol UserLoginDelegate: NetworkDelegate {
    func loginSuccessful(user: User)
}

protocol UserLogoutDelegate: NetworkDelegate {
    func logoutSuccessful()
}

class UserService {
    
    var userLoginDelegate: UserLoginDelegate?
    var userLogoutDelegate: UserLogoutDelegate?
    
    init() {
        
    }
    
    func loginUser(username: String, password: String) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET,"http://localhost:9000/api/user/login?username=" + username + "&password=" + password)
            .responseJSON { (request, response, object, error) in
            if(response != nil) {
                if(response!.statusCode == 200) {
                    println("GET Login Successfully")
                    let json = JSON(object!)
                    let user = User.createFromJSON(json)
                    
                    var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(user.createDictionary(), forKey: "ActualUser")
                    defaults.setBool(true, forKey: "IsLoggedIn")
                    defaults.synchronize()
                    self.userLoginDelegate?.loginSuccessful(user)
                    
                } else if(response!.statusCode == 401) {
                    var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject([], forKey: "ActualUser")
                    defaults.setBool(false, forKey: "IsLoggedIn")
                    defaults.synchronize()
                    self.userLoginDelegate?.authenticationError()
                    
                } else {
                    println("Response: " + response!.description)
                    println("Object: " + object!.description)
                    println("Error: " + error!.description)
                    self.userLoginDelegate?.networkError()
                    
                }
            } else {
                println("No Connection!")
                self.userLoginDelegate?.networkError()
            }
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func logoutUser() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET,"http://localhost:9000/api/user/logout")
            .responseString{ (request, response, object, error) in
            if(response != nil) {
                if(response!.statusCode == 200) {
                    println("GET Logout Successfully")
                    var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject([], forKey: "ActualUser")
                    defaults.setBool(false, forKey: "IsLoggedIn")
                    defaults.synchronize()
                    self.userLogoutDelegate?.logoutSuccessful()

                } else {
                    println("Response: " + response!.description)
                    println("Object: " + object!)
                    println("Error: " + error!.description)
                    self.userLogoutDelegate?.networkError()
                }
            } else {
                println("No Connection!")
                self.userLogoutDelegate?.networkError()
            }
                
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

