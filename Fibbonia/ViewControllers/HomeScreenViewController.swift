  //
//  HomeScreenViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 16/Mar/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(currName)
        //welcomeLabel.text = "Welcome – " + currName + "!"
        setUp()
        checkTutor()
        states = ["Alabama", "Alaska", "Arizona", "Arkansas",
        "California", "Colorado", "Connecticut", "Delaware",
        "Florida", "Georgia", "Hawaii", "Idaho", "Illinois",
        "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
        "Maine", "Maryland", "Massachusetts", "Michigan",
        "Minnesota", "Mississippi", "Missouri", "Montana",
        "Nebraska", "Nevada", "New Hampshire", "New Jersey",
        "New Mexico", "New York", "North Carolina", "North Dakota",
        "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island",
        "South Carolina", "South Dakota", "Tennessee", "Texas",
        "Utah", "Vermont", "Virginia", "Washington",
        "West Virginia", "Wisconsin", "Wyoming"]
        self.statePickerView.delegate = self
        self.statePickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelecter = states[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    private var states: [String] = [String]()
    var pickerSelecter: String = ""

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var becomeTutorButton: UIButton!
    @IBOutlet weak var saveInfobutton: UIButton!

    @IBOutlet weak var addline1: UITextField!
    @IBOutlet weak var addline2: UITextField!
    @IBOutlet weak var cityline: UITextField!
    @IBOutlet weak var zipcodeline: UITextField!
    
    @IBOutlet weak var statePickerView: UIPickerView!
    
    var tut: Bool = false
    
    @IBAction func signOutPressed(_ sender: Any) {
        signOutNCreateAlert(title: "Sign Out", message: "Are you sure you want to sign out?")
    }
    
    
    @IBAction func saveInfoPressed(_ sender: Any) {
        if addline1.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || addline2.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cityline.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            zipcodeline.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            createAlert(title: "Empty Fields", message: "Please fill out all fields", buttonMsg: "Okay")
            return
        }
        print(pickerSelecter)
        
        let add1 = addline1.text!
        let add2 = addline2.text!
        let city = cityline.text!
        let zip = zipcodeline.text!
        
        let address = add1 + " " + add2
        
        let db = Firestore.firestore()
        db.collection("users").document(currEmail).setData(
            ["address":address,
            "city":city,
            "zip": zip], merge: true)
        
        print("address updated")
    }
    
    
    @IBAction func tutorPressed(_ sender: Any) {
        
        if tut {
            print("already tutor")
            let tutorTBC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tutorHomeVC)
            self.view.window?.rootViewController = tutorTBC
            self.view.window?.makeKeyAndVisible()
            
        } else {
            let tutorVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tutorSignUpVC) as? TutorSignUpViewController
            self.view.window?.rootViewController = tutorVC
            self.view.window?.makeKeyAndVisible()
            
            print("becoming tutor")
        }
        
        
    }
    

    func signOutNCreateAlert(title: String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action) in
            do {
                try Auth.auth().signOut()
                print("signed out")
                currName = ""
                print()
                let viewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
                self.present(viewController!, animated: true, completion: nil)
                //self.view.window?.rootViewController = viewController
                //self.view.window?.makeKeyAndVisible()
                
            } catch let error {
                print("sign out failed", error)
                let alt = UIAlertController(title: "Hmm Something's wrong", message: "Error Signing out", preferredStyle: .alert)
                alt.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
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
    
    
    
    func setUp() {
        Utils.styleHollowButton(signOutButton)
        Utils.styleFilledButton(becomeTutorButton)
        Utils.styleHollowButton(saveInfobutton)
        
    }
    
    func checkTutor() {
        let db = Firestore.firestore()
        db.collection("users")
            .document(currEmail)
            .getDocument { (document, error) in
            // Check for error
            if error == nil {
                // Check that this document exists
                if document != nil && document!.exists {
                    
                    let documentData = document!.data()
                    if documentData!["tutor"] as! Bool == true {
                        self.becomeTutorButton.setTitle("Go to Tutor View", for: .normal)
                        self.tut = true
                    } else {
                        self.becomeTutorButton.setTitle("Become A Tutor!", for: .normal)
                    }
                }
                
            }
            
        }
    }
    
    
        
}



