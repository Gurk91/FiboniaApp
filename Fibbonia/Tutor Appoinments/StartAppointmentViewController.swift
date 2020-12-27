//
//  StartAppointmentViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 18/Aug/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class StartAppointmentViewController: UIViewController {
    
    
    @IBOutlet weak var startButton: UIButton!
    
    var studentAppointments: [[String: Any]] = [["":""]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.styleFilledGreenButton(startButton)
        self.hideKeyboardWhenTappedAround() 

        // Do any additional setup after loading the view.
        let db = Firestore.firestore()
        db.collection("users").document(currAppt["studentEmail"] as! String).getDocument { (document, error) in
            if error != nil {
                Utils.createAlert(title: "Error", message: "There was an error loading the appointment details. Please try again", buttonMsg: "Okay", viewController: self)
                print(error.debugDescription)
            } else {
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    self.studentAppointments = documentData!["appointments"] as! [[String: Any]]
                }
            }
        }
    }
    
    var currAppt: [String: Any] = ["abc":"def"]
    

    @IBAction func startPressed(_ sender: Any) {
        print(currAppt)
        let uniqID = currAppt["uniqid"] as! String
        var maps = [0: "", 1: "", 2: "", 3: "", 4: ""]

        var idiot = 0
        for n in uniqID {
            maps[idiot / 10] = maps[idiot / 10]! + String(n)
            idiot += 1
        }
        
        let url = Constants.emailServerURL.appendingPathComponent("tutor-wants-money")
        let params = ["name": currAppt["studentName"], "email": currAppt["studentEmail"], "payCode": maps[3]]
        let jsondata = try? JSONSerialization.data(withJSONObject: params)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsondata
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error occured", error.debugDescription)
            } else {
                print("data", data?.description as Any)
            }
        }
        task.resume()
        let db = Firestore.firestore()
        let docRef = db.collection("tutors").document(currTutor.calEmail)
        var index = 0
        for i in 0..<currTutor.appointments.count {
            if (currAppt["uid"] as! String) == (currTutor.appointments[i]["uid"] as! String) {
                index = i
                break
            }
        }
        currTutor.appointments[index]["pay_created"] = true
        docRef.setData(["appointments": currTutor.appointments], merge: true)
        var count = 0
        for i in 0..<studentAppointments.count {
            if (currAppt["uid"] as! String) == (studentAppointments[i]["uid"] as! String) {
                count = i
                break
            }
        }
        studentAppointments[count]["pay_created"] = true
        db.collection("users").document(currAppt["studentEmail"] as! String).setData(["appointments": studentAppointments], merge: true)
        
        for clas in currTutor.classes {
            db.collection(clas).document(currTutor.calEmail).setData(["appointments": currTutor.appointments], merge: true)
        }
        Utils.createAlert(title: "Appointment Begun", message: "Your student will join your tutoring session soon! Please ensure that they have paid you, before you begin tutoring.", buttonMsg: "Okay", viewController: self)
        print("FINALLY done")
        
    }
    
}
