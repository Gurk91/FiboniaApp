  //
//  HomeScreenViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 16/Mar/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class HomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
                
    }
    


    @IBOutlet weak var saveInfobutton: UIButton!
    
    @IBAction func saveInfoPressed(_ sender: Any) {
        
    }
    
    
    func createAlert(title: String, message: String, buttonMsg: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMsg, style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func setUp() {
        
        Utils.styleHollowButton(saveInfobutton)
    
        
    }
    
    func saveToCoreDate() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: context)
        newUser.setValue(currEmail, forKey: "email")
        newUser.setValue(currName, forKey: "name")
        
        
        do {
            try context.save()
            print("saved")
        } catch  {
            print("error")
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        
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



