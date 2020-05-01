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
    @IBOutlet weak var gpalabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var apptNotes: UITextField!
    
    var currentValue: Constants.tutorField = Constants.tutorField(name: "", rating: "", price: "", GPA: "", onlineID: "", major: "", email: "", timings: "", appointments: [] )

    func setTerms() {
        tutorName.text! = currentValue.name
        priceLabel.text! = currentValue.price
        gpalabel.text! = currentValue.GPA
        majorLabel.text! = currentValue.major
        timeLabel.text! = currentValue.timings
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func appointmentPressed(_ sender: Any) {
        let currAppt = Appointment(tutorEmail: currentValue.email, name: currentValue.name, time: datePicker.date, location: currentValue.onlineID, className: pickedClass, notes: apptNotes.text!, studentName: currName, selfEmail: currEmail)
        var dict = currAppt.toDict()
        let time = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let inputDate = dateFormatter.string(from: time)
        dict["time"] = inputDate
        currStudent.addAppointment(appy: dict)
        let db = Firestore.firestore()
        let appts = currStudent.appointments
        db.collection("users").document(currStudent.email).setData(["appointments": appts], merge: true)
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
                    db.collection("tutors").document(self.currentValue.email).setData(["appointments": tutorappts], merge: true)
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
