//
//  LoginViewController.swift
//  sicHouseApp
//
//  Created by Lincoln Roth on 11/23/20.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passField: UITextField!
    
    @IBAction func signupdidpress(_ sender: Any) {
        
    }
    @IBAction func loginPress(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!,
                               password: passField.text!) { (user, error) in
                                if error != nil{
                                    let errorCode = "bad"
                                    self.errorAlert(errorCode)
                                }else{
                                    self.checkIfLogged()
                                }
        }
    }
    
    @IBAction func signupPress(_ sender: Any) {
    }
    
    func errorAlert(_ errorWords: String){
        let alert = UIAlertController(title: "Error",
                                      message:  errorWords,
                                      preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry",
                                        style: .default){ action in
                                            
        }
        alert.addAction(retryAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    func checkIfLogged(){
        if Auth.auth().currentUser != nil {
            print("im in")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
            secondViewController.modalPresentationStyle = .fullScreen

            self.present(secondViewController, animated: true, completion: nil)

        } else {
            print("im not in")
        }

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        checkIfLogged()
        
        super.viewDidAppear(animated)
    }

}


