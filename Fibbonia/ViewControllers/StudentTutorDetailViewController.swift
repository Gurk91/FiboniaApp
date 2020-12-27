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
        dayPicker.delegate = self
        dayPicker.dataSource = self
        setTerms()
        setUp()
        self.hideKeyboardWhenTappedAround() 
        
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
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var apptNotes: UITextField!
    @IBOutlet weak var groupTutoringBool: UISwitch!
    
    
    var currentValue: Constants.tutorField = Constants.tutorField(name: "", rating: 0, price: 0, zoom: "", calEmail: "", prefTime: ["0": [Int](), "1":[Int](), "2":[Int](), "3":[Int](), "4":[Int](), "5":[Int](), "6":[Int]()], appointments: [["ABC":"DEF"]], bio: "", classes: [])
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
        print(selectedDate)
        timeButtonsSetup()
        pickedTime = 0
        selectedTimes = []
    }
    
    //MARK: Everything else
    func setTerms() {
        tutorName.text! = currentValue.name
        priceLabel.text! = String(currentValue.price)
        ratingLabel.text! = String(currentValue.rating)
        bioLabel.text! = currentValue.bio
        
        let db = Firestore.firestore()
        db.collection("tutors").document(currentValue.calEmail).getDocument { (document, error) in
            if error != nil {
                Utils.createAlert(title: "Error", message: "There was an error loading this tutor. Please try again", buttonMsg: "Okay", viewController: self)
                print(error.debugDescription)
            }
            if document != nil && document!.exists {
                let documentData = document!.data()
                tempSubjects = documentData!["classes"] as! [String]
                print("tutor classes pulled")
            }
        }
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
        if selectedTimes.count == 0 {
            Utils.createAlert(title: "No Time Picked", message: "Please pick a time before you can create this appointment", buttonMsg: "Okay", viewController: self)
            return
        }
        else if apptNotes.text! == "" {
            Utils.createAlert(title: "No Notes Added", message: "Please add some notes to let your tutor know how to help you best", buttonMsg: "Okay", viewController: self)
            return
        }
        
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
        let appt = ["classname":classname, "notes": notes, "studentEmail": currStudent.email, "studentName": currStudent.firstName + " " + currStudent.lastName, "subject": subject, "time": time, "tutorEmail": tutorEmail, "rated": false, "group_tutoring": group, "uniqid": uniqid, "tutorFN": tutorFN, "tutor_read": false, "student_read": true, "txn_id": "", "uid": uid, "timeCreated":timeCreated, "zoom": currentValue.zoom, "pay_created": false] as [String : Any]
        currStudent.appointments.append(appt)
        
        if currStudent.subjects.contains(subject) != true {
            currStudent.subjects.append(subject)
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currStudent.email)
        docRef.setData(["appointments": currStudent.appointments, "subjects": currStudent.subjects], merge: true) {(error) in
            if error != nil {
                Utils.createAlert(title: "Error Creating Appointment", message: "There was an error creating your appointment. Please try again later", buttonMsg: "Okay", viewController: self)
            }
        }
        currentValue.appointments.append(appt)
        let docRefTut = db.collection("tutors").document(tutorEmail)
        docRefTut.setData(["appointments": currentValue.appointments], merge: true)
        //Updates the appts array for every class this tutor teaches :(
        for item in tempSubjects{
            let docRefClass = db.collection(item).document(tutorEmail)
            docRefClass.setData(["appointments": currentValue.appointments], merge: true) { (error) in
                if error != nil {
                    Utils.createAlert(title: "Error Saving Appointment", message: "There was an error saving your appointment. Please try again later", buttonMsg: "Okay", viewController: self)
                    print(error.debugDescription)
                }
            }
        }
        tempSubjects = []
        
        var maps = [0: "", 1: "", 2: "", 3: "", 4: ""]
        
        var index = 0
        for n in uniqid {
            maps[index / 10] = maps[index / 10]! + String(n)
            index += 1
        }
        print("appt", appt)
        let url = Constants.emailServerURL.appendingPathComponent("tutor-appt-request")
        let params = ["name":appt["tutorFN"], "email": tutorEmail, "class": appt["classname"], "group": appt["group_tutoring"], "time":hoursTime, "date": selectedDate, "acceptUID": maps[0], "rejectUID": maps[1]]
        let jsondata = try? JSONSerialization.data(withJSONObject: params)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsondata
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error occured", error.debugDescription)
            } else {
                print("response", response?.description as Any)
                print("data", data?.description as Any)
            }
        }
        task.resume()
        
        Utils.createAlert(title: "Appointment Created!", message: "Your tutor has been sent your appointment request. If they accept, we'll email you about it! Have fun!", buttonMsg: "Okay", viewController: self)
        
    }
    
    //MARK: Sets up the buttons according to available times for one-on-one and group tutoring
    func timeButtonsSetup() {
        var availableTimes: [Int] = []
        var groupTutoringTimes: [Int] = []
        for button in self.timeButtons {
            button.backgroundColor = UIColor.init(red: 0/255, green: 45/255, blue: 95/255, alpha: 1)
            button.titleLabel?.textColor = UIColor.white
        }
        
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
                                availableTimes = removeFromArray(arr: availableTimes, obj: Int(time)!) //removes the group tutoring times from available times
                            }
                            //Adding the returned times to the list of group tutoring times
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
                                if (i + 1) == availableTimes.count {
                                    break
                                }
                        
                            }
                        }
                    }
                }
            }
            print(availableTimes)
            print(groupTutoringTimes)
                        
            if availableTimes.count == 0 {
                Utils.createAlert(title: "No Available Times", message: "There are no available times for this tutor on this date. Please try another date", buttonMsg: "Okay", viewController: self)
                return
            } else {
                var index = 0
                //Handles one-on-one availabilities
                while index < availableTimes.count {
                    if groupTutoringTimes.contains(availableTimes[index]) {
                        index += 1
                        print("shit happened")
                        continue
                    } else {
                        let button = self.timeButtons[index]
                        let timeDifference = Utils.getUTCTimeDifference()
                        let convertedTime = Utils.convertToLocalTime(timeDifference: timeDifference, time: availableTimes[index])
                        var displayTime = ""
                        if convertedTime == 0 {
                            displayTime = "00:00"
                        } else if convertedTime < 1000 {
                            let hrs = String(convertedTime / 100)
                            let mins = String(convertedTime % 100)
                            if mins == "0" {
                                displayTime = "0" + hrs + ":00"
                                print("idiot 3")
                            } else {
                                displayTime = "0" + hrs + ":" + mins
                            }

                        } else {
                            let hrs = String(convertedTime / 100)
                            let mins = String(convertedTime % 100)
                            if mins == "0" {
                                displayTime = hrs + ":00"
                            } else {
                                displayTime = hrs + ":" + mins
                            }
                        }
                        
                        button.isHidden = false
                        button.tag = availableTimes[index]
                        button.setTitle(String(displayTime), for: .normal)
                        button.layer.cornerRadius = button.frame.height / 2
                        index += 1
                    }
                }
                //Handles group tutoring availabilities
                var group = 0
                while group < groupTutoringTimes.count {
                    let button = self.timeButtons[index]
                    let timeDifference = Utils.getUTCTimeDifference()
                    let convertedTime = Utils.convertToLocalTime(timeDifference: timeDifference, time: groupTutoringTimes[group])
                    var displayTime = ""
                    if convertedTime == 0 {
                        displayTime = "00:00"
                    } else if convertedTime < 1000 {
                        let hrs = String(convertedTime / 100)
                        let mins = String(convertedTime % 100)
                        
                        if mins == "0" {
                            displayTime = hrs + ":00"
                        } else {
                            displayTime = hrs + ":" + mins
                        }
                    } else {
                        let hrs = String(convertedTime / 100)
                        let mins = String(convertedTime % 100)
                        
                        if mins == "0" {
                            displayTime = hrs + ":00"
                        } else {
                            displayTime = hrs + ":" + mins
                        }
                    }
                    print(groupTutoringTimes)
                    
                    button.setTitle(String(displayTime), for: .normal)
                    button.isHidden = false
                    button.layer.cornerRadius = button.frame.height / 2
                    button.backgroundColor = UIColor.orange
                    button.tag = groupTutoringTimes[group]
                    index += 1
                    group += 1
                }
                while index < timeButtons.count {
                    let button = self.timeButtons[index]
                    button.isHidden = true
                    index += 1
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
        
        //timeButtonsSetup()
        
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
