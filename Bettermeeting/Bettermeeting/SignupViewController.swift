import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordConfirmation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signupTapped(sender: UIButton) {
        var username:NSString = txtEmail.text as NSString
        var firstname:NSString = txtFirstName.text as NSString
        var lastname:NSString = txtLastName.text as NSString
        var password:NSString = txtPassword.text as NSString
        var confirm_password:NSString = txtPasswordConfirmation.text as NSString
        
        if ( username.isEqualToString("")
            || password.isEqualToString("")
            || firstname.isEqualToString("")
            || lastname.isEqualToString("")
            ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please enter all required Information"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else if ( !password.isEqual(confirm_password) ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords doesn't Match"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            // DO SIGNIN
        }
    }
    
    @IBAction func gotoLogin(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
