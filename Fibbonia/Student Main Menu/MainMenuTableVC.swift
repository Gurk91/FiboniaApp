//
//  MainMenuTableVC.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 28/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class MainMenuTableVC: UITableViewController {

    var sectionData = [Int: [String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.sectionData = [
        0: ["Edit Profile", "Become Tutor", "Edit Payment Info"],
        1: ["History", "Stats"],
        2: ["Favourite Tutors", "Preferences"],
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
            print(text)
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "tutor")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            print(text)
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (0, 2):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "payment")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            print(text)
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (1, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "history")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            print(text)
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (1, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "statistics")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            print(text)
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (2, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "favourite")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            print(text)
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (2, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "preferences")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            print(text)
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (3, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! Menu2TableViewCell
            let text = sectionData[indexPath.section]![indexPath.row]
            print(text)
            cell.setUp(txt: text)
            return cell
        case (3, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! Menu2TableViewCell
            let text = sectionData[indexPath.section]![indexPath.row]
            print(text)
            cell.setUp(txt: text)
            return cell
        case (3, 2):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! Menu2TableViewCell
            let text = sectionData[indexPath.section]![indexPath.row]
            print(text)
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
        print("stuff", self.sectionData[indexPath.section]![indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(section)
        return ["PERSONAL INFORMATION", "APPOINTMENTS", "TUTORS", " ", " "][section]
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
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
            
        case (0,0):
            let text = String(indexPath.section) + String(indexPath.row)
            performSegue(withIdentifier: "move", sender: text)
        case (0, 1):
            let text = String(indexPath.section) + String(indexPath.row)
            performSegue(withIdentifier: "move", sender: text)
        case (0, 2):
            let text = String(indexPath.section) + String(indexPath.row)
            performSegue(withIdentifier: "move", sender: text)
        case (1, 0):
            let text = String(indexPath.section) + String(indexPath.row)
            performSegue(withIdentifier: "move", sender: text)
        case (1, 1):
            let text = String(indexPath.section) + String(indexPath.row)
            performSegue(withIdentifier: "move", sender: text)
        case (1, 2):
            let text = String(indexPath.section) + String(indexPath.row)
            performSegue(withIdentifier: "move", sender: text)
        case (2, 0):
            let text = String(indexPath.section) + String(indexPath.row)
            performSegue(withIdentifier: "move", sender: text)
        case (2, 1):
            let text = String(indexPath.section) + String(indexPath.row)
            performSegue(withIdentifier: "move", sender: text)
        case (2, 2):
            let text = String(indexPath.section) + String(indexPath.row)
            performSegue(withIdentifier: "move", sender: text)
        case (3, 0):
            let text = String(indexPath.section) + String(indexPath.row)
            performSegue(withIdentifier: "move", sender: text)
        case (4, 0):
            let text = String(indexPath.section) + String(indexPath.row)
            performSegue(withIdentifier: "move", sender: text)
        
        default:
            break
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "move"{
            let destination = segue.destination as! DisplayViewController
            destination.display = sender as? String
        }
    }
 */



}
