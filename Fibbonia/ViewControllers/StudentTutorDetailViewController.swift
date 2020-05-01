//
//  StudentTutorDetailViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 1/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class StudentTutorDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTerms()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBOutlet weak var tutorName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var gpalabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var currentValue: Constants.tutorField = Constants.tutorField(name: "", rating: "", price: "", GPA: "", onlineID: "", major: "", email: "", timings: "")

    func setTerms() {
        tutorName.text! = currentValue.name
        priceLabel.text! = currentValue.price
        gpalabel.text! = currentValue.GPA
        majorLabel.text! = currentValue.major
        timeLabel.text! = currentValue.timings
    }
}
