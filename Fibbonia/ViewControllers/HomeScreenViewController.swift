  //
//  HomeScreenViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 16/Mar/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(currName)
        //welcomeLabel.text = "Welcome – " + currName + "!"
        setUp()
        checkTutor()
    }
    

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var becomeTutorButton: UIButton!
    @IBOutlet weak var saveInfobutton: UIButton!
    

    @IBOutlet weak var addline1: UITextField!
    @IBOutlet weak var addline2: UITextField!
    @IBOutlet weak var cityline: UITextField!
    @IBOutlet weak var zipcodeline: UITextField!
    
    var tutor: Bool = false
    
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
        
        if tutor {
            print("already tutor")
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
    
    func checkTutor(){
        let db = Firestore.firestore()
        let docref = db.collection("users").document(currEmail)
        docref.getDocument { (document, error) in
            //checking if tutor already exists
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                print("user exists")
                self.becomeTutorButton.setTitle("Go To Tutor View", for: .normal)
                self.tutor = true
            } else {
                self.becomeTutorButton.setTitle("Become A Tutor!", for: .normal)
            }
        }
    }
    
    
    func setUp() {
        Utils.styleHollowButton(signOutButton)
        Utils.styleFilledButton(becomeTutorButton)
        Utils.styleHollowButton(saveInfobutton)
        
    }
    
        
}

