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
        self.hideKeyboardWhenTappedAround() 
        
    }

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorTextDisplay: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backbutton: UIButton!
    
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
        let cleanedFirstName = firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utils.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        if Utils.validFirstName(name: cleanedFirstName) == false {
            //First Name isn't valid
            return "Please enter an actual, valid name"
        }
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //validate the fields
        self.showSpinner(onView: view)
        let error = validateFields()
        if error != nil {
            errorTextDisplay.text = error!
            errorTextDisplay.alpha = 1
            self.removeSpinner()
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
                    //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("user exists")
                    self.errorTextDisplay.text = "User Exists"
                    self.errorTextDisplay.alpha = 1
                    self.removeSpinner()
                    return
                } else {
                    //user is new. Proceed with sign up
                    print("Proceed with signup")
                    Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                        //check for errors
                        if err != nil {
                            //there is an error
                            self.errorTextDisplay.text = "Error creating user"
                            self.errorTextDisplay.alpha = 1
                            self.removeSpinner()
                            return
                        } else {
                            //user created. now store first and last name
                            //Time to verify email
                            let user = Auth.auth().currentUser
                            user?.reload(completion: { (error) in
                                switch user!.isEmailVerified {
                                case true:
                                    print("users email is verified")
                                    self.errorTextDisplay.text = "User Already Exists"
                                    self.errorTextDisplay.alpha = 1
                                    self.removeSpinner()
                                    return
                                case false:
                                    
                                    user!.sendEmailVerification { (error) in
                                        print("sent verification email")
                                        
                                        guard let error = error else {
                                            print("user email verification sent")
                                            let uid = result?.user.uid
                                            db.collection("users").document(email).setData(["firstName":firstname, "lastName":lastname, "uid":uid!, "email":email, "appointments":[], "tutor": false, "calEmail": "", "subjects": [], "stripe_id": currStripe, "accntType": "email", "newsletter": false, "update_classes": [], "firstlogin":false, "img": "https://www.work.fibonia.com/1/html/img.png", "transactionHistory":[]]) { (error) in
                                                if error != nil {
                                                    self.errorTextDisplay.text = "First and Last Name not saved"
                                                    self.errorTextDisplay.alpha = 1
                                                }
                                            }
                                            currStudent = Student(fn: firstname, ln: lastname, eml: email, appt: [], subjects: [], stripeID: currStripe, accntType: "email", firstlogin: true)
                                            //set current user name
                                            currName = firstname
                                            currEmail = email
                                            //transition to home screen
                                            //self.transitionToHome()
                                            self.removeSpinner()
                                            
                                            self.performSegue(withIdentifier: "home", sender: nil)
                                            return 
                                        }
                                        self.removeSpinner()
                                        self.handleError(error: error)
                                    }
                                    
                                    print("verify it now")
                                }
                            })
                            
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "home" {
            _ = segue.destination as! WelcomeScreenViewController
        }
    }
    
    func transitionToHome() {
                
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
        Utils.styleHollowButton(backbutton)
    }
    
    func createAlert(title: String, message: String, buttonMsg: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMsg, style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
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
    

}

