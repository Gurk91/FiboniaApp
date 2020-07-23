//
//  NewStudentHomeViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 22/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class NewStudentHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //@IBOutlet weak var becomeTutorButton: UIButton!
    //@IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var becomeTutorButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    //@IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tut: Bool = false
    var data = [0: currStudent.subjects, 1: currStudent.appointments, 2: []] as [Int: Any]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        data[1] = currStudent.appointments
        
        tableView.reloadData()
        
        
        if Utils.Connection() == true {
            print("good connection")
            checkTutor()
        } else if currTutorEmail != "" {
            self.becomeTutorButton.setTitle("Go to Tutor View", for: .normal)
            tut = true
        }
        setUp()
        
        if alreadyEntered == false {
            Utils.organizeSubjects()
            Utils.organizeClasses()
            alreadyEntered = true
        }
        
        /*
        if currStudent.preferences["tutorPricing"] as! [Double] == [0, 0] || currStudent.preferences["location"] as! [Bool] == [false, false, false, false]{
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(currEmail)
            docRef.setData(["setPrefs": false], merge: true)
        } else {
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(currEmail)
            docRef.setData(["setPrefs": true], merge: true)
        }
 */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        data[1] = currStudent.appointments
        tableView.reloadData()
    }
    
    
    
    func setUp() {
        Utils.styleHollowDeleteButton(signOutButton)
        Utils.styleFilledButton(becomeTutorButton)
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        signOutNCreateAlert(title: "Sign Out", message: "Are you sure you want to sign out?")
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
                                    
                                    //let gpa = documentData!["GPA"] as! String
                                    let gradyear = documentData!["gradyear"] as! String
                                    let subs = documentData!["subjects"]
                                    
                                    //let tutor = Tutor(name: currName, calEmail: currTutorEmail, GPA: Double(gpa)!, gradYear: Int(gradyear)!, major: documentData!["major"] as! String, subjects: subs as! [String])
                                    let tutor = Tutor(name: currName, calEmail: currTutorEmail, gradyear: Int(gradyear)!, subjects: subs as! [String], phone: documentData!["phone"] as! String, zoom: documentData!["zoom"] as! String, setPrefs: documentData!["setPrefs"] as! Bool, preferences: documentData!["preferences"] as! [String : Any], img: "", firstlogin: documentData!["firstlogin"] as! Bool, prefTime: documentData!["prefTime"] as! [String: [Int]])
                                    let ph = documentData!["phone"] as! String
                                    if documentData!["classes"] == nil {
                                        db.collection("tutors").document(currTutorEmail).setData(["classes": currTutor.classes], merge: true)
                                    } else {
                                        tutor.classes = documentData!["classes"] as! [String]
                                    }
                                    currTutor = tutor
                                    if let appts = documentData?["appointments"] {
                                        currTutor.appointments = appts as! [[String : Any]]
                                        print("got tutor appts")
                                    } else {
                                        currTutor.appointments = []
                                        print("no tutor appts")
                                    }
                        
                                
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
    
    
    //Table Commands

    // MARK: - Tableview Code

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch (section) {
            
        case 0:
            return 1
            
        case 1:
            let step = data[section] as! [[String: String]]
            return step.count
            
        case 2:
            return 0
            
        default:
            return 1
        }
        
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
            
        case (0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "collView", for: indexPath) as! CollectionStudentTableViewCell
            return cell
        case (1):
            let appts = data[indexPath.section] as! [[String: String]]
            let current = appts[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "display") as! AppointmentViewTableViewCell
            if appts.count > 0 {
                cell.setVals(input: current)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section) {
        
        case (1):
            let step1 = data[indexPath.section] as! [[String: String]]
            let current = step1[indexPath.row]
            performSegue(withIdentifier: "apptDisplay", sender: current)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.section) {
        
        case(0):
            print("case 0")
            return 90
            
        case(1):
            print("case 1")
            return 66
            
        default:
            return 66
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(section)
        return ["YOUR RECENT SUBJECTS", "UPCOMING APPOINTMENTS", " "][section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
            headerView.textLabel?.textColor = UIColor.darkGray
            //headerView.frame = CGRect(x: 10, y: 20, width: view.frame.width, height: 60)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "apptDisplay"{
            let destination = segue.destination as! StudentDisplayApptViewController
            destination.currAppt = sender as! [String: Any]
        }
    }
    
    
}

