//
//  StudentTutorDetailViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 1/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class StudentTutorDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Utils.styleFilledButton(appointmentButton)
        
        setTerms()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBOutlet weak var appointmentButton: UIButton!
    
    @IBOutlet weak var tutorName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    //@IBOutlet weak var gpalabel: UILabel!
    //@IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var apptNotes: UITextField!
    
    var currentValue: Constants.tutorField = Constants.tutorField(name: "", rating: "", price: "", onlineID: "", email: "", timings: "", appointments: [] )
    
    var subject: String = ""

    func setTerms() {
        tutorName.text! = currentValue.name
        priceLabel.text! = currentValue.price
        //gpalabel.text! = currentValue.GPA
        //majorLabel.text! = currentValue.major
        timeLabel.text! = currentValue.timings
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func appointmentPressed(_ sender: Any) {
        let time = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let timezone = dateFormatter.timeZone.abbreviation()!
        let inputDate = dateFormatter.string(from: time)
        let uid = UUID().uuidString
        let currAppt = Appointment(tutorEmail: currentValue.email, name: currentValue.name, time: datePicker.date, location: currentValue.onlineID, className: pickedClass, notes: apptNotes.text!, studentName: currName, selfEmail: currEmail, uid: uid, timezone: timezone, subject: subject)
        var dict = currAppt.toDict()
        dict["time"] = inputDate //necessary to change input from Date to String
        //dict["timezone"] = timezone //not necessary as input is already a string
        currStudent.addAppointment(appy: dict)
        let db = Firestore.firestore()
        let appts = currStudent.appointments
        if currStudent.subjects.contains(self.subject) != true {
            currStudent.subjects.append(self.subject)
        }
        let subs = currStudent.subjects
        db.collection("users").document(currStudent.email).setData(["appointments": appts, "subjects": subs], merge: true)
        db.collection("tutors")
            .document(self.currentValue.email)
            .getDocument { (document, error) in
            
            // Check for error
            if error == nil {
                
                // Check that this document exists
                if document != nil && document!.exists {
                    
                    let documentData = document!.data()
                    var tutorappts = documentData!["appointments"] as! [[String: Any]]
                    tutorappts.append(dict)
                    var tutorSubjects = documentData!["subjects"] as! [String]
                    if tutorSubjects.contains(self.subject) != true {
                        tutorSubjects.append(self.subject)
                    }
                    db.collection("tutors").document(self.currentValue.email).setData(["appointments": tutorappts, "subjects": tutorSubjects], merge: true)
                }
            }
        }
        createAlert(title: "Appointment Created!", message: "Your appointment with " + currentValue.name + " has been set", buttonMsg: "Okay")
        
    }
    
    func createAlert(title: String, message: String, buttonMsg: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMsg, style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
