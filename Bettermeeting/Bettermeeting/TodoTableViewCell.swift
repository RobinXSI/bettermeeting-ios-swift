import UIKit
import QuartzCore

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var txtMonth: UILabel!
    @IBOutlet weak var txtDay: UILabel!
    @IBOutlet weak var txtWeekDay: UILabel!
    @IBOutlet weak var txtSubject: UILabel!
    @IBOutlet weak var txtremainingTime: UILabel!
    @IBOutlet weak var txtTime: UILabel!
    
    func setTodo(todo: JSON) {
        txtSubject.text = todo["subject"].string
        
        var formatter: NSDateFormatter = NSDateFormatter()
        var dueDate = NSDate(timeIntervalSince1970: todo["dueDate"].double! / 1000)
        
        formatter.dateFormat = "MMM"
        txtMonth.text = formatter.stringFromDate(dueDate).uppercaseString
        
        formatter.dateFormat = "dd"
        txtDay.text = formatter.stringFromDate(dueDate)
        
        formatter.dateFormat = "EEE"
        txtWeekDay.text = formatter.stringFromDate(dueDate).uppercaseString
        
        formatter.dateFormat = "HH:mm"
        txtTime.text = formatter.stringFromDate(dueDate).uppercaseString
        
        let difference = NSCalendar.currentCalendar().components(.DayCalendarUnit, fromDate: NSDate(), toDate: dueDate, options: nil)
        let dueTime = difference.day
        if(dueTime > 0) {
            txtremainingTime.text = dueTime.description + " days left"
        } else {
            txtremainingTime.text = dueTime.description + " days overdue"
        }
    }
}