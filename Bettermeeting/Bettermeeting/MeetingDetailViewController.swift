import UIKit

class MeetingDetailViewController: UIViewController {
    
    var meeting: JSON!
    
    @IBOutlet weak var txtGoal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtGoal.text = meeting["goal"].string
        
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "EE"
    
        var createdDate = NSDate(timeIntervalSince1970: meeting["created"].double! / 1000)
        var created = formatter.stringFromDate(createdDate)
        println(created)
    }
    
    func reloadData() {
    }
    
}