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
    
    var here: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadPeopleHere()
        // Do any additional setup after loading the view.
        
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

