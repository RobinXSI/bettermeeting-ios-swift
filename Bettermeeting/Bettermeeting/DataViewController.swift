
import Foundation
import UIKit

class DataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var actualUser: User?
    
    lazy var userService: UserService = {
        var us = UserService()
        us.userLogoutDelegate = self
        return us
        }()
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var apiReadyValue = false
    var apiReady : Bool {
        get {
            return self.apiReadyValue
        }
        set(value) {
            self.apiReadyValue = value
            if(value){
                hideActivityIndicator()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(!apiReady) {
            showActivityIndicatory(self.view)
        }
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.backgroundColor = UIColorFromHex(0x323A41, alpha: 1.0)
        
        tableView.addSubview(refreshControl)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Bool = defaults.boolForKey("IsLoggedIn") as Bool
        if(!isLoggedIn) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        }
        
        self.reloadData()
    }
    
    func showActivityIndicatory(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    func reloadData() {
        if(self.refreshControl != nil) {
            self.refreshControl.endRefreshing()
        }
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let actualUserDictionary = defaults.dictionaryForKey("ActualUser") as NSDictionary!
        if(actualUserDictionary != nil) {
            self.actualUser = User.createFromDictionary(actualUserDictionary)
        }
    }
    
    func refresh(sender:AnyObject) {
        self.reloadData()
    }
    
    
    @IBAction func logoutTapped(sender: AnyObject) {
        userService.logoutUser()
    }
}


extension DataViewController: NetworkDelegate {
    func networkError() {
        self.showAlertView("Network Error!", text: "No Connection to Server")
    }
    func authenticationError() {
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}

extension DataViewController : UserLogoutDelegate {
    func logoutSuccessful() {
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}
