import UIKit
import Alamofire

class ToDoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func testTapped(sender: UIButton) {
        Alamofire.request(.GET,"http://localhost:9000/api/meetings")
            .responseJSON { (request, response, object, error) in
                
                if(response!.statusCode == 200) {
                    println("GET Login Successfully")
                    let json = JSON(object!)
                    println(json)
                } else if(response!.statusCode == 401) {
                    self.showAlertView("Sign in Failed!", text: "Wrong User Credentials")
                } else {
                    self.showAlertView("Sign in Failed!", text: "Unkown Error. View Log!")
                    println("Response: " + response!.description)
                    println("Object: " + object!.description)
                    println("Error: " + error!.description)
                }
        }
        
    }
    
    
    @IBAction func logoutTapped(sender: UIBarButtonItem) {
        
        
        Alamofire.request(.GET,"http://localhost:9000/api/user/logout")
            .responseString{ (request, response, object, error) in
                if(response!.statusCode == 200) {
                    println(object)
                    
                } else {
                    self.showAlertView("Sign out Failed!", text: "Unkown Error. View Log!")
                    println("Response: " + response!.description)
                    println("Object: " + object!)
                    println("Error: " + error!.description)
                }
                var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject([], forKey: "ActualUser")
                defaults.setBool(false, forKey: "IsLoggedIn")
                defaults.synchronize()
                self.performSegueWithIdentifier("goto_login", sender: self)
        }
    }
    
    func showAlertView(title: String, text: String) {
        var alertView:UIAlertView = UIAlertView()
        alertView.title = title
        alertView.message = text
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Bool = defaults.boolForKey("IsLoggedIn") as Bool
        if(!isLoggedIn) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        }
        
    }
}

