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
        //Utils.organizeSubjects()
        //Utils.organizeClasses()
        Utils.createCustomer()
    }

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorTextDisplay: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBAction func backPressed(_ sender: UIButton) {
        //sender.pulsate()
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        //(sender as! UIButton).pulsate()
        
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
                            let subjects = documentData!["subjects"] //as! [String]
                            currName = name! + " " + ln!
                            print(currName)
                            currEmail = email
                            
                            if documentData!["appointments"] == nil || documentData!["tutor"] == nil {
                                //let dummy = Appointment(tutorEmail: "anemail@email.com", name: "RandDude", time: Date(), location: "Home", className: "CS61A", notes: "dummy node", studentName: currName, selfEmail: currEmail, uid: "", timezone: "UTC")
                                //let entryVal = dummy.toDict()
                                docRef.setData(["appointments":[], "tutor": false], merge:true)
                                currStudent = Student(fn: name!, ln: ln!, eml: email, appt: [], subjects: subjects as! [String], setPrefs: false, preferences: ["languages":"", "tutorPricing":[0, 0], "educationLvl":"", "location": [false, false, false, false]], stripeID: currStripe, google: false, facebook: false)
                                
                            }
                            if documentData!["setPrefs"] == nil {
                                docRef.setData(["setPrefs": false, "preferences": ["languages":"", "tutorPricing":[0, 0], "eductionLvl":"", "location": [false, false, false, false]]], merge:true)
                                currStudent = Student(fn: name!, ln: ln!, eml: email, appt: documentData!["appointments"] as! [[String : Any]], subjects: subjects as! [String], setPrefs: false, preferences: ["languages":"", "tutorPricing":[0, 0], "eductionLvl":"", "location": [false, false, false, false]], stripeID: currStripe, google: false, facebook: false)
                            }
                                
                            if documentData!["stripe_id"] == nil {
                                docRef.setData(["stripe_id": currStripe], merge: true)
                                
                            }
                        
                            else {
                                currStudent = Student(fn: name!, ln: ln!, eml: email, appt: documentData!["appointments"] as! [[String : Any]], subjects: subjects as! [String], setPrefs: documentData!["setPrefs"] as! Bool, preferences: documentData!["preferences"] as! [String : Any], stripeID: documentData!["stripe_id"] as! String, google: false, facebook: false)
                                currStripe = currStudent.stripeID
                                //print("set student")
                                //print(currStudent)
                            }
                            
                            /*
                            let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeScreenViewController
                                
                            self.view.window?.rootViewController = homeViewController
                            self.view.window?.makeKeyAndVisible()
                            */
                            
                            print("entering bar sequence")
                            print(currStudent.setPrefs)
                            
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
