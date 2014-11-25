import UIKit
import QuartzCore

class MeetingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var txtMonth: UILabel!
    @IBOutlet weak var txtDay: UILabel!
    @IBOutlet weak var txtWeekDay: UILabel!
    @IBOutlet weak var txtGoal: UILabel!
    @IBOutlet weak var txtVote: UILabel!
    @IBOutlet weak var imgVote: UIImageView!
    
    
    func setMeeting(meeting: JSON, username: String) {
        txtGoal.text = meeting["goal"].string
        
        var formatter: NSDateFormatter = NSDateFormatter()
        var createdDate = NSDate(timeIntervalSince1970: meeting["created"].double! / 1000)
        
        formatter.dateFormat = "MMM"
        txtMonth.text = formatter.stringFromDate(createdDate).uppercaseString
        
        formatter.dateFormat = "dd"
        txtDay.text = formatter.stringFromDate(createdDate)
        
        formatter.dateFormat = "EEE"
        txtWeekDay.text = formatter.stringFromDate(createdDate).uppercaseString
        
        if(meeting["organizer"].string == username) {
            self.backgroundColor = UIColorFromHex(0xCE1836, alpha: 1.0)
            imgVote.hidden = true
            txtVote.hidden = true
        } else {
            self.backgroundColor = UIColorFromHex(0x009989, alpha: 1.0)
            
            var voted = false
            for(index: String, voteOnGoal: JSON) in meeting["votesOnGoal"] {
                if(voteOnGoal["email"].string == username) {
                    voted = true
                    break
                }
            }
            if(voted) {
                imgVote.hidden = true
                txtVote.hidden = true
            }
        }
        
        
    }
}