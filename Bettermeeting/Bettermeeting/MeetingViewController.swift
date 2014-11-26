import UIKit

class MeetingViewController: DataViewController {
    
    lazy var meetingService: MeetingService = {
        var ms = MeetingService()
        ms.meetingDelegate = self
        return ms
        }()
    
    var meetings: JSON?
    var didAnimateCell:[NSIndexPath: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = UIColorFromHex(0x323A41, alpha: 1.0)
    }
    
    override func reloadData() {
        super.reloadData()
        if(apiReady) {
            meetingService.getMeetings()
        }
    }
}

extension MeetingViewController : MeetingDelegate {
    func meetingSuccessful(json: JSON) {
        meetings = json
        tableView.reloadData()
    }
}

extension MeetingViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if didAnimateCell[indexPath] == nil || didAnimateCell[indexPath]! == false {
            didAnimateCell[indexPath] = true
            CellAnimator.animate(cell)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(meetings != nil) {
            return meetings!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Meeting", forIndexPath: indexPath) as MeetingTableViewCell
        let meeting = meetings![indexPath.row]
        
        cell.setMeeting(meeting, username:self.actualUser!.email)
        
        cell.selectionStyle = .None
        cell.accessoryType = .None
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "meeting_selected") {
            var indexPath = self.tableView.indexPathForSelectedRow()
            var destinationViewController: MeetingDetailViewController = segue.destinationViewController as MeetingDetailViewController;
            destinationViewController.meeting = self.meetings![indexPath!.row]
            destinationViewController.user = self.actualUser
        }
    }
    
}
