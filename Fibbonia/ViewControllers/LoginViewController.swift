//
//  LoginViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 16/Mar/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import CoreData

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorTextDisplay: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func loginTapped(_ sender: Any) {
        //validate text fields
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorTextDisplay.text = error!.localizedDescription
                self.errorTextDisplay.alpha = 1
            }
            else {
                let db = Firestore.firestore()
                let docRef = db.collection("users").document(email)
                docRef.getDocument { (document, error) in
                    // Check for error
                    if error == nil {
                        // Check that this document exists
                        if document != nil && document!.exists {
                            let documentData = document!.data()
                            print("************ PRINTING DOC VALS ************")
                            let name = documentData!["firstName"] as Any? as? String
                            let ln = documentData!["lastName"] as Any? as? String
                            currName = name! + " " + ln!
                            print(currName)
                            currEmail = email
                            if documentData!["appointments"] == nil || documentData!["tutor"] == nil {
                                let dummy = Appointment(tutorEmail: "anemail@email.com", name: "RandDude", time: Date(), location: "Home", className: "CS61A", notes: "dummy node")
                                let entryVal = dummy.toDict()
                                docRef.setData(["appointments":[entryVal], "tutor": false], merge:true)
                                currStudent = Student(fn: name!, ln: ln!, eml: email, appt: [entryVal])
                            }
                            
                            /*
                            let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeScreenViewController
                                
                            self.view.window?.rootViewController = homeViewController
                            self.view.window?.makeKeyAndVisible()
                            */
                            
                            print("entering bar sequence")
                            
                            let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarCont)
                            self.view.window?.rootViewController = tabBarController
                            self.view.window?.makeKeyAndVisible()
                            
                        }
                    }
                }
            
            
            
            
            }
        }
        
        
    }
    
    func setUpElements() {
        errorTextDisplay.alpha = 0
        
        Utils.styleTextField(emailField)
        Utils.styleTextField(passwordField)
        
        Utils.styleFilledButton(loginButton)
        Utils.styleHollowButton(backButton)
    }
    

}
