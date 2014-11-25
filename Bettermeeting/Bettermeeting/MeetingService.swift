
import UIKit
import Alamofire

protocol MeetingDelegate: NetworkDelegate {
    func meetingSuccessful(json: JSON)
}


class MeetingService {
    
    var meetingDelegate: MeetingDelegate?
    var serverPath: String
    
    init() {
        self.serverPath = NSBundle.mainBundle().objectForInfoDictionaryKey("IPServerAdress") as String
    }
    
    func getMeetings() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET,self.serverPath + "/api/user/meetings")
            .responseJSON { (request, response, object, error) in
                if(response != nil) {
                    if(response!.statusCode == 200) {
                        println("GET Meeting Successfully")
                        let json = JSON(object!)
                        self.meetingDelegate?.meetingSuccessful(json)
                        
                    } else if(response!.statusCode == 401) {
                        self.meetingDelegate?.authenticationError()
                        
                    } else {
                        println("Response: " + response!.description)
                        println("Object: " + object!.description)
                        println("Error: " + error!.description)
                        self.meetingDelegate?.networkError()
                    }
                } else {
                    println("No Connection!")
                    self.meetingDelegate?.networkError()
                }
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

