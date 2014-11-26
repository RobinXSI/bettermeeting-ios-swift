
import UIKit
import Alamofire

protocol MeetingDelegate: NetworkDelegate {
    func meetingSuccessful(json: JSON)
}

protocol VoteDelegate: NetworkDelegate {
    func voteSuccessful(json: JSON, type: String, up: Bool)
}


class MeetingService {
    
    var meetingDelegate: MeetingDelegate?
    var voteDelegate: VoteDelegate?
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
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func voteOnMeeting(meeting: JSON, type: String, up: Bool) {
        
        let parameters = [
            "voteValue": (up) ? 1 : -1
        ]
        
        let id : String = meeting["_id"]["$oid"].string!
        let upDown : String = (up) ? "up" : "down"
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        Alamofire.request(.PUT, self.serverPath + "/api/meetings/" + id + "/vote/" + type + "/" + upDown, parameters: parameters)
        .responseJSON { (request, response, object, error) in
            if(response != nil) {
                if(response!.statusCode == 200) {
                    let json = JSON(object!)
                    self.voteDelegate?.voteSuccessful(json, type: type, up: up)
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
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}

