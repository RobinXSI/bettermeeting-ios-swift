import UIKit
import Alamofire


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    lazy var userService: UserService = {
        var us = UserService()
        us.userLoginDelegate = self
        return us
    }()

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
            userService.loginUser(username, password: password)
        }
    }
}

extension LoginViewController : UserLoginDelegate {
    func loginSuccessful() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func authorizationError() {
        self.showAlertView("Sign in Failed!", text: "Wrong User Credentials")
    }
    func networkError() {
        self.showAlertView("No Connection!", text: "Connection to server failed")
    }
}
