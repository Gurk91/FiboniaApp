//
//  OptionsViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 12/Jul/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class OptionsViewController: UIViewController, GIDSignInDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.styleFilledButton(emailButton)
        Utils.styleHollowButton(backButton)
        errorTextDisplay.alpha = 0
    
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    @IBOutlet weak var googleButton: GIDSignInButton!
    @IBOutlet weak var facebookButton: FBLoginButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var errorTextDisplay: UILabel!
    
    
    
    @IBAction func googlePressed(_ sender: Any) {
        
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
            //Successful user sign-up
            print("Successfully logged into Firebase with Google")
            let Myuser = Auth.auth().currentUser
            var email = ""
            if let Myuser = Myuser {
                email = Myuser.email!
            }
            //Checking if user already exists
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(email)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    self.errorTextDisplay.text = "User Exists"
                    self.errorTextDisplay.alpha = 1
                    return
                }
            }
            let firstname = user.profile.givenName!
            let lastname = user.profile.familyName!
            let uid = user.userID!
            
            db.collection("users").document(email).setData(["firstName":firstname, "lastName":lastname, "uid":uid, "email":email, "appointments":[], "tutor": false, "calEmail": "", "subjects": [], "stripe_id": currStripe, "accntType": "google", "newsletter": false, "update_classes": [], "firstlogin":false, "img": "https://www.work.fibonia.com/1/html/img.png"]) { (error) in
                if error != nil {
                    self.errorTextDisplay.text = "First and Last Name not saved"
                    self.errorTextDisplay.alpha = 1
                }
            }
            currStudent = Student(fn: firstname, ln: lastname, eml: email, appt: [], subjects: [], stripeID: currStripe, accntType: "google", firstlogin: true)
                
                //Student(fn: firstname, ln: lastname, eml: email, appt: [], subjects: [], setPrefs: false, preferences: ["languages":"", "tutorPricing":[0, 0], "educationLvl":"", "location": [false, false, false, false]], stripeID: currStripe, google: true, facebook: false)
            //set current user name
            currName = firstname
            currEmail = email
            
            print("entering bar sequence")
            
            let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarCont)
            self.view.window?.rootViewController = tabBarController
            self.view.window?.makeKeyAndVisible()
        }
    }

}
