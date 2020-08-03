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
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var displayImage: UIImageView!
    
    
    func setVals(input: [String: Any]) {
        nameLabel.text! = input["tutorFN"] as! String
        
        //Converts time display to local time
        let importedTime = input["time"] as! String
        let timecomps = importedTime.components(separatedBy: " ")
        let date = timecomps[0] + " " + timecomps[1] + " " + timecomps[2]
        let timings = timecomps[3..<timecomps.count]
        var finalTimes = ""
        let timedifference = Utils.getUTCTimeDifference()
        for time in timings {
            let converted = Utils.convertToLocalTime(timeDifference: timedifference, time: Int(time)!)
            finalTimes = finalTimes + String(converted) + " "
        }
        timeLabel.text! = date + " " + finalTimes
        classLabel.text! = input["classname"] as! String
        
        let subject = classLabel.text!.components(separatedBy: " ")[0]
        if subject == "COMPSCI" {
            displayImage.image = UIImage(named: "COMPSCI")
        }
        else if subject == "CHEM" {
            displayImage.image = UIImage(named: "CHEM")
        }
        else if subject == "ECON" {
            displayImage.image = UIImage(named: "ECON")
        }
        else if subject == "MATH" {
            displayImage.image = UIImage(named: "MATH")
        }
        else if subject == "PHYSICS" {
            displayImage.image = UIImage(named: "PHYSICS")
        }
        else if subject == "BIOLOGY" {
            displayImage.image = UIImage(named: "BIOLOGY")
        } else {
            displayImage.image = UIImage(named: "OTHER")
        }
        
    }

}
