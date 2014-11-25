import UIKit
import QuartzCore

class MeetingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var txtMonth: UILabel!
    @IBOutlet weak var txtDay: UILabel!
    @IBOutlet weak var txtWeekDay: UILabel!
    @IBOutlet weak var txtGoal: UILabel!
    
    func setMeeting(meeting: JSON) {
        txtGoal.text = meeting["goal"].string
    }   
}