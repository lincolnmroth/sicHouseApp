//
//  AddShoppingViewController.swift
//  sicHouseApp
//
//  Created by Lincoln Roth on 12/7/20.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddShoppingViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func submitDidPress(_ sender: Any) {
        let name = nameField.text!
        let priceRounded = round(100*Double(NSNumber(value:(priceField.text! as NSString).floatValue)))/(100)
        let price = NSNumber(value: priceRounded)
        let quantity = Int( quantityField.text!) ?? -1
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid;
            print(name)
            print(price)
            print(quantity)
            print(uid)
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
                newList.append(["name": name, "price": price, "quantity": quantity, "uid": uid])
                ref.child("shoppingList").setValue(newList)
                self.navigationController?.dismiss(animated: true, completion: nil)
                self.presentingViewController?.dismiss(animated: true, completion: nil)


              // ...
              }) { (error) in
                print(error.localizedDescription)
            }
            
        }
      
        
    }
    

}

