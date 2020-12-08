//
//  AddToDoViewController.swift
//  sicHouseApp
//
//  Created by Lincoln Roth on 12/7/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddToDoViewController: UIViewController {

    @IBOutlet weak var taskName: UITextField!
    
    @IBOutlet weak var DueDate: UIDatePicker!
    
    @IBOutlet weak var lincolnAssign: UISwitch!
    @IBOutlet weak var anitejAssign: UISwitch!
    @IBOutlet weak var riaAssign: UISwitch!
    @IBOutlet weak var silpitaAssign: UISwitch!
    @IBOutlet weak var rohanAssign: UISwitch!
    @IBOutlet weak var aakashAssign: UISwitch!
    @IBOutlet weak var samAssign: UISwitch!
    
    @IBOutlet weak var comments: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    @IBAction func submitDidPress(_ sender: Any) {
        let assignees = ["Lincoln": lincolnAssign.isOn,"Anitej": anitejAssign.isOn,"Ria": riaAssign.isOn,"Silpita": silpitaAssign.isOn,"Rohan": rohanAssign.isOn,"Aakash": aakashAssign.isOn,"Sam": samAssign.isOn]
     
        let comm = comments.text!
        let task = taskName.text!
        
        let date = DueDate.date
        
        print(assignees)
        print(comm)
        print(task)
        print(date)
        print(type(of: date))
        
        let calendar = Calendar.current
        
        let year = String(calendar.component(.year, from: date))
        let month = String(calendar.component(.month, from: date))
        let day = String(calendar.component(.day, from: date))
        let hour = String(calendar.component(.hour, from: date))
        let minute = String(calendar.component(.minute, from: date))
        
        print(year)
        print(month)
        print(day)
        print(hour)
        print(minute)
        print(type(of: year))

        
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid;
            let creator = uid;
            let due = year + "-" + month + "-" + day + "-" + hour + "-" + minute
            
            let ref = Database.database().reference()
            ref.child("todolist").observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
                var newList: [Dictionary<String,Any>] = []
                let oldList = snapshot.value as? NSArray
                for listItem in oldList!{
                    if !(listItem is NSNull){
                        let item = listItem as! Dictionary<String, Any>
                        newList.append(item)
                    }
                }
                newList.append(["assigned":assignees, "comments":comm, "creator":uid, "due":due, "task":task])
                ref.child("todolist").setValue(newList)
                self.navigationController?.dismiss(animated: true, completion: nil)
                self.presentingViewController?.dismiss(animated: true, completion: nil)


              // ...
              }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
