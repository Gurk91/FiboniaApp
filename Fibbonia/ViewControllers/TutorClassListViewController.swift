//
//  TutorClassListViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 28/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class TutorClassListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        data = currTutor.classes
    
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var data = currTutor.classes
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("stuff 1")
        print(data)
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("stuff 2")
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        print("stuff 3")
        return cell
    }
    
}


