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
        setUpElements()
    }
    
    func setUpElements() {
        Utils.styleFilledButton(signUpButton)
        Utils.styleFilledButton(loginButton)
    }
    
}




