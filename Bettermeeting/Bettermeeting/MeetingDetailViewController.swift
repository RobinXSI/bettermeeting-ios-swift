import UIKit

class MeetingDetailViewController: UIViewController {
    
    var meeting: JSON!
    
    @IBOutlet weak var txtGoal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtGoal.text = meeting["goal"].string
    }
    
    
    
}