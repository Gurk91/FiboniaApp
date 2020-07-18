//
//  TutorClassDisplayViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 28/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class TutorClassDisplayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
    }
    
    var takenClass: String?

    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var savePriceButton: UIButton!
    @IBOutlet weak var timingsField: UITextField!
    @IBOutlet weak var updateTimingsButton: UIButton!
    @IBOutlet weak var deleteClassButton: UIButton!
    
    func setUp() {
        classNameLabel.text = takenClass
        
        Utils.styleTextField(priceField)
        Utils.styleTextField(timingsField)
        
        Utils.styleFilledButton(updateTimingsButton)
        Utils.styleHollowButton(savePriceButton)
        
        Utils.styleHollowDeleteButton(deleteClassButton)
        deleteClassButton.alpha = 0
    }
    
    @IBAction func savePricePressed(_ sender: Any) {
        let db = Firestore.firestore()
        if priceField.text != "" {
            let price = priceField.text!
            db.collection(takenClass!)
                .document(currTutor.calEmail)
                .setData(["price": price], merge:true)
            createAlert(title: "Price Updated", message: "Your price has been updated!", buttonMsg: "Okay")
        } else {
            createAlert(title: "Empty Values", message: "Enter a valid number for Price", buttonMsg: "Okay")
        }
        
    }
    
    @IBAction func updateTimingsPressed(_ sender: Any) {
        let db = Firestore.firestore()
        if timingsField.text != "" {
            let time = timingsField.text!
            db.collection(takenClass!)
                .document(currTutor.calEmail)
                .setData(["times": time], merge:true)
            createAlert(title: "Timings Updated", message: "Your timings have been updated!", buttonMsg: "Okay")
        } else {
            createAlert(title: "Empty Values", message: "Enter a valid time for timing", buttonMsg: "Okay")
        }
    }
    
    /*
    @IBAction func deletePressed(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection(takenClass!)
            .document(currTutor.calEmail).delete()
        createAlert(title: "Class Removed", message: "You would not be teaching this class anymore", buttonMsg: "Okay")
        var index = 0
        for clas in currTutor.classes {
            if clas == takenClass!{
                currTutor.classes.remove(at: index)
            }
            index += 1
        }
        print(currTutor.classes)
    }
 */
    
    func createAlert(title: String, message: String, buttonMsg: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMsg, style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    

}
