//
//  TutStudentDisplayViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 1/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class TutStudentDisplayViewController: UIViewController {

    var currAppt: [String: Any] = ["":""]
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var onlineLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterParams()
        setUp()
        // Do any additional setup after loading the view.
    }
    
    func setUp() {
        Utils.styleHollowDeleteButton(cancelButton)
        
    }

    func enterParams() {
        studentName.text! = currAppt["studentName"] as! String
        emailLabel.text! = currAppt["studentEmail"] as! String
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
            for appt in currTutor.appointments{
                if appt["notes"] as! String == self.currAppt["notes"] as! String {
                    currTutor.appointments.remove(at: count)
                    break
                }
                count += 1
            }
            let db = Firestore.firestore()
            db.collection("tutors").document(currTutor.calEmail).setData(["appointments": currTutor.appointments], merge: true)
            print("tutor side appointment deleted")
            db.collection("users")
                .document(self.currAppt["studentEmail"] as! String)
                .getDocument { (document, error) in
                
                // Check for error
                if error == nil {
                    
                    // Check that this document exists
                    if document != nil && document!.exists {
                        
                        let documentData = document!.data()
                        var studAppts = documentData!["appointments"] as! [[String: Any]]
                        var count = 0
                        for appt in studAppts{
                            if appt["notes"] as! String == self.currAppt["notes"] as! String {
                                studAppts.remove(at: count)
                                break
                            }
                            count += 1
                        }
                    db.collection("users").document(self.currAppt["studentEmail"] as! String).setData(["appointments": studAppts], merge: true)
                    }
                    
                }
                
            }
            
            let tutorTBC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tutorHomeVC)
            self.view.window?.rootViewController = tutorTBC
            self.view.window?.makeKeyAndVisible()
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        self.dismiss(animated: true, completion: nil)
    }))
    self.present(alert, animated: true, completion: nil)
    
    
    }

}
