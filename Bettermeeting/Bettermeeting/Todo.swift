
import Foundation


class Todo {
    let _id : String
    var subject : String
    var editor : String
    var owner : String
    var status : String
    var dueDate : NSNumber
    var reminderDate : NSNumber
    var reminderType : String
    var created : NSNumber
    var updated : NSNumber
    
    init(
        _id: String,
        subject: String,
        editor: String,
        owner: String,
        status: String,
        dueDate: NSNumber,
        reminderDate: NSNumber,
        reminderType: String,
        created: NSNumber,
        updated: NSNumber) {
            self._id = _id
            self.subject = subject
            self.editor = editor
            self.owner = owner
            self.status = status
            self.dueDate = dueDate
            self.reminderDate = reminderDate
            self.reminderType = reminderType
            self.created = created
            self.updated = updated
    }
    
    func createDictionary () -> NSDictionary {
        var idObject: NSDictionary = [
            "$oid": self._id
        ]
        var dictionary: NSDictionary = [
            "_id": idObject,
            "subject": self.subject,
            "editor": self.editor,
            "owner": self.owner,
            "status": self.status,
            "dueDate": self.dueDate,
            "reminderDate": self.reminderDate,
            "reminderType": self.reminderType,
            "created": self.created,
            "updated": self.updated
        ]
        return dictionary
    }
    
    class func createFromDictionary(dictionary : NSDictionary) -> User {
        var idObject = dictionary["_id"] as Dictionary<String, AnyObject>
        var actualUser = User(
            _id: idObject["$oid"] as String,
            email: dictionary["email"] as String,
            firstName: dictionary["firstName"] as String,
            lastName: dictionary["lastName"] as String,
            password: dictionary["password"] as String,
            pushToken: dictionary["pushToken"] as String
        )
        return actualUser
    }
    
    class func createFromJSON(json : JSON) -> [Todo] {
        var todos = [Todo]()
        for (index: String, todoJson: JSON) in json {
            let _id = todoJson["_id"]["$oid"].string
            let subject = todoJson["subject"].string
            let editor = todoJson["subject"].string
            let owner = todoJson["owner"].string
            let status = todoJson["status"].string
            let dueDate = todoJson["dueDate"].int
            let reminderDate = todoJson["reminderDate"].int
            let reminderType = todoJson["reminderType"].string
            let created = todoJson["created"].int
            let updated = todoJson["updated"].int
            
            var todo = Todo(_id: _id!, subject: subject!, editor: editor!, owner: owner!, status: status!, dueDate: dueDate!, reminderDate: reminderDate!, reminderType: reminderType!, created: created!, updated: updated!)
            todos.append(todo)
            println(todo.createDictionary())
        }
        println(todos)
        return todos
    }
    
}