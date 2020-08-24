//
//  StudentAppointmentsTableViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 1/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class StudentAppointmentsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        data = currStudent.appointments
        tableView.reloadData()
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        data = currStudent.appointments
        tableView.reloadData()
    }
    
    var data = currStudent.appointments

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "display") as! AppointmentViewTableViewCell
        if self.data.count > 0 {
            cell.setVals(input: current)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
