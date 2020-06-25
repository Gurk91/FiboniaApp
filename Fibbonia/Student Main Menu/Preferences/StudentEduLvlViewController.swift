//
//  StudentEduLvlViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 16/Jun/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class StudentEduLvlViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var educationPickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.educationPickerView.dataSource = self
        self.educationPickerView.delegate = self
        setUp()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUp()
    }
    
    @IBOutlet weak var currentChoice: UILabel!
    
    let pickerData = ["Any","Freshman", "Sophomore", "Junior", "Senior", "Graduate Student", "PhD Candidate"]
    var picked = ""
    var educationLevel = currStudent.preferences["educationLvl"]
    
    
    @IBAction func savePressed(_ sender: Any) {
        if picked == "" {
            createAlert(title: "No Preference Chosen", message: "Please pick a preference before saving", buttonMsg: "Okay")
            return
        }
        
        currStudent.preferences["educationLvl"] = picked
        
        createAlert(title: "Preferences Saved", message: "Your preferences have been saved. Refresh the screen to see your saved choice", buttonMsg: "Okay")
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currEmail)
        let prefs = currStudent.preferences
        docRef.setData(["preferences": prefs], merge: true)
        
        setUp()
    }
    
    func setUp() {
        Utils.styleFilledButton(saveButton)

        currentChoice.text = educationLevel as? String
    }
    
    func createAlert(title: String, message: String, buttonMsg: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMsg, style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        picked = pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    

}
