import UIKit
import Foundation

class TodoViewController: DataViewController {

    @IBOutlet weak var tableView: UITableView!
   
    lazy var todoService: TodoService = {
        var ts = TodoService()
        ts.todoDelegate = self
        return ts
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func reloadData() {
        if(apiReady) {
            todoService.getTodos()
        }
    }
    
    
}

extension TodoViewController : TodoDelegate {
    func todoSuccessful(todos: [Todo]) {
        println("Todos Successful")
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

