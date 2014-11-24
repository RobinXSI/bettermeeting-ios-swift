
import Foundation

class User {
    let _id: String
    let email: String
    let firstName: String
    let lastName: String
    let password: String
    let pushToken: String
    
    init(
        _id: String,
        email: String,
        firstName: String,
        lastName: String,
        password: String,
        pushToken: String) {
            self._id = _id
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.password = password
            self.pushToken = pushToken
    }
    
    func createDictionary () -> NSDictionary {
        var idObject: NSDictionary = [
            "$oid": self._id
        ]
        var dictionary: NSDictionary = [
            "_id": idObject,
            "email": self.email,
            "firstName": self.firstName,
            "lastName": self.lastName,
            "password": self.password,
            "pushToken": self.pushToken
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
}
