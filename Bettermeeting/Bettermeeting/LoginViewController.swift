import UIKit


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
        
        txtEmail.delegate = self
        txtPassword.delegate = self
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

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var nextTag = textField.tag + 1
        
        var nextResponder = textField.superview?.viewWithTag(nextTag)
        
        if(nextResponder != nil) {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.loginTapped(self)
        }
        return false
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
    }
}

extension LoginViewController : UserLoginDelegate {
    func loginSuccessful(user: User) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.loginSuccessful(user)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
extension LoginViewController: NetworkDelegate {
    func authenticationError() {
        self.showAlertView("Sign in Failed!", text: "Wrong User Credentials")
    }
    func networkError() {
        self.showAlertView("No Connection!", text: "Connection to server failed")
    }
}
