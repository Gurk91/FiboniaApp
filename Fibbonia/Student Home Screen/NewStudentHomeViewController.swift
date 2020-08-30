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
    
    
    @IBOutlet weak var becomeTutorButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var newAppointmentButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tut: Bool = false
    var data = [0: currStudent.subjects, 1: [], 2: [], 3: []] as [Int: Any]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        Utils.reloadAppointments()
        
        data[1] = studentConfirmedAppts
        data[2] = studentCurrentAppointments
        data[3] = studentUnratedAppointments
        
        tableView.reloadData()
        self.hideKeyboardWhenTappedAround() 
        
        
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
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Utils.reloadAppointments()
        
        data[1] = studentConfirmedAppts
        data[2] = studentCurrentAppointments
        data[3] = studentUnratedAppointments
        tableView.reloadData()
    }
    
    
    
    func setUp() {
        Utils.styleHollowDeleteButton(signOutButton)
        Utils.styleFilledButton(becomeTutorButton)
        Utils.styleFilledButton(newAppointmentButton)
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
            let tutorVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.signUpTutor)
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
                Utils.resetAll()

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
        if currStudent.tutor == true {
            self.becomeTutorButton.setTitle("Go to Tutor View", for: .normal)
            self.tut = true
            
            if switchedTutorBefore == false {
                currTutorEmail = currStudent.calEmail
                let db = Firestore.firestore()
                db.collection("tutors")
                    .document(currTutorEmail)
                    .getDocument { (document, error) in
                    
                    // Check for error
                    if error == nil {
                        
                        // Check that this document exists
                        if document != nil && document!.exists {
                            
                            //Get all tutor data and set to currTutor
                            let documentData = document!.data()
                            
                            let gradyear = documentData!["gradyear"] as! Int
                            let subs = documentData!["subjects"]
                            let zoom = documentData!["zoom"] as! String
                            let setPrefs = documentData!["setPrefs"] as! Bool
                            let preferences = documentData!["preferences"] as! [String : Any]
                            let img = documentData!["img"] as! String
                            let prefTime = documentData!["prefTime"] as! [String: [Int]]
                            let educationLevel = documentData!["educationLevel"] as! String
                            let bio = documentData!["bio"] as! String
                            let stpID = documentData!["stripe_id"] as! String
                            let venID = documentData!["venmo_id"] as! String
                            let venBal = documentData!["venmo_balance"] as! Double
                            
                            let tutor = Tutor(name: currName, calEmail: currTutorEmail, gradyear: gradyear, subjects: subs as! [String], zoom: zoom , setPrefs: setPrefs, preferences: preferences, img: img, firstlogin: false, prefTime: prefTime, educationLevel: educationLevel, bio: bio, stripe_id: stpID, venmo_id: venID, venmo_bal: venBal)
                    
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
                            currTutor.rating = documentData!["rating"] as! Double
                            currTutor.experience = documentData!["experience"] as! Int
                            
                            for appt in currTutor.appointments {
                                
                                if (appt["tutor_read"] as! Bool) == true {
                                    tutorConfirmedAppts.append(appt)
                                } else {
                                    tutorUnconfirmedAppts.append(appt)
                                }
                                
                            }
                
                        
                        }
                    }
                        
                }
                switchedTutorBefore = true
            }
            
        } else {
            self.becomeTutorButton.setTitle("Become A Tutor!", for: .normal)
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
            if currStudent.appointments.count == 0 {
                return 1
            } else {
                let step = data[section] as! [[String: Any]]
                return step.count
            }
            
        case 2:
            let step = data[section] as! [[String: Any]]
            return step.count
    
        case 3:
            let step = data[section] as! [[String: Any]]
            return step.count
            
        default:
            return 1
        }
        
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
            
        case (0):
            if currStudent.subjects.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "noSub")
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "collView", for: indexPath) as! CollectionStudentTableViewCell
                return cell
            }
            
        case (1):
            let appts = data[indexPath.section] as! [[String: Any]]
            print("count", currStudent.appointments.count)
            if currStudent.appointments.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "empty")
                return cell!
            }
            let current = appts[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "display") as! AppointmentViewTableViewCell
            if appts.count > 0 {
                cell.setVals(input: current)
            }
            return cell
        
        case (2):
            let appts = data[indexPath.section] as! [[String: Any]]
            let current = appts[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "startAppt") as! CurrentAppointmentTableViewCell
            if appts.count > 0 {
                cell.setVals(input: current)
            }
            return cell
        case (3):
            let appts = data[indexPath.section] as! [[String: Any]]
            let current = appts[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "unratedAppt") as! UnratedAppointmentTableViewCell
            if appts.count > 0 {
                cell.setVals(input: current)
            }
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "empty")
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section) {
        
        case (1):
            let step1 = data[indexPath.section] as! [[String: Any]]
            let current = step1[indexPath.row]
            performSegue(withIdentifier: "apptDisplay", sender: current)
            
        case (2):
            let step1 = data[indexPath.section] as! [[String: Any]]
            let current = step1[indexPath.row]
            performSegue(withIdentifier: "currentAppt", sender: current)
            
        case (3):
            let step1 = data[indexPath.section] as! [[String: Any]]
            let current = step1[indexPath.row]
            performSegue(withIdentifier: "rateAppt", sender: current)
            
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.section) {
        
        case(0):
            if currStudent.subjects.count == 0 {
                return 66
            } else {
                return 90
            }
                        
        default:
            return 66
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["YOUR RECENT SUBJECTS", "CONFIRMED APPOINTMENTS","CURRENT APPOINTMENTS" , "UNRATED APPOINTMENTS"][section]
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
    
    //MARK: Segue functions
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "apptDisplay"{
            let destination = segue.destination as! StudentDisplayApptViewController
            destination.currAppt = sender as! [String: Any]
        }
        else if segue.identifier == "currentAppt" {
            let destination = segue.destination as! CurrentAppointmentViewController
            destination.currAppt = sender as! [String: Any]
        }
        else if segue.identifier == "rateAppt" {
            let destination = segue.destination as! RatingViewController
            destination.currAppt = sender as! [String: Any]
        }
    }
    
    
}

