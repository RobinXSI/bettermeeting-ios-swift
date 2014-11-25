
import UIKit
import Alamofire

protocol TodoDelegate {
    func todoSuccessful(todos: [Todo])
    func authorizationError()
    func networkError()
}


class TodoService {
    
    var todoDelegate: TodoDelegate?
    
    init() {
        
    }
    
    func getTodos() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET,"http://localhost:9000/api/user/actionpoints")
            .responseJSON { (request, response, object, error) in
                
                println(response!.statusCode)
                /*if(response != nil) {
                    if(response!.statusCode == 200) {
                        println("GET ToDo Successfully")
                        let json = JSON(object!)
                        let todos = Todo.createFromJSON(json)
                        
                        self.todoDelegate?.todoSuccessful(todos)
                        
                    } else if(response!.statusCode == 401) {
                        self.todoDelegate?.authorizationError()
                        
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
                */
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

