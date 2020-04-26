//
//  TutorProfileViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 25/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class TutorProfileViewController: UIViewController {

    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var GPAField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var gradYearField: UITextField!
    
    @IBOutlet weak var saveInfoButton: UIButton!
    @IBOutlet weak var studentViewButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    @IBAction func studentViewPressed(_ sender: Any) {
        print("entering student view")
        
        let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarCont)
        self.view.window?.rootViewController = tabBarController
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        signOutNCreateAlert(title: "Sign Out", message: "Are you sure you want to sign out?")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
    }
    
    func setUp() {
        Utils.styleHollowButton(signOutButton)
        Utils.styleFilledButton(studentViewButton)
        Utils.styleHollowButton(saveInfoButton)
        
        Utils.styleTextField(phoneNumber)
        Utils.styleTextField(GPAField)
        Utils.styleTextField(majorField)
        Utils.styleTextField(gradYearField)
    }
    
    func signOutNCreateAlert(title: String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action) in
            do {
                try Auth.auth().signOut()
                print("signed out")
                currName = ""
                print()
                let viewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
                self.present(viewController!, animated: true, completion: nil)
                //self.view.window?.rootViewController = viewController
                //self.view.window?.makeKeyAndVisible()
                
            } catch let error {
                print("sign out failed", error)
                let alt = UIAlertController(title: "Hmm Something's wrong", message: "Error Signing out", preferredStyle: .alert)
                alt.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    
    }
    
    


}
