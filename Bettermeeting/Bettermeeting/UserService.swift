
import Foundation
import Alamofire

class UserService {
    
    
    func loginUser(username: String, password: String) {
        Alamofire.request(.GET,"http://localhost:9000/api/user/login?username=" + username + "&password=23" + password)
            .responseJSON { (request, response, object, error) in
                println(response?.statusCode)
                if(response!.statusCode == 401) {
                    
                } else {
                    println("GET Login Successfully")
                    let json = JSON(object!)
                    
                    let user = json["user"]
                    let _id = user["_id"]["$oid"].string
                    let email = user["email"].string
                    let firstName = user["firstName"].string
                    let lastName = user["lastName"].string
                    let password = user["password"].string
                    var pushToken = user["pushToken"].string
                    
                    if pushToken == nil {
                        pushToken = ""
                    }
                    
                    let actualUser = User(_id: _id!, email: email!, firstName: firstName!, lastName: lastName!, password: password!, pushToken: pushToken!)
                    
                    println(actualUser.createDictionary())
                }
        }
    }
}

