import UIKit
import Foundation

class TodoViewController: DataViewController, TodoDelegate  {

    lazy var todoService: TodoService = {
        var ts = TodoService()
        ts.todoDelegate = self
        return ts
        }()
    
    var todos: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func reloadData() {
        super.reloadData()
        if(apiReady) {
            todoService.getTodos()
        }
    }
}
extension TodoViewController : TodoDelegate {
    func todoSuccessful(json: JSON) {
        self.todos = json
        if(tableView != nil) {
            tableView.reloadData()
        }
    }
}

extension TodoViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(todos != nil) {
            return todos!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Todo", forIndexPath: indexPath) as TodoTableViewCell
        let todo = todos![indexPath.row]
        cell.setTodo(todo)
        
        cell.selectionStyle = .None
        cell.accessoryType = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var laterAction = UITableViewRowAction(style: .Normal, title: "Later") { (action, indexPath) -> Void in
            tableView.editing = false
            println("laterAction")
        }
        laterAction.backgroundColor = UIColorFromHex(0xDD182C, alpha: 1.0)
        
        var doneAction = UITableViewRowAction(style: .Default, title: "Done") { (action, indexPath) -> Void in
            tableView.editing = false
            println("doneAction")
        }
        doneAction.backgroundColor = UIColorFromHex(0x009EFF, alpha: 1.0)
        
        return [doneAction, laterAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Intentionally blank. Required to use UITableViewRowActions
    }
        
    
}

