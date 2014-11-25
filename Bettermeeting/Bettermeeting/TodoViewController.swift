import UIKit
import Foundation

class TodoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
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
            println(value)
            if(value){
                hideActivityIndicator()
            }
            
        }
    }
    
    
    lazy var userService: UserService = {
        var us = UserService()
        us.userLogoutDelegate = self
        return us
        }()
    
    lazy var todoService: TodoService = {
        var ts = TodoService()
        ts.todoDelegate = self
        return ts
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if(!apiReady) {
            showActivityIndicatory(self.view)
        }
    }
    
    func reloadData() {
        if(apiReady) {
            todoService.getTodos()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Bool = defaults.boolForKey("IsLoggedIn") as Bool
        if(!isLoggedIn) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        }
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
    
    @IBAction func logoutTapped(sender: UIBarButtonItem) {
        userService.logoutUser()
    }
    
    
}


extension TodoViewController : UserLogoutDelegate {
    func logoutSuccessful() {
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    func networkError() {
        self.showAlertView("Network Error!", text: "No Connection to Server")
    }
}

extension TodoViewController : TodoDelegate {
    func todoSuccessful(todos: [Todo]) {
        println("Todos Successful")
    }
    func authorizationError() {
    }
}

extension TodoViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        
        cell.textLabel.text = "hallo"
        cell.detailTextLabel?.text = "asdfasdfasdfasdf"
        
        return cell
    }
    
}

