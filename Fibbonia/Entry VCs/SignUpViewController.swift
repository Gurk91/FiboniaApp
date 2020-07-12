//
//  SignUpViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 16/Mar/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        Utils.organizeSubjects()
        Utils.organizeClasses()
        Utils.createCustomer()
    }

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorTextDisplay: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    //@IBOutlet weak var backButton: UIButton!
    
    //check fields and validate that the data is correct. if evrything is correct, this method returns nil. Otherwise it returns the error message
    func validateFields() -> String? {
        
        //check if all fields are filled in
        if firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        
        //check if password is correct: tutorial time 52:46 (optional)
        let cleanedPassword = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utils.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //validate the fields
        let error = validateFields()
        if error != nil {
            errorTextDisplay.text = error!
            errorTextDisplay.alpha = 1
        } else {
            //make data accessible
            let firstname = self.firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = self.lastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = self.emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = self.passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //create the user
            let db = Firestore.firestore()
            
            //checking if the user already exists or if email is being reused
            let docRef = db.collection("users").document(email)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    print("user exists")
                    self.errorTextDisplay.text = "User Exists"
                    self.errorTextDisplay.alpha = 1
                } else {
                    //user is new. Proceed with sign up
                    print("Proceed with signup")
                    Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                        //check for errors
                        if err != nil {
                            //there is an error
                            self.errorTextDisplay.text = "Error creating user"
                            self.errorTextDisplay.alpha = 1
                        } else {
                            //user created. now store first and last name
                            //let dummy = Appointment(tutorEmail: "anemail@email.com", name: "RandDude", time: Date(), location: "Home", className: "CS61A", notes: "dummy node", studentName: "dude", selfEmail: email)
                            //let entryVal = dummy.toDict()
                            db.collection("users").document(email).setData(["firstName":firstname, "lastName":lastname, "uid":result!.user.uid, "email":email, "appointments":[], "tutor": false, "address": "", "city": "", "calEmail": "", "state": "", "zip": "", "subjects": [], "setPrefs": false, "preferences": ["languages":"", "tutorPricing":[0, 0], "eductionLvl":"", "location": [false, false, false, false]], "stripe_id": currStripe]) { (error) in
                                if error != nil {
                                    self.errorTextDisplay.text = "First and Last Name not saved"
                                    self.errorTextDisplay.alpha = 1
                                }
                            }
                            currStudent = Student(fn: firstname, ln: lastname, eml: email, appt: [], subjects: [], setPrefs: false, preferences: ["languages":"", "tutorPricing":[0, 0], "eductionLvl":"", "location": [false, false, false, false]], stripeID: currStripe, google: false, facebook: false)
                            //set current user name
                            currName = firstname
                            currEmail = email
                            //transition to home screen
                            self.transitionToHome()
                        }
                    }
                }
            }
        }
    }
    
    func transitionToHome() {
        
        print("entering bar sequence")
        
        let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarCont)
        self.view.window?.rootViewController = tabBarController
        self.view.window?.makeKeyAndVisible()
    }
    
    func setUpElements() {
        errorTextDisplay.alpha = 0
        
        Utils.styleTextField(firstNameField)
        Utils.styleTextField(lastNameField)
        Utils.styleTextField(emailField)
        Utils.styleTextField(passwordField)
        
        Utils.styleFilledButton(signUpButton)
        //Utils.styleHollowButton(backButton)
    }
    

}
