//
//  LoginOptionsViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 12/Jul/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Firebase


class LoginOptionsViewController: UIViewController, GIDSignInDelegate {
    
    
    @IBOutlet weak var googleButton: GIDSignInButton!
    @IBOutlet weak var facebookButton: FBLoginButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var errorTextDisplay: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.styleFilledButton(emailButton)
        Utils.styleHollowButton(backButton)
        errorTextDisplay.alpha = 0
        
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log in to Google", err)
            self.errorTextDisplay.text = "Error logging user in"
            self.errorTextDisplay.alpha = 1
            return
        }
        print("Google log-in success")
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Failed to create a Firebase account for associated Google account", error)
                self.errorTextDisplay.text = "Failed to create a Firebase account for associated Google account"
                self.errorTextDisplay.alpha = 1
                return
            }
            //Successful user login
            print("Successfully logged into Firebase with Google")
            let Myuser = Auth.auth().currentUser
            var email = ""
            if let Myuser = Myuser {
                email = Myuser.email!
            }
            //Getting user data from firebase
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(email)
            docRef.getDocument { (document, error) in
                // Check for error
                if document?.exists == false {
                    self.errorTextDisplay.text = "Account doesn't exist. Please sign-up for a new account"
                    self.errorTextDisplay.alpha = 1
                    return
                }
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
