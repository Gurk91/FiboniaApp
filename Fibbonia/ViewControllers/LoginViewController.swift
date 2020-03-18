//
//  LoginViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 16/Mar/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

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
        
    }
    
    func setUpElements() {
        errorTextDisplay.alpha = 0
        
        Utils.styleTextField(emailField)
        Utils.styleTextField(passwordField)
        
        Utils.styleFilledButton(loginButton)
        Utils.styleHollowButton(backButton)
    }
    

}
