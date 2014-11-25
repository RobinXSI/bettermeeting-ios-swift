
import UIKit
import Alamofire

protocol MeetingDelegate: NetworkDelegate {
    func meetingSuccessful()
}


class MeetingService {
    
    var meetingDelegate: MeetingDelegate?
    
    init() {
        
    }
    
    func getMeetings() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET,"http://localhost:9000/api/user/meetings")
            .responseJSON { (request, response, object, error) in
                if(response != nil) {
                    if(response!.statusCode == 200) {
                        println("GET Meeting Successfully")
                        let json = JSON(object!)
                        println(json)
                        self.meetingDelegate?.meetingSuccessful()
                        
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

