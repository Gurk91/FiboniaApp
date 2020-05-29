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
    //@IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tut: Bool = false
    var data = currStudent.appointments
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        data = currStudent.appointments
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
        //nameLabel.text = "Welcome – " + currName + "!"
        
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
        data = currStudent.appointments
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
                                    currTutor.appointments = documentData!["appointments"] as! [[String : Any]]
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
    
    
    //Table Commands

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.data.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "display") as! AppointmentViewTableViewCell
        if self.data.count > 0 {
            cell.setVals(input: current)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let current = data[indexPath.row]
        performSegue(withIdentifier: "apptDisplay", sender: current)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "apptDisplay"{
            let destination = segue.destination as! StudentDisplayApptViewController
            destination.currAppt = sender as! [String: Any]
        }
    }
    

}
