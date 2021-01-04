//
//  ForgotPasswordViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 5/Jan/21.
//  Copyright © 2021 Gurkarn Goindi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ForgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("good 1")
        Utils.styleTextField(emailField)
        Utils.styleHollowButton(backButton)
        Utils.styleFilledButton(getButton)
        print("good 2")

    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func forgotPassword(_ sender: Any) {
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            Utils.createAlert(title: "No Email Entered", message: "Please enter the email associated with your Fibonia accround", buttonMsg: "Okay", viewController: self)
        }
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                Utils.createAlert(title: "Error", message: "There was an error resetting your password. Please try again later.", buttonMsg: "Okay", viewController: self)
            } else {
                Utils.createAlert(title: "Password Reset!", message: "Check your email for a link to reset your password", buttonMsg: "Okay", viewController: self)
            }
        }
        
    }
    

}
