//
//  StudentDisplayApptViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 1/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class StudentDisplayApptViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var currAppt: [String: Any] = ["":""]
    
    
    @IBOutlet weak var tutorName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    @IBOutlet weak var ApptFinButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        db.collection(currAppt["classname"] as! String).document(currAppt["tutorEmail"] as! String).getDocument { (document, error) in
            if error != nil {
                Utils.createAlert(title: "Error", message: "There was an error loading the appointment details. Please try again", buttonMsg: "Okay", viewController: self)
                print(error.debugDescription)
            }
            if document != nil && document!.exists {
                let documentData = document!.data()
                self.ratingLabel.text! = String(documentData!["rating"] as! Double)
                self.priceLabel.text! = documentData!["price"] as! String
            }
        }
        
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
        notesLabel.text! = "Appointment Notes: " + (currAppt["notes"] as! String)
        classLabel.text! = currAppt["classname"] as! String
        
        let importedTime = currAppt["time"] as! String
        let timecomps = importedTime.components(separatedBy: " ")
        let date = timecomps[0] + " " + timecomps[1] + " " + timecomps[2]
        let timings = timecomps[3..<timecomps.count]
        var finalTimes = ""
        let timedifference = Utils.getUTCTimeDifference()
        for time in timings {
            let converted = Utils.convertToLocalTime(timeDifference: timedifference, time: Int(time)!)
            finalTimes = finalTimes + String(converted) + " "
        }
        timeLabel.text! = date + " " + finalTimes
        
        if (currAppt["tutor_read"] as! Bool) == true {
            statusLabel.text! = "Confirmed"
            statusLabel.textColor = UIColor.green
        } else {
            statusLabel.text! = "Yet To Be Confirmed"
            statusLabel.textColor = UIColor.red
        }
        
    }
    
    @IBAction func zoomButton(_ sender: UIButton) {
        guard let zoomurl = URL(string: currAppt["zoom"] as! String) else {
            Utils.createAlert(title: "Fault Zoom/ Online ID URL", message: "Please contact Fibonia Support and we shall resolve your situation as soon as possible", buttonMsg: "Okay", viewController: self)
            return
        }
        
        let safariViewController = SFSafariViewController(url: zoomurl)
        safariViewController.delegate = self

        present(safariViewController, animated: true, completion: nil)
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        return
    }
    
    
    //MARK: Worry about this when doing Appt. Completion (task 3/4)
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
    
    func createAlert(title: String, message: String, buttonMsg: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMsg, style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }


}
