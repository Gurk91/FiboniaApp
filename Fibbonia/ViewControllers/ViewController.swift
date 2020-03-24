//
//  MainScreenViewController.swift
//  
//
//  Created by Gurkarn Goindi on 6/Mar/20.
//

import UIKit
import FirebaseUI
import FirebaseDatabase


class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //authenticateUser()
        setUpElements()
    }
    
    func setUpElements() {
        Utils.styleFilledButton(signUpButton)
        Utils.styleFilledButton(loginButton)
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeScreenViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        } else {
            return 
        }
    }
    
}




