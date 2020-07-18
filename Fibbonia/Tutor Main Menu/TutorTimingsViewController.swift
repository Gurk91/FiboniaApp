//
//  TutorTimingsViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 18/Jul/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class TutorTimingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUp()
    }
    
    //MARK: All button outlets
    
    @IBOutlet var timeButtons: [UIButton]!
    @IBOutlet weak var saveButton: UIButton!
    
    
    func setUp() {
        for button in self.timeButtons {
            button.layer.cornerRadius = button.frame.height / 4
            button.tintColor = UIColor.white
        }
        Utils.styleFilledButton(saveButton)
    }
    

}
