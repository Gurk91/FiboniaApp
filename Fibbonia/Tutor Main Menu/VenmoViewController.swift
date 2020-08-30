//
//  VenmoViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 26/Aug/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class VenmoViewController: UIViewController {
    
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var venmoLabel: UILabel!
    
    @IBOutlet weak var venmoField: UITextField!
    
    @IBOutlet weak var saveIDButton: UIButton!
    @IBOutlet weak var payoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utils.styleFilledGreenButton(payoutButton)
        Utils.styleFilledButton(saveIDButton)
        self.hideKeyboardWhenTappedAround()
        enterParams()
        
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        if currTutor.stripe_id != "" {
            Utils.createAlert(title: "Stripe Connected", message: "You cannot connect a Venmo account when you already have a Stripe Connect account", buttonMsg: "Okay", viewController: self)
        } else {
            if venmoField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                let venmo = venmoField.text!
                currTutor.venmo_id = venmo
                let db = Firestore.firestore()
                let docRef = db.collection("tutors").document(currTutor.calEmail)
                docRef.setData(["venmo_id": venmo], merge: true)
                Utils.createAlert(title: "Venmo ID Saved", message: "Your Venmo ID has been updated", buttonMsg: "Okay", viewController: self)
            } else {
                Utils.createAlert(title: "No Venmo ID", message: "Please enter your Venmo ID", buttonMsg: "Okay", viewController: self)
            }
        }
    }
    
    func enterParams() {
        self.venmoLabel.text! = "Venmo ID: " + currTutor.venmo_id
        self.balanceLabel.text! = "Payout Balance: $" + String(currTutor.venmo_bal)
    }
    
    @IBAction func payoutPressed(_ sender: Any) {
        let url = Constants.emailServerURL.appendingPathComponent("venmo-payout")
        let params = ["name":currTutor.name, "email": currTutor.calEmail, "venmo":currTutor.venmo_id]
        let jsondata = try? JSONSerialization.data(withJSONObject: params)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsondata
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error occured", error.debugDescription)
            } else {
                print("response", response?.description as Any)
                print("data", data?.description as Any)
            }
        }
        task.resume()
    }
    

}
