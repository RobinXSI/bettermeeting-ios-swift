import UIKit
import Alamofire


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        var username:NSString = txtEmail.text
        var password:NSString = txtPassword.text
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            self.loginUser(username, password: password)
            
        }
    }
    
    func loginUser(username: String, password: String) {
        Alamofire.request(.GET,"http://localhost:9000/api/user/login?username=" + username + "&password=" + password)
            .responseJSON { (request, response, object, error) in
                
                if(response!.statusCode == 200) {
                    println("GET Login Successfully")
                    let json = JSON(object!)
                    
                    let user = json["user"]
                    let _id = user["_id"]["$oid"].string
                    let email = user["email"].string
                    let firstName = user["firstName"].string
                    let lastName = user["lastName"].string
                    let password = user["password"].string
                    var pushToken = user["pushToken"].string
                    
                    if pushToken == nil {
                        pushToken = ""
                    }
                    let actualUser = User(_id: _id!, email: email!, firstName: firstName!, lastName: lastName!, password: password!, pushToken: pushToken!)
                    
                    var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(actualUser.createDictionary(), forKey: "ActualUser")
                    defaults.setBool(true, forKey: "IsLoggedIn")
                    defaults.synchronize()
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
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
    
    func showAlertView(title: String, text: String) {
        var alertView:UIAlertView = UIAlertView()
        alertView.title = title
        alertView.message = text
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
}
