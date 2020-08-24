//
//  TutorMenuTableVC.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 29/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class TutorMenuTableVC: UITableViewController {

    var sectionData = [Int: [String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.hideKeyboardWhenTappedAround() 
        
        self.sectionData = [
        0: ["Edit Profile", "Student View", "Edit Payment Info", "Edit Tutor Timings"],
        1: ["History", "Stats"],
        2: ["Update/Upload Transcript", "My Classes"],
        3: ["About Fibonia", "Help and Support", "Sign Out"],
        4: []]

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sectionData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sectionData[section]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section, indexPath.row) {
            
        case (0, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "profile")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "student")
            let rightImg = UIImage(named: "forwardArrow")
            let text = "Student View"
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (0, 2):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "payment")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (0, 3):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "time")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (1, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "history")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (1, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "statistics")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (2, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "transcript")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (2, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "classes")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (3, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! Menu2TableViewCell
            let text = sectionData[indexPath.section]![indexPath.row]
            
            cell.setUp(txt: text)
            return cell
        case (3, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! Menu2TableViewCell
            let text = sectionData[indexPath.section]![indexPath.row]
            
            cell.setUp(txt: text)
            return cell
        case (3, 2):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! Menu2TableViewCell
            let text = sectionData[indexPath.section]![indexPath.row]
            
            cell.setUp(txt: text)
            cell.label.textColor = UIColor.red
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "forwardArrow")!
            let rightImg = UIImage(named: "forwardArrow")!
            let text = String(indexPath.section) + " " + String(indexPath.row)
            cell.setUp(Rimg: rightImg, txt: text, Limg: leftImg)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "identity", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = self.sectionData[indexPath.section]![indexPath.row]
        //print("index stuff", indexPath.section, indexPath.row)
        //print("stuff", self.sectionData[indexPath.section]![indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(section)
        return ["PERSONAL INFORMATION", "APPOINTMENTS", "TUTORING", " ", " "][section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
            headerView.textLabel?.textColor = UIColor.darkGray
            //headerView.frame = CGRect(x: 10, y: 20, width: view.frame.width, height: 60)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
            
        case (0, 0):
            performSegue(withIdentifier: "editProfile", sender: self)
            
        case (0, 1):
            let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarCont)
            self.view.window?.rootViewController = tabBarController
            self.view.window?.makeKeyAndVisible()
            
        case (0, 2):
            performSegue(withIdentifier: "payment", sender: self)
            
        case (0, 3):
            performSegue(withIdentifier: "times", sender: self)
            
        case (1, 0):
            performSegue(withIdentifier: "maintenance", sender: self)
            
        case (1, 1):
            performSegue(withIdentifier: "maintenance", sender: self)
            
        case (2, 0):
            performSegue(withIdentifier: "transcript", sender: self)
            
        case (2, 1):
            performSegue(withIdentifier: "classes", sender: self)
            
        case (3, 0):
            performSegue(withIdentifier: "about", sender: self)
            
        case (3, 2):
            signOutNCreateAlert(title: "Sign Out", message: "Are you sure you want to sign out?")
            
        case (3, 1):
            performSegue(withIdentifier: "help", sender: self)
            
        default:
            performSegue(withIdentifier: "maintenance", sender: self)
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

}
