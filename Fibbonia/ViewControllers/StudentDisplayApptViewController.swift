//
//  StudentDisplayApptViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 1/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class StudentDisplayApptViewController: UIViewController {
    
    var currAppt: [String: Any] = ["":""]
    
    
    @IBOutlet weak var tutorName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var onlineLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    
    @IBOutlet weak var ApptFinButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        enterParams()
        setUp()
        // Do any additional setup after loading the view.
    }
    
    func setUp() {
        Utils.styleFilledButton(ApptFinButton)
        Utils.styleHollowDeleteButton(cancelButton)
        
    }

    func enterParams() {
        tutorName.text! = currAppt["tutorFN"] as! String
        emailLabel.text! = currAppt["tutorEmail"] as! String
        onlineLabel.text! = currAppt["location"] as! String
        notesLabel.text! = currAppt["notes"] as! String
        timeLabel.text! = currAppt["time"] as! String
        classLabel.text! = currAppt["classname"] as! String
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        deleteNCreateAlert(title: "Cancel Appointment", message: "Are you sure you want to cancel this appointment?")
    }
    
    func deleteNCreateAlert(title: String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete Appointment", style: .default, handler: { (action) in
            var count = 0
            for appt in currStudent.appointments{
                if appt["uid"] as! String == self.currAppt["uid"] as! String {
                    currStudent.appointments.remove(at: count)
                    break
                }
                count += 1
            }
            let db = Firestore.firestore()
            db.collection("users").document(currStudent.email).setData(["appointments": currStudent.appointments], merge: true)
            print("student side appointment deleted")
            db.collection("tutors")
                .document(self.currAppt["tutorEmail"] as! String)
                .getDocument { (document, error) in
                
                // Check for error
                if error == nil {
                    
                    // Check that this document exists
                    if document != nil && document!.exists {
                        
                        let documentData = document!.data()
                        var tutAppts = documentData!["appointments"] as! [[String: Any]]
                        var count = 0
                        for appt in tutAppts{
                            if appt["uid"] as! String == self.currAppt["uid"] as! String {
                                tutAppts.remove(at: count)
                                break
                            }
                            count += 1
                        }
                    db.collection("tutors").document(self.currAppt["tutorEmail"] as! String).setData(["appointments": tutAppts], merge: true)
                    }
                    
                }
                
            }
            
            let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarCont)
            self.view.window?.rootViewController = tabBarController
            self.view.window?.makeKeyAndVisible()
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        self.dismiss(animated: true, completion: nil)
    }))
    self.present(alert, animated: true, completion: nil)
    
    }
    
    @IBAction func completedAction(_ sender: Any) {
        let time = timeLabel.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let date = dateFormatter.date(from: time)
        
        
        createAlert(title: "Not Yet!", message: "This appointment hasn't begun yet. You can complete it and rate your tutor after it has begun", buttonMsg: "Okay")
    }
    
    func createAlert(title: String, message: String, buttonMsg: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMsg, style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }


}
