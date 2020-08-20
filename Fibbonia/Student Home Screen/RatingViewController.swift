//
//  RatingViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 20/Aug/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class RatingViewController: UIViewController {
    
    var currAppt: [String: Any] = ["":""]
    var exper: Int = 0
    var oldrate: Double = 0.0
    var tutorClasses: [String] = []
    var tutorAppointments: [[String: Any]] = [["":""]]

    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.styleFilledButton(rateButton)
        // Do any additional setup after loading the view.
        currAppt = unratedAppointment
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var tutorName: UILabel!
    
    var rating = 0
    
    @IBOutlet weak var rateButton: UIButton!
    
    @IBOutlet var starButtons: [UIButton]!
    
    @IBAction func starPressed(_ sender: UIButton) {
        var press = sender.tag
        rating = press
        while press >= 0 {
            starButtons[press].setImage(UIImage(named: "filledStar"), for: .normal)
            press -= 1
        }
        
    }
    
    func enterParams() {
        let db = Firestore.firestore()
        db.collection(currAppt["classname"] as! String).document(currAppt["tutorEmail"] as! String).getDocument { (document, error) in
            if error != nil {
                Utils.createAlert(title: "Error", message: "There was an error loading the appointment details. Please try again", buttonMsg: "Okay", viewController: self)
                print(error.debugDescription)
            }
            if document != nil && document!.exists {
                let documentData = document!.data()
                self.oldrate = documentData!["rating"] as! Double
                self.ratingLabel.text! = String(self.oldrate)
                self.priceLabel.text! = documentData!["price"] as! String
                self.exper = documentData!["experience"] as! Int
            }
        }
        tutorName.text! = currAppt["tutorFN"] as! String
        classLabel.text! = currAppt["classname"] as! String
    }
    
    
    @IBAction func ratePressed(_ sender: Any) {
        var count = 0
        for appt in currStudent.appointments{
            if appt["uid"] as! String == self.currAppt["uid"] as! String {
                currStudent.appointments.remove(at: count)
                break
            }
            count += 1
        }
        
        //shitshow begins
        let currSum = (oldrate * Double(exper)) + Double(rating)
        let newRating = currSum / Double(exper + 1)
        exper += 1
        let db = Firestore.firestore()
        let docRef = db.collection("tutors").document(currAppt["tutorEmail"] as! String)

        let apptUID = currAppt["uid"] as! String
        var index = 0
        for appt in tutorAppointments{
            if appt["uid"] as! String == apptUID {
                tutorAppointments.remove(at: index)
                break
            }
            index += 1
        }
        docRef.setData(["experience": exper, "rating": newRating, "appointments": tutorAppointments], merge: true)
        for clas in tutorClasses{
            let docRef2 = db.collection(clas).document(currAppt["tutorEmail"] as! String)
            docRef2.setData(["experience": exper, "rating": newRating, "appointments": tutorAppointments], merge: true)
        }
        Utils.createAlert(title: "Thank You!", message: "We hope you were able to find what you were looking for! Hope to see you again in future!", buttonMsg: "Okay", viewController: self)
        let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarCont)
        self.view.window?.rootViewController = tabBarController
        self.view.window?.makeKeyAndVisible()

    }
    
}
