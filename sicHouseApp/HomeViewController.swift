//
//  ViewController.swift
//  sicHouseApp
//
//  Created by Lincoln Roth on 11/23/20.
//

import UIKit
import FirebaseDatabase


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var washer1: UILabel!
    @IBOutlet weak var washer2: UILabel!
    @IBOutlet weak var dryer1: UILabel!
    @IBOutlet weak var dryer2: UILabel!
    
    var here: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadPeopleHere()
        reloadWasherDryer()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func refreshPage(_ sender: Any) {
        reloadPeopleHere()
        reloadWasherDryer()
    }
    func reloadWasherDryer(){
        let ref = Database.database().reference()
        ref.child("wdavailability").observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
            
          let value = snapshot.value as? NSDictionary
            let w1 = (value!["washer1"] as? NSDictionary)
            let w1stat = w1!["inUse"] as? Bool
            let w1time = w1!["timeLeft"] as? Int
            if (w1stat!){
                self.washer1.text = "Washer 1 is in use. " + String(w1time!) + " Minutes remaining."
            } else if (!w1stat!){
                self.washer1.text = "Washer 1 is not in use"
            }
            
            
            let w2 = (value!["washer2"] as? NSDictionary)
            let w2stat = w2!["inUse"] as? Bool
            let w2time = w2!["timeLeft"] as? Int
            if (w2stat!){
                self.washer2.text = "Washer 2 is in use. " + String(w2time!) + " Minutes remaining."
            } else if (!w2stat!){
                self.washer2.text = "Washer 2 is not in use"
            }
            
        
            
            let d1 = (value!["dryer1"] as? NSDictionary)
            let d1stat = d1!["inUse"] as? Bool
            let d1time = d1!["timeLeft"] as? Int
            if (d1stat!){
                self.dryer1.text = "Dryer 1 is in use. " + String(d1time!) + " Minutes remaining."
            } else if (!d1stat!){
                self.dryer1.text = "Dryer 1 is not in use"
            }
            
            let d2 = (value!["dryer2"] as? NSDictionary)
            let d2stat = d2!["inUse"] as? Bool
            let d2time = d2!["timeLeft"] as? Int
            if (d2stat!){
                self.dryer2.text = "Dryer 2 is in use. " + String(d2time!) + " Minutes remaining."
            } else if (!d2stat!){
                self.dryer2.text = "Dryer 2 is not in use"
            }
            
//            var temp: [String] = []
//            for person in value!{
//                let a = person as! Dictionary<String, Any>
//                if a["active"] as! Bool{
//                    print(a["name"]!)
//                    temp.append(a["name"] as! String)
//                }
//            }

          }) { (error) in
            print(error.localizedDescription)
        }
    }
    func reloadPeopleHere(){
        let ref = Database.database().reference()
        ref.child("devices").observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSArray
            print("hello good sir")
            print(value!)
            var temp: [String] = []
            for person in value!{
                let a = person as! Dictionary<String, Any>
                if a["active"] as! Bool{
                    print(a["name"]!)
                    temp.append(a["name"] as! String)
                }
            }
            self.here = temp
            
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
        return self.here.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("333")
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "cell1")!) as UITableViewCell
        cell.textLabel?.text = self.here[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("222")
        print("You selected cell #\(indexPath.row)!")
        tableView.deselectRow(at: indexPath, animated: true)
        
    }


}

