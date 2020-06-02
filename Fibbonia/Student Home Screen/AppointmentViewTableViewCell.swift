//
//  AppointmentViewTableViewCell.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 1/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class AppointmentViewTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    func setVals(input: [String: Any]) {
        nameLabel.text! = input["tutorFN"] as! String
        timeLabel.text! = input["time"] as! String
        print("cell looks great")
    }

}
