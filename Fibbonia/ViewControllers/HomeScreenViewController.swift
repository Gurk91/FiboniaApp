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
    }
    
    /*
    @IBAction func signOutTapped(_ sender: Any) {
        do
        {
            try Auth.auth().signOut()
            currName = ""
            
            let viewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.ViewController) as? ViewController
            self.view.window?.rootViewController = viewController
            self.view.window?.makeKeyAndVisible()
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
            print("could not sign out well")
        }
        
    }
   */
    
    
}
