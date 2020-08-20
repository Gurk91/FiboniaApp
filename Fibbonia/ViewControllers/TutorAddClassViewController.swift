//
//  TutorAddClassViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 26/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

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
        let price = pricePHfield.text!
        var data: [String] = []
        print(selectedClass)
        let db = Firestore.firestore()
        do {
            try db.collection(selectedClass).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    Utils.createAlert(title: "Error", message: "Unable to add class. Please try again later", buttonMsg: "Okay", viewController: self)
                } else {
                    print("step B")
                    for document in querySnapshot!.documents {
                        data.append(document.documentID)
                    }
                    if data.contains(email) {
                        Utils.createAlert(title: "Class Already Added", message: "Looks like you're already in this class", buttonMsg: "Okay", viewController: self)
                        return
                    } else {
                        currTutor.classes.append(self.selectedClass)
                        db.collection(self.selectedClass).document(currTutor.calEmail).setData(["appointments": currTutor.appointments, "verified": false, "classes": currTutor.classes, "calEmail": currTutor.calEmail, "experience":currTutor.experience, "name": currTutor.name, "zoom": currTutor.zoom, "rating": currTutor.rating, "subjects":currTutor.subjects, "price": price, "prefTime": currTutor.prefTime, "bio": currTutor.bio]) { (error) in
                            if error != nil {
                                Utils.createAlert(title: "Error Adding Class", message: "An unknown error occured while adding your class. Please try again later", buttonMsg: "Okay", viewController: self)
                                return
                            }
                            let docRef = db.collection("tutors").document(currTutor.calEmail)
                            docRef.setData(["classes": currTutor.classes], merge: true)
                        }
                        let url = Constants.emailServerURL.appendingPathComponent("confirm-class")
                        let params = ["name":currTutor.name, "email": currTutor.calEmail, "class": self.selectedClass]
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
            }
        }
        print(self.selectedSubject)
        print(self.selectedClass)
    }
    
}

