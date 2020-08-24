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
        
        self.hideKeyboardWhenTappedAround()
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
                let user = Auth.auth().currentUser
                user?.reload(completion: { (error) in
                    switch user!.isEmailVerified {
                    case true:
                        self.showSpinner(onView: self.view)
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
                                    currStudent = Student(fn: name!, ln: ln!, eml: email, appt: documentData!["appointments"] as! [[String : Any]], subjects: subjects as! [String], stripeID: documentData!["stripe_id"] as! String, accntType: documentData!["accntType"] as! String, firstlogin: false)
                                    currStripe = currStudent.stripeID
                                    currStudent.tutor = documentData!["tutor"] as! Bool
                                    currStudent.calEmail = documentData!["calEmail"] as! String
                                    
                                    Utils.reloadAppointments()
                                    
                                    self.removeSpinner()
                                    print("entering bar sequence")
                                    
                                    let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarCont)
                                    self.view.window?.rootViewController = tabBarController
                                    self.view.window?.makeKeyAndVisible()
                                    
                                }
                            } else {
                                self.createAlert(title: "Error Logging In", message: error!.localizedDescription, buttonMsg: "Okay")
                                return
                            }
                        }
                    case false:
                        self.errorTextDisplay.text = "Unverified User. Please verify your email first."
                        self.errorTextDisplay.alpha = 1
                        return
                    }
                })
            
            }
        }
        
        
    }
    
    func handleError(error: Error) {
        
        // the user is not registered
        // user not found
        
        let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
        switch errorAuthStatus {
        case .wrongPassword:
            print("wrongPassword")
        case .invalidEmail:
            print("invalidEmail")
        case .operationNotAllowed:
            print("operationNotAllowed")
        case .userDisabled:
            print("userDisabled")
        case .userNotFound:
            print("userNotFound")
        case .tooManyRequests:
            print("tooManyRequests, oooops")
        default: fatalError("error not supported here")
        }
        
    }
    
    func setUpElements() {
        errorTextDisplay.alpha = 0
        
        Utils.styleTextField(emailField)
        Utils.styleTextField(passwordField)
        
        Utils.styleFilledButton(loginButton)
        Utils.styleHollowButton(backButton)
    }
    
    func createAlert(title: String, message: String, buttonMsg: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMsg, style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }

    

}
