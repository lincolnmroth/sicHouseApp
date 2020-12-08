//
//  ToDoItemViewController.swift
//  sicHouseApp
//
//  Created by Lincoln Roth on 12/7/20.
//

import UIKit

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
    
    var selectedItem: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedItem)
        
        taskLabel.text = "Task:" + (selectedItem!["task"] as! String)
        let assignments = selectedItem!["assigned"] as! NSDictionary
        lincolnLabel.text = "Lincoln:" + String(assignments["Lincoln"] as! Int)
        anitejLabel.text = "Anitej:" + String(assignments["Anitej"] as! Int)
        riaLabel.text = "Ria:" + String(assignments["Ria"] as! Int)
        silpitaLabel.text = "Silpita:" + String(assignments["Silpita"] as! Int)
        rohanLabel.text = "Rohan:" + String(assignments["Rohan"] as! Int)
        aakashLabel.text = "Aakash:" + String(assignments["Aakash"] as! Int)
        samLabel.text = "Sam:" + String(assignments["Sam"] as! Int)
        dueLabel.text = "Due:" + (selectedItem!["due"] as! String)
        commentsLabel.text = "Comments:" + (selectedItem!["comments"] as! String)
        creatorLabel.text = "Creator:" + (selectedItem!["creator"] as! String)
        
        // Do any additional setup after loading the view.
    }


}
