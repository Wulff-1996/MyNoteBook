//
//  SigninViewController.swift
//  MyNoteBook Mandatory 2
//
//  Created by Jakob Wulff on 15/03/2019.
//  Copyright © 2019 Jakob Wulff. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SigninViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    //  references
    var fStore : Firestore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fStore = Firestore.firestore()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doBtnSingin(_ sender: Any) {
        
        if Auth.auth().currentUser == nil{
            if let email = tfEmail.text, let password = tfPassword.text{
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil{
                        //Creating UIAlertController and
                        //  alert user that username or pass is not in DB
                        let alertController = UIAlertController(
                            title: "UNREGISTERED ACCOUNT",
                            message: "this account is not registered in our system\nemailaddress: \(email)",
                            preferredStyle: .alert)
                        
                        //the cancel action doing nothing
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
                        }
                
                        alertController.addAction(cancelAction)
                        
                        //finally presenting the dialog box
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else {
                        self.performSegue(withIdentifier: "showTable", sender: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func doBtnSignup(_ sender: Any) {
        if let email = tfEmail.text, let password = tfPassword.text{
            Auth.auth().createUser(withEmail: email, password: password, completion:  { (user, error) in
                if error == nil{
                    self.performSegue(withIdentifier: "showTable", sender: nil)
                }
                else{
                    //Creating UIAlertController and
                    //  alert user that username or pass is not in DB
                    let alertController = UIAlertController(
                        title: "INVALID INFO",
                        message: "Email and/or Password is invalid",
                        preferredStyle: .alert)
                    
                    //the cancel action doing nothing
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
                    }
                    
                    alertController.addAction(cancelAction)
                    
                    //finally presenting the dialog box
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
