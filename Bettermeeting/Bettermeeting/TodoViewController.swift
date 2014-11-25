import UIKit
import Foundation

class TodoViewController: DataViewController {

   
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
        super.reloadData()
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
    
    func Done(UITableViewRowAction!,
        NSIndexPath!) -> Void {
            
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    }
    
    
    
}

