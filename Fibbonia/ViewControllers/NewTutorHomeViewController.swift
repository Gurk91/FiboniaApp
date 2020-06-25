//
//  NewTutorHomeViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 22/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class NewTutorHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var becomeTutorButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var data = [0: currTutor.subjects, 1: currTutor.appointments, 2: []] as [Int: Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("tutsubs: ", currTutor.subjects)
        
        tableView.dataSource = self
        tableView.delegate = self
        data[1] = currStudent.appointments
        tableView.reloadData()
        
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        data[1] = currTutor.appointments
        tableView.reloadData()
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
    
    func setUp() {
        Utils.styleHollowDeleteButton(signOutButton)
        Utils.styleFilledButton(becomeTutorButton)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "collView", for: indexPath) as! TutorCollectionTableViewCell
            return cell
        case (1):
            let step1 = data[indexPath.section] as! [[String: String]]
            let current = step1[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "display") as! AppointmentViewTableViewCell
            if self.data.count > 0 {
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
            performSegue(withIdentifier: "apptDetails", sender: current)
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
        if segue.identifier == "apptDetails"{
            let destination = segue.destination as! TutStudentDisplayViewController
            destination.currAppt = sender as! [String: Any]
        }
    }
    

}
