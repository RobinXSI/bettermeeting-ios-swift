import UIKit

class MeetingViewController: UIViewController {
    
    lazy var userService: UserService = {
        var us = UserService()
        us.userLogoutDelegate = self
        return us
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Bool = defaults.boolForKey("IsLoggedIn") as Bool
        if(!isLoggedIn) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        }
    }
    
    @IBAction func logoutTapped(sender: UIBarButtonItem) {
        userService.logoutUser()
    }
}

extension MeetingViewController : UserLogoutDelegate {
    func logoutSuccessful() {
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    func networkError() {
        self.showAlertView("Sign out Failed!", text: "Unkown Error. View Log!")
    }
}
