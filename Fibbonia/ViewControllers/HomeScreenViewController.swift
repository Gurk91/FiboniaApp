  //
//  HomeScreenViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 16/Mar/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class HomeScreenViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(currName)
        //welcomeLabel.text = "Welcome – " + currName + "!"
        
        
        if Utils.Connection() == true {
            print("good connection")
            checkTutor()
        } else if currTutorEmail != "" {
            self.becomeTutorButton.setTitle("Go to Tutor View", for: .normal)
            tut = true
        }
        
        setUp()
        states = Constants.states
        self.statePickerView.delegate = self
        self.statePickerView.dataSource = self
        self.saveToCoreDate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
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
    
    @IBAction func signOutPressed(_ sender: Any) {
        signOutNCreateAlert(title: "Sign Out", message: "Are you sure you want to sign out?")
    }
    
    
    @IBAction func saveInfoPressed(_ sender: Any) {
        if addline1.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || addline2.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cityline.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            zipcodeline.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        pickerSelecter == ""{
            
            createAlert(title: "Empty Fields", message: "Please fill out all fields", buttonMsg: "Okay")
            return
        }
        let add1 = addline1.text!
        let add2 = addline2.text!
        let city = cityline.text!
        let zip = zipcodeline.text!
        let state = pickerSelecter

        
        let address = add1 + " " + add2
        
        currStudent.setAddress(addr: address, cty: city, ste: state, zp: zip)
        
        let db = Firestore.firestore()
        db.collection("users").document(currEmail).setData(
            ["address":address,
            "city":city,
            "zip": zip, "state": state], merge: true)
        
        print("address updated")
        createAlert(title: "Info Updated!", message: "Your information has been updated", buttonMsg: "Okay")
        return
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
        
        Utils.styleTextField(addline1)
        Utils.styleTextField(addline2)
        Utils.styleTextField(zipcodeline)
        Utils.styleTextField(cityline)
        
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
                    
                    let data = document!.data()
                    if data!["tutor"] as! Bool == true {
                        self.becomeTutorButton.setTitle("Go to Tutor View", for: .normal)
                        self.tut = true
                        currTutorEmail = data!["calEmail"] as! String
                        db.collection("tutors")
                            .document(currTutorEmail)
                            .getDocument { (document, error) in
                            
                            // Check for error
                            if error == nil {
                                
                                // Check that this document exists
                                if document != nil && document!.exists {
                                    
                                    let documentData = document!.data()
                                    
                                    let gpa = documentData!["GPA"] as! String
                                    let gradyear = documentData!["GradYear"] as! String
                                    
                                    let tutor = Tutor(name: currName, calEmail: currTutorEmail, GPA: Double(gpa)!, gradYear: Int(gradyear)!, major: documentData!["major"] as! String)
                                    let ph = documentData!["phone"] as! String
                                    if documentData!["classes"] == nil {
                                        db.collection("tutors").document(currTutorEmail).setData(["classes": currTutor.classes], merge: true)
                                    } else {
                                        tutor.classes = documentData!["classes"] as! [String]
                                    }
                                    currTutor = tutor
                                    //print(currTutor.classes)
                                    currTutor.phone = ph
                                
                                }
                            }
                                
                        }
                    } else {
                        self.becomeTutorButton.setTitle("Become A Tutor!", for: .normal)
                    }
                }
                
            }
            
        }
        
        
    }
    
    func saveToCoreDate() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: context)
        newUser.setValue(currEmail, forKey: "email")
        newUser.setValue(currName, forKey: "name")
        
        
        do {
            try context.save()
            print("saved")
        } catch  {
            print("error")
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        
        do {
            let results = try context.fetch(request)
            for data in results as! [NSManagedObject] {
                print(data)
            }
        } catch {
            print("data pull fail")
        }
        
    }
    
    
    func loadData() {
        for clas in Constants.activeClasses{
            var output: [Constants.tutorField] = []
            let db = Firestore.firestore()
                db.collection(clas)
                    .getDocuments { (snapshot, error) in
                    
                    if error == nil && snapshot != nil {
                        if snapshot!.documents.count > 0 {
                        
                        for document in snapshot!.documents {
                            let documentData = document.data()
                            let info = documentData["info"] as! [String: Any]
                            let name = info["name"] as! String
                            let rating = info["rating"] as! Double
                            let price = documentData["price"] as! String
                            let GPA = info["GPA"] as! Double
                            let online = info["onlineID"] as! String
                            let major = info["Major"] as! String
                            let email = info["email"] as! String
                            let time = documentData["times"] as! String
                            let object = Constants.tutorField(name: name, rating: String(rating), price: price, GPA: String(GPA), onlineID: online, major: major, email: email, timings: time)
                            print(name, rating, price)
                            output.append(object)
                        }
                            Constants.classTutors[clas] = output
                            output = []
                        }
                    }
                }
        }
        
    }
    
    
        
}



