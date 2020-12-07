//
//  ShoppingViewController.swift
//  sicHouseApp
//
//  Created by Lincoln Roth on 12/7/20.
//

import UIKit
import FirebaseDatabase

class ShoppingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var list: [String] = []

    @IBOutlet weak var tableView: UITableView!
    @IBAction func refreshDidPress(_ sender: Any) {
        refreshShoppingList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshShoppingList()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        refreshShoppingList()
    }
    
    func refreshFirebaseShopping() {
        let ref = Database.database().reference()
        ref.child("shoppingList").observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
            var newList: [Dictionary<String,Any>] = []
            let oldList = snapshot.value as? NSArray
            for listItem in oldList!{
                if !(listItem is NSNull){
                    let item = listItem as! Dictionary<String, Any>
                    newList.append(item)
                }
            }
            
            ref.child("shoppingList").setValue(newList)
          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    func refreshShoppingList(){
        refreshFirebaseShopping()
        let ref = Database.database().reference()
        ref.child("shoppingList").observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSArray
            print("hello good sir")
            var temp: [String] = []
            for person in value!{
                if !(person is NSNull) {
                    let a = person as! Dictionary<String, Any>
                    let name = a["name"] as! String
                    let quantity = a["quantity"] as! Int
                    let price = a["price"] as! NSNumber
                    let tempString = name + "*" + String(quantity) + " @ $" + "\(price)" + " each"
                    temp.append(tempString)
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
            cell.textLabel?.text = self.list[indexPath.row]
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("222")
            print("You selected cell #\(indexPath.row)!")
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if (editingStyle == .delete) {
                let ref = Database.database().reference().child("shoppingList").child(String(indexPath.row))
                ref.removeValue { error, _ in

                    print(error)
                }
                refreshShoppingList()
                // handle delete (by removing the data from your array and updating the tableview)
            }
        }
   

}
