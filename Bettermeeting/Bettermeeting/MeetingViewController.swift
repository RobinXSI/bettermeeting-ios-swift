import UIKit
import Foundation

class MeetingViewController: DataViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var meetingService: MeetingService = {
        var ms = MeetingService()
        ms.meetingDelegate = self
        return ms
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func reloadData() {
        if(apiReady) {
            meetingService.getMeetings()
        }
    }
}

extension MeetingViewController : MeetingDelegate {
    func meetingSuccessful() {
        
    }
}


extension MeetingViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        
        cell.textLabel.text = "hallo"
        cell.detailTextLabel?.text = "asdfasdfasdfasdf"
        
        return cell
    }
    
}
