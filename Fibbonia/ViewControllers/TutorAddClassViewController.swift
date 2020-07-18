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
    
    
    @IBOutlet weak var pricePHfield: UITextField!
    //@IBOutlet weak var availabilityField: UITextField!
    @IBOutlet weak var newClassButton: UIButton!
    
    private var subjects: [String] = [String]()
    private var classes: [String] = [String]()
    
    var selectedSubject: String = ""
    var selectedClass: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        subjects = Constants.pulledSubjects
        classes = Constants.emptyList
        self.classPicker.delegate = self
        self.classPicker.delegate = self
        self.subjectPicker.delegate = self
        self.subjectPicker.delegate = self
    }
    
    func setUp() {
        Utils.styleFilledButton(newClassButton)
        //Utils.styleTextField(availabilityField)
        Utils.styleTextField(pricePHfield)
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
            classes = Constants.pulledClasses[selectedSubject]!
            classPicker.selectRow(0, inComponent: 0, animated: true)
            self.classPicker.reloadAllComponents()
        } else {
            selectedClass = selectedSubject + " " + classes[row]
        }
        
    }

    @IBAction func newClassPressed(_ sender: Any) {
        let email = currTutor.calEmail
        let db = Firestore.firestore()
        let tutorInfo = currTutor.getData()
        let price = pricePHfield.text!
        let times = "a"
        var data: [String] = []
        print(selectedClass)
        do {
            try db.collection(selectedClass).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print("step B")
                    for document in querySnapshot!.documents {
                        data.append(document.documentID)
                    }
                    if data.contains(email) {
                        self.createAlert(title: "Class Already Added", message: "Looks like you're already in this class", buttonMsg: "Okay")
                    } else {
                        print("class added")
                        print(tutorInfo)
                        print(self.selectedClass)
                        print(price)
                        print(times)
                        db.collection(self.selectedClass).document(email).setData(["info":tutorInfo, "price": price, "times": times])
                        print("step 1")
                        currTutor.addClass(clas: self.selectedClass)
                        print(currTutor.classes)
                        self.createAlert(title: "Class Added", message: "You can now teach " + self.selectedClass, buttonMsg: "Okay")
                        db.collection("tutors").document(email).setData(["classes": currTutor.classes], merge: true)
                        print("all through")
                    }
                }
            }
        } catch let error {
            createAlert(title: "Error", message: "Unable to add class. Please try again later", buttonMsg: "Okay")
            print(error)
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

