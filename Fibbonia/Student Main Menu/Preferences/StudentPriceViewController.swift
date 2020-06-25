//
//  StudentPriceViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 16/Jun/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class StudentPriceViewController: UIViewController {
    
    @IBOutlet weak var minPrice: UITextField!
    @IBOutlet weak var maxPrice: UITextField!
    
    @IBOutlet weak var minDisplay: UILabel!
    @IBOutlet weak var maxDisplay: UILabel!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        prices = currStudent.preferences["tutorPricing"] as! [Double]
        prefs = currStudent.preferences
        setUp()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        prices = currStudent.preferences["tutorPricing"] as! [Double]
        prefs = currStudent.preferences
        setUp()
    }
    
    var prices = currStudent.preferences["tutorPricing"] as! [Double]
    var prefs = currStudent.preferences
    
    
    @IBAction func savePressed(_ sender: Any) {
        let minP = minPrice.text!
        let maxP = maxPrice.text!
        
        if minP == "" || maxP == ""{
            createAlert(title: "Missing Range", message: "Please enter values for both max and min prices", buttonMsg: "Okay")
            return
        }
        let minNum = Double(minP)!
        let maxNum = Double(maxP)!
        
        if minNum >= maxNum {
            createAlert(title: "Invalid Range", message: "The min price must be less than the max price", buttonMsg: "Okay")
            return
        }
        if minNum < 0 || maxNum < 0 {
            createAlert(title: "Invalid Range", message: "Cannot have negative prices", buttonMsg: "Okay")
            return
        }
        
        currStudent.preferences["tutorPricing"] = [minNum, maxNum]
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currEmail)
        prefs["tutorPricing"] = [minNum, maxNum]
        docRef.setData(["preferences": prefs], merge: true)
        
        createAlert(title: "Prices Saved", message: "Your prices have been saved. Refresh the screen to see your saved values", buttonMsg: "Okay")
        
        setUp()
        
    }
    
    func createAlert(title: String, message: String, buttonMsg: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMsg, style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func setUp() {
        Utils.styleFilledButton(saveButton)
        minDisplay.text = String(prices[0])
        maxDisplay.text = String(prices[1])
    }
    
    
    

}
