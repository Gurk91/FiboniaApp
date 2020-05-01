//
//  DesperationViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 1/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class DesperationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tutors: [Constants.tutorField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tutors = desperate
        // Do any additional setup after loading the view.
    }
    

}
extension DesperationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutors.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tutor = tutors[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tutorCell") as! TutorSelectionTableViewCell
        cell.setVals(input: tutor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tutor = tutors[indexPath.row]
        performSegue(withIdentifier: "tutorDetails", sender: tutor)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tutorDetails"{
            let destination = segue.destination as! StudentTutorDetailViewController
            destination.currentValue = (sender as? Constants.tutorField)!
        }
    }
}
