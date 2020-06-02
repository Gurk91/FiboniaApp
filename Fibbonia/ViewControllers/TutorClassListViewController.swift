//
//  TutorClassListViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 28/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class TutorClassListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        data = currTutor.classes
        tableView.reloadData()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //savetoCoreData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        data = currTutor.classes
        tableView.reloadData()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var data = currTutor.classes
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = data[indexPath.row]
        performSegue(withIdentifier: Constants.Storyboard.tlist2Class, sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Storyboard.tlist2Class{
            let destination = segue.destination as! TutorClassDisplayViewController
            destination.takenClass = sender as? String
        }
    }
    
    func savetoCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entry = NSEntityDescription.insertNewObject(forEntityName: "TutorData", into: context)
        entry.setValue(currTutor.calEmail, forKey: "tutorEmail")
        print("saved: ", currTutor.calEmail)
        let classlist = self.data
        for clas in classlist{
            print("class:", clas)
            entry.setValue(clas, forKey: "classes")
        }
        do {
            try context.save()
            print("saved")
        } catch  {
            print("error")
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TutorData")
        do {
            let results = try context.fetch(request)
            for data in results as! [NSManagedObject] {
                print(data)
            }
        } catch {
            print("data pull fail")
        }
        
    }
    
}


