//
//  TutApptTableViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 1/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class TutApptTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        data = currTutor.appointments
        //print(data)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        data = currTutor.appointments
        tableView.reloadData()
    }
    
    var data = currTutor.appointments

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.data.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "display") as! TutorAppointmentTableViewCell
        if self.data.count > 1 {
            cell.setVals(input: current)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let current = data[indexPath.row]
        performSegue(withIdentifier: "apptDetails", sender: current)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "apptDetails"{
            let destination = segue.destination as! TutStudentDisplayViewController
            destination.currAppt = sender as! [String: Any]
        }
    }

}
