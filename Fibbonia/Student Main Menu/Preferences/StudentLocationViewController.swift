//
//  StudentLocationViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 16/Jun/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class StudentLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var online: UISwitch!
    @IBOutlet weak var travelling: UISwitch!
    @IBOutlet weak var hostHome: UISwitch!
    @IBOutlet weak var groupTutoring: UISwitch!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func savePressed(_ sender: Any) {
        if online.isOn {
            online.setOn(true, animated: false)
        }
        if travelling.isOn{
            travelling.setOn(true, animated: false)
        }
    }
    
    
    
    

}
