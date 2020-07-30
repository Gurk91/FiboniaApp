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
    @IBOutlet weak var clearButton: UIButton!
    
    
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
        Utils.styleHollowDeleteButton(clearButton)
    }
    
    @IBAction func clearTimes(_ sender: Any) {
        self.data = ["0": [Int](), "1": [Int](), "2": [Int](), "3": [Int](), "4": [Int](), "5": [Int](),"6": [Int]()]
        let db = Firestore.firestore()
        let docRef = db.collection("tutors").document(currTutorEmail)
        docRef.setData(["prefTime": self.data], merge: true)
        currTutor.prefTime = self.data
        
        for button in self.timeButtons{
            if button.tag == -1 {
                button.backgroundColor = UIColor.red
            } else {
                button.backgroundColor = UIColor.systemTeal
            }
        }
    }
    
    @IBAction func timingSelected(_ sender: UIButton) {
        
        if sender.tag == -1 {
            data[self.selectedDay]! = [Int]()
            selectButtons(times: [])
            sender.backgroundColor = UIColor.lightGray
        } else if sender.backgroundColor == UIColor.lightGray {
            sender.backgroundColor = UIColor.systemTeal
            data[self.selectedDay]! = removeFromArray(arr: data[self.selectedDay]!, obj: sender.tag)
        } else if data[self.selectedDay]!.count < 5 {
            sender.backgroundColor = UIColor.lightGray
            data[self.selectedDay]!.append(sender.tag)
        } else if (data[self.selectedDay]?.contains(sender.tag + 30))! || (data[self.selectedDay]?.contains(sender.tag - 30))! {
            Utils.createAlert(title: "Can't select adjacent times", message: "You may not select times that are adjacent to one another as each time represents a 1 hour time-slot", buttonMsg: "Okay", viewController: self)
            return
        }
        else {
            Utils.createAlert(title: "Max Times Selected", message: "You may not select more than 5 preferred times for each day", buttonMsg: "Okay", viewController: self)
            return
        }
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
                button.backgroundColor = UIColor.systemTeal
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
        
        print(finalTimes)
        let db = Firestore.firestore()
        let docRef = db.collection("tutors").document(currTutorEmail)
        print("docref 1")
        docRef.setData(["prefTime": finalTimes], merge: true)
        print("docref 2")
        currTutor.prefTime = finalTimes
        currTutor.setPrefs = true
        docRef.setData(["setPrefs": true], merge: true)
        print("docref 3")
         
    }
    
    func removeFromArray(arr: [Int], obj: Int) -> [Int] {
        var array = arr
        for i in 0..<arr.count {
            if array[i] == obj {
                array.remove(at: i)
                return array
            }
        }
        return array
    }
    
}
