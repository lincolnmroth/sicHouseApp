//
//  ToDoViewController.swift
//  sicHouseApp
//
//  Created by Lincoln Roth on 12/7/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var list: [NSDictionary] = []
    var selected = NSDictionary()

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func refreshPage(_ sender: Any) {
        reloadToDoList()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadToDoList()
        // Do any additional setup after loading the view.
    }
    func refreshFirebaseToDo(){
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
            
            ref.child("todolist").setValue(newList)
          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    func reloadToDoList(){
        refreshFirebaseToDo()
        let ref = Database.database().reference()
        ref.child("todolist").observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSArray
            print("hello good sir")
            var temp: [NSDictionary] = []
            for person in value!{
                if !(person is NSNull) {
                    let a = person as! Dictionary<String, Any>
                    temp.append(a as NSDictionary)
                }

            }
            self.list = temp
            
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")

            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("111")
        return self.list.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("333")
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "cell1")!) as UITableViewCell
        cell.textLabel?.text = self.list[indexPath.row]["task"] as? String
        let assignees = self.list[indexPath.row]["assigned"] as! NSDictionary
        let userLookup = ["L40PTHjlsmbU0KF9yRPdbaPIy462":"Lincoln", "a":"Anitej", "b":"Ria", "c":"Silpita", "d":"Rohan", "e":"Aakash", "f":"Sam"]
        let user = Auth.auth().currentUser
        
        if let user = user {
            let uid = user.uid;
            print(assignees)

            print(uid)
            
            let isAssignee = assignees[userLookup[uid]] as! Bool
            if (isAssignee){
                cell.textLabel?.textColor = UIColor.red

            } else {
                cell.textLabel?.textColor = UIColor.green

            }
            
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("222")
        print("You selected cell #\(indexPath.row)!")
        selected = self.list[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "todosegue", sender: (self.tableView.dequeueReusableCell(withIdentifier: "cell1")!) as UITableViewCell)

        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let ref = Database.database().reference().child("todolist").child(String(indexPath.row))
            ref.removeValue { error, _ in

                print(error)
            }
            reloadToDoList()
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("testestst")
        if let destination = segue.destination as? ToDoItemViewController{
            destination.selectedItem = selected

        }
        
    }


}
