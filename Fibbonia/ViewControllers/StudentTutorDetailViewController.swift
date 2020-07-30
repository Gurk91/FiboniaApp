//
//  StudentTutorDetailViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 1/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

//NOTE: Button tags are in UTC, so remember to convert them for display, but not when writing to DB

import UIKit
import Firebase

class StudentTutorDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setTerms()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBOutlet weak var dayPicker: UIPickerView!
    
    @IBOutlet var timeButtons: [UIButton]!
    
    @IBOutlet weak var appointmentButton: UIButton!
    
    @IBOutlet weak var tutorName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var apptNotes: UITextField!
    @IBOutlet weak var groupTutoringBool: UISwitch!
    
    
    var currentValue: Constants.tutorField = Constants.tutorField(name: "", rating: 0, price: "", zoom: "", calEmail: "", prefTime: ["0": [Int](), "1":[Int](), "2":[Int](), "3":[Int](), "4":[Int](), "5":[Int](), "6":[Int]()], appointments: [["ABC":"DEF"]], bio: "", classes: [])
    var subject: String = ""
    var dayData: [String] = Constants.nextDates
    let dayDict: [String: String] = ["Monday": "0", "Tuesday": "1", "Wednesday": "2", "Thursday":"3", "Friday": "4", "Saturday": "5", "Sunday": "6"]
    
    var selectedDate: String = ""
    var selectedDay: String = ""
    var dayNumber: String = ""
    var pickedTime: Int = 0
    var groupTutoring: Bool = false
    var selectedTimes: [Int] = []

    //MARK: DayPicker stubs
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dayData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dayData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDate = dayData[row]
        let list = selectedDate.components(separatedBy: " ")
        selectedDay = list[0]
        print(selectedDate, selectedDay)
        timeButtonsSetup()
    }
    
    //MARK: Everything else
    func setTerms() {
        tutorName.text! = currentValue.name
        priceLabel.text! = currentValue.price
        ratingLabel.text! = String(currentValue.rating)
    }
    
    
    @IBAction func timeButtonPressed(_ sender: UIButton) {
        
        if sender.backgroundColor == UIColor.lightGray {
            sender.backgroundColor = UIColor.init(red: 0/255, green: 45/255, blue: 95/255, alpha: 1)
            selectedTimes = removeFromArray(arr: selectedTimes, obj: sender.tag)
            sender.titleLabel?.textColor = UIColor.white
        } else {
            sender.backgroundColor = UIColor.lightGray
            sender.titleLabel?.textColor = UIColor.black
            selectedTimes.append(sender.tag)
        }
        
    }
    
    
    @IBAction func tutoringSwitch(_ sender: UISwitch) {
        groupTutoring = sender.isOn
    }
    
    
    @IBAction func appointmentPressed(_ sender: Any) {
        //prepare the times from selectedTimes array
        var hoursTime = ""
        for time in selectedTimes {
            let currTime = String(time)
            if hoursTime.count == 0{
                hoursTime = currTime
            } else {
                hoursTime = hoursTime + " " + currTime
            }
        }
        
        let time = selectedDate + " " + hoursTime
        let notes = apptNotes.text!
        let group = groupTutoring
        let classname = pickedClass
        let tutorFN = currentValue.name
        let tutorEmail = currentValue.calEmail
        let uid = UUID().uuidString
        let uniqid = Utils.char50UID()
        let timeComps = Date().description.components(separatedBy: " ")
        let timeCreated = timeComps[0] + " " + timeComps[1]
        let appt = ["classname":classname, "notes": notes, "studentEmail": currStudent.email, "studentName": currStudent.firstName + " " + currStudent.lastName, "subject": subject, "time": time, "tutorEmail": tutorEmail, "rated": false, "group_tutoring": group, "uniqid": uniqid, "tutorFN": tutorFN, "tutor_read": false, "student_read": true, "txn_id": "", "uid": uid, "timeCreated":timeCreated] as [String : Any]
        currStudent.appointments.append(appt)
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currStudent.email)
        docRef.setData(["appointments": currStudent.appointments], merge: true) {(error) in
            if error != nil {
                Utils.createAlert(title: "Error Creating Appointment", message: "There was an error creating your appointment. Please try again later", buttonMsg: "Okay", viewController: self)
            }
        }
        currentValue.appointments.append(appt)
        let docRefTut = db.collection("tutors").document(tutorEmail)
        docRefTut.setData(["appointments": currentValue.appointments], merge: true)
        //Updates the appts array for every class this tutor teached :(
        
    }
    
    //MARK: Sets up the buttons according to available times for one-on-one and group tutoring
    func timeButtonsSetup() {
        var availableTimes: [Int] = []
        var groupTutoringTimes: [Int] = []
        if selectedDay != "" {
            dayNumber = dayDict[selectedDay]!
            availableTimes = currentValue.prefTime[dayNumber]!
            
            if currentValue.appointments.count > 0 {
                
                for appt in currentValue.appointments {
                    let apptTime = appt["time"] as! String
                    let apptTimeComps = apptTime.components(separatedBy: " ")
                    let apptDate = apptTimeComps[0] + " " + apptTimeComps[1] + " " + apptTimeComps[2]
                    if apptDate == selectedDate {
                        if appt["group_tutoring"] as! Bool == true {
                            
                            //Next 3 lines seperate the times from the existing appt
                            let goodTimes = apptTimeComps[3..<apptTimeComps.count]
                            var result: [Int] = []
                            for time in goodTimes {
                                result.append(Int(time)!)
                            }
                            //Adding those times to the list of group tutoring times
                            groupTutoringTimes = groupTutoringTimes + result
                        } else {
                            //Next 3 lines seperate the times from the existing appt
                            let goodTimes = apptTimeComps[3..<apptTimeComps.count]
                            var result: [Int] = []
                            for time in goodTimes {
                                result.append(Int(time)!)
                            }
                            //removing the above times form availableTimes
                            for i in 0..<availableTimes.count {
                                if result.contains(availableTimes[i]) {
                                    availableTimes = removeFromArray(arr: availableTimes, obj: availableTimes[i])
                                }
                            }
                        }
                    }
                }
            }
                        
            if availableTimes.count == 0 {
                Utils.createAlert(title: "No Available Times", message: "There are no available times for this tutor on this date. Please try another date", buttonMsg: "Okay", viewController: self)
                return
            } else {
                var index = 0
                //Handles one-on-one availabilities
                while index < availableTimes.count {
                    let button = self.timeButtons[index]
                    let timeDifference = Utils.getUTCTimeDifference()
                    let displayTime = Utils.convertToLocalTime(timeDifference: timeDifference, time: availableTimes[index])
                    
                    button.titleLabel?.text = String(displayTime)
                    button.isHidden = false
                    button.layer.cornerRadius = button.frame.height / 2
                    button.tag = availableTimes[index]
                    index += 1
                }
                //Handles group tutoring availabilities
                var group = 0
                while index < timeButtons.count && group < groupTutoringTimes.count {
                    let button = self.timeButtons[index]
                    let timeDifference = Utils.getUTCTimeDifference()
                    let displayTime = Utils.convertToLocalTime(timeDifference: timeDifference, time: groupTutoringTimes[group])
                    
                    button.titleLabel?.text = String(displayTime)
                    button.isHidden = false
                    button.layer.cornerRadius = button.frame.height / 2
                    button.backgroundColor = UIColor.orange
                    button.tag = groupTutoringTimes[group]
                    index += 1
                    group += 1
                }
            }
            
        } else {
            Utils.createAlert(title: "No Available Times", message: "There are no available times for this tutor on this date. Please try another date", buttonMsg: "Okay", viewController: self)
            return
        }
        
    }
    
    func setUp() {
        Utils.styleFilledButton(appointmentButton)
        
        profileImg.backgroundColor = UIColor.white
        profileImg.layer.borderWidth = 1
        profileImg.layer.masksToBounds = false
        profileImg.clipsToBounds = true
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.layer.borderColor = UIColor.gray.cgColor
        
        for button in self.timeButtons {
            button.isHidden = true
        }
        
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
