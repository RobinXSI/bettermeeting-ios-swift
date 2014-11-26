import UIKit

class MeetingDetailViewController: UIViewController {
    
    lazy var meetingService: MeetingService = {
        var ms = MeetingService()
        ms.voteDelegate = self
        return ms
        }()
    
    var meeting: JSON!
    var user: User!
    
    var didAnimateCell:[NSIndexPath: Bool] = [:]
    @IBOutlet weak var txtGoal: UILabel!
    
    @IBOutlet weak var txtEfficiencyVote: UILabel!
    @IBOutlet weak var txtGoalVote: UILabel!
    
    @IBOutlet weak var btnEfficiencyDown: UIButton!
    @IBOutlet weak var btnEfficiencyUp: UIButton!
    @IBOutlet weak var btnGoalDown: UIButton!
    @IBOutlet weak var btnGoalUp: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtGoal.text = meeting["goal"].string
        
        let imgVoteUp = UIImage(named: "vote-up.png")!
        let imgVoteDown = UIImage(named: "vote-down.png")!
        
        btnEfficiencyUp.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnEfficiencyUp.setImage(imgVoteUp, forState:UIControlState.Normal)
        btnEfficiencyUp.setImage(imgVoteUp, forState:UIControlState.Highlighted)
        btnEfficiencyUp.setTitle("", forState: UIControlState.Normal)
        btnEfficiencyUp.backgroundColor = UIColorFromHex(0x8CD055, alpha: 1.0)
        
        btnEfficiencyDown.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnEfficiencyDown.setImage(imgVoteDown, forState:UIControlState.Normal)
        btnEfficiencyDown.setImage(imgVoteDown, forState:UIControlState.Highlighted)
        btnEfficiencyDown.setTitle("", forState: UIControlState.Normal)
        btnEfficiencyDown.backgroundColor = UIColorFromHex(0xDD182C, alpha: 1.0)
        
        btnGoalUp.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnGoalUp.setImage(imgVoteUp, forState:UIControlState.Normal)
        btnGoalUp.setImage(imgVoteUp, forState:UIControlState.Highlighted)
        btnGoalUp.setTitle("", forState: UIControlState.Normal)
        btnGoalUp.backgroundColor = UIColorFromHex(0x8CD055, alpha: 1.0)
        
        btnGoalDown.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnGoalDown.setImage(imgVoteDown, forState:UIControlState.Normal)
        btnGoalDown.setImage(imgVoteDown, forState:UIControlState.Highlighted)
        btnGoalDown.setTitle("", forState: UIControlState.Normal)
        btnGoalDown.backgroundColor = UIColorFromHex(0xDD182C, alpha: 1.0)
        
        if(meeting["organizer"].string == user.email) {
            btnEfficiencyUp.enabled = false
            btnEfficiencyDown.enabled = false
            btnGoalUp.enabled = false
            btnGoalDown.enabled = false
        } else {
            for(index: String, voteOnGoal: JSON) in meeting["votesOnGoal"] {
                if(voteOnGoal["email"].string == user.email) {
                    if(voteOnGoal["voteValue"].int == 1) {
                        println("Positives Voting on Goal")
                        btnGoalDown.backgroundColor = UIColorFromHex(0xE0E0E0, alpha: 1.0)
                    } else {
                        println("Negatives Voting on Goal")
                        btnGoalUp.backgroundColor = UIColorFromHex(0xE0E0E0, alpha: 1.0)
                    }
                    break
                }
            }
            
            for(index: String, voteOnEfficiency: JSON) in meeting["votesOnEfficiency"] {
                if(voteOnEfficiency["email"].string == user.email) {
                    if(voteOnEfficiency["voteValue"].int == 1) {
                        println("Positives Voting on Efficiency")
                        btnEfficiencyDown.backgroundColor = UIColorFromHex(0xE0E0E0, alpha: 1.0)
                    } else {
                        println("Negatives Voting on Efficiency")
                        btnEfficiencyUp.backgroundColor = UIColorFromHex(0xE0E0E0, alpha: 1.0)
                    }
                    break
                }
            }
        }  
    }
    
    @IBAction func tippedEfficiencyDown(sender: UIButton) {
        println("Tipped Efficiency Down")
        self.meetingService.voteOnMeeting(self.meeting, type: "efficiency", up: false)
    }
    @IBAction func tippedEfficiencyUp(sender: UIButton) {
        println("Tipped Efficiency Up")
        self.meetingService.voteOnMeeting(self.meeting, type: "efficiency", up: true)
    }
    @IBAction func tippedGoalDownn(sender: UIButton) {
        println("Tipped Goal Down")
        self.meetingService.voteOnMeeting(self.meeting, type: "goal", up: false)
    }
    @IBAction func tippedGoalUp(sender: UIButton) {
        println("Tipped Goal Up")
        self.meetingService.voteOnMeeting(self.meeting, type: "goal", up: true)
    }
}
extension MeetingDetailViewController : VoteDelegate {
    func voteSuccessful(json: JSON, type: String, up: Bool) {
        if(type == "efficiency") {
            if(up) {
                btnEfficiencyUp.backgroundColor = UIColorFromHex(0x8CD055, alpha: 1.0)
                btnEfficiencyDown.backgroundColor = UIColorFromHex(0xE0E0E0, alpha: 1.0)
            } else {
                btnEfficiencyUp.backgroundColor = UIColorFromHex(0xE0E0E0, alpha: 1.0)
                btnEfficiencyDown.backgroundColor = UIColorFromHex(0xDD182C, alpha: 1.0)
            }
        }
        if(type == "goal") {
            if(up) {
                btnGoalUp.backgroundColor = UIColorFromHex(0x8CD055, alpha: 1.0)
                btnGoalDown.backgroundColor = UIColorFromHex(0xE0E0E0, alpha: 1.0)
            } else {
                btnGoalUp.backgroundColor = UIColorFromHex(0xE0E0E0, alpha: 1.0)
                btnGoalDown.backgroundColor = UIColorFromHex(0xDD182C, alpha: 1.0)
            }
        }
    }
}

extension MeetingDetailViewController: NetworkDelegate {
    func networkError() {
        self.showAlertView("Network Error!", text: "No Connection to Server")
    }
    func authenticationError() {
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}

