//
//  TutorSignUpViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 19/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class TutorSignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUp()
    }
    
    //Buttons
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var errorTextDisplay: UILabel!
    
    //Text Fields
    @IBOutlet weak var calEmailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var GPAField: UITextField!
    //@IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var gradYearField: UITextField!
    @IBOutlet weak var onlineID: UITextField!
    
    
    @IBAction func backPressed(_ sender: Any) {
        
        self.transitionToStudentHome()
    }
    
    
    func setUp() {
        errorTextDisplay.alpha = 0
        
        Utils.styleTextField(calEmailField)
        Utils.styleTextField(phoneNumberField)
        Utils.styleTextField(GPAField)
        //Utils.styleTextField(majorField)
        Utils.styleTextField(gradYearField)
        Utils.styleTextField(onlineID)
        
        Utils.styleFilledButton(signUpButton)
        Utils.styleHollowButton(backButton)
    }
    
    func transitionToStudentHome() {
        print("entering student home sequeence")
        
        let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarCont)
        self.view.window?.rootViewController = tabBarController
        self.view.window?.makeKeyAndVisible()
    }
    
    func validateFields() -> String? {
        
        if calEmailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || phoneNumberField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            GPAField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            //majorField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            gradYearField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            onlineID.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        if Utils.validCalEmail(email: calEmailField.text!) != true {
            return "Enter Valid Cal Email"
        }
        if Utils.validPhone(phone: phoneNumberField.text!) != true {
            return "Enter Valid Phone Number"
        }
        
        return nil
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        let errorText = validateFields()
        if errorText != nil {
            errorTextDisplay.text = errorText!
            errorTextDisplay.alpha = 1
        } else {
            //Reassigning fields
            let calEmail = self.calEmailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //let major = self.majorField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let gradYear = self.gradYearField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let online = self.onlineID.text!
            
            //Creating user
            let db = Firestore.firestore()
            let docref = db.collection("tutors").document(calEmail)
            docref.getDocument { (document, error) in
                //checking if tutor already exists
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    print("user exists")
                    self.errorTextDisplay.text = "User Exists"
                    self.errorTextDisplay.alpha = 1
                } else {
                    //user is new. Proceed with sign up
                    //user created. now store first and last name
                    
                    db.collection("tutors").document(calEmail).setData(["name": currName, "calEmail": calEmail, "gradyear": Int(gradYear)!, "subjects": [""], "phone": "", "zoom": "", "setPrefs": false, "preferences": ["languages": [], "location": []], "img": "", "firstlogin": true, "prefTime": ["0": [Int](), "1":[Int](), "2":[Int](), "3":[Int](), "4":[Int](), "5":[Int](), "6":[Int]()]]) { (error) in
                                                                            if error != nil {
                                                                            self.errorTextDisplay.text = "Tutor Not Created"
                                                                                self.errorTextDisplay.alpha = 1
                                                                            }
                    }
                    
                    //Attaching tutor profile to user profile
                    db.collection("users").document(currEmail).setData(["tutor": true, "calEmail": calEmail], merge: true)
                    //Transitioning to Tutor Home
                    currStudent.calEmail = calEmail
                    currStudent.tutor = true
                    //currTutor = Tutor(name: currName ,calEmail: calEmail, GPA:Double(gpa)!, gradYear: Int(gradYear)!, major: major, subjects: [""])
                    currTutor = Tutor(name: currName, calEmail: calEmail, gradyear: gradYear, subjects: [""], zoom: "", setPrefs: false, preferences: ["languages": [], "location": []], img: "", firstlogin: true, prefTime: ["0": [Int](), "1":[Int](), "2":[Int](), "3":[Int](), "4":[Int](), "5":[Int](), "6":[Int]()], educationLevel: "")
                    
                    currTutor.setOnline(ID: online)
                    let tutorTBC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tutorHomeVC)
                    self.view.window?.rootViewController = tutorTBC
                    self.view.window?.makeKeyAndVisible()
                    }
                }
            }
        }
       
    
}
        
    

