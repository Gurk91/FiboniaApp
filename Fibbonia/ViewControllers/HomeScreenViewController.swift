  //
//  HomeScreenViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 16/Mar/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(currName)
        labelText.text = "Welcome – " + currName
    }
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBAction func signOutButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you wish to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
        do {
            try Auth.auth().signOut()
            let viewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
            self.view.window?.rootViewController = viewController
            self.view.window?.makeKeyAndVisible()
            
        } catch let error {
            print("sign out failed", error)
            let alert = UIAlertController(title: "Hmm Something's wrong", message: "Error Signing out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        currName = ""
        
    }
    
    
    
    
}
