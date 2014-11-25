
import UIKit
import Alamofire

protocol TodoDelegate: NetworkDelegate {
    func todoSuccessful(todos: [Todo])
}


class TodoService {
    
    var todoDelegate: TodoDelegate?
    
    init() {
        
    }
    
    func getTodos() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET,"http://localhost:9000/api/user/actionpoints")
            .responseJSON { (request, response, object, error) in
                if(response != nil) {
                    if(response!.statusCode == 200) {
                        println("GET ToDo Successfully")
                        let json = JSON(object!)
                        //let todos = Todo.createFromJSON(json)
                        
                        self.todoDelegate?.todoSuccessful([])
                        
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
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

