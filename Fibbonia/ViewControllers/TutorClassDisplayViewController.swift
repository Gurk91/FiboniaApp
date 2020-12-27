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
        self.hideKeyboardWhenTappedAround() 
    }
    
    var takenClass: String?

    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var savePriceButton: UIButton!
    @IBOutlet weak var deleteClassButton: UIButton!
    
    func setUp() {
        classNameLabel.text = takenClass
        
        Utils.styleTextField(priceField)
        
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
                .setData(["price": Int(price)!], merge:true)
            createAlert(title: "Price Updated", message: "Your price has been updated!", buttonMsg: "Okay")
        } else {
            createAlert(title: "Empty Values", message: "Enter a valid number for Price", buttonMsg: "Okay")
        }
        
    }
    
    
    func createAlert(title: String, message: String, buttonMsg: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMsg, style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    

}
