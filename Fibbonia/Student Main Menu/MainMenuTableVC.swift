//
//  MainMenuTableVC.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 28/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class MainMenuTableVC: UITableViewController {

    var sectionData = [Int: [String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.sectionData = [
        0: ["Edit Payment Info"],
        1: ["Become Tutor", "Tutor Eligibility"],
        2: ["About Fibonia", "Help and Support", "Sign Out"],
        3: []]

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
            let leftImg = UIImage(named: "payment")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            //print(text)
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (1, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "tutor")
            let rightImg = UIImage(named: "forwardArrow")
            var text = ""
            if currTutor.name != "" {
                text = "Go to Tutor View"
            } else {
                text = sectionData[indexPath.section]![indexPath.row]
            }
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (1, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "reportcard")
            let rightImg = UIImage(named: "forwardArrow")
            let text = "Tutor Eligibility"
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (2, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! Menu2TableViewCell
            let text = sectionData[indexPath.section]![indexPath.row]
            //print(text)
            cell.setUp(txt: text)
            return cell
        case (2, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! Menu2TableViewCell
            let text = sectionData[indexPath.section]![indexPath.row]
            //print(text)
            cell.setUp(txt: text)
            return cell
        case (2, 2):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! Menu2TableViewCell
            let text = sectionData[indexPath.section]![indexPath.row]
            //print(text)
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
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //print(section)
        return ["PERSONAL INFORMATION", "TUTORING", " ", " "][section]
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
            performSegue(withIdentifier: "payment", sender: self)
            
        case (1, 0):
            if currTutor.name != "" {
                let tutorTBC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tutorHomeVC)
                self.view.window?.rootViewController = tutorTBC
                self.view.window?.makeKeyAndVisible()
            } else {
                let tutorVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tutorSignUpVC) as? TutorSignUpViewController
                self.view.window?.rootViewController = tutorVC
                self.view.window?.makeKeyAndVisible()
            }
        case (1, 1):
            performSegue(withIdentifier: "tutorSignUp", sender: self)
        
        case (2, 0):
            performSegue(withIdentifier: "about", sender: self)
            
        case (2, 2):
            signOutNCreateAlert(title: "Sign Out", message: "Are you sure you want to sign out?")
            
        case (2, 1):
            performSegue(withIdentifier: "help", sender: self)
            
        default:
            performSegue(withIdentifier: "about", sender: self)

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
