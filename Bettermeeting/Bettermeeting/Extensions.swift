import UIKit

extension UIViewController {
    func showAlertView(title: String, text: String) {
        var alertView:UIAlertView = UIAlertView()
        alertView.title = title
        alertView.message = text
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}