//
//  NewTutorHomeViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 22/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class NewTutorHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TutUnconfirmedDelegate {
    
    @IBOutlet weak var becomeTutorButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var data = [0: tutorUnconfirmedAppts, 1: tutorConfirmedAppts, 2: []] as [Int: [Any]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setUp()
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        data[0] = tutorUnconfirmedAppts
        data[1] = tutorConfirmedAppts
    }
    
    @IBAction func becomeTutorPressed(_ sender: Any) {
        print("entering student view")
        
        let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarCont)
        self.view.window?.rootViewController = tabBarController
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        signOutNCreateAlert(title: "Sign Out", message: "Are you sure you want to sign out?")
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
    
    func setUp() {
        Utils.styleHollowDeleteButton(signOutButton)
        Utils.styleFilledButton(becomeTutorButton)
    }
    
    //Table Commands
    //MARK: Unconfirmed Appointment Delegate Methods
    func acceptAppointment(appointment: [String : Any]) {
        print("appointment accepted")
        self.showSpinner(onView: self.view)
        
        for i in 0..<currTutor.appointments.count {
            if (currTutor.appointments[i]["uid"] as! String) == (appointment["uid"] as! String) {
                currTutor.appointments[i]["tutor_read"] = true
                break
            }
        }
        
        let db = Firestore.firestore()
        db.collection("tutors").document(currTutor.calEmail).setData(["appointments": currTutor.appointments], merge: true)
        db.collection("users").document(appointment["studentEmail"] as! String).getDocument { (document, error) in
            if error != nil {
                Utils.createAlert(title: "Error Confirming Appointment", message: "There was an unknown error confirming the appointment. Please try again later", buttonMsg: "Okay", viewController: self)
                return
            } else {
                if document != nil && document!.exists {
                    
                    let documentData = document!.data()
                    var studAppts = documentData!["appointments"] as! [[String: Any]]
                    for i in 0..<studAppts.count {
                        if (studAppts[i]["uid"] as! String) == (appointment["uid"] as! String) {
                            studAppts[i]["tutor_read"] = true
                            break
                        }
                    }
                    db.collection("users").document(appointment["studentEmail"] as! String).setData(["appointments": studAppts], merge: true)
                }
            }
        }
        for clas in currTutor.classes {
            db.collection(clas).document(currTutor.calEmail).setData(["appointments": currTutor.appointments], merge: true) { (error) in
                if error != nil {
                    Utils.createAlert(title: "Error Confirming Appointment", message: "There was an unknown error confirming the appointment. Please try again later", buttonMsg: "Okay", viewController: self)
                    return
                }
            }
        }
        tutorConfirmedAppts = []
        tutorUnconfirmedAppts = []
        
        for appt in currTutor.appointments {
            
            if (appt["tutor_read"] as! Bool) == true {
                tutorConfirmedAppts.append(appt)
            } else {
                tutorUnconfirmedAppts.append(appt)
            }
            
        }
        
        Utils.reloadAppointments()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        self.removeSpinner()
        
        Utils.createAlert(title: "Confirmed!", message: "Your appointment is confirmed! You're all set!", buttonMsg: "Okay", viewController: self)
    }
    
    func rejectAppointment(appointment: [String : Any]) {
        print("appointment rejected", appointment)
        //code for sending email about rejected appointment
        self.showSpinner(onView: self.view)
        
        var count = 0
        //tutor side
        for appt in currTutor.appointments {
            if appt["uid"] as! String == appointment["uid"] as! String{
                currTutor.appointments.remove(at: count)
                break
            }
            count += 1
        }
        let db = Firestore.firestore()
        let docRef = db.collection("tutors").document(currTutor.calEmail)
        docRef.setData(["appointments": currTutor.appointments], merge: true)
        
        Utils.reloadAppointments()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
        
        //for each class
        for clas in currTutor.classes {
            let docRef2 = db.collection(clas).document(currTutor.calEmail)
            docRef2.setData(["appointments": currTutor.appointments], merge: true)
        }
        //Student side
        db.collection("users").document(appointment["studentEmail"] as! String).getDocument { (document, error) in
            if error != nil {
                Utils.createAlert(title: "Error Confirming Appointment", message: "There was an unknown error confirming the appointment. Please try again later", buttonMsg: "Okay", viewController: self)
                return
            } else {
                if document != nil && document!.exists {
                    
                    let documentData = document!.data()
                    var studAppts = documentData!["appointments"] as! [[String: Any]]
                    for i in 0..<studAppts.count {
                        if (studAppts[i]["uid"] as! String) == (appointment["uid"] as! String) {
                            studAppts.remove(at: i)
                            break
                        }
                    }
                    db.collection("users").document(appointment["studentEmail"] as! String).setData(["appointments": studAppts], merge: true)
                }
            }
        }
        let url = Constants.emailServerURL.appendingPathComponent("tutor-appt-reject")
        let params = ["name":appointment["studentName"], "time": appointment["time"], "class": appointment["classname"], "email":appointment["studentEmail"]]
        let jsondata = try? JSONSerialization.data(withJSONObject: params)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsondata
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error occured", error.debugDescription)
            } else {
                print("response", response?.description as Any)
                print("data", data?.description as Any)
            }
        }
        task.resume()
        
        
        self.removeSpinner()
        Utils.createAlert(title: "Rejected!", message: "This appointment has been rejected", buttonMsg: "Okay", viewController: self)
    }

    // MARK: - Tableview Code
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch (section) {
            
        case 0:
            return data[0]!.count
        case 1:
            return data[1]!.count
        case 2:
            return 0
        default:
            return 1
        }

    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
            
        case (0):
            let current = data[0]![indexPath.row] as! [String: Any]
            let cell = tableView.dequeueReusableCell(withIdentifier: "UCdisplay") as! TutUnconfirmedTableViewCell
            cell.delegate = self
            if tutorUnconfirmedAppts.count > 0 {
                print("appts is more than 0")
                cell.setVals(input: current)
            }
            return cell
        case (1):
            let current = data[1]![indexPath.row] as! [String: Any]
            let cell = tableView.dequeueReusableCell(withIdentifier: "display") as! TutorAppointmentTableViewCell
            if tutorConfirmedAppts.count > 0 {
                print("appts is more than 0")
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
        
        case (0):
            let current = data[0]![indexPath.row] as! [String: Any]
            performSegue(withIdentifier: "apptDetails", sender: current)
        case (1):
            let current = data[1]![indexPath.row] as! [String: Any]
            performSegue(withIdentifier: "apptDetails", sender: current)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.section) {
        
        case(0):
            return 66
            
        default:
            return 66
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["UNCONFIRMED APPOINTMENTS","CONFIRMED APPOINTMENTS", " "][section]
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
        if segue.identifier == "apptDetails"{
            let destination = segue.destination as! TutStudentDisplayViewController
            destination.currAppt = sender as! [String: Any]
        }
    }
    

}
