//
//  ProfileViewController.swift
//  sicHouseApp
//
//  Created by Lincoln Roth on 12/7/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameField: UILabel!
    @IBAction func signOutDidPress(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            print(uid)
//            self.nameField.text = uid
            let ref = Database.database().reference()
            ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
              let value = snapshot.value as? NSDictionary
                print("hello good sir")
                let name = value!["name"] as! String
                let device = value!["device"] as! String
                self.nameField.text = "Name: " + name + " Device: " + device

            
              }) { (error) in
                print(error.localizedDescription)
            }
            
            
            
            
        }
        // Do any additional setup after loading the view.
    }


}
