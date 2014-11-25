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
            println(meetings!.count)
            return meetings!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Meeting", forIndexPath: indexPath) as MeetingTableViewCell
        let meeting = meetings![indexPath.row]
        cell.setMeeting(meeting)
        return cell
    }
    
}
