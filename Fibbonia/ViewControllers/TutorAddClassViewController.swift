//
//  TutorAddClassViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 26/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class TutorAddClassViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet weak var subjectPicker: UIPickerView!
    @IBOutlet weak var classPicker: UIPickerView!
    
    @IBOutlet weak var newClassButton: UIButton!
    
    private var subjects: [String] = [String]()
    private var classes: [String] = [String]()
    
    var selectedSubject: String = ""
    var selectedClass: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.styleFilledButton(newClassButton)
        subjects = Constants.subjects
        classes = Constants.emptyList
        self.classPicker.delegate = self
        self.classPicker.delegate = self
        self.subjectPicker.delegate = self
        self.subjectPicker.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return subjects.count
        } else {
            return classes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return subjects[row]
        } else {
            return classes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedSubject = subjects[row]
            classes = Utils.getClasses(subject: selectedSubject)
            classPicker.selectRow(0, inComponent: 0, animated: true)
            self.classPicker.reloadAllComponents()
        } else {
            selectedClass = classes[row]
        }
        
    }

    @IBAction func newClassPressed(_ sender: Any) {
        let email = "shitit"
        let db = Firestore.firestore()
        let tutorInfo = currTutor.getData()
        var data: [String] = []
        
        db.collection(selectedClass).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    data.append(document.documentID)
                }
                if data.contains(email) {
                    self.createAlert(title: "Class Already Added", message: "Looks like you're already in this class", buttonMsg: "Okay")
                } else {
                    print("FFS")
                     db.collection("CS61B").document(email).setData(["firstName":"firstname", "lastName":"lastname", "uid":"result", "email":"email", "appointments":["dummy":"entryVal"]])
                    self.createAlert(title: "Class Added", message: "You can now teach " + self.selectedClass, buttonMsg: "Okay")
                }
            }
        }
        
        print(self.selectedSubject)
        print(self.selectedClass)
    }
    
    func createAlert(title: String, message: String, buttonMsg: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMsg, style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}

