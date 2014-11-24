import UIKit

class MeetingViewController: UIViewController {
    
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
    
    

}
