//
//  StudentPreferencesViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 4/Jun/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class StudentPreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.sectionData = [
        0: ["Tutor Languages", "Location Preferences", "Education Level", "Tutor Pricing"],
        1: []]

    }
    
    var sectionData = [Int: [String]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionData[section]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section, indexPath.row) {
            
        case (0,0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "language")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            //print(text)
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "location")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            //print(text)
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (0, 2):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "education")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            //print(text)
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
            return cell
        case (0, 3):
            let cell = tableView.dequeueReusableCell(withIdentifier: "identity") as! MenuCell
            let leftImg = UIImage(named: "pricing")
            let rightImg = UIImage(named: "forwardArrow")
            let text = sectionData[indexPath.section]![indexPath.row]
            //print(text)
            cell.setUp(Rimg: rightImg!, txt: text, Limg: leftImg!)
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(section)
        return [" ", " "][section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
            
        case (0,0):
            performSegue(withIdentifier: "language", sender: self)
            
        case (0, 1):
            performSegue(withIdentifier: "location", sender: self)
            
        case (0, 2):
            performSegue(withIdentifier: "edulvl", sender: self)
            
        case (0, 3):
            performSegue(withIdentifier: "price", sender: self)
            
        default:
            performSegue(withIdentifier: "language", sender: self)
        }
    }
    
    
}
