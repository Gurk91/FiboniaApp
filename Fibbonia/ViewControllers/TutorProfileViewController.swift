//
//  TutorProfileViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 25/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class TutorProfileViewController: UIViewController {

    
    @IBOutlet weak var gradYearField: UITextField!
    @IBOutlet weak var onlineIDfield: UITextField!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var calEmailLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var saveInfoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        setUp()
        // Do any additional setup after loading the view.
        nameLabel.text! = "Welcome " + currTutor.name + "!"
        calEmailLabel.text! = "Tutor Email: " + currTutor.calEmail
        ratingLabel.text! = "Rating: " + String(currTutor.rating)
        experienceLabel.text! = "Appointments Taught: " + String(currTutor.experience)
    }
    
    func setUp() {

        Utils.styleHollowButton(saveInfoButton)

        Utils.styleTextField(gradYearField)
        Utils.styleTextField(onlineIDfield)
        Utils.styleTextField(bioField)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let db = Firestore.firestore()
        if Utils.validZoomID(zoom: onlineIDfield.text!) == true {
            let online = onlineIDfield.text!
            db.collection("tutors").document(currTutor.calEmail).setData(["zoom": online], merge: true)
            currTutor.zoom = online
            Utils.createAlert(title: "Profile Updated", message: "Your profile was updated", buttonMsg: "Okay", viewController: self)
        }
        if onlineIDfield.text! != "" && Utils.validZoomID(zoom: onlineIDfield.text!) == false {
            Utils.createAlert(title: "Invalid Zoom ID", message: "Please enter a valid https://berkeley.zoom.us Zoom ID", buttonMsg: "Okay", viewController: self)
            return
        }
        if gradYearField.text! != "" {
            db.collection("tutors").document(currTutor.calEmail).setData(["gradyear": Int(gradYearField.text!)!], merge: true)
            currTutor.gradyear = Int(gradYearField.text!)!
            Utils.createAlert(title: "Profile Updated", message: "Your profile was updated", buttonMsg: "Okay", viewController: self)
        }
        if bioField.text! != "" {
            db.collection("tutors").document(currTutor.calEmail).setData(["bio": bioField.text!], merge: true)
            currTutor.bio = bioField.text!
            Utils.createAlert(title: "Profile Updated", message: "Your profile was updated", buttonMsg: "Okay", viewController: self)
        }
        
    }

}
