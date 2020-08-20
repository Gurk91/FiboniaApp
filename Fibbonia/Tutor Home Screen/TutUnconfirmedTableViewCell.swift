//
//  TutUnconfirmedTableViewCell.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 4/Aug/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

protocol TutUnconfirmedDelegate {
    func acceptAppointment(appointment: [String: Any])
    func rejectAppointment(appointment: [String: Any])
}

class TutUnconfirmedTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var delegate: TutUnconfirmedDelegate?
    var currentAppt: [String: Any] = ["":""]
    
    
    func setVals(input: [String: Any]) {
        currentAppt = input
        print(input["studentName"] as! String, "set name label UC")
        nameLabel.text! = input["studentName"] as! String
         
         //Converts time display to local time
        let importedTime = input["time"] as! String
        let timecomps = importedTime.components(separatedBy: " ")
        let date = timecomps[0] + " " + timecomps[1] + " " + timecomps[2]
        let timings = timecomps[3..<timecomps.count]
        var finalTimes = ""
        let timedifference = Utils.getUTCTimeDifference()
        for time in timings {
            let converted = Utils.convertToLocalTime(timeDifference: timedifference, time:Int(time)!)
            finalTimes = finalTimes + String(converted) + " "
        }
        timeLabel.text! = date + " " + finalTimes
        classLabel.text! = input["classname"] as! String
         
    }
    
    @IBAction func acceptPressed(_ sender: Any) {
        delegate?.acceptAppointment(appointment: currentAppt)
    }
    
    @IBAction func rejectPressed(_ sender: Any) {
        delegate?.rejectAppointment(appointment: currentAppt)
    }
    

}
