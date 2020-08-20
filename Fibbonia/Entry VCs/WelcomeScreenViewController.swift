//
//  WelcomeScreenViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 19/Aug/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class WelcomeScreenViewController: UIViewController {
    
    @IBOutlet weak var homeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utils.styleFilledButton(homeButton)
    }
    

}
