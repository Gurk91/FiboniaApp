//
//  SelectTutorTableViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 30/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class SelectTutorTableViewController: UITableViewController {

    var data = [Constants.tutorField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tutorCell", for: indexPath) as! TutorSelectionTableViewCell
        cell.nameLabel.text = data[indexPath.row].name
        cell.priceLabel.text = data[indexPath.row].price
        cell.ratingLabel.text = data[indexPath.row].rating

        return cell
    }
    

}
