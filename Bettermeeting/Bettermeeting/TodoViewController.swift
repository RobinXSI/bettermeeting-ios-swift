import UIKit
import Foundation

class TodoViewController: DataViewController, TodoDelegate  {

    lazy var todoService: TodoService = {
        var ts = TodoService()
        ts.todoDelegate = self
        return ts
        }()
    
    //var todos: JSON!
    
    var todos: [JSON]!
    
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
    
    func todoDone(indexRow: Int) {
        todoService.markAsDone(todos[indexRow], indexRow: indexRow)
    }
    
    func todoLater(indexRow: Int) {
        
        let alert = UIAlertController(
            title: "Don't have enough time?",
            message: "Do your ToDo later",
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        let plus4hours = UIAlertAction(
            title: "Add 4 Hours",
            style: UIAlertActionStyle.Default)
            { (alert) -> Void in
                self.todoService.addTime(self.todos[indexRow], indexRow: indexRow, timeInHours: 4)
            }
        let plus24hours = UIAlertAction(
            title: "Add 1 day",
            style: UIAlertActionStyle.Default)
            { (alert) -> Void in
                self.todoService.addTime(self.todos[indexRow], indexRow: indexRow, timeInHours: 24)
        }
        let plus48hours = UIAlertAction(
            title: "Add 2 days",
            style: UIAlertActionStyle.Default)
            { (alert) -> Void in
                self.todoService.addTime(self.todos[indexRow], indexRow: indexRow, timeInHours: 48)
        }
        let plus1week = UIAlertAction(
            title: "Add 1 week",
            style: UIAlertActionStyle.Default)
            { (alert) -> Void in
                self.todoService.addTime(self.todos[indexRow], indexRow: indexRow, timeInHours: 168)
        }
        let cancelButton = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Cancel)
            { (alert) -> Void in
                println("Cancel Pressed")
            }
        
        alert.addAction(plus4hours)
        alert.addAction(plus24hours)
        alert.addAction(plus48hours)
        alert.addAction(plus1week)
        alert.addAction(cancelButton)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
extension TodoViewController : TodoDelegate {
    func todoSuccessful(json: JSON) {
        self.todos = json.array
        if(tableView != nil) {
            tableView.reloadData()
        }
    }
    
    func markAsDoneSuccessful(json: JSON, indexRow: Int) {
        self.todos.removeAtIndex(indexRow)
        if(tableView != nil) {
            tableView.reloadData()
        }
    }
    
    func doLater(todo: JSON, indexRow: Int, timeInHours: Int) {
        self.todos[indexRow] = todo
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
            self.todoLater(indexPath.row)
        }
        laterAction.backgroundColor = UIColorFromHex(0xDD182C, alpha: 1.0)
        
        var doneAction = UITableViewRowAction(style: .Default, title: "Done") { (action, indexPath) -> Void in
            tableView.editing = false
            self.todoDone(indexPath.row)
        }
        doneAction.backgroundColor = UIColorFromHex(0x009EFF, alpha: 1.0)
        
        return [doneAction, laterAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Intentionally blank. Required to use UITableViewRowActions
    }
        
    
}

