
import UIKit
import Alamofire

protocol TodoDelegate: NetworkDelegate {
    func todoSuccessful(json: JSON)
    func markAsDoneSuccessful(json: JSON, indexRow: Int)
    func doLater(todo: JSON, indexRow: Int, timeInHours: Int)
}


class TodoService {
    
    var todoDelegate: TodoDelegate?
    var serverPath: String
    
    init() {
        self.serverPath = NSBundle.mainBundle().objectForInfoDictionaryKey("IPServerAdress") as String
    }
    
    func getTodos() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET, self.serverPath + "/api/user/actionpoints")
            .responseJSON { (request, response, object, error) in
                if(response != nil) {
                    if(response!.statusCode == 200) {
                        println("GET Todo Successfully")
                        let json = JSON(object!)
                        self.todoDelegate?.todoSuccessful(json)
                    } else if(response!.statusCode == 401) {
                        self.todoDelegate?.authenticationError()
                        
                    } else {
                        println("Response: " + response!.description)
                        println("Object: " + object!.description)
                        println("Error: " + error!.description)
                        self.todoDelegate?.networkError()
                    }
                } else {
                    println("No Connection!")
                    self.todoDelegate?.networkError()
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
    }
    
    func markAsDone(todo: JSON, indexRow: Int) {
        var updatedTodo = todo
        updatedTodo["status"] = JSON("done")
        
        let id : String = todo["_id"]["$oid"].string!
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.PUT, self.serverPath + "/api/actionpoint/" + id, parameters: updatedTodo.dictionaryObject, encoding: .JSON)
            .responseJSON { (request, response, object, error) in
                if(response != nil) {
                    if(response!.statusCode == 200) {
                        println("PUT Todo Successfully")
                        let json = JSON(object!)
                        self.todoDelegate?.markAsDoneSuccessful(json, indexRow: indexRow)
                        
                    } else if(response!.statusCode == 401) {
                        self.todoDelegate?.authenticationError()
                        
                    } else {
                        println("Response: " + response!.description)
                        println("Object: " + object!.description)
                        println("Error: " + error!.description)
                        self.todoDelegate?.networkError()
                    }
                } else {
                    println("No Connection!")
                    self.todoDelegate?.networkError()
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }

    }
    
    func addTime(todo: JSON, indexRow: Int, timeInHours: Int) {
        var updatedTodo = todo
        let updatedDueDate: Int = updatedTodo["dueDate"].int! + (timeInHours * 60 * 60 * 1000)
        updatedTodo["dueDate"] = JSON(updatedDueDate)
        
        let id : String = todo["_id"]["$oid"].string!
        
        Alamofire.request(.PUT, self.serverPath + "/api/actionpoint/" + id, parameters: updatedTodo.dictionaryObject, encoding: .JSON)
            .responseJSON { (request, response, object, error) in
                if(response != nil) {
                    if(response!.statusCode == 200) {
                        println("PUT Todo Successfully")
                        let json = JSON(object!)
                        self.todoDelegate?.doLater(updatedTodo, indexRow: indexRow, timeInHours: timeInHours)
                        
                    } else if(response!.statusCode == 401) {
                        self.todoDelegate?.authenticationError()
                        
                    } else {
                        println("Response: " + response!.description)
                        println("Object: " + object!.description)
                        println("Error: " + error!.description)
                        self.todoDelegate?.networkError()
                    }
                } else {
                    println("No Connection!")
                    self.todoDelegate?.networkError()
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        

        
        
    }
}

