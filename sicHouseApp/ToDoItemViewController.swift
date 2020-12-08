//
//  ToDoItemViewController.swift
//  sicHouseApp
//
//  Created by Lincoln Roth on 12/7/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ToDoItemViewController: UIViewController {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var lincolnLabel: UILabel!
    @IBOutlet weak var anitejLabel: UILabel!
    @IBOutlet weak var riaLabel: UILabel!
    @IBOutlet weak var silpitaLabel: UILabel!
    @IBOutlet weak var rohanLabel: UILabel!
    @IBOutlet weak var aakashLabel: UILabel!
    @IBOutlet weak var samLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var lincolnSwitch: UISwitch!
    @IBOutlet weak var anitejSwitch: UISwitch!
    @IBOutlet weak var riaSwitch: UISwitch!
    @IBOutlet weak var silpitaSwitch: UISwitch!
    @IBOutlet weak var rohanSwitch: UISwitch!
    @IBOutlet weak var aakashSwitch: UISwitch!
    @IBOutlet weak var samSwitch: UISwitch!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var taskField: UITextField!
    
    @IBOutlet weak var commentsField: UITextField!
    
    
    var selectedItem: NSDictionary!
    var selectedIndex: Int!

    @IBAction func saveDidPress(_ sender: Any) {
        let newAssigments = ["Lincoln": lincolnSwitch.isOn,"Anitej": anitejSwitch.isOn,"Ria": riaSwitch.isOn,"Silpita": silpitaSwitch.isOn,"Rohan": rohanSwitch.isOn,"Aakash": aakashSwitch.isOn,"Sam": samSwitch.isOn]
        let comm = commentsField.text!
        let task = taskField.text!
        let date = datePicker.date
        
        let calendar = Calendar.current
        
        let year = String(calendar.component(.year, from: date))
        let month = String(calendar.component(.month, from: date))
        let day = String(calendar.component(.day, from: date))
        let hour = String(calendar.component(.hour, from: date))
        let minute = String(calendar.component(.minute, from: date))
        
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
                var i = 0
                for listItem in oldList!{
                    if !(listItem is NSNull){
                        let item = listItem as! Dictionary<String, Any>
                        if (i == self.selectedIndex){
                            newList.append(["assigned":newAssigments, "comments":comm, "creator":uid, "due":due, "task":task])
                        } else {
                            newList.append(item)
                        }
                    }
                    i+=1
                }
                
               
                ref.child("todolist").setValue(newList)
                self.navigationController?.dismiss(animated: true, completion: nil)
                self.presentingViewController?.dismiss(animated: true, completion: nil)


              // ...
              }) { (error) in
                print(error.localizedDescription)
            }
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        print(selectedItem)
        print(selectedIndex)
        let assignments = selectedItem!["assigned"] as! NSDictionary

        let initalTask = selectedItem!["task"] as! String
        let lincolnInitial = assignments["Lincoln"] as! Bool
        let anitejInitial = assignments["Anitej"] as! Bool
        let riaInitial = assignments["Ria"] as! Bool
        let silpitaInitial = assignments["Silpita"] as! Bool
        let rohanInitial = assignments["Rohan"] as! Bool
        let aakashInitial = assignments["Aakash"] as! Bool
        let samInitial = assignments["Sam"] as! Bool
        let creatorInitial = selectedItem!["creator"] as! String
        let dueInitial = selectedItem!["due"] as! String
        let commentInitial = selectedItem!["comments"] as! String

        if (lincolnInitial){
            lincolnSwitch.setOn(true, animated: false)
        } else {
            lincolnSwitch.setOn(false, animated: false)
        }
        if (anitejInitial){
            anitejSwitch.setOn(true, animated: false)
        } else {
            anitejSwitch.setOn(false, animated: false)
        }
        if (riaInitial){
            riaSwitch.setOn(true, animated: false)
        } else {
            riaSwitch.setOn(false, animated: false)
        }
        if (silpitaInitial){
            silpitaSwitch.setOn(true, animated: false)
        } else {
            silpitaSwitch.setOn(false, animated: false)
        }
        if (rohanInitial){
            rohanSwitch.setOn(true, animated: false)
        } else {
            rohanSwitch.setOn(false, animated: false)
        }
        if (aakashInitial){
            aakashSwitch.setOn(true, animated: false)
        } else {
            aakashSwitch.setOn(false, animated: false)
        }
        if (samInitial){
            samSwitch.setOn(true, animated: false)
        } else {
            samSwitch.setOn(false, animated: false)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        let date = dateFormatter.date(from: dueInitial)
        datePicker.date = date!
        
        taskField.text = initalTask
        creatorLabel.text = "Creator" + String(creatorInitial)
        commentsField.text = commentInitial
        
        // Do any additional setup after loading the view.
    }


}
