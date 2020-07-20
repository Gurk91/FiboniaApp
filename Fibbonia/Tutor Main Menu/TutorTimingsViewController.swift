//
//  TutorTimingsViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 18/Jul/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class TutorTimingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUp()
    }
    
    var data = ["0": [Int](), "1": [Int](), "2": [Int](), "3": [Int](), "4": [Int](), "5": [Int](),"6": [Int]()] //currTutor.prefTime
    var selectedDay = "0"
    
    //MARK: Outlets
    
    @IBOutlet var timeButtons: [UIButton]!
    @IBOutlet weak var saveButton: UIButton!
    
    func setUp() {
        
        for button in self.timeButtons {
            button.layer.cornerRadius = button.frame.height / 4
            button.tintColor = UIColor.white
        }
        let UTCtimes = currTutor.prefTime
        for day in UTCtimes {
            var converted = [Int]()
            for time in day.value {
                let localTime = Utils.convertToLocalTime(timeDifference: Utils.getUTCTimeDifference(), time: time)
                converted.append(localTime)
                self.data[day.key]!.append(localTime)
            }
            selectButtons(times: converted)
        }
        
        Utils.styleFilledButton(saveButton)
    }
    
    @IBAction func timingSelected(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.lightGray
        data[self.selectedDay]!.append(sender.tag)
    }
    
   
    @IBAction func dayPicker(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            self.selectedDay = String(sender.selectedSegmentIndex)
            selectButtons(times: self.data[self.selectedDay]!)
        case 1:
            self.selectedDay = String(sender.selectedSegmentIndex)
            selectButtons(times: self.data[self.selectedDay]!)
        case 2:
            self.selectedDay = String(sender.selectedSegmentIndex)
            selectButtons(times: self.data[self.selectedDay]!)
        case 3:
            self.selectedDay = String(sender.selectedSegmentIndex)
            selectButtons(times: self.data[self.selectedDay]!)
        case 4:
            self.selectedDay = String(sender.selectedSegmentIndex)
            selectButtons(times: self.data[self.selectedDay]!)
        case 5:
            self.selectedDay = String(sender.selectedSegmentIndex)
            selectButtons(times: self.data[self.selectedDay]!)
        case 6:
            self.selectedDay = String(sender.selectedSegmentIndex)
            selectButtons(times: self.data[self.selectedDay]!)
        default:
            self.selectedDay = "0"
            setUp()
            
        }
    }
    
    func selectButtons(times: [Int]) {
        for button in self.timeButtons{
            if times.contains(button.tag) {
                button.backgroundColor = UIColor.lightGray
            } else {
                button.backgroundColor = UIColor.init(red: 84/255, green: 199/255, blue: 252/255, alpha: 1)
            }
            if button.tag == -1 && times.contains(-1) != true {
                button.backgroundColor = UIColor.red
            }
        }
        
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        //Converting to UTC time and sending to Firebase
        let timeDifference = Utils.getUTCTimeDifference()
        
        var finalTimes = ["0": [Int](), "1": [Int](), "2": [Int](), "3": [Int](), "4": [Int](), "5": [Int](),"6": [Int]()]
        for day in self.data {
            var dayArr = [Int]()
            for time in day.value {
                let finalTime = Utils.convertTime(timeDifference: timeDifference, time: time)
                dayArr.append(finalTime)
                //print(time, "–––", finalTime)
            }
            
            finalTimes[day.key] = dayArr
        }
        let db = Firestore.firestore()
        let docRef = db.collection("tutors").document(currTutorEmail)
        docRef.setData(["prefTime": finalTimes], merge: true)
        currTutor.prefTime = finalTimes
         
    }
    
}
