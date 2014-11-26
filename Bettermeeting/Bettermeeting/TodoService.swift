
import UIKit
import Alamofire

protocol TodoDelegate: NetworkDelegate {
    func todoSuccessful(json: JSON)
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
                    println("GET ToDo Successfully")
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
}

